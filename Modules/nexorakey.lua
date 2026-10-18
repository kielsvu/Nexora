-- nexora key system ui

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local pg = LP:WaitForChild("PlayerGui")

local lucideCache
local function resolveLucide(name)
    if not lucideCache then
        local ok, icons = pcall(function()
            local src = game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua")
            return loadstring(src)()
        end)
        lucideCache = (ok and type(icons) == "table") and icons or false
    end
    if not lucideCache then return nil end
    local data = (lucideCache.Icons and lucideCache.Icons[name]) or lucideCache[name]
    if type(data) ~= "table" then return nil end
    local img = data.Image
    if type(img) == "number" then img = "rbxassetid://" .. tostring(img) end
    return img, data.ImageRectPosition, data.ImageRectSize
end

local function applyIcon(label, name)
    local img, offset, size = resolveLucide(name)
    if not img then return end
    label.Image = img
    label.ImageRectOffset = offset or Vector2.zero
    label.ImageRectSize = size or Vector2.zero
end

local function parentGui(gui)
    local function tryParent(target)
        pcall(function() gui.Parent = target end)
        return gui.Parent ~= nil
    end
    if tryParent(pg) then return true end
    pcall(function()
        if typeof(gethui) == "function" then
            local h = gethui()
            if h and tryParent(h) then return true end
        end
    end)
    if tryParent(game:GetService("CoreGui")) then return true end
    return false
end

