local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

if CoreGui:FindFirstChild("AnimeBallHub") then
    CoreGui.AnimeBallHub:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AnimeBallHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

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
titleLabel.Text = "การต่อสู้บอลอนิเมะ (Hub)"
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
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        end
        callback(state)
    end)
end

createToggle("ตีบอลอัตโนมัติ", 50, function(state)
    settings.AutoHit = state
end)

createToggle("เดินเข้าหาบอลออโต้", 95, function(state)
    settings.AutoFarm = state
end)

createToggle("ระบบหลบสกิลอัจฉริยะ", 140, function(state)
    settings.AutoDodge = state
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

-- ฟังก์ชันตรวจสอบว่ากำลังอยู่ในสนามต่อสู้จริงหรือไม่
local function isInArena()
    local arenaMapLive = Workspace:FindFirstChild("ArenaMapLive")
    return arenaMapLive and #arenaMapLive:GetChildren() > 0
end

RunService.RenderStepped:Connect(function()
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")

    if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then return end

    -- ถ้าอยู่หน้าล็อบบี้ จะไม่สั่งเดินหรือหลบเด็ดขาด ป้องกันการเดินมั่ว
    if not isInArena() then return end

    -- 1. ระบบตีบอลอัตโนมัติ (ยิงผ่าน ArenaRemotes ที่ตรวจพบ)
    if settings.AutoHit then
        pcall(function()
            local arenaRemotes = ReplicatedStorage:FindFirstChild("ArenaRemotes")
            if arenaRemotes then
                local inputRemote = arenaRemotes:FindFirstChild("Input")
                if inputRemote and inputRemote:IsA("RemoteEvent") then
                    inputRemote:FireServer(true)
                end
                -- สั่งเรียกทุกรีโมตที่เกี่ยวกับการโจมตีเผื่อสำรอง
                for _, remote in ipairs(arenaRemotes:GetChildren()) do
                    if remote:IsA("RemoteEvent") and (remote.Name:lower().match("hit") or remote.Name:lower().match("parry") or remote.Name:lower().match("event")) then
                        remote:FireServer()
                    end
                end
            end
        end)
    end

    -- 2. ระบบเดินเข้าหาบอล/เป้าหมายเฉพาะในแมทช์
    if settings.AutoFarm then
        pcall(function()
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj.Name:lower().match("ball") or obj.Name:lower().match("part") or obj.Name:lower().match("model") then
                    local targetPart = obj:IsA("BasePart") and obj or (obj:FindFirstChild("HumanoidRootPart") and obj.HumanoidRootPart)
                    if targetPart and targetPart ~= humanoidRootPart then
                        local distance = (humanoidRootPart.Position - targetPart.Position).Magnitude
                        if distance < 65 and distance > 4 then
                            humanoid:MoveTo(targetPart.Position)
                            break
                        end
                    end
                end
            end
        end)
    end

    -- 3. ระบบหลบสกิลอัจฉริยะ (ระยะไกลขยับตัวเนียนๆ / ระยะใกล้พุ่งหลบฉุกเฉิน)
    if settings.AutoDodge then
        pcall(function()
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj ~= humanoidRootPart and not obj:IsDescendantOf(character) then
                    local distance = (humanoidRootPart.Position - obj.Position).Magnitude
                    
                    -- ถ้าระยะปานกลาง (35 Studs) ขยับตัวเตรียมหลบแบบเนียนๆ ไม่ให้โป๊ะ
                    if distance <= 35 and distance > 18 then
                        local subtleMove = humanoidRootPart.Position + (humanoidRootPart.CFrame.RightVector * math.random(-12, 12))
                        humanoid.WalkSpeed = 18
                        humanoid:MoveTo(subtleMove)
                        break
                    -- พอเข้ามาใกล้ในระยะอันตราย (<= 18 Studs) สั่งพุ่งหลบออกด้านข้างทันทีอย่างรวดเร็ว
                    elseif distance <= 18 then
                        local emergencySide = humanoidRootPart.CFrame.RightVector * (math.random(0, 1) == 1 and 35 or -35)
                        humanoid.WalkSpeed = 24
                        humanoid:MoveTo(humanoidRootPart.Position + emergencySide)
                        break
                    else
                        humanoid.WalkSpeed = 16
                    end
                end
            end
        end)
    end
end)

