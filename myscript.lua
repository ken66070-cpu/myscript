-- == Basic Utility Script ==
-- ใช้ได้กับ executor ที่รองรับ loadstring และ基本的な API

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ===== 1. Fullbright =====
local function enableFullbright()
    Lighting.Brightness = 3
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") then
            v.Enabled = false
        end
    end
    print("[✓] Fullbright เปิดใช้งาน")
end

-- ===== 2. Noclip =====
local noclipEnabled = false
local noclipConn

local function toggleNoclip(state)
    noclipEnabled = state
    if noclipConn then noclipConn:Disconnect() end
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
        print("[✓] Noclip เปิด")
    else
        print("[✗] Noclip ปิด")
    end
end

-- ===== 3. Godmode (กึ่งสำเร็จรูป) =====
-- หมายเหตุ: Godmode จริงๆ ต้องพึ่งช่องโหว่ของเกมนั้นๆ
-- ที่ทำได้ทั่วไปคือการทำให้ Humanoid ไม่รับความเสียหาย
local godmodeEnabled = false

local function toggleGodmode(state)
    godmodeEnabled = state
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if state then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            print("[✓] Godmode เปิด (แบบ MaxHealth)")
        else
            humanoid.MaxHealth = 100
            humanoid.Health = 100
            print("[✗] Godmode ปิด")
        end
    end
end

-- ===== 4. Save Spot (จำตำแหน่ง) =====
local savedPosition = nil
local savedCFrame = nil

local function saveSpot()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedCFrame = char.HumanoidRootPart.CFrame
        savedPosition = savedCFrame.Position
        print("[✓] บันทึกตำแหน่ง: " .. tostring(savedPosition))
    else
        warn("[✗] ไม่พบตัวละคร")
    end
end

local function teleportToSpot()
    if not savedCFrame then
        warn("[✗] ยังไม่ได้บันทึกตำแหน่ง")
        return
    end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = savedCFrame
        print("[✓] วาร์ปกลับตำแหน่งที่บันทึก")
    end
end

-- ===== เมนู GUI แบบง่าย =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UtilityGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 280)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "Utility Script"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = Frame

local function makeButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Text = text
    btn.Parent = Frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

makeButton("Fullbright", 40, enableFullbright)
makeButton("Toggle Noclip", 80, function() toggleNoclip(not noclipEnabled) end)
makeButton("Toggle Godmode", 120, function() toggleGodmode(not godmodeEnabled) end)
makeButton("Save Spot", 160, saveSpot)
makeButton("Teleport to Spot", 200, teleportToSpot)
makeButton("ปิดเมนู", 240, function() ScreenGui:Destroy() end)

print("[✓] โหลดสคริปต์สำเร็จ")
