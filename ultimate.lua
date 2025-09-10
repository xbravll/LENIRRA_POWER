-- Advanced Multi-Feature Hub - Ultimate Roblox Tool
-- Press F to toggle GUI

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

-- Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

-- States
local guiVisible = false
local flyEnabled = false
local noclipEnabled = false
local speedEnabled = false
local jumpPowerEnabled = false
local infiniteJumpEnabled = false
local espEnabled = false
local fullbrightEnabled = false
local autoFarmEnabled = false
local clickTpEnabled = false

local flyConnection = nil
local noclipConnection = nil
local speedConnection = nil
local jumpConnection = nil
local espConnection = nil
local autoFarmConnection = nil
local flyObject = nil

local antiDetectionEnabled = true
local waypoints = {}
local espBoxes = {}
local originalJumpPower = 50
local originalWalkSpeed = 16
local customSpeed = 50
local customJumpPower = 100

-- Anti-Detection Settings
local maxTeleportDistance = 500
local teleportDelay = 0.1
local smoothTeleport = true

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedMultiHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 480, 0, 700)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -350)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 60)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 15)
titleFix.Position = UDim2.new(0, 0, 1, -15)
titleFix.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -70, 1, 0)
titleText.Position = UDim2.new(0, 20, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "⚡ LENIRRA_ZONE Hub v2.0"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 22
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 45, 0, 45)
closeBtn.Position = UDim2.new(1, -50, 0, 7.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 28
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 10)
closeBtnCorner.Parent = closeBtn

-- Tab System
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0, 10, 0, 70)
tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = mainFrame

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 8)
tabCorner.Parent = tabFrame

-- Tabs
local tabs = {"Movement", "Teleport", "Visual", "Misc", "Settings"}
local tabButtons = {}
local contentFrames = {}
local activeTab = 1

-- Create tab buttons
for i, tabName in pairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1/#tabs, -2, 1, -4)
    tabBtn.Position = UDim2.new((i-1)/#tabs, 1, 0, 2)
    tabBtn.BackgroundColor3 = i == 1 and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(50, 50, 50)
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.Parent = tabFrame
    
    local tabBtnCorner = Instance.new("UICorner")
    tabBtnCorner.CornerRadius = UDim.new(0, 6)
    tabBtnCorner.Parent = tabBtn
    
    tabButtons[i] = tabBtn
end

-- Content Area
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -20, 1, -130)
contentArea.Position = UDim2.new(0, 10, 0, 120)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

-- Create content frames for each tab
for i = 1, #tabs do
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.Position = UDim2.new(0, 0, 0, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 6
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)
    contentFrame.Visible = i == 1
    contentFrame.Parent = contentArea
    
    contentFrames[i] = contentFrame
end

-- Helper function to create feature frames
local function createFeatureFrame(parent, title, yPos, height)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, height or 80)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.6, 0, 0, 30)
    titleLabel.Position = UDim2.new(0, 15, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = frame
    
    return frame, titleLabel
end

local function createToggleButton(parent, xPos, yPos, initialState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 0, 35)
    btn.Position = UDim2.new(0, xPos, 0, yPos)
    btn.BackgroundColor3 = initialState and Color3.fromRGB(70, 255, 70) or Color3.fromRGB(255, 70, 70)
    btn.BorderSizePixel = 0
    btn.Text = initialState and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        local newState = btn.Text == "OFF"
        btn.Text = newState and "ON" or "OFF"
        btn.BackgroundColor3 = newState and Color3.fromRGB(70, 255, 70) or Color3.fromRGB(255, 70, 70)
        callback(newState)
    end)
    
    return btn
end

-- TAB 1: MOVEMENT
local movementTab = contentFrames[1]

-- Fly Feature
local flyFrame, flyTitle = createFeatureFrame(movementTab, "✈️ Advanced Fly Mode", 10)
local flyStatus = Instance.new("TextLabel")
flyStatus.Size = UDim2.new(0.6, 0, 0, 20)
flyStatus.Position = UDim2.new(0, 15, 0, 40)
flyStatus.BackgroundTransparency = 1
flyStatus.Text = "Status: OFF | Speed: 25"
flyStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
flyStatus.TextSize = 12
flyStatus.Font = Enum.Font.Gotham
flyStatus.TextXAlignment = Enum.TextXAlignment.Left
flyStatus.Parent = flyFrame

local flyToggle = createToggleButton(flyFrame, 350, 15, false, function(state)
    flyEnabled = state
    if state then
        startFly()
        flyStatus.Text = "Status: ON | Speed: " .. (speedBox and speedBox.Text or "25")
        flyStatus.TextColor3 = Color3.fromRGB(70, 255, 70)
    else
        stopFly()
        flyStatus.Text = "Status: OFF | Speed: " .. (speedBox and speedBox.Text or "25")
        flyStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
    end
end)

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 80, 0, 25)
speedBox.Position = UDim2.new(1, -170, 0, 50)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBox.BorderSizePixel = 0
speedBox.Text = "25"
speedBox.PlaceholderText = "Speed"
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextSize = 12
speedBox.Font = Enum.Font.Gotham
speedBox.TextXAlignment = Enum.TextXAlignment.Center
speedBox.Parent = flyFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 6)
speedCorner.Parent = speedBox

-- Noclip Feature
local noclipFrame, noclipTitle = createFeatureFrame(movementTab, "👻 Noclip Mode", 100)
local noclipStatus = Instance.new("TextLabel")
noclipStatus.Size = UDim2.new(0.6, 0, 0, 20)
noclipStatus.Position = UDim2.new(0, 15, 0, 40)
noclipStatus.BackgroundTransparency = 1
noclipStatus.Text = "Status: OFF"
noclipStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
noclipStatus.TextSize = 12
noclipStatus.Font = Enum.Font.Gotham
noclipStatus.TextXAlignment = Enum.TextXAlignment.Left
noclipStatus.Parent = noclipFrame

local noclipToggle = createToggleButton(noclipFrame, 350, 15, false, function(state)
    noclipEnabled = state
    if state then
        startNoclip()
        noclipStatus.Text = "Status: ON"
        noclipStatus.TextColor3 = Color3.fromRGB(70, 255, 70)
    else
        stopNoclip()
        noclipStatus.Text = "Status: OFF"
        noclipStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
    end
end)

