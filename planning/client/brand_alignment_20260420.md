# Brand Alignment Report: Cheese Inc.
> Generated: 2026-04-20 | Sources: drinksom.eu · utopiatokyo.com · planetono.space
> Brand Brief: "Cheesy Yummy Gooey" · Rob Lowe aesthetic · cheese eaters

---

## A. Visual Brand

### Personality
**Recommended:** `editorial-dark indulgent playful`

The three inspiration sites share a precise tension: **premium craft meets irreverent personality**. Drinksom is mystical-premium. Utopia Tokyo is cyberpunk-moody. Planetono is cosmic-playful. Together they define a brand that takes its *product* seriously but winks at the audience — exactly the Rob Lowe brief ("yummy and cheesy"). The current `bold` is too blunt and undirected. The new personality is **dark editorial as the base, with deliberate moments of warmth and wit**.

**Celebrity alignment check:** Rob Lowe is charming, self-aware, effortlessly cool, premium but never stiff. All three sites have this quality — they don't explain themselves, they pull you in. ✅ Aligned.

### Color System
| Token | Current | Recommended | Reasoning |
|-------|---------|-------------|-----------|
| `COLOR_SURFACE` | `#FFFFFF` | `#0D0907` | All 3 inspo sites use dark bases. White is the single biggest gap from the inspo aesthetic. Warm near-black (chocolate undertone) fits cheese indulgence. |
| `COLOR_ON_SURFACE` | `#0D0D0D` | `#F0E6D0` | Warm cream/parchment on dark — evokes aged cheese, luxury. |
| `COLOR_PRIMARY` | `#CC2200` | `#FF4500` | Brighter red-orange pops on dark. Current value goes muddy on dark backgrounds. |
| `COLOR_SECONDARY` | `#F5F0E8` | `#D4A853` | Aged-cheese amber/gold. Replaces neutral cream with something sensory and rich. |
| `COLOR_ACCENT` | `#E8650A` | `#E8650A` | Keep. Molten orange is the "hot cheese" energy — perfect. |

**Confidence:** High. Dark surface is unanimous across all 3 sites. The warm undertone is brand-specific.

### Typography
| Token | Current | Recommended | Reasoning |
|-------|---------|-------------|-----------|
| `FONT_PRIMARY` | `Space Grotesk` | `Space Grotesk` | Keep. Editorial, modern — aligns with drinksom's dramatic hierarchy. |
| `FONT_SECONDARY` | `Playfair Display` | `Playfair Display` | Keep. Luxury serif for body/subhead — appropriate for indulgent positioning. |

**Hero display moments:** Consider `Bebas Neue` or `DM Serif Display` for oversized hero text (80-120px). Not a client.json field — implement via `ETextStyles.heroDisplay`.

### Hero Variant
`HERO_VARIANT`: Keep `fullscreen`. All 3 inspo sites use immersive full-viewport heroes.

### NAV_STYLE
`NAV_STYLE`: Keep `overlay`. All 3 sites use transparent overlay nav. ✅ Already aligned.

---

## B. Layout Patterns (Cross-Site Consensus)

### Section Ordering
| Site | Flow |
|------|------|
| drinksom.eu | Hero → Benefits carousel → Origin story → CTA |
| utopiatokyo.com | Hero → Gallery grid → Interactive → Footer |
| planetono.space | Hero → Product showcase → How it works → Locations → Footer |
| **Consensus** | **Hero → Product/Feature → Story/How → CTA → Location** |

### Grid Density
**Sparse to balanced.** All three sites use generous whitespace. Dense grids are absent. Cards are large, breathable, not crammed.

### Above-the-fold Pattern
- Fullscreen hero, minimal text (1 headline + 1 CTA), no scrolling content visible
- Nav is invisible or minimal at load
- Two of three have a **loading sequence before hero appears**

### Structural Motifs
- Sticky nav: ❌ None of the 3 sites use sticky nav prominently
- Full-bleed imagery: ✅ All three
- Card grids: ✅ Utopia (dense product grid) and Planetono (sparse product cards)
- Carousels: ✅ drinksom (numbered benefit carousel 01/04)

