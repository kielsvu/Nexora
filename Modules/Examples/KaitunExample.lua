local NexoraHUD = loadstring(game:HttpGet(
    ""
))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local hud = NexoraHUD.new({
    Title = "Nexora Hub • Kaitun",
    Subtitle = "By ykiel & day",
    Discord = "discord.gg/rxsAtJtWbF"
})

-- Example game-specific remote references.
-- Replace these with the actual game's remotes.

local GetStats = ReplicatedStorage.Remotes.GetStats

local statusColors = {
    IDLE = Color3.fromRGB(149, 124, 133),
    FARMING = Color3.fromRGB(150, 220, 170),
    HOPPING = Color3.fromRGB(255, 170, 195),
    TRAVELING = Color3.fromRGB(120, 180, 255),
    COLLECTING = Color3.fromRGB(100, 210, 220),
    SELLING = Color3.fromRGB(240, 200, 110),
    RECONNECTING = Color3.fromRGB(240, 176, 108),
    PAUSED = Color3.fromRGB(149, 124, 133),
    ERROR = Color3.fromRGB(240, 100, 100),
    COMPLETED = Color3.fromRGB(150, 220, 170)
}

local function setStatus(status)
    hud:SetStatus(
        status,
        statusColors[status] or Color3.fromRGB(240, 228, 232)
    )
end

-- Retrieve values from the game.
local function getStats()
    local success, result = pcall(function()
        return GetStats:InvokeServer()
    end)

    if not success or type(result) ~= "table" then
        return nil
    end

    return result
end

-- Update the HUD using retrieved values.
local function updateStats()
    local stats = getStats()

    if not stats then
        setStatus("ERROR")
        return
    end

    hud:SetStats({
        {Name = "Level", Value = stats.Level},
        {Name = "Bounty", Value = stats.Bounty},
        {Name = "Money", Value = stats.Money}
    })
end

-- Example automation states.
local function startFarming()
    setStatus("FARMING")
end

local function startTraveling()
    setStatus("TRAVELING")
end

local function startCollecting()
    setStatus("COLLECTING")
end

local function startHopping()
    setStatus("HOPPING")
end

-- Main update loop.
task.spawn(function()
    while task.wait(2) do
        updateStats()
    end
end)

-- Your automation calls these when its state changes:
startFarming()
-- startTraveling()
-- startCollecting()
-- startHopping()
