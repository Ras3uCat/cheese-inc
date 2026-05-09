# Feature: CI — Grain Overlay & Custom Cursor
> Status: backlog

## Goal
Add the grain texture overlay and verify the custom cursor matches the reference: 14px ring default, 46px hot state, primary color, difference blend mode.

## Reference: `styles/tweaks.css` (grain), `/home/ryan/Downloads/cheese-inc/js/cursor.js`

## Files
- `execution/frontend/app/lib/main.dart` — add grain overlay to widget tree
- `execution/frontend/app/lib/core/widgets/cursor_overlay.dart` — verify/fix cursor

## Grain Overlay
- Full-viewport `IgnorePointer` + `CustomPaint` as top-most `Stack` layer in `main.dart`
- `NoisePainter`: fixed seed (42), opacity 0.06, `shouldRepaint: false`
- `BlendMode.overlay` on the `CustomPaint`
- Points per px²: ~0.15 density, 0.5px radius circles

## Custom Cursor (web only — guard with `kIsWeb`)
Reference states:
- Default: 14px ring, 1.5px primary border, `BlendMode.difference`
- Dot: 4px cream, snaps instantly to pointer position
- Hot state: ring expands to 46px, fills primary, on hover of `a`, `button`, `[data-cursor-hot]` equivalent
- Smooth trailing via `ValueNotifier` + `CustomPainter` — never `setState`
- Follow easing factor: 0.18 (interpolate current → target per frame)

## Verify in `cursor_overlay.dart`
- [ ] Ring size: 14px default, 46px hot
- [ ] Border color: `EColors.primary`
- [ ] Blend mode: `BlendMode.difference`
- [ ] Dot: 4px cream, no smoothing (snaps)
- [ ] Uses `ValueNotifier<Offset>` — not `setState`
- [ ] `CustomPainter(repaint: Listenable.merge([positionNotifier, sizeNotifier]))`
- [ ] Hot targets: Flutter `MouseRegion` equivalents wired via inherited widget or `data-cursor-hot` flag approach

## Tasks
- [ ] Create `NoisePainter` (static, fixed seed)
- [ ] Add `IgnorePointer(child: CustomPaint(painter: NoisePainter()))` as top overlay in `main.dart` Stack
- [ ] Audit `cursor_overlay.dart` against spec above
- [ ] Fix any cursor issues (wrong size, setState usage, blend mode)
- [ ] Guard cursor and grain with `kIsWeb` check for native builds

## Acceptance Criteria
- [ ] Subtle grain visible over all sections (don't overpower content)
- [ ] Cursor ring 14px on default areas
- [ ] Cursor expands to 46px on buttons/links
- [ ] No visible lag on cursor movement