### Recommended HOME_SECTIONS
```
hero,services,gallery,cta,testimonials
```
**Changes from current (`hero,gallery,services,blog,testimonials,cta`):**
- Move `services` before `gallery` — product/concept before visual proof
- Remove `blog` from homepage — none of the inspo sites surface a blog on the homepage
- Move `cta` before `testimonials` — convert first, validate second

---

## C. Interactive Elements

### Detected Animation Patterns
| Site | Interactions |
|------|-------------|
| drinksom.eu | Loading sequence, numbered scroll carousel, scroll-triggered reveals |
| utopiatokyo.com | Loading states, glitch effects, hover on tiles, interactive generator |
| planetono.space | Immersive sound, smooth scroll anchors, map markers, playful irregular type |

### Flutter Animation Vocabulary (Recommended)
| Effect | Widget |
|--------|--------|
| Brand loading screen before hero | `NeonPulse` on logo + fade reveal |
| Headline reveals on scroll | `TextReveal` (word mode) |
| Gallery / product cards | `TiltCard` + `InertiaCarousel` |
| Hero background depth | `ParallaxLayer` (depth 0.2 bg, 0.6 content) |
| Service/product section entrances | `RevealOnScroll` + `StaggerGroup` |
| Desktop cursor | `CursorOverlay` (ring expands on CTAs) |
| Page transitions | Diagonal clip-path wipe (350ms) |

---

## D. Guest Flow

### CTA Analysis
| Site | Primary CTA | Flow |
|------|-------------|------|
| drinksom.eu | JOIN WAITLIST | Hero email capture → waitlist |
| utopiatokyo.com | DISCOVER YOUR MASK | Interactive generator → product |
| planetono.space | StArt / Where to find us | Browse → location |

### Recommended Flow for Cheese Inc.
```
Hero ("TASTE THE COLLECTION") 
  → Services (boards, pairings, shop)
  → Gallery (visual proof / appetite appeal)
  → CTA ("BUILD YOUR BOARD" or "SHOP NOW")
  → Testimonials (social proof)
  → Footer with location + hours
```

**CTA Language:** Use sensory, action-oriented language. Recommend: `"TASTE THE COLLECTION"` for hero, `"BUILD YOUR BOARD"` for service CTA.

**Trust signals:** Place testimonials **after** the primary CTA, not before. Trust comes from visual quality, not quote blocks.

---

## E. Conflicts & Gaps

### 🔴 Critical Conflicts
| Conflict | Current | Fix |
|----------|---------|-----|
| **White surface** | `COLOR_SURFACE: #FFFFFF` | Change to `#0D0907`. White is the single biggest mismatch. |
| **Blog in homepage sections** | `HOME_SECTIONS` includes `blog` | Remove. None of the 3 inspo sites have a blog on the homepage. |
| **`PERSONALITY: bold`** | Too generic | Replace with `editorial-dark indulgent playful` |

### 🟡 Moderate Gaps
| Gap | Notes |
|-----|-------|
| **No loading screen** | 2 of 3 sites have an intro loading sequence. A branded loading screen would immediately elevate the feel. |
| **No interactive element** | Cheese equivalent of "Discover Your Mask": "Build Your Board" selector. V2 consideration. |
| **Testimonials placement** | Currently before CTA. Move after. |

### 🟢 Already Aligned
- `HERO_VARIANT: fullscreen` ✅
- `NAV_STYLE: overlay` ✅
- `FONT_PRIMARY: Space Grotesk` ✅
- `FONT_SECONDARY: Playfair Display` ✅
- `COLOR_ACCENT: #E8650A` ✅

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

**No changes:** `HERO_VARIANT`, `NAV_STYLE`, `FONT_PRIMARY`, `FONT_SECONDARY`, `COLOR_ACCENT`, `COLOR_ERROR`

---

*Run `/build` to apply these findings to client.json and activate the Flutter build session.*
