if not workspace or workspace == nil then
    workspace = game:GetService("Workspace")
end

local oldGui = game:GetService("CoreGui"):FindFirstChild("OEA_AnimationGui")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CXH_AnimationGui"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.IgnoreGuiInset = true

local ShadowText = Instance.new("TextLabel")
ShadowText.Size = UDim2.new(0, 1200, 0, 300)
ShadowText.Position = UDim2.new(0.5, 5, 0.5, 5)
ShadowText.AnchorPoint = Vector2.new(0.5, 0.5)
ShadowText.BackgroundTransparency = 1
ShadowText.Text = "CXH"
ShadowText.TextColor3 = Color3.fromRGB(0, 0, 0)
ShadowText.TextSize = 140
ShadowText.Font = Enum.Font.GothamBlack
ShadowText.ZIndex = 1
ShadowText.Parent = ScreenGui

local MainText = Instance.new("TextLabel")
MainText.Size = UDim2.new(0, 1200, 0, 300)
MainText.Position = UDim2.new(0.5, 0, 0.5, 0)
MainText.AnchorPoint = Vector2.new(0.5, 0.5)
MainText.BackgroundTransparency = 1
MainText.Text = "CXH"
MainText.TextColor3 = Color3.fromRGB(255, 255, 255)
MainText.TextSize = 140
MainText.Font = Enum.Font.GothamBlack
MainText.ZIndex = 2
MainText.Parent = ScreenGui

local TextGradient = Instance.new("UIGradient")
TextGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 235, 245))
})
TextGradient.Parent = MainText

local ShadowGradient = Instance.new("UIGradient")
ShadowGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
ShadowGradient.Parent = ShadowText

TextGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 1)})
ShadowGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 1)})

for i = 0, 80 do
    local progress = i / 80
    local p1 = math.clamp(progress, 0.001, 0.998)
    local p2 = math.clamp(progress + 0.001, 0.002, 0.999)
    local seq = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(p1, 0),
        NumberSequenceKeypoint.new(p2, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
    TextGradient.Transparency = seq
    ShadowGradient.Transparency = seq
    task.wait(0.015)
end

TextGradient.Transparency = NumberSequence.new(0)
ShadowGradient.Transparency = NumberSequence.new(0)
task.wait(1.5)

for i = 0, 25 do
    local progress = i / 25
    local p1 = math.clamp(progress, 0.001, 0.998)
    local p2 = math.clamp(progress + 0.001, 0.002, 0.999)
    local seq = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(p1, 1),
        NumberSequenceKeypoint.new(p2, 0),
        NumberSequenceKeypoint.new(1, 0)
    })
    TextGradient.Transparency = seq
    ShadowGradient.Transparency = seq
    task.wait(0.008)
end

MainText:Destroy()
ShadowText:Destroy()
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(0, 650, 0, 30)
TopBar.Position = UDim2.new(0.5, 0, 0.06, 0)
TopBar.AnchorPoint = Vector2.new(0.5, 0.5)
TopBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TopBar.BackgroundTransparency = 1
TopBar.BorderSizePixel = 0
TopBar.Parent = ScreenGui

local BarText = Instance.new("TextLabel")
BarText.Size = UDim2.new(1, -20, 1, 0)
BarText.Position = UDim2.new(0.5, 0, 0.5, 0)
BarText.AnchorPoint = Vector2.new(0.5, 0.5)
BarText.BackgroundTransparency = 1
BarText.Text = ""
BarText.TextColor3 = Color3.fromRGB(255, 255, 255)
BarText.TextSize = 14
BarText.Font = Enum.Font.GothamMedium
BarText.TextTransparency = 1
BarText.Parent = TopBar

local TweenService = game:GetService("TweenService")
local fadeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local notices = {
    "⚠️ 본 스크립트를 불법 배포시 처벌받습니다.",
    "⚠️ 계정이 밴이 될수 있으니 조심히 사용해 주세요.",
    "💖 사용하시고 디스코드에 후기를 남겨주세요!"
}

