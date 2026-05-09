# Feature: CI — Services Section Rebuild
> Status: backlog

## Goal
Rebuild the services section header and cards to match the reference: 2-column header, 3-column card grid, correct card anatomy with hover gradient overlay and animated arrow gap.

## Reference: `/home/ryan/Downloads/cheese-inc/js/services.js` + `styles/services.css`

## Files
- `execution/frontend/app/lib/modules/home/views/sections/services_section.dart`
- `execution/frontend/app/lib/modules/home/views/sections/_catalogue_card.dart`

## Reference Content (6 Services)
1. Cut-to-Order Wedges — "from / wedge · $18" — Experience
2. The Pairing Board — "from / two · $68" — Tasting
3. Tour the Aging Cave — "per / guest · $45" — Tour
4. The Monthly Board Box — "per / month · $64" — Subscription
5. Full Wheels — "per / wheel · $180" — Wholesale
6. The Fresh Case — "per / ea. · $9" — Daily

## Section Header
- 2-column layout (not centered OrnamentalHeader)
  - Left: Large title "What we have, *today.*" (Playfair 900, step-4 responsive)
    - "today." in Playfair italic, secondary color
  - Right: Description paragraph (Playfair italic, dim, max 38ch)

## Card Layout (`_catalogue_card.dart`)
- Sharp border: 1px cream/0.12, no radius
- Min-height: 440px
- Header row: Index "01"–"06" (Playfair italic primary, 2.5rem) + category tag (mono dim, right-aligned)
- SVG illustration: 180px height (update from current 100px), hover scales 1.05 + rotate(-2deg)
- Title: Playfair 700, 1.8rem, cream
- Description: Space Grotesk, 0.88rem, dim, 1.5 line-height, 3-line max
- Separator: 1px secondary/0.2 opacity
- Footer row: price left ("from / wedge · $18") + "View →" link right
  - Arrow gap: `AnimatedContainer` 0.4rem → 0.8rem on hover

## Card Hover State
- Border → `EColors.primary`
- Background → `EColors.surface2`
- `LinearGradient` overlay fades in: 160deg, primary/0.09 → secondary/0.04 (0.4s)
- SVG scales 1.05 + rotate(-2deg)

## Tasks
- [ ] Replace section header with 2-column layout
- [ ] Update SVG illustration height to 180px
- [ ] Update title style to Playfair 700 1.8rem
- [ ] Add hover gradient overlay with `AnimatedOpacity`
- [ ] Animate arrow gap with `AnimatedContainer`
- [ ] Populate 6 real service entries
- [ ] Confirm 3-col grid desktop / 1-col mobile

## Acceptance Criteria
- [ ] Header is 2-column, title has italic secondary "today."
- [ ] 6 service cards with correct content
- [ ] Hover triggers border+bg+gradient+svg+arrow changes
- [ ] Grid is 3-column on desktop
