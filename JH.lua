local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/kielsvu/Nexora/refs/heads/main/Modules/Nexora.lua"))()

local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local vector2 = Vector2.new

local drawingAvailable = (typeof(Drawing) == "table" and typeof(Drawing.new) == "function")

if not drawingAvailable then
    warn("[NexoraHub] Drawing library not available - visuals will be disabled")
end

local settings = {
    tag = "Ball",
    radius = 12,
    hitboxColor = Color3.fromRGB(255, 60, 60),
    hitboxThickness = 2.5,
    hitboxTransparency = 0.25,
    hitboxEnabled = true,
    ringEnabled = true,

    predictionEnabled = true,
    predictionTime = 6,
    predictionColor = Color3.fromRGB(255, 200, 0),
    landingColor = Color3.fromRGB(255, 60, 60),
    landingRadius = 10,
    minimumSpeed = 2,
    groundRayDistance = 500,

    highlightEnabled = false,
    highlightFill = Color3.fromRGB(255, 60, 60),
    highlightOutline = Color3.fromRGB(255, 0, 0),

    tracerEnabled = false,
    tracerColor = Color3.fromRGB(255, 60, 60),
}

local trackedBalls = {}

local function getBallRoot(ball)
    if not ball or not ball.Parent then return nil end
    return ball.PrimaryPart or ball:FindFirstChildWhichIsA("BasePart", true)
end

local function createPredictionLines(lineCount)
    local lines = {}
    for i = 1, lineCount - 1 do
        local line = Drawing.new("Line")
        line.Color = settings.predictionColor
        line.Thickness = 2
        line.Transparency = 0.5
        line.Visible = false
        table.insert(lines, line)
    end
    return lines
end

local function createLandingCircle()
    local circle = Drawing.new("Circle")
    circle.Color = settings.landingColor
    circle.Filled = false
    circle.NumSides = 64
    circle.Thickness = 2
    circle.Transparency = 0.3
    circle.Visible = false
    return circle
end

local function startTrackingBall(ball)
    if not ball:IsA("Model") or not ball:IsDescendantOf(workspace) then return end
    if trackedBalls[ball] then return end

    local root = getBallRoot(ball)
    if not root then return end

    local hitboxPart = Instance.new("Part")
    hitboxPart.Name = "NexoraHitbox"
    hitboxPart.Shape = Enum.PartType.Ball
    hitboxPart.Size = Vector3.new(settings.radius * 2, settings.radius * 2, settings.radius * 2)
    hitboxPart.CFrame = root.CFrame
    hitboxPart.Transparency = 1
    hitboxPart.CanCollide = false
    hitboxPart.CanTouch = false
    hitboxPart.CanQuery = settings.hitboxEnabled
    hitboxPart.Anchored = true
    hitboxPart.CastShadow = false
    hitboxPart.Massless = true
    hitboxPart.Parent = ball

    local ring = nil
    if drawingAvailable then
        ring = Drawing.new("Circle")
        ring.Color = settings.hitboxColor
        ring.Filled = false
        ring.NumSides = 128
        ring.Thickness = settings.hitboxThickness
        ring.Transparency = settings.hitboxTransparency
        ring.Visible = false
    end

    local predictionLines = nil
    local landingCircle = nil

    if drawingAvailable and settings.predictionEnabled then
        local lineCount = math.ceil(settings.predictionTime / 0.05)
        predictionLines = createPredictionLines(lineCount)
        landingCircle = createLandingCircle()
    end

    local tracer = nil
    if drawingAvailable then
        tracer = Drawing.new("Line")
        tracer.Color = settings.tracerColor
        tracer.Thickness = 1.5
        tracer.Transparency = 0.3
        tracer.Visible = false
    end

    local highlight = nil
    if settings.highlightEnabled then
        highlight = Instance.new("Highlight")
        highlight.Name = "NexoraHighlight"
        highlight.Adornee = ball
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = settings.highlightFill
        highlight.OutlineColor = settings.highlightOutline
        highlight.FillTransparency = 0.6
        highlight.OutlineTransparency = 0
        highlight.Parent = ball
    end

    trackedBalls[ball] = {
        hitboxPart = hitboxPart,
        ring = ring,
        predictionLines = predictionLines,
        landingCircle = landingCircle,
        tracer = tracer,
        highlight = highlight,
    }
end