TweenService:Create(TopBar, fadeInfo, {BackgroundTransparency = 0.45}):Play()
task.wait(0.4)

for idx, textContent in ipairs(notices) do
    BarText.Text = textContent
    TweenService:Create(BarText, fadeInfo, {TextTransparency = 0}):Play()
    task.wait(2.5)

    if idx < #notices then
        local fadeOutText = TweenService:Create(BarText, fadeInfo, {TextTransparency = 1})
        fadeOutText:Play()
        fadeOutText.Completed:Wait()
    end
end

local hideBar = TweenService:Create(TopBar, fadeInfo, {BackgroundTransparency = 1})
local hideText = TweenService:Create(BarText, fadeInfo, {TextTransparency = 1})

hideBar:Play()
hideText:Play()
hideBar.Completed:Wait()

ScreenGui:Destroy()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Teams = game:GetService("Teams")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local CaveGui = Instance.new("ScreenGui")
CaveGui.Name = "CaveMenu_Classic_Pure_Final"
CaveGui.ResetOnSpawn = false
CaveGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 520, 0, 360)
Frame.Position = UDim2.new(0.5, -260, 0.5, -180)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.4
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Visible = true
Frame.Parent = CaveGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "HCS SCRIPT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "[ ` ] 키를 눌러 Menu를 열거나 닫으세요"
Footer.TextColor3 = Color3.fromRGB(200, 200, 200)
Footer.TextSize = 12
Footer.Font = Enum.Font.SourceSans
Footer.Parent = Frame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -30, 1, -85)
ScrollingFrame.Position = UDim2.new(0, 15, 0, 50)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.Parent = Frame

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.Parent = ScrollingFrame
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.CellSize = UDim2.new(0, 155, 0, 55)
UIGridLayout.CellPadding = UDim2.new(0, 12, 0, 12)

local infAmmoEnabled, fireRateEnabled, recoilEnabled, damageEnabled, hitboxEnabled, espEnabled = false, false, false, false, false, false
local noclipEnabled, AntiArrestEnabled = false, false
local hitboxSize = 10
local backupData, espObjects = {}, {}
local function processTool(tool)
    if not tool:IsA("Tool") then return end
    if infAmmoEnabled then
        tool:SetAttribute("ammo", 999999)
        tool:SetAttribute("max_ammo", 999999)
        local ammoObj = tool:FindFirstChild("ammo") or tool:FindFirstChild("Ammo")
        if ammoObj and ammoObj:IsA("ValueBase") then ammoObj.Value = 999999 end
        local maxAmmoObj = tool:FindFirstChild("max_ammo") or tool:FindFirstChild("MaxAmmo")
        if maxAmmoObj and maxAmmoObj:IsA("ValueBase") then maxAmmoObj.Value = 999999 end
    end
    local info = tool:FindFirstChild("Info")
    if info and info:IsA("ModuleScript") then
        local ok, data = pcall(require, info)
        if ok and type(data) == "table" then
            if not backupData[info] then
                backupData[info] = {
                    rpm = data.rpm, reload_time = data.reload_time, equip_time = data.equip_time, fire_mode = data.fire_mode, max_ammo = data.max_ammo, max_dist = data.max_dist, ammo = data.ammo,
                    damage = data.damage and {min = data.damage.min, max = data.damage.max, headshot = data.damage.headshot} or nil,
                    recoil = data.recoil and { dir = data.recoil.dir and {X = data.recoil.dir.X, Y = data.recoil.dir.Y} or nil, inout = data.recoil.inout, rotation = data.recoil.rotation } or nil,
                    spread = data.spread and { min = data.spread.min, max = data.spread.max, min_running = data.spread.min_running, mult_running = data.spread.mult_running, running = data.spread.running, jumping = data.spread.jumping } or nil
                }
            end
            local b = backupData[info]
            if fireRateEnabled then data.rpm = 6974; data.reload_time = 0; data.equip_time = 0; data.fire_mode = 0 else data.rpm = b.rpm; data.reload_time = b.reload_time; data.equip_time = b.equip_time; data.fire_mode = b.fire_mode end
            if recoilEnabled then
                if data.recoil then
                    if data.recoil.dir then if data.recoil.dir.X then data.recoil.dir.X = {0,0} end; if data.recoil.dir.Y then data.recoil.dir.Y = {0,0} end end
                    if data.recoil.inout then data.recoil.inout = {0,0} end; if data.recoil.rotation then data.recoil.rotation = 0 end
                end
                if data.spread then data.spread.min, data.spread.max, data.spread.min_running, data.spread.mult_running, data.spread.running, data.spread.jumping = 0, 0, 0, 0, 0, 0 end
            else
                if data.recoil and b.recoil then
                    if data.recoil.dir and b.recoil.dir then if data.recoil.dir.X then data.recoil.dir.X = b.recoil.dir.X end; if data.recoil.dir.Y then data.recoil.dir.Y = b.recoil.dir.Y end end
                    if data.recoil.inout then data.recoil.inout = b.recoil.inout end; if data.recoil.rotation then data.recoil.rotation = b.recoil.rotation end
                end
                if data.spread and b.spread then data.spread.min, data.spread.max, data.spread.min_running, data.spread.mult_running, data.spread.running, data.spread.jumping = b.spread.min, b.spread.max, b.spread.min_running, b.spread.mult_running, b.spread.running, b.spread.jumping end
            end
            if infAmmoEnabled then data.max_ammo, data.max_dist, data.ammo = math.huge, 999999, math.huge else data.max_ammo, data.max_dist, data.ammo = b.max_ammo, b.max_dist, b.ammo end
            if damageEnabled then if data.damage then data.damage.min, data.damage.max, data.damage.headshot = 999999, 999999, 999999 end else if data.damage and b.damage then data.damage.min, data.damage.max, data.damage.headshot = b.damage.min, b.damage.max, b.damage.headshot end end
        end
    end
end

local function updateCurrentTool()
    local char = LocalPlayer.Character
    if char then
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool then
            pcall(processTool, currentTool)
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                currentTool.Parent = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack")
                task.wait(0.02)
                humanoid:EquipTool(currentTool)
            end
        end
    end
end

local function applyToggleState()
    updateCurrentTool()
end

task.spawn(function()
    while true do
        task.wait(0.3)
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then for _, obj in pairs(backpack:GetChildren()) do pcall(processTool, obj) end end
        local character = LocalPlayer.Character
        if character then for _, obj in pairs(character:GetChildren()) do pcall(processTool, obj) end end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.2)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if root and root:IsA("BasePart") then
                    if hitboxEnabled then
                        root.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        root.Transparency = 0.7; root.Color = player.TeamColor and player.TeamColor.Color or Color3.fromRGB(0, 170, 255)
                        root.Material = Enum.Material.Neon; root.CanCollide = false
                    else
                        root.Size = Vector3.new(2, 2, 1); root.Transparency = 1; root.CanCollide = true
                    end
                end
            end
        end
    end
end)

local function applyESP(player)
    if player == LocalPlayer then return end
    local function draw(char)
        if not char then return end
        if espObjects[player] then pcall(function() espObjects[player]:Destroy() end) end
        local hl = Instance.new("Highlight")
        hl.FillColor = player.TeamColor and player.TeamColor.Color or Color3.fromRGB(255, 50, 50)
        hl.FillTransparency = 0.5; hl.OutlineTransparency = 0; hl.Enabled = espEnabled; hl.Adornee = char; hl.Parent = char
        espObjects[player] = hl
    end
    if player.Character then draw(player.Character) end
    player.CharacterAdded:Connect(draw)
end

for _, p in pairs(Players:GetPlayers()) do applyESP(p) end
Players.PlayerAdded:Connect(applyESP)

RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

local function setupChat(p)
    p.Chatted:Connect(function(msg)
        if AntiArrestEnabled and (msg:find("전역소") or msg:find("체포")) and (msg:find(LocalPlayer.Name) or msg:find(LocalPlayer.DisplayName)) then
            LocalPlayer:Kick("병신")
        end
    end)
end
for _, p in pairs(Players:GetPlayers()) do setupChat(p) end
Players.PlayerAdded:Connect(setupChat)

local function addToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0); btn.BackgroundTransparency = 0.5
    btn.Text = text .. "\n[꺼짐]"; btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.SourceSans; btn.TextSize = 12; btn.Parent = ScrollingFrame
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = text .. "\n[켜짐]"; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.BackgroundTransparency = 0.2
        else
            btn.Text = text .. "\n[꺼짐]"; btn.TextColor3 = Color3.fromRGB(200, 200, 200); btn.BackgroundTransparency = 0.5
        end
        callback(state)
        applyToggleState()
    end)
end

local function addButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0); btn.BackgroundTransparency = 0.5
    btn.Text = text; btn.TextColor3 = Color3.fromRGB(255, 255, 100)
    btn.Font = Enum.Font.SourceSansBold; btn.TextSize = 13; btn.Parent = ScrollingFrame
    btn.MouseButton1Click:Connect(callback)
end

addToggle("무한 탄약", function(v) infAmmoEnabled = v end)
addToggle("빠른 연사", function(v) fireRateEnabled = v end)
addToggle("반동 제거", function(v) recoilEnabled = v end)
addToggle("즉사 데미지", function(v) damageEnabled = v end)
addToggle("히트박스", function(v) hitboxEnabled = v end)
addToggle("위치 표시 ESP", function(v) espEnabled = v; for _, hl in pairs(espObjects) do if hl then hl.Enabled = v end end end)
addToggle("Noclip (벽통과)", function(v) noclipEnabled = v end)
addToggle("삭제된기능", function(v) AntiArrestEnabled = v end)

addButton("전역소 가기 [이동]", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.CFrame = CFrame.new(181.74, 171.86, 161.39) end
end)

addButton("레이드 팀 변경", function()
    local t = Teams:FindFirstChild("레이드")
    if t then LocalPlayer.Team = t; LocalPlayer.TeamColor = t.TeamColor end
end)

local InputFrame = Instance.new("Frame")
InputFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0); InputFrame.BackgroundTransparency = 0.5
InputFrame.Parent = ScrollingFrame
local InputCorner = Instance.new("UICorner"); InputCorner.CornerRadius = UDim.new(0, 2); InputCorner.Parent = InputFrame

local InputLabel = Instance.new("TextLabel")
InputLabel.Size = UDim2.new(1, 0, 0, 25); InputLabel.BackgroundTransparency = 1
InputLabel.Text = "히트박스 크기 지정"; InputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InputLabel.Font = Enum.Font.SourceSans; InputLabel.TextSize = 12; InputLabel.Parent = InputFrame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(1, -20, 0, 22); TextBox.Position = UDim2.new(0, 10, 0, 25)
TextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0); TextBox.BackgroundTransparency = 0.3
TextBox.Text = "10"; TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Font = Enum.Font.SourceSansBold
TextBox.TextSize = 13
TextBox.ClearTextOnFocus = false
TextBox.Parent = InputFrame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 2)
BoxCorner.Parent = TextBox

TextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(TextBox.Text)
        if num then
            hitboxSize = math.clamp(num, 2, 100)
            TextBox.Text = tostring(hitboxSize)
        else
            TextBox.Text = tostring(hitboxSize)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Backquote then
        Frame.Visible = not Frame.Visible
    end
end)
