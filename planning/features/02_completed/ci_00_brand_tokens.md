# Feature: CI — Brand Tokens & Artisan Personality
> Status: backlog

## Goal
Fix the token layer so every downstream section renders the correct colors, fonts, and motion parameters. This is a hard blocker — nothing else will look right until this is set.

## Reference Values

### Colors
| Token | Hex | Role |
|-------|-----|------|
| SURFACE | `#0D0907` | Primary background |
| SURFACE_2 | `#17110C` | Elevated surface (drawers, sheets) |
| SURFACE_3 | `#211812` | Tertiary depth (card hover backgrounds) |
| ON_SURFACE | `#F0E6D0` | Primary text / CREAM alias |
| ON_SURFACE_DIM | `#A89B80` | Secondary/muted text |
| PRIMARY | `#FF4500` | CTAs, interactive states |
| SECONDARY | `#D4A853` | Highlights, metadata |
| ACCENT | `#E8650A` | Special emphasis |
| DEEP | `#0D0907` | Dark overlay text on light surfaces (alias) |
| PARCHMENT | `#E8D9B5` | Section backgrounds, blockquotes |
| RIND | `#7A4A1F` | Warm brown accents, rind motif |
| MOLD | `#B8C4A4` | Membership badges, blue-cheese veining green |

### Typography
| Token | Value |
|-------|-------|
| FONT_PRIMARY | `Playfair Display` |
| FONT_UI | `Space Grotesk` |
| FONT_MONO | `JetBrains Mono` |
| PERSONALITY | `artisan` |

## Files
- `execution/frontend/app/lib/core/config/app_env.dart` — verify/fix defaults + add new fields
- `execution/frontend/app/lib/core/theme/e_colors.dart` — add SURFACE_3, PARCHMENT, RIND, MOLD, border helpers
- `execution/frontend/app/lib/core/theme/e_text_styles.dart` — add 7-step scale + named variants
- `execution/frontend/app/lib/core/theme/personality_theme.dart` — add `artisan` preset
- `execution/frontend/app/lib/core/theme/_personality_presets.dart` — artisan preset values

## Tasks

### Colors
- [ ] Update AppEnv fallback defaults to cheese-inc brand values
- [ ] Add `SURFACE_3`, `PARCHMENT`, `RIND`, `MOLD` to EColors
- [ ] Add border opacity helpers to EColors:
  - `borderSubtle` → `onSurface.withValues(alpha: 0.08)` (dividers)
  - `borderMedium` → `onSurface.withValues(alpha: 0.12)` (card rest state)
  - `borderStrong` → `onSurface.withValues(alpha: 0.25)` (emphasis)

### Typography — Type Scale
- [ ] Add 7-step scale to ETextStyles (mobile / desktop breakpoints via LayoutBuilder):
  - step0: 14sp / 16sp — body small
  - step1: 16sp / 20sp — body
  - step2: 22sp / 32sp — subhead
  - step3: 32sp / 52sp — section heading
  - step4: 48sp / 96sp — display small
  - step5: 72sp / 176sp — display
  - step6: 96sp / 256sp — hero headline
- [ ] Add named text style variants to ETextStyles:
  - `displayHero` — Playfair w900, lh 0.88, -0.02em LS
  - `sansXl` — Space Grotesk w500, 0.18em LS, uppercase (eyebrow labels)
  - `mono` — JetBrains Mono 0.78× step1, 0.12em LS, uppercase (metadata)
  - `eyebrow` — Space Grotesk 0.72× step1, 0.28em LS, uppercase (chapter markers)
  - `serifItalic` — Playfair w400, italic (pull quotes)

### Spacing
- [ ] Add ESpacing constants:
  - `gut` — responsive gutter helper (16–48px via LayoutBuilder)
  - `maxWidth: 1440` — content container cap
  - Scale: `xs=4, sm=8, md=16, lg=24, xl=48, xxl=80, xxxl=128`

### Personality Preset
- [ ] Add `artisan` personality preset:
  - `cardRadius: 0`, `buttonRadius: 0`
  - `headingWeight: FontWeight.w900`
  - `animDuration: 700ms`
  - `animCurve: Curves.easeOutQuint` (≈ cubic-bezier(0.16, 1, 0.3, 1))
  - `animCurveInteractive: Curves.easeInOutCubic` (≈ cubic-bezier(0.76, 0, 0.24, 1))
  - `letterSpacingDisplay: -0.02em`
  - `textAlignment: TextAlign.left`
- [ ] Set `PERSONALITY=artisan` in client.json

### AppEnv Runtime Fields
- [ ] Verify/add AppEnv fields (dart-defines from client.json):
  - `HERO_VARIANT` — default `"editorial"`
  - `MOTION_INTENSITY` — default `"full"`
  - `SHOW_LOADER` — default `true`
  - `PALETTE` — default `"warm-dark"`
  - `WES_DIAL` — default `85` (motion personality dial, 0–100)

### Grain Texture
- [ ] Add grain texture asset (`assets/textures/grain.png`) to pubspec + asset list
- [ ] Add `EEffects.grainOpacity = 0.06` constant for `AmbientHeroBackground` usage

### Quality
- [ ] Confirm dart-defines / client.json feeds correct values into AppEnv at build time
- [ ] Run `flutter analyze` — zero errors

## Acceptance Criteria

### Colors
- [ ] `EColors.primary` resolves to `#FF4500`
- [ ] `EColors.surface` resolves to `#0D0907`
- [ ] `EColors.surface2` resolves to `#17110C`
- [ ] `EColors.surface3` resolves to `#211812`
- [ ] `EColors.onSurface` resolves to `#F0E6D0`
- [ ] `EColors.onSurfaceDim` resolves to `#A89B80`
- [ ] `EColors.parchment` resolves to `#E8D9B5`
- [ ] `EColors.rind` resolves to `#7A4A1F`
- [ ] `EColors.mold` resolves to `#B8C4A4`
- [ ] Border helpers (`borderSubtle`, `borderMedium`, `borderStrong`) exist and use `withValues(alpha:)`

### Typography
- [ ] Display font renders Playfair Display
- [ ] UI font renders Space Grotesk
- [ ] Mono font renders JetBrains Mono
- [ ] `ETextStyles.displayHero` renders Playfair w900 at step-5/step-6 scale
- [ ] `ETextStyles.eyebrow` renders Space Grotesk 0.28em LS uppercase
- [ ] `ETextStyles.mono` renders JetBrains Mono uppercase

### Spacing
- [ ] `ESpacing.gut` scales responsively (16–48px range via LayoutBuilder)
- [ ] `ESpacing.maxWidth` equals `1440`

### AppEnv
- [ ] `AppEnv.heroVariant` defaults to `"editorial"`
- [ ] `AppEnv.motionIntensity` defaults to `"full"`
- [ ] `AppEnv.showLoader` defaults to `true`
- [ ] `AppEnv.wesDial` defaults to `85`

### Grain
- [ ] Grain texture asset referenced in `AmbientHeroBackground` at opacity `0.06`