-- Speed Hack Feature
local speedFrame, speedTitle = createFeatureFrame(movementTab, "🏃 Speed Hack", 190)
local speedHackStatus = Instance.new("TextLabel")
speedHackStatus.Size = UDim2.new(0.6, 0, 0, 20)
speedHackStatus.Position = UDim2.new(0, 15, 0, 40)
speedHackStatus.BackgroundTransparency = 1
speedHackStatus.Text = "Status: OFF | Speed: 50"
speedHackStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
speedHackStatus.TextSize = 12
speedHackStatus.Font = Enum.Font.Gotham
speedHackStatus.TextXAlignment = Enum.TextXAlignment.Left
speedHackStatus.Parent = speedFrame

local speedHackToggle = createToggleButton(speedFrame, 350, 15, false, function(state)
    speedEnabled = state
    toggleSpeed(state)
end)

local speedHackBox = Instance.new("TextBox")
speedHackBox.Size = UDim2.new(0, 80, 0, 25)
speedHackBox.Position = UDim2.new(1, -170, 0, 50)
speedHackBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedHackBox.BorderSizePixel = 0
speedHackBox.Text = "50"
speedHackBox.PlaceholderText = "Speed"
speedHackBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedHackBox.TextSize = 12
speedHackBox.Font = Enum.Font.Gotham
speedHackBox.TextXAlignment = Enum.TextXAlignment.Center
speedHackBox.Parent = speedFrame

local speedHackCorner = Instance.new("UICorner")
speedHackCorner.CornerRadius = UDim.new(0, 6)
speedHackCorner.Parent = speedHackBox

-- Jump Power Feature
local jumpFrame, jumpTitle = createFeatureFrame(movementTab, "🦘 Super Jump", 280)
local jumpStatus = Instance.new("TextLabel")
jumpStatus.Size = UDim2.new(0.6, 0, 0, 20)
jumpStatus.Position = UDim2.new(0, 15, 0, 40)
jumpStatus.BackgroundTransparency = 1
jumpStatus.Text = "Status: OFF | Power: 100"
jumpStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
jumpStatus.TextSize = 12
jumpStatus.Font = Enum.Font.Gotham
jumpStatus.TextXAlignment = Enum.TextXAlignment.Left
jumpStatus.Parent = jumpFrame

local jumpToggle = createToggleButton(jumpFrame, 350, 15, false, function(state)
    jumpPowerEnabled = state
    toggleJumpPower(state)
end)

local jumpBox = Instance.new("TextBox")
jumpBox.Size = UDim2.new(0, 80, 0, 25)
jumpBox.Position = UDim2.new(1, -170, 0, 50)
jumpBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
jumpBox.BorderSizePixel = 0
jumpBox.Text = "100"
jumpBox.PlaceholderText = "Power"
jumpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBox.TextSize = 12
jumpBox.Font = Enum.Font.Gotham
jumpBox.TextXAlignment = Enum.TextXAlignment.Center
jumpBox.Parent = jumpFrame

local jumpCorner = Instance.new("UICorner")
jumpCorner.CornerRadius = UDim.new(0, 6)
jumpCorner.Parent = jumpBox

-- Infinite Jump Feature
local infJumpFrame, infJumpTitle = createFeatureFrame(movementTab, "🚀 Infinite Jump", 370)
local infJumpStatus = Instance.new("TextLabel")
infJumpStatus.Size = UDim2.new(0.6, 0, 0, 20)
infJumpStatus.Position = UDim2.new(0, 15, 0, 40)
infJumpStatus.BackgroundTransparency = 1
infJumpStatus.Text = "Status: OFF"
infJumpStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
infJumpStatus.TextSize = 12
infJumpStatus.Font = Enum.Font.Gotham
infJumpStatus.TextXAlignment = Enum.TextXAlignment.Left
infJumpStatus.Parent = infJumpFrame

local infJumpToggle = createToggleButton(infJumpFrame, 350, 15, false, function(state)
    infiniteJumpEnabled = state
    toggleInfiniteJump(state)
end)

-- TAB 2: TELEPORT
local teleportTab = contentFrames[2]

-- Current Position
local currentPosFrame, currentPosTitle = createFeatureFrame(teleportTab, "📍 Current Position", 10, 100)
local currentPosLabel = Instance.new("TextLabel")
currentPosLabel.Size = UDim2.new(1, -140, 0, 25)
currentPosLabel.Position = UDim2.new(0, 15, 0, 40)
currentPosLabel.BackgroundTransparency = 1
currentPosLabel.Text = "X: 0, Y: 0, Z: 0"
currentPosLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
currentPosLabel.TextSize = 14
currentPosLabel.TextXAlignment = Enum.TextXAlignment.Left
currentPosLabel.Font = Enum.Font.Gotham
currentPosLabel.Parent = currentPosFrame

local saveWaypointBtn = Instance.new("TextButton")
saveWaypointBtn.Size = UDim2.new(0, 110, 0, 30)
saveWaypointBtn.Position = UDim2.new(1, -120, 0, 35)
saveWaypointBtn.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
saveWaypointBtn.BorderSizePixel = 0
saveWaypointBtn.Text = "Save Waypoint"
saveWaypointBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveWaypointBtn.TextSize = 12
saveWaypointBtn.Font = Enum.Font.GothamBold
saveWaypointBtn.Parent = currentPosFrame

local saveWaypointCorner = Instance.new("UICorner")
saveWaypointCorner.CornerRadius = UDim.new(0, 8)
saveWaypointCorner.Parent = saveWaypointBtn

local copyPosBtn = Instance.new("TextButton")
copyPosBtn.Size = UDim2.new(0, 80, 0, 25)
copyPosBtn.Position = UDim2.new(1, -100, 0, 70)
copyPosBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
copyPosBtn.BorderSizePixel = 0
copyPosBtn.Text = "Copy Pos"
copyPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyPosBtn.TextSize = 11
copyPosBtn.Font = Enum.Font.Gotham
copyPosBtn.Parent = currentPosFrame

local copyPosCorner = Instance.new("UICorner")
copyPosCorner.CornerRadius = UDim.new(0, 6)
copyPosCorner.Parent = copyPosBtn

-- Manual Teleport
local manualTpFrame, manualTpTitle = createFeatureFrame(teleportTab, "🎯 Manual Teleport", 120, 120)

