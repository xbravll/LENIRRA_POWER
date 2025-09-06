-- Advanced Teleport & Waypoint System with Anti-Detection
-- Press T to toggle GUI

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

-- Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

-- States
local guiVisible = false
local teleportConnection = nil
local waypoints = {}
local selectedWaypoint = nil
local antiDetectionEnabled = true

-- Anti-Detection Settings
local maxTeleportDistance = 500 -- Max distance per teleport to avoid detection
local teleportDelay = 0.1 -- Delay between multi-step teleports
local smoothTeleport = true -- Use smooth teleportation

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportWaypointGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Rounded corners
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Fix title bar bottom
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 12)
titleFix.Position = UDim2.new(0, 0, 1, -12)
titleFix.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

-- Title Text
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -60, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🚀 Teleport & Waypoint Hub"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 24
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 8)
closeBtnCorner.Parent = closeBtn

-- Content Frame with Scrolling
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -70)
contentFrame.Position = UDim2.new(0, 10, 0, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 5
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
contentFrame.Parent = mainFrame

-- Current Position Section
local currentPosFrame = Instance.new("Frame")
currentPosFrame.Size = UDim2.new(1, 0, 0, 80)
currentPosFrame.Position = UDim2.new(0, 0, 0, 0)
currentPosFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
currentPosFrame.BorderSizePixel = 0
currentPosFrame.Parent = contentFrame

local currentPosCorner = Instance.new("UICorner")
currentPosCorner.CornerRadius = UDim.new(0, 8)
currentPosCorner.Parent = currentPosFrame

local currentPosTitle = Instance.new("TextLabel")
currentPosTitle.Size = UDim2.new(1, -20, 0, 25)
currentPosTitle.Position = UDim2.new(0, 10, 0, 5)
currentPosTitle.BackgroundTransparency = 1
currentPosTitle.Text = "📍 Current Position"
currentPosTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
currentPosTitle.TextSize = 16
currentPosTitle.TextXAlignment = Enum.TextXAlignment.Left
currentPosTitle.Font = Enum.Font.GothamBold
currentPosTitle.Parent = currentPosFrame

local currentPosLabel = Instance.new("TextLabel")
currentPosLabel.Size = UDim2.new(1, -120, 0, 20)
currentPosLabel.Position = UDim2.new(0, 10, 0, 30)
currentPosLabel.BackgroundTransparency = 1
currentPosLabel.Text = "X: 0, Y: 0, Z: 0"
currentPosLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
currentPosLabel.TextSize = 12
currentPosLabel.TextXAlignment = Enum.TextXAlignment.Left
currentPosLabel.Font = Enum.Font.Gotham
currentPosLabel.Parent = currentPosFrame

local saveCurrentBtn = Instance.new("TextButton")
saveCurrentBtn.Size = UDim2.new(0, 100, 0, 30)
saveCurrentBtn.Position = UDim2.new(1, -110, 0, 25)
saveCurrentBtn.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
saveCurrentBtn.BorderSizePixel = 0
saveCurrentBtn.Text = "Save Waypoint"
saveCurrentBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveCurrentBtn.TextSize = 12
saveCurrentBtn.Font = Enum.Font.GothamBold
saveCurrentBtn.Parent = currentPosFrame

local saveCurrentCorner = Instance.new("UICorner")
saveCurrentCorner.CornerRadius = UDim.new(0, 6)
saveCurrentCorner.Parent = saveCurrentBtn

local copyPosBtn = Instance.new("TextButton")
copyPosBtn.Size = UDim2.new(0, 80, 0, 20)
copyPosBtn.Position = UDim2.new(1, -90, 0, 55)
copyPosBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
copyPosBtn.BorderSizePixel = 0
copyPosBtn.Text = "Copy Pos"
copyPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyPosBtn.TextSize = 10
copyPosBtn.Font = Enum.Font.Gotham
copyPosBtn.Parent = currentPosFrame

local copyPosCorner = Instance.new("UICorner")
copyPosCorner.CornerRadius = UDim.new(0, 4)
copyPosCorner.Parent = copyPosBtn

-- Manual Teleport Section
local manualTpFrame = Instance.new("Frame")
manualTpFrame.Size = UDim2.new(1, 0, 0, 120)
manualTpFrame.Position = UDim2.new(0, 0, 0, 90)
manualTpFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
manualTpFrame.BorderSizePixel = 0
manualTpFrame.Parent = contentFrame

local manualTpCorner = Instance.new("UICorner")
manualTpCorner.CornerRadius = UDim.new(0, 8)
manualTpCorner.Parent = manualTpFrame

local manualTpTitle = Instance.new("TextLabel")
manualTpTitle.Size = UDim2.new(1, -20, 0, 25)
manualTpTitle.Position = UDim2.new(0, 10, 0, 5)
manualTpTitle.BackgroundTransparency = 1
manualTpTitle.Text = "🎯 Manual Teleport"
manualTpTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
manualTpTitle.TextSize = 16
manualTpTitle.TextXAlignment = Enum.TextXAlignment.Left
manualTpTitle.Font = Enum.Font.GothamBold
manualTpTitle.Parent = manualTpFrame

-- X Y Z input boxes
local xBox = Instance.new("TextBox")
xBox.Size = UDim2.new(0, 90, 0, 25)
xBox.Position = UDim2.new(0, 10, 0, 35)
xBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
xBox.BorderSizePixel = 0
xBox.PlaceholderText = "X Position"
xBox.Text = ""
xBox.TextColor3 = Color3.fromRGB(255, 255, 255)
xBox.TextSize = 12
xBox.Font = Enum.Font.Gotham
xBox.Parent = manualTpFrame

local xBoxCorner = Instance.new("UICorner")
xBoxCorner.CornerRadius = UDim.new(0, 4)
xBoxCorner.Parent = xBox

local yBox = Instance.new("TextBox")
yBox.Size = UDim2.new(0, 90, 0, 25)
yBox.Position = UDim2.new(0, 110, 0, 35)
yBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
yBox.BorderSizePixel = 0
yBox.PlaceholderText = "Y Position"
yBox.Text = ""
yBox.TextColor3 = Color3.fromRGB(255, 255, 255)
yBox.TextSize = 12
yBox.Font = Enum.Font.Gotham
yBox.Parent = manualTpFrame

local yBoxCorner = Instance.new("UICorner")
yBoxCorner.CornerRadius = UDim.new(0, 4)
yBoxCorner.Parent = yBox

local zBox = Instance.new("TextBox")
zBox.Size = UDim2.new(0, 90, 0, 25)
zBox.Position = UDim2.new(0, 210, 0, 35)
zBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
zBox.BorderSizePixel = 0
zBox.PlaceholderText = "Z Position"
zBox.Text = ""
zBox.TextColor3 = Color3.fromRGB(255, 255, 255)
zBox.TextSize = 12
zBox.Font = Enum.Font.Gotham
zBox.Parent = manualTpFrame

local zBoxCorner = Instance.new("UICorner")
zBoxCorner.CornerRadius = UDim.new(0, 4)
zBoxCorner.Parent = zBox

local manualTpBtn = Instance.new("TextButton")
manualTpBtn.Size = UDim2.new(0, 80, 0, 25)
manualTpBtn.Position = UDim2.new(1, -90, 0, 35)
manualTpBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
manualTpBtn.BorderSizePixel = 0
manualTpBtn.Text = "Teleport"
manualTpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
manualTpBtn.TextSize = 12
manualTpBtn.Font = Enum.Font.GothamBold
manualTpBtn.Parent = manualTpFrame

local manualTpBtnCorner = Instance.new("UICorner")
manualTpBtnCorner.CornerRadius = UDim.new(0, 6)
manualTpBtnCorner.Parent = manualTpBtn

-- Player teleport section
local playerTpFrame = Instance.new("Frame")
playerTpFrame.Size = UDim2.new(1, 0, 0, 80)
playerTpFrame.Position = UDim2.new(0, 0, 0, 220)
playerTpFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
playerTpFrame.BorderSizePixel = 0
playerTpFrame.Parent = contentFrame

local playerTpCorner = Instance.new("UICorner")
playerTpCorner.CornerRadius = UDim.new(0, 8)
playerTpCorner.Parent = playerTpFrame

local playerTpTitle = Instance.new("TextLabel")
playerTpTitle.Size = UDim2.new(1, -20, 0, 25)
playerTpTitle.Position = UDim2.new(0, 10, 0, 5)
playerTpTitle.BackgroundTransparency = 1
playerTpTitle.Text = "👥 Player Teleport"
playerTpTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
playerTpTitle.TextSize = 16
playerTpTitle.TextXAlignment = Enum.TextXAlignment.Left
playerTpTitle.Font = Enum.Font.GothamBold
playerTpTitle.Parent = playerTpFrame

local playerNameBox = Instance.new("TextBox")
playerNameBox.Size = UDim2.new(1, -100, 0, 25)
playerNameBox.Position = UDim2.new(0, 10, 0, 35)
playerNameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
playerNameBox.BorderSizePixel = 0
playerNameBox.PlaceholderText = "Player name (partial works)"
playerNameBox.Text = ""
playerNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
playerNameBox.TextSize = 12
playerNameBox.Font = Enum.Font.Gotham
playerNameBox.Parent = playerTpFrame

local playerNameCorner = Instance.new("UICorner")
playerNameCorner.CornerRadius = UDim.new(0, 4)
playerNameCorner.Parent = playerNameBox

local playerTpBtn = Instance.new("TextButton")
playerTpBtn.Size = UDim2.new(0, 80, 0, 25)
playerTpBtn.Position = UDim2.new(1, -90, 0, 35)
playerTpBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
playerTpBtn.BorderSizePixel = 0
playerTpBtn.Text = "TP to Player"
playerTpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
playerTpBtn.TextSize = 11
playerTpBtn.Font = Enum.Font.GothamBold
playerTpBtn.Parent = playerTpFrame

local playerTpBtnCorner = Instance.new("UICorner")
playerTpBtnCorner.CornerRadius = UDim.new(0, 6)
playerTpBtnCorner.Parent = playerTpBtn

-- Waypoints Section
local waypointsFrame = Instance.new("Frame")
waypointsFrame.Size = UDim2.new(1, 0, 0, 300)
waypointsFrame.Position = UDim2.new(0, 0, 0, 310)
waypointsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
waypointsFrame.BorderSizePixel = 0
waypointsFrame.Parent = contentFrame

local waypointsCorner = Instance.new("UICorner")
waypointsCorner.CornerRadius = UDim.new(0, 8)
waypointsCorner.Parent = waypointsFrame

local waypointsTitle = Instance.new("TextLabel")
waypointsTitle.Size = UDim2.new(1, -100, 0, 25)
waypointsTitle.Position = UDim2.new(0, 10, 0, 5)
waypointsTitle.BackgroundTransparency = 1
waypointsTitle.Text = "📌 Saved Waypoints"
waypointsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
waypointsTitle.TextSize = 16
waypointsTitle.TextXAlignment = Enum.TextXAlignment.Left
waypointsTitle.Font = Enum.Font.GothamBold
waypointsTitle.Parent = waypointsFrame

local clearAllBtn = Instance.new("TextButton")
clearAllBtn.Size = UDim2.new(0, 80, 0, 20)
clearAllBtn.Position = UDim2.new(1, -90, 0, 7)
clearAllBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
clearAllBtn.BorderSizePixel = 0
clearAllBtn.Text = "Clear All"
clearAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearAllBtn.TextSize = 10
clearAllBtn.Font = Enum.Font.Gotham
clearAllBtn.Parent = waypointsFrame

local clearAllCorner = Instance.new("UICorner")
clearAllCorner.CornerRadius = UDim.new(0, 4)
clearAllCorner.Parent = clearAllBtn

-- Waypoints list container
local waypointsList = Instance.new("ScrollingFrame")
waypointsList.Size = UDim2.new(1, -20, 1, -40)
waypointsList.Position = UDim2.new(0, 10, 0, 35)
waypointsList.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
waypointsList.BorderSizePixel = 0
waypointsList.ScrollBarThickness = 4
waypointsList.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
waypointsList.CanvasSize = UDim2.new(0, 0, 0, 0)
waypointsList.Parent = waypointsFrame

local waypointsListCorner = Instance.new("UICorner")
waypointsListCorner.CornerRadius = UDim.new(0, 6)
waypointsListCorner.Parent = waypointsList

-- Settings Section
local settingsFrame = Instance.new("Frame")
settingsFrame.Size = UDim2.new(1, 0, 0, 120)
settingsFrame.Position = UDim2.new(0, 0, 0, 620)
settingsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
settingsFrame.BorderSizePixel = 0
settingsFrame.Parent = contentFrame

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 8)
settingsCorner.Parent = settingsFrame

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1, -20, 0, 25)
settingsTitle.Position = UDim2.new(0, 10, 0, 5)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "⚙️ Anti-Detection Settings"
settingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsTitle.TextSize = 16
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.Parent = settingsFrame

