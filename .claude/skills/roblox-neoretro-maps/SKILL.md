---
name: roblox-neoretro-maps
description: Designs and builds detailed Roblox Neo-Retro maps (Regretevator, Combat Initiation, Forsaken aesthetic) via Roblox Studio MCP (Luau execution) or .rbxmx XML. Use whenever creating, detailing, or refactoring Roblox maps, especially downhill mountain car-crash / demolition obstacle courses, retro architectural props, Lighting presets, BrickColor palettes, stud/inlet surface discipline, and physics-safe sloped roads.
---

# Roblox Neo-Retro Map Architect

Build intentional, crisp, high-detail **Neo-Retro** Roblox maps (*Regretevator*, *Combat Initiation*, *Forsaken*) using **Roblox Studio MCP** (preferred) or `.rbxmx` XML.

## Core Design Principles (Anti-Retroslop)

Never spam studs on all 6 faces of giant featureless boxes. Neo-Retro combines classic 2008–2013 plastic-block grammar with modern composition, silhouette depth, and atmospheric lighting:

1. **Grid Discipline:** Snap architectural sizes and positions to `4`, `2`, `1`, `0.5`, or `0.25` studs. Avoid arbitrary decimals except trigonometric CFrame chaining on angled slopes.
2. **3-Layer Silhouette Depth:** Every major structure (tunnel portal, bridge, cliff wall, tower, obstacle) needs:
   - **Primary Mass:** Thick structural blocks (`2–8` studs thick; no paper-thin walls).
   - **Secondary Framing:** Protruding pillars, ribs, arches, buttresses (`+0.5–2` studs offset).
   - **Tertiary Trim & Props:** Contrasting border strips (`0.25–0.5` studs), `TrussPart` supports, bolts, signs, hazard stripes, `Neon` accents.
3. **Surface & Material Discipline:**
   - Use `Material = Plastic` for 70–80% of base architecture with `TopSurface = Studs`, `BottomSurface = Inlet`, and **`Smooth` on side faces**.
   - Use `Weld` or `Universal` surfaces on steel beams, crates, pipes, and mechanical joints.
   - Reserve `SmoothPlastic` for road markings, clean signage, hazard stripes, and stylized trim.
   - Use `Neon` strictly for **3–7% of the scene** (boost chevrons, explosive fuses, tunnel beacons, hazard arrows).
   - Use `Metal`, `DiamondPlate`, `WoodPlanks`, and `Concrete` selectively for industrial/quarry contrast.
4. **60-30-10 BrickColor Rule:**
   - **60% Environment Base:** `Dark stone grey`, `Medium stone grey`, `Black`, `Earth green`, `Dark green`, `Reddish brown`.
   - **30% Structures:** `Institutional white`, `Mid gray`, `Bright blue`, `Medium blue`, `Nougat`.
   - **10% Gameplay Targets & Hazards:** `Bright yellow` + `Really black` stripes, `Bright red` (explosives/targets), `Bright orange` (cones/barriers/ramps), `Lime green` / `Cyan` (boosts).
   - **Seam Rule:** Never let two touching parts share the exact same color and flush plane—shift value by 1–2 steps or insert a `0.25–0.5` stud border.
5. **Atmospheric Lighting:** Never leave flat default lighting. Configure `ShadowMap` (or `Voxel`), tinted cool shadows (`Ambient`), warm directional sunlight (`OutdoorAmbient`), subtle `BloomEffect`, `ColorCorrectionEffect`, and distance `FogEnd` / `Atmosphere`.

## Downhill Car-Crash Map Architecture

When building a mountain descent map for crashing vehicles into obstacles:

