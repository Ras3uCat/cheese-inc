# Feature: CI — Marquee Section Audit & Fix
> Status: backlog

## Goal
Verify (and fix if needed) the marquee strip between hero and services to match the reference: surface-2 background, top/bottom borders, Playfair italic items alternating with orange stars, 40s speed.

## Reference: `/home/ryan/Downloads/cheese-inc/js/marquee.js`

## Files
- `execution/frontend/app/lib/core/widgets/marquee_section.dart` — audit + fix
- `execution/frontend/app/lib/modules/home/views/home_view.dart` — ensure it's wired between hero and services

## Reference Content
Items (cycle): "Aged in cedar · ✦ · Cut to order · ✦ · Small-batch · ✦ · Stored at 54°F · ✦ · Wrapped in beeswax paper · ✦ · Tacoma, WA · ✦ · Est. 2019 · ✦ · Open Wed–Sun"

## Tasks
- [ ] Background: `EColors.surface2` (not `EColors.surface`)
- [ ] Top + bottom borders: 1px `EColors.onSurface.withValues(alpha: 0.12)`
- [ ] Vertical padding: 1.2rem (~19px)
- [ ] Item text: Playfair Display italic, 1.6rem (~26px), `EColors.onSurface`
- [ ] Star dividers: `✦` in `EColors.primary`
- [ ] Animation: 40s linear infinite (no pause, no reverse)
- [ ] Duplicate content list for seamless loop
- [ ] Wire in `home_view.dart` after `HeroFullbleed`, before `ServicesSection`

## Acceptance Criteria
- [ ] Background visually distinct from hero (slightly lighter)
- [ ] Stars orange, text cream
- [ ] Scrolls smoothly with no gap/jump at loop point
- [ ] Wired correctly in page flow
