#!/usr/bin/env bash
# setup.sh — Run Supabase migrations for this client's enabled modules.
# Usage: MODULES='booking,newsletter' CLIENT_JSON='/path/to/client.json' ./setup.sh
# Run AFTER: supabase link --project-ref <client-project-ref>

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MIGRATIONS_DIR="$SCRIPT_DIR/migrations"

# ─── Resolve client.json ──────────────────────────────────────────────────────
if [[ -z "${CLIENT_JSON:-}" ]]; then
  CLIENT_JSON="$(dirname "$(dirname "$SCRIPT_DIR")")/frontend/app/client.json"
fi

if [[ ! -f "$CLIENT_JSON" ]]; then
  echo "⚠️  client.json not found at $CLIENT_JSON"
  CLIENT_JSON=""
fi

# ─── Read MODULES from env or client.json ─────────────────────────────────────
if [[ -z "${MODULES:-}" ]]; then
  if [[ -n "$CLIENT_JSON" ]]; then
    MODULES=$(python3 -c "import json; d=json.load(open('$CLIENT_JSON')); print(d.get('MODULES','home,contact,auth'))")
  else
    echo "⚠️  No MODULES env var and no client.json found. Running base migrations only."
    MODULES="home,contact,auth"
  fi
fi

echo "📦 Modules enabled: $MODULES"
echo ""

# ─── Verify project is linked ─────────────────────────────────────────────────
if [[ ! -f "$SCRIPT_DIR/.temp/project-ref" ]]; then
  echo "❌ Supabase project not linked."
  echo "   Run: supabase link --project-ref <ref>  (from $SCRIPT_DIR)"
  exit 1
fi

# ─── Create persistent workdir ────────────────────────────────────────────────
# supabase db execute --file was removed in CLI v2.x. All enabled migrations are
# staged into one temp workdir and pushed in a single 'db push --include-all' call.
# The workdir stays alive through cron scheduling so each subsequent push has the
# full local history and avoids "remote migration versions not found" errors.
WORK_TMP="$(mktemp -d /tmp/supabase_work_XXXXXX)"
mkdir -p "$WORK_TMP/supabase/migrations"
cp -r "$SCRIPT_DIR/.temp" "$WORK_TMP/supabase/.temp"
trap 'rm -rf "$WORK_TMP"' EXIT

# ─── Staging helpers ──────────────────────────────────────────────────────────
stage() {
  local src="$1"
  local name="${2:-$(basename "$src")}"
  [[ -f "$src" ]] && cp "$src" "$WORK_TMP/supabase/migrations/$name"
}

stage_if_enabled() {
  local module="$1"
  local file="$2"
  if [[ ",$MODULES," == *",$module,"* ]]; then
    if [[ -f "$MIGRATIONS_DIR/$file" ]]; then
      echo "  📄 $file (module: $module)"
      stage "$MIGRATIONS_DIR/$file"
    else
      echo "  ⚠️  $file not found — skipping $module"
    fi
  fi
}

stage_always() {
  local file="$1"
  [[ -f "$MIGRATIONS_DIR/$file" ]] && stage "$MIGRATIONS_DIR/$file" && echo "  📄 $file (always)"
}

flag_enabled() {
  [[ -n "$CLIENT_JSON" ]] && \
    [[ "$(python3 -c "import json; d=json.load(open('$CLIENT_JSON')); print(d.get('$1','false'))" 2>/dev/null)" == "true" ]]
}

# ─── Stage migrations ─────────────────────────────────────────────────────────
echo "▶ Staging migrations..."

echo "  📄 000_base.sql"
stage "$MIGRATIONS_DIR/000_base.sql"

echo "  📄 001_auth_hook.sql"
stage "$MIGRATIONS_DIR/001_auth_hook.sql"

# Seed: tokens replaced from client.json, staged with a fixed name (tracked once)
if [[ -n "$CLIENT_JSON" && -f "$MIGRATIONS_DIR/002_seed.sql" ]]; then
  SEED_SQL=$(python3 - "$CLIENT_JSON" "$MIGRATIONS_DIR/002_seed.sql" << 'PYEOF'
import json, sys
c = json.load(open(sys.argv[1]))
sql = open(sys.argv[2]).read()
sql = sql.replace('CLIENT_NAME',     c.get('CLIENT_NAME', 'Client'))
sql = sql.replace('CLIENT_TIMEZONE', c.get('TIMEZONE',    'UTC'))
print(sql)
PYEOF
)
  SEED_TMP="$(mktemp /tmp/raspucat_seed_XXXXXX.sql)"
  echo "$SEED_SQL" > "$SEED_TMP"
  stage "$SEED_TMP" "002_seed.sql"
  rm -f "$SEED_TMP"
  echo "  📄 002_seed.sql (values from client.json)"
fi

stage_if_enabled "booking"      "010_booking.sql"
stage_if_enabled "newsletter"   "020_newsletter.sql"
stage_if_enabled "newsletter"   "021_newsletter_unsubscribe.sql"
stage_if_enabled "testimonials" "030_testimonials.sql"
stage_if_enabled "faq"          "031_faq.sql"
stage_if_enabled "gallery"      "032_gallery.sql"
stage_if_enabled "blog"         "033_blog.sql"

stage_always "040_booking_user_profile.sql"
stage_always "070_deposit.sql"
stage_always "050_content_management.sql"
stage_always "060_reminders_notes.sql"
stage_always "061_pending_booking.sql"

stage_if_enabled "crm" "062_crm.sql"