local xBox = Instance.new("TextBox")
xBox.Size = UDim2.new(0, 100, 0, 30)
xBox.Position = UDim2.new(0, 15, 0, 40)
xBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
xBox.BorderSizePixel = 0
xBox.PlaceholderText = "X Position"
xBox.Text = ""
xBox.TextColor3 = Color3.fromRGB(255, 255, 255)
xBox.TextSize = 12
xBox.Font = Enum.Font.Gotham
xBox.Parent = manualTpFrame

local xBoxCorner = Instance.new("UICorner")
xBoxCorner.CornerRadius = UDim.new(0, 6)
xBoxCorner.Parent = xBox

local yBox = Instance.new("TextBox")
yBox.Size = UDim2.new(0, 100, 0, 30)
yBox.Position = UDim2.new(0, 125, 0, 40)
yBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
yBox.BorderSizePixel = 0
yBox.PlaceholderText = "Y Position"
yBox.Text = ""
yBox.TextColor3 = Color3.fromRGB(255, 255, 255)
yBox.TextSize = 12
yBox.Font = Enum.Font.Gotham
yBox.Parent = manualTpFrame

local yBoxCorner = Instance.new("UICorner")
yBoxCorner.CornerRadius = UDim.new(0, 6)
yBoxCorner.Parent = yBox

local zBox = Instance.new("TextBox")
zBox.Size = UDim2.new(0, 100, 0, 30)
zBox.Position = UDim2.new(0, 235, 0, 40)
zBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
zBox.BorderSizePixel = 0
zBox.PlaceholderText = "Z Position"
zBox.Text = ""
zBox.TextColor3 = Color3.fromRGB(255, 255, 255)
zBox.TextSize = 12
zBox.Font = Enum.Font.Gotham
zBox.Parent = manualTpFrame

local zBoxCorner = Instance.new("UICorner")
zBoxCorner.CornerRadius = UDim.new(0, 6)
zBoxCorner.Parent = zBox

local manualTpBtn = Instance.new("TextButton")
manualTpBtn.Size = UDim2.new(0, 90, 0, 30)
manualTpBtn.Position = UDim2.new(1, -100, 0, 40)
manualTpBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
manualTpBtn.BorderSizePixel = 0
manualTpBtn.Text = "Teleport"
manualTpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
manualTpBtn.TextSize = 13
manualTpBtn.Font = Enum.Font.GothamBold
manualTpBtn.Parent = manualTpFrame

local manualTpCorner = Instance.new("UICorner")
manualTpCorner.CornerRadius = UDim.new(0, 8)
manualTpCorner.Parent = manualTpBtn

-- Player Teleport
local playerTpFrame, playerTpTitle = createFeatureFrame(teleportTab, "👥 Player Teleport", 250, 100)

local playerNameBox = Instance.new("TextBox")
playerNameBox.Size = UDim2.new(1, -120, 0, 30)
playerNameBox.Position = UDim2.new(0, 15, 0, 40)
playerNameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
playerNameBox.BorderSizePixel = 0
playerNameBox.PlaceholderText = "Player name (partial works)"
playerNameBox.Text = ""
playerNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
playerNameBox.TextSize = 12
playerNameBox.Font = Enum.Font.Gotham
playerNameBox.Parent = playerTpFrame

local playerNameCorner = Instance.new("UICorner")
playerNameCorner.CornerRadius = UDim.new(0, 6)
playerNameCorner.Parent = playerNameBox

local playerTpBtn = Instance.new("TextButton")
playerTpBtn.Size = UDim2.new(0, 100, 0, 30)
playerTpBtn.Position = UDim2.new(1, -110, 0, 40)
playerTpBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
playerTpBtn.BorderSizePixel = 0
playerTpBtn.Text = "TP to Player"
playerTpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
playerTpBtn.TextSize = 12
playerTpBtn.Font = Enum.Font.GothamBold
playerTpBtn.Parent = playerTpFrame

local playerTpCorner = Instance.new("UICorner")
playerTpCorner.CornerRadius = UDim.new(0, 8)
playerTpCorner.Parent = playerTpBtn

-- Click to Teleport
local clickTpFrame, clickTpTitle = createFeatureFrame(teleportTab, "🖱️ Click Teleport", 360)
local clickTpStatus = Instance.new("TextLabel")
clickTpStatus.Size = UDim2.new(0.6, 0, 0, 20)
clickTpStatus.Position = UDim2.new(0, 15, 0, 40)
clickTpStatus.BackgroundTransparency = 1
clickTpStatus.Text = "Status: OFF (Hold Ctrl + Click)"
clickTpStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
clickTpStatus.TextSize = 12
clickTpStatus.Font = Enum.Font.Gotham
clickTpStatus.TextXAlignment = Enum.TextXAlignment.Left
clickTpStatus.Parent = clickTpFrame

local clickTpToggle = createToggleButton(clickTpFrame, 350, 15, false, function(state)
    clickTpEnabled = state
    toggleClickTeleport(state)
end)

-- TAB 3: VISUAL
local visualTab = contentFrames[3]

-- ESP Feature
local espFrame, espTitle = createFeatureFrame(visualTab, "👁️ Player ESP", 10)
local espStatus = Instance.new("TextLabel")
espStatus.Size = UDim2.new(0.6, 0, 0, 20)
espStatus.Position = UDim2.new(0, 15, 0, 40)
espStatus.BackgroundTransparency = 1
espStatus.Text = "Status: OFF"
espStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
espStatus.TextSize = 12
espStatus.Font = Enum.Font.Gotham
espStatus.TextXAlignment = Enum.TextXAlignment.Left
espStatus.Parent = espFrame

local espToggle = createToggleButton(espFrame, 350, 15, false, function(state)
    espEnabled = state
    toggleESP(state)
end)

-- Fullbright Feature
local fullbrightFrame, fullbrightTitle = createFeatureFrame(visualTab, "💡 Fullbright", 100)
local fullbrightStatus = Instance.new("TextLabel")
fullbrightStatus.Size = UDim2.new(0.6, 0, 0, 20)
fullbrightStatus.Position = UDim2.new(0, 15, 0, 40)
fullbrightStatus.BackgroundTransparency = 1
fullbrightStatus.Text = "Status: OFF"
fullbrightStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
fullbrightStatus.TextSize = 12
fullbrightStatus.Font = Enum.Font.Gotham
fullbrightStatus.TextXAlignment = Enum.TextXAlignment.Left
fullbrightStatus.Parent = fullbrightFrame

