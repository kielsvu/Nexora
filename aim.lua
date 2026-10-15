local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/kielsvu/Nexora/refs/heads/main/Modules/Nexora.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local UserSettings = game:GetService("UserSettings")
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera

task.spawn(function()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.ShadowSoftness = 0
        UserSettings.Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)

    local function disableEffect(instance)
        if instance:IsA("ParticleEmitter") or instance:IsA("Trail") or instance:IsA("Beam") then
            instance.Enabled = false
        elseif instance:IsA("BlurEffect") or instance:IsA("SunRaysEffect") or instance:IsA("DepthOfFieldEffect") or instance:IsA("BloomEffect") or instance:IsA("ColorCorrectionEffect") then
            instance.Enabled = false
        end
    end

    for _, child in ipairs(Lighting:GetChildren()) do
        pcall(disableEffect, child)
    end

    local scanned = 0
    for _, descendant in ipairs(workspace:GetDescendants()) do
        pcall(disableEffect, descendant)
        scanned = scanned + 1
        if scanned >= 5000 then break end
    end

    workspace.DescendantAdded:Connect(function(descendant) pcall(disableEffect, descendant) end)
    Lighting.DescendantAdded:Connect(function(descendant) pcall(disableEffect, descendant) end)
end)

local Settings = {
    AimbotEnabled = false,
    TeamCheck = true,
    WallCheck = true,
    Smoothness = 0,
    TargetPart = "Head",
    FOVCircleSize = 150,
    ESPHighlight = false,
    ESPTracer = false,
    ESPDistance = false,
    ESPMaxDistance = 1000,
    FOVEnabled = false,
    FOVValue = 70,
}

local DefaultFOV = CurrentCamera.FieldOfView

local FieldOfViewCircle = Drawing.new("Circle")
FieldOfViewCircle.Thickness = 2
FieldOfViewCircle.Filled = false
FieldOfViewCircle.Transparency = 1
FieldOfViewCircle.NumSides = 64
FieldOfViewCircle.Radius = Settings.FOVCircleSize
FieldOfViewCircle.Color = Color3.fromRGB(255, 255, 255)
FieldOfViewCircle.ZIndex = 2
FieldOfViewCircle.Visible = false

local TracerLines = {}
local NameTags = {}

local Window = Airflow:CreateWindow({
    Name = "NexoraHub",
    Icon = "lucide:terminal",
    LoadingSubtitle = "discord.gg/rxsAtJtWbF",
    Theme = "Rose",
    ToggleUIKeybind = "RightControl",
    OpenButton = { Title = "NexoraHub", Icon = "lucide:terminal", Locked = true },
    ConfigurationSaving = { Enabled = true, FolderName = "NexoraHub", FileName = "aimbot" },
    Home = {
        Name = "Home",
        Stats = { "FPS", "Ping", "Executor", "Game", "Region", "Time" },
        Pages = {
            {
                Name = "Info",
                Icon = "info",
                Entries = {
                    {
                        Title = "Credits",
                        Content = "Thank you for using NexoraHub and supporting what we do. We put time and effort into making scripts for the community and we hope you enjoy using them.\n\nIf you want to support our project, consider joining our server. It helps us keep going and gives us more motivation to make new scripts and improve the ones we already have.\n\nWe really appreciate everyone who supports us. Thank you for being part of NexoraHub!\n\n- Nexora Team",
                    },
                },
            },
        },
    },
})

do
    local homeTab = Window.Home or (Window.Tabs and Window.Tabs[1])

    if homeTab then
        pcall(function()
            homeTab:CreateSection("Community")

            homeTab:CreateButton({
                Name = "Join Discord",
                Desc = "discord.gg/rxsAtJtWbF",
                Icon = "message-circle",
                Style = "Primary",
                Callback = function()
                    pcall(function()
                        game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/rxsAtJtWbF")
                    end)

                    if setclipboard then
                        setclipboard("discord.gg/rxsAtJtWbF")
                    elseif toclipboard then
                        toclipboard("discord.gg/rxsAtJtWbF")
                    end

                    Airflow:Notify({
                        Title = "Discord",
                        Content = "Invite opened and copied to clipboard.",
                        Icon = "message-circle",
                        Type = "Info",
                        Duration = 3,
                    })
                end,
            })
        end)
    end
