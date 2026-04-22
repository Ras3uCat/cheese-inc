Analyze inspiration URLs from client.json and produce a Brand Alignment Report.

Load `.claude/skills/client-delivery/SKILL.md` before proceeding.

---

**Step 0 — Version existing report**
Before doing anything else, check if `planning/client/brand_alignment.md` exists.
- If it exists: copy it to `planning/client/brand_alignment_YYYYMMDD.md` (use today's date) before overwriting. Confirm: "Archived previous BAR as brand_alignment_YYYYMMDD.md."
- If it doesn't exist: proceed normally.

---

**Pre-check: Competitor Intel Feed**
Check if `planning/client/competitor_intel.md` exists.
- If it exists: read it now. The top 5 competitor URLs become supplementary inspiration sources (append to your fetch list). The Blueprint findings inform Section B (Layout Patterns) and Section D (Guest Flow). Gaps feed directly into Section E (Conflicts & Gaps).
- If it doesn't exist: proceed normally. Remind the user: run `/comp-intel` first next time for richer analysis.

---

1. Read `execution/frontend/app/client.json`

2. **Parse `BRAND_INSPO_URLS`** — handle both export formats:
   - Correct format: `["https://a.com", "https://b.com"]` → use as-is
   - Legacy format: `["https://a.com https://b.com https://c.com"]` (single space-separated string) → split on spaces to recover individual URLs
   - If the array is empty or the field is missing — stop and tell the user to add inspiration URLs or run `/brand-brief` first.

3. Read the brand brief context fields before fetching any URLs:
   - `BUSINESS_TYPE` — what kind of business (e.g. "artisan cheese shop"). If missing, infer from `CLIENT_NAME` and `BRAND_TARGET_CUSTOMER` and note the inference.
   - `BRAND_THREE_WORDS` — the three words that describe the brand's desired feeling
   - `BRAND_CELEBRITY` — the celebrity whose aesthetic this brand wants to channel
   - `BRAND_TARGET_CUSTOMER` — who the site is for (age, lifestyle, needs)

   **Brief quality check:** If any of these fields still contain obvious scaffold placeholders (e.g. "cheese eaters", "bold", generic single words), flag them in the report under Section E as low-confidence inputs and recommend running `/brand-brief` to enrich them.

   Use these as your interpretive lens throughout the analysis:
   - When URL signals are ambiguous, break ties toward BRAND_THREE_WORDS
   - Ask "does this site feel like [BRAND_CELEBRITY]'s aesthetic?" for each URL — flag contradictions
   - Evaluate every guest flow decision through the eyes of BRAND_TARGET_CUSTOMER

4. Iterate over the parsed URL array. Fetch each URL with WebFetch in parallel.

**Step 4.5: Industry Design Research (ui-ux-pro-max)**
After fetching all URLs but before writing the report:
1. Identify the product/industry type from `BUSINESS_TYPE` and the URL analysis
2. Run: `python3 .claude/skills/ui-ux-pro-max/scripts/search.py "[BUSINESS_TYPE] [BRAND_THREE_WORDS]" --design-system`
3. Cross-reference the recommended palette and font pairing against what the URLs showed — do they align or conflict?
4. If they conflict, surface the discrepancy as a note in Section E (Conflicts & Gaps)
5. If they align, use the industry-validated recommendation to strengthen Section A confidence

5. Analyze each page and produce the Brand Alignment Report with these five sections:

**A. Visual Brand**
Recommended PERSONALITY (with reasoning), COLOR_PRIMARY / COLOR_SECONDARY / COLOR_ACCENT (hex), FONT_PRIMARY / FONT_SECONDARY (Google Fonts names), HERO_VARIANT. Alignment score vs stated PERSONALITY; flag any conflicts.

**B. Layout Patterns (cross-site)**
Common section ordering across all URLs, grid density (sparse / balanced / dense), above-the-fold pattern shared across sites, structural motifs (sticky nav, full-bleed images, card grids). Recommended HOME_SECTIONS order derived from cross-site consensus.

**C. Interactive Elements**
Scroll behavior (parallax, fade-in, sticky — check script tags for AOS, GSAP, Lottie, Framer Motion), hover/micro-interaction patterns, carousels/modals/accordions present (Y/N per site), animation library detected. Recommend Flutter animation vocabulary to match.

**D. Guest Flow**
Hero CTA entry point (Book / Shop / Sign up / Browse), conversion path from homepage to transaction, trust signals shown before CTA, friction removed (guest checkout, inline booking vs redirect). Recommended module sequence and CTA placement for HOME_SECTIONS.

**E. Conflicts & Gaps**
Tension between stated PERSONALITY and extracted signals. Modules selected in client.json that none of the inspiration sites use (potential friction). Modules not selected that appear prominently in inspiration sites (potential miss). Flag any low-quality brand brief inputs that reduced confidence.

---

**Output format:** Markdown report. End with a diff-style summary of recommended changes to client.json fields — only list fields where the recommendation differs from the current value.

**After producing the report:**

**Output A — Save markdown:** Write the full report to `planning/client/brand_alignment.md`.

**Output B — Generate shareable HTML report:** Create `planning/client/brand_alignment_report.html` as a self-contained, print-ready client deliverable. Requirements:
- Inline all CSS — no external CDN or `<link>` tags
- Use COLOR_SURFACE from client.json as page background (fall back to `#0D0907`), COLOR_PRIMARY as accent
- `@media print { .no-print { display: none; } }` for clean PDF export
- `page-break-before: always` before each major section
- Font: system-ui stack only (must work offline)

HTML report structure:
1. **Cover** — Client name, "Brand Alignment Report", date, "Prepared by Raspucat"
2. **Color Palette** — Two rows of swatches: "Current" vs "Recommended". Each swatch: filled circle (40px) + hex value + token name
3. **Typography** — Font name cards showing FONT_PRIMARY and FONT_SECONDARY rendered at display and body sizes using Google Fonts @import
4. **Section Flow** — Horizontal arrow diagram: current HOME_SECTIONS → recommended HOME_SECTIONS
5. **Animation Vocabulary** — Two-column table: Effect | Flutter Widget
6. **Guest Flow** — Numbered funnel: Hero CTA → step 2 → step 3 → conversion
7. **Conflicts & Gaps** — Three-row table: 🔴 Critical | 🟡 Moderate | 🟢 Aligned
8. **Diff Summary** — Styled diff block (red/green rows) of recommended client.json changes

**After saving both files:** Confirm both were written. Tell the user:
> "Brand Alignment Report saved. Open `planning/client/brand_alignment_report.html` in a browser → File → Print → Save as PDF to share with the client. Run `/build` to apply these findings to the Flutter build."
