-- == Player ESP + Speed Custom ==

local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

------------------------------------------------------------
-- 1. ESP ผู้เล่น (สีเขียว/แดง + ระยะทาง)
------------------------------------------------------------
local espEnabled = false
local espFolder  = Instance.new("Folder")
espFolder.Name   = "ESP_Highlights"
espFolder.Parent = game.CoreGui

local espData = {} -- [player] = {highlight=, billboard=, nameLabel=, distLabel=}

local FRIENDLY_COLOR   = Color3.fromRGB(0, 255, 0)   -- เขียว (ปกติ/เพื่อน)
local ENEMY_COLOR      = Color3.fromRGB(255, 0, 0)   -- แดง (ฆ่าตก/ศัตรู)

-- วิธีตัดสินว่าใครเป็นศัตรู: ใช้ Team ถ้ามี, ถ้าไม่มีให้ถือว่าทุกคนเป็นศัตรู
-- ถ้าอยากกำหนดเอง ให้แก้ฟังก์ชัน isEnemy ด้านล่าง
local function isEnemy(plr)
    if plr.Team and LocalPlayer.Team then
        return plr.Team ~= LocalPlayer.Team
    end
    return true -- ไม่มีทีม = มองเป็นศัตรูทั้งหมด
end

local function createESP(plr)
    if plr == LocalPlayer then return end
    if espData[plr] then return end

    local function attach(char)
        if not char then return end

        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end

        -- Highlight
        local hl = Instance.new("Highlight")
        hl.Name           = "ESP_HL"
        hl.Adornee        = char
        hl.DepthMode      = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillTransparency = 0.6
        hl.OutlineTransparency = 0
        hl.FillColor      = isEnemy(plr) and ENEMY_COLOR or FRIENDLY_COLOR
        hl.OutlineColor   = hl.FillColor
        hl.Parent         = espFolder

        -- Billboard บอกชื่อ + ระยะ
        local bb = Instance.new("BillboardGui")
        bb.Name          = "ESP_BB"
        bb.Adornee       = hrp
        bb.Size          = UDim2.new(0, 200, 0, 50)
        bb.StudsOffset   = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop   = true
        bb.Parent        = espFolder

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size             = UDim2.new(1, 0, 0.5, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.TextColor3       = hl.FillColor
        nameLbl.Font             = Enum.Font.GothamBold
        nameLbl.TextSize         = 14
        nameLbl.TextStrokeTransparency = 0
        nameLbl.Text             = plr.Name .. (isEnemy(plr) and " [ENEMY]" or " [ALLY]")
        nameLbl.Parent           = bb

        local distLbl = Instance.new("TextLabel")
        distLbl.Size             = UDim2.new(1, 0, 0.5, 0)
        distLbl.Position         = UDim2.new(0, 0, 0.5, 0)
        distLbl.BackgroundTransparency = 1
        distLbl.TextColor3       = Color3.fromRGB(255, 255, 255)
        distLbl.Font             = Enum.Font.Gotham
        distLbl.TextSize         = 13
        distLbl.TextStrokeTransparency = 0
        distLbl.Text             = "0 m"
        distLbl.Parent           = bb

        espData[plr] = {
            highlight = hl,
            billboard = bb,
            nameLabel = nameLbl,
            distLabel = distLbl,
            char      = char
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

-- อัปเดตระยะทุกเฟรม
RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    local myChar = LocalPlayer.Character
    local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    for plr, d in pairs(espData) do
        local char = plr.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and d.distLabel and d.highlight then
            local dist = (hrp.Position - myHRP.Position).Magnitude
            d.distLabel.Text = string.format("%d m", math.floor(dist))

            -- อัปเดตสีตามสถานะ (เผื่อเปลี่ยนทีม)
            local color = isEnemy(plr) and ENEMY_COLOR or FRIENDLY_COLOR
            d.highlight.FillColor    = color
            d.highlight.OutlineColor = color
            d.nameLabel.TextColor3   = color
            d.nameLabel.Text         = plr.Name .. (isEnemy(plr) and " [ENEMY]" or " [ALLY]")
        end
    end
end)

-- เพิ่ม/ลบผู้เล่นอัตโนมัติ
Players.PlayerAdded:Connect(function(plr)
    if espEnabled then createESP(plr) end
end)
Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
end)

------------------------------------------------------------
-- 2. Speed (ปรับเองได้)
------------------------------------------------------------
local speedValue = 16
local speedEnabled = false
local baseSpeed = 16

