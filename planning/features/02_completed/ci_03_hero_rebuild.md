# Feature: CI — Hero Section Rebuild
> Status: completed

## Goal
Rebuild the hero section to exactly match the reference: inset frame border, 3-column meta header, word-reveal title with italic secondary-color "Collection", 3-column footer with dual CTAs and animated scroll indicator, hero badges.

## Reference
- `js/hero.js` + `styles/hero.css` — hero layout, wheel, specks, animations
- `index.html` — global tokens, reveal system, cursor, button styles
- `js/reveal.js` — reveal easing spec
- `js/marquee.js` — marquee content

## Current State
`hero_fullbleed.dart` has wheel (right-aligned) + specks (inside rotation — bug) + gradient overlay + overline pill + title + tagline + CTA. Missing frame, meta, 3-col footer, badges. `_hero_centered.dart` and `_hero_split.dart` are personality variants exported from the file. Content Column is wrapped in `Transform.translate(scrollPx * 0.12)` — this parallax on text does not exist in the reference and must be removed.

## Files to Modify / Create
- `hero_fullbleed.dart` — full restructure; remove `_OverlinePill`, `_PulsingScrollIndicator`; delete `_hero_cta.dart` reference
- `_hero_meta.dart` (new)
- `_hero_title.dart` (new)
- `_hero_tag.dart` (new)
- `_hero_foot.dart` (new) — contains `_HeroDesc`, `_HeroCtaStack`, `_HeroScroll`
- `_hero_badges.dart` (new)
- `_wheel_layer.dart` — fix centering, fix specks extraction, add size constraint
- `_specks_painter.dart` — rewrite as static painter, fix count/size/colors, extract from rotation group
- `_cheese_wheel_painter.dart` — fidelity pass (see WheelPainter task)
- `_hero_cta.dart` — keep unchanged (still used by `_hero_centered.dart` and `_hero_split.dart`)

## Layout Structure
```
Stack
  └── AmbientHeroBackground (keep — grain/gradient drift)
  └── SpecksPainter — SEPARATE from WheelLayer, NOT inside rotation group
  └── WheelLayer (centered, see fix below)
  └── Gradient overlay (keep existing)
  └── Positioned.fill(margin: all framePad) > IgnorePointer > DecoratedBox(1px cream/0.12)
        [frame is its own Stack layer — does NOT wrap the Column]
  └── SafeArea > Padding > Column
        A. _HeroMeta (3-col: Chapter/Vol/Location)
        B. Spacer
        C. _HeroTitle (word-reveal, "Taste the Collection")
        D. _HeroTag ([hr] "An Artisanal Catalogue · Volume XIV" [hr])
        E. Spacer
        F. _HeroFoot (3-col: description | CTAs | scroll indicator)
  └── _HeroBadges (Positioned bottom-left, 3 awards)
```

## Tasks

### Design token fixes (EColors / ESpacing)
- [x] `EColors.cream` does not exist — everywhere the plan says `EColors.cream` use `EColors.onSurface` (maps to `#F0E6D0`). Do NOT hardcode hex.
- [x] `EColors.gold` does not exist — wheel painter tasks that reference it should use `EColors.secondary` (maps to `#D4A853`).
- [x] `ESpacing.framePad` and `ESpacing.frameSmall` do not exist. Add to `e_spacing.dart`:
  - `static const double framePad = 20.0;` (≈ 1.25rem)
  - `static const double frameSmall = 10.0;` (≈ 0.6rem mobile)

### Cleanup — existing widgets replaced by this rebuild
- [x] Remove `_OverlinePill` class from `hero_fullbleed.dart` (replaced by `_HeroMeta`)
- [x] Remove `_PulsingScrollIndicator` class from `hero_fullbleed.dart` (replaced by `_HeroScroll`)
- [x] Remove the `Transform.translate(offset: Offset(0, scrollPx * 0.12))` wrapper around the content Column — text should NOT parallax on scroll (reference: only the wheel moves)
- [x] **Do NOT delete `_hero_cta.dart`** — both `_hero_centered.dart` (line 10) and `_hero_split.dart` (line 10) import it. Deleting it breaks the build. `HeroCta` stays in `_hero_cta.dart` for those variants. `_HeroCtaStack` in `_hero_foot.dart` is a new, separate implementation for the fullbleed layout only.
- [x] `_hero_centered.dart` and `_hero_split.dart` — keep. They are valid `AppEnv.heroVariant` routes (`'split'`, `'centered'`) in `home_view.dart`. Do not delete or remove exports.

