--!strict
-- Modular Neo-Retro Map Builder Library for Roblox Studio MCP execution
-- Designed for downhill car-crash maps in Regretevator / Combat Initiation / Forsaken style

local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")

local NeoRetro = {}

export type PartOpts = {
	Name: string?,
	Size: Vector3,
	CFrame: CFrame,
	Color: string | Color3 | nil,
	Material: Enum.Material?,
	TopSurface: Enum.SurfaceType?,
	BottomSurface: Enum.SurfaceType?,
	SideSurface: Enum.SurfaceType?,
	Anchored: boolean?,
	CanCollide: boolean?,
	Shape: Enum.PartType?,
	Transparency: number?,
	Parent: Instance?,
	Tags: { string }?,
	Attributes: { [string]: any }?,
}

function NeoRetro.applyLightingPreset(preset: "Daylight" | "Dusk")
	for _, child in ipairs(Lighting:GetChildren()) do
		if child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect") or child:IsA("Atmosphere") then
			child:Destroy()
		end
	end

	Lighting.GlobalShadows = true
	Lighting.EnvironmentDiffuseScale = 0.25
	Lighting.EnvironmentSpecularScale = 0

	local cc = Instance.new("ColorCorrectionEffect")
	cc.Name = "NeoRetroColor"
	cc.Parent = Lighting

	local bloom = Instance.new("BloomEffect")
	bloom.Name = "NeoRetroBloom"
	bloom.Parent = Lighting

	if preset == "Dusk" then
		Lighting.ClockTime = 17.6
		Lighting.Brightness = 2.0
		Lighting.Ambient = Color3.fromRGB(48, 42, 72)
		Lighting.OutdoorAmbient = Color3.fromRGB(120, 95, 115)
		Lighting.ColorShift_Top = Color3.fromRGB(255, 175, 130)
		Lighting.FogColor = Color3.fromRGB(95, 78, 115)
		Lighting.FogStart = 180
		Lighting.FogEnd = 950
		cc.Saturation = 0.18
		cc.Contrast = 0.15
		bloom.Intensity = 0.45
		bloom.Size = 20
		bloom.Threshold = 1.4
	else
		Lighting.ClockTime = 14.5
		Lighting.Brightness = 2.4
		Lighting.Ambient = Color3.fromRGB(70, 78, 110)
		Lighting.OutdoorAmbient = Color3.fromRGB(145, 145, 155)
		Lighting.ColorShift_Top = Color3.fromRGB(255, 242, 218)
		Lighting.FogColor = Color3.fromRGB(185, 205, 230)
		Lighting.FogStart = 250
		Lighting.FogEnd = 1300
		cc.Saturation = 0.14
		cc.Contrast = 0.10
		bloom.Intensity = 0.35
		bloom.Size = 16
		bloom.Threshold = 1.6
	end
end

function NeoRetro.makePart(opts: PartOpts): Part
	local p = Instance.new("Part")
	p.Name = opts.Name or "RetroPart"
	p.Size = opts.Size
	p.CFrame = opts.CFrame
	p.Anchored = if opts.Anchored == nil then true else opts.Anchored
	p.CanCollide = if opts.CanCollide == nil then true else opts.CanCollide
	p.Material = opts.Material or Enum.Material.Plastic
	p.Shape = opts.Shape or Enum.PartType.Block
	p.Transparency = opts.Transparency or 0

	if typeof(opts.Color) == "Color3" then
		p.Color = opts.Color
	elseif type(opts.Color) == "string" then
		p.BrickColor = BrickColor.new(opts.Color)
	else
		p.BrickColor = BrickColor.new("Medium stone grey")
	end

	p.TopSurface = opts.TopSurface or Enum.SurfaceType.Studs
	p.BottomSurface = opts.BottomSurface or Enum.SurfaceType.Inlet
	local side = opts.SideSurface or Enum.SurfaceType.Smooth
	p.FrontSurface = side
	p.BackSurface = side
	p.LeftSurface = side
	p.RightSurface = side

	if opts.Tags then
		for _, tag in ipairs(opts.Tags) do
			CollectionService:AddTag(p, tag)
		end
	end
	if opts.Attributes then
		for k, v in pairs(opts.Attributes) do
			p:SetAttribute(k, v)
		end
	end

	p.Parent = opts.Parent
	return p
