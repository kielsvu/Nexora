local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/kielsvu/Nexora/refs/heads/main/Modules/Nexora.lua"))()

-- Airflow:LoadFont({ Name = "ValleySans" })

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

    workspace.DescendantAdded:Connect(function(descendant)
        pcall(disableEffect, descendant)
    end)
    Lighting.DescendantAdded:Connect(function(descendant)
        pcall(disableEffect, descendant)
    end)
end)

local Window = Airflow:CreateWindow({
    Name = "NexoraHub",
    Icon = "lucide:terminal",
    LoadingSubtitle = "discord.gg/rxsAtJtWbF",
    Theme = "Rose",
    ToggleUIKeybind = "RightControl",
    OpenButton = { Title = "NexoraHub", Icon = "lucide:terminal", Locked = true },
    ConfigurationSaving = { Enabled = true, FolderName = "NexoraHub", FileName = "default" },
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

local BaBFTab = Window:CreateTab({ Name = "Build a Boat", Desc = "Auto farm and quests for Build a Boat", Icon = "ship" })

BaBFTab:CreateSection("Auto Farm")

local FarmRunning = false
local FarmCharConn = nil

local function getOtherData()
    return LocalPlayer:FindFirstChild("OtherData")
end

local function getBoatStages()
    return workspace:FindFirstChild("BoatStages")
end

local function getClaimRemote()
    return workspace:FindFirstChild("ClaimRiverResultsGold")
end

local function CollectStage(StageNumber)
    local stages = getBoatStages()
    if not stages then return end

    local normalStages = stages:FindFirstChild("NormalStages")
    if not normalStages then return end

    local Stage = normalStages:FindFirstChild("CaveStage" .. StageNumber)
    if not Stage then return end

    local Collect = Stage:FindFirstChild("DarknessPart")
    if not Collect then return end

    local otherData = getOtherData()
    if not otherData then return end

    local StageData = otherData:FindFirstChild("Stage" .. (StageNumber - 1))
    if not StageData then return end

    local Char = LocalPlayer.Character
    if not Char then return end

    local Hum = Char:FindFirstChildOfClass("Humanoid")
    if not Hum then return end

    repeat
        task.wait()
        if not Char or not Char.Parent then continue end
        Char:PivotTo(Collect.CFrame * CFrame.new(0, 0, -20))
        for _, BodyPart in ipairs(Char:GetChildren()) do
            if BodyPart:IsA("BasePart") then
                BodyPart.Velocity = Vector3.zero
                BodyPart.RotVelocity = Vector3.zero
            end
        end
    until StageData.Value ~= "" or not Char or not Hum or Hum.Health <= 0 or not FarmRunning
end

local function TouchChest()
    task.spawn(function()
        local Char = LocalPlayer.Character
        if not Char then return end

        local Hum = Char:FindFirstChildOfClass("Humanoid")
        if not Hum then return end

        local stages = getBoatStages()
        if not stages then return end

        local normalStages = stages:FindFirstChild("NormalStages")
        if not normalStages then return end

        local TheEnd = normalStages:FindFirstChild("TheEnd")
        if not TheEnd then return end

        local GoldenChest = TheEnd:FindFirstChild("GoldenChest")
        if not GoldenChest then return end

        local Trigger = GoldenChest:FindFirstChild("Trigger")
        if not Trigger then return end

        local otherData = getOtherData()
        if not otherData then return end

        local EndData = otherData:FindFirstChild("End")
        if not EndData then return end

        repeat
            if not Char or not Hum or Hum.Health <= 0 then
                task.wait()
                continue
            end
            local Old = Trigger.CFrame
            Trigger.CFrame = Char:GetPivot()
            task.wait()
            Trigger.CFrame = Old
        until EndData.Value ~= "" or not Char or not Hum or Hum.Health <= 0 or not FarmRunning
    end)
end

local function Farm()
    local Char = LocalPlayer.Character
    if not Char then return end

    local Hum = Char:WaitForChild("Humanoid", 5)
    if not Hum then return end

    local claimRemote = getClaimRemote()
    if not claimRemote then return end

    for StageNumber = 2, 10 do
        if not FarmRunning then return end

        local CanContinue = false
        task.spawn(function()
            CollectStage(StageNumber)
            CanContinue = true
        end)

        repeat task.wait() until CanContinue or not Char or not Hum or Hum.Health <= 0 or not FarmRunning

        if not FarmRunning then return end

        if StageNumber ~= 2 then
            pcall(function() claimRemote:FireServer() end)
        else
            task.spawn(function()
                task.wait(1)
                TouchChest()
            end)
        end
    end

    if Char then pcall(function() Char:BreakJoints() end) end
end

local function StartFarm()
    if FarmRunning then return end
    FarmRunning = true

    if FarmCharConn then
        FarmCharConn:Disconnect()
        FarmCharConn = nil
    end

    FarmCharConn = LocalPlayer.CharacterAdded:Connect(function()
        if not FarmRunning then return end
        task.wait(1)
        pcall(Farm)
    end)

    task.spawn(function() pcall(Farm) end)

    Airflow:Notify({
        Title = "Auto Farm",
        Content = "Auto farm started.",
        Icon = "play",
        Type = "Info",
        Duration = 3,
    })
end

local function StopFarm()
    if not FarmRunning then return end
    FarmRunning = false

    if FarmCharConn then
        FarmCharConn:Disconnect()
        FarmCharConn = nil
    end

    Airflow:Notify({
        Title = "Auto Farm",
        Content = "Auto farm stopped.",
        Icon = "square",
        Type = "Info",
        Duration = 3,
    })
end

BaBFTab:CreateToggle({
    Name = "Auto Farm Gold",
    Desc = "Automatically completes stages 2 through 10",
    CurrentValue = false,
    Flag = "AutoFarmGold",
    Callback = function(Value)
        if Value then
            StartFarm()
        else
            StopFarm()
        end
    end,
})

BaBFTab:CreateButton({
    Name = "Reset Farm",
    Desc = "Restarts the farm loop. Does nothing if the farm is off.",
    Icon = "rotate-ccw",
    Callback = function()
        if not FarmRunning then
            Airflow:Notify({
                Title = "Auto Farm",
                Content = "Farm is not active.",
                Icon = "alert-triangle",
                Type = "Warning",
                Duration = 3,
            })
            return
        end

        StopFarm()
        task.wait(0.5)
        StartFarm()
    end,
})

BaBFTab:CreateSection("Quest")

local Questing = false

local function GetZone()
    local teamColor = LocalPlayer.TeamColor
    if not teamColor then return nil end
    return workspace:FindFirstChild(teamColor.Name .. "Zone")
end

local function GetQuest()
    local Zone = GetZone()
    if not Zone then return nil end
    return Zone:FindFirstChild("Quest")
end

local function Place(Name, Pos)
    local BTool = LocalPlayer.Backpack:FindFirstChild("BuildingTool")
    if BTool then
        BTool.Parent = LocalPlayer.Character
    else
        BTool = LocalPlayer.Character:FindFirstChild("BuildingTool")
    end

    if not BTool then return end

    task.spawn(function()
        local RF = BTool:FindFirstChild("RF")
        if not RF then return end
        pcall(function()
            RF:InvokeServer(
                Name,
                LocalPlayer.Data[Name].Value,
                nil,
                nil,
                false,
                Pos,
                false
            )
        end)
    end)
end

local QuestFunctions = {
    [1] = function()
        local Quest = GetQuest()
        if not Quest then return end
        local Cloud = Quest:WaitForChild("Cloud", 5)
        if not Cloud then return end
        local Part1 = Cloud:WaitForChild("Part1", 5)
        if not Part1 then return end
        Part1.CFrame = LocalPlayer.Character:GetPivot()
    end,

    [2] = function()
        local Quest = GetQuest()
        if not Quest then return end
        local Target = Quest:WaitForChild("Target", 5)
        if not Target then return end

        local Done = false
        repeat
            for _, Part in ipairs(Target:GetChildren()) do
                if Part.Name == "Part" and Part:FindFirstChildOfClass("Script") then
                    Done = true
                    Part.CFrame = LocalPlayer.Character:GetPivot()
                    break
                end
            end
            task.wait()
        until Done
    end,

    [3] = function()
        local Quest = GetQuest()
        if not Quest then return end
        local Ramp = Quest:WaitForChild("Ramp", 5)
        if not Ramp then return end

        local Done = false
        repeat
            for _, Part in ipairs(Ramp:GetChildren()) do
                if Part.Name == "Part" and Part:FindFirstChildOfClass("TouchTransmitter") then
                    Done = true
                    Part.CFrame = LocalPlayer.Character:GetPivot()
                    break
                end
            end
            task.wait()
        until Done
    end,

    [4] = function()
        local Zone = GetZone()
        if not Zone then return end

        repeat
            task.wait()

            local Quest = GetQuest()
            if not Quest then break end

            local Butter = Quest:FindFirstChild("Butter")
            if not Butter then continue end

            local Part = Butter:FindFirstChild("PPart")
            if not Part then continue end

            local Click = Part:FindFirstChildOfClass("ClickDetector")
            if not Click then continue end

            pcall(fireclickdetector, Click)
        until not Zone:FindFirstChild("Quest")
    end,

    [6] = function()
        local Zone = GetZone()
        if not Zone then return end

        local Quest = GetQuest()
        if not Quest then return end

        local MBox = Quest:WaitForChild("MBox", 5)
        if not MBox then return end

        local PPart = MBox:WaitForChild("PPart", 5)
        if not PPart then return end

        Place("Seat", PPart.CFrame * CFrame.new(2, 0, 0))

        local Blocks = workspace:FindFirstChild("Blocks")
        if not Blocks then return end

        local BlocksFolder = Blocks:FindFirstChild(LocalPlayer.Name)
        if not BlocksFolder then return end

        local Finished = false
        BlocksFolder.ChildAdded:Once(function(SeatModel)
            local Char = LocalPlayer.Character
            if not Char then return end
            local Hum = Char:FindFirstChildOfClass("Humanoid")
            if not Hum then return end

            local Seat = SeatModel:WaitForChild("Seat", 5)
            if Seat then
                pcall(function() Seat:Sit(Hum) end)
                repeat task.wait() until Hum.Sit or not Questing
            end

            local VoteLaunch = Zone:FindFirstChild("VoteLaunchRE")
            if VoteLaunch then
                pcall(function() VoteLaunch:FireServer() end)
            end

            task.wait(0.5)

            local stages = getBoatStages()
            if stages then
                local normalStages = stages:FindFirstChild("NormalStages")
                if normalStages then
                    local TheEnd = normalStages:FindFirstChild("TheEnd")
                    if TheEnd then
                        local GoldenChest = TheEnd:FindFirstChild("GoldenChest")
                        if GoldenChest then
                            local Trigger = GoldenChest:FindFirstChild("Trigger")
                            if Trigger then
                                pcall(function() Char:PivotTo(Trigger.CFrame) end)
                            end
                        end
                    end
                end
            end

            task.wait(5)
            Finished = true
        end)

        repeat task.wait() until Finished or not Questing
    end,

    [9] = function()
        local stages = getBoatStages()
        if not stages then return end

        local normalStages = stages:FindFirstChild("NormalStages")
        if not normalStages then return end

        local CaveStage1 = normalStages:FindFirstChild("CaveStage1")
        if not CaveStage1 then return end

        local Collect = CaveStage1:FindFirstChild("DarknessPart")
        if not Collect then return end

        local otherData = getOtherData()
        if not otherData then return end

        local StageData = otherData:FindFirstChild("Stage0")
        if not StageData then return end

        local Char = LocalPlayer.Character
        if not Char then return end

        local Hum = Char:FindFirstChildOfClass("Humanoid")
        if not Hum then return end

        repeat
            task.wait()

            if not Char then continue end

            Char:PivotTo(Collect.CFrame * CFrame.new(0, -60, -10))

            for _, BodyPart in ipairs(Char:GetChildren()) do
                if BodyPart:IsA("BasePart") then
                    BodyPart.Velocity = Vector3.zero
                    BodyPart.RotVelocity = Vector3.zero
                end
            end
        until StageData.Value ~= "" or not Char or not Hum or Hum.Health <= 0 or not Questing

        local stages2 = getBoatStages()
        if stages2 then
            local ns = stages2:FindFirstChild("NormalStages")
            if ns then
                local TheEnd = ns:FindFirstChild("TheEnd")
                if TheEnd then
                    local GC = TheEnd:FindFirstChild("GoldenChest")
                    if GC then
                        local Trig = GC:FindFirstChild("Trigger")
                        if Trig and LocalPlayer.Character then
                            pcall(function() LocalPlayer.Character:PivotTo(Trig.CFrame) end)
                        end
                    end
                end
            end
        end
    end,
}

local QuestOrder = { 1, 2, 3, 4, 6, 9 }

BaBFTab:CreateButton({
    Name = "Auto Complete Quest",
    Desc = "Runs every implemented quest in order",
    Icon = "check",
    Style = "Primary",
    Callback = function()
        if Questing then return end
        Questing = true

        task.spawn(function()
            local StartQuest = workspace:FindFirstChild("QuestMakerEvent")
            if not StartQuest then
                Questing = false
                Airflow:Notify({
                    Title = "Quests",
                    Content = "QuestMakerEvent not found.",
                    Icon = "alert-triangle",
                    Type = "Warning",
                    Duration = 3,
                })
                return
            end

            local Zone = GetZone()
            if Zone and Zone:FindFirstChild("Quest") then
                StartQuest:FireServer(0)
                repeat task.wait() until not Zone:FindFirstChild("Quest") or not Questing
                task.wait(1)
            end

            local otherData = getOtherData()
            if not otherData then
                Questing = false
                return
            end

            for _, Num in ipairs(QuestOrder) do
                if not Questing then break end
                if otherData:FindFirstChild("Q" .. Num) then
                    continue
                end

                StartQuest:FireServer(Num)
                local fn = QuestFunctions[Num]
                if fn then
                    pcall(fn)
                end

                local currentZone = GetZone()
                if currentZone then
                    repeat task.wait() until not currentZone:FindFirstChild("Quest") or not Questing
                end
                task.wait(1)
            end

            Questing = false

            Airflow:Notify({
                Title = "Quests",
                Content = "Quest run complete.",
                Icon = "check",
                Type = "Info",
                Duration = 3,
            })
        end)
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

SettingsTab:CreateSection("Extras")

local Clicking = false

SettingsTab:CreateButton({
    Name = "Click Others Blocks",
    Desc = "Fires ClickDetector on every block other players placed",
    Icon = "mouse-pointer-click",
    Callback = function()
        if Clicking then return end
        Clicking = true

        task.spawn(function()
            local Blocks = workspace:FindFirstChild("Blocks")
            if not Blocks then
                Clicking = false
                Airflow:Notify({
                    Title = "Blocks",
                    Content = "Blocks folder not found.",
                    Icon = "alert-triangle",
                    Type = "Warning",
                    Duration = 3,
                })
                return
            end

            for _, Folder in ipairs(Blocks:GetChildren()) do
                if Folder.Name == LocalPlayer.Name then continue end

                for _, Block in ipairs(Folder:GetChildren()) do
                    if Block.Name == "CameraDome" then continue end

                    local Click = Block:FindFirstChildOfClass("ClickDetector")
                    if Click then
                        pcall(fireclickdetector, Click)
                        task.wait()
                    end
                end
            end

            Clicking = false

            Airflow:Notify({
                Title = "Blocks",
                Content = "Clicked all other players' blocks.",
                Icon = "check",
                Type = "Info",
                Duration = 3,
            })
        end)
    end,
})

SettingsTab:CreateSection("Actions")

SettingsTab:CreateButton({
    Name = "Unload",
    Desc = "Removes the UI and stops the farm",
    Icon = "power",
    Style = "Danger",
    Callback = function()
        FarmRunning = false
        Questing = false
        Clicking = false

        if FarmCharConn then
            FarmCharConn:Disconnect()
            FarmCharConn = nil
        end

        Window:Destroy()
    end,
})

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