local fullbrightToggle = createToggleButton(fullbrightFrame, 350, 15, false, function(state)
    fullbrightEnabled = state
    toggleFullbright(state)
end)

-- TAB 4: MISC
local miscTab = contentFrames[4]

-- Auto Farm Feature
local autoFarmFrame, autoFarmTitle = createFeatureFrame(miscTab, "🤖 Simple Auto Farm", 10, 120)
local autoFarmStatus = Instance.new("TextLabel")
autoFarmStatus.Size = UDim2.new(0.6, 0, 0, 20)
autoFarmStatus.Position = UDim2.new(0, 15, 0, 40)
autoFarmStatus.BackgroundTransparency = 1
autoFarmStatus.Text = "Status: OFF"
autoFarmStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
autoFarmStatus.TextSize = 12
autoFarmStatus.Font = Enum.Font.Gotham
autoFarmStatus.TextXAlignment = Enum.TextXAlignment.Left
autoFarmStatus.Parent = autoFarmFrame

local autoFarmToggle = createToggleButton(autoFarmFrame, 350, 15, false, function(state)
    autoFarmEnabled = state
    toggleAutoFarm(state)
end)

local autoFarmInfo = Instance.new("TextLabel")
autoFarmInfo.Size = UDim2.new(1, -20, 0, 40)
autoFarmInfo.Position = UDim2.new(0, 10, 0, 65)
autoFarmInfo.BackgroundTransparency = 1
autoFarmInfo.Text = "Automatically collects nearby objects\nand teleports to spawn points"
autoFarmInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
autoFarmInfo.TextSize = 10
autoFarmInfo.TextXAlignment = Enum.TextXAlignment.Left
autoFarmInfo.TextYAlignment = Enum.TextYAlignment.Top
autoFarmInfo.Font = Enum.Font.Gotham
autoFarmInfo.Parent = autoFarmFrame

-- Rejoin Server
local rejoinFrame, rejoinTitle = createFeatureFrame(miscTab, "🔄 Server Utils", 140, 100)

local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Size = UDim2.new(0, 120, 0, 35)
rejoinBtn.Position = UDim2.new(0, 15, 0, 40)
rejoinBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
rejoinBtn.BorderSizePixel = 0
rejoinBtn.Text = "Rejoin Server"
rejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rejoinBtn.TextSize = 12
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.Parent = rejoinFrame

local rejoinCorner = Instance.new("UICorner")
rejoinCorner.CornerRadius = UDim.new(0, 8)
rejoinCorner.Parent = rejoinBtn

local serverHopBtn = Instance.new("TextButton")
serverHopBtn.Size = UDim2.new(0, 120, 0, 35)
serverHopBtn.Position = UDim2.new(0, 145, 0, 40)
serverHopBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
serverHopBtn.BorderSizePixel = 0
serverHopBtn.Text = "Server Hop"
serverHopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
serverHopBtn.TextSize = 12
serverHopBtn.Font = Enum.Font.GothamBold
serverHopBtn.Parent = rejoinFrame

local serverHopCorner = Instance.new("UICorner")
serverHopCorner.CornerRadius = UDim.new(0, 8)
serverHopCorner.Parent = serverHopBtn

local lowGfxBtn = Instance.new("TextButton")
lowGfxBtn.Size = UDim2.new(0, 120, 0, 35)
lowGfxBtn.Position = UDim2.new(0, 275, 0, 40)
lowGfxBtn.BackgroundColor3 = Color3.fromRGB(150, 75, 200)
lowGfxBtn.BorderSizePixel = 0
lowGfxBtn.Text = "Low Graphics"
lowGfxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
lowGfxBtn.TextSize = 12
lowGfxBtn.Font = Enum.Font.GothamBold
lowGfxBtn.Parent = rejoinFrame

local lowGfxCorner = Instance.new("UICorner")
lowGfxCorner.CornerRadius = UDim.new(0, 8)
lowGfxCorner.Parent = lowGfxBtn

-- Anti AFK
local antiAfkFrame, antiAfkTitle = createFeatureFrame(miscTab, "⏰ Anti AFK", 250)
local antiAfkStatus = Instance.new("TextLabel")
antiAfkStatus.Size = UDim2.new(0.6, 0, 0, 20)
antiAfkStatus.Position = UDim2.new(0, 15, 0, 40)
antiAfkStatus.BackgroundTransparency = 1
antiAfkStatus.Text = "Status: OFF"
antiAfkStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
antiAfkStatus.TextSize = 12
antiAfkStatus.Font = Enum.Font.Gotham
antiAfkStatus.TextXAlignment = Enum.TextXAlignment.Left
antiAfkStatus.Parent = antiAfkFrame

local antiAfkToggle = createToggleButton(antiAfkFrame, 350, 15, false, function(state)
    toggleAntiAFK(state)
end)

-- TAB 5: SETTINGS
local settingsTab = contentFrames[5]

-- Anti-Detection Settings
local antiDetectionFrame, antiDetectionTitle = createFeatureFrame(settingsTab, "🛡️ Anti-Detection Settings", 10, 160)

local antiDetectionToggle = Instance.new("TextButton")
antiDetectionToggle.Size = UDim2.new(0, 130, 0, 30)
antiDetectionToggle.Position = UDim2.new(0, 15, 0, 40)
antiDetectionToggle.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
antiDetectionToggle.BorderSizePixel = 0
antiDetectionToggle.Text = "SAFE MODE: ON"
antiDetectionToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
antiDetectionToggle.TextSize = 11
antiDetectionToggle.Font = Enum.Font.GothamBold
antiDetectionToggle.Parent = antiDetectionFrame

local antiDetectionCorner = Instance.new("UICorner")
antiDetectionCorner.CornerRadius = UDim.new(0, 8)
antiDetectionCorner.Parent = antiDetectionToggle

local distanceLabel = Instance.new("TextLabel")
distanceLabel.Size = UDim2.new(0, 100, 0, 30)
distanceLabel.Position = UDim2.new(0, 155, 0, 40)
distanceLabel.BackgroundTransparency = 1
distanceLabel.Text = "Max Distance:"
distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
distanceLabel.TextSize = 11
distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
distanceLabel.Font = Enum.Font.Gotham
distanceLabel.Parent = antiDetectionFrame

