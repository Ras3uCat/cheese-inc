# Feature: CI — Loading Screen
> Status: completed

## Goal
Rebuild the app loader to exactly match the reference: full-viewport 2×2 corner grid, animated cheese wheel (not just a ring arc), live percentage counter, curtain exit.

## Reference: `/home/ryan/Downloads/cheese-inc/js/loader.js` + `styles/loader.css`

## Visual Layout
```
┌─────────────────────────────────┐
│ EST. 2019        47.2529° N     │
│ TACOMA, WA       122.4443° W    │
│                                 │
│         [CheeseWheel]           │
│       "Cheese & Inc."           │
│   AGING THE COLLECTION · …      │
│                                 │
│ 000%             LOT 014 — 2026 │
└─────────────────────────────────┘
```

## Layer Stack (back → front)
1. `.loader-bg` — full-inset `EColors.surface` fill; fades `opacity 0→ ` over `0.6s ease` on exit
2. Top curtain — `50vh`, slides `translateY(-100%)` on exit
3. Bottom curtain — `50vh`, slides `translateY(100%)` on exit
4. Grid content (corners + center) — fades `opacity 0` over `0.4s` simultaneously with curtains

## Animation Sequence
| t (ms) | Event |
|--------|-------|
| 0      | Loader mounts; body scroll locked |
| 200    | Cheese wheel scales in (0.8→1.0, opacity 0→1, 0.8s ease) |
| 500    | "Cheese & Inc." reveals via letter-spacing 0.2em→normal + fade, 1s `cubic-bezier(0.16,1,0.3,1)` |
| 1000   | Subtitle fades in, 0.6s ease |
| 0–2200 | Progress arc sweeps 0→360° + counter 000→100% with ease-out quint: `1 − (1−t)⁵` |
| 2200   | Animation complete; 400ms hold |
| 2600   | Curtains slide out (1100ms `cubic-bezier(0.76,0,0.24,1)`); grid fades (400ms); `loader-bg` fades (600ms); `onComplete` fires |
| 4000   | Loader widget removed from tree (1400ms after curtain start) |

## Files
- `execution/frontend/app/lib/core/widgets/app_loader.dart` (132 lines → rebuild)

## Tasks
- [x] Replace ring-only center with full `CheeseWheelPainter` (reuse `_cheese_wheel_painter.dart`) at 140×140px
- [x] Cheese wheel entrance: scale 0.8→1.0 + opacity 0→1, `0.8s ease`, `0.2s` delay
- [x] Cheese wheel slow rotation: 20s linear infinite (applied to wheel container, not painter)
- [x] Progress arc: outer ring sweeps 0→360° over 2200ms with ease-out quint easing
- [x] Counter: "000%" animating 0→100 per-frame, same ease-out quint curve as arc
- [x] Center text: "Cheese & Inc." (Playfair italic 700, `clamp(3rem,6vw,5rem)` equiv) — letter-spacing 0.2em→normal + fade, `1s cubic-bezier(0.16,1,0.3,1)`, `0.5s` delay; `&` in `EColors.primary`
- [x] Subtitle: "AGING THE COLLECTION · PLEASE WAIT" (mono dim), fade-in 0.6s ease, 1s delay
- [x] Corner labels (mono dim):
  - Top-left: "EST. 2019" / "TACOMA, WA"
  - Top-right: "47.2529° N" / "122.4443° W"
  - Bottom-right: "LOT 014 — 2026"
- [x] Bottom-left: live "000%" counter
- [x] Layer stack: `loader-bg` (surface fill) + top/bottom curtains (each 50vh) + grid content
- [x] Exit sequence: 400ms hold after 100% → curtains slide out 1100ms + grid fades 400ms + bg fades 600ms
- [x] `onComplete` callback fires when exit begins (for hero/page reveal orchestration)
- [x] Loader widget removed from tree 1400ms after curtain exit starts
- [x] Block scroll (overlay covers interaction) during load; release on exit
- [x] `flutter analyze` — zero errors

## Acceptance Criteria
- [x] Side-by-side with reference: identical layout at all viewport sizes
- [x] Wheel scales in before rotating; rotation starts from rest
- [x] Counter reaches 100% (ease-out quint) before 400ms hold begins
- [x] "Cheese & Inc." letter-spacing animates in, not just fades
- [x] All three exit layers animate simultaneously (curtains + grid fade + bg fade)
- [x] `onComplete` fires before loader is removed, allowing page-level animations to start
- [x] Loader widget fully removed from tree ~4s after mount
- [x] Curtain exit smooth at 1100ms with snap easing
