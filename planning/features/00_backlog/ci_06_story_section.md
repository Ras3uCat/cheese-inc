# Feature: CI — Story Section (Chapter Three)
> Status: backlog

## Goal
Build the "Story" section: 2-column layout with diagonal-stripe image placeholder on left, biography content with drop-cap lede on right.

## Reference: `/home/ryan/Downloads/cheese-inc/js/story.js`

## Files
- `execution/frontend/app/lib/modules/home/views/sections/story_section.dart` (new)
- `execution/frontend/app/lib/modules/home/views/home_view.dart` — wire after services

## Layout
```
Row (1-col on mobile)
  Left (4:5 aspect):
    - CustomPainter diagonal stripe pattern + dark overlay
    - SVG portrait icon centered
    - Caption bottom: "Fig. 01 — Nora Åkerberg · Head Monger" (mono dim)
    - Border: 1px cream/0.15

  Right:
    - Chapter label: "Chapter Three" (mono primary)
    - Title (word-reveal): "A shop on 6th Ave, *by accident.*"
      - "by accident." = Playfair italic primary
    - Lede: Playfair italic 1.4rem cream; first letter drop cap (3.5rem, Playfair 900, primary)
    - Body: Space Grotesk, on-surface-dim, 1rem, 1.7 line-height, max 50ch
    - Signature row (border-top): "— Nora & Sam" (Playfair italic 1.3rem cream) + metadata mono dim
```

## Background
- `EColors.surface2` with 1px top/bottom borders (cream/0.12)

## Tasks
- [ ] Create `story_section.dart` with `RevealOnScroll` wrapper
- [ ] Left panel: `CustomPainter` for diagonal stripe (45deg, cream/0.05 on surface3 bg)
- [ ] Drop cap: `RichText` with first character styled separately
- [ ] Word-reveal on title using `TextReveal` widget
- [ ] Signature row with `Divider` top border
- [ ] Responsive: 2-col desktop, 1-col mobile (image above content)
- [ ] Wire into `home_view.dart` after `ServicesSection`

## Acceptance Criteria
- [ ] 2-column renders at 1440px, stacks at mobile
- [ ] Drop cap is visible and primary-colored
- [ ] Title word-reveals on scroll
- [ ] Diagonal stripe texture visible on image placeholder
