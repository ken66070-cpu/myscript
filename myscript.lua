local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("AnimeBallHub") then
    playerGui.AnimeBallHub:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AnimeBallHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 220)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
titleLabel.Text = "Anime Ball Hub (Auto)"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

local settings = {
    AutoHit = false,
    AutoFarm = false,
    AutoDodge = false,
}

local function createToggle(name, yPos, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 220, 0, 35)
    button.Position = UDim2.new(0.5, -110, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    button.Text = name .. ": OFF"
    button.TextColor3 = Color3.fromRGB(255, 100, 100)
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.Parent = mainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = button

    local state = false
    button.MouseButton1Click:Connect(function()
        state = not state
        if state then
            button.Text = name .. ": ON"
            button.TextColor3 = Color3.fromRGB(100, 255, 100)
            button.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
        else
            button.Text = name .. ": OFF"
            button.TextColor3 = Color3.fromRGB(255, 100, 100)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        end
        callback(state)
    end)
end

createToggle("Auto Hit / Parry", 50, function(state)
    settings.AutoHit = state
end)

createToggle("Auto Farm / Move", 95, function(state)
    settings.AutoFarm = state
end)

createToggle("Auto Dodge Skills", 140, function(state)
    settings.AutoDodge = state
end)

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 220, 0, 25)
closeButton.Position = UDim2.new(0.5, -110, 0, 185)
closeButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
closeButton.Text = "Close / Unload Hub"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 12
closeButton.Font = Enum.Font.Gotham
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

RunService.RenderStepped:Connect(function()
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")

    if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then return end

    if settings.AutoHit then
        pcall(function()
            local remoteFolder = ReplicatedStorage:FindFirstChild("Remotes")
            if remoteFolder and remoteFolder:FindFirstChild("HitEvent") then
                remoteFolder.HitEvent:FireServer()
            end
        end)
    end

    if settings.AutoFarm then
        pcall(function()
            local targetsFolder = Workspace:FindFirstChild("Balls") or Workspace:FindFirstChild("Enemies")
            if targetsFolder then
                for _, target in ipairs(targetsFolder:GetChildren()) do
                    local targetPart = target:FindFirstChild("HumanoidRootPart") or (target:IsA("BasePart") and target)
                    if targetPart then
                        local distance = (humanoidRootPart.Position - targetPart.Position).Magnitude
                        if distance > 15 then
                            humanoid:MoveTo(targetPart.Position)
                        end
                        break
                    end
                end
            end
        end)
    end

    if settings.AutoDodge then
        pcall(function()
            local dangerFolder = Workspace:FindFirstChild("Projectiles") or Workspace:FindFirstChild("Skills")
            if dangerFolder then
                for _, skill in ipairs(dangerFolder:GetChildren()) do
                    local part = skill:FindFirstChild("Handle") or (skill:IsA("BasePart") and skill)
                    if part then
                        local distance = (humanoidRootPart.Position - part.Position).Magnitude
                        if distance <= 18 then
                            local randomOffset = Vector3.new(math.random(-12, 12), 0, math.random(-12, 12))
                            humanoid:MoveTo(humanoidRootPart.Position + randomOffset)
                            break
                        end
                    end
                end
            end
        end)
    end
end)

