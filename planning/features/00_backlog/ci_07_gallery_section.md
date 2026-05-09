# Feature: CI — Gallery Section (Chapter Four)
> Status: backlog

## Goal
Build the draggable horizontal carousel gallery with 8 cheese cards + 1 origin card, physics-based drag inertia, progress bar, and prev/next navigation.

## Reference: `/home/ryan/Downloads/cheese-inc/js/gallery.js` + `styles/gallery.css`

## Files
- `execution/frontend/app/lib/modules/home/views/sections/gallery_section.dart` (new)
- `execution/frontend/app/lib/modules/home/views/sections/_gallery_card.dart` (new)
- `execution/frontend/app/lib/modules/home/views/home_view.dart` — wire after story

## Cards (9 total, origin card at position 3)
1. 01 · Alpage Gruyère · 18 mo · Switzerland
2. 02 · Cave Tomme · 6 mo · Tacoma
3. [ORIGIN CARD — orange bg, "2019", founder quote]
4. 03 · Chèvre Frais · made friday
5. 04 · Stilton Blue · 4 mo · Colston Bassett
6. 05 · Quince & Comté · board N°07
7. 06 · Manchego Viejo · 12 mo · La Mancha
8. 07 · Burrata, Gone Soon · weds only
9. 08 · Rogue River Blue · autumn wrap · OR

## Layout
- Section header: "The *Current* Wheel" + "Drag · Scroll · Click" controls (mono dim)
- Horizontal scrolling track: `GestureDetector` + spring decay physics (inertia)
- Card size: 3:4 aspect, `width: clamp(240–380px)` → `constraints.maxWidth * 0.28` desktop
- Gap: 1rem between cards
- Below track: progress bar (1px, animates width with scroll) + prev/next arrows + hint text

## Card Anatomy (`_gallery_card.dart`)
- Diagonal stripe placeholder bg (CustomPainter, same as story section)
- Hover: `translateY(-6px)`, border → primary (MouseRegion + TweenAnimationBuilder)
- Overlay top-left: number "01" (Playfair italic primary)
- Overlay top-right: tag (mono cream, semi-transparent bg)
- Overlay bottom: dark gradient + title (Playfair italic) + meta (mono dim)

## Origin Card (position 3)
- Background: `EColors.primary`
- Text color: deep `#0D0907`
- Large "2019" (Playfair italic, 5rem, deep)
- Label: "the year we opened" (mono)
- Quote + signature

## Drag Physics
- Use `GestureDetector.onHorizontalDragUpdate` + `onHorizontalDragEnd`
- Apply velocity-based spring decay: `FrictionSimulation` or manual velocity decay
- Never instant snap — always inertia

## Tasks
- [ ] Create `gallery_section.dart` + `_gallery_card.dart`
- [ ] Implement drag + spring physics scroll
- [ ] Build origin card as a special variant
- [ ] Animate progress bar width based on scroll position
- [ ] Prev/next arrow buttons (48×48px, stroke on default, fill on hover)
- [ ] Hover effects on cards (translateY + border change)
- [ ] Responsive: card width scales down on mobile

## Acceptance Criteria
- [ ] Drag inertia feels smooth — no snap to grid
- [ ] Origin card at correct position with orange bg
- [ ] Progress bar tracks scroll position
- [ ] Hover translateY and border change visible
