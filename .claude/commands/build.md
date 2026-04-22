Apply Brand Alignment Report findings to client.json and activate build skills.

---

**Part 1 — Update client.json design tokens**

1. Read `planning/client/brand_alignment.md`.
   If the file does not exist — stop and tell the user to run `/inspo` first.

2. Read `execution/frontend/app/client.json`.

3. Apply every field where the BAR diff summary differs from the current value:
   PERSONALITY, COLOR_PRIMARY, COLOR_SECONDARY, COLOR_ACCENT, COLOR_SURFACE,
   COLOR_ON_SURFACE, FONT_PRIMARY, FONT_SECONDARY, HERO_VARIANT, NAV_STYLE, HOME_SECTIONS.

4. Write the updated `client.json` back to disk.

5. Print a clear diff of every field changed: `FIELD: old_value → new_value`.
   If no fields changed, confirm the current client.json is already aligned with the BAR.

---

**Part 2 — Claude Design mockup (recommended before building)**

Before writing any Flutter code, check if a Claude Design mockup exists:
- Ask: "Have you run Claude Design on this project yet? (y/n)"
- **If yes:** Ask for the mockup screenshot or export. Use it as the visual target for Part 3+.
- **If no:** Recommend: "For best results, open Claude Design at claude.ai/design, point it at `execution/frontend/app/` and `planning/client/brand_alignment.md`, describe the screen you want, and paste the result here before we build. This gives AntiGravity a concrete visual target."
- Either way: proceed to Part 3 — Claude Design is recommended but not blocking.

---

**Part 3 — Activate build skills**

6. Load `.claude/skills/brand-directives/SKILL.md`
7. Load `.claude/skills/frontend-design/SKILL.md`
8. Load `.claude/skills/flutter_dev/SKILL.md`
9. Confirm the Active Directives are derived from the BAR and the session is ready to build.

---

Remind the user: run `./deliver.sh --skip-db --skip-functions` from `execution/frontend/app/`
to compile the Flutter app with the updated client.json tokens.

---

**Part 3 — Image placeholder standard**

All image slots scaffolded in this session must use `ShimmerPlaceholder` (defined in `frontend-design/DETAILED_GUIDE.md`). Rules:

- Package: `shimmer: ^3.0.0` — if not in `pubspec.yaml`, remind the user to add it.
- Colors: `baseColor: EColors.surface`, `highlightColor: EColors.surfaceAlt`
- Every placeholder must carry a `// TODO(image-gen): <slot description>` comment so `/image-gen` can locate and replace it.
- Aspect ratio must always be locked via `AspectRatio` — never a fixed height — so layout is stable when the real image loads.

**Default slot presets:**
| Slot | Ratio |
|------|-------|
| Hero background | `16 / 9` |
| Product / service card | `4 / 3` |
| Portrait / team | `3 / 4` |
| Square thumbnail | `1 / 1` |

**Usage:**
```dart
// TODO(image-gen): hero-background
ShimmerPlaceholder(aspectRatio: 16 / 9, slot: 'hero-background')

// TODO(image-gen): service-card-cheese-tasting
ShimmerPlaceholder(aspectRatio: 4 / 3, slot: 'service-card-cheese-tasting')
```

Never use `Container(color: Colors.grey)`, `Placeholder()`, or `Image.asset('assets/placeholder.png')` as image stand-ins.