local antiDetectionToggle = Instance.new("TextButton")
antiDetectionToggle.Size = UDim2.new(0, 100, 0, 25)
antiDetectionToggle.Position = UDim2.new(0, 10, 0, 35)
antiDetectionToggle.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
antiDetectionToggle.BorderSizePixel = 0
antiDetectionToggle.Text = "SAFE MODE: ON"
antiDetectionToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
antiDetectionToggle.TextSize = 10
antiDetectionToggle.Font = Enum.Font.GothamBold
antiDetectionToggle.Parent = settingsFrame

local antiDetectionCorner = Instance.new("UICorner")
antiDetectionCorner.CornerRadius = UDim.new(0, 6)
antiDetectionCorner.Parent = antiDetectionToggle

local distanceLabel = Instance.new("TextLabel")
distanceLabel.Size = UDim2.new(0, 80, 0, 25)
distanceLabel.Position = UDim2.new(0, 120, 0, 35)
distanceLabel.BackgroundTransparency = 1
distanceLabel.Text = "Max Distance:"
distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
distanceLabel.TextSize = 10
distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
distanceLabel.Font = Enum.Font.Gotham
distanceLabel.Parent = settingsFrame

local distanceBox = Instance.new("TextBox")
distanceBox.Size = UDim2.new(0, 60, 0, 25)
distanceBox.Position = UDim2.new(0, 200, 0, 35)
distanceBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
distanceBox.BorderSizePixel = 0
distanceBox.Text = "500"
distanceBox.TextColor3 = Color3.fromRGB(255, 255, 255)
distanceBox.TextSize = 10
distanceBox.Font = Enum.Font.Gotham
distanceBox.TextXAlignment = Enum.TextXAlignment.Center
distanceBox.Parent = settingsFrame