end

local AimbotTab = Window:CreateTab({ Name = "Aimbot", Desc = "Camera-based target locking", Icon = "crosshair" })

AimbotTab:CreateSection("Aimbot")

AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    Desc = "Hold RMB to lock the camera onto the nearest enemy",
    CurrentValue = false,
    Flag = "AimbotEnabled",
    Callback = function(Value)
        Settings.AimbotEnabled = Value
        FieldOfViewCircle.Visible = Value
    end,
})

AimbotTab:CreateDropdown({
    Name = "Target Part",
    Desc = "Which body part the aimbot locks onto",
    Options = { "Head", "Body" },
    CurrentOption = "Head",
    Flag = "AimbotTargetPart",
    Callback = function(Option)
        Settings.TargetPart = Option
    end,
})

AimbotTab:CreateSlider({
    Name = "Smoothness",
    Desc = "0 = instant snap, higher = slower glide",
    Range = { 0, 10 },
    Increment = 0.5,
    CurrentValue = 0,
    Flag = "AimbotSmoothness",
    Callback = function(Value)
        Settings.Smoothness = Value
    end,
})

AimbotTab:CreateSlider({
    Name = "FOV Circle Size",
    Desc = "Radius of the aimbot target circle in pixels",
    Range = { 30, 600 },
    Increment = 10,
    Suffix = "px",
    CurrentValue = 150,
    Flag = "AimbotFOVCircleSize",
    Callback = function(Value)
        Settings.FOVCircleSize = Value
        FieldOfViewCircle.Radius = Value
    end,
})

AimbotTab:CreateSection("Filters")

AimbotTab:CreateToggle({
    Name = "Team Check",
    Desc = "Skip players on your team",
    CurrentValue = true,
    Flag = "AimbotTeamCheck",
    Callback = function(Value)
        Settings.TeamCheck = Value
    end,
})

AimbotTab:CreateToggle({
    Name = "Wall Check",
    Desc = "Only lock onto targets with clear line of sight",
    CurrentValue = true,
    Flag = "AimbotWallCheck",
    Callback = function(Value)
        Settings.WallCheck = Value
    end,
})

local ESPTab = Window:CreateTab({ Name = "ESP", Desc = "Enemy visual indicators", Icon = "eye" })

ESPTab:CreateSection("Visuals")

ESPTab:CreateToggle({
    Name = "Highlight",
    Desc = "Red outline drawn through walls on enemies",
    CurrentValue = false,
    Flag = "ESPHighlight",
    Callback = function(Value)
        Settings.ESPHighlight = Value
    end,
})

ESPTab:CreateToggle({
    Name = "Tracer",
    Desc = "Line from your screen to each enemy",
    CurrentValue = false,
    Flag = "ESPTracer",
    Callback = function(Value)
        Settings.ESPTracer = Value
    end,
})

ESPTab:CreateToggle({
    Name = "Distance",
    Desc = "Stud count shown above each enemy",
    CurrentValue = false,
    Flag = "ESPDistance",
    Callback = function(Value)
        Settings.ESPDistance = Value
    end,
})

ESPTab:CreateSlider({
    Name = "Max Distance",
    Desc = "Hide ESP beyond this range",
    Range = { 100, 5000 },
    Increment = 50,
    Suffix = "studs",
    CurrentValue = 1000,
    Flag = "ESPMaxDistance",
    Callback = function(Value)
        Settings.ESPMaxDistance = Value
    end,
})

local CameraTab = Window:CreateTab({ Name = "Camera", Desc = "Field of view settings", Icon = "video" })

CameraTab:CreateSection("Field of View")

CameraTab:CreateToggle({
    Name = "Enable FOV Changer",
    Desc = "Overrides the game's default field of view",
    CurrentValue = false,
    Flag = "FOVEnabled",
    Callback = function(Value)
        Settings.FOVEnabled = Value
        if not Value then
            CurrentCamera.FieldOfView = DefaultFOV
        else
            CurrentCamera.FieldOfView = Settings.FOVValue
        end
    end,
})

