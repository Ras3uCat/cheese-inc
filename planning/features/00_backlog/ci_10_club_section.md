# Feature: CI — Cheese Club Section (Chapter Six)
> Status: backlog

## Goal
Build the high-impact subscription section with solid primary-orange background, monthly box card that rotates on hover, and features grid.

## Reference: `/home/ryan/Downloads/cheese-inc/js/club.js` + `styles/club.css`

## Files
- `execution/frontend/app/lib/modules/home/views/sections/club_section.dart` (new)
- `execution/frontend/app/lib/modules/home/views/home_view.dart` — wire after board

## Layout
```
Full-width section, background: EColors.primary (#FF4500)
All text color: deep (#0D0907)

Row (1-col mobile)
  Left:
    - Chapter label: "Chapter Six" (mono deep, opacity 0.7)
    - Eyebrow: "The Monthly Board Box · Subscriptions ship Apr 03 next" (mono deep, 0.7)
    - Title (word-reveal): "Four cheeses. One *surprise.*" (Playfair 900, step-5, deep)
    - Lede: Playfair italic 1.5rem deep, max 42ch
    - Features 2×2 grid (StaggerGroup):
      Each: dot bullet + feature title (Playfair italic bold deep) + description (Space Grotesk)
    - CTA row: "Join the Club" primary-dark button + price display
      Price: Playfair italic 2rem deep; sub-price: mono small 0.7 opacity

  Right — Box Card (rotates on hover):
    - Background: deep (#0D0907)
    - Text: cream
    - Default transform: rotate(-2deg)
    - Hover: rotate(0deg) + scale(1.02), TweenAnimationBuilder 300ms easeInOutCubic
    - Seal badge: circular 60px, border 1px primary, rotate(12deg), top-right
    - Header: "N° 014 · MONTHLY BOX" (mono dim)
    - Month: "April" (Playfair italic primary, 4rem)
    - Year: "VOL. MMXXVI" (mono cream)
    - 4 items:
      - Bleu de Gex · 80g
      - Tacoma Tomme · 90g
      - Fleur Verte · 70g
      - — wildcard — · ?g
```

## Background Overlays
- Use `Stack` with `CustomPaint` for 2 radial gradient overlays (subtle light + dark at corners)

## Tasks
- [ ] Create `club_section.dart`
- [ ] Solid `EColors.primary` background with radial gradient overlays (CustomPaint in Stack)
- [ ] All text uses deep color (#0D0907)
- [ ] `BoxCard` widget: `TweenAnimationBuilder` for rotation/scale on `MouseRegion` hover
- [ ] Seal badge: `Transform.rotate(radians(12))` + circular border
- [ ] Features 2×2 grid with `StaggerGroup`
- [ ] Word-reveal on title
- [ ] Wire into `home_view.dart` after `BoardSection`

## Acceptance Criteria
- [ ] Section background is solid orange — distinct from everything else on page
- [ ] Box card default rotation (-2deg) visible
- [ ] Hover straightens + scales card smoothly
- [ ] 4 monthly box items render
- [ ] Features grid staggered reveal fires on scroll
