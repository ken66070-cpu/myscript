-- =============================================
--   🔥 Suij Hub Style [ไม่ต้องใช้คีย์]
--   ฟังก์ชันครบ: Auto Farm, Spin, Teleport
--   ใช้ UI พื้นฐาน (ไม่ต้องพึ่ง Rayfield)
-- =============================================

local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SuijHubNoKey"
screenGui.Parent = player.PlayerGui

-- ปุ่มเปิดเมนู
local mainBtn = Instance.new("TextButton")
mainBtn.Size = UDim2.new(0, 60, 0, 60)
mainBtn.Position = UDim2.new(0, 15, 0, 100)
mainBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
mainBtn.Text = "⚡"
mainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mainBtn.TextScaled = true
mainBtn.Font = Enum.Font.GothamBold
mainBtn.Parent = screenGui

local menuOpen = false
local menuFrame = nil

local function createMenu()
    if menuOpen then
        if menuFrame then menuFrame:Destroy() end
        menuOpen = false
        return
    end

    menuOpen = true
    menuFrame = Instance.new("Frame")
    menuFrame.Size = UDim2.new(0, 280, 0, 400)
    menuFrame.Position = UDim2.new(0, 90, 0, 70)
    menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    menuFrame.BackgroundTransparency = 0.1
    menuFrame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    title.Text = "⚡ Suij Hub [No Key]"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = menuFrame

    local function createBtn(text, yPos, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.Position = UDim2.new(0.05, 0, yPos, 0)
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamMedium
        btn.Parent = menuFrame
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local y = 0.12

    -- Auto Farm
    createBtn("⚔️ Auto Farm", y, Color3.fromRGB(60, 60, 200), function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/6Wumpus6/SpyHub/main/ShindoLife", true))()
        print("✅ Auto Farm เปิดแล้ว!")
    end)
    y = y + 0.1

    -- Auto Spin
    createBtn("🔄 Auto Spin 50 รอบ", y, Color3.fromRGB(200, 150, 50), function()
        for i = 1, 50 do
            player.startevent:FireServer("spin", "kg1")
            task.wait(0.1)
        end
        print("✅ หมุน Bloodline ครบ 50 รอบ!")
    end)
    y = y + 0.1

    -- Teleport
    createBtn("📍 Shindai Valley", y, Color3.fromRGB(50, 200, 100), function()
        player.Character.HumanoidRootPart.CFrame = CFrame.new(-2500, 100, -2500)
        print("✅ ไป Shindai Valley แล้ว!")
    end)
    y = y + 0.1

    createBtn("📍 Dunes Village", y, Color3.fromRGB(50, 200, 100), function()
        player.Character.HumanoidRootPart.CFrame = CFrame.new(2000, 50, 2000)
        print("✅ ไป Dunes Village แล้ว!")
    end)
    y = y + 0.1

    -- Reset Stats
    createBtn("🔄 รีเซ็ตสเตตัส", y, Color3.fromRGB(200, 50, 50), function()
        player.startevent:FireServer("resetstats")
        print("✅ รีเซ็ตสเตตัสแล้ว!")
    end)
    y = y + 0.1

    -- Fly
    createBtn("✈️ โหมดบิน", y, Color3.fromRGB(0, 150, 255), function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TerminalZer0/ShindoLife/main/Fly"))()
        print("✅ เปิดโหมดบิน!")
    end)
end

mainBtn.MouseButton1Click:Connect(createMenu)

print("✅ Suij Hub [No Key] โหลดสำเร็จ!")
print("💡 กดปุ่ม ⚡ ที่มุมซ้ายเพื่อเปิดเมนู")