CameraTab:CreateSlider({
    Name = "FOV",
    Desc = "Camera field of view in degrees",
    Range = { 30, 120 },
    Increment = 1,
    Suffix = "°",
    CurrentValue = 70,
    Flag = "FOVValue",
    Callback = function(Value)
        Settings.FOVValue = Value
        if Settings.FOVEnabled then
            CurrentCamera.FieldOfView = Value
        end
    end,
})

CameraTab:CreateButton({
    Name = "Reset FOV",
    Desc = "Turns off FOV changer and restores the game default",
    Icon = "rotate-ccw",
    Callback = function()
        Settings.FOVEnabled = false
        CurrentCamera.FieldOfView = DefaultFOV
        local fovToggle = Window.Flags and Window.Flags["FOVEnabled"]
        if fovToggle and fovToggle.Set then
            fovToggle:Set(false)
        end
    end,
})

local SettingsTab = Window:CreateTab({ Name = "Settings", Desc = "Interface and config options", Icon = "settings" })

SettingsTab:CreateSection("Interface")

SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    Desc = "Key that hides and shows the window",
    CurrentKeybind = "RightControl",
    OnChanged = function(Key)
        Window:SetKeybind(Key)
    end,
})

SettingsTab:CreateConfigManager({ Name = "Configs" })

SettingsTab:CreateSection("Actions")

SettingsTab:CreateButton({
    Name = "Unload",
    Desc = "Removes the UI and restores default FOV",
    Icon = "power",
    Style = "Danger",
    Callback = function()
        CurrentCamera.FieldOfView = DefaultFOV
        for _, tracer in pairs(TracerLines) do
            tracer:Remove()
        end
        FieldOfViewCircle:Remove()
        Window:Destroy()
    end,
})

Window:LoadConfig()

local IsTouching = false
UserInputService.TouchStarted:Connect(function() IsTouching = true end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        IsTouching = false
    end
end)

local function getScreenCenter()
    local screenPoint = CurrentCamera:WorldToViewportPoint(CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * 100)
    return Vector2.new(screenPoint.X, screenPoint.Y)
end

local function isTeammate(player)
    if player == LocalPlayer then return true end
    if not Settings.TeamCheck then return false end
    if not LocalPlayer.Team or not player.Team then return false end
    return LocalPlayer.Team == player.Team
end

local function getTargetPart(character)
    if Settings.TargetPart == "Head" then
        return character:FindFirstChild("Head")
    end
    return character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("Torso")
        or character:FindFirstChild("HumanoidRootPart")
end

local function hasLineOfSight(targetPart)
    if not Settings.WallCheck then return true end

    local rayOrigin = CurrentCamera.CFrame.Position
    local rayDirection = targetPart.Position - rayOrigin

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = { LocalPlayer.Character }

    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if not raycastResult then return true end
    return raycastResult.Instance:IsDescendantOf(targetPart.Parent)
end

local function findTarget(screenCenter)
    local closestTarget = nil
    local closestDistance = Settings.FOVCircleSize

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not isTeammate(player) then
            local character = player.Character

            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if humanoid and humanoid.Health > 0 then
                    local targetPart = getTargetPart(character)

                    if targetPart then
                        local screenPosition, isOnScreen = CurrentCamera:WorldToViewportPoint(targetPart.Position)

                        if isOnScreen then
                            local screenDistance = (Vector2.new(screenPosition.X, screenPosition.Y) - screenCenter).Magnitude

                            if screenDistance < closestDistance and hasLineOfSight(targetPart) then
                                closestDistance = screenDistance
                                closestTarget = targetPart
                            end
                        end
                    end
                end
            end
        end
    end

    return closestTarget
end

local function applyHighlight(player)
    local character = player.Character
    if not character then return end

    if player == LocalPlayer or isTeammate(player) then
        local existingHighlight = character:FindFirstChild("NexoraHighlight")
        if existingHighlight then
            existingHighlight:Destroy()
        end
        return
    end

    local highlight = character:FindFirstChild("NexoraHighlight")

    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "NexoraHighlight"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character
    end

    highlight.FillColor = Color3.fromRGB(255, 60, 60)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
end

local function clearHighlight(player)
    local character = player.Character

    if character then
        local highlight = character:FindFirstChild("NexoraHighlight")
        if highlight then
            highlight:Destroy()
        end
    end
end

