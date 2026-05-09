/// AppEnv — single source of all dart-define values.
/// All values are injected at build time via:
///   flutter build web --dart-define-from-file=client.json
///
/// NEVER call String.fromEnvironment() anywhere else in the codebase.
/// NEVER hardcode fallback brand values — use client.json.example as reference.
class AppEnv {
  AppEnv._();

  // ─── Identity ────────────────────────────────────────────────────────────
  static const clientName = String.fromEnvironment('CLIENT_NAME');
  static const clientSlug = String.fromEnvironment('CLIENT_SLUG');

  // ─── Personality & Layout ────────────────────────────────────────────────
  /// One of: luxury | minimal | bold | warm | corporate | artisan
  static const personality = String.fromEnvironment('PERSONALITY', defaultValue: 'artisan');

  /// One of: fullbleed | split | centered | video_bg | editorial
  static const heroVariant = String.fromEnvironment('HERO_VARIANT', defaultValue: 'editorial');

  /// One of: overlay | sticky | sidebar | minimal
  static const navStyle = String.fromEnvironment('NAV_STYLE', defaultValue: 'sticky');

  /// One of: full | reduced | none
  static const motionIntensity = String.fromEnvironment('MOTION_INTENSITY', defaultValue: 'full');
  static const showLoader = bool.fromEnvironment('SHOW_LOADER', defaultValue: true);

  /// One of: warm-dark | cool-light
  static const palette = String.fromEnvironment('PALETTE', defaultValue: 'warm-dark');

  /// Motion personality dial 0–100. Higher = more dramatic motion.
  static const wesDial = int.fromEnvironment('WES_DIAL', defaultValue: 85);

  /// Comma-separated section order: hero,services,team,testimonials,cta
  static const homeSections = String.fromEnvironment(
    'HOME_SECTIONS',
    defaultValue: 'hero,services,cta',
  );

  // ─── Brand Colors (hex strings without #) ────────────────────────────────
  static const colorPrimary = String.fromEnvironment('COLOR_PRIMARY', defaultValue: 'FF4500');
  static const colorSecondary = String.fromEnvironment('COLOR_SECONDARY', defaultValue: 'D4A853');
  static const colorAccent = String.fromEnvironment('COLOR_ACCENT', defaultValue: 'E8650A');
  static const colorSurface = String.fromEnvironment('COLOR_SURFACE', defaultValue: '0D0907');
  static const colorOnSurface = String.fromEnvironment('COLOR_ON_SURFACE', defaultValue: 'F0E6D0');
  static const colorOnSurfaceDim = String.fromEnvironment(
    'COLOR_ON_SURFACE_DIM',
    defaultValue: 'A89B80',
  );
  static const colorSurface2 = String.fromEnvironment('COLOR_SURFACE_2', defaultValue: '17110C');
  static const colorSurface3 = String.fromEnvironment('COLOR_SURFACE_3', defaultValue: '211812');
  static const colorParchment = String.fromEnvironment('COLOR_PARCHMENT', defaultValue: 'E8D9B5');
  static const colorRind = String.fromEnvironment('COLOR_RIND', defaultValue: '7A4A1F');
  static const colorMold = String.fromEnvironment('COLOR_MOLD', defaultValue: 'B8C4A4');
  static const colorError = String.fromEnvironment('COLOR_ERROR', defaultValue: 'B3261E');

  // ─── Fonts ───────────────────────────────────────────────────────────────
  static const fontPrimary = String.fromEnvironment(
    'FONT_PRIMARY',
    defaultValue: 'Playfair Display',
  );
  static const fontSecondary = String.fromEnvironment(
    'FONT_SECONDARY',
    defaultValue: 'Space Grotesk',
  );
  static const fontMono = String.fromEnvironment('FONT_MONO', defaultValue: 'JetBrains Mono');

  // ─── Locale & Business ───────────────────────────────────────────────────
  static const timezone = String.fromEnvironment('TIMEZONE', defaultValue: 'America/New_York');
  static const stripeMode = String.fromEnvironment('STRIPE_MODE', defaultValue: 'standard');
  static const siteUrl = String.fromEnvironment('SITE_URL', defaultValue: 'http://localhost:8080');

