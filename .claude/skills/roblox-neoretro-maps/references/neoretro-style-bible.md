# Neo-Retro Style Bible (Regretevator / Combat Initiation / Forsaken)

## 1. What Makes Neo-Retro Look Intentional

| Bad ("Retroslop") | Authentic Neo-Retro |
|---|---|
| `Studs` on all 6 faces of every block | `Studs` on `TopSurface`, `Inlet` on `BottomSurface`, `Smooth` on sides |
| Flat 1-part walls with no trim | 3-depth layering: base wall + structural ribs + contrasting border trim |
| Random neon RGB colors everywhere | Disciplined `BrickColor` 60-30-10 ratio; `Neon` capped at 3–7% |
| Default bright flat 2008 lighting | `ShadowMap`/`Voxel` with cool tinted `Ambient` + warm `OutdoorAmbient` |
| Random decimal sizes (`13.47 x 4.19`) | Snapped `4 / 2 / 1 / 0.5 / 0.25` stud grid |

## 2. Geometry & Micro-Detailing Rules

- **Minimum Structural Thickness:** Walls `2–4` studs, pillars `2–3` studs, guardrails `0.75–1.5` studs, trim plates `0.25–0.5` studs.
- **Faked Bevels & Chamfers:** Since legacy `Part` bevels are deprecated, frame corners with `WedgePart` gussets, recessed center panels (`-0.25` stud inset), or stepped `0.5` stud caps on top of pillars and crates.
- **Mechanical Props:** Combine `Part` (`Block` and `Cylinder`), `WedgePart`, `CornerWedgePart`, and `TrussPart`. Add `0.25` stud rivet/bolt blocks, end-caps on pipes, and collar rings on barrels.

## 3. Material & SurfaceType Matrix

| Element Type | `Material` | `TopSurface` | `BottomSurface` | Side Surfaces |
|---|---|---|---|---|
| Cliff terraces, ground, roofs | `Plastic` | `Studs` | `Inlet` | `Smooth` |
| Structural walls, brick stacks | `Plastic` | `Studs` | `Smooth` | `Smooth` |
| Steel beams, crates, girders | `Metal` or `Plastic` | `Weld` / `Studs` | `Weld` | `Weld` or `Smooth` |
| Road asphalt / lane stripes | `SmoothPlastic` or `Slate` | `Smooth` | `Smooth` | `Smooth` |
| Industrial catwalks / ramp edges | `DiamondPlate` | `Smooth` | `Smooth` | `Smooth` |
| Scaffolding, barriers, crates | `WoodPlanks` | `Smooth` / `Studs` | `Smooth` | `Smooth` |
| Boost chevrons, beacons, fuses | `Neon` | `Smooth` | `Smooth` | `Smooth` |
| Towers, ladders, bridge trusses | `TrussPart` (`Metal`/`Plastic`) | N/A | N/A | N/A |

## 4. Curated Neo-Retro BrickColor Palettes

### Preset A: Alpine Smash (High-Contrast Daylight)
- **Mountain Rock (60%):** `Dark stone grey` (199), `Medium stone grey` (194), `Flint`
- **Foliage & Ground:** `Earth green` (141), `Dark green` (28), `Reddish brown` (192)
- **Road & Bridges (30%):** `Black` (26) asphalt, `Institutional white` (1001) stripes, `Mid gray` barriers
- **Hazards & Targets (10%):** `Bright yellow` (24), `Really black` (1003), `Bright red` (21), `Bright orange` (106)

### Preset B: Combat Quarry (Industrial Sunset)
- **Cliffs & Walls (60%):** `Dark stone grey` (199), `Smoky grey`, `Brown`
- **Structures (30%):** `Fossil`, `Medium blue` (102), `Rust` / `Reddish brown` (192)
- **Hazards (10%):** `New Yeller`, `Bright red` (21), `Deep orange`

### Preset C: Forsaken Dusk (Moody Twilight)
- **Cliffs & Terrain (60%):** `Really black` (1003), `Dark stone grey` (199), `Earth green` (141)
- **Architecture (30%):** `Dark taupe`, `Steel blue`, `Sand blue`
- **Neon & Targets (10%):** `Crimson`, `Bright yellow` (24), `Teal` / `Cyan`

## 5. Lighting & Post-Processing Presets

Apply these exact ratios to `Lighting` (adjust `ClockTime` per preset):

### Daylight Crisp (Regretevator / Classic Neo-Retro)
- `Technology = Enum.Technology.ShadowMap`
- `GlobalShadows = true`
- `ClockTime = 14.5`
- `Brightness = 2.4`
- `Ambient = Color3.fromRGB(70, 78, 110)` (cool blue-violet shadows)
- `OutdoorAmbient = Color3.fromRGB(145, 145, 155)`
- `ColorShift_Top = Color3.fromRGB(255, 242, 218)`
- `FogColor = Color3.fromRGB(185, 205, 230)`
- `FogStart = 250`, `FogEnd = 1300`
- `ColorCorrectionEffect`: `Saturation = 0.14`, `Contrast = 0.10`
- `BloomEffect`: `Intensity = 0.35`, `Size = 16`, `Threshold = 1.6`

### Forsaken Dusk (High-Contrast Dramatic)
- `Technology = Enum.Technology.ShadowMap`
- `ClockTime = 17.6`
- `Brightness = 2.0`
- `Ambient = Color3.fromRGB(48, 42, 72)`
- `OutdoorAmbient = Color3.fromRGB(120, 95, 115)`
- `ColorShift_Top = Color3.fromRGB(255, 175, 130)`
- `FogColor = Color3.fromRGB(95, 78, 115)`
- `FogStart = 180`, `FogEnd = 950`
- `ColorCorrectionEffect`: `Saturation = 0.18`, `Contrast = 0.15`
- `BloomEffect`: `Intensity = 0.45`, `Size = 20`, `Threshold = 1.4`