### Frame
- [x] Frame: `Positioned.fill` with `margin: EdgeInsets.all(ESpacing.framePad)` + `IgnorePointer` + `DecoratedBox(border: Border.all(color: EColors.onSurface.withValues(alpha: 0.12)))`. Must NOT wrap the content Column — it's a separate layer in the Stack.
- [x] Mobile (≤600px): frame margin shrinks to `EdgeInsets.all(ESpacing.frameSmall)` (0.6rem equiv)

### _HeroMeta
- [x] 3-col `Row` with `MainAxisAlignment.spaceBetween`. Padding-top: 32px (2rem — no exact ESpacing token; use `SizedBox(height: 32)` or add `ESpacing.gapMeta = 32.0` to `e_spacing.dart`).
- [x] Each column is a `Column(mainAxisSize: MainAxisSize.min, gap: 5)` (0.3rem ≈ 5px) of: label `Text` + value `Text`.
- [x] Label: JetBrains Mono, 0.62rem, `letter-spacing: 0.3em`, `EColors.onSurfaceDim.withValues(alpha: 0.5)`.
- [x] Value: Playfair Display italic, 1.1rem, `EColors.onSurface` (NOT onSurfaceDim — this was wrong in earlier versions).
- [x] Column content — left: "Chapter One" / "The Collection"; center (`TextAlign.center`): "Volume" / "MMXXVI · N°014"; right (`TextAlign.right`): "Filed From" / "Tacoma, WA".
- [x] Stagger reveal triggers after `loaderDone`. Delay per child: col-1 = 50ms, col-2 = 150ms, col-3 = 250ms.
- [x] Mobile: collapse to 2-column (drop center column — show left and right only).

### _HeroTitle
- [x] Word-split "Taste the Collection" into individual word spans
- [x] **Content note**: `HomeController.heroTitle` currently defaults to `'TASTE THE COLLECTION'` (all-caps). Either: (a) store `"Taste the Collection"` in `business_config.hero_title` in Supabase, OR (b) `_HeroTitle` applies `.toLowerCase()` then `.split(' ')` and re-capitalizes the display. Do not rely on the all-caps default — word-casing must match reference exactly.
- [x] Each word: `ClipRect` wrapping `SlideTransition` (translateY 110% → 0). Stagger: 40ms per word. Reveal triggers after loader-done.
- [x] Easing: `cubic-bezier(0.16, 1, 0.3, 1)` equivalent — use `Cubic(0.16, 1.0, 0.3, 1.0)` in Flutter. Duration: 1.1s per word.
- [x] Wrap the entire title in `Padding(padding: EdgeInsets.symmetric(vertical: 32))` (2rem top + bottom — reference `.hero-main { padding: 2rem 0; }`).
- [x] "Taste" and "the" words: Playfair Display weight 900, `line-height: 0.86`, `letter-spacing: -0.03em`, `EColors.onSurface`
- [x] "Collection" word: Playfair Display **italic weight 400** (not 900), `EColors.secondary`
- [x] Responsive size: `clamp(3.2rem, 2rem + 7vw, 9rem)` — use `LayoutBuilder`-driven font size

### _HeroTag
- [x] `Row`: `Expanded(child: Divider)` · mono center text · `Expanded(child: Divider)`. Divider color: `EColors.onSurface.withValues(alpha: 0.25)`
- [x] Text: JetBrains Mono, 0.78rem, `letter-spacing: 0.2em`, uppercase, `EColors.onSurfaceDim`. Content: "An Artisanal Catalogue · Volume XIV"
- [x] Padding-top: `ESpacing.lg` (1.5rem equiv)
- [x] Reveal: fade + translateY(40px → 0), 1s `Cubic(0.16, 1, 0.3, 1)`, after loader-done

