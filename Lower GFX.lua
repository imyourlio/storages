

local Terrain = workspace:FindFirstChildOfClass("Terrain")
local Lighting = game:GetService("Lighting")

if Terrain then
	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterReflectance = 0
	Terrain.WaterTransparency = 0
end

Lighting.GlobalShadows = false
Lighting.FogEnd = math.huge
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

local function Simplify(obj)
	if obj:IsA("Part") or obj:IsA("UnionOperation") or obj:IsA("MeshPart")
		or obj:IsA("CornerWedgePart") or obj:IsA("TrussPart") then
		obj.Material = Enum.Material.Plastic
		obj.Reflectance = 0

	elseif obj:IsA("Decal") then
		obj.Transparency = 1
        
    elseif obj:IsA("ParticleEmitter") then
        obj.Lifetime = NumberRange.new(0)

    elseif obj:IsA("Trail") then
        obj.Lifetime = 0

	elseif obj:IsA("Explosion") then
		obj.BlastPressure = 1
		obj.BlastRadius = 1

	elseif obj:IsA("Texture") then
		obj.Texture = ""

	elseif obj:IsA("Sky") then
		obj.Parent = nil
	end
end

for _, obj in pairs(game:GetDescendants()) do
	Simplify(obj)
end

for _, effect in pairs(Lighting:GetDescendants()) do
	if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect")
		or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect")
		or effect:IsA("DepthOfFieldEffect") then
		effect.Enabled = false
	end
end

game.DescendantAdded:Connect(function(obj)
	Simplify(obj)
end)

Lighting.ChildAdded:Connect(function(obj)
	if obj:IsA("BlurEffect") or obj:IsA("SunRaysEffect")
		or obj:IsA("ColorCorrectionEffect") or obj:IsA("BloomEffect")
		or obj:IsA("DepthOfFieldEffect") then
		obj.Enabled = false
	else
		Simplify(obj)
	end
end)
