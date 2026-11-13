# Downhill Mountain Car-Crash Map Engineering

## 1. Vehicle Scale & Clearance Standards

- **Typical Roblox Car:** `6–10` studs wide, `12–18` studs long, `5–8` studs tall.
- **Road Width:** `56–80` studs (supports 4–6 lanes, swerving, multi-car chaos).
- **Guardrail Height:** `6–10` studs along outer edges (`4–8` stud thick backing walls or stepped cliff lips).
- **Tunnel / Gantry Clearance:** Minimum `18–24` studs above road surface so tall trucks and airborne jumps never clip overhead beams.
- **Sightline Rhythm:** Place a readable obstacle cluster or ramp every `45–75` studs along the descent. At `180` studs/sec, `60` studs equals ~`0.33` seconds between impacts.

## 2. Slope CFrame Math (Zero Physics Lip)

In Roblox, local forward is `-Z`, local up is `+Y`, and local right is `+X`.

- Tilting `-Z` **downhill** by `pitchDeg` degrees requires a **negative** X rotation:
  `CFrame.Angles(-math.rad(pitchDeg), 0, 0)`
- Given a `segTopStartCF` sitting flush on the road's top surface at the start edge:
  - Road slab center: `segTopStartCF * CFrame.new(0, -thickness / 2, -length / 2)`
  - Next segment start edge: `local nextPos = (segTopStartCF * CFrame.new(0, -0.04, -length)).Position`
  - Build `nextStartCF = CFrame.new(nextPos) * CFrame.Angles(0, yawRad, 0) * CFrame.Angles(-math.rad(nextPitchDeg), 0, 0)`
- **Why `-0.04` on Y:** Even if floating-point rounding occurs at high vehicle speed, a `0.04` stud downward drop lets tires fall smoothly onto the next plate instead of catching an upward seam lip and flipping randomly.

### WedgePart Orientation Check
In Roblox, an unrotated `WedgePart` slopes **upward from `-Z` (low) to `+Z` (high)**:
- **Launch Ramp facing downhill (`-Z`):** Car drives from `+Z` toward `-Z` and launches upward. Rotate `WedgePart` by `CFrame.Angles(0, math.pi, 0)` relative to `roadCF`!
- **Descending Nose / Cliff Skirt facing `-Z`:** Keep unrotated (`0` yaw) so the thin tip points toward `-Z`.

## 3. Vertical Macro-Zoning Blueprint

Total drop example: `Y = +680` (Summit) down to `Y = 0` (Crash Bowl), ~`1,800–2,400` studs horizontal run.

| Zone | Elevation | Slope Pitch | Visual Identity | Key Obstacles |
|---|---|---|---|---|
| `Zone0_Summit` | `Y = +680` | `0°` -> `12°` | Garage pads, giant neon start arch | Starter boost strips, breakable banner gates |
| `Zone1_Alpine` | `+680` -> `+450` | `15°–20°` | Pine terraces, wooden scaffolding | Brick walls, crate pyramids, cones, small jumps |
| `Zone2_Quarry` | `+450` -> `+220` | `22°–28°` | Rock tunnel, `TrussPart` bridges, pipes | Explosive barrel rows, concrete slalom piers, boulders |
| `Zone3_Gauntlet` | `+220` -> `+30` | `30°–38°` | High-speed highway, hazard stripes | Mega-ramps, boost carpets, tollbooths, rotating bars |
| `Zone4_CrashBowl` | `Y = 0` | `0°` bowl | Walled demolition pit & grandstands | Giant brick target wall, explosive pit, finish zone |

## 4. Obstacle Taxonomy & CollectionService Tagging

Always attach `CollectionService` tags and `Attributes` so gameplay scripts work immediately:

| Category | `Anchored` | Joints | `CollectionService` Tag | Recommended `Attributes` |
|---|---|---|---|---|
| Brick Walls / Crates / Signs | `false` | `WeldConstraint` per prop or brick-by-brick | `"Breakable"` | `ScoreValue (number)`, `MassClass (string)` |
| Explosive Barrels / Mines | `false` | `WeldConstraint` on barrel sub-parts | `"Explosive"` | `BlastRadius (number)`, `BlastForce (number)` |
| Speed Boost Strips | `true` | N/A (`CanCollide = false` or flush `0.15` slab) | `"BoostPad"` | `BoostSpeed (number)`, `Duration (number)` |
| Jersey Barriers / Piers | `true` | N/A | `"SolidHazard"` | `DamageScale (number)` |
| Finish / Arena Trigger | `true` | N/A (`CanCollide = false`, `Transparency = 1`) | `"FinishZone"` | `ZoneName (string)` |

### Multi-Part Unanchored Assembly Rule
For any `Anchored = false` obstacle made of >1 part (e.g., an explosive barrel with top/bottom rings and a neon cap, or a highway sign):
- Set one main body part as `model.PrimaryPart`.
- Connect every child `BasePart` to `PrimaryPart` using a `WeldConstraint` (`Part0 = PrimaryPart`, `Part1 = child`).
- Never rely on legacy surface auto-joints (`ExplicitAutoJoints`) for dynamic props—explicit `WeldConstraint` guarantees parts stay together until broken by script/explosion.

## 5. Blocky Mountain & Vista Detailing

- **Cliff Flanks:** Every road segment should have stepped rock terraces on `Left` and `Right` (`-X` and `+X`), rising `24–96` studs higher than the road with staggered offsets (`0`, `+12`, `+28` studs out) and `WedgePart` buttresses.
- **Overhead Landmarks:** Place retro gantries, steel `TrussPart` viaduct arches, or rock tunnels every `200–300` studs so the player constantly perceives speed via parallax.
- **Retro Foliage:** Build pine trees from a `Reddish brown` trunk (`4x12x4`) topped with 3 stacked `Dark green` / `Earth green` tiers (`14x4x14`, `10x4x10`, `6x4x6`) with `TopSurface = Studs`.