if flag_enabled "SMS_ENABLED";           then stage_always "071_sms_phone.sql"; fi
if flag_enabled "GIFT_ENABLED";          then stage_always "072_gift_vouchers.sql"; fi
if flag_enabled "INTAKE_ENABLED";        then stage_always "073_intake_forms.sql"; fi
if flag_enabled "LOYALTY_ENABLED";       then stage_always "074_loyalty.sql"; fi
if flag_enabled "WAITLIST_ENABLED";      then stage_always "075_waitlist.sql"; fi
if flag_enabled "PACKAGES_ENABLED";      then stage_always "076_packages.sql"; fi

stage_if_enabled "booking" "077_staff_hours.sql"

if flag_enabled "REVIEWS_ENABLED";       then stage_always "078_reviews.sql"; fi
if flag_enabled "INVOICES_ENABLED";      then stage_always "096_invoice_generation.sql"; fi
if flag_enabled "CLIENT_PHOTOS_ENABLED"; then stage_always "079_client_photos.sql"; fi
if flag_enabled "RECURRING_ENABLED"; then
  stage_always "080_recurring_bookings.sql"
  stage_always "081_recurring_payment.sql"
fi

stage_if_enabled "subscriptions" "082_subscriptions.sql"
stage_if_enabled "referrals"     "083_referrals.sql"
stage_if_enabled "booking"       "084_analytics.sql"
stage_if_enabled "shop"          "085_shop.sql"

if [[ ",$MODULES," == *",shop,"* ]] && [[ ",$MODULES," == *",booking,"* ]]; then
  stage_always "086_shop_analytics.sql"
fi

stage_if_enabled "events" "087_events.sql"
stage_if_enabled "menu"   "097_menu.sql"

if [[ ",$MODULES," == *",testimonials,"* ]] && flag_enabled "REVIEWS_SYNC_ENABLED"; then
  stage_always "098_reviews_sync.sql"
fi
if flag_enabled "LOCATIONS_ENABLED"; then stage_always "099_multi_location.sql"; fi
if flag_enabled "FCM_ENABLED";       then stage_always "100_fcm_tokens.sql"; fi

# ─── Push all staged migrations ───────────────────────────────────────────────
echo ""
echo "▶ Pushing migrations to remote database..."
supabase db push --workdir "$WORK_TMP" --include-all --yes

echo ""
echo "✅ Base schema applied."
echo "✅ business_config and business_hours seeded."
echo "   ⚠️  Register auth hook: Auth → Hooks → Custom Access Token → custom_access_token_hook"
echo ""
echo "🎉 Database setup complete for modules: $MODULES"

# ─── Cron jobs (pg_cron + pg_net — both enabled by default on Supabase) ───────
# Each cron push reuses WORK_TMP (all previously applied migrations are present),
# so the remote history check passes. Only the new cron SQL file gets applied.
if [[ -n "$CLIENT_JSON" ]]; then
  SUPABASE_URL_VAL=$(python3 -c "import json; d=json.load(open('$CLIENT_JSON')); print(d.get('SUPABASE_URL','').rstrip('/'))" 2>/dev/null || echo "")
  SUPABASE_ANON_VAL=$(python3 -c "import json; d=json.load(open('$CLIENT_JSON')); print(d.get('SUPABASE_ANON_KEY',''))" 2>/dev/null || echo "")
  CLIENT_SLUG_VAL=$(python3 -c "import json; d=json.load(open('$CLIENT_JSON')); print(d.get('CLIENT_SLUG',''))" 2>/dev/null || echo "")

  schedule_cron() {
    local name="$1" schedule="$2" fn_path="$3"
    [[ -z "$SUPABASE_URL_VAL" || -z "$SUPABASE_ANON_VAL" ]] && return 1
    local CRON_SQL="
SELECT cron.unschedule(jobname) FROM cron.job WHERE jobname = '${name}';
SELECT cron.schedule(
  '${name}',
  '${schedule}',
  format(
    \$\$SELECT net.http_post(url:=%L,headers:=%L::jsonb,body:=%L::jsonb)\$\$,
    '${SUPABASE_URL_VAL}/functions/v1/${fn_path}',
    '{\"Content-Type\":\"application/json\",\"apikey\":\"${SUPABASE_ANON_VAL}\"}',
    '{}'
  )
);"
    local CRON_TMP CRON_NAME
    CRON_TMP=$(mktemp /tmp/cron_XXXXXX.sql)
    CRON_NAME="cron_${name}_$(date +%Y%m%d%H%M%S).sql"
    echo "$CRON_SQL" > "$CRON_TMP"
    cp "$CRON_TMP" "$WORK_TMP/supabase/migrations/$CRON_NAME"
    rm -f "$CRON_TMP"

    if supabase db push --workdir "$WORK_TMP" --include-all --yes 2>/dev/null; then
      echo "✅ Cron scheduled: $name ($schedule)"
      [[ -n "$CLIENT_SLUG_VAL" ]] && touch "/tmp/.cron_${name}_${CLIENT_SLUG_VAL}" || true
      return 0
    else
      echo "⚠️  Cron scheduling failed for $name — schedule manually in Supabase"
      return 1
    fi
  }

  echo "▶ Scheduling cron jobs..."

  if [[ ",$MODULES," == *",booking,"* ]]; then
    schedule_cron "expire-pending-bookings" "*/10 * * * *" "expire-pending-bookings" || true
    schedule_cron "send-reminders" "0 8 * * *" "send-reminders" || true
  fi

  if [[ ",$MODULES," == *",google_reviews,"* ]]; then
    schedule_cron "send-review-requests" "0 10 * * *" "send-review-requests" || true
  fi
fi
# trap removes WORK_TMP on exit