1. **Physics-Safe Slope Chaining:** Compute every sloped road segment sequentially via `CFrame` math and step each new segment down by `-0.04` studs along local `Y` (or use bottom overlap) so fast cars (`120–250 studs/sec`) never snag on an upward seam lip.
2. **Vehicle Scale:** Keep road width `56–80` studs, guardrails/cliff walls `8–16` studs high along both edges, and tunnel/arch clearances at least `18` studs tall.
3. **Blocky Mountain Terrain (No Smooth Terrain):** Sculpt cliffs with terraced `Part`, `WedgePart`, and `CornerWedgePart` slabs (`8 / 16 / 32` stud elevation steps), low-poly retro pine trees, watchtowers, pipelines, and distant horizon peaks.
4. **3 Obstacle Classes & Tagging:**
   - `Obstacles_Breakable` (`Anchored = false`, internal sub-parts joined with `WeldConstraint`, tagged `"Breakable"` or `"Explosive"`): crate stacks, brick walls, explosive barrels, signs, tire piles, glass barriers.
   - `Obstacles_Solid` (`Anchored = true`): jersey barriers, concrete bridge piers, rock clusters, mega-ramps with `Neon` chevrons.
   - `Hazards_Dynamic` / `Interactive_Zones`: `"BoostPad"` strips, rotating crusher bars, wrecking-ball mount points, `"FinishZone"` bowl.
5. **5-Zone Vertical Progression (`Y = +700` down to `Y = 0`):**
   - **Zone 0 (Summit Plaza):** Garage spawners, giant retro gantry arch, launch boosts.
   - **Zone 1 (Alpine Switchbacks, `14°–20°`):** Pine terraces, wooden scaffolding, brick walls, small jump gaps.
   - **Zone 2 (Industrial Quarry & Tunnel, `22°–28°`):** `TrussPart` bridges, cliff overhangs, neon-lit tunnel packed with explosive barrels and slalom pillars.
   - **Zone 3 (Turbo Gauntlet, `30°–38°`):** Multi-lane boost strips, mega-ramps, dense breakable prop carpets, overhead hazard gates.
   - **Zone 4 (Crash Bowl, `Y = 0`):** Walled demolition pit with giant target wall, crusher pads, and reset/score trigger.

## Execution Workflow (Roblox Studio MCP)

Follow this phased workflow when working with MCP so builds stay clean, deterministic, and within tool execution limits:

1. **Inspect & Plan:** Check `Workspace` and `Lighting` via MCP first. Define the map's `Y` elevation budget, zone boundaries, and palette preset.
2. **Pass 1 — Lighting & Hierarchy:** Apply the `Lighting` preset and create an idempotent root container `Workspace.Map` with zone folders (`Zone0_Summit` .. `Zone4_CrashBowl`).
3. **Pass 2 — Spine & Road Physics:** Execute modular Luau builders (see `templates/luau-builders.lua`) to generate the continuous `RoadSegments`, `Guardrails`, and `Ramps` first. Verify zero upward lips at joints.
4. **Pass 3 — Mountain & Architecture:** Add terraced `Environment` cliffs, tunnels, `TrussPart` bridges, overhead gantries, and retro pine trees around the road spine.
5. **Pass 4 — Obstacles & Tags:** Populate `Obstacles_Breakable`, `Obstacles_Solid`, and `Interactive_Zones` every `45–75` studs with clear high-contrast sightlines, `WeldConstraint` joints on unanchored assemblies, and `CollectionService` tags/attributes.
6. **Pass 5 — Verification:** Inspect part counts, bounding boxes, `Anchored` states, and `Lighting` via MCP; test-check clearances (`>= 18` studs vertical, `>= 56` studs road width) before reporting completion.

## Reference Library

Load only the reference file needed for the current task:
- Style rules, `SurfaceType` matrix, `BrickColor` palettes, and `Lighting` presets: `references/neoretro-style-bible.md`
- Slope CFrame math, `WedgePart` orientation, vertical zoning, and obstacle design: `references/downhill-crash-engineering.md`
- Roblox Studio MCP patterns and `.rbxmx` XML schema/enum integer tokens: `references/mcp-and-rbxmx-spec.md`
- Ready-to-adapt Luau builder functions for MCP execution: `templates/luau-builders.lua`
