# Feature: CI — Build-Your-Board Section (Interactive)
> Status: backlog

## Goal
Build the interactive "Build Your Board" section: a live plate canvas on the left where cheese pieces respond to hover, and a 4-step instructions list on the right.

## Reference: `/home/ryan/Downloads/cheese-inc/js/board.js` + `styles/board.css`

## Files
- `execution/frontend/app/lib/modules/home/views/sections/board_section.dart` (new)
- `execution/frontend/app/lib/modules/home/views/home_view.dart` — wire after tours

## Layout
```
Row (1-col mobile)
  Left — Interactive Plate Canvas (square aspect):
    - Background: surface2 with 1px border
    - Center: circular plate (radial gradient, warm cream)
    - 4 cheese pieces positioned around plate (absolute positioned)
      Each piece: hover → scale(1.08) + bg → primary
    - Bottom text: "Honey · Quince · Walnuts" + "$68.00" total (Playfair italic)

  Right:
    - Chapter label: "Build Your Own · Interactive" (mono primary)
    - Title (word-reveal): "Build Your *Board.*"
    - Description: Playfair italic dim
    - 4-step list (StaggerGroup):
      Each step: number (Playfair italic primary 1.6rem) + name (Playfair italic cream 1.4rem)
               + sub-details (mono dim)
      Hover: padding-left increases + title → primary
    - "Start Building" primary button
```

## 4 Steps
1. Choose four cheeses — soft · semi-firm · aged · strange
2. Add two cures — prosciutto, saucisson, bresaola
3. Three accoutrements — honey, jam, nuts, pickles, the strange one
4. A loaf & a bottle — sourdough · crackers · natural wine

## Plate Canvas
- Use `CustomPaint` for the plate circle (radial gradient: cream center, tan edge)
- 4 cheese piece widgets: `Positioned` around plate center
- `MouseRegion` on each piece: `TweenAnimationBuilder` scale + color change (150ms)

## Tasks
- [ ] Create `board_section.dart`
- [ ] `BoardCanvas` widget: `Stack` with `CustomPaint` plate + 4 `Positioned` cheese pieces
- [ ] Cheese piece hover: scale 1.08 + bg → primary (TweenAnimationBuilder)
- [ ] Step list: `StaggerGroup` with 80ms interval
- [ ] Step hover: `AnimatedContainer` for left padding + `AnimatedDefaultTextStyle` for title color
- [ ] Responsive: plate above steps on mobile
- [ ] Wire into `home_view.dart` after `ToursSection`

## Acceptance Criteria
- [ ] Plate canvas renders with circular plate
- [ ] Cheese pieces scale on hover and turn orange
- [ ] 4 steps visible with staggered reveal
- [ ] "Build Your Board" word-reveal fires on scroll