local function applySpeed()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speedEnabled and speedValue or baseSpeed
    end
end

local function setSpeed(v)
    speedValue = tonumber(v) or speedValue
    speedEnabled = true
    applySpeed()
    print("[✓] ตั้งความเร็ว = " .. speedValue)
end

local function disableSpeed()
    speedEnabled = false
    applySpeed()
    print("[✗] Speed ปิด")
end

-- เมื่อตัวละครเกิดใหม่ ให้ apply ความเร็วเดิม
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    applySpeed()
end)

------------------------------------------------------------
-- GUI
------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name          = "ESP_Speed_Gui"
ScreenGui.ResetOnSpawn  = false
ScreenGui.Parent        = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size             = UDim2.new(0, 260, 0, 480)
Frame.Position         = UDim2.new(0, 20, 0, 80)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel  = 0
Frame.Active           = true
Frame.Draggable        = true
Frame.Parent           = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size             = UDim2.new(1, 0, 0, 32)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text             = "ESP + Speed"
Title.TextColor3       = Color3.new(1, 1, 1)
Title.Font             = Enum.Font.GothamBold
Title.TextSize         = 15
Title.Parent           = Frame

local function makeButton(text, yPos, callback, height)
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(1, -20, 0, height or 32)
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

-- ปุ่ม ESP
local espBtn = makeButton("Toggle ESP", 40, function()
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

-- ป้ายหัวข้อ Speed
local lbl = Instance.new("TextLabel")
lbl.Size             = UDim2.new(1, -20, 0, 24)
lbl.Position         = UDim2.new(0, 10, 0, 80)
lbl.BackgroundTransparency = 1
lbl.Text             = "ความเร็วเคลื่อนที่"
lbl.TextColor3       = Color3.fromRGB(200, 200, 200)
lbl.Font             = Enum.Font.GothamBold
lbl.TextSize         = 13
lbl.TextXAlignment   = Enum.TextXAlignment.Left
lbl.Parent           = Frame

-- ปุ่มความเร็วสำเร็จรูป
local speedPresets = {20, 30, 40, 50, 100, 200}
local startY = 108
for i, v in ipairs(speedPresets) do
    local col = (i - 1) % 2
    local row = math.floor((i - 1) / 2)
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(0.5, -15, 0, 30)
    btn.Position         = UDim2.new(col * 0.5, 10, 0, startY + row * 34)
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 90)
    btn.TextColor3       = Color3.new(1, 1, 1)
    btn.Font             = Enum.Font.Gotham
    btn.TextSize         = 13
    btn.Text             = tostring(v)
    btn.Parent           = Frame
    btn.MouseButton1Click:Connect(function() setSpeed(v) end)
end

-- ช่องกรอกความเร็วเอง
local boxY = startY + 3 * 34 + 5
local input = Instance.new("TextBox")
input.Size             = UDim2.new(1, -20, 0, 32)
input.Position         = UDim2.new(0, 10, 0, boxY)
input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
input.TextColor3       = Color3.new(1, 1, 1)
input.Font             = Enum.Font.Gotham
input.TextSize         = 13
input.PlaceholderText  = "พิมพ์ความเร็วเอง เช่น 75"
input.Text             = ""
input.Parent           = Frame

local applyBtn = Instance.new("TextButton")
applyBtn.Size             = UDim2.new(1, -20, 0, 32)
applyBtn.Position         = UDim2.new(0, 10, 0, boxY + 38)
applyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 180)
applyBtn.TextColor3       = Color3.new(1, 1, 1)
applyBtn.Font             = Enum.Font.GothamBold
applyBtn.TextSize         = 13
applyBtn.Text             = "ใช้ค่าที่พิมพ์"
applyBtn.Parent           = Frame
applyBtn.MouseButton1Click:Connect(function()
    local v = tonumber(input.Text)
    if v and v > 0 and v < 1000 then
        setSpeed(v)
    else
        warn("[✗] ค่าไม่ถูกต้อง (ต้องเป็นตัวเลข 1-999)")
    end
end)

-- ปุ่มปิด Speed
local offBtn = makeButton("ปิด Speed (กลับเป็น 16)", boxY + 76, function()
    disableSpeed()
end)

-- ปุ่มปิดเมนู
makeButton("ปิดเมนู", boxY + 114, function() ScreenGui:Destroy() end)

print("[✓] โหลดสคริปต์ ESP + Speed สำเร็จ")
