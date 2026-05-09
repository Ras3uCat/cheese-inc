# Feature: CI — Testimonials Section (Epilogue)
> Status: backlog

## Goal
Build the testimonials section: 3-column card grid with star ratings, large quote mark, customer quotes, and author attribution.

## Reference: `/home/ryan/Downloads/cheese-inc/js/testimonials.js` + `styles/testimonials.css`

## Files
- `execution/frontend/app/lib/modules/home/views/sections/testimonials_section.dart` (new)
- `execution/frontend/app/lib/modules/home/views/home_view.dart` — wire after club

## Reference Content (3 Testimonials)
1. "The pairing board was the best $68 I've spent on a Tuesday. Nora talked us through each bite like it was a ghost story."
   — Marielle T. · Google 5.0

2. "I was handed a rind to sniff and told 'this one killed the cat, briefly.' Ten out of ten. Have joined the club."
   — D. Ortega · Yelp 5.0

3. "Took the Saturday chèvre workshop for my husband's birthday. He has not stopped talking about it. Please make him stop."
   — K. Lindström · Instagram DM

## Layout
```
Section (surface2 bg, top/bottom borders)
  Header (centered):
    - "Kind Words · Epilogue" (mono primary, centered)
    - Title: "From the *register tape.*" (Playfair 900, step-4, centered)
      - "register tape." = Playfair italic primary

  3-column card grid (1-col mobile):
    Each card:
      - Stars: "★ ★ ★ ★ ★" (primary, 1rem)
      - Large quote mark `"` (Playfair, 3rem, primary, positioned top-left)
      - Quote text: Playfair italic 1.2rem cream, 1.4 line-height
      - Author divider: 1px cream/0.15 top border
      - Name: Playfair italic 1.1rem cream
      - Source: mono small dim, right-aligned
```

## Tasks
- [ ] Create `testimonials_section.dart`
- [ ] `TestimonialCard` widget: `Stack` with `Positioned` quote mark + content
- [ ] Stars row using `Text("★ ★ ★ ★ ★")` in `EColors.primary`
- [ ] `StaggerGroup` wraps all 3 cards (100ms stagger)
- [ ] Centered section header with Playfair italic primary "register tape."
- [ ] 3-col `GridView` desktop, single column mobile
- [ ] Wire into `home_view.dart` after `ClubSection`

## Acceptance Criteria
- [ ] 3 testimonials with correct quotes
- [ ] Large quote mark positioned correctly
- [ ] Stars in primary orange
- [ ] Cards stagger-reveal on scroll
- [ ] Responsive: 1 column on mobile
