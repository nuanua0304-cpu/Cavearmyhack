local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Teams = game:GetService("Teams")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

local SafeGuiParent = (gethui and gethui()) or CoreGui:FindFirstChild("RobloxGui") or LocalPlayer:WaitForChild("PlayerGui")

local function LoadMainScript()
    if not workspace or workspace == nil then
        workspace = game:GetService("Workspace")
    end

    pcall(function() Lighting.GlobalShadows = false; Camera.FieldOfView = 90 end)

    local oldGui = SafeGuiParent:FindFirstChild("HCS_Script_Hub")
    if oldGui then oldGui:Destroy() end

    local HubGui = Instance.new("ScreenGui")
    HubGui.Name = "HCS_Script_Hub"
    HubGui.ResetOnSpawn = false
    HubGui.Parent = SafeGuiParent

    -- [유명 허브 스타일 UI 프레임워크 구축]
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 520, 0, 320)
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Parent = HubGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(45, 45, 45)
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame

    -- 드래그 기능
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
                guiObject.Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
            end
        end)
    end
    makeDraggable(MainFrame)

    -- 상단바 (TopBar)
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 6)
    TopBarCorner.Parent = TopBar
    
    local TopBarCover = Instance.new("Frame") -- 하단 라운드 가리기
    TopBarCover.Size = UDim2.new(1, 0, 0, 10)
    TopBarCover.Position = UDim2.new(0, 0, 1, -10)
    TopBarCover.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TopBarCover.BorderSizePixel = 0
    TopBarCover.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "HCS HUB"
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.Parent = TopBar

    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 1, 0)
    Line.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Line.BorderSizePixel = 0
    Line.Parent = TopBar

    -- 닫기/숨기기 버튼 (우측 상단)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "-"
    CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    CloseBtn.Parent = TopBar
    CloseBtn.Activated:Connect(function() MainFrame.Visible = false end)

    -- 플로팅 아이콘 (숨겼을 때 다시 켜기용)
    local OpenIcon = Instance.new("TextButton")
    OpenIcon.Size = UDim2.new(0, 40, 0, 40)
    OpenIcon.Position = UDim2.new(0, 20, 0.5, 0)
    OpenIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    OpenIcon.Text = "H"
    OpenIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenIcon.Font = Enum.Font.GothamBold
    OpenIcon.TextSize = 18
    OpenIcon.Parent = HubGui
    local OpenCorner = Instance.new("UICorner")
    OpenCorner.CornerRadius = UDim.new(1, 0)
    OpenCorner.Parent = OpenIcon
    local OpenStroke = Instance.new("UIStroke")
    OpenStroke.Color = Color3.fromRGB(70, 130, 255)
    OpenStroke.Thickness = 2
    OpenStroke.Parent = OpenIcon
    makeDraggable(OpenIcon)
    OpenIcon.Activated:Connect(function() MainFrame.Visible = true end)

    -- 좌측 사이드바 (탭 버튼 컨테이너)
    local SideBar = Instance.new("Frame")
    SideBar.Size = UDim2.new(0, 130, 1, -36)
    SideBar.Position = UDim2.new(0, 0, 0, 36)
    SideBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    SideBar.BorderSizePixel = 0
    SideBar.Parent = MainFrame

    local SideLine = Instance.new("Frame")
    SideLine.Size = UDim2.new(0, 1, 1, 0)
    SideLine.Position = UDim2.new(1, 0, 0, 0)
    SideLine.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SideLine.BorderSizePixel = 0
    SideLine.Parent = SideBar

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = SideBar
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabContainer
    TabListLayout.Padding = UDim.new(0, 2)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 8)
    TabPadding.Parent = TabContainer

    -- 우측 콘텐츠 영역
    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -131, 1, -36)
    ContentArea.Position = UDim2.new(0, 131, 0, 36)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame

    -- [라이브러리 논리 구성]
    local tabs = {}
    local function CreateTab(name)
        -- 탭 버튼 생성
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, -12, 0, 30)
        TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 12
        TabBtn.Parent = TabContainer

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 4)
        BtnCorner.Parent = TabBtn

        -- 페이지 생성
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, -16, 1, -16)
        Page.Position = UDim2.new(0, 8, 0, 8)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
        Page.Visible = false
        Page.Parent = ContentArea

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.Padding = UDim.new(0, 6)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
        end)

        -- 탭 전환 로직
        TabBtn.Activated:Connect(function()
            for _, t in pairs(tabs) do
                t.Page.Visible = false
                t.Btn.BackgroundTransparency = 1
                t.Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        table.insert(tabs, {Btn = TabBtn, Page = Page})
        if #tabs == 1 then
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        return Page
    end

    local function CreateToggle(parent, text, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, -6, 0, 36)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        ToggleFrame.Parent = parent
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 4)
        Corner.Parent = ToggleFrame
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Color3.fromRGB(45, 45, 45)
        Stroke.Parent = ToggleFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -60, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(220, 220, 220)
        Label.TextSize = 13
        Label.Font = Enum.Font.GothamMedium
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame

        local SwitchBtn = Instance.new("TextButton")
        SwitchBtn.Size = UDim2.new(0, 40, 0, 20)
        SwitchBtn.Position = UDim2.new(1, -50, 0.5, -10)
        SwitchBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        SwitchBtn.Text = ""
        SwitchBtn.Parent = ToggleFrame
        local SwitchCorner = Instance.new("UICorner")
        SwitchCorner.CornerRadius = UDim.new(1, 0)
        SwitchCorner.Parent = SwitchBtn

        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 16, 0, 16)
        Circle.Position = UDim2.new(0, 2, 0.5, -8)
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.Parent = SwitchBtn
        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(1, 0)
        CircleCorner.Parent = Circle

        local state = false
        local twInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        SwitchBtn.Activated:Connect(function()
            state = not state
            if state then
                TweenService:Create(Circle, twInfo, {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
                TweenService:Create(SwitchBtn, twInfo, {BackgroundColor3 = Color3.fromRGB(0, 130, 255)}):Play()
            else
                TweenService:Create(Circle, twInfo, {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                TweenService:Create(SwitchBtn, twInfo, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            end
            callback(state)
        end)
    end

    local function CreateButton(parent, text, callback)
        local BtnFrame = Instance.new("Frame")
        BtnFrame.Size = UDim2.new(1, -6, 0, 36)
        BtnFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        BtnFrame.Parent = parent
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 4)
        Corner.Parent = BtnFrame
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Color3.fromRGB(45, 45, 45)
        Stroke.Parent = BtnFrame

        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -16, 1, -10)
        Btn.Position = UDim2.new(0, 8, 0, 5)
        Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Btn.Text = text
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.Font = Enum.Font.GothamMedium
        Btn.TextSize = 13
        Btn.Parent = BtnFrame
        local BtnCorner2 = Instance.new("UICorner")
        BtnCorner2.CornerRadius = UDim.new(0, 4)
        BtnCorner2.Parent = Btn

        Btn.Activated:Connect(function()
            local og = Btn.BackgroundColor3
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 130, 255)}):Play()
            task.wait(0.1)
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = og}):Play()
            callback()
        end)
    end

    local function CreateInput(parent, text, default, callback)
        local InputFrame = Instance.new("Frame")
        InputFrame.Size = UDim2.new(1, -6, 0, 36)
        InputFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        InputFrame.Parent = parent
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 4)
        Corner.Parent = InputFrame
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Color3.fromRGB(45, 45, 45)
        Stroke.Parent = InputFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -80, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(220, 220, 220)
        Label.TextSize = 13
        Label.Font = Enum.Font.GothamMedium
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = InputFrame

        local TBox = Instance.new("TextBox")
        TBox.Size = UDim2.new(0, 60, 0, 24)
        TBox.Position = UDim2.new(1, -68, 0.5, -12)
        TBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        TBox.Text = tostring(default)
        TBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        TBox.Font = Enum.Font.GothamBold
        TBox.TextSize = 12
        TBox.ClearTextOnFocus = false
        TBox.Parent = InputFrame
        local TBCorner = Instance.new("UICorner")
        TBCorner.CornerRadius = UDim.new(0, 4)
        TBCorner.Parent = TBox
        local TBStroke = Instance.new("UIStroke")
        TBStroke.Color = Color3.fromRGB(60, 60, 60)
        TBStroke.Parent = TBox

        TBox.FocusLost:Connect(function()
            callback(TBox.Text, TBox)
        end)
    end

    -- ==========================================
    -- 스크립트 기능 변수 및 로직
    -- ==========================================
    local infAmmoEnabled, fireRateEnabled, recoilEnabled, damageEnabled, hitboxEnabled, espEnabled = false, false, false, false, false, false
    local noclipEnabled, AntiArrestEnabled, aimbotEnabled, flyEnabled, speedEnabled, crawlMoveEnabled = false, false, false, false, false, false
    local infHealthEnabled = false
    local healPadConn = nil
    local hitboxSize = 10
    local backupData, espObjects = {}, {}
    local flySpeed = 50

    -- [핵심 로직]
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
        if crawlMoveEnabled and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hum and root then
                hum.PlatformStand = true
                if hum.MoveDirection.Magnitude > 0 then
                    root.CFrame = root.CFrame + (hum.MoveDirection * 0.25)
                end
            end
        else
            if LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.PlatformStand and not flyEnabled then
                    hum.PlatformStand = false
                end
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

    -- [허브 UI 요소 채우기]
    local CombatTab = CreateTab("Combat")
    local MovementTab = CreateTab("Movement")
    local VisualsTab = CreateTab("Visuals")
    local MiscTab = CreateTab("Misc")

    -- Combat
    CreateToggle(CombatTab, "무한 탄약 (Inf Ammo)", function(v) infAmmoEnabled = v end)
    CreateToggle(CombatTab, "빠른 연사력 (Fast Fire)", function(v) fireRateEnabled = v end)
    CreateToggle(CombatTab, "반동 제거 (No Recoil)", function(v) recoilEnabled = v end)
    CreateToggle(CombatTab, "즉사 데미지 (Insta Kill)", function(v) damageEnabled = v end)
    CreateToggle(CombatTab, "무한 체력 (Inf Health)", function(v)
        infHealthEnabled = v
        if infHealthEnabled then
            local healPad = nil
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name == "HealPad" then
                    healPad = obj
                    break
                end
            end
            
            if healPad then
                healPad.Size = Vector3.new(2, healPad.Size.Y, 2)
                healPadConn = RunService.Heartbeat:Connect(function()
                    local char = LocalPlayer.Character
                    local upperTorso = char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
                    if upperTorso and healPad then
                        healPad.CanCollide = false 
                        healPad.CFrame = upperTorso.CFrame
                    end
                end)
            end
        else
            if healPadConn then
                healPadConn:Disconnect()
                healPadConn = nil
            end
        end
    end)
    CreateToggle(CombatTab, "몸통 히트박스 (Hitbox)", function(v) hitboxEnabled = v end)
    CreateInput(CombatTab, "히트박스 크기 (Size)", 10, function(text, box)
        local num = tonumber(text)
        if num then
            hitboxSize = math.clamp(num, 2, 100)
            box.Text = tostring(hitboxSize)
        else
            box.Text = tostring(hitboxSize)
        end
    end)
    CreateToggle(CombatTab, "에임봇 (Aimbot)", function(v) aimbotEnabled = v end)

    -- Movement
    CreateToggle(MovementTab, "스피드 증가 (Speed 40)", function(v) speedEnabled = v end)
    CreateToggle(MovementTab, "날기 (Fly)", function(v) toggleFly(v) end)
    CreateToggle(MovementTab, "노클립 (Noclip)", function(v) noclipEnabled = v end)
    CreateToggle(MovementTab, "누운 채로 이동 (Crawl Move)", function(v) crawlMoveEnabled = v end)

    -- Visuals
    CreateToggle(VisualsTab, "위치 표시 (ESP)", function(v) 
        espEnabled = v 
        for _, hl in pairs(espObjects) do 
            if hl then hl.Enabled = v end 
        end 
    end)

    -- Misc
    CreateToggle(MiscTab, "안티 영창탈주 (Anti-Arrest)", function(v) AntiArrestEnabled = v end)
    CreateButton(MiscTab, "영창 탈출 (Escape Prison)", function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(181.74, 171.86, 161.39)
        end
    end)
    CreateButton(MiscTab, "레이더 팀 변경 (Team Change)", function()
        local t = Teams:FindFirstChild("레이더")
        if t then
            LocalPlayer.Team = t
            LocalPlayer.TeamColor = t.TeamColor
        end
    end)

end

LoadMainScript()
