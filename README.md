# Roblox Neo-Retro Maps — Claude Code Skill

**English** | [Русский](README.ru.md)

A **Claude Code** skill (`roblox-neoretro-maps`) that teaches Claude how to design and build detailed Roblox maps in the **Neo-Retro** aesthetic (*Regretevator*, *Combat Initiation*, *Forsaken*) via **Roblox Studio MCP** or **`.rbxmx` XML**.

Focused on high-speed downhill mountain car-crash / demolition obstacle maps: physics-safe sloped road chaining, 3-layer silhouette detailing, `Studs` / `Inlet` / `Smooth` surface discipline, classic `BrickColor` palettes, `Lighting` presets, and modular Luau builders.

---

## Skill Structure

```text
.claude/skills/roblox-neoretro-maps/
├── SKILL.md                                  # Core rules, MCP workflow, and trigger metadata
├── references/
│   ├── neoretro-style-bible.md               # Anti-retroslop rules, SurfaceType, BrickColor, Lighting
│   ├── downhill-crash-engineering.md         # Slope CFrame math, vertical zones, obstacle tags
│   └── mcp-and-rbxmx-spec.md                 # Studio MCP patterns and .rbxmx XML enum tokens
└── templates/
    └── luau-builders.lua                     # Ready-to-use Luau builders for roads, ramps, and props
```

---

## Quick Installation

### Option 1: Via `npx skills` (Recommended)

Install **globally** (available across all your Claude Code projects):

```bash
npx skills add limonhikk/roblox_claude --skill roblox-neoretro-maps -g
```

Install **into the current project only** (run inside your Roblox project root):

```bash
npx skills add limonhikk/roblox_claude --skill roblox-neoretro-maps
```

---

### Option 2: Via `npx degit` (Downloads only the skill folder, no `.git`)

**Global — Windows (PowerShell):**
```powershell
npx degit limonhikk/roblox_claude/.claude/skills/roblox-neoretro-maps "$env:USERPROFILE\.claude\skills\roblox-neoretro-maps"
```

**Global — macOS / Linux / Git Bash:**
```bash
npx degit limonhikk/roblox_claude/.claude/skills/roblox-neoretro-maps ~/.claude/skills/roblox-neoretro-maps
```

**Current project only:**
```bash
npx degit limonhikk/roblox_claude/.claude/skills/roblox-neoretro-maps .claude/skills/roblox-neoretro-maps
```

---

### Option 3: Pure `git` (`sparse-checkout`, no Node.js required)

Fetches only `.claude/skills/roblox-neoretro-maps` from the repository:

**Windows (PowerShell):**
```powershell
git clone --depth 1 --filter=blob:none --sparse https://github.com/limonhikk/roblox_claude.git _tmp_skill
git -C _tmp_skill sparse-checkout set .claude/skills/roblox-neoretro-maps
New-Item -ItemType Directory -Force "$env:USERPROFILE\.claude\skills" | Out-Null
Move-Item "_tmp_skill\.claude\skills\roblox-neoretro-maps" "$env:USERPROFILE\.claude\skills\" -Force
Remove-Item -Recurse -Force _tmp_skill
```

**macOS / Linux / Git Bash:**
```bash
git clone --depth 1 --filter=blob:none --sparse https://github.com/limonhikk/roblox_claude.git _tmp_skill && \
git -C _tmp_skill sparse-checkout set .claude/skills/roblox-neoretro-maps && \
mkdir -p ~/.claude/skills && \
rm -rf ~/.claude/skills/roblox-neoretro-maps && \
mv _tmp_skill/.claude/skills/roblox-neoretro-maps ~/.claude/skills/ && \
rm -rf _tmp_skill
```

---

## Verification & Usage in Claude Code

1. Open your Roblox project and run `claude`.
2. Make sure **Roblox Studio** is open and **Roblox Studio MCP** is connected (`/mcp` inside Claude Code).
3. Type `/` — `/roblox-neoretro-maps` should appear in the command list.

### Recommended 4-Pass Generation Workflow

For maximum detail and clean physics, build maps in 4 sequential passes:

1. **Lighting & Road Spine:**
   ```text
   /roblox-neoretro-maps Apply the Daylight Lighting preset, create Workspace.Map, and build a seamless 64-stud-wide downhill road from Y=650 to Y=0 with guardrails and dashed lane markings.
   ```
2. **Mountain Terrain & Architecture:**
   ```text
   Add stepped Neo-Retro terraced cliffs (no Smooth Terrain), retro pine trees, TrussPart bridges, a neon-lit tunnel in Zone2, and overhead gantries along the descent.
   ```
3. **Obstacles & Gameplay Zones:**
   ```text
   Populate the road every 50–70 studs with obstacles: breakable brick walls, welded explosive barrels, neon-trimmed ramps, and boost pads with CollectionService tags.
   ```
4. **Crash Bowl & Physics Audit:**
   ```text
   Build the Crash Bowl arena at Y=0 with a giant target wall and FinishZone trigger, then verify all road joints have zero upward seam lips.
   ```
