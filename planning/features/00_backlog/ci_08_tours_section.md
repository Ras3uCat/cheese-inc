# Feature: CI — Tours Section (Chapter Five)
> Status: backlog

## Goal
Build the tours/events listing section: 2-column layout with title + CTA left, schedule list right. Staggered row reveals, hover row highlight, "FULL" strikethrough.

## Reference: `/home/ryan/Downloads/cheese-inc/js/tours.js`

## Files
- `execution/frontend/app/lib/modules/home/views/sections/tours_section.dart` (new)
- `execution/frontend/app/lib/modules/home/views/home_view.dart` — wire after gallery

## Reference Content (6 Tours)
| Day | Name | Time | Duration | Price | Seats |
|-----|------|------|----------|-------|-------|
| WED · Apr 30 | The Aging Cave | 18:00 | 90 min | $45 | 4 left |
| THU · May 1 | Pairings with Sam | 19:00 | 2 hr | $75 | FULL |
| FRI · May 2 | The Aging Cave | 18:00 | 90 min | $45 | 6 left |
| SAT · May 3 | Make Your Own Chèvre | 10:00 | 3 hr | $120 | 2 left |
| SAT · May 3 | The Full Wheel Dinner | 19:30 | 2.5 hr | $160 | 8 left |
| SUN · May 4 | Kids & Cheddar | 11:00 | 60 min | $25 | 12 left |

## Layout
```
Row (1-col mobile)
  Left:
    - Title: "Tours, *Tastings,* & Cave Nights" (word-reveal)
    - Lede: Playfair italic 1.3rem dim
    - "See All Dates" primary button

  Right:
    - Schedule list (StaggerGroup)
    - Each row: 4-col [Day | Title | Meta | Seats]
      - Day: mono dim, min-width 90px
      - Title: Playfair italic 1.6rem cream; hover → primary
      - Meta: mono dim ("18:00 · 90 min · $45")
      - Seats: Playfair italic 1.1rem secondary; "FULL" = dim + strikethrough
    - Row hover: left-padding increases + bg tint (AnimatedContainer 150ms)
```

## Background
- `EColors.surface2` with top/bottom 1px borders

## Tasks
- [ ] Create `tours_section.dart`
- [ ] `TourRow` widget: `MouseRegion` for hover state, `AnimatedContainer` for padding/bg
- [ ] "FULL" seats: `TextDecoration.lineThrough` + dim color
- [ ] `StaggerGroup` wraps all 6 rows (80ms stagger)
- [ ] 2-column desktop, 1-column mobile (left content above list)
- [ ] Wire into `home_view.dart` after `GallerySection`

## Acceptance Criteria
- [ ] 6 tours render with correct data
- [ ] "FULL" rows show strikethrough
- [ ] Hover padding animation visible on rows
- [ ] Staggered reveal fires on scroll