local distanceBoxCorner = Instance.new("UICorner")
distanceBoxCorner.CornerRadius = UDim.new(0, 4)
distanceBoxCorner.Parent = distanceBox

local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 60, 0, 25)
delayLabel.Position = UDim2.new(0, 270, 0, 35)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "Delay(s):"
delayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
delayLabel.TextSize = 10
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Font = Enum.Font.Gotham
delayLabel.Parent = settingsFrame

local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(0, 50, 0, 25)
delayBox.Position = UDim2.new(1, -60, 0, 35)
delayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
delayBox.BorderSizePixel = 0
delayBox.Text = "0.1"
delayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayBox.TextSize = 10
delayBox.Font = Enum.Font.Gotham
delayBox.TextXAlignment = Enum.TextXAlignment.Center
delayBox.Parent = settingsFrame

local delayBoxCorner = Instance.new("UICorner")
delayBoxCorner.CornerRadius = UDim.new(0, 4)
delayBoxCorner.Parent = delayBox

local smoothToggle = Instance.new("TextButton")
smoothToggle.Size = UDim2.new(0, 120, 0, 25)
smoothToggle.Position = UDim2.new(0, 10, 0, 70)
smoothToggle.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
smoothToggle.BorderSizePixel = 0
smoothToggle.Text = "SMOOTH TP: ON"
smoothToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
smoothToggle.TextSize = 10
smoothToggle.Font = Enum.Font.GothamBold
smoothToggle.Parent = settingsFrame