local distanceBox = Instance.new("TextBox")
distanceBox.Size = UDim2.new(0, 80, 0, 30)
distanceBox.Position = UDim2.new(1, -90, 0, 40)
distanceBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
distanceBox.BorderSizePixel = 0
distanceBox.Text = "500"
distanceBox.TextColor3 = Color3.fromRGB(255, 255, 255)
distanceBox.TextSize = 11
distanceBox.Font = Enum.Font.Gotham
distanceBox.TextXAlignment = Enum.TextXAlignment.Center
distanceBox.Parent = antiDetectionFrame

local distanceBoxCorner = Instance.new("UICorner")
distanceBoxCorner.CornerRadius = UDim.new(0, 6)
distanceBoxCorner.Parent = distanceBox

local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 100, 0, 30)
delayLabel.Position = UDim2.new(0, 15, 0, 80)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "TP Delay (s):"
delayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
delayLabel.TextSize = 11
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Font = Enum.Font.Gotham
delayLabel.Parent = antiDetectionFrame

local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(0, 80, 0, 30)
delayBox.Position = UDim2.new(0, 125, 0, 80)
delayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
delayBox.BorderSizePixel = 0
delayBox.Text = "0.1"
delayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayBox.TextSize = 11
delayBox.Font = Enum.Font.Gotham
delayBox.TextXAlignment = Enum.TextXAlignment.Center
delayBox.Parent = antiDetectionFrame

local delayBoxCorner = Instance.new("UICorner")
delayBoxCorner.CornerRadius = UDim.new(0, 6)
delayBoxCorner.Parent = delayBox

local smoothToggle = Instance.new("TextButton")
smoothToggle.Size = UDim2.new(0, 130, 0, 30)
smoothToggle.Position = UDim2.new(1, -140, 0, 80)
smoothToggle.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
smoothToggle.BorderSizePixel = 0
smoothToggle.Text = "SMOOTH TP: ON"
smoothToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
smoothToggle.TextSize = 11
smoothToggle.Font = Enum.Font.GothamBold
smoothToggle.Parent = antiDetectionFrame

local smoothToggleCorner = Instance.new("UICorner")
smoothToggleCorner.CornerRadius = UDim.new(0, 8)
smoothToggleCorner.Parent = smoothToggle

local settingsInfo = Instance.new("TextLabel")
settingsInfo.Size = UDim2.new(1, -20, 0, 40)
settingsInfo.Position = UDim2.new(0, 10, 0, 120)
settingsInfo.BackgroundTransparency = 1
settingsInfo.Text = "Safe Mode: Multi-step teleport for anti-detection\nSmooth TP: Tween animation instead of instant teleport"
settingsInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
settingsInfo.TextSize = 10
settingsInfo.TextXAlignment = Enum.TextXAlignment.Left
settingsInfo.TextYAlignment = Enum.TextYAlignment.Top
settingsInfo.Font = Enum.Font.Gotham
settingsInfo.Parent = antiDetectionFrame

-- Keybinds Info
local keybindsFrame, keybindsTitle = createFeatureFrame(settingsTab, "⌨️ Keybinds", 180, 200)
local keybindsText = Instance.new("TextLabel")
keybindsText.Size = UDim2.new(1, -20, 1, -40)
keybindsText.Position = UDim2.new(0, 10, 0, 35)
keybindsText.BackgroundTransparency = 1
keybindsText.Text = [[F - Toggle GUI
H - Toggle Fly ON/OFF
G - Toggle Noclip ON/OFF
R - Toggle Speed Hack ON/OFF
T - Toggle Jump Power ON/OFF
Y - Toggle Infinite Jump ON/OFF
U - Toggle ESP ON/OFF
I - Toggle Fullbright ON/OFF
Ctrl + Click - Click Teleport (when enabled)

FLIGHT CONTROLS:
W/A/S/D - Movement
Space - Up    Shift - Down
Ctrl - Speed Boost (2.5x)]]
keybindsText.TextColor3 = Color3.fromRGB(190, 190, 190)
keybindsText.TextSize = 11
keybindsText.TextXAlignment = Enum.TextXAlignment.Left
keybindsText.TextYAlignment = Enum.TextYAlignment.Top
keybindsText.Font = Enum.Font.Gotham
keybindsText.Parent = keybindsFrame

-- Credits
local creditsFrame, creditsTitle = createFeatureFrame(settingsTab, "👨‍💻 Credits & Info", 390, 100)
local creditsText = Instance.new("TextLabel")
creditsText.Size = UDim2.new(1, -20, 1, -40)
creditsText.Position = UDim2.new(0, 10, 0, 35)
creditsText.BackgroundTransparency = 1
creditsText.Text = [[LNR_Ultimate Hub v2.0 - Advanced Multi-Tool
Created by: Anonymous Developer
Features: Fly, Noclip, Speed, Jump, ESP, Teleport, 
Waypoints, Auto Farm, Anti-Detection & More!

Use responsibly and have fun! 🚀]]
creditsText.TextColor3 = Color3.fromRGB(150, 200, 255)
creditsText.TextSize = 11
creditsText.TextXAlignment = Enum.TextXAlignment.Left
creditsText.TextYAlignment = Enum.TextYAlignment.Top
creditsText.Font = Enum.Font.Gotham
creditsText.Parent = creditsFrame

-- FUNCTIONS
local function toggleGUI()
    guiVisible = not guiVisible
    
    if guiVisible then
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 480, 0, 700)
        }):Play()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        
        wait(0.2)
        mainFrame.Visible = false
    end
end

local function switchTab(tabIndex)
    activeTab = tabIndex
    
    for i = 1, #tabs do
        contentFrames[i].Visible = (i == tabIndex)
        tabButtons[i].BackgroundColor3 = (i == tabIndex) and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(50, 50, 50)
    end
end

local function updateCurrentPosition()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        currentPosLabel.Text = string.format("X: %.0f, Y: %.0f, Z: %.0f", pos.X, pos.Y, pos.Z)
    end
end

