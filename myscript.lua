-- == Violence District Utility Script ==
-- ESP (ALLY/ENEMY + ระยะ) + Speed (ทน anti-cheat)

local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

------------------------------------------------------------
-- 1. ESP
------------------------------------------------------------
local espEnabled = false
local espFolder  = Instance.new("Folder")
espFolder.Name   = "ESP_Highlights"
espFolder.Parent = game:GetService("CoreGui")

local espData = {}

local FRIENDLY_COLOR = Color3.fromRGB(0, 255, 0)
local ENEMY_COLOR    = Color3.fromRGB(255, 0, 0)

local function isEnemy(plr)
    if plr.Team and LocalPlayer.Team then
        return plr.Team ~= LocalPlayer.Team
    end
    return true
end

local function createESP(plr)
    if plr == LocalPlayer then return end
    if espData[plr] then return end

    local function attach(char)
        if not char then return end
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end

        local hl = Instance.new("Highlight")
        hl.Name = "ESP_HL"
        hl.Adornee = char
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillTransparency = 0.6
        hl.OutlineTransparency = 0
        hl.FillColor = isEnemy(plr) and ENEMY_COLOR or FRIENDLY_COLOR
        hl.OutlineColor = hl.FillColor
        hl.Parent = espFolder

        local bb = Instance.new("BillboardGui")
        bb.Name = "ESP_BB"
        bb.Adornee = hrp
        bb.Size = UDim2.new(0, 200, 0, 50)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.Parent = espFolder

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, 0, 0.5, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.TextColor3 = hl.FillColor
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 14
        nameLbl.TextStrokeTransparency = 0
        nameLbl.Text = plr.Name .. (isEnemy(plr) and " [ENEMY]" or " [ALLY]")
        nameLbl.Parent = bb

        local distLbl = Instance.new("TextLabel")
        distLbl.Size = UDim2.new(1, 0, 0.5, 0)
        distLbl.Position = UDim2.new(0, 0, 0.5, 0)
        distLbl.BackgroundTransparency = 1
        distLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        distLbl.Font = Enum.Font.Gotham
        distLbl.TextSize = 13
        distLbl.TextStrokeTransparency = 0
        distLbl.Text = "0 m"
        distLbl.Parent = bb

        espData[plr] = {
            highlight = hl,
            billboard = bb,
            nameLabel = nameLbl,
            distLabel = distLbl,
            char = char
        }
    end

    if plr.Character then attach(plr.Character) end
    plr.CharacterAdded:Connect(attach)
end

local function removeESP(plr)
    local d = espData[plr]
    if d then
        if d.highlight then d.highlight:Destroy() end
        if d.billboard then d.billboard:Destroy() end
        espData[plr] = nil
    end
end

local function enableESP()
    espEnabled = true
    for _, plr in pairs(Players:GetPlayers()) do
        createESP(plr)
    end
    print("[✓] ESP เปิด")
end

local function disableESP()
    espEnabled = false
    for plr, _ in pairs(espData) do
        removeESP(plr)
    end
    print("[✗] ESP ปิด")
end

RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    for plr, d in pairs(espData) do
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and d.distLabel and d.highlight then
            local dist = (hrp.Position - myHRP.Position).Magnitude
            d.distLabel.Text = string.format("%d m", math.floor(dist))
            local color = isEnemy(plr) and ENEMY_COLOR or FRIENDLY_COLOR
            d.highlight.FillColor = color
            d.highlight.OutlineColor = color
            d.nameLabel.TextColor3 = color
            d.nameLabel.Text = plr.Name .. (isEnemy(plr) and " [ENEMY]" or " [ALLY]")
        end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    if espEnabled then createESP(plr) end
end)
Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
end)

------------------------------------------------------------
-- 2. Speed (Loop + BodyVelocity fallback)
------------------------------------------------------------
local speedEnabled = false
local speedValue   = 16
local baseSpeed    = 16
local useBodyVel   = false
local bodyVel      = nil

local function getHumanoid()
    local char = LocalPlayer.Character
    if not char then return nil, nil end
    return char:FindFirstChildOfClass("Humanoid"), char:FindFirstChild("HumanoidRootPart")
end

-- Loop บังคับ WalkSpeed ทุกเฟรม
RunService.Heartbeat:Connect(function()
    if not speedEnabled or useBodyVel then return end
    local humanoid = getHumanoid()
    if humanoid and humanoid.WalkSpeed ~= speedValue then
        humanoid.WalkSpeed = speedValue
    end
end)

