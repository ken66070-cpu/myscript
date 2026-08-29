-- =============================================
--   🔥 Shindo Life Hub 2026 (แบบไม่ใช้ Rayfield)
--   ใช้ UI พื้นฐานของ Roblox เห็นปุ่มชัวร์!
-- =============================================

local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

-- สร้างปุ่มหลักตรงมุมซ้าย
local mainButton = Instance.new("TextButton")
mainButton.Size = UDim2.new(0, 50, 0, 50)
mainButton.Position = UDim2.new(0, 10, 0, 100)
mainButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
mainButton.Text = "🔥"
mainButton.TextScaled = true
mainButton.Parent = screenGui

-- ฟังก์ชัน Auto Spin
local function StartAutoSpin()
    print("🔄 กำลังหมุน Bloodline...")
    for i = 1, 50 do
        player.startevent:FireServer("spin", "kg1")
        task.wait(0.3)
    end
    print("✅ หมุน Bloodline ครบ 50 รอบแล้ว!")
end

-- ฟังก์ชันเปลี่ยน Bloodline
local function EquipBloodline(bloodline)
    local bloodlineMap = {
        ["Akuma"] = "sharingan",
        ["Rengoku"] = "rinnegan",
        ["Shindai"] = "shindaiakuma",
        ["Sengoku"] = "sengoku",
        ["Borumaki"] = "borumaki",
        ["Dio Senko"] = "namikazegod",
        ["Shiver Akuma"] = "obitosharingan",
        ["Tengoku"] = "tenseigan",
    }
    local id = bloodlineMap[bloodline]
    if id then
        player.startevent:FireServer("equipkg", player.statz.main["kg1"])
        print("✅ เปลี่ยนเป็น " .. bloodline .. " แล้ว!")
    end
end

-- สร้างเมนูเมื่อกดปุ่มหลัก
local menuOpen = false
local menuFrame = nil

mainButton.MouseButton1Click:Connect(function()
    if menuOpen then
        if menuFrame then menuFrame:Destroy() end
        menuOpen = false
        return
    end
    
    menuOpen = true
    menuFrame = Instance.new("Frame")
    menuFrame.Size = UDim2.new(0, 250, 0, 400)
    menuFrame.Position = UDim2.new(0, 70, 0, 100)
    menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    menuFrame.BackgroundTransparency = 0.1
    menuFrame.Parent = screenGui
    
    -- หัวข้อ
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "🔥 Shindo Life 2026"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Parent = menuFrame
    
    -- ปุ่มฟาร์ม
    local farmBtn = Instance.new("TextButton")
    farmBtn.Size = UDim2.new(0.9, 0, 0, 40)
    farmBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
    farmBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
    farmBtn.Text = "⚔️ Auto Farm (โหลดเพิ่ม)"
    farmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    farmBtn.Parent = menuFrame
    farmBtn.MouseButton1Click:Connect(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/6Wumpus6/SpyHub/main/ShindoLife", true))()
        print("✅ เปิด Auto Farm แล้ว!")
    end)
    
    -- ปุ่ม Auto Spin
    local spinBtn = Instance.new("TextButton")
    spinBtn.Size = UDim2.new(0.9, 0, 0, 40)
    spinBtn.Position = UDim2.new(0.05, 0, 0.22, 0)
    spinBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
    spinBtn.Text = "🔄 Auto Spin 50 รอบ"
    spinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    spinBtn.Parent = menuFrame
    spinBtn.MouseButton1Click:Connect(StartAutoSpin)
    
    -- ปุ่มเปลี่ยน Bloodline
    local bloodlineBtn = Instance.new("TextButton")
    bloodlineBtn.Size = UDim2.new(0.9, 0, 0, 40)
    bloodlineBtn.Position = UDim2.new(0.05, 0, 0.34, 0)
    bloodlineBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
    bloodlineBtn.Text = "🧬 เปลี่ยนเป็น Akuma"
    bloodlineBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    bloodlineBtn.Parent = menuFrame
    bloodlineBtn.MouseButton1Click:Connect(function() EquipBloodline("Akuma") end)
    
    -- ปุ่มเทเลพอร์ต
    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(0.9, 0, 0, 40)
    tpBtn.Position = UDim2.new(0.05, 0, 0.46, 0)
    tpBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
    tpBtn.Text = "📍 เทเลพอร์ต Shindai Valley"
    tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpBtn.Parent = menuFrame
    tpBtn.MouseButton1Click:Connect(function()
        player.Character.HumanoidRootPart.CFrame = CFrame.new(-2500, 100, -2500)
        print("✅ ไป Shindai Valley แล้ว!")
    end)
    
    -- ปุ่มรีเซ็ตสเตตัส
    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(0.9, 0, 0, 40)
    resetBtn.Position = UDim2.new(0.05, 0, 0.58, 0)
    resetBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    resetBtn.Text = "🔄 รีเซ็ตสเตตัส"
    resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetBtn.Parent = menuFrame
    resetBtn.MouseButton1Click:Connect(function()
        player.startevent:FireServer("resetstats")
        print("✅ รีเซ็ตสเตตัสแล้ว!")
    end)
    
    -- ปุ่มโหมดบิน
    local flyBtn = Instance.new("TextButton")
    flyBtn.Size = UDim2.new(0.9, 0, 0, 40)
    flyBtn.Position = UDim2.new(0.05, 0, 0.70, 0)
    flyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    flyBtn.Text = "✈️ โหมดบิน"
    flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyBtn.Parent = menuFrame
    flyBtn.MouseButton1Click:Connect(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TerminalZer0/ShindoLife/main/Fly"))()
        print("✅ เปิดโหมดบินแล้ว!")
    end)
end)

print("✅ โหลด Shindo Life Hub 2026 สำเร็จ! (ไม่ใช้ Rayfield)")
print("🔥 กดปุ่ม 🔥 ที่มุมซ้ายเพื่อเปิดเมนู!")