-- FLY FUNCTIONS
function startFly()
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not rootPart or not humanoid then return end
    
    flyObject = Instance.new("Part")
    flyObject.Name = "FlyPart"
    flyObject.Anchored = true
    flyObject.CanCollide = false
    flyObject.Transparency = 1
    flyObject.Size = Vector3.new(4, 1, 2)
    flyObject.CFrame = rootPart.CFrame
    flyObject.Parent = Workspace
    
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = rootPart
    weld.Part1 = flyObject
    weld.Parent = flyObject
    
    rootPart.Anchored = false
    humanoid.PlatformStand = true
    
    local speed = tonumber(speedBox.Text) or 200
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flyEnabled then return end
        
        local velocity = Vector3.new(0, 0, 0)
        local currentSpeed = speed
        
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            currentSpeed = speed * 2.5
        end
        
        local moveX = 0
        local moveZ = 0
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveZ = 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveZ = -1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveX = -1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveX = 1 end
        
        if moveX ~= 0 or moveZ ~= 0 then
            local lookDirection = camera.CFrame.LookVector
            local rightDirection = camera.CFrame.RightVector
            local moveDirection = (lookDirection * moveZ + rightDirection * moveX)
            if moveDirection.Magnitude > 0 then
                velocity = velocity + moveDirection.Unit * currentSpeed
            end
        end
        
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            local upDirection = camera.CFrame.UpVector
            velocity = velocity + upDirection * currentSpeed
        end
        
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            local upDirection = camera.CFrame.UpVector
            velocity = velocity - upDirection * currentSpeed
        end
        
        if velocity.Magnitude > 0 then
            local deltaTime = RunService.Heartbeat:Wait()
            flyObject.CFrame = flyObject.CFrame + velocity * deltaTime
        end
    end)
end

function stopFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    if flyObject then
        flyObject:Destroy()
        flyObject = nil
    end
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoid then
            humanoid.PlatformStand = false
        end
        
        if rootPart then
            rootPart.Anchored = false
        end
    end
end

-- NOCLIP FUNCTIONS
function startNoclip()
    noclipConnection = RunService.Stepped:Connect(function()
        if not noclipEnabled then return end
        
        local character = player.Character
        if not character then return end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

function stopNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    local character = player.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end

-- SPEED FUNCTIONS
function toggleSpeed(state)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    if state then
        originalWalkSpeed = humanoid.WalkSpeed
        customSpeed = tonumber(speedHackBox.Text) or 100
        humanoid.WalkSpeed = customSpeed
        speedHackStatus.Text = "Status: ON | Speed: " .. customSpeed
        speedHackStatus.TextColor3 = Color3.fromRGB(70, 255, 70)
    else
        humanoid.WalkSpeed = originalWalkSpeed
        speedHackStatus.Text = "Status: OFF | Speed: " .. (speedHackBox.Text or "100")
        speedHackStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
    end
end

-- JUMP FUNCTIONS
function toggleJumpPower(state)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    if state then
        originalJumpPower = humanoid.JumpPower
        customJumpPower = tonumber(jumpBox.Text) or 100
        humanoid.JumpPower = customJumpPower
        jumpStatus.Text = "Status: ON | Power: " .. customJumpPower
        jumpStatus.TextColor3 = Color3.fromRGB(70, 255, 70)
    else
        humanoid.JumpPower = originalJumpPower
        jumpStatus.Text = "Status: OFF | Power: " .. (jumpBox.Text or "100")
        jumpStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
    end
end

function toggleInfiniteJump(state)
    infiniteJumpEnabled = state
    if state then
        jumpConnection = UserInputService.JumpRequest:Connect(function()
            if infiniteJumpEnabled then
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end)
        infJumpStatus.Text = "Status: ON"
        infJumpStatus.TextColor3 = Color3.fromRGB(70, 255, 70)
    else
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
        infJumpStatus.Text = "Status: OFF"
        infJumpStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
    end
end

-- ESP FUNCTIONS
function toggleESP(state)
    espEnabled = state
    if state then
        espConnection = RunService.Heartbeat:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local character = player.Character
                    local rootPart = character.HumanoidRootPart
                    
                    if not espBoxes[player.Name] then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Size = rootPart.Size + Vector3.new(1, 1, 1)
                        box.Color3 = Color3.fromRGB(255, 0, 0)
                        box.Transparency = 0.5
                        box.AlwaysOnTop = true
                        box.ZIndex = 5
                        box.Adornee = rootPart
                        box.Parent = rootPart
                        
                        local nameGui = Instance.new("BillboardGui")
                        nameGui.Size = UDim2.new(0, 100, 0, 50)
                        nameGui.StudsOffset = Vector3.new(0, 3, 0)
                        nameGui.Adornee = rootPart
                        nameGui.Parent = rootPart
                        
                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Size = UDim2.new(1, 0, 1, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Text = player.Name
                        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        nameLabel.TextSize = 14
                        nameLabel.Font = Enum.Font.GothamBold
                        nameLabel.TextStrokeTransparency = 0
                        nameLabel.Parent = nameGui
                        
                        espBoxes[player.Name] = {box = box, gui = nameGui}
                    end
                end
            end
        end)
        espStatus.Text = "Status: ON"
        espStatus.TextColor3 = Color3.fromRGB(70, 255, 70)
    else
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        for _, espData in pairs(espBoxes) do
            if espData.box then espData.box:Destroy() end
            if espData.gui then espData.gui:Destroy() end
        end
        espBoxes = {}
        espStatus.Text = "Status: OFF"
        espStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
    end
end

-- FULLBRIGHT FUNCTIONS
function toggleFullbright(state)
    fullbrightEnabled = state
    if state then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.FogEnd = 1000000
        for _, obj in pairs(Lighting:GetChildren()) do
            if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") then
                obj.Enabled = false
            end
        end
        fullbrightStatus.Text = "Status: ON"
        fullbrightStatus.TextColor3 = Color3.fromRGB(70, 255, 70)
    else
        Lighting.Ambient = Color3.fromRGB(70, 70, 70)
        Lighting.Brightness = 1
        Lighting.FogEnd = 100000
        for _, obj in pairs(Lighting:GetChildren()) do
            if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") then
                obj.Enabled = true
            end
        end
        fullbrightStatus.Text = "Status: OFF"
        fullbrightStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
    end
end

-- TELEPORT FUNCTIONS
local function safeTeleport(targetPosition)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local rootPart = character.HumanoidRootPart
    local currentPos = rootPart.Position
    local distance = (targetPosition - currentPos).Magnitude
    
    if not antiDetectionEnabled then
        if smoothTeleport then
            local tween = TweenService:Create(rootPart, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                CFrame = CFrame.new(targetPosition)
            })
            tween:Play()
        else
            rootPart.CFrame = CFrame.new(targetPosition)
        end
        return true
    end
    
    if distance <= maxTeleportDistance then
        if smoothTeleport then
            local tween = TweenService:Create(rootPart, TweenInfo.new(teleportDelay * 2, Enum.EasingStyle.Quad), {
                CFrame = CFrame.new(targetPosition)
            })
            tween:Play()
        else
            rootPart.CFrame = CFrame.new(targetPosition)
        end
    else
        local direction = (targetPosition - currentPos).Unit
        local steps = math.ceil(distance / maxTeleportDistance)
        
        spawn(function()
            for i = 1, steps do
                if not character.Parent then break end
                
                local stepDistance = math.min(maxTeleportDistance, distance - (maxTeleportDistance * (i - 1)))
                local stepPosition = currentPos + (direction * maxTeleportDistance * i)
                
                if i == steps then
                    stepPosition = targetPosition
                end
                
                if smoothTeleport then
                    local tween = TweenService:Create(rootPart, TweenInfo.new(teleportDelay, Enum.EasingStyle.Quad), {
                        CFrame = CFrame.new(stepPosition)
                    })
                    tween:Play()
                    tween.Completed:Wait()
                else
                    rootPart.CFrame = CFrame.new(stepPosition)
                    wait(teleportDelay)
                end
                
                local randomOffset = Vector3.new(
                    math.random(-2, 2),
                    math.random(-1, 1),
                    math.random(-2, 2)
                )
                rootPart.CFrame = rootPart.CFrame + randomOffset
                wait(0.05)
                rootPart.CFrame = rootPart.CFrame - randomOffset
            end
        end)
    end
    
    return true
