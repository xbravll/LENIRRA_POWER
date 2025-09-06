-- Advanced FrameFly GUI - Simple & Working
-- Press F to toggle GUI

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

-- States
local guiVisible = false
local flyEnabled = false
local noclipEnabled = false
local flyConnection = nil
local noclipConnection = nil
local flyObject = nil

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedFlyGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Fix title bar bottom
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 12)
titleFix.Position = UDim2.new(0, 0, 1, -12)
titleFix.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

-- Title Text
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -60, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🚀 Advanced Fly Hub"
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

-- Content Area
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -70)
contentFrame.Position = UDim2.new(0, 10, 0, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Fly Section
local flyFrame = Instance.new("Frame")
flyFrame.Size = UDim2.new(1, 0, 0, 80)
flyFrame.Position = UDim2.new(0, 0, 0, 0)
flyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
flyFrame.BorderSizePixel = 0
flyFrame.Parent = contentFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 8)
flyCorner.Parent = flyFrame

local flyTitle = Instance.new("TextLabel")
flyTitle.Size = UDim2.new(0.6, 0, 0.4, 0)
flyTitle.Position = UDim2.new(0, 15, 0, 5)
flyTitle.BackgroundTransparency = 1
flyTitle.Text = "✈️ Fly Mode"
flyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
flyTitle.TextSize = 16
flyTitle.TextXAlignment = Enum.TextXAlignment.Left
flyTitle.Font = Enum.Font.GothamBold
flyTitle.Parent = flyFrame

local flyStatus = Instance.new("TextLabel")
flyStatus.Size = UDim2.new(0.6, 0, 0.3, 0)
flyStatus.Position = UDim2.new(0, 15, 0.4, 0)
flyStatus.BackgroundTransparency = 1
flyStatus.Text = "Status: OFF"
flyStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
flyStatus.TextSize = 12
flyStatus.Font = Enum.Font.Gotham
flyStatus.TextXAlignment = Enum.TextXAlignment.Left
flyStatus.Parent = flyFrame

local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(0, 80, 0, 35)
flyToggle.Position = UDim2.new(1, -90, 0, 10)
flyToggle.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
flyToggle.BorderSizePixel = 0
flyToggle.Text = "OFF"
flyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
flyToggle.TextSize = 14
flyToggle.Font = Enum.Font.GothamBold
flyToggle.Parent = flyFrame

local flyToggleCorner = Instance.new("UICorner")
flyToggleCorner.CornerRadius = UDim.new(0, 6)
flyToggleCorner.Parent = flyToggle

-- Speed Control
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 60, 0, 20)
speedLabel.Position = UDim2.new(0, 15, 1, -25)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed:"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextSize = 12
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = flyFrame

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 60, 0, 20)
speedBox.Position = UDim2.new(0, 75, 1, -25)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBox.BorderSizePixel = 0
speedBox.Text = "25"
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextSize = 12
speedBox.Font = Enum.Font.Gotham
speedBox.TextXAlignment = Enum.TextXAlignment.Center
speedBox.Parent = flyFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 4)
speedCorner.Parent = speedBox

-- Noclip Section
local noclipFrame = Instance.new("Frame")
noclipFrame.Size = UDim2.new(1, 0, 0, 60)
noclipFrame.Position = UDim2.new(0, 0, 0, 90)
noclipFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
noclipFrame.BorderSizePixel = 0
noclipFrame.Parent = contentFrame

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 8)
noclipCorner.Parent = noclipFrame

local noclipTitle = Instance.new("TextLabel")
noclipTitle.Size = UDim2.new(0.6, 0, 0.5, 0)
noclipTitle.Position = UDim2.new(0, 15, 0, 5)
noclipTitle.BackgroundTransparency = 1
noclipTitle.Text = "👻 Noclip Mode"
noclipTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipTitle.TextSize = 16
noclipTitle.TextXAlignment = Enum.TextXAlignment.Left
noclipTitle.Font = Enum.Font.GothamBold
noclipTitle.Parent = noclipFrame