local function updateTracer(player, character)
    if not TracerLines[player] then
        local line = Drawing.new("Line")
        line.Thickness = 1.5
        line.Transparency = 1
        line.Color = Color3.fromRGB(255, 60, 60)
        line.ZIndex = 2
        line.Visible = false
        TracerLines[player] = line
    end

    local tracer = TracerLines[player]

    if not Settings.ESPTracer or isTeammate(player) then
        tracer.Visible = false
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        tracer.Visible = false
        return
    end

    local screenPosition, isOnScreen = CurrentCamera:WorldToViewportPoint(root.Position)
    if isOnScreen then
        tracer.From = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y)
        tracer.To = Vector2.new(screenPosition.X, screenPosition.Y)
        tracer.Visible = true
    else
        tracer.Visible = false
    end
end

local function clearTracer(player)
    if TracerLines[player] then
        TracerLines[player]:Remove()
        TracerLines[player] = nil
    end
end

local function updateNameTag(player, character, distance)
    if not Settings.ESPDistance then
        if NameTags[player] then
            NameTags[player]:Destroy()
            NameTags[player] = nil
        end
        return
    end

    local head = character:FindFirstChild("Head")
    if not head then return end

    local tag = NameTags[player]
    if not tag then
        tag = Instance.new("BillboardGui")
        tag.Name = "NexoraDistanceTag"
        tag.AlwaysOnTop = true
        tag.Size = UDim2.new(0, 100, 0, 20)
        tag.StudsOffset = Vector3.new(0, 2.5, 0)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeTransparency = 0.5
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 12
        label.Parent = tag

        tag.Parent = head
        NameTags[player] = tag
    end

    tag.Adornee = head
    local label = tag:FindFirstChildOfClass("TextLabel")
    if label then
        label.Text = "[" .. math.floor(distance) .. "m]"
    end
end

local function clearNameTag(player)
    if NameTags[player] then
        NameTags[player]:Destroy()
        NameTags[player] = nil
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(0.3)
            applyHighlight(player)
        end)
        applyHighlight(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.3)
        applyHighlight(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    clearHighlight(player)
    clearTracer(player)
    clearNameTag(player)
end)

RunService.RenderStepped:Connect(function()
    local screenCenter = getScreenCenter()
    FieldOfViewCircle.Position = screenCenter
    FieldOfViewCircle.Radius = Settings.FOVCircleSize
    FieldOfViewCircle.Visible = Settings.AimbotEnabled

    if Settings.FOVEnabled and CurrentCamera.FieldOfView ~= Settings.FOVValue then
        CurrentCamera.FieldOfView = Settings.FOVValue
    end

    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local teammate = isTeammate(player)

            if character and not teammate then
                if Settings.ESPHighlight then
                    applyHighlight(player)
                else
                    clearHighlight(player)
                end

                if Settings.ESPTracer then
                    updateTracer(player, character)
                else
                    clearTracer(player)
                end

                if Settings.ESPDistance and myRoot then
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local distance = (root.Position - myRoot.Position).Magnitude
                        if distance <= Settings.ESPMaxDistance then
                            updateNameTag(player, character, distance)
                        else
                            clearNameTag(player)
                        end
                    end
                else
                    clearNameTag(player)
                end
            else
                clearHighlight(player)
                clearTracer(player)
                clearNameTag(player)
            end
        end
    end

    if Settings.AimbotEnabled then
        local shouldAim

        if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
            shouldAim = IsTouching
        else
            shouldAim = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        end

        if shouldAim then
            local target = findTarget(screenCenter)

            if target then
                if Settings.Smoothness == 0 then
                    CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, target.Position)
                else
                    CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(CFrame.new(CurrentCamera.CFrame.Position, target.Position), 1 / (Settings.Smoothness * 2))
                end
            end
        end
    end
end)

Airflow:Notify({
    Title = "NexoraHub",
    Content = "Loaded successfully. A script made with love.",
    Icon = "heart",
    Type = "Info",
    Duration = 4,
})

task.delay(1.5, function()
    Airflow:Notify({
        Title = "Discord",
        Content = "Join us at discord.gg/rxsAtJtWbF",
        Icon = "message-circle",
        Type = "Info",
        Duration = 5,
    })
end)