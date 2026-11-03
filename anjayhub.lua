-- ANJAY HUB V1
-- Created for ANJAY ISLAND
-- Place inside StarterPlayerScripts as a LocalScript

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- RemoteEvent dibuat oleh server game milikmu
local remote = ReplicatedStorage:WaitForChild("AnjayHubAction")

local gui = Instance.new("ScreenGui")
gui.Name = "ANJAY_HUB_V1"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 440, 0, 310)
main.Position = UDim2.new(0.5, -220, 0.5, -155)
main.BackgroundColor3 = Color3.fromRGB(12, 15, 12)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 255, 90)
stroke.Thickness = 2
stroke.Parent = main

-- HEADER
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -80, 0, 45)
header.Position = UDim2.new(0, 12, 0, 0)
header.BackgroundTransparency = 1
header.Text = "ANJAY HUB V1"
header.TextColor3 = Color3.fromRGB(0, 255, 90)
header.TextSize = 22
header.Font = Enum.Font.GothamBold
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = main

-- CLOSE BUTTON
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 35, 0, 30)
close.Position = UDim2.new(1, -43, 0, 8)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(130, 20, 20)
close.Font = Enum.Font.GothamBold
close.Parent = main

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- MINIMIZE BUTTON
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 35, 0, 30)
minimize.Position = UDim2.new(1, -83, 0, 8)
minimize.Text = "-"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.BackgroundColor3 = Color3.fromRGB(30, 90, 40)
minimize.Font = Enum.Font.GothamBold
minimize.Parent = main

local minimized = false

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, item in ipairs(main:GetChildren()) do
        if item ~= header and item ~= close
            and item ~= minimize and item ~= corner
            and item ~= stroke then
            item.Visible = not minimized
        end
    end
    main.Size = minimized
        and UDim2.new(0, 440, 0, 45)
        or UDim2.new(0, 440, 0, 310)
end)

-- CONTENT
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -60)
content.Position = UDim2.new(0, 10, 0, 50)
content.BackgroundTransparency = 1
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.Parent = content

local function createButton(name, action)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(24, 35, 25)
    button.TextColor3 = Color3.fromRGB(0, 255, 90)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Text = name
    button.Parent = content

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = button

    button.MouseButton1Click:Connect(function()
        action()
    end)

    return button
end

local function createToggle(name, action)
    local enabled = false

    local button = createButton(name .. ": OFF", function()
        enabled = not enabled
        button.Text = name .. (enabled and ": ON" or ": OFF")
        remote:FireServer(action, enabled)
    end)

    return button
end

-- AUTO REEL
createToggle("AUTO REEL", "AutoReel")

-- AUTO PLACE
createToggle("AUTO PLACE EGG", "AutoPlace")

-- AUTO SELL
createToggle("AUTO SELL EGG", "AutoSellEgg")
createToggle("AUTO SELL PET", "AutoSellPet")

-- REEL SPEED
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1, 0, 0, 35)
speedBox.BackgroundColor3 = Color3.fromRGB(24, 35, 25)
speedBox.TextColor3 = Color3.fromRGB(0, 255, 90)
speedBox.PlaceholderText = "Reel Speed (default 0.100)"
speedBox.Text = "0.100"
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.Parent = content

speedBox.FocusLost:Connect(function()
    local speed = tonumber(speedBox.Text)

    if speed and speed >= 0.05 and speed <= 5 then
        remote:FireServer("ReelSpeed", speed)
    else
        speedBox.Text = "0.100"
    end
end)

-- TELEPORT
createButton("TELEPORT: FISHING ISLAND", function()
    remote:FireServer("Teleport", "FishingIsland")
end)

createButton("TELEPORT: VOLCANO ISLAND", function()
    remote:FireServer("Teleport", "VolcanoIsland")
end)

createButton("TELEPORT: SAVANNA ISLAND", function()
    remote:FireServer("Teleport", "SavannaIsland")
end)

print("ANJAY HUB V1 Loaded")