end

local function findPlayer(name)
    name = name:lower()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():find(name) or p.DisplayName:lower():find(name) then
            return p
        end
    end
    return nil
end

-- CLICK TELEPORT
function toggleClickTeleport(state)
    clickTpEnabled = state
    if state then
        clickTpStatus.Text = "Status: ON (Hold Ctrl + Click)"
        clickTpStatus.TextColor3 = Color3.fromRGB(70, 255, 70)
    else
        clickTpStatus.Text = "Status: OFF (Hold Ctrl + Click)"
        clickTpStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
    end
end

-- AUTO FARM
function toggleAutoFarm(state)
    autoFarmEnabled = state
    if state then
        autoFarmConnection = RunService.Heartbeat:Connect(function()
            if not autoFarmEnabled then return end
            
            -- Simple auto farm logic - collect nearby parts
            local character = player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            
            local rootPart = character.HumanoidRootPart
            
            -- Look for collectible items within range
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("Part") and obj.Name:lower():find("coin") or obj.Name:lower():find("cash") or obj.Name:lower():find("money") then
                    local distance = (obj.Position - rootPart.Position).Magnitude
                    if distance < 50 then
                        obj.CFrame = rootPart.CFrame
                    end
                end
            end
        end)
        autoFarmStatus.Text = "Status: ON"
        autoFarmStatus.TextColor3 = Color3.fromRGB(70, 255, 70)
    else
        if autoFarmConnection then
            autoFarmConnection:Disconnect()
            autoFarmConnection = nil
        end
        autoFarmStatus.Text = "Status: OFF"
        autoFarmStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
    end
end

-- ANTI AFK
function toggleAntiAFK(state)
    if state then
        spawn(function()
            while true do
                wait(300) -- 5 minutes
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local pos = player.Character.HumanoidRootPart.Position
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 0, 0.1))
                    wait(0.1)
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
                end
            end
        end)
        antiAfkStatus.Text = "Status: ON"
        antiAfkStatus.TextColor3 = Color3.fromRGB(70, 255, 70)
    else
        antiAfkStatus.Text = "Status: OFF"
        antiAfkStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
    end
end

-- EVENT CONNECTIONS
closeBtn.MouseButton1Click:Connect(function()
    toggleGUI()
end)

-- Tab switching
for i, tabBtn in pairs(tabButtons) do
    tabBtn.MouseButton1Click:Connect(function()
        switchTab(i)
    end)
end

-- Position updates
saveWaypointBtn.MouseButton1Click:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local position = character.HumanoidRootPart.Position
        local name = "Waypoint " .. (#waypoints + 1)
        
        -- Simple waypoint save
        table.insert(waypoints, {name = name, position = position})
        print("Waypoint saved: " .. name)
    end
end)

copyPosBtn.MouseButton1Click:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        local posString = string.format("%.0f, %.0f, %.0f", pos.X, pos.Y, pos.Z)
        print("Position copied: " .. posString)
    end
end)

manualTpBtn.MouseButton1Click:Connect(function()
    local x = tonumber(xBox.Text)
    local y = tonumber(yBox.Text)
    local z = tonumber(zBox.Text)
    
    if x and y and z then
        safeTeleport(Vector3.new(x, y, z))
    else
        print("Please enter valid coordinates")
    end
end)

playerTpBtn.MouseButton1Click:Connect(function()
    local targetPlayer = findPlayer(playerNameBox.Text)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = targetPlayer.Character.HumanoidRootPart.Position
        safeTeleport(targetPos)
        print("Teleported to " .. targetPlayer.Name)
    else
        print("Player not found: " .. playerNameBox.Text)
    end
end)

-- Server utilities
rejoinBtn.MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, player)
end)

serverHopBtn.MouseButton1Click:Connect(function()
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Api = "https://games.roblox.com/v1/games/"
    
    local _place = game.PlaceId
    local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
    
    function ListServers(cursor)
        local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
        return Http:JSONDecode(Raw)
    end
    
    local Server, Next; repeat
        local Servers = ListServers(Next)
        Server = Servers.data[1]
        Next = Servers.nextPageCursor
    until Server
    
    TPS:TeleportToPlaceInstance(_place,Server.id,player)
end)

lowGfxBtn.MouseButton1Click:Connect(function()
    settings().Rendering.QualityLevel = 1
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        end
    end
    print("Low graphics mode enabled")
end)

