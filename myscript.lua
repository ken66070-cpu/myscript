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
mainFrame.Size = UDim2.new(0, 260, 0, 200)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 30, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.BackgroundColor3 = Color3.fromRGB(55, 45, 65)
titleLabel.Text = "Slayers 2 - Boss & Loot"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local tCorner = Instance.new("UICorner")
tCorner.CornerRadius = UDim.new(0, 8)
tCorner.Parent = titleLabel

local toggles = {
    AutoLoot = false,
    AutoBoss = false
}

local function addBtn(name, y, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 220, 0, 35)
    btn.Position = UDim2.new(0.5, -110, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(60, 50, 80)
    btn.Text = name .. ": ปิด"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = mainFrame

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = btn

    btn.MouseButton1Click:Connect(function()
        toggles[key] = not toggles[key]
        if toggles[key] then
            btn.Text = name .. ": เปิด"
            btn.TextColor3 = Color3.fromRGB(100, 255, 100)
            btn.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
        else
            btn.Text = name .. ": ปิด"
            btn.TextColor3 = Color3.fromRGB(255, 100, 100)
            btn.BackgroundColor3 = Color3.fromRGB(60, 50, 80)
        end
    end)
end

addBtn("ออโต้ดูดไอเทมดรอป/กล่อง", 45, "AutoLoot")
addBtn("ออโต้ฟาร์มบอส/มอนสเตอร์", 90, "AutoBoss")

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 220, 0, 30)
closeBtn.Position = UDim2.new(0.5, -110, 0, 145)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
closeBtn.Text = "ปิดเมนู"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.Gotham
closeBtn.Parent = mainFrame

local cc = Instance.new("UICorner")
cc.CornerRadius = UDim.new(0, 6)
cc.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

RunService.RenderStepped:Connect(function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    -- 1. ระบบดูดไอเทมดรอปและกล่องมาหาตัวทันที (LootDrops & Chests)
    if toggles.AutoLoot then
        pcall(function()
            local folders = {Workspace:FindFirstChild("LootDrops"), Workspace:FindFirstChild("Chests")}
            for _, folder in ipairs(folders) do
                if folder then
                    for _, item in ipairs(folder:GetChildren()) do
                        local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
                        if part then
                            -- วาปไอเทมมาหาตัวผู้เล่น เพื่อเก็บอัตโนมัติทันที
                            part.CFrame = hrp.CFrame + Vector3.new(0, 1, 0)
                        end
                    end
                end
            end
        end)
    end

    -- 2. ระบบออโต้ฟาร์มบอส/มอนสเตอร์ (วาร์ปไปประชิดและจำลองการตี)
    if toggles.AutoBoss then
        pcall(function()
            local humanoidsFolder = Workspace:FindFirstChild("Humanoids")
            if humanoidsFolder then
                for _, enemy in ipairs(humanoidsFolder:GetChildren()) do
                    local eh = enemy:FindFirstChild("Humanoid")
                    local ehrp = enemy:FindFirstChild("HumanoidRootPart")
                    if eh and ehrp and eh.Health > 0 and enemy ~= char then
                        -- วาปตัวเราไปอยู่ใกล้ๆ บอส/มอนสเตอร์ ด้านหน้าแบบประชิด
                        hrp.CFrame = ehrp.CFrame * CFrame.new(0, 0, 3)
                        
                        -- สั่งให้ตัวละครใช้เครื่องมือ (Tool) ในช่องเก็บของโจมตีอัตโนมัติ
                        for _, tool in ipairs(player.Backpack:GetChildren()) do
                            if tool:IsA("Tool") then
                                tool.Parent = char
                            end
                        end
                        for _, tool in ipairs(char:GetChildren()) do
                            if tool:IsA("Tool") then
                                tool:Activate()
                            end
                        end
                        break
                    end
                end
            end
        end)
    end
end)