local function stopTrackingBall(ball)
    local data = trackedBalls[ball]
    if not data then return end

    if data.hitboxPart then
        pcall(function() data.hitboxPart:Destroy() end)
    end

    if data.ring then
        pcall(function() data.ring:Remove() end)
    end

    if data.predictionLines then
        for _, line in ipairs(data.predictionLines) do
            pcall(function() line:Remove() end)
        end
    end

    if data.landingCircle then
        pcall(function() data.landingCircle:Remove() end)
    end

    if data.tracer then
        pcall(function() data.tracer:Remove() end)
    end

    if data.highlight then
        pcall(function() data.highlight:Destroy() end)
    end

    trackedBalls[ball] = nil
end

local function findGroundHeight(root)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = { root.Parent }
    raycastParams.IgnoreWater = false

    local result = workspace:Raycast(root.Position, Vector3.new(0, -settings.groundRayDistance, 0), raycastParams)
    if result then
        return result.Position.Y
    end
    return nil
end

local function predictTrajectory(root)
    local position = root.Position
    local velocity = root.AssemblyLinearVelocity

    if velocity.Magnitude < settings.minimumSpeed then
        return nil, nil
    end

    local groundHeight = findGroundHeight(root)
    local gravityForce = Vector3.new(0, -workspace.Gravity, 0)

    local timeStep = 0.05
    local maxSteps = math.ceil(settings.predictionTime / timeStep)
    local points = {}
    local landingPosition = nil

    for step = 1, maxSteps do
        local elapsed = step * timeStep
        local point = position + velocity * elapsed + gravityForce * (0.5 * elapsed * elapsed)
        table.insert(points, point)

        if groundHeight and point.Y <= groundHeight + 0.5 then
            landingPosition = Vector3.new(point.X, groundHeight, point.Z)
            break
        end

        if point.Y < -50 then
            break
        end
    end

    if not landingPosition and #points > 0 then
        landingPosition = points[#points]
    end

    return points, landingPosition
end

local ballAddedConnection = CollectionService:GetInstanceAddedSignal(settings.tag):Connect(startTrackingBall)
local ballRemovedConnection = CollectionService:GetInstanceRemovedSignal(settings.tag):Connect(stopTrackingBall)

local renderConnection = RunService.RenderStepped:Connect(function()
    camera = workspace.CurrentCamera
    if not camera then return end

    for ball, data in pairs(trackedBalls) do
        local root = getBallRoot(ball)

        if not root then
            stopTrackingBall(ball)
        else
            if data.hitboxPart and data.hitboxPart.Parent then
                data.hitboxPart.CFrame = root.CFrame
                data.hitboxPart.CanQuery = settings.hitboxEnabled
            end

            -- ring around the ball
            if data.ring then
                if settings.ringEnabled and settings.hitboxEnabled then
                    local screenPosition, isOnScreen = camera:WorldToViewportPoint(root.Position)

                    if isOnScreen and screenPosition.Z > 0 then
                        local edgePoint = camera:WorldToViewportPoint(root.Position + camera.CFrame.RightVector * settings.radius)
                        local pixelRadius = math.abs(edgePoint.X - screenPosition.X)

                        if pixelRadius ~= pixelRadius or pixelRadius <= 0 then
                            data.ring.Visible = false
                        else
                            data.ring.Color = settings.hitboxColor
                            data.ring.Position = vector2(screenPosition.X, screenPosition.Y)
                            data.ring.Radius = pixelRadius
                            data.ring.Thickness = settings.hitboxThickness
                            data.ring.Transparency = settings.hitboxTransparency
                            data.ring.Visible = true
                        end
                    else
                        data.ring.Visible = false
                    end
                else
                    data.ring.Visible = false
                end
            end

            -- tracer
            if data.tracer then
                if settings.tracerEnabled then
                    local screenPosition, isOnScreen = camera:WorldToViewportPoint(root.Position)

                    if isOnScreen and screenPosition.Z > 0 then
                        data.tracer.Color = settings.tracerColor
                        data.tracer.From = vector2(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                        data.tracer.To = vector2(screenPosition.X, screenPosition.Y)
                        data.tracer.Visible = true
                    else
                        data.tracer.Visible = false
                    end
                else
                    data.tracer.Visible = false
                end
            end

            -- prediction
            if data.predictionLines and data.landingCircle then
                if settings.predictionEnabled then
                    local points, landingPosition = predictTrajectory(root)

                    if not points or #points < 2 then
                        for _, line in ipairs(data.predictionLines) do
                            line.Visible = false
                        end
                        data.landingCircle.Visible = false
                    else
                        local screenPoints = {}

                        for i, point in ipairs(points) do
                            local projectedPoint, isOnScreen = camera:WorldToViewportPoint(point)
                            screenPoints[i] = {
                                screenPosition = projectedPoint,
                                visible = isOnScreen and projectedPoint.Z > 0,
                            }
                        end

                        for i = 1, #data.predictionLines do
                            local pointA = screenPoints[i]
                            local pointB = screenPoints[i + 1]

                            if pointA and pointB and pointA.visible and pointB.visible then
                                data.predictionLines[i].Color = settings.predictionColor
                                data.predictionLines[i].From = vector2(pointA.screenPosition.X, pointA.screenPosition.Y)
                                data.predictionLines[i].To = vector2(pointB.screenPosition.X, pointB.screenPosition.Y)
                                data.predictionLines[i].Visible = true
                            else
                                data.predictionLines[i].Visible = false
                            end
                        end

                        if landingPosition then
                            local screenPosition, isOnScreen = camera:WorldToViewportPoint(landingPosition)

                            if isOnScreen and screenPosition.Z > 0 then
                                data.landingCircle.Color = settings.landingColor
                                data.landingCircle.Position = vector2(screenPosition.X, screenPosition.Y)
                                data.landingCircle.Radius = settings.landingRadius
                                data.landingCircle.Visible = true
                            else
                                data.landingCircle.Visible = false
                            end
                        else
                            data.landingCircle.Visible = false
                        end
                    end
                else
                    for _, line in ipairs(data.predictionLines) do
                        line.Visible = false
                    end
                    data.landingCircle.Visible = false
                end
            end
        end
    end
end)

local Window = Airflow:CreateWindow({
    Name = "NexoraHub",
    Icon = "lucide:terminal",
    LoadingSubtitle = "discord.gg/rxsAtJtWbF",
    Theme = "Rose",
    ToggleUIKeybind = "RightControl",
    OpenButton = { Title = "NexoraHub", Icon = "lucide:terminal", Locked = true },
    ConfigurationSaving = { Enabled = true, FolderName = "NexoraHub", FileName = "volleyball" },
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

local HitboxTab = Window:CreateTab({ Name = "Hitbox", Desc = "Ball hitbox expander", Icon = "target" })

HitboxTab:CreateSection("Hitbox")

HitboxTab:CreateToggle({
    Name = "Enable Hitbox",
    Desc = "Expands an invisible queryable sphere around the ball",
    CurrentValue = true,
    Flag = "HitboxEnabled",
    Callback = function(value)
        settings.hitboxEnabled = value

        for _, data in pairs(trackedBalls) do
            if data.hitboxPart then
                data.hitboxPart.CanQuery = value
            end
        end
    end,
})

HitboxTab:CreateSlider({
    Name = "Hitbox Radius",
    Desc = "Size of the invisible hitbox around the ball",
    Range = { 1, 30 },
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 12,
    Flag = "HitboxRadius",
    Callback = function(value)
        settings.radius = value

        for _, data in pairs(trackedBalls) do
            if data.hitboxPart then
                data.hitboxPart.Size = Vector3.new(value * 2, value * 2, value * 2)
            end
        end
    end,
})

HitboxTab:CreateSection("Visual")

HitboxTab:CreateToggle({
    Name = "Show Ball Ring",
    Desc = "Draws a circle around the ball on screen",
    CurrentValue = true,
    Flag = "BallRing",
    Callback = function(value)
        settings.ringEnabled = value
    end,
})

HitboxTab:CreateSection("Info")

HitboxTab:CreateParagraph({
    Title = "How it works",
    Content = "Creates an invisible, non-colliding, queryable sphere around the ball. If the game uses client-side hit detection with raycasts, shots that pass through the sphere register as hits. If the game validates shots server-side, the hitbox may not affect damage.",
})

local PredictionTab = Window:CreateTab({ Name = "Prediction", Desc = "Ball trajectory prediction", Icon = "trending-up" })

PredictionTab:CreateSection("Prediction")

PredictionTab:CreateParagraph({
    Title = "Beta Feature",
    Content = "This is a beta feature — help me test it. Trajectory and landing marker are estimates based on the ball's current velocity and gravity. If the ball is hit mid-flight, prediction recomputes on the next frame. Report any weird jumps or wrong landings to Discord.",
})

PredictionTab:CreateToggle({
    Name = "Enable Prediction",
    Desc = "Draws the ball's predicted flight path and landing spot",
    CurrentValue = true,
    Flag = "PredictionEnabled",
    Callback = function(value)
        settings.predictionEnabled = value

        for _, data in pairs(trackedBalls) do
            if value then
                if not data.predictionLines and drawingAvailable then
                    local lineCount = math.ceil(settings.predictionTime / 0.05)
                    data.predictionLines = createPredictionLines(lineCount)
                    data.landingCircle = createLandingCircle()
                end
            else
                if data.predictionLines then
                    for _, line in ipairs(data.predictionLines) do
                        line.Visible = false
                    end
                end
                if data.landingCircle then
                    data.landingCircle.Visible = false
                end
            end
        end
    end,
})

PredictionTab:CreateSlider({
    Name = "Look-ahead Time",
    Desc = "How far ahead to predict, in seconds",
    Range = { 1, 10 },
    Increment = 0.5,
    Suffix = "s",
    CurrentValue = 6,
    Flag = "PredictionTime",
    Callback = function(value)
        settings.predictionTime = value

        for _, data in pairs(trackedBalls) do
            if data.predictionLines then
                for _, line in ipairs(data.predictionLines) do
                    pcall(function() line:Remove() end)
                end
            end

            if data.landingCircle then
                pcall(function() data.landingCircle:Remove() end)
            end

            if drawingAvailable then
                local lineCount = math.ceil(value / 0.05)
                data.predictionLines = createPredictionLines(lineCount)
                data.landingCircle = createLandingCircle()
            end
        end
    end,
})

PredictionTab:CreateSection("Info")

PredictionTab:CreateParagraph({
    Title = "How it works",
    Content = "The prediction raycasts down from the ball to find the ground level, then simulates projectile motion using the ball's current velocity and workspace gravity. The orange trail is the predicted path; the red circle marks where the ball is expected to hit the floor.",
})

local ESPTab = Window:CreateTab({ Name = "ESP", Desc = "Ball tracking visuals", Icon = "eye" })

ESPTab:CreateSection("Highlight")

ESPTab:CreateToggle({
    Name = "Ball Highlight",
    Desc = "Red glow around the ball, visible through walls",
    CurrentValue = false,
    Flag = "BallHighlight",
    Callback = function(value)
        settings.highlightEnabled = value

        for ball, data in pairs(trackedBalls) do
            if value then
                if not data.highlight then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "NexoraHighlight"
                    highlight.Adornee = ball
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.FillColor = settings.highlightFill
                    highlight.OutlineColor = settings.highlightOutline
                    highlight.FillTransparency = 0.6
                    highlight.OutlineTransparency = 0
                    highlight.Parent = ball
                    data.highlight = highlight
                end
            else
                if data.highlight then
                    pcall(function() data.highlight:Destroy() end)
                    data.highlight = nil
                end
            end
        end
    end,
})

ESPTab:CreateSection("Tracer")

ESPTab:CreateToggle({
    Name = "Ball Tracer",
    Desc = "Line from bottom of screen to the ball",
    CurrentValue = false,
    Flag = "BallTracer",
    Callback = function(value)
        settings.tracerEnabled = value
    end,
})

local SettingsTab = Window:CreateTab({ Name = "Settings", Desc = "Interface and config options", Icon = "settings" })

SettingsTab:CreateSection("Interface")

SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    Desc = "Key that hides and shows the window",
    CurrentKeybind = "RightControl",
    OnChanged = function(key)
        Window:SetKeybind(key)
    end,
})

SettingsTab:CreateConfigManager({ Name = "Configs" })

SettingsTab:CreateSection("Actions")

SettingsTab:CreateButton({
    Name = "Unload",
    Desc = "Removes the UI and clears all visuals",
    Icon = "power",
    Style = "Danger",
    Callback = function()
        if ballAddedConnection then ballAddedConnection:Disconnect() end
        if ballRemovedConnection then ballRemovedConnection:Disconnect() end
        if renderConnection then renderConnection:Disconnect() end

        for ball, _ in pairs(trackedBalls) do
            stopTrackingBall(ball)
        end

        Window:Destroy()
    end,
})

for _, ball in ipairs(CollectionService:GetTagged(settings.tag)) do
    startTrackingBall(ball)
end

Airflow:Notify({
    Title = "NexoraHub",
    Content = "Loaded. A script made with love.",
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