### _HeroFoot
- [x] Layout: `Row(crossAxisAlignment: CrossAxisAlignment.end, children: [Expanded(_HeroDesc), _HeroCtaStack, Expanded(Align(alignment: Alignment.centerRight, child: _HeroScroll))])`. Padding-top: `ESpacing.xl` (48px ≈ 3rem).
- [x] **Left — `_HeroDesc`**: `Expanded` column. Playfair Display italic 1.1rem, `EColors.onSurface`, `height: 1.4`. Max-width: constrain via `LayoutBuilder` to `min(width, 28 * 17.6)` ≈ 493px, or simply let `Expanded` handle it. Copy: `"A small, obsessively curated cheesemongery in the Pacific Northwest. Boards, pairings, tours of the aging cave — and a monthly box for the brave of palate."` Bold phrase **"obsessively curated"**: weight 700, non-italic, `EColors.primary` via `TextSpan`.
- [x] **Center — `_HeroCtaStack`**: Natural-width `Column(mainAxisSize: MainAxisSize.min)`, centered. Primary button: "Shop the Collection →" — Space Grotesk, 0.82rem, `letter-spacing: 0.18em`, uppercase; filled `EColors.primary` bg, `EColors.surface` text; padding ~17.6px v / 28px h. SVG arrow inline at right. Outline button: "Book a Tour" — Space Grotesk, 0.72rem, uppercase; transparent bg, `EColors.onSurface` border; reduced padding ~11px v / 19px h. **Hover (web)**: use `MouseRegion` + `AnimatedContainer`; primary slide-fills with `EColors.onSurface`; outline slide-fills with `EColors.primary`; arrow `Transform.translate(Offset(4, 0))`.
- [x] **Right — `_HeroScroll`**: `Expanded(Align(right))`. JetBrains Mono 0.68rem, `letter-spacing: 0.28em`, uppercase, `EColors.onSurfaceDim`. Text: "Scroll · Ch. II". Below: `SizedBox(width: 1, height: 60)` filled `EColors.primary`. Animate `scaleY` using a single `AnimationController` (2s, repeat). In builder: when `value < 0.5` → `Transform.scale(scaleY: value * 2, alignment: Alignment.topCenter)`; when `value >= 0.5` → `Transform.scale(scaleY: (1 - value) * 2, alignment: Alignment.bottomCenter)`.
- [x] Mobile: `Column(crossAxisAlignment: CrossAxisAlignment.center)`. Desc: full-width, `TextAlign.center`. Scroll: centered.
- [x] Reveal: fade + `Transform.translate(Offset(0, 40) → Offset.zero)`, 1s `Cubic(0.16,1,0.3,1)`, after `loaderDone`.

### _HeroBadges
- [x] `Positioned(left: ESpacing.gut(context), bottom: 32)` — bottom: 2rem = 32px (no exact ESpacing token; use literal 32.0 or add `ESpacing.badgeBottom = 32.0`). `Column` gap ≈ 6px (0.4rem). 3 awards:
  - `◦ Good Food Awards 2024`
  - `◦ ACS Gold 2023`
  - `◦ PNW Slow Food 2025`
- [x] Label part (e.g. "◦ Good Food Awards"): JetBrains Mono, 0.68rem, `letter-spacing: 0.2em`, uppercase, `EColors.onSurfaceDim`
- [x] Year part (e.g. "2024"): Playfair Display italic, 0.95rem, **`EColors.secondary`**, normal letter-spacing — use `TextSpan` with separate `TextStyle`
- [x] Mobile: convert to horizontal `Wrap`, centered, below content flow