end

function NeoRetro.weldAssembly(model: Model, primary: BasePart)
	model.PrimaryPart = primary
	for _, desc in ipairs(model:GetDescendants()) do
		if desc:IsA("BasePart") and desc ~= primary then
			local w = Instance.new("WeldConstraint")
			w.Part0 = primary
			w.Part1 = desc
			w.Parent = primary
		end
	end
end

-- Builds a physics-safe downhill road segment with guardrails & dashed markings.
-- Returns the top-surface CFrame at the end edge for chaining the next segment.
function NeoRetro.chainRoadSegment(
	parent: Instance,
	startEdgePos: Vector3,
	yawDeg: number,
	pitchDeg: number,
	length: number,
	width: number,
	roadColor: string?
): (Model, CFrame)
	local model = Instance.new("Model")
	model.Name = "RoadSegment"
	model.Parent = parent

	-- Drop -0.04 along Y so cars never snag an upward seam lip at high speed
	local segTopStartCF = CFrame.new(startEdgePos + Vector3.new(0, -0.04, 0))
		* CFrame.Angles(0, math.rad(yawDeg), 0)
		* CFrame.Angles(-math.rad(pitchDeg), 0, 0)

	local thickness = 4
	local roadCF = segTopStartCF * CFrame.new(0, -thickness / 2, -length / 2)

	local road = NeoRetro.makePart({
		Name = "RoadDeck",
		Size = Vector3.new(width, thickness, length),
		CFrame = roadCF,
		Color = roadColor or "Black",
		Material = Enum.Material.SmoothPlastic,
		TopSurface = Enum.SurfaceType.Smooth,
		BottomSurface = Enum.SurfaceType.Studs,
		Parent = model,
	})
	model.PrimaryPart = road

	-- Dashed retro lane center stripes
	local stripeStep = 16
	for z = 8, length - 8, stripeStep do
		NeoRetro.makePart({
			Name = "LaneStripe",
			Size = Vector3.new(1.5, 0.1, 8),
			CFrame = segTopStartCF * CFrame.new(0, 0.05, -z),
			Color = "Bright yellow",
			Material = Enum.Material.SmoothPlastic,
			TopSurface = Enum.SurfaceType.Smooth,
			CanCollide = false,
			Parent = model,
		})
	end

	-- Guardrails on left and right edges (8 studs tall)
	local railHeight = 8
	local railThick = 2
	for _, sideSign in ipairs({ -1, 1 }) do
		local xOff = sideSign * (width / 2 + railThick / 2)
		NeoRetro.makePart({
			Name = if sideSign < 0 then "GuardrailLeft" else "GuardrailRight",
			Size = Vector3.new(railThick, railHeight, length),
			CFrame = segTopStartCF * CFrame.new(xOff, railHeight / 2 - 1, -length / 2),
			Color = "Medium stone grey",
			Material = Enum.Material.Plastic,
			TopSurface = Enum.SurfaceType.Studs,
			SideSurface = Enum.SurfaceType.Weld,
			Parent = model,
		})

		-- Contrasting hazard top rail
		NeoRetro.makePart({
			Name = "HazardCap",
			Size = Vector3.new(railThick + 0.5, 1, length),
			CFrame = segTopStartCF * CFrame.new(xOff, railHeight - 0.5, -length / 2),
			Color = "Bright orange",
			Material = Enum.Material.Plastic,
			TopSurface = Enum.SurfaceType.Studs,
			Parent = model,
		})
	end

	local endTopCF = segTopStartCF * CFrame.new(0, 0, -length)
	return model, endTopCF
end

