# Feature: CI — Footer Rebuild
> Status: backlog

## Goal
Rebuild the footer to match the reference: mega heading, 4-column link grid, newsletter form, coordinates, legal row.

## Reference: `/home/ryan/Downloads/cheese-inc/js/footer.js`

## Files
- `execution/frontend/app/lib/modules/home/views/_home_footer.dart` (new — extract from home_view.dart)
- `execution/frontend/app/lib/modules/home/views/home_view.dart` — replace inline footer

## Layout
```
Footer (background: deep #0D0907)

Mega heading:
  "Come by. *Smell things.*" (Playfair 900, step-5, cream)
  "*Smell things.*" = Playfair italic primary

4-column grid (2-col tablet, 1-col mobile):
  Col 1 — The Shop:
    - Address (Playfair italic 1.4rem cream, 1.4 line-height)
    - "Open Wed–Sun · 11–19" (mono dim)
    - Newsletter form:
      - Email input: transparent bg, cream text, mono font, 1px cream/0.2 bottom border
      - Subscribe button: primary bg, deep text, mono font; hover → cream bg

  Col 2 — Shop links:
    H4: mono dim header
    Links: The Case, Pairing Boards, Full Wheels, Accoutrements, Gift Cards
    Link hover: → primary + left padding increase

  Col 3 — Learn links:
    H4: mono dim header
    Links: Tours, Workshops, The Cheese Club, Our Story, Journal

  Col 4 — Elsewhere links:
    H4: mono dim header
    Links: Instagram, TikTok, Substack, Google, hello@cheese.inc

Bottom row:
  Left: "© 2026 Cheese Inc. · Tacoma, WA" (mono dim)
  Center: "47.2529° N, 122.4443° W" (Playfair italic cream)
  Right: Privacy · Terms · Accessibility (mono dim, hover → primary)
```

## Tasks
- [ ] Create `_home_footer.dart` (extract from home_view.dart footer)
- [ ] Mega heading with `TextSpan` for italic primary portion
- [ ] 4-column grid using `Wrap` or `GridView`
- [ ] Newsletter `TextField` with transparent style + primary bottom border focus
- [ ] Link list widget reused across all 3 link columns
- [ ] Link hover: `AnimatedPadding` + color change via `MouseRegion`
- [ ] Bottom row 3-column with coordinates in Playfair italic
- [ ] Responsive: 4→2→1 column at breakpoints

## Acceptance Criteria
- [ ] Mega heading renders "Smell things." in italic orange
- [ ] 4 columns visible at 1440px, 2 at tablet, 1 at mobile
- [ ] Newsletter input has correct styling (no box, just bottom border)
- [ ] Links hover to orange
- [ ] Coordinates in Playfair italic at bottom