local nexorakey = Instance.new("ScreenGui")
nexorakey.Name = "nexorakey"
nexorakey.IgnoreGuiInset = true
nexorakey.ResetOnSpawn = false
nexorakey.DisplayOrder = 999
nexorakey.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
nexorakey.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Name = "Frame"
    Frame.AnchorPoint = Vector2.new(0.5,0.5)
    Frame.Position = UDim2.new(0.5,0,0.5,0)
    Frame.Size = UDim2.new(0,600,0,340)
    Frame.BackgroundTransparency = 1
    Frame.Parent = nexorakey

        local UIScale = Instance.new("UIScale")
        UIScale.Name = "UIScale"
        UIScale.Scale = 0.75
        UIScale.Parent = Frame

        local ImageLabel = Instance.new("ImageLabel")
        ImageLabel.Name = "ImageLabel"
        ImageLabel.Position = UDim2.new(0,-25,0,-25)
        ImageLabel.Size = UDim2.new(1,50,1,50)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = "rbxassetid://6014261993"
        ImageLabel.ImageColor3 = Color3.fromRGB(0,0,0)
        ImageLabel.ImageTransparency = 0.6
        ImageLabel.ScaleType = Enum.ScaleType.Slice
        ImageLabel.SliceCenter = Rect.new(49,49,450,450)
        ImageLabel.Parent = Frame

        local CanvasGroup = Instance.new("CanvasGroup")
        CanvasGroup.Name = "CanvasGroup"
        CanvasGroup.Size = UDim2.new(1,0,1,0)
        CanvasGroup.BackgroundColor3 = Color3.fromRGB(20,16,20)
        CanvasGroup.BorderSizePixel = 0
        CanvasGroup.Parent = Frame

            local UICorner = Instance.new("UICorner")
            UICorner.Name = "UICorner"
            UICorner.CornerRadius = UDim.new(0,10)
            UICorner.Parent = CanvasGroup

            local ImageLabel2 = Instance.new("ImageLabel")
            ImageLabel2.Name = "ImageLabel"
            ImageLabel2.AnchorPoint = Vector2.new(0.5,0.5)
            ImageLabel2.Position = UDim2.new(0,300,0,348)
            ImageLabel2.Size = UDim2.new(0,500,0,180)
            ImageLabel2.BackgroundTransparency = 1
            ImageLabel2.Image = "rbxassetid://8992230677"
            ImageLabel2.ImageColor3 = Color3.fromRGB(226,218,230)
            ImageLabel2.ImageTransparency = 0.86
            ImageLabel2.Parent = CanvasGroup

                local UIGradient = Instance.new("UIGradient")
                UIGradient.Name = "UIGradient"
                UIGradient.Color = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(235,199,246))
                UIGradient.Rotation = 270
                UIGradient.Parent = ImageLabel2

            local ImageLabel3 = Instance.new("ImageLabel")
            ImageLabel3.Name = "ImageLabel"
            ImageLabel3.AnchorPoint = Vector2.new(0.5,0.5)
            ImageLabel3.Position = UDim2.new(0,-10,0,330)
            ImageLabel3.Size = UDim2.new(0,130,0,60)
            ImageLabel3.BackgroundTransparency = 1
            ImageLabel3.Image = "rbxassetid://8992230677"
            ImageLabel3.ImageColor3 = Color3.fromRGB(226,218,230)
            ImageLabel3.ImageTransparency = 0.75
            ImageLabel3.Parent = CanvasGroup

                local UIGradient2 = Instance.new("UIGradient")
                UIGradient2.Name = "UIGradient"
                UIGradient2.Color = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(235,199,246))
                UIGradient2.Rotation = 90
                UIGradient2.Parent = ImageLabel3

            local ImageLabel4 = Instance.new("ImageLabel")
            ImageLabel4.Name = "ImageLabel"
            ImageLabel4.AnchorPoint = Vector2.new(0.5,0.5)
            ImageLabel4.Position = UDim2.new(0,586,0,10)
            ImageLabel4.Size = UDim2.new(0,520,0,240)
            ImageLabel4.BackgroundTransparency = 1
            ImageLabel4.Image = "rbxassetid://8992230677"
            ImageLabel4.ImageColor3 = Color3.fromRGB(226,218,230)
            ImageLabel4.ImageTransparency = 0.92
            ImageLabel4.Parent = CanvasGroup

                local UIGradient3 = Instance.new("UIGradient")
                UIGradient3.Name = "UIGradient"
                UIGradient3.Color = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(235,199,246))
                UIGradient3.Rotation = 90
                UIGradient3.Parent = ImageLabel4

            local ImageLabel5 = Instance.new("ImageLabel")
            ImageLabel5.Name = "ImageLabel"
            ImageLabel5.AnchorPoint = Vector2.new(0.5,0.5)
            ImageLabel5.Position = UDim2.new(0,6,0,-6)
            ImageLabel5.Size = UDim2.new(0,90,0,180)
            ImageLabel5.BackgroundTransparency = 1
            ImageLabel5.Image = "rbxassetid://8992230677"
            ImageLabel5.ImageColor3 = Color3.fromRGB(226,218,230)
            ImageLabel5.ImageTransparency = 0.78
            ImageLabel5.Parent = CanvasGroup

                local UIGradient4 = Instance.new("UIGradient")
                UIGradient4.Name = "UIGradient"
                UIGradient4.Color = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(235,199,246))
                UIGradient4.Rotation = 90
                UIGradient4.Parent = ImageLabel5

            local Frame2 = Instance.new("Frame")
            Frame2.Name = "Frame"
            Frame2.Size = UDim2.new(0,356,0,340)
            Frame2.BackgroundTransparency = 1
            Frame2.Parent = CanvasGroup

                local ImageLabel6 = Instance.new("ImageLabel")
                ImageLabel6.Name = "ImageLabel"
                ImageLabel6.Position = UDim2.new(0,28,0,26)
                ImageLabel6.Size = UDim2.new(0,44,0,40)
                ImageLabel6.BackgroundTransparency = 1
                ImageLabel6.Image = "rbxassetid://103859712365480"
                ImageLabel6.ImageColor3 = Color3.fromRGB(235,199,246)
                ImageLabel6.ScaleType = Enum.ScaleType.Fit
                ImageLabel6.Parent = Frame2

                local TextLabel = Instance.new("TextLabel")
                TextLabel.Name = "TextLabel"
                TextLabel.Position = UDim2.new(0,82,0,28)
                TextLabel.Size = UDim2.new(0,200,0,24)
                TextLabel.BackgroundTransparency = 1
                TextLabel.Text = "Nexora"
                TextLabel.TextColor3 = Color3.fromRGB(233,229,234)
                TextLabel.TextSize = 22
                TextLabel.Font = Enum.Font.Unknown
                TextLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextLabel.Parent = Frame2

                local TextLabel2 = Instance.new("TextLabel")
                TextLabel2.Name = "TextLabel"
                TextLabel2.Position = UDim2.new(0,82,0,52)
                TextLabel2.Size = UDim2.new(0,200,0,14)
                TextLabel2.BackgroundTransparency = 1
                TextLabel2.Text = "Key system"
                TextLabel2.TextColor3 = Color3.fromRGB(125,115,126)
                TextLabel2.TextSize = 12
                TextLabel2.Font = Enum.Font.Unknown
                TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
                TextLabel2.Parent = Frame2

                local TextLabel3 = Instance.new("TextLabel")
                TextLabel3.Name = "TextLabel"
                TextLabel3.Position = UDim2.new(0,28,0,100)
                TextLabel3.Size = UDim2.new(0,200,0,14)
                TextLabel3.BackgroundTransparency = 1
                TextLabel3.Text = "License key"
                TextLabel3.TextColor3 = Color3.fromRGB(125,115,126)
                TextLabel3.TextSize = 11
                TextLabel3.Font = Enum.Font.Unknown
                TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
                TextLabel3.Parent = Frame2

                local Frame3 = Instance.new("Frame")
                Frame3.Name = "Frame"
                Frame3.Position = UDim2.new(0,28,0,120)
                Frame3.Size = UDim2.new(0,300,0,40)
                Frame3.BackgroundColor3 = Color3.fromRGB(24,19,24)
                Frame3.BorderSizePixel = 0
                Frame3.Parent = Frame2

                    local UICorner2 = Instance.new("UICorner")
                    UICorner2.Name = "UICorner"
                    UICorner2.Parent = Frame3

                    local UIStroke = Instance.new("UIStroke")
                    UIStroke.Name = "UIStroke"
                    UIStroke.Color = Color3.fromRGB(40,32,41)
                    UIStroke.Parent = Frame3

                    local Frame4 = Instance.new("Frame")
                    Frame4.Name = "Frame"
                    Frame4.Position = UDim2.new(0,13,0,12)
                    Frame4.Size = UDim2.new(0,16,0,16)
                    Frame4.BackgroundTransparency = 1
                    Frame4.Parent = Frame3

                        local iconglow = Instance.new("ImageLabel")
                        iconglow.Name = "iconglow"
                        iconglow.ZIndex = 0
                        iconglow.AnchorPoint = Vector2.new(0.5,0.5)
                        iconglow.Position = UDim2.new(0.5,0,0.5,0)
                        iconglow.Size = UDim2.new(2,0,2,0)
                        iconglow.BackgroundTransparency = 1
                        iconglow.Image = "rbxassetid://8992230677"
                        iconglow.ImageColor3 = Color3.fromRGB(125,115,126)
                        iconglow.ImageTransparency = 0.9
                        iconglow.Parent = Frame4

                        local ImageLabel7 = Instance.new("ImageLabel")
                        ImageLabel7.Name = "ImageLabel"
                        ImageLabel7.Size = UDim2.new(1,0,1,0)
                        ImageLabel7.BackgroundTransparency = 1
                        ImageLabel7.Image = "rbxassetid://122605056588923"
                        ImageLabel7.ImageColor3 = Color3.fromRGB(125,115,126)
                        ImageLabel7.ImageRectOffset = Vector2.new(975,50)
                        ImageLabel7.ImageRectSize = Vector2.new(24,24)
                        ImageLabel7.Parent = Frame4

                    local TextBox = Instance.new("TextBox")
                    TextBox.Name = "TextBox"
                    TextBox.Position = UDim2.new(0,40,0,0)
                    TextBox.Size = UDim2.new(1,-52,1,0)
                    TextBox.BackgroundTransparency = 1
                    TextBox.Text = ""
                    TextBox.TextColor3 = Color3.fromRGB(233,229,234)
                    TextBox.TextSize = 13
                    TextBox.Font = Enum.Font.Unknown
                    TextBox.TextXAlignment = Enum.TextXAlignment.Left
                    TextBox.PlaceholderText = "Paste your key here"
                    TextBox.PlaceholderColor3 = Color3.fromRGB(125,115,126)
                    TextBox.ClearTextOnFocus = false
                    TextBox.Parent = Frame3

                local TextLabel4 = Instance.new("TextLabel")
                TextLabel4.Name = "TextLabel"
                TextLabel4.Position = UDim2.new(0,28,0,232)
                TextLabel4.Size = UDim2.new(0,300,0,16)
                TextLabel4.BackgroundTransparency = 1
                TextLabel4.Text = ""
                TextLabel4.TextColor3 = Color3.fromRGB(125,115,126)
                TextLabel4.TextSize = 12
                TextLabel4.Font = Enum.Font.Unknown
                TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
                TextLabel4.TextTruncate = Enum.TextTruncate.AtEnd
                TextLabel4.Parent = Frame2

                local TextLabel5 = Instance.new("TextLabel")
                TextLabel5.Name = "TextLabel"
                TextLabel5.Position = UDim2.new(0,28,0,296)
                TextLabel5.Size = UDim2.new(0,300,0,14)
                TextLabel5.BackgroundTransparency = 1
                TextLabel5.Text = "Your key is saved, you only enter it once"
                TextLabel5.TextColor3 = Color3.fromRGB(125,115,126)
                TextLabel5.TextSize = 11
                TextLabel5.Font = Enum.Font.Unknown
                TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
                TextLabel5.Parent = Frame2

                local TextButton = Instance.new("TextButton")
                TextButton.Name = "TextButton"
                TextButton.Position = UDim2.new(0,28,0,176)
                TextButton.Size = UDim2.new(0,144,0,38)
                TextButton.BackgroundColor3 = Color3.fromRGB(235,199,246)
                TextButton.BackgroundTransparency = 0.12
                TextButton.Text = "Submit"
                TextButton.TextColor3 = Color3.fromRGB(24,18,26)
                TextButton.TextSize = 13
                TextButton.Font = Enum.Font.Unknown
                TextButton.AutoButtonColor = false
                TextButton.Parent = Frame2

                    local UICorner3 = Instance.new("UICorner")
                    UICorner3.Name = "UICorner"
                    UICorner3.Parent = TextButton

                    local UIStroke2 = Instance.new("UIStroke")
                    UIStroke2.Name = "UIStroke"
                    UIStroke2.Color = Color3.fromRGB(235,199,246)
                    UIStroke2.Transparency = 0.4
                    UIStroke2.Parent = TextButton

                    local UIPadding = Instance.new("UIPadding")
                    UIPadding.Name = "UIPadding"
                    UIPadding.PaddingLeft = UDim.new(0,24)
                    UIPadding.Parent = TextButton

                    local Frame5 = Instance.new("Frame")
                    Frame5.Name = "Frame"
                    Frame5.Position = UDim2.new(0,-12,0,11)
                    Frame5.Size = UDim2.new(0,16,0,16)
                    Frame5.BackgroundTransparency = 1
                    Frame5.Parent = TextButton

                        local iconglow2 = Instance.new("ImageLabel")
                        iconglow2.Name = "iconglow"
                        iconglow2.ZIndex = 0
                        iconglow2.AnchorPoint = Vector2.new(0.5,0.5)
                        iconglow2.Position = UDim2.new(0.5,0,0.5,0)
                        iconglow2.Size = UDim2.new(2,0,2,0)
                        iconglow2.BackgroundTransparency = 1
                        iconglow2.Image = "rbxassetid://8992230677"
                        iconglow2.ImageColor3 = Color3.fromRGB(24,18,26)
                        iconglow2.ImageTransparency = 0.9
                        iconglow2.Parent = Frame5

                        local ImageLabel8 = Instance.new("ImageLabel")
                        ImageLabel8.Name = "ImageLabel"
                        ImageLabel8.Size = UDim2.new(1,0,1,0)
                        ImageLabel8.BackgroundTransparency = 1
                        ImageLabel8.Image = "rbxassetid://122605056588923"
                        ImageLabel8.ImageColor3 = Color3.fromRGB(24,18,26)
                        ImageLabel8.ImageRectOffset = Vector2.new(200,100)
                        ImageLabel8.ImageRectSize = Vector2.new(24,24)
                        ImageLabel8.Parent = Frame5

                local TextButton2 = Instance.new("TextButton")
                TextButton2.Name = "TextButton"
                TextButton2.Position = UDim2.new(0,184,0,176)
                TextButton2.Size = UDim2.new(0,144,0,38)
                TextButton2.BackgroundColor3 = Color3.fromRGB(42,36,43)
                TextButton2.Text = "Get a key"
                TextButton2.TextColor3 = Color3.fromRGB(233,229,234)
                TextButton2.TextSize = 13
                TextButton2.Font = Enum.Font.Unknown
                TextButton2.AutoButtonColor = false
                TextButton2.Parent = Frame2

                    local UICorner4 = Instance.new("UICorner")
                    UICorner4.Name = "UICorner"
                    UICorner4.Parent = TextButton2

                    local UIStroke3 = Instance.new("UIStroke")
                    UIStroke3.Name = "UIStroke"
                    UIStroke3.Color = Color3.fromRGB(40,32,41)
                    UIStroke3.Parent = TextButton2

                    local UIPadding2 = Instance.new("UIPadding")
                    UIPadding2.Name = "UIPadding"
                    UIPadding2.PaddingLeft = UDim.new(0,24)
                    UIPadding2.Parent = TextButton2

                    local Frame6 = Instance.new("Frame")
                    Frame6.Name = "Frame"
                    Frame6.Position = UDim2.new(0,-12,0,11)
                    Frame6.Size = UDim2.new(0,16,0,16)
                    Frame6.BackgroundTransparency = 1
                    Frame6.Parent = TextButton2

                        local iconglow3 = Instance.new("ImageLabel")
                        iconglow3.Name = "iconglow"
                        iconglow3.ZIndex = 0
                        iconglow3.AnchorPoint = Vector2.new(0.5,0.5)
                        iconglow3.Position = UDim2.new(0.5,0,0.5,0)
                        iconglow3.Size = UDim2.new(2,0,2,0)
                        iconglow3.BackgroundTransparency = 1
                        iconglow3.Image = "rbxassetid://8992230677"
                        iconglow3.ImageColor3 = Color3.fromRGB(233,229,234)
                        iconglow3.ImageTransparency = 0.9
                        iconglow3.Parent = Frame6

                        local ImageLabel9 = Instance.new("ImageLabel")
                        ImageLabel9.Name = "ImageLabel"
                        ImageLabel9.Size = UDim2.new(1,0,1,0)
                        ImageLabel9.BackgroundTransparency = 1
                        ImageLabel9.Image = "rbxassetid://122605056588923"
                        ImageLabel9.ImageColor3 = Color3.fromRGB(233,229,234)
                        ImageLabel9.ImageRectOffset = Vector2.new(450,500)
                        ImageLabel9.ImageRectSize = Vector2.new(24,24)
                        ImageLabel9.Parent = Frame6

            local Frame7 = Instance.new("Frame")
            Frame7.Name = "Frame"
            Frame7.Position = UDim2.new(0,356,0,28)
            Frame7.Size = UDim2.new(0,1,1,-56)
            Frame7.BackgroundColor3 = Color3.fromRGB(40,32,41)
            Frame7.BorderSizePixel = 0
            Frame7.Parent = CanvasGroup

            local Frame8 = Instance.new("Frame")
            Frame8.Name = "Frame"
            Frame8.Position = UDim2.new(0,357,0,0)
            Frame8.Size = UDim2.new(0,244,0,340)
            Frame8.BackgroundTransparency = 1
            Frame8.Parent = CanvasGroup

                local TextLabel6 = Instance.new("TextLabel")
                TextLabel6.Name = "TextLabel"
                TextLabel6.Position = UDim2.new(0,28,0,30)
                TextLabel6.Size = UDim2.new(0,184,0,14)
                TextLabel6.BackgroundTransparency = 1
                TextLabel6.Text = "Detected game"
                TextLabel6.TextColor3 = Color3.fromRGB(125,115,126)
                TextLabel6.TextSize = 11
                TextLabel6.Font = Enum.Font.Unknown
                TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
                TextLabel6.Parent = Frame8

                local Frame9 = Instance.new("Frame")
                Frame9.Name = "Frame"
                Frame9.Position = UDim2.new(0,28,0,50)
                Frame9.Size = UDim2.new(0,188,0,60)
                Frame9.BackgroundColor3 = Color3.fromRGB(28,22,28)
                Frame9.BorderSizePixel = 0
                Frame9.Parent = Frame8

                    local UICorner5 = Instance.new("UICorner")
                    UICorner5.Name = "UICorner"
                    UICorner5.Parent = Frame9

                    local UIStroke4 = Instance.new("UIStroke")
                    UIStroke4.Name = "UIStroke"
                    UIStroke4.Color = Color3.fromRGB(40,32,41)
                    UIStroke4.Parent = Frame9

                    local ImageLabel10 = Instance.new("ImageLabel")
                    ImageLabel10.Name = "ImageLabel"
                    ImageLabel10.Position = UDim2.new(0,11,0,11)
                    ImageLabel10.Size = UDim2.new(0,38,0,38)
                    ImageLabel10.BackgroundColor3 = Color3.fromRGB(24,19,24)
                    ImageLabel10.BorderSizePixel = 0
                    ImageLabel10.Image = "rbxassetid://74584987850498"
                    ImageLabel10.Parent = Frame9

                        local UICorner6 = Instance.new("UICorner")
                        UICorner6.Name = "UICorner"
                        UICorner6.CornerRadius = UDim.new(0,7)
                        UICorner6.Parent = ImageLabel10

                        local UIStroke5 = Instance.new("UIStroke")
                        UIStroke5.Name = "UIStroke"
                        UIStroke5.Color = Color3.fromRGB(40,32,41)
                        UIStroke5.Parent = ImageLabel10

                    local TextLabel7 = Instance.new("TextLabel")
                    TextLabel7.Name = "TextLabel"
                    TextLabel7.Position = UDim2.new(0,58,0,15)
                    TextLabel7.Size = UDim2.new(0,122,0,14)
                    TextLabel7.BackgroundTransparency = 1
                    TextLabel7.Text = "[UP] Just a baseplate."
                    TextLabel7.TextColor3 = Color3.fromRGB(233,229,234)
                    TextLabel7.TextSize = 12
                    TextLabel7.Font = Enum.Font.Unknown
                    TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
                    TextLabel7.TextTruncate = Enum.TextTruncate.AtEnd
                    TextLabel7.Parent = Frame9

                    local TextLabel8 = Instance.new("TextLabel")
                    TextLabel8.Name = "TextLabel"
                    TextLabel8.Position = UDim2.new(0,58,0,32)
                    TextLabel8.Size = UDim2.new(0,122,0,13)
                    TextLabel8.BackgroundTransparency = 1
                    TextLabel8.Text = "Not in our list"
                    TextLabel8.TextColor3 = Color3.fromRGB(125,115,126)
                    TextLabel8.TextSize = 11
                    TextLabel8.Font = Enum.Font.Unknown
                    TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
                    TextLabel8.TextTruncate = Enum.TextTruncate.AtEnd
                    TextLabel8.Parent = Frame9

                local TextLabel9 = Instance.new("TextLabel")
                TextLabel9.Name = "TextLabel"
                TextLabel9.Position = UDim2.new(0,28,0,126)
                TextLabel9.Size = UDim2.new(0,90,0,14)
                TextLabel9.BackgroundTransparency = 1
                TextLabel9.Text = "Executor"
                TextLabel9.TextColor3 = Color3.fromRGB(125,115,126)
                TextLabel9.TextSize = 11
                TextLabel9.Font = Enum.Font.Unknown
                TextLabel9.TextXAlignment = Enum.TextXAlignment.Left
                TextLabel9.Parent = Frame8

                local TextLabel10 = Instance.new("TextLabel")
                TextLabel10.Name = "TextLabel"
                TextLabel10.Position = UDim2.new(0,120,0,126)
                TextLabel10.Size = UDim2.new(0,96,0,14)
                TextLabel10.BackgroundTransparency = 1
                TextLabel10.Text = "Delta"
                TextLabel10.TextColor3 = Color3.fromRGB(233,229,234)
                TextLabel10.TextSize = 11
                TextLabel10.Font = Enum.Font.Unknown
                TextLabel10.TextXAlignment = Enum.TextXAlignment.Right
                TextLabel10.TextTruncate = Enum.TextTruncate.AtEnd
                TextLabel10.Parent = Frame8

                local TextLabel11 = Instance.new("TextLabel")
                TextLabel11.Name = "TextLabel"
                TextLabel11.Position = UDim2.new(0,28,0,148)
                TextLabel11.Size = UDim2.new(0,90,0,14)
                TextLabel11.BackgroundTransparency = 1
                TextLabel11.Text = "Status"
                TextLabel11.TextColor3 = Color3.fromRGB(125,115,126)
                TextLabel11.TextSize = 11
                TextLabel11.Font = Enum.Font.Unknown
                TextLabel11.TextXAlignment = Enum.TextXAlignment.Left
                TextLabel11.Parent = Frame8

                local TextLabel12 = Instance.new("TextLabel")
                TextLabel12.Name = "TextLabel"
                TextLabel12.Position = UDim2.new(0,120,0,148)
                TextLabel12.Size = UDim2.new(0,96,0,14)
                TextLabel12.BackgroundTransparency = 1
                TextLabel12.Text = "Key required"
                TextLabel12.TextColor3 = Color3.fromRGB(240,176,108)
                TextLabel12.TextSize = 11
                TextLabel12.Font = Enum.Font.Unknown
                TextLabel12.TextXAlignment = Enum.TextXAlignment.Right
                TextLabel12.TextTruncate = Enum.TextTruncate.AtEnd
                TextLabel12.Parent = Frame8

                local Frame10 = Instance.new("Frame")
                Frame10.Name = "Frame"
                Frame10.Position = UDim2.new(0,28,0,176)
                Frame10.Size = UDim2.new(0,188,0,1)
                Frame10.BackgroundColor3 = Color3.fromRGB(40,32,41)
                Frame10.BorderSizePixel = 0
                Frame10.Parent = Frame8

                local TextButton3 = Instance.new("TextButton")
                TextButton3.Name = "TextButton"
                TextButton3.Position = UDim2.new(0,28,0,190)
                TextButton3.Size = UDim2.new(0,188,0,48)
                TextButton3.BackgroundColor3 = Color3.fromRGB(28,22,28)
                TextButton3.Text = ""
                TextButton3.AutoButtonColor = false
                TextButton3.Parent = Frame8

                    local UICorner7 = Instance.new("UICorner")
                    UICorner7.Name = "UICorner"
                    UICorner7.Parent = TextButton3

                    local UIStroke6 = Instance.new("UIStroke")
                    UIStroke6.Name = "UIStroke"
                    UIStroke6.Color = Color3.fromRGB(40,32,41)
                    UIStroke6.Parent = TextButton3

                    local Frame11 = Instance.new("Frame")
                    Frame11.Name = "Frame"
                    Frame11.Position = UDim2.new(0,13,0,16)
                    Frame11.Size = UDim2.new(0,16,0,16)
                    Frame11.BackgroundTransparency = 1
                    Frame11.Parent = TextButton3

                        local iconglow4 = Instance.new("ImageLabel")
                        iconglow4.Name = "iconglow"
                        iconglow4.ZIndex = 0
                        iconglow4.AnchorPoint = Vector2.new(0.5,0.5)
                        iconglow4.Position = UDim2.new(0.5,0,0.5,0)
                        iconglow4.Size = UDim2.new(2,0,2,0)
                        iconglow4.BackgroundTransparency = 1
                        iconglow4.Image = "rbxassetid://8992230677"
                        iconglow4.ImageColor3 = Color3.fromRGB(235,199,246)
                        iconglow4.ImageTransparency = 0.9
                        iconglow4.Parent = Frame11

                        local ImageLabel11 = Instance.new("ImageLabel")
                        ImageLabel11.Name = "ImageLabel"
                        ImageLabel11.Size = UDim2.new(1,0,1,0)
                        ImageLabel11.BackgroundTransparency = 1
                        ImageLabel11.Image = "rbxassetid://122605056588923"
                        ImageLabel11.ImageColor3 = Color3.fromRGB(235,199,246)
                        ImageLabel11.ImageRectOffset = Vector2.new(325,775)
                        ImageLabel11.ImageRectSize = Vector2.new(24,24)
                        ImageLabel11.Parent = Frame11

                    local TextLabel13 = Instance.new("TextLabel")
                    TextLabel13.Name = "TextLabel"
                    TextLabel13.Position = UDim2.new(0,40,0,10)
                    TextLabel13.Size = UDim2.new(0,120,0,14)
                    TextLabel13.BackgroundTransparency = 1
                    TextLabel13.Text = "Discord"
                    TextLabel13.TextColor3 = Color3.fromRGB(233,229,234)
                    TextLabel13.TextSize = 12
                    TextLabel13.Font = Enum.Font.Unknown
                    TextLabel13.TextXAlignment = Enum.TextXAlignment.Left
                    TextLabel13.Parent = TextButton3

                    local TextLabel14 = Instance.new("TextLabel")
                    TextLabel14.Name = "TextLabel"
                    TextLabel14.Position = UDim2.new(0,40,0,25)
                    TextLabel14.Size = UDim2.new(0,132,0,13)
                    TextLabel14.BackgroundTransparency = 1
                    TextLabel14.Text = "discord.gg/rxsAtJtWbF"
                    TextLabel14.TextColor3 = Color3.fromRGB(125,115,126)
                    TextLabel14.TextSize = 11
                    TextLabel14.Font = Enum.Font.Unknown
                    TextLabel14.TextXAlignment = Enum.TextXAlignment.Left
                    TextLabel14.TextTruncate = Enum.TextTruncate.AtEnd
                    TextLabel14.Parent = TextButton3

                local TextButton4 = Instance.new("TextButton")
                TextButton4.Name = "TextButton"
                TextButton4.Position = UDim2.new(0,28,0,246)
                TextButton4.Size = UDim2.new(0,188,0,48)
                TextButton4.BackgroundColor3 = Color3.fromRGB(28,22,28)
                TextButton4.Text = ""
                TextButton4.AutoButtonColor = false
                TextButton4.Parent = Frame8

                    local UICorner8 = Instance.new("UICorner")
                    UICorner8.Name = "UICorner"
                    UICorner8.Parent = TextButton4

                    local UIStroke7 = Instance.new("UIStroke")
                    UIStroke7.Name = "UIStroke"
                    UIStroke7.Color = Color3.fromRGB(40,32,41)
                    UIStroke7.Parent = TextButton4

                    local Frame12 = Instance.new("Frame")
                    Frame12.Name = "Frame"
                    Frame12.Position = UDim2.new(0,13,0,16)
                    Frame12.Size = UDim2.new(0,16,0,16)
                    Frame12.BackgroundTransparency = 1
                    Frame12.Parent = TextButton4

                        local iconglow5 = Instance.new("ImageLabel")
                        iconglow5.Name = "iconglow"
                        iconglow5.ZIndex = 0
                        iconglow5.AnchorPoint = Vector2.new(0.5,0.5)
                        iconglow5.Position = UDim2.new(0.5,0,0.5,0)
                        iconglow5.Size = UDim2.new(2,0,2,0)
                        iconglow5.BackgroundTransparency = 1
                        iconglow5.Image = "rbxassetid://8992230677"
                        iconglow5.ImageColor3 = Color3.fromRGB(235,199,246)
                        iconglow5.ImageTransparency = 0.9
                        iconglow5.Parent = Frame12

                        local ImageLabel12 = Instance.new("ImageLabel")
                        ImageLabel12.Name = "ImageLabel"
                        ImageLabel12.Size = UDim2.new(1,0,1,0)
                        ImageLabel12.BackgroundTransparency = 1
                        ImageLabel12.Image = "rbxassetid://122605056588923"
                        ImageLabel12.ImageColor3 = Color3.fromRGB(235,199,246)
                        ImageLabel12.ImageRectOffset = Vector2.new(450,500)
                        ImageLabel12.ImageRectSize = Vector2.new(24,24)
                        ImageLabel12.Parent = Frame12

                    local TextLabel15 = Instance.new("TextLabel")
                    TextLabel15.Name = "TextLabel"
                    TextLabel15.Position = UDim2.new(0,40,0,10)
                    TextLabel15.Size = UDim2.new(0,120,0,14)
                    TextLabel15.BackgroundTransparency = 1
                    TextLabel15.Text = "Website"
                    TextLabel15.TextColor3 = Color3.fromRGB(233,229,234)
                    TextLabel15.TextSize = 12
                    TextLabel15.Font = Enum.Font.Unknown
                    TextLabel15.TextXAlignment = Enum.TextXAlignment.Left
                    TextLabel15.Parent = TextButton4

                    local TextLabel16 = Instance.new("TextLabel")
                    TextLabel16.Name = "TextLabel"
                    TextLabel16.Position = UDim2.new(0,40,0,25)
                    TextLabel16.Size = UDim2.new(0,132,0,13)
                    TextLabel16.BackgroundTransparency = 1
                    TextLabel16.Text = "nexorascript.com"
                    TextLabel16.TextColor3 = Color3.fromRGB(125,115,126)
                    TextLabel16.TextSize = 11
                    TextLabel16.Font = Enum.Font.Unknown
                    TextLabel16.TextXAlignment = Enum.TextXAlignment.Left
                    TextLabel16.TextTruncate = Enum.TextTruncate.AtEnd
                    TextLabel16.Parent = TextButton4

for _, child in ipairs(pg:GetChildren()) do
    if child:IsA("ScreenGui") then
        child.Enabled = true
        child.ResetOnSpawn = false
        parentGui(child)
    end
end