local noclipStatus = Instance.new("TextLabel")
noclipStatus.Size = UDim2.new(0.6, 0, 0.5, 0)
noclipStatus.Position = UDim2.new(0, 15, 0.5, 0)
noclipStatus.BackgroundTransparency = 1
noclipStatus.Text = "Status: OFF"
noclipStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
noclipStatus.TextSize = 12
noclipStatus.Font = Enum.Font.Gotham
noclipStatus.TextXAlignment = Enum.TextXAlignment.Left
noclipStatus.Parent = noclipFrame

local noclipToggle = Instance.new("TextButton")
noclipToggle.Size = UDim2.new(0, 80, 0, 35)
noclipToggle.Position = UDim2.new(1, -90, 0.5, -17.5)
noclipToggle.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
noclipToggle.BorderSizePixel = 0
noclipToggle.Text = "OFF"
noclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipToggle.TextSize = 14
noclipToggle.Font = Enum.Font.GothamBold
noclipToggle.Parent = noclipFrame

local noclipToggleCorner = Instance.new("UICorner")
noclipToggleCorner.CornerRadius = UDim.new(0, 6)
noclipToggleCorner.Parent = noclipToggle

-- Controls Info
local controlsFrame = Instance.new("Frame")
controlsFrame.Size = UDim2.new(1, 0, 0, 170)
controlsFrame.Position = UDim2.new(0, 0, 0, 160)
controlsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
controlsFrame.BorderSizePixel = 0
controlsFrame.Parent = contentFrame

local controlsCorner = Instance.new("UICorner")
controlsCorner.CornerRadius = UDim.new(0, 8)
controlsCorner.Parent = controlsFrame

local controlsTitle = Instance.new("TextLabel")
controlsTitle.Size = UDim2.new(1, -20, 0, 25)
controlsTitle.Position = UDim2.new(0, 10, 0, 5)
controlsTitle.BackgroundTransparency = 1
controlsTitle.Text = "🎮 Controls & Info"
controlsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
controlsTitle.TextSize = 16
controlsTitle.TextXAlignment = Enum.TextXAlignment.Left
controlsTitle.Font = Enum.Font.GothamBold
controlsTitle.Parent = controlsFrame

local controlsText = Instance.new("TextLabel")
controlsText.Size = UDim2.new(1, -20, 1, -35)
controlsText.Position = UDim2.new(0, 10, 0, 30)
controlsText.BackgroundTransparency = 1
controlsText.Text = [[F - Toggle GUI
H - Toggle Fly ON/OFF
G - Toggle Noclip ON/OFF

✈️ SMOOTH FLIGHT CONTROLS:
W - Forward    S - Backward
A - Left       D - Right
Space - Up (camera relative)
Shift - Down (camera relative)
Ctrl - Speed Boost (2.5x)

🎮 Full 3D movement that follows
your camera direction!]]
controlsText.TextColor3 = Color3.fromRGB(190, 190, 190)
controlsText.TextSize = 12
controlsText.TextXAlignment = Enum.TextXAlignment.Left
controlsText.TextYAlignment = Enum.TextYAlignment.Top
controlsText.Font = Enum.Font.Gotham
controlsText.Parent = controlsFrame

-- Functions
local function toggleGUI()
    guiVisible = not guiVisible
    
    if guiVisible then
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 350, 0, 400)
        }):Play()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        
        game:GetService("Debris"):AddItem(game:GetService("TweenService"):Create(mainFrame, TweenInfo.new(0.2), {}), 0.2)
        wait(0.2)
        mainFrame.Visible = false
    end
end

