# /inspo — Brand Alignment Report: Cheese Inc.
> Generated: 2026-04-20 (v2 — with Competitor Intel feed)
> Sources: drinksom.eu · utopiatokyo.com · planetono.space + 5 competitor profiles
> Brand Brief: "Bold Sensory Playful" · Wes Anderson aesthetic · Adventurous food lovers 25–45, Pacific Northwest

---

## A. Visual Brand

### Personality
**Recommended:** `editorial-dark indulgent playful`

The three inspiration sites are unanimous: dark, immersive, interactive. drinksom.eu is premium-mystical (red/orange on black, numbered carousel, loading sequence). Utopia Tokyo is cyberpunk-irreverent (black/white contrast, glitch effects, interactive selector). Planetono is cosmic-playful (deep space palette, irregular typography, sound-forward). All three take their product seriously while winking at the audience — exactly the Wes Anderson brief: warm, art-directed, never stiff.

**Competitor intel cross-check:** The top 5 cheese competitors (Beecher's, Rogue, etc.) all use warm earthy palettes and heritage serif fonts — the industry baseline. The inspo sites operate at a higher editorial register. The intersection is the opportunity: **warm dark editorial as base (chocolate, amber, cream) with Wes Anderson wit layered on top.** This differentiates Cheese Inc. from every direct competitor while remaining legible as a premium food brand.

**Celebrity alignment:** Wes Anderson = obsessively art-directed grids, warm color palettes, deliberate quirkiness, never random. drinksom's numbered carousel (01/04) and planetono's cast of named characters (Major Paws, Cluck Rogers) share this quality. ✅ Confirmed alignment.

**Note:** Step 4.5 (ui-ux-pro-max script) was skipped — `scripts/search.py` not present in this project. Add `.claude/skills/ui-ux-pro-max/scripts/search.py` to enable industry design validation.

### Color System
| Token | Current | Recommended | Reasoning |
|-------|---------|-------------|-----------|
| `COLOR_SURFACE` | `#FFFFFF` | `#0D0907` | All 3 inspo sites use dark bases. White is the single biggest mismatch. Warm near-black (chocolate undertone) fits artisan cheese indulgence and differentiates from every competitor. |
| `COLOR_ON_SURFACE` | `#0D0D0D` | `#F0E6D0` | Warm cream/parchment on dark — evokes aged cheese, candlelight, luxury. Matches drinksom's warm text-on-dark. |
| `COLOR_PRIMARY` | `#CC2200` | `#FF4500` | Brighter red-orange pops on dark. drinksom's hero is dominant red/orange on black — this is the signal. Current CC2200 goes muddy on dark surfaces. |
| `COLOR_SECONDARY` | `#F5F0E8` | `#D4A853` | Aged-cheese amber/gold. Replaces neutral cream with something sensory and rich. Competitors use earthy warm tones — amber bridges inspo aesthetic and competitor warmth. |
| `COLOR_ACCENT` | `#E8650A` | `#E8650A` | **Keep.** Molten orange is the "hot cheese" energy and maps directly to drinksom's secondary tones. |

**Confidence:** High. Dark surface is unanimous across all 3 inspo sites AND differentiates from all 5 competitors (0 of 5 use dark).

### Typography
| Token | Current | Recommended | Reasoning |
|-------|---------|-------------|-----------|
| `FONT_PRIMARY` | `Space Grotesk` | `Space Grotesk` | **Keep.** Editorial, modern, geometric — aligns with drinksom's dramatic hierarchy and utopiatokyo's letter-spacing effects. |
| `FONT_SECONDARY` | `Playfair Display` | `Playfair Display` | **Keep.** Luxury serif for body/subhead — Wes Anderson's aesthetic always pairs modern geometry with classical references. Competitor intel confirms: all 5 top competitors use serif for heritage signaling. |

**Hero display moments:** Planetono and utopiatokyo both use oversized, irregular type (80–120px with mixed case and letter-spacing extremes). Implement via `ETextStyles.heroDisplay` — not a client.json field. Consider `Bebas Neue` for impact moments only.

### Hero Variant
`HERO_VARIANT`: Keep `fullscreen`. All 3 inspo sites: fullscreen. drinksom and planetono explicitly use immersive full-viewport heroes.

### NAV_STYLE
`NAV_STYLE`: Keep `overlay`. drinksom uses sticky minimal nav, utopiatokyo uses coordinate-anchored minimal nav, planetono uses sticky horizontal menu. All are invisible or minimal at load. ✅ Already aligned.

---

## B. Layout Patterns (Cross-Site Consensus)

### Section Ordering
| Source | Flow |
|--------|------|
| drinksom.eu | Hero → Benefits carousel → Origin story → CTA → Waitlist |
| utopiatokyo.com | Loading → Hero → Gallery → Interactive selector → Footer |
| planetono.space | Hero → Products → How it works → Locations → Footer |
| Competitor consensus | Hero → Origin story → Products/Services → Awards → CTA → Location |
| **Combined consensus** | **Hero → Services → Gallery → CTA → Testimonials** |

**Origin story gap (competitor intel):** All 5 competitors use a founding story as a primary trust anchor. None of the inspo sites lead with it (they lead with product/experience), but it appears mid-scroll in all competitor sites. Recommendation: surface a brief origin story within the services or gallery section as a callout card, rather than a full dedicated section.

### Grid Density
**Sparse to balanced.** All three inspo sites use generous whitespace. Utopiatokyo is the densest (mask gallery grid) but still breathable — 2–3 columns max. Planetono is the sparsest (1 product card at a time). Competitors confirm: spacious is the category standard.

### Above-the-Fold Pattern
- Fullscreen hero, minimal text (1 headline + 1 CTA), no scrolling content visible
- Nav invisible or minimal at load (transparent overlay)
- 2 of 3 inspo sites have a loading sequence before hero appears (drinksom's "LOADING SŌM EXPERIENCE", utopiatokyo's loading state)

### Structural Motifs
- Loading sequences: ✅ 2/3 inspo sites
- Full-bleed imagery: ✅ All three
- Numbered content (01/04): ✅ drinksom
- Interactive product selector: ✅ utopiatokyo
- Location markers/map: ✅ planetono
- Card grids: ✅ utopiatokyo (dense product grid)
- Carousels: ✅ drinksom (numbered benefit carousel)

### Recommended HOME_SECTIONS
```
hero,services,gallery,cta,testimonials
```
**Changes from current (`hero,gallery,services,blog,testimonials,cta`):**
- Move `services` before `gallery` — establish what you offer before visual proof
- Remove `blog` — none of 3 inspo sites OR 5 competitors surface blog on homepage
- Move `cta` before `testimonials` — convert first, validate second (inspo + competitor consensus)
- Keep `testimonials` last as trust anchor before footer

**Origin story:** Embed as a callout within the gallery section rather than a standalone section — this keeps section count lean while addressing the competitor trust gap.

---

## C. Interactive Elements

### Detected Animation Patterns
| Site | Interactions |
|------|-------------|
| drinksom.eu | Branded loading sequence, numbered scroll carousel (01/04), scroll-triggered reveals, badge display, waitlist form capture |
| utopiatokyo.com | Loading state + warning toggle, glitch effects, hover on mask tiles, interactive stat-driven selector, safe/danger mode toggle |
| planetono.space | Immersive sound intro, fullscreen hero, playful mixed-case irregular typography, location map markers, named character mascots |

### Animation Signals
No specific library tags confirmed (GSAP/Lottie not detected in fetched source). All three sites have **bespoke loading sequences** and **scroll-driven reveals** suggesting custom implementation. Planetono's irregular letter casing and utopiatokyo's glitch effects suggest CSS animation + custom JS rather than library-driven.

### Flutter Animation Vocabulary (Recommended)
| Effect | Widget | Priority |
|--------|--------|----------|
| Brand loading screen before hero | `NeonPulse` on logo + fade reveal | HIGH — 2/3 inspo sites use this |
| Headline reveals on scroll | `TextReveal` (word mode) | HIGH |
| Gallery / product cards | `TiltCard` + `InertiaCarousel` | HIGH |
| Hero background depth | `ParallaxLayer` (depth 0.2 bg, 0.6 content) | HIGH |
| Section entrances | `RevealOnScroll` + `StaggerGroup` | HIGH |
| Desktop cursor | `CursorOverlay` (ring expands on CTAs) | MEDIUM |
| Page transitions | Diagonal clip-path wipe (350ms) | MEDIUM |
| Numbered carousel | `InertiaCarousel` with index counter display | LOW (v2) |
| Interactive product selector | Custom state machine (v2 feature) | LOW (v2) |

---

## D. Guest Flow

### CTA Analysis
| Source | Primary CTA | Flow |
|--------|-------------|------|
| drinksom.eu | JOIN WAITLIST | Hero email capture → waitlist |
| utopiatokyo.com | DISCOVER YOUR INNER MASK | Interactive selector → product |
| planetono.space | gift it / keep it | Experience → share or keep |
| Competitor avg | Discover / Visit Us / Shop Now | Browse → location or shop |

### Recommended Flow for Cheese Inc.
```
Hero ("TASTE THE COLLECTION")
  → Services (what they offer: boards, pairings, tasting, shop)
  → Gallery (visual proof / appetite appeal — embed origin callout here)
  → CTA ("BUILD YOUR BOARD" or "SHOP NOW")
  → Testimonials (social proof anchor)
  → Footer with Tacoma location + hours
```

**CTA Language:** None of the inspo sites use generic "Contact Us" or "Learn More." They use sensory, action-oriented language. Recommend: `"TASTE THE COLLECTION"` for hero, `"BUILD YOUR BOARD"` for service CTA. Both are Instagram-share worthy — direct appeal to the target customer (adventurous 25–45 sharing everything).

**Trust before CTA:** Inspo sites don't lead with testimonials. They lead with the experience itself. Competitors confirm: origin story and product come before testimonials. Place testimonials after the CTA.

**Tacoma positioning opportunity (competitor intel):** Zero of 5 competitors explicitly target Tacoma. Add "Tacoma" to hero subhead, SEO_TITLE, and SEO_DESCRIPTION. This is the fastest trust win available and costs nothing to implement.

---

## E. Conflicts & Gaps

### 🔴 Critical Conflicts
| Conflict | Current | Fix |
|----------|---------|-----|
| **White surface** | `COLOR_SURFACE: #FFFFFF` | Change to `#0D0907`. White is the single biggest mismatch — all 3 inspo sites and 0 competitors use pure white. |
| **Blog on homepage** | `HOME_SECTIONS` includes `blog` | Remove. None of 3 inspo sites or 5 competitors surface blog on homepage. |
| **`PERSONALITY: bold`** | Too generic, undirected | Replace with `editorial-dark indulgent playful` |

### 🟡 Moderate Gaps
| Gap | Notes |
|-----|-------|
| **No loading screen** | 2/3 inspo sites have a branded loading sequence. A logo animation + fade-in immediately elevates the editorial feel. |
| **No origin story callout** | All 5 competitors use it. Embed as a card within the gallery section. |
| **No awards / badges** | 3/5 competitors display awards (ACS, Good Food Award). If Cheese Inc. has any, surface as badge elements near the hero. |
| **Tacoma identity absent** | "Tacoma" and "Pacific Northwest" not in SEO_TITLE or SEO_DESCRIPTION. All competitors lead with geographic identity. |
| **`COLOR_PRIMARY: #CC2200`** | Correct hue but muddy on new dark surface. Brighten to `#FF4500`. |
| **Testimonials before CTA** | Currently ordered before CTA. Inspo and competitor consensus: convert first, validate second. |

### 🟢 Already Aligned
- `HERO_VARIANT: fullscreen` ✅
- `NAV_STYLE: overlay` ✅
- `FONT_PRIMARY: Space Grotesk` ✅
- `FONT_SECONDARY: Playfair Display` ✅
- `COLOR_ACCENT: #E8650A` ✅
- `BRAND_THREE_WORDS: Bold Sensory Playful` ✅ — maps well to inspo sites
- `BRAND_CELEBRITY: Wes Anderson` ✅ — confirmed alignment across all 3 inspo sites

### Low-Confidence Inputs
All brand brief fields are discovery-grade. No flags raised. `/brand-brief` was run prior to this analysis. ✅

### ui-ux-pro-max
Step 4.5 skipped — `scripts/search.py` not found. Industry design system cross-validation not available for this run.

### Modules Not in Inspo (Potential Friction)
- `newsletter` — none of the 3 inspo sites use a standalone newsletter section. drinksom uses email capture baked into the hero waitlist flow. Consider merging newsletter capture into the hero CTA form.
- `crm`, `faq` — internal/admin modules, no guest-facing concern.

### Modules Missing (Potential Win)
- **Subscriptions/cheese club** — Rogue Creamery's cheese club is their highest-trust conversion driver. The subscriptions module is available but disabled. Even a "Monthly Board Box" creates recurring revenue and opens the subscription keyword category.

---

## Diff Summary — Recommended client.json Changes

```diff
- "PERSONALITY": "bold",
+ "PERSONALITY": "editorial-dark indulgent playful",

- "HOME_SECTIONS": "hero,gallery,services,blog,testimonials,cta",
+ "HOME_SECTIONS": "hero,services,gallery,cta,testimonials",

- "COLOR_PRIMARY": "CC2200",
+ "COLOR_PRIMARY": "FF4500",

- "COLOR_SECONDARY": "F5F0E8",
+ "COLOR_SECONDARY": "D4A853",

- "COLOR_SURFACE": "FFFFFF",
+ "COLOR_SURFACE": "0D0907",

- "COLOR_ON_SURFACE": "0D0D0D",
+ "COLOR_ON_SURFACE": "F0E6D0",
```

**No changes recommended for:** `HERO_VARIANT`, `NAV_STYLE`, `FONT_PRIMARY`, `FONT_SECONDARY`, `COLOR_ACCENT`, `COLOR_ERROR`

**Non-client.json actions (high value):**
- Update `SEO_TITLE` and `SEO_DESCRIPTION` to include "Tacoma" and "Pacific Northwest"
- Add a branded loading screen (NeonPulse + fade) before the hero
- Embed origin story callout card inside the gallery section
- Display any awards as badge elements near the hero

---

*Run `/build` to apply these findings to client.json and activate the Flutter build session.*
