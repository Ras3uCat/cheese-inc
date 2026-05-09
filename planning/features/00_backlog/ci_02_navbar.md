# Feature: CI — Navigation Bar
> Status: backlog

## Goal
Add a fixed nav bar that matches the reference: transparent default, blur-on-scroll, 3-column layout, live status dot, hover underline animation.

## Reference: `/home/ryan/Downloads/cheese-inc/js/main.js`

## Files
- `execution/frontend/app/lib/modules/home/views/_nav_bar.dart` (new)
- `execution/frontend/app/lib/modules/home/views/home_view.dart` — wire as Stack overlay

## Tasks
- [ ] Create `_nav_bar.dart` as a `StatefulWidget` with `ScrollController` listener
- [ ] Default state: transparent background, no border
- [ ] Scrolled state (>50px): `BackdropFilter(blur: 12)` + `rgba(13,9,7,0.75)` bg + bottom border 1px cream/0.08; transition 400ms
- [ ] 3-column layout: left=[nav links] | center=[logo] | right=[hours+cart]
- [ ] Logo: Playfair italic 700 — "Cheese & Inc." with `&` in `EColors.primary`
- [ ] Nav links: Space Grotesk uppercase 0.82rem, 0.12em letter-spacing
  - Hover: text → primary + scaleX underline animates from right origin (400ms snap easing)
  - Use `MouseRegion` + `TweenAnimationBuilder` for underline
- [ ] Live status dot: 6×6px `#7FD97F`, pulsing opacity 2s infinite
- [ ] Hours: "OPEN · UNTIL 19:00" mono dim
- [ ] Responsive: <820px → hide links + hours, center logo only
- [ ] Wire into `home_view.dart` as top-level `Stack` overlay (not inside scroll view)

## Acceptance Criteria
- [ ] Nav transparent on hero, blurs on scroll down
- [ ] Logo `&` is orange
- [ ] Hover underlines animate correctly
- [ ] Status dot pulses green
- [ ] Mobile hides links correctly