-- Launches cars traveling along -Z (WedgePart rotated 180 deg around Y)
function NeoRetro.buildRamp(parent: Instance, roadTopCF: CFrame, width: number, length: number, height: number): Model
	local m = Instance.new("Model")
	m.Name = "RetroRamp"
	m.Parent = parent

	local wedge = Instance.new("WedgePart")
	wedge.Name = "RampSlope"
	wedge.Size = Vector3.new(width, height, length)
	wedge.CFrame = roadTopCF * CFrame.new(0, height / 2, 0) * CFrame.Angles(0, math.pi, 0)
	wedge.Anchored = true
	wedge.Material = Enum.Material.Plastic
	wedge.BrickColor = BrickColor.new("Bright orange")
	wedge.TopSurface = Enum.SurfaceType.Studs
	wedge.Parent = m

	-- Neon launch trim strip at the top lip
	NeoRetro.makePart({
		Name = "LaunchLipNeon",
		Size = Vector3.new(width, 0.5, 1),
		CFrame = roadTopCF * CFrame.new(0, height - 0.25, -length / 2 + 0.5),
		Color = "Bright yellow",
		Material = Enum.Material.Neon,
		TopSurface = Enum.SurfaceType.Smooth,
		CanCollide = false,
		Parent = m,
	})

	m.PrimaryPart = wedge
	return m
end

function NeoRetro.buildBoostPad(parent: Instance, roadTopCF: CFrame, width: number, length: number, boostSpeed: number): Part
	return NeoRetro.makePart({
		Name = "BoostPad",
		Size = Vector3.new(width, 0.2, length),
		CFrame = roadTopCF * CFrame.new(0, 0.1, 0),
		Color = "Lime green",
		Material = Enum.Material.Neon,
		TopSurface = Enum.SurfaceType.Smooth,
		CanCollide = false,
		Tags = { "BoostPad" },
		Attributes = { BoostSpeed = boostSpeed, Duration = 1.5 },
		Parent = parent,
	})
end

function NeoRetro.buildExplosiveBarrel(parent: Instance, worldCF: CFrame): Model
	local m = Instance.new("Model")
	m.Name = "ExplosiveBarrel"
	m.Parent = parent

	local body = NeoRetro.makePart({
		Name = "BarrelBody",
		Size = Vector3.new(5, 3.5, 3.5), -- Cylinder length is on X axis in Roblox
		CFrame = worldCF * CFrame.new(0, 2.5, 0) * CFrame.Angles(0, 0, math.rad(90)),
		Shape = Enum.PartType.Cylinder,
		Color = "Bright red",
		Material = Enum.Material.Metal,
		Anchored = false,
		Tags = { "Explosive", "Breakable" },
		Attributes = { BlastRadius = 24, BlastForce = 120, ScoreValue = 150 },
		Parent = m,
	})

	for _, yOff in ipairs({ 1.0, 4.0 }) do
		NeoRetro.makePart({
			Name = "BarrelRing",
			Size = Vector3.new(0.4, 3.7, 3.7),
			CFrame = worldCF * CFrame.new(0, yOff, 0) * CFrame.Angles(0, 0, math.rad(90)),
			Shape = Enum.PartType.Cylinder,
			Color = "Really black",
			Material = Enum.Material.SmoothPlastic,
			Anchored = false,
			Parent = m,
		})
	end

	NeoRetro.makePart({
		Name = "FuseBeacon",
		Size = Vector3.new(1, 1, 1),
		CFrame = worldCF * CFrame.new(0, 5.2, 0),
		Color = "Bright yellow",
		Material = Enum.Material.Neon,
		TopSurface = Enum.SurfaceType.Smooth,
		Anchored = false,
		Parent = m,
	})

	NeoRetro.weldAssembly(m, body)
	return m
end