  // ─── Location & Contact (used in SEO / JSON-LD) ──────────────────────────
  static const city = String.fromEnvironment('CITY', defaultValue: '');
  static const state = String.fromEnvironment('STATE', defaultValue: '');
  static const zip = String.fromEnvironment('ZIP', defaultValue: '');
  static const country = String.fromEnvironment('COUNTRY', defaultValue: '');
  static const street = String.fromEnvironment('STREET', defaultValue: '');
  static const phone = String.fromEnvironment('PHONE', defaultValue: '');
  static const gdprEnabled = bool.fromEnvironment('GDPR_ENABLED', defaultValue: false);
  static const googleAuthEnabled = bool.fromEnvironment('GOOGLE_AUTH_ENABLED', defaultValue: false);
  static const appleAuthEnabled = bool.fromEnvironment('APPLE_AUTH_ENABLED', defaultValue: false);

  // ─── Social links (empty = not shown) ────────────────────────────────────
  static const instagramUrl = String.fromEnvironment('INSTAGRAM_URL', defaultValue: '');
  static const facebookUrl = String.fromEnvironment('FACEBOOK_URL', defaultValue: '');
  static const tiktokUrl = String.fromEnvironment('TIKTOK_URL', defaultValue: '');
  static const youtubeUrl = String.fromEnvironment('YOUTUBE_URL', defaultValue: '');

  // ─── Add-on features ─────────────────────────────────────────────────────
  static const smsEnabled = bool.fromEnvironment('SMS_ENABLED', defaultValue: false);
  static const intakeEnabled = bool.fromEnvironment('INTAKE_ENABLED', defaultValue: false);
  static const loyaltyEnabled = bool.fromEnvironment('LOYALTY_ENABLED', defaultValue: false);
  static const giftEnabled = bool.fromEnvironment('GIFT_ENABLED', defaultValue: false);
  static const waitlistEnabled = bool.fromEnvironment('WAITLIST_ENABLED', defaultValue: false);
  static const packagesEnabled = bool.fromEnvironment('PACKAGES_ENABLED', defaultValue: false);
  static const reviewsEnabled = bool.fromEnvironment('REVIEWS_ENABLED', defaultValue: false);
  static const clientPhotosEnabled = bool.fromEnvironment(
    'CLIENT_PHOTOS_ENABLED',
    defaultValue: false,
  );
  static const recurringEnabled = bool.fromEnvironment('RECURRING_ENABLED', defaultValue: false);
  static const coursesEnabled = bool.fromEnvironment('COURSES_ENABLED', defaultValue: false);
  static const tipEnabled = bool.fromEnvironment('TIP_ENABLED', defaultValue: false);
  static const digestEnabled = bool.fromEnvironment('DIGEST_ENABLED', defaultValue: false);
  static const chatbotEnabled = bool.fromEnvironment('CHATBOT_ENABLED', defaultValue: false);
  static const chatbotFull = String.fromEnvironment('CHATBOT_MODE') == 'full';
  static const pushEnabled = bool.fromEnvironment('PUSH_ENABLED', defaultValue: false);
  static const stripeInvoicingEnabled = bool.fromEnvironment(
    'STRIPE_INVOICING_ENABLED',
    defaultValue: false,
  );
  static const invoicesEnabled = bool.fromEnvironment('INVOICES_ENABLED', defaultValue: false);
  static const reviewsSyncEnabled = bool.fromEnvironment(
    'REVIEWS_SYNC_ENABLED',
    defaultValue: false,
  );
  static const locationsEnabled = bool.fromEnvironment('LOCATIONS_ENABLED', defaultValue: false);
  static const fcmEnabled = bool.fromEnvironment('FCM_ENABLED', defaultValue: false);
  static const vapidPublicKey = String.fromEnvironment('VAPID_PUBLIC_KEY');

  // ─── Modules ─────────────────────────────────────────────────────────────
  /// Comma-separated list: home,contact,auth,booking,newsletter,crm
  static const _modulesRaw = String.fromEnvironment('MODULES', defaultValue: 'home,contact,auth');
  static List<String> get modules =>
      _modulesRaw.split(',').map((m) => m.trim()).where((m) => m.isNotEmpty).toList();

  // ─── Credentials (server-adjacent only — publishable/anon keys) ──────────
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const stripePk = String.fromEnvironment('STRIPE_PK');

  // ─── Helpers ─────────────────────────────────────────────────────────────
  /// System modules are always enabled regardless of the MODULES env var.
  static const _systemModules = {'auth', 'admin'};
  static bool moduleEnabled(String id) => _systemModules.contains(id) || modules.contains(id);

  static List<String> get homeSectionList =>
      homeSections.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
}
