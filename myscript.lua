-- == Basic Utility Script (เวอร์ชันปรับปรุง) ==
-- ใช้ได้กับ executor ที่รองรับ loadstring และ API พื้นฐาน

local Players     = game:GetService("Players")
local Lighting    = game:GetService("Lighting")
local RunService  = game:GetService("RunService")
local UserInput   = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

------------------------------------------------------------
-- 1. Fullbright
------------------------------------------------------------
local function enableFullbright()
    Lighting.Brightness      = 3
    Lighting.ClockTime       = 14
    Lighting.FogEnd          = 100000
    Lighting.GlobalShadows   = false
    Lighting.OutdoorAmbient  = Color3.fromRGB(178, 178, 178)
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") then v.Enabled = false end
    end
    print("[✓] Fullbright เปิดใช้งาน")
end

------------------------------------------------------------
-- 2. Noclip
------------------------------------------------------------
local noclipEnabled = false
local noclipConn

local function toggleNoclip(state)
    noclipEnabled = state
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end)
        print("[✓] Noclip เปิด")
    else
        print("[✗] Noclip ปิด")
    end
end

------------------------------------------------------------
-- 3. Godmode (แบบ MaxHealth)
------------------------------------------------------------
local godmodeEnabled = false

local function toggleGodmode(state)
    godmodeEnabled = state
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if state then
            humanoid.MaxHealth = math.huge
            humanoid.Health    = math.huge
            print("[✓] Godmode เปิด")
        else
            humanoid.MaxHealth = 100
            humanoid.Health    = 100
            print("[✗] Godmode ปิด")
        end
    end
end

------------------------------------------------------------
-- 4. Save Spot / Teleport
------------------------------------------------------------
local savedCFrame = nil

local function saveSpot()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedCFrame = char.HumanoidRootPart.CFrame
        print("[✓] บันทึกตำแหน่ง: " .. tostring(savedCFrame.Position))
    else
        warn("[✗] ไม่พบตัวละคร")
    end
end

local function teleportToSpot()
    if not savedCFrame then warn("[✗] ยังไม่ได้บันทึกตำแหน่ง"); return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = savedCFrame
        print("[✓] วาร์ปกลับตำแหน่งที่บันทึก")
    end
end

------------------------------------------------------------
-- 5. Speed
------------------------------------------------------------
local speedEnabled = false
local defaultSpeed = 16
local speedValue   = 60

local function applySpeed()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speedEnabled and speedValue or defaultSpeed
    end
end

local function toggleSpeed(state)
    speedEnabled = state
    applySpeed()
    print(state and "[✓] Speed เปิด" or "[✗] Speed ปิด")
end

------------------------------------------------------------
-- 6. Infinite Jump
------------------------------------------------------------
local infJumpEnabled = false
local infJumpConn

local function toggleInfJump(state)
    infJumpEnabled = state
    if infJumpConn then infJumpConn:Disconnect(); infJumpConn = nil end
    if state then
        infJumpConn = UserInput.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.Space then
                local char = LocalPlayer.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end)
        print("[✓] Infinite Jump เปิด")
    else
        print("[✗] Infinite Jump ปิด")
    end
end

------------------------------------------------------------
-- 7. Fly (ง่ายๆ)
------------------------------------------------------------
local flyEnabled = false
local flyConn
local flySpeed = 60
local bodyVel, bodyGyro

local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVel.Velocity = Vector3.zero
    bodyVel.Parent   = hrp

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.P        = 1e4
    bodyGyro.CFrame   = hrp.CFrame
    bodyGyro.Parent   = hrp

    flyConn = RunService.RenderStepped:Connect(function()
        if not bodyVel or not bodyGyro then return end
        local move = Vector3.zero
        if UserInput:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
        if UserInput:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
        if UserInput:IsKeyDown(Enum.KeyCode.A) then move -= Camera.CFrame.RightVector end
        if UserInput:IsKeyDown(Enum.KeyCode.D) then move += Camera.CFrame.RightVector end
        if UserInput:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UserInput:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
        bodyVel.Velocity = move.Magnitude > 0 and move.Unit * flySpeed or Vector3.zero
        bodyGyro.CFrame  = Camera.CFrame
    end)
end

local function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if bodyVel then bodyVel:Destroy(); bodyVel = nil end
    if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
end

local function toggleFly(state)
    flyEnabled = state
    if state then startFly(); print("[✓] Fly เปิด")
    else stopFly(); print("[✗] Fly ปิด") end
end

------------------------------------------------------------
-- GUI
------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name          = "UtilityGui"
ScreenGui.ResetOnSpawn  = false
ScreenGui.Parent        = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size             = UDim2.new(0, 240, 0, 420)
Frame.Position         = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel  = 0
Frame.Active           = true
Frame.Draggable        = true
Frame.Parent           = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size             = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text             = "Utility Script"
Title.TextColor3       = Color3.new(1, 1, 1)
Title.Font             = Enum.Font.GothamBold
Title.TextSize         = 14
Title.Parent           = Frame

local function makeButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(1, -20, 0, 35)
    btn.Position         = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3       = Color3.new(1, 1, 1)
    btn.Font             = Enum.Font.Gotham
    btn.TextSize         = 13
    btn.Text             = text
    btn.Parent           = Frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

makeButton("Fullbright",          40,  enableFullbright)
makeButton("Toggle Noclip",       80,  function() toggleNoclip(not noclipEnabled) end)
makeButton("Toggle Godmode",      120, function() toggleGodmode(not godmodeEnabled) end)
makeButton("Save Spot",           160, saveSpot)
makeButton("Teleport to Spot",    200, teleportToSpot)
makeButton("Toggle Speed",        240, function() toggleSpeed(not speedEnabled) end)
makeButton("Toggle Infinite Jump",280, function() toggleInfJump(not infJumpEnabled) end)
makeButton("Toggle Fly",          320, function() toggleFly(not flyEnabled) end)
makeButton("ปิดเมนู",              360, function() ScreenGui:Destroy() end)

print("[✓] โหลดสคริปต์สำเร็จ")
