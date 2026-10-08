local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

if CoreGui:FindFirstChild("Slayers2Hub") then
    CoreGui.Slayers2Hub:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Slayers2Hub"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 220)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 30, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(55, 45, 65)
titleLabel.Text = "Slayers 2 - Helper Hub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

local settings = {
    AutoChests = false,
    AutoDrops = false,
    AutoTarget = false,
}

local function createToggle(name, yPos, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 220, 0, 35)
    button.Position = UDim2.new(0.5, -110, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(60, 50, 80)
    button.Text = name .. ": ปิด"
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
            button.Text = name .. ": เปิด"
            button.TextColor3 = Color3.fromRGB(100, 255, 100)
            button.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
        else
            button.Text = name .. ": ปิด"
            button.TextColor3 = Color3.fromRGB(255, 100, 100)
            button.BackgroundColor3 = Color3.fromRGB(60, 50, 80)
        end
        callback(state)
    end)
end

createToggle("ออโต้เก็บกล่องสมบัติ", 50, function(state)
    settings.AutoChests = state
end)

createToggle("ออโต้เก็บไอเทมดรอป", 95, function(state)
    settings.AutoDrops = state
end)

createToggle("ออโต้เข้าหาเป้าหมาย/มอน", 140, function(state)
    settings.AutoTarget = state
end)

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 220, 0, 25)
closeButton.Position = UDim2.new(0.5, -110, 0, 185)
closeButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
closeButton.Text = "ปิด / ซ่อนเมนู"
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

    if settings.AutoChests then
        pcall(function()
            local chestsFolder = Workspace:FindFirstChild("Chests")
            if chestsFolder then
                for _, chest in ipairs(chestsFolder:GetChildren()) do
                    local targetPart = chest:IsA("BasePart") and chest or chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart")
                    if targetPart then
                        local dist = (humanoidRootPart.Position - targetPart.Position).Magnitude
                        if dist < 100 then
                            humanoid:MoveTo(targetPart.Position)
                            break
                        end
                    end
                end
            end
        end)
    end

    if settings.AutoDrops then
        pcall(function()
            local dropsFolder = Workspace:FindFirstChild("LootDrops")
            if dropsFolder then
                for _, drop in ipairs(dropsFolder:GetChildren()) do
                    local targetPart = drop:IsA("BasePart") and drop or drop:FindFirstChildWhichIsA("BasePart")
                    if targetPart then
                        local dist = (humanoidRootPart.Position - targetPart.Position).Magnitude
                        if dist < 100 then
                            humanoid:MoveTo(targetPart.Position)
                            break
                        end
                    end
                end
            end
        end)
    end

    if settings.AutoTarget then
        pcall(function()
            local humanoidsFolder = Workspace:FindFirstChild("Humanoids")
            if humanoidsFolder then
                for _, enemy in ipairs(humanoidsFolder:GetChildren()) do
                    local hrp = enemy:FindFirstChild("HumanoidRootPart")
                    local hum = enemy:FindFirstChild("Humanoid")
                    if hrp and hum and hum.Health > 0 and enemy ~= character then
                        local dist = (humanoidRootPart.Position - hrp.Position).Magnitude
                        if dist < 80 and dist > 5 then
                            humanoid:MoveTo(hrp.Position)
                            break
                        end
                    end
                end
            end
        end)
    end
end)