local function startFly()
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not rootPart or not humanoid then return end
    
    -- Create invisible fly part
    flyObject = Instance.new("Part")
    flyObject.Name = "FlyPart"
    flyObject.Anchored = true
    flyObject.CanCollide = false
    flyObject.Transparency = 1
    flyObject.Size = Vector3.new(4, 1, 2)
    flyObject.CFrame = rootPart.CFrame
    flyObject.Parent = Workspace
    
    -- Create weld
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = rootPart
    weld.Part1 = flyObject
    weld.Parent = flyObject
    
    -- Disable default character physics
    rootPart.Anchored = false
    humanoid.PlatformStand = true
    
    local speed = tonumber(speedBox.Text) or 25
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flyEnabled then return end
        
        local velocity = Vector3.new(0, 0, 0)
        local currentSpeed = speed
        
        -- Speed boost
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            currentSpeed = speed * 2.5
        end
        
        -- Direct WASD input (much more responsive)
        local moveX = 0
        local moveZ = 0
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveZ = 1  -- Forward (positive Z in look direction)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveZ = -1  -- Backward (negative Z in look direction)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveX = -1  -- Left
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveX = 1   -- Right
        end
        
        -- Calculate movement based on camera direction
        if moveX ~= 0 or moveZ ~= 0 then
            local lookDirection = camera.CFrame.LookVector
            local rightDirection = camera.CFrame.RightVector
            
            -- Create movement vector (full 3D movement with camera direction)
            local moveDirection = (lookDirection * moveZ + rightDirection * moveX)
            if moveDirection.Magnitude > 0 then
                velocity = velocity + moveDirection.Unit * currentSpeed
            end
        end
        
        -- Vertical movement (camera-relative for smooth flight)
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            -- Up movement follows camera's up vector for natural flight
            local upDirection = camera.CFrame.UpVector
            velocity = velocity + upDirection * currentSpeed
        end
        
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            -- Down movement opposite to camera's up vector
            local upDirection = camera.CFrame.UpVector
            velocity = velocity - upDirection * currentSpeed
        end
        
        -- Apply movement with smooth interpolation
        if velocity.Magnitude > 0 then
            local deltaTime = RunService.Heartbeat:Wait()
            flyObject.CFrame = flyObject.CFrame + velocity * deltaTime
        end
    end)
end

local function stopFly()
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

local function toggleFly()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        startFly()
        flyToggle.Text = "ON"
        flyToggle.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
        flyStatus.Text = "Status: ON"
        flyStatus.TextColor3 = Color3.fromRGB(70, 255, 70)
    else
        stopFly()
        flyToggle.Text = "OFF"
        flyToggle.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        flyStatus.Text = "Status: OFF"
        flyStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
    end
end

local function startNoclip()
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

local function stopNoclip()
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

local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        startNoclip()
        noclipToggle.Text = "ON"
        noclipToggle.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
        noclipStatus.Text = "Status: ON"
        noclipStatus.TextColor3 = Color3.fromRGB(70, 255, 70)
    else
        stopNoclip()
        noclipToggle.Text = "OFF"
        noclipToggle.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        noclipStatus.Text = "Status: OFF"
        noclipStatus.TextColor3 = Color3.fromRGB(170, 170, 170)
    end
end

-- Events
closeBtn.MouseButton1Click:Connect(function()
    toggleGUI()
end)

flyToggle.MouseButton1Click:Connect(function()
    toggleFly()
end)

noclipToggle.MouseButton1Click:Connect(function()
    toggleNoclip()
end)

-- Speed validation
speedBox.FocusLost:Connect(function()
    local value = tonumber(speedBox.Text)
    if not value or value < 1 then
        speedBox.Text = "25"
    elseif value > 150 then
        speedBox.Text = "150"
    end
end)

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        toggleGUI()
    elseif input.KeyCode == Enum.KeyCode.H then
        toggleFly()
    elseif input.KeyCode == Enum.KeyCode.G then
        toggleNoclip()
    end
end)

-- Character respawn handling
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart")
    wait(1)
    
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
end)

-- Cleanup
player.CharacterRemoving:Connect(function()
    stopFly()
    stopNoclip()
end)

-- Initialize
print("✅ Advanced Fly GUI Loaded!")
print("📋 Press F to open GUI")
print("🚀 Press H for quick fly toggle")
print("👻 Press G for quick noclip toggle")

-- Auto-show GUI on first load
wait(1)
toggleGUI()