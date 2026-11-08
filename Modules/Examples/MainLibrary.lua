--fuck ykiel (examples)
local NexoraHUD = loadstring(game:HttpGet(
    "" -- paste Nexora.lua URL
))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- icons
pcall(function() NexoraHUD:PreloadIcons() end)

-- window (theme is Rose by default, no need to set)
local Window = NexoraHUD:Window{
    Title = "Nexora HUD",
    Subtitle = "v1.0.0",
    Size = UDim2.fromOffset(680, 500),
    Keybind = "RightShift",

    MinSize = Vector2.new(500, 380),
    MaxSize = Vector2.new(1000, 800),
    KeepOnScreen = true,

    Home = {
        Greeting = "Welcome back",
        SectionName = "System info",
        Stats = {"FPS", "Ping", "Executor", "Game", "Time", "Players", "Uptime"},
        Pages = {
            {
                Name = "Changelog",
                Icon = "scroll-text",
                Entries = {
                    {
                        Title = "v1.0.0",
                        Tag = "Latest",
                        Changes = {
                            "Initial HUD build",
                            "Uses Players + ReplicatedStorage",
                        },
                    },
                },
            },
        },
    },

    Loading = {
        Enabled = true,
        Title = "Nexora HUD",
        Text = "Loading",
        Duration = 1.8,
        Steps = {"Preparing", "Loading", "Ready"},
    },

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NexoraHUD",
        FileName = "default",
        AutoSave = false,
    },
}

-- main tab
local Main = Window:Tab{
    Name = "Main",
    Icon = "home",
    Desc = "Demo controls",
}

Main:Section("Actions")

Main:Button{
    Name = "Say hello",
    Desc = "Prints and shows a toast",
    Icon = "message-circle",
    Style = "Primary",
    Callback = function()
        print("[NexoraHUD] Hello, " .. player.Name)
        Window:Notify{
            Title = "Hello!",
            Content = "Success toast.",
            Type = "Success",
            Duration = 3,
            Icon = "check",
        }
    end,
}

Main:Button{
    Name = "Danger",
    Desc = "Asks before running",
    Icon = "trash-2",
    Style = "Danger",
    Callback = function()
        Window:Confirm{
            Title = "Delete?",
            Content = "Cannot be undone.",
            ConfirmText = "Delete",
            Callback = function()
                Window:Notify{Title = "Deleted", Content = "Confirmed.", Type = "Info"}
            end,
        }
    end,
}

Main:Section("Toggles")

Main:Toggle{
    Name = "Enabled",
    Desc = "Master switch",
    Default = false,
    Flag = "demo_enabled",
    Callback = function(v) print("[NexoraHUD] Enabled:", v) end,
}

Main:Toggle{
    Name = "Auto-save",
    Desc = "Save on flag change",
    Default = true,
    Flag = "auto_save",
    Callback = function(v) Window:SetAutoSave(v) end,
}

Main:Section("Values")

Main:Slider{
    Name = "Speed",
    Min = 10,
    Max = 200,
    Step = 5,
    Default = 50,
    Suffix = " studs/s",
    Flag = "speed",
    Callback = function(v) print("[NexoraHUD] Speed:", v) end,
}

Main:Stepper{
    Name = "Quantity",
    Min = 1,
    Max = 100,
    Default = 10,
    Suffix = " pcs",
    Flag = "quantity",
    Callback = function(v) print("[NexoraHUD] Quantity:", v) end,
}

Main:Dropdown{
    Name = "Mode",
    Options = {"Easy", "Normal", "Hard", "Extreme"},
    Default = "Normal",
    Flag = "mode",
    Callback = function(v) print("[NexoraHUD] Mode:", v) end,
}

Main:Dropdown{
    Name = "Features",
    Options = {"ESP", "Aimbot", "Fly", "Speed", "Godmode"},
    Multi = true,
    Default = {"ESP"},
    Flag = "features",
    Callback = function(v) print("[NexoraHUD] Features:", table.concat(v, ", ")) end,
}

Main:Input{
    Name = "Username",
    Placeholder = "Type here...",
    Flag = "username",
    Callback = function(v, enter)
        if enter then
            Window:Notify{
                Title = "Saved",
                Content = "Hello, " .. (v ~= "" and v or "stranger"),
                Type = "Success",
            }
        end
    end,
}

Main:Keybind{
    Name = "Toggle key",
    Default = "F",
    Flag = "toggle_key",
    Callback = function(k) print("[NexoraHUD] Key:", k and k.Name or "nil") end,
}

Main:ColorPicker{
    Name = "Accent color",
    Default = "#FFAAC3",
    Flag = "accent_color",
    Callback = function(c) print("[NexoraHUD] Color:", c:ToHex()) end,
}

Main:Section("Display")

local frames = 0
RunService.RenderStepped:Connect(function() frames = frames + 1 end)

Main:Label{
    Name = "Status",
    Text = "Idle",
    UpdateRate = 1,
    Update = function()
        local fps = frames
        frames = 0
        return "FPS: " .. fps
    end,
}

Main:Paragraph{
    Name = "Info",
    Content = "Paragraph auto-wraps when text gets long.",
}

local prog = Main:Progress{
    Name = "Progress",
    Default = 0.3,
}

task.spawn(function()
    while task.wait(1) do
        if not prog or not prog.Get then break end
        local v = prog:Get() + 0.05
        prog:Set(v > 1 and 0.05 or v)
    end
end)

Main:Divider()

-- settings tab
local Settings = Window:Tab{
    Name = "Settings",
    Icon = "settings",
    Desc = "Preferences",
}

Settings:Section("Visual")
Settings:Toggle{Name = "Blur", Desc = "Background blur", Default = false, Flag = "blur"}
Settings:Toggle{Name = "Animations", Default = true, Flag = "animations"}

Settings:Section("Config")
Settings:ConfigManager{Name = "Config manager"}

-- welcome
task.delay(2.5, function()
    Window:Notify{
        Title = "Welcome, " .. player.DisplayName,
        Content = "RightShift to toggle.",
        Type = "Success",
        Duration = 4,
        Icon = "check",
    }
end)

_G.NexoraHUD = NexoraHUD
_G.NexoraHUDWindow = Window
