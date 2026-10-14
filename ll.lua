print("[NexoraHub] step 1: script started")

local Airflow = loadstring(game:HttpGet("https://raw.githubusercontent.com/kielsvu/Nexora/refs/heads/main/Modules/Nexora.lua"))()
print("[NexoraHub] step 2: air flow source loaded")

pcall(function()
    Airflow:LoadFont({ Name = "ValleySans" })
end)
print("[NexoraHub] step 3: font load attempted")

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
    print("[NexoraHub] step 4: fps booster light settings done")
end)

local Window

do
    local ok, err = pcall(function()
        Window = Airflow:CreateWindow({
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
    end)

    if not ok then
        warn("[NexoraHub] FAILED at CreateWindow: " .. tostring(err))
        return
    end
end

print("[NexoraHub] step 5: window created")

local ok1, err1 = pcall(function()
    local homeTab = Window.Home or (Window.Tabs and Window.Tabs[1])

    if homeTab then
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
        print("[NexoraHub] step 6: home tab button added")
    else
        print("[NexoraHub] step 6: home tab NOT FOUND")
    end
end)

if not ok1 then
    warn("[NexoraHub] FAILED at home tab: " .. tostring(err1))
end

print("[NexoraHub] step 7: about to create Build a Boat tab")

local ok2, err2 = pcall(function()
    local BaBFTab = Window:CreateTab({ Name = "Build a Boat", Desc = "Auto farm and quests", Icon = "ship" })
    print("[NexoraHub] step 8: Build a Boat tab created")

    BaBFTab:CreateSection("Auto Farm")
    print("[NexoraHub] step 9: Auto Farm section created")
end)

if not ok2 then
    warn("[NexoraHub] FAILED at Build a Boat tab: " .. tostring(err2))
    return
end

print("[NexoraHub] step 10: creating Settings tab")

local ok3, err3 = pcall(function()
    local SettingsTab = Window:CreateTab({ Name = "Settings", Desc = "Interface and config options", Icon = "settings" })
    SettingsTab:CreateSection("Interface")
    print("[NexoraHub] step 11: Settings tab created")
end)

if not ok3 then
    warn("[NexoraHub] FAILED at Settings tab: " .. tostring(err3))
    return
end

print("[NexoraHub] ALL STEPS COMPLETE")