-- Settings toggles
antiDetectionToggle.MouseButton1Click:Connect(function()
    antiDetectionEnabled = not antiDetectionEnabled
    
    if antiDetectionEnabled then
        antiDetectionToggle.Text = "SAFE MODE: ON"
        antiDetectionToggle.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
    else
        antiDetectionToggle.Text = "SAFE MODE: OFF"
        antiDetectionToggle.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    end
end)

smoothToggle.MouseButton1Click:Connect(function()
    smoothTeleport = not smoothTeleport
    
    if smoothTeleport then
        smoothToggle.Text = "SMOOTH TP: ON"
        smoothToggle.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
    else
        smoothToggle.Text = "SMOOTH TP: OFF"
        smoothToggle.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    end
end)

-- Settings validation
distanceBox.FocusLost:Connect(function()
    local value = tonumber(distanceBox.Text)
    if value and value > 0 then
        maxTeleportDistance = value
    else
        distanceBox.Text = tostring(maxTeleportDistance)
    end
end)

delayBox.FocusLost:Connect(function()
    local value = tonumber(delayBox.Text)
    if value and value >= 0.05 then
        teleportDelay = value
    else
        delayBox.Text = tostring(teleportDelay)
    end
end)

speedBox.FocusLost:Connect(function()
    local value = tonumber(speedBox.Text)
    if value and value > 0 and value <= 200 then
        if flyEnabled then
            flyStatus.Text = "Status: ON | Speed: " .. value
        else
            flyStatus.Text = "Status: OFF | Speed: " .. value
        end
    else
        speedBox.Text = "25"
    end
end)

speedHackBox.FocusLost:Connect(function()
    local value = tonumber(speedHackBox.Text)
    if value and value > 0 and value <= 200 then
        customSpeed = value
        if speedEnabled then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = value
                end
            end
            speedHackStatus.Text = "Status: ON | Speed: " .. value
        else
            speedHackStatus.Text = "Status: OFF | Speed: " .. value
        end
    else
        speedHackBox.Text = "50"
    end
end)

jumpBox.FocusLost:Connect(function()
    local value = tonumber(jumpBox.Text)
    if value and value > 0 and value <= 500 then
        customJumpPower = value
        if jumpPowerEnabled then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = value
                end
            end
            jumpStatus.Text = "Status: ON | Power: " .. value
        else
            jumpStatus.Text = "Status: OFF | Power: " .. value
        end
    else
        jumpBox.Text = "100"
    end
end)

-- Keyboard controls
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        toggleGUI()
    elseif input.KeyCode == Enum.KeyCode.H then
        flyToggle.MouseButton1Click()
    elseif input.KeyCode == Enum.KeyCode.G then
        noclipToggle.MouseButton1Click()
    elseif input.KeyCode == Enum.KeyCode.R then
        speedHackToggle.MouseButton1Click()
    elseif input.KeyCode == Enum.KeyCode.T then
        jumpToggle.MouseButton1Click()
    elseif input.KeyCode == Enum.KeyCode.Y then
        infJumpToggle.MouseButton1Click()
    elseif input.KeyCode == Enum.KeyCode.U then
        espToggle.MouseButton1Click()
    elseif input.KeyCode == Enum.KeyCode.I then
        fullbrightToggle.MouseButton1Click()
    end
end)

-- Click teleport
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and clickTpEnabled and not gameProcessed then
        local mouse = player:GetMouse()
        local hit = mouse.Hit
        if hit then
            safeTeleport(hit.Position + Vector3.new(0, 5, 0))
        end
    end
end)

-- Position updater
spawn(function()
    while true do
        wait(1)
        if guiVisible then
            updateCurrentPosition()
        end
    end
end)

-- Character respawn handling
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart")
    wait(2)
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        originalJumpPower = humanoid.JumpPower
        originalWalkSpeed = humanoid.WalkSpeed
    end
    
    if flyEnabled then
        stopFly()
        wait(0.5)
        startFly()
    end
    
    if noclipEnabled then
        stopNoclip()
        wait(0.2)
        startNoclip()
    end
    
    if speedEnabled then
        humanoid.WalkSpeed = customSpeed
    end
    
    if jumpPowerEnabled then
        humanoid.JumpPower = customJumpPower
    end
    
    updateCurrentPosition()
end)

-- Cleanup
player.CharacterRemoving:Connect(function()
    stopFly()
    stopNoclip()
    if espConnection then
        espConnection:Disconnect()
    end
    if autoFarmConnection then
        autoFarmConnection:Disconnect()
    end
    if jumpConnection then
        jumpConnection:Disconnect()
    end
end)

-- Anti-detection features
local oldMetatable = getrawmetatable(game)
setreadonly(oldMetatable, false)

local oldNamecall = oldMetatable.__namecall
oldMetatable.__namecall = function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "GetPropertyChangedSignal" and args[1] == "CFrame" then
        return {Connect = function() end, Disconnect = function() end}
    end
    
    if method == "Raycast" and antiDetectionEnabled then
        local result = oldNamecall(self, ...)
        if result and result.Position then
            local offset = Vector3.new(
                math.random(-1, 1) * 0.01,
                math.random(-1, 1) * 0.01,
                math.random(-1, 1) * 0.01
            )
            result.Position = result.Position + offset
        end
        return result
    end
    
    return oldNamecall(self, ...)
end

setreadonly(oldMetatable, true)

-- Initialize
print("✅ LNR_Ultimate Hub v2.0 Loaded Successfully!")
print("📋 Press F to open GUI")
print("🚀 Features Loaded:")
print("   • Advanced Fly System")
print("   • Noclip & Speed Hack")
print("   • Super Jump & Infinite Jump")
print("   • Player ESP & Fullbright")
print("   • Teleport & Waypoint System")
print("   • Click Teleport & Player TP")
print("   • Auto Farm & Anti-AFK")
print("   • Anti-Detection Protection")
print("   • Server Utilities")
print("")
print("⌨️ Quick Keybinds:")
print("   F - Toggle GUI    H - Fly    G - Noclip")
print("   R - Speed    T - Jump    Y - Inf Jump")
print("   U - ESP    I - Fullbright")
print("")
print("🎮 Use responsibly and have fun!")

-- Auto-show GUI on first load
wait(2)
toggleGUI()