### WheelLayer — bug fixes + sizing
- [x] **Fix centering**: Change from `Positioned(right: 40, ...)` to `Center`-based positioning. Wheel should be centered in the hero (`top: 50%, left: 50%` equiv — use `Align(alignment: Alignment.center)`).
- [x] **Fix specks rotation bug**: `SpecksPainter` is currently inside the `Transform.rotate` group — move it OUT. Specks must be a sibling Stack layer to `WheelLayer`, not a child. Move `SpecksPainter` `CustomPaint` up to `hero_fullbleed.dart` Stack.
- [x] **Fix specks behavior**: Reference specks are STATIC — 30 dots at random fixed positions, no movement animation. Current `SpecksPainter` animates them rising (wrong). Rewrite as a `CustomPainter` with `shouldRepaint → false`: generate 30 dots at seeded-random `(x, y)` positions, fixed. Remove the `Ticker` and `_speckTicker` from `_WheelLayerState` entirely.
- [x] **Fix speck size**: Reference: 2–6px diameter = **1–3px radius**. Current code uses 2–6px radius (too large). Change seed: `radius: 1.0 + _rng.nextDouble() * 2.0`.
- [x] **Fix speck colors**: `_specks_painter.dart` hardcodes hex. Change to use `EColors.primary`, `EColors.secondary`, `EColors.accent` — these can't be `static const`, so generate dot data lazily or pass colors in as constructor params.
- [x] **Fix speck count**: Increase `_kCount` from 12 to 30.
- [x] **Fix wheel size**: Replace hardcoded `380.0` with `LayoutBuilder`-computed `min(min(width, height) * 0.62, 620.0)` (maps to `min(62vmin, 620px)`).
- [x] **Fix wheel opacity**: Wrap wheel `CustomPaint` in `Opacity(opacity: 0.85)`.
- [x] **Fix parallax guard**: Add `if (scrollPx < viewportHeight)` check before applying `Offset(0, scrollPx * 0.3)`. If scroll ≥ viewport, hold offset at `Offset(0, viewportHeight * 0.3)`. (Current code has no guard — wheel drifts indefinitely.)
- [x] Confirm mouse tilt: ±20px (already implemented, verify `TweenAnimationBuilder` smoothing is still intact)
- [x] Confirm 60s rotation: already present in `_WheelLayerState`, verify it applies to wheel `CustomPaint` only (specks are now a separate static layer)

### CheeseWheelPainter — fidelity pass
The existing painter is a rough approximation. Match the reference SVG detail:
- [x] **Radial gradient fills**: Replace flat `_kPaste` fill with `RadialGradient` (center amber, edge dark). Replace flat rind with radial rind bloom (transparent at 92%, opaque at 100%).
- [x] **Interior contour rings**: Add 3 concentric circles at 75%, 54%, 33% of radius, `EColors.secondary` at 12% opacity, `strokeWidth: 0.5`.
- [x] **Rind bloom dashes**: Add dashed circle at `r * 0.975`, `strokeDashArray` equiv (1px stroke, 4px gap), `EColors.onSurface.withValues(alpha: 0.18)`.
- [x] **Tick marks**: 48 ticks around rind (every 7.5°). Every 4th tick is longer. `EColors.rind.withValues(alpha: 0.35)`.
- [x] **Chapter marks**: Text labels "01" "02" "03" "04" at 12, 3, 6, 9 o'clock positions. JetBrains Mono, 10px, `letter-spacing: 2`, `EColors.onSurface.withValues(alpha: 0.4)`. Use `canvas.drawParagraph` or `TextPainter` — no `Text` widget in a `CustomPainter`.
- [x] **Center stamp**: Two concentric `drawCircle` strokes (r≈14%, r≈12% of full radius). Inner: dashed. "Cheese" italic Playfair at center, "INC · TAC" mono below. Both at 55% opacity.
- [x] **Wedge cut geometry**: Match reference — cut from 12 o'clock clockwise to ~34° (top-right arc). Current 50° wedge at 25° doesn't match.
- [x] **Cut face lines**: Two radial strokes along wedge edges, subtle (45% opacity).
- [x] **Floating slice**: Small translated/rotated wedge fragment offset from main wheel (sells the cut effect).
- [x] **Eye count and positions**: Increase from 7 to 14 deterministic eyes matching reference positions. Use fixed seed coordinates, not pure random.
- [x] **Crumb count**: Increase from 8 to 38 crumbs, using golden-angle spiral (137.5° step) for distribution.

### Loader sequencing
- [x] Add `final loaderDone = false.obs` to `HomeController`. This is the single source of truth hero widgets observe.
- [x] `AppLoader` already exposes `onComplete` (fires when progress hits 100%) and `onDismiss` (fires 1400ms later after curtains exit). Hero reveals must gate on **`onDismiss`** — not `onComplete` — so text only appears after the curtains are fully gone. In `main.dart` (or wherever `AppLoader` is instantiated), pass `onDismiss: () => Get.find<HomeController>().loaderDone.value = true`.
- [x] If `AppEnv.showLoader` is false, `AppLoader` is not shown. In that case `loaderDone` must be set `true` immediately on `HomeController.onInit()` so reveals fire without waiting.
- [x] **Fallback timeout**: In `HomeController.onInit()`, after 6 seconds force `loaderDone.value = true` if still false. Mirrors `main.js` failsafe.

