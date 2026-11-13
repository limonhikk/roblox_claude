# Roblox Neo-Retro Maps — Скилл для Claude Code

[English](README.md) | **Русский**

Скилл **`roblox-neoretro-maps`** для **Claude Code**, который обучает Claude проектировать и собирать детализированные карты Roblox в стиле **Neo-Retro** (*Regretevator*, *Combat Initiation*, *Forsaken*) через **Roblox Studio MCP** или **`.rbxmx` XML**.

Основной фокус — скоростные горные спуски на автомобилях с множеством препятствий для столкновений: бесшовная физика наклонов, 3-слойная детализация, дисциплина стадов/поверхностей (`Studs` / `Inlet` / `Smooth`), палитры `BrickColor`, пресеты `Lighting` и модульные Luau-билдеры.

---

## Структура скилла

```text
.claude/skills/roblox-neoretro-maps/
├── SKILL.md                                  # Основные правила, пайплайн MCP и триггеры
├── references/
│   ├── neoretro-style-bible.md               # Анти-retroslop, SurfaceType, BrickColor, Lighting
│   ├── downhill-crash-engineering.md         # Математика CFrame для уклонов, зоны, теги препятствий
│   └── mcp-and-rbxmx-spec.md                 # Работа через Studio MCP и XML-токены .rbxmx
└── templates/
    └── luau-builders.lua                     # Готовые Luau-функции генерации дороги, рамп и пропов
```

---

## Быстрая установка

### Способ 1: Через `npx skills` (рекомендуемый)

Установить **глобально** (скилл будет доступен во всех ваших проектах Claude Code):

```bash
npx skills add limonhikk/roblox_claude --skill roblox-neoretro-maps -g
```

Установить **только в текущий проект** (выполнять в корне вашего Roblox-проекта):

```bash
npx skills add limonhikk/roblox_claude --skill roblox-neoretro-maps
```

---

### Способ 2: Через `npx degit` (скачивает только папку скилла без `.git`)

**Глобально — Windows (PowerShell):**
```powershell
npx degit limonhikk/roblox_claude/.claude/skills/roblox-neoretro-maps "$env:USERPROFILE\.claude\skills\roblox-neoretro-maps"
```

**Глобально — macOS / Linux / Git Bash:**
```bash
npx degit limonhikk/roblox_claude/.claude/skills/roblox-neoretro-maps ~/.claude/skills/roblox-neoretro-maps
```

**В текущий проект:**
```bash
npx degit limonhikk/roblox_claude/.claude/skills/roblox-neoretro-maps .claude/skills/roblox-neoretro-maps
```

---

### Способ 3: Чистый `git` (`sparse-checkout`, без Node.js)

Выкачивает из репозитория только папку `.claude/skills/roblox-neoretro-maps`:

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

## Проверка и использование в Claude Code

1. Откройте ваш Roblox-проект и запустите `claude`.
2. Убедитесь, что **Roblox Studio** открыта, а **Roblox Studio MCP** подключен (`/mcp` в Claude Code).
3. Введите `/` — в списке команд должен появиться `/roblox-neoretro-maps`.

### Рекомендуемый пошаговый пайплайн генерации карты

Чтобы карта получилась максимально детализированной, собирайте её в 4 прохода:

1. **Свет и основа трассы:**
   ```text
   /roblox-neoretro-maps Примени пресет Lighting Daylight, создай структуру Workspace.Map и построй бесшовную трассу спуска от Y=650 до Y=0 шириной 64 studs с отбойниками и разметкой.
   ```
2. **Горный рельеф и архитектура:**
   ```text
   Добавь вокруг трассы ступенчатые нео-ретро скалы без Smooth Terrain, ретро-сосны, ферменные мосты из TrussPart, туннель в Zone2 и наддорожные арки.
   ```
3. **Препятствия и геймплей:**
   ```text
   Наполни трассу препятствиями каждые 50–70 studs: разрушаемые кирпичные стены, взрывные бочки со WeldConstraint, трамплины с неоновыми стрелками и буст-пады с тегами CollectionService.
   ```
4. **Финишная арена и аудит:**
   ```text
   На Y=0 построй Crash Bowl арену со стеной-мишенью и триггером FinishZone, затем проверь стыки дороги на отсутствие порогов.
   ```
