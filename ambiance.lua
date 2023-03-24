local get=function(x)return game:GetService(x)end local players=get('Players')local ws=get('Workspace')local rs=get('ReplicatedStorage')local rus=get('RunService')local uis=get('UserInputService')local coregui=get('CoreGui')local http=get('HttpService')local ts=get('TeleportService')local lighting=get('Lighting')local plr=players.LocalPlayer local char=(plr and (plr.Character or plr.CharacterAdded:Wait())or nil)local hrp=plr and (char:WaitForChild('HumanoidRootPart'))or nil local hum=plr and (char:WaitForChild('Humanoid'))or nil if plr then plr.CharacterAdded:Connect(function(c)char=c hrp=c:WaitForChild'HumanoidRootPart'hum=c:WaitForChild('Humanoid')end)end local cf=CFrame local v3=Vector3 local v2=Vector2 local ud2=UDim2 local c3=Color3 local rgb=c3.fromRGB local step=rus.Stepped local rstep=rus.RenderStepped local heartbeat=rus.Heartbeat local JSON={stringify=function(...)return http:JSONEncode(...)end,parse=function(...)return http:JSONDecode(...)end}local function create(class,parent,props,children)if not class then return end props=props or{}children=children or{}local obj=Instance.new(class,parent)for prop,name in pairs(props)do obj[prop]=name end for _,child in pairs(children)do child.Parent=obj end return obj end
local models = ws.Models
local stadium = models.Stadium

local weather = ws:FindFirstChild('SkyWeather')
if weather then weather:Destroy() end

for i,v in pairs(workspace.Models.Field.Grass:GetDescendants()) do
    if v:IsA("Part") then
        v.Color = Color3.fromRGB(28, 119, 35)
    end
end

local function disableConnections(signal)
    for _,v in next,getconnections(signal) do
        v:Disable()
    end
end
disableConnections(lighting.ChildAdded)
disableConnections(lighting.DescendantAdded)
disableConnections(lighting.Changed)
local lightingProps = {
    Ambient = Color3.fromRGB(255,191,0),
    Brightness = 1.25,
    ColorShift_Bottom = Color3.fromRGB(0,0,65),
    ColorShift_Top = Color3.fromRGB(0,0,65),
    EnvironmentDiffuseScale = 0.3,
    EnvironmentSpecularScale = 0.2,
    GlobalShadows = true,
    OutdoorAmbient = Color3.fromRGB(0,0,0),
    ShadowSoftness = 0.2,
    ClockTime = 24,
    GeographicLatitude = 45,
    ExposureCompensation = 1.3
}
local old_lightingProps = {}
for i,_ in pairs(lightingProps) do
    old_lightingProps[i] = lighting[i]
end
local function oldLighting()
    lighting:ClearAllChildren()
    for i,v in pairs(old_lightingProps) do
        lighting[i] = v
    end
end
local function newLighting()
    sethiddenproperty(lighting,'Technology',Enum.Technology.ShadowMap)
    lighting:ClearAllChildren()
    for i,v in pairs(lightingProps) do
        lighting[i] = v
    end
    local Bloom = create("BloomEffect",lighting,{
        Intensity = 0.3,
        Size = 10,
        Threshold = 0.8
    })
    local Blur = create("BlurEffect",lighting,{
        Size = 2
    })
    local ColorCor = create("ColorCorrectionEffect",lighting,{
        Brightness = 0.1,
        Contrast = 0.1,
        Saturation = .4,
        TintColor = Color3.fromRGB(230,230,230)
    })
    local Atm = create("Atmosphere",lighting,{
        Density = 0.2,
        Offset = 0.556,
        Color = Color3.fromRGB(175, 165, 245),
        Decay = Color3.fromRGB(44, 39, 33),
        Glare = 0.66,
        Haze = 1.72
    })
    --[[ for _,v in pairs(models:GetDescendants()) do
        if v:IsA('BasePart') then
            v.CastShadow = false
        end
    end ]]
end

oldLighting()
newLighting()

game.Lighting.FogStart = 200
game.Lighting.FogEnd = 850
game.Lighting.FogColor = Color3.fromRGB(95, 105, 129)
workspace.Models.Field.Grass.Normal.Mid.SurfaceGui.ImageLabel.Image = "https://www.roblox.com/asset/?id=11488072236"
local function removeStadiumShadows()
    local models = ws.Models
    local stadium = models.Stadium
    for _,v in pairs(stadium:GetDescendants()) do
        if v:IsA('BasePart') then
            if v.Position.Y < 75 then
            v.CastShadow = true
            end
        end
    end
end

removeStadiumShadows()

game.RunService.Stepped:Connect(function()
    for i,v in pairs(game.Players:GetPlayers()) do
        for i,v in pairs(v.Character.Uniform:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Reflectance = 0.05
            end
        end
    end
end)