### MarqueeSection — wiring and content
- [x] `MarqueeSection` is already registered in `home_view.dart`'s `_sectionForId` — no code change needed there. The missing piece: **add `'marquee'` to `HOME_SECTIONS` in `client.json`**, immediately after `'hero'`. Current default is `'hero,services,cta'` — it must become `'hero,marquee,services,cta'` (or equivalent for this client).
- [x] `MarqueeSection` is currently wrapped in `RevealOnScroll` by `_buildSections()`. The reference marquee has no entrance animation — it should appear immediately below the hero. In `home_view.dart._buildSections()`, skip the `RevealOnScroll` wrapper when `id == 'marquee'` (or handle it as a special case before the loop).
- [x] Content items (from `marquee.js`): `'Aged in cedar'`, `'Cut to order'`, `'Small-batch'`, `'Stored at 54°F'`, `'Wrapped in beeswax paper'`, `'Tacoma, WA'`, `'Est. 2019'`, `'Open Wed–Sun'`
- [x] Separator: `✦` glyph in `EColors.primary`. Items in Playfair Display italic 1.6rem, `EColors.onSurface`.
- [x] Animation: 40s linear infinite scroll (duplicate sequence for seamless loop)

### Extract & size limits
- [x] Keep `hero_fullbleed.dart` under 300 lines — extract sub-widgets progressively as it grows

## Acceptance Criteria
- [x] Frame border visible inset from viewport edges (separate Stack layer, pointer-events ignored)
- [x] Meta 3 columns: labels `EColors.onSurfaceDim` at 50% opacity, values `EColors.onSurface` Playfair italic — stagger 50/150/250ms after loader curtain exits
- [x] Title words reveal staggered 40ms per word, only after `loaderDone = true`, using `Cubic(0.16, 1, 0.3, 1)` at 1.1s; "Collection" = Playfair italic weight 400 in `EColors.secondary`
- [x] Wheel centered (not right-aligned), rotates 60s, parallax scrollY×0.3, ±20px cursor tilt, opacity 0.85
- [x] Specks are a separate non-rotating Stack layer; static (no rise animation); count = 30; radius 1–3px; colors use `EColors.*` tokens
- [x] Wheel parallax clamps at viewport height boundary — wheel stops drifting past bottom of hero
- [x] Footer: `Row([Expanded(desc), cta, Expanded(Align(right, scroll))])`, bottom-aligned; "obsessively curated" weight 700 `EColors.primary`; stacks to 1-col on mobile
- [x] `_HeroScroll` line animates with origin flip: top-origin expand then bottom-origin collapse, 2s loop
- [x] Scroll indicator line in `EColors.primary`, origin-flip at midpoint, 2s loop
- [x] All 3 badges bottom-left; year in Playfair italic `EColors.secondary`
- [x] MarqueeSection appears immediately after hero (no RevealOnScroll wrapper), correct content, `✦` separators in `EColors.primary`
- [x] `loaderDone` observable on `HomeController`; set via `AppLoader.onDismiss`; 6s fallback; immediate if `showLoader = false`
- [x] No hardcoded `EColors.cream` or `EColors.gold` — only `EColors.onSurface` and `EColors.secondary` respectively
- [x] `ESpacing.framePad` (20.0) and `ESpacing.frameSmall` (10.0) added to `e_spacing.dart`
- [x] `client.json` `HOME_SECTIONS` includes `'marquee'` after `'hero'`
- [x] Content Column `Transform.translate(scrollPx * 0.12)` removed; only wheel parallaxes on scroll
- [x] Mobile (≤600px): 2-col meta, stacked footer, `ESpacing.frameSmall` frame inset, horizontal badges
- [x] `_hero_cta.dart` retained (used by centered/split variants); `_OverlinePill` and `_PulsingScrollIndicator` classes removed from `hero_fullbleed.dart`
- [x] `_HeroMeta` has 32px top padding; `_HeroTitle` has 32px vertical padding; `_HeroBadges` has 32px bottom offset