function NeoRetro.buildBreakableBrickWall(
	parent: Instance,
	roadTopCF: CFrame,
	cols: number,
	rows: number,
	brickW: number,
	brickH: number
): Model
	local m = Instance.new("Model")
	m.Name = "BreakableBrickWall"
	m.Parent = parent

	local totalW = cols * brickW
	for r = 1, rows do
		local stagger = if r % 2 == 0 then brickW * 0.25 else 0
		for c = 1, cols do
			local x = -totalW / 2 + (c - 0.5) * brickW + stagger
			local y = (r - 0.5) * brickH
			NeoRetro.makePart({
				Name = "Brick",
				Size = Vector3.new(brickW - 0.1, brickH - 0.05, 2.5),
				CFrame = roadTopCF * CFrame.new(x, y, 0),
				Color = if (r + c) % 2 == 0 then "Bright red" else "Reddish brown",
				Material = Enum.Material.Plastic,
				TopSurface = Enum.SurfaceType.Studs,
				BottomSurface = Enum.SurfaceType.Inlet,
				Anchored = false,
				Tags = { "Breakable" },
				Attributes = { ScoreValue = 25 },
				Parent = m,
			})
		end
	end

	return m
end

function NeoRetro.buildRetroPine(parent: Instance, worldCF: CFrame, scale: number?): Model
	local s = scale or 1
	local m = Instance.new("Model")
	m.Name = "RetroPine"
	m.Parent = parent

	local trunk = NeoRetro.makePart({
		Name = "Trunk",
		Size = Vector3.new(4 * s, 12 * s, 4 * s),
		CFrame = worldCF * CFrame.new(0, 6 * s, 0),
		Color = "Reddish brown",
		Material = Enum.Material.Plastic,
		TopSurface = Enum.SurfaceType.Studs,
		Parent = m,
	})
	m.PrimaryPart = trunk

	local tiers = {
		{ y = 12, w = 16, h = 4, c = "Earth green" },
		{ y = 16, w = 12, h = 4, c = "Dark green" },
		{ y = 20, w = 8, h = 4, c = "Earth green" },
		{ y = 24, w = 4, h = 4, c = "Dark green" },
	}
	for i, t in ipairs(tiers) do
		NeoRetro.makePart({
			Name = "FoliageTier" .. i,
			Size = Vector3.new(t.w * s, t.h * s, t.w * s),
			CFrame = worldCF * CFrame.new(0, (t.y + t.h / 2) * s, 0),
			Color = t.c,
			Material = Enum.Material.Plastic,
			TopSurface = Enum.SurfaceType.Studs,
			Parent = m,
		})
	end

	return m
end

function NeoRetro.buildOverheadGantry(parent: Instance, roadTopCF: CFrame, spanWidth: number, clearanceY: number)
	local m = Instance.new("Model")
	m.Name = "OverheadGantry"
	m.Parent = parent

	for _, sideSign in ipairs({ -1, 1 }) do
		local truss = Instance.new("TrussPart")
		truss.Name = "GantryPillar"
		truss.Size = Vector3.new(4, clearanceY, 4)
		truss.CFrame = roadTopCF * CFrame.new(sideSign * (spanWidth / 2 + 3), clearanceY / 2, 0)
		truss.Anchored = true
		truss.BrickColor = BrickColor.new("Medium stone grey")
		truss.Material = Enum.Material.Metal
		truss.Parent = m
	end

	local beam = NeoRetro.makePart({
		Name = "CrossBeam",
		Size = Vector3.new(spanWidth + 10, 4, 4),
		CFrame = roadTopCF * CFrame.new(0, clearanceY + 2, 0),
		Color = "Dark stone grey",
		Material = Enum.Material.Plastic,
		TopSurface = Enum.SurfaceType.Studs,
		SideSurface = Enum.SurfaceType.Weld,
		Parent = m,
	})
	m.PrimaryPart = beam

	-- Retro hazard trim strip
	NeoRetro.makePart({
		Name = "SignTrim",
		Size = Vector3.new(spanWidth * 0.6, 2.5, 4.5),
		CFrame = roadTopCF * CFrame.new(0, clearanceY + 2, 0),
		Color = "Bright yellow",
		Material = Enum.Material.Neon,
		TopSurface = Enum.SurfaceType.Smooth,
		CanCollide = false,
		Parent = m,
	})

	return m
end

return NeoRetro