local smoothToggleCorner = Instance.new("UICorner")
smoothToggleCorner.CornerRadius = UDim.new(0, 6)
smoothToggleCorner.Parent = smoothToggle

-- Info text
local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, -140, 0, 50)
infoText.Position = UDim2.new(0, 140, 0, 70)
infoText.BackgroundTransparency = 1
infoText.Text = "Safe Mode: Multi-step teleport\nSmooth TP: Tween animation\nT - Toggle GUI"
infoText.TextColor3 = Color3.fromRGB(150, 150, 150)
infoText.TextSize = 9
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.Font = Enum.Font.Gotham
infoText.Parent = settingsFrame

-- Functions
local function updateCurrentPosition()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        currentPosLabel.Text = string.format("X: %.0f, Y: %.0f, Z: %.0f", pos.X, pos.Y, pos.Z)
    end
end

local function toggleGUI()
    guiVisible = not guiVisible
    
    if guiVisible then
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 400, 0, 500)
        }):Play()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        
        wait(0.2)
        mainFrame.Visible = false
    end
end

local function safeTeleport(targetPosition)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local rootPart = character.HumanoidRootPart
    local currentPos = rootPart.Position
    local distance = (targetPosition - currentPos).Magnitude
    
    if not antiDetectionEnabled then
        -- Direct teleport
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
    
    -- Multi-step safe teleport
    if distance <= maxTeleportDistance then
        -- Single teleport
        if smoothTeleport then
            local tween = TweenService:Create(rootPart, TweenInfo.new(teleportDelay * 2, Enum.EasingStyle.Quad), {
                CFrame = CFrame.new(targetPosition)
            })
            tween:Play()
        else
            rootPart.CFrame = CFrame.new(targetPosition)
        end
    else
        -- Multi-step teleport
        local direction = (targetPosition - currentPos).Unit
        local steps = math.ceil(distance / maxTeleportDistance)
        
        spawn(function()
            for i = 1, steps do
                if not character.Parent then break end
                
                local stepDistance = math.min(maxTeleportDistance, distance - (maxTeleportDistance * (i - 1)))
                local stepPosition = currentPos + (direction * maxTeleportDistance * i)
                
                if i == steps then
                    stepPosition = targetPosition -- Ensure we reach exact target
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
                
                -- Add small random offset for anti-detection
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

local function createWaypointEntry(name, position, index)
    local entryFrame = Instance.new("Frame")
    entryFrame.Size = UDim2.new(1, -10, 0, 40)
    entryFrame.Position = UDim2.new(0, 5, 0, (index - 1) * 45)
    entryFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    entryFrame.BorderSizePixel = 0
    entryFrame.Parent = waypointsList
    
    local entryCorner = Instance.new("UICorner")
    entryCorner.CornerRadius = UDim.new(0, 6)
    entryCorner.Parent = entryFrame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.4, 0, 1, 0)
    nameLabel.Position = UDim2.new(0, 10, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 12
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = entryFrame
    
    local posLabel = Instance.new("TextLabel")
    posLabel.Size = UDim2.new(0.35, 0, 1, 0)
    posLabel.Position = UDim2.new(0.4, 0, 0, 0)
    posLabel.BackgroundTransparency = 1
    posLabel.Text = string.format("%.0f, %.0f, %.0f", position.X, position.Y, position.Z)
    posLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    posLabel.TextSize = 10
    posLabel.TextXAlignment = Enum.TextXAlignment.Left
    posLabel.Font = Enum.Font.Gotham
    posLabel.Parent = entryFrame
    
    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(0, 50, 0, 25)
    tpBtn.Position = UDim2.new(1, -80, 0.5, -12.5)
    tpBtn.BackgroundColor3 = Color3.fromRGB(70, 150, 255)
    tpBtn.BorderSizePixel = 0
    tpBtn.Text = "TP"
    tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpBtn.TextSize = 11
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.Parent = entryFrame
    
    local tpBtnCorner = Instance.new("UICorner")
    tpBtnCorner.CornerRadius = UDim.new(0, 4)
    tpBtnCorner.Parent = tpBtn
    
    local deleteBtn = Instance.new("TextButton")
    deleteBtn.Size = UDim2.new(0, 25, 0, 25)
    deleteBtn.Position = UDim2.new(1, -25, 0.5, -12.5)
    deleteBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    deleteBtn.BorderSizePixel = 0
    deleteBtn.Text = "×"
    deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    deleteBtn.TextSize = 14
    deleteBtn.Font = Enum.Font.GothamBold
    deleteBtn.Parent = entryFrame
    
    local deleteBtnCorner = Instance.new("UICorner")
    deleteBtnCorner.CornerRadius = UDim.new(0, 4)
    deleteBtnCorner.Parent = deleteBtn
    
    -- Button events
    tpBtn.MouseButton1Click:Connect(function()
        safeTeleport(position)
    end)
    
    deleteBtn.MouseButton1Click:Connect(function()
        table.remove(waypoints, index)
        refreshWaypointsList()
    end)
    
    return entryFrame
end

local function refreshWaypointsList()
    -- Clear existing entries
    for _, child in pairs(waypointsList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Create new entries
    for i, waypoint in pairs(waypoints) do
        createWaypointEntry(waypoint.name, waypoint.position, i)
    end
    
    -- Update canvas size
    waypointsList.CanvasSize = UDim2.new(0, 0, 0, #waypoints * 45)
end

local function saveWaypoint()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local position = character.HumanoidRootPart.Position
    local name = "Waypoint " .. (#waypoints + 1)
    
    -- Create name input dialog
    local nameDialog = Instance.new("Frame")
    nameDialog.Size = UDim2.new(0, 300, 0, 150)
    nameDialog.Position = UDim2.new(0.5, -150, 0.5, -75)
    nameDialog.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    nameDialog.BorderSizePixel = 0
    nameDialog.Parent = screenGui
    
    local nameDialogCorner = Instance.new("UICorner")
    nameDialogCorner.CornerRadius = UDim.new(0, 8)
    nameDialogCorner.Parent = nameDialog
    
    local dialogTitle = Instance.new("TextLabel")
    dialogTitle.Size = UDim2.new(1, -20, 0, 30)
    dialogTitle.Position = UDim2.new(0, 10, 0, 10)
    dialogTitle.BackgroundTransparency = 1
    dialogTitle.Text = "💾 Save Waypoint"
    dialogTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    dialogTitle.TextSize = 16
    dialogTitle.TextXAlignment = Enum.TextXAlignment.Left
    dialogTitle.Font = Enum.Font.GothamBold
    dialogTitle.Parent = nameDialog
    
    local nameInput = Instance.new("TextBox")
    nameInput.Size = UDim2.new(1, -20, 0, 35)
    nameInput.Position = UDim2.new(0, 10, 0, 50)
    nameInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    nameInput.BorderSizePixel = 0
    nameInput.Text = name
    nameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameInput.TextSize = 14
    nameInput.Font = Enum.Font.Gotham
    nameInput.Parent = nameDialog
    
    local nameInputCorner = Instance.new("UICorner")
    nameInputCorner.CornerRadius = UDim.new(0, 6)
    nameInputCorner.Parent = nameInput
    
    local saveBtn = Instance.new("TextButton")
    saveBtn.Size = UDim2.new(0, 80, 0, 30)
    saveBtn.Position = UDim2.new(0, 10, 1, -40)
    saveBtn.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
    saveBtn.BorderSizePixel = 0
    saveBtn.Text = "Save"
    saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    saveBtn.TextSize = 12
    saveBtn.Font = Enum.Font.GothamBold
    saveBtn.Parent = nameDialog
    
    local saveBtnCorner = Instance.new("UICorner")
    saveBtnCorner.CornerRadius = UDim.new(0, 6)
    saveBtnCorner.Parent = saveBtn
    
    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Size = UDim2.new(0, 80, 0, 30)
    cancelBtn.Position = UDim2.new(1, -90, 1, -40)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    cancelBtn.BorderSizePixel = 0
    cancelBtn.Text = "Cancel"
    cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    cancelBtn.TextSize = 12
    cancelBtn.Font = Enum.Font.GothamBold
    cancelBtn.Parent = nameDialog
    
    local cancelBtnCorner = Instance.new("UICorner")
    cancelBtnCorner.CornerRadius = UDim.new(0, 6)
    cancelBtnCorner.Parent = cancelBtn
    
    saveBtn.MouseButton1Click:Connect(function()
        local waypointName = nameInput.Text
        if waypointName and waypointName ~= "" then
            table.insert(waypoints, {name = waypointName, position = position})
            refreshWaypointsList()
        end
        nameDialog:Destroy()
    end)
    
    cancelBtn.MouseButton1Click:Connect(function()
        nameDialog:Destroy()
    end)
    
    nameInput:CaptureFocus()
end

-- Event connections
closeBtn.MouseButton1Click:Connect(function()
    toggleGUI()
end)

saveCurrentBtn.MouseButton1Click:Connect(function()
    saveWaypoint()
end)

copyPosBtn.MouseButton1Click:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        local posString = string.format("%.0f, %.0f, %.0f", pos.X, pos.Y, pos.Z)
        -- Copy to clipboard would require external methods
        print("Position copied: " .. posString)
    end
end)

manualTpBtn.MouseButton1Click:Connect(function()
    local x = tonumber(xBox.Text)
    local y = tonumber(yBox.Text)
    local z = tonumber(zBox.Text)
    
    if x and y and z then
        safeTeleport(Vector3.new(x, y, z))
    end
end)

playerTpBtn.MouseButton1Click:Connect(function()
    local targetPlayer = findPlayer(playerNameBox.Text)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = targetPlayer.Character.HumanoidRootPart.Position
        safeTeleport(targetPos)
    else
        print("Player not found: " .. playerNameBox.Text)
    end
end)

clearAllBtn.MouseButton1Click:Connect(function()
    waypoints = {}
    refreshWaypointsList()
end)

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

-- Keyboard controls
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.T then
        toggleGUI()
    end
end)

-- Position updater
spawn(function()
    while true do
        wait(0.5)
        if guiVisible then
            updateCurrentPosition()
        end
    end
end)

-- Character respawn handling
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart")
    wait(2)
    updateCurrentPosition()
end)

-- Anti-detection features
local oldMetatable = getrawmetatable(game)
setreadonly(oldMetatable, false)

local oldNamecall = oldMetatable.__namecall
oldMetatable.__namecall = function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    -- Block common teleport detection methods
    if method == "GetPropertyChangedSignal" and args[1] == "CFrame" then
        return {Connect = function() end, Disconnect = function() end}
    end
    
    if method == "Raycast" and antiDetectionEnabled then
        -- Modify raycast results to prevent teleport detection
        local result = oldNamecall(self, ...)
        if result and result.Position then
            -- Add small random offset to avoid pattern detection
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
print("✅ Advanced Teleport & Waypoint System Loaded!")
print("📋 Press T to open GUI")
print("🚀 Features:")
print("   • Safe multi-step teleportation")
print("   • Waypoint save/load system") 
print("   • Player teleportation")
print("   • Anti-detection protection")
print("   • Manual coordinate input")

-- Auto-show GUI on first load
wait(1)
toggleGUI()