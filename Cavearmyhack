local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local SafeGuiParent = (gethui and gethui()) or CoreGui:FindFirstChild("RobloxGui") or LocalPlayer:WaitForChild("PlayerGui")

local function LoadMainScript()
    if not workspace or workspace == nil then
        workspace = game:GetService("Workspace")
    end

    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Teams = game:GetService("Teams")
    local Camera = workspace.CurrentCamera
    local Lighting = game:GetService("Lighting")

    pcall(function()
        Lighting.GlobalShadows = false
        Camera.FieldOfView = 90
    end)

    local oldGui = SafeGuiParent:FindFirstChild("CaveMenu_Classic_Pure_Final")
    if oldGui then oldGui:Destroy() end

    local CaveGui = Instance.new("ScreenGui")
    CaveGui.Name = "CaveMenu_Classic_Pure_Final"
    CaveGui.ResetOnSpawn = false
    CaveGui.Parent = SafeGuiParent

    -- 메인 프레임 (가로형, 콤팩트 사이즈)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 420, 0, 220)
    Frame.Position = UDim2.new(0.5, -210, 0.7, -110)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    Frame.BackgroundTransparency = 0.05
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Visible = true
    Frame.Parent = CaveGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Frame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(60, 60, 65)
    UIStroke.Thickness = 1
    UIStroke.Parent = Frame

    -- 상단 타이틀 (크기 축소)
    local TitleFrame = Instance.new("Frame")
    TitleFrame.Size = UDim2.new(1, 0, 0, 35)
    TitleFrame.BackgroundTransparency = 1
    TitleFrame.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "HCS PREMIUM SCRIPT"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextSize = 13
    Title.Font = Enum.Font.GothamBold
    Title.Parent = TitleFrame
    
    local TitleLine = Instance.new("Frame")
    TitleLine.Size = UDim2.new(1, -20, 0, 1)
    TitleLine.Position = UDim2.new(0, 10, 1, -1)
    TitleLine.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    TitleLine.BorderSizePixel = 0
    TitleLine.Parent = TitleFrame

    local function makeDraggable(guiObject)
        local isDragging, dragStart, startPos
        guiObject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                dragStart = input.Position
                startPos = guiObject.AbsolutePosition
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                local newX = math.clamp(startPos.X + delta.X, 0, Camera.ViewportSize.X - guiObject.AbsoluteSize.X)
                local newY = math.clamp(startPos.Y + delta.Y, 0, Camera.ViewportSize.Y - guiObject.AbsoluteSize.Y)
                guiObject.Position = UDim2.new(0, newX, 0, newY)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
            end
        end)
    end
    makeDraggable(Frame)

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
    ToggleBtn.Position = UDim2.new(0, 20, 0.7, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    ToggleBtn.BackgroundTransparency = 0.1
    ToggleBtn.Text = "HCS"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 12
    ToggleBtn.Parent = CaveGui
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = ToggleBtn
    
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(70, 70, 75)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = ToggleBtn
    makeDraggable(ToggleBtn)

    ToggleBtn.Activated:Connect(function()
        Frame.Visible = not Frame.Visible
    end)

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1, -20, 1, -45)
    ScrollingFrame.Position = UDim2.new(0, 10, 0, 38)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.ScrollBarThickness = 3
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Parent = Frame

    -- 세로 리스트 대신 그리드 레이아웃(가로 2단) 사용
    local UIGridLayout = Instance.new("UIGridLayout")
    UIGridLayout.Parent = ScrollingFrame
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.CellSize = UDim2.new(0, 192, 0, 32)
    UIGridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
    
    UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIGridLayout.AbsoluteContentSize.Y + 10)
    end)

    local infAmmoEnabled, fireRateEnabled, recoilEnabled, damageEnabled, hitboxEnabled, espEnabled = false, false, false, false, false, false
    local noclipEnabled, AntiArrestEnabled, aimbotEnabled, flyEnabled, speedEnabled = false, false, false, false, false
    local hitboxSize = 10
    local backupData, espObjects = {}, {}
    local flySpeed = 50

    RunService.Stepped:Connect(function()
        if speedEnabled and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.MoveDirection.Magnitude > 0 then
                root.CFrame = root.CFrame + (hum.MoveDirection * 0.4)
            end
        end
    end)

    RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                local hue = (tick() * 5) % 1
                for _, part in pairs(tool:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Color = Color3.fromHSV(hue, 1, 1)
                        part.Material = Enum.Material.Neon
                        part.Transparency = 0
                    end
                end
            end
        end
    end)

    local pLib = { bv = nil, bg = nil }
    local function toggleFly(state)
        flyEnabled = state
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local rootPart = char.HumanoidRootPart
        local humanoid = char:FindFirstChildOfClass("Humanoid")

        if flyEnabled then
            pLib.bv = Instance.new("BodyVelocity")
            pLib.bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            pLib.bv.Velocity = Vector3.new(0, 0, 0)
            pLib.bv.Parent = rootPart

            pLib.bg = Instance.new("BodyGyro")
            pLib.bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            pLib.bg.CFrame = rootPart.CFrame
            pLib.bg.Parent = rootPart

            if humanoid then humanoid.PlatformStand = true end
        else
            if pLib.bv then pLib.bv:Destroy() pLib.bv = nil end
            if pLib.bg then pLib.bg:Destroy() pLib.bg = nil end
            if humanoid then humanoid.PlatformStand = false end
        end
    end

    RunService.RenderStepped:Connect(function()
        if flyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if pLib.bv and pLib.bg then
                pLib.bg.CFrame = Camera.CFrame
                local moveDir = LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MoveDirection
                if moveDir.Magnitude > 0 then
                    local forwardVec = Camera.CFrame.LookVector
                    local dotForward = moveDir.Unit:Dot(Vector3.new(forwardVec.X, 0, forwardVec.Z).Unit)
                    pLib.bv.Velocity = Vector3.new(moveDir.X, forwardVec.Y * dotForward, moveDir.Z).Unit * flySpeed
                else
                    pLib.bv.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end)

    local function processTool(tool)
        if not tool:IsA("Tool") then return end
        tool.Equipped:Connect(function() Camera.FieldOfView = 90 end)

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
                        rpm = data.rpm, reload_time = data.reload_time, equip_time = data.equip_time, fire_mode = data.fire_mode,
                        max_ammo = data.max_ammo, max_dist = data.max_dist, ammo = data.ammo,
                        damage = data.damage and {min = data.damage.min, max = data.damage.max, headshot = data.damage.headshot} or nil,
                        recoil = data.recoil and { dir = data.recoil.dir and {X = data.recoil.dir.X, Y = data.recoil.dir.Y} or nil, inout = data.recoil.inout, rotation = data.recoil.rotation } or nil,
                        spread = data.spread and { min = data.spread.min, max = data.spread.max, min_running = data.spread.min_running, mult_running = data.spread.mult_running, running = data.spread.running, jumping = data.spread.jumping } or nil
                    }
                end
                local b = backupData[info]

                if fireRateEnabled then
                    data.rpm, data.reload_time, data.equip_time, data.fire_mode = 6974, 0, 0, 0
                else
                    data.rpm, data.reload_time, data.equip_time, data.fire_mode = b.rpm, b.reload_time, b.equip_time, b.fire_mode
                end

                if recoilEnabled then
                    if data.recoil then
                        if data.recoil.dir then
                            if data.recoil.dir.X then data.recoil.dir.X = {0,0} end
                            if data.recoil.dir.Y then data.recoil.dir.Y = {0,0} end
                        end
                        if data.recoil.inout then data.recoil.inout = {0,0} end
                        if data.recoil.rotation then data.recoil.rotation = 0 end
                    end
                    if data.spread then
                        data.spread.min, data.spread.max, data.spread.min_running, data.spread.mult_running, data.spread.running, data.spread.jumping = 0, 0, 0, 0, 0, 0
                    end
                else
                    if data.recoil and b.recoil then
                        if data.recoil.dir and b.recoil.dir then
                            if data.recoil.dir.X then data.recoil.dir.X = b.recoil.dir.X end
                            if data.recoil.dir.Y then data.recoil.dir.Y = b.recoil.dir.Y end
                        end
                        if data.recoil.inout then data.recoil.inout = b.recoil.inout end
                        if data.recoil.rotation then data.recoil.rotation = b.recoil.rotation end
                    end
                    if data.spread and b.spread then
                        data.spread.min, data.spread.max, data.spread.min_running, data.spread.mult_running, data.spread.running, data.spread.jumping = b.spread.min, b.spread.max, b.spread.min_running, b.spread.mult_running, b.spread.running, b.spread.jumping
                    end
                end

                if infAmmoEnabled then
                    data.max_ammo, data.max_dist, data.ammo = math.huge, 999999, math.huge
                else
                    data.max_ammo, data.max_dist, data.ammo = b.max_ammo, b.max_dist, b.ammo
                end

                if damageEnabled then
                    if data.damage then data.damage.min, data.damage.max, data.damage.headshot = 250, 250, 300 end
                else
                    if data.damage and b.damage then data.damage.min, data.damage.max, data.damage.headshot = b.damage.min, b.damage.max, b.damage.headshot end
                end
            end
        end
    end

    task.spawn(function()
        while true do
            task.wait(2.0)
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if backpack then for _, obj in pairs(backpack:GetChildren()) do pcall(processTool, obj) end end
            local character = LocalPlayer.Character
            if character then for _, obj in pairs(character:GetChildren()) do pcall(processTool, obj) end end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(1.0)
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local root = player.Character:FindFirstChild("HumanoidRootPart")
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    if root and root:IsA("BasePart") and hum then
                        if hitboxEnabled and hum.Health > 0 then
                            root.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                            root.Transparency = 0.7
                            root.Color = player.TeamColor and player.TeamColor.Color or Color3.fromRGB(0, 170, 255)
                            root.Material = Enum.Material.Neon
                            root.CanCollide = false
                        else
                            root.Size = Vector3.new(2, 2, 1)
                            root.Transparency = 1
                            root.CanCollide = true
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
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.Enabled = espEnabled
            hl.Adornee = char
            hl.Parent = char
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
            if AntiArrestEnabled and (msg:find("영창") or msg:find("체포")) and (msg:find(LocalPlayer.Name) or msg:find(LocalPlayer.DisplayName)) then
                LocalPlayer:Kick("안전 탈주!")
            end
        end)
    end
    for _, p in pairs(Players:GetPlayers()) do setupChat(p) end
    Players.PlayerAdded:Connect(setupChat)

    local function getClosestPlayer()
        local closestPlayer = nil
        local shortestDistance = math.huge
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local rootPart = player.Character.HumanoidRootPart
                    local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                    if onScreen then
                        local rayParams = RaycastParams.new()
                        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                        rayParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
                        if not workspace:Raycast(Camera.CFrame.Position, rootPart.Position - Camera.CFrame.Position, rayParams) then
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                closestPlayer = player
                            end
                        end
                    end
                end
            end
        end
        return closestPlayer
    end

    RunService.RenderStepped:Connect(function()
        if aimbotEnabled then
            local target = getClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end
    end)

    -- [핵심] 초고퀄리티 iOS 스타일 스위치 토글 함수 (크기 축소)
    local function addToggle(text, callback)
        local Row = Instance.new("Frame")
        Row.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        Row.BorderSizePixel = 0
        Row.Parent = ScrollingFrame

        local RowCorner = Instance.new("UICorner")
        RowCorner.CornerRadius = UDim.new(0, 6)
        RowCorner.Parent = Row

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -50, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(220, 220, 220)
        Label.TextSize = 12
        Label.Font = Enum.Font.GothamSemibold
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Row

        local ToggleContainer = Instance.new("TextButton")
        ToggleContainer.Size = UDim2.new(0, 36, 0, 18)
        ToggleContainer.Position = UDim2.new(1, -44, 0.5, -9)
        ToggleContainer.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
        ToggleContainer.Text = ""
        ToggleContainer.Parent = Row
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(1, 0)
        ToggleCorner.Parent = ToggleContainer

        local ToggleCircle = Instance.new("Frame")
        ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
        ToggleCircle.Position = UDim2.new(0, 2, 0.5, -7)
        ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleCircle.Parent = ToggleContainer
        
        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(1, 0)
        CircleCorner.Parent = ToggleCircle
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local state = false

        ToggleContainer.Activated:Connect(function()
            state = not state
            
            local goalCircle = {}
            local goalBG = {}

            if state then
                goalCircle.Position = UDim2.new(1, -16, 0.5, -7)
                goalBG.BackgroundColor3 = Color3.fromRGB(76, 217, 100)
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                goalCircle.Position = UDim2.new(0, 2, 0.5, -7)
                goalBG.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
                Label.TextColor3 = Color3.fromRGB(220, 220, 220)
            end

            TweenService:Create(ToggleCircle, tweenInfo, goalCircle):Play()
            TweenService:Create(ToggleContainer, tweenInfo, goalBG):Play()
            
            callback(state)
        end)
    end

    -- [핵심] 초고퀄리티 버튼 함수 (크기 축소)
    local function addButton(text, callback)
        local Btn = Instance.new("TextButton")
        Btn.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
        Btn.Text = text
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 12
        Btn.Parent = ScrollingFrame
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Btn
        
        Btn.Activated:Connect(function()
            local originalColor = Btn.BackgroundColor3
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70, 120, 255)}):Play()
            task.wait(0.1)
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = originalColor}):Play()
            callback()
        end)
    end

    addToggle("무한 탄약", function(v) infAmmoEnabled = v end)
    addToggle("빠른 연사력", function(v) fireRateEnabled = v end)
    addToggle("반동 제거", function(v) recoilEnabled = v end)
    addToggle("즉사 데미지", function(v) damageEnabled = v end)
    addToggle("몸통 히트박스", function(v) hitboxEnabled = v end)
    addToggle("위치 표시 ESP", function(v) espEnabled = v for _, hl in pairs(espObjects) do if hl then hl.Enabled = v end end end)
    addToggle("Noclip 통과", function(v) noclipEnabled = v end)
    addToggle("안티 영창탈주", function(v) AntiArrestEnabled = v end)
    addToggle("에임봇 (Aimbot)", function(v) aimbotEnabled = v end)
    addToggle("Fly (날기)", function(v) toggleFly(v) end)
    addToggle("스피드 40", function(v) speedEnabled = v end)

    addButton("영창탈출", function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(181.74, 171.86, 161.39)
        end
    end)

    addButton("레이더 팀 변경", function()
        local t = Teams:FindFirstChild("레이더")
        if t then
            LocalPlayer.Team = t
            LocalPlayer.TeamColor = t.TeamColor
        end
    end)

    -- 히트박스 크기 조절 모던 인풋 (크기 축소)
    local InputFrame = Instance.new("Frame")
    InputFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    InputFrame.Parent = ScrollingFrame

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = InputFrame

    local InputLabel = Instance.new("TextLabel")
    InputLabel.Size = UDim2.new(0.6, 0, 1, 0)
    InputLabel.Position = UDim2.new(0, 12, 0, 0)
    InputLabel.BackgroundTransparency = 1
    InputLabel.Text = "히트박스 크기"
    InputLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    InputLabel.Font = Enum.Font.GothamSemibold
    InputLabel.TextSize = 12
    InputLabel.TextXAlignment = Enum.TextXAlignment.Left
    InputLabel.Parent = InputFrame

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0, 50, 0, 22)
    TextBox.Position = UDim2.new(1, -58, 0.5, -11)
    TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TextBox.Text = "10"
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.Font = Enum.Font.GothamBold
    TextBox.TextSize = 11
    TextBox.ClearTextOnFocus = false
    TextBox.Parent = InputFrame
    
    local TBBoxCorner = Instance.new("UICorner")
    TBBoxCorner.CornerRadius = UDim.new(0, 4)
    TBBoxCorner.Parent = TextBox

    TextBox.FocusLost:Connect(function()
        local num = tonumber(TextBox.Text)
        if num then
            hitboxSize = math.clamp(num, 2, 100)
            TextBox.Text = tostring(hitboxSize)
        else
            TextBox.Text = tostring(hitboxSize)
        end
    end)
end

LoadMainScript()