-- BodyVelocity fallback
local function startBodyVel()
    local humanoid, hrp = getHumanoid()
    if not hrp then return end
    if bodyVel then bodyVel:Destroy() end

    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(1e5, 0, 1e5)
    bodyVel.Velocity = Vector3.zero
    bodyVel.Parent = hrp

    RunService.Heartbeat:Connect(function()
        if not bodyVel or not bodyVel.Parent then return end
        if not speedEnabled then
            bodyVel.Velocity = Vector3.zero
            return
        end
        local h = getHumanoid()
        if h then
            local dir = h.MoveDirection
            bodyVel.Velocity = Vector3.new(dir.X * speedValue, 0, dir.Z * speedValue)
        end
    end)
end

local function stopBodyVel()
    if bodyVel then bodyVel:Destroy(); bodyVel = nil end
end

local function setSpeed(v)
    speedValue = tonumber(v) or speedValue
    speedEnabled = true
    if useBodyVel then startBodyVel() end
    print("[✓] ตั้งความเร็ว = " .. speedValue)
end

local function disableSpeed()
    speedEnabled = false
    local humanoid = getHumanoid()
    if humanoid then humanoid.WalkSpeed = baseSpeed end
    stopBodyVel()
    print("[✗] Speed ปิด")
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if speedEnabled then
        if useBodyVel then startBodyVel()
        else
            local h = getHumanoid()
            if h then h.WalkSpeed = speedValue end
        end
    end
end)

------------------------------------------------------------
-- 3. GUI
------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VD_UtilityGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 260, 0, 540)
Frame.Position = UDim2.new(0, 20, 0, 60)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 32)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "Violence District Utility"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = Frame

local function makeButton(text, yPos, callback, height)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, height or 32)
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

-- ESP
local espBtn = makeButton("Toggle ESP (ปิด)", 40, function()
    if espEnabled then
        disableESP()
        espBtn.Text = "Toggle ESP (ปิด)"
        espBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    else
        enableESP()
        espBtn.Text = "Toggle ESP (เปิด)"
        espBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 0)
    end
end)

-- BodyVelocity mode
local bvBtn = makeButton("BodyVelocity Mode: OFF", 78, function()
    useBodyVel = not useBodyVel
    if useBodyVel then
        bvBtn.Text = "BodyVelocity Mode: ON"
        bvBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 120)
        if speedEnabled then startBodyVel() end
    else
        bvBtn.Text = "BodyVelocity Mode: OFF"
        bvBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        stopBodyVel()
    end
end)

-- หัวข้อ Speed
local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.new(1, -20, 0, 24)
lbl.Position = UDim2.new(0, 10, 0, 116)
lbl.BackgroundTransparency = 1
lbl.Text = "ความเร็วเคลื่อนที่"
lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
lbl.Font = Enum.Font.GothamBold
lbl.TextSize = 13
lbl.TextXAlignment = Enum.TextXAlignment.Left
lbl.Parent = Frame

-- ปุ่ม preset
local speedPresets = {20, 30, 40, 50, 100, 200}
local startY = 144
for i, v in ipairs(speedPresets) do
    local col = (i - 1) % 2
    local row = math.floor((i - 1) / 2)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, -15, 0, 30)
    btn.Position = UDim2.new(col * 0.5, 10, 0, startY + row * 34)
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 90)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Text = tostring(v)
    btn.Parent = Frame
    btn.MouseButton1Click:Connect(function() setSpeed(v) end)
end

-- ช่องกรอกเอง
local boxY = startY + 3 * 34 + 5
local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -20, 0, 32)
input.Position = UDim2.new(0, 10, 0, boxY)
input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
input.TextColor3 = Color3.new(1, 1, 1)
input.Font = Enum.Font.Gotham
input.TextSize = 13
input.PlaceholderText = "พิมพ์ความเร็วเอง เช่น 75"
input.Text = ""
input.Parent = Frame

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(1, -20, 0, 32)
applyBtn.Position = UDim2.new(0, 10, 0, boxY + 38)
applyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 180)
applyBtn.TextColor3 = Color3.new(1, 1, 1)
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 13
applyBtn.Text = "ใช้ค่าที่พิมพ์"
applyBtn.Parent = Frame
applyBtn.MouseButton1Click:Connect(function()
    local v = tonumber(input.Text)
    if v and v > 0 and v < 1000 then
        setSpeed(v)
    else
        warn("[✗] ค่าไม่ถูกต้อง (1-999)")
    end
end)

makeButton("ปิด Speed (กลับเป็น 16)", boxY + 76, disableSpeed)

local closeBtn = makeButton("ปิดเมนู", boxY + 114, function()
    ScreenGui:Destroy()
end)

print("[✓] โหลดสคริปต์ Violence District สำเร็จ")
