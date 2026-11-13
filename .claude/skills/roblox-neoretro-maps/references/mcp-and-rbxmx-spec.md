# Roblox Studio MCP & .rbxmx XML Technical Specification

## 1. Roblox Studio MCP Execution Strategy

When connected to Roblox Studio via MCP (e.g., `run_code`, `execute_luau`, or scene-editing tools):

1. **Always Make Scripts Idempotent:** Before generating a zone or map, destroy and recreate the target container (`local existing = workspace:FindFirstChild("Map"); if existing then existing:Destroy() end`) or target zone folder so re-running never duplicates geometry.
2. **Wrap Mutations in `ChangeHistoryService`:** Call `ChangeHistoryService:SetWaypoint("Before NeoRetro Build")` / `("After NeoRetro Build")` when modifying Studio via Luau so the developer can Ctrl+Z cleanly.
3. **Build in Modular Passes:** Never dump a 2,000-line single-shot script if MCP has output/timeout limits. Split into:
   - Pass 1: `Lighting` + `Map` folder skeleton + helper module/table.
   - Pass 2: `RoadSegments` + `Guardrails` + `Ramps` spine.
   - Pass 3: `Environment` (terrace cliffs, pines, tunnels, gantries).
   - Pass 4: `Obstacles_Breakable`, `Obstacles_Solid`, `Interactive_Zones`.
4. **Verify After Each Pass:** Query child counts and `GetBoundingBox()` on `workspace.Map` via MCP to confirm zero NaN CFrames and expected elevation span.

---

## 2. .rbxmx XML Specification (Fallback / File Export)

If asked to output a standalone `.rbxmx` file for drag-and-drop into Roblox Studio Explorer:

### Root Envelope
```xml
<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.roblox.com/roblox.xsd" version="4">
  <External>null</External>
  <External>nil</External>
  <Meta name="ExplicitAutoJoints">true</Meta>
  <Item class="Model" referent="RBX_MAP">
    <Properties>
      <string name="Name">NeoRetroDownhillMap</string>
    </Properties>
    <!-- Child Items -->
  </Item>
</roblox>
```

### Critical XML Quirks
- **`size` is lowercase:** `<Vector3 name="size"><X>16</X><Y>2</Y><Z>16</Z></Vector3>`
- **`shape` is lowercase:** `<token name="shape">1</token>` (`Part` only; omit on `WedgePart` and `CornerWedgePart`).
- **`referent` must be unique** on every `<Item>` (`RBX_0001`, `RBX_0002`, ...), especially when referencing `PrimaryPart` (`<Ref name="PrimaryPart">RBX_0001</Ref>`) or `WeldConstraint` (`<Ref name="Part0">`, `<Ref name="Part1">`).
- **Orthonormal Rotation Matrix in `<CoordinateFrame name="CFrame">`:**
  For rotation around X by `-theta` (downhill slope):
  - `R00 = 1`, `R01 = 0`, `R02 = 0`
  - `R10 = 0`, `R11 = cos(-theta)`, `R12 = -sin(-theta)`
  - `R20 = 0`, `R21 = sin(-theta)`, `R22 = cos(-theta)`
  (Since `cos(-θ) = cos(θ)` and `sin(-θ) = -sin(θ)`, `R12 = +sin(θ)` and `R21 = -sin(θ)`.)

### Verified .rbxmx Enum Integer Tokens

**`Material` (`<token name="Material">`):**
- `256` = `Plastic`
- `272` = `SmoothPlastic`
- `288` = `Neon`
- `512` = `Wood`
- `528` = `WoodPlanks`
- `784` = `Marble`
- `800` = `Slate`
- `816` = `Concrete`
- `832` = `Granite`
- `848` = `Brick`
- `1040` = `CorrodedMetal`
- `1056` = `DiamondPlate`
- `1088` = `Metal`
- `1280` = `Grass`
- `1568` = `Glass`

**`TopSurface` / `BottomSurface` / Side Surfaces:**
- `0` = `Smooth`
- `1` = `Glue`
- `2` = `Weld`
- `3` = `Studs`
- `4` = `Inlet`
- `5` = `Universal`
- `10` = `SmoothNoOutlines`

**`shape` (`Part` only):**
- `0` = `Ball` (Sphere)
- `1` = `Block`
- `2` = `Cylinder`
- `3` = `Wedge`
- `4` = `CornerWedge`

**`TrussPart` `style` (`<token name="style">`):**
- `0` = `Alternates`
- `1` = `BridgeStyle`
- `2` = `NoSupports`

**Core `BrickColor` IDs (`<int name="BrickColor">`):**
- `21` = Bright red
- `23` = Bright blue
- `24` = Bright yellow
- `26` = Black
- `28` = Dark green
- `37` = Bright green
- `102` = Medium blue
- `106` = Bright orange
- `141` = Earth green
- `192` = Reddish brown
- `194` = Medium stone grey
- `199` = Dark stone grey
- `1001` = Institutional white
- `1003` = Really black
