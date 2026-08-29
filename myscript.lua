-- =============================================
--   🔥 DZ HUB [ภาษาไทย] 
--   UI สวยงามเหมือนต้นฉบับ พร้อมฟังก์ชันครบ
--   ไม่ต้องใช้คีย์
-- =============================================

-- ส่วนแสดงผล UI หลัก
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DzHub"
screenGui.Parent = player.PlayerGui

-- ฟังก์ชันสร้างปุ่มหลัก (ทรงกลม สีส้ม)
local function createMainButton()
    local button = Instance.new("ImageButton")
    button.Size = UDim2.new(0, 55, 0, 55)
    button.Position = UDim2.new(0, 15, 0, 100)
    button.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    button.BackgroundTransparency = 0.2
    button.Image = "rbxassetid://" .. (button.Image or "0")
    button.ImageColor3 = Color3.fromRGB(255, 255, 255)
    button.ImageTransparency = 0.5
    button.Parent = screenGui

    -- ข้อความบนปุ่ม
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "Dz"
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.Parent = button

    return button
end

-- ฟังก์ชันสร้างเมนูหลัก
local function createMenu()
    local menu = Instance.new("Frame")
    menu.Size = UDim2.new(0, 350, 0, 450)
    menu.Position = UDim2.new(0.5, -175, 0.5, -225)
    menu.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    menu.BackgroundTransparency = 0.1
    menu.BorderSizePixel = 0
    menu.Parent = screenGui

    -- หัวข้อเมนู
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 45)
    title.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    title.Text = "🔥 DZ HUB [ภาษาไทย]"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = menu

    -- ปุ่มปิดเมนู (X)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 7)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = menu
    closeBtn.MouseButton1Click:Connect(function()
        menu:Destroy()
    end)

    -- ฟังก์ชันช่วยสร้างปุ่มในเมนู
    local function createButton(text, yPos, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.85, 0, 0, 35)
        btn.Position = UDim2.new(0.075, 0, yPos, 0)
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamMedium
        btn.BorderSizePixel = 0
        btn.Parent = menu
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- กำหนดตำแหน่ง Y เริ่มต้น
    local y = 0.13

    -- ปุ่มฟังก์ชันต่างๆ (เหมือน DzHub ทุกประการ)
    createButton("⚔️ เปิด Auto Farm", y, Color3.fromRGB(60, 60, 200), function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/6Wumpus6/SpyHub/main/ShindoLife", true))()
        print("✅ Auto Farm เปิดแล้ว!")
    end)
    y = y + 0.09

    createButton("🔄 หมุน Bloodline 50 ครั้ง", y, Color3.fromRGB(200, 150, 50), function()
        for i = 1, 50 do
            player.startevent:FireServer("spin", "kg1")
            task.wait(0.1)
        end
        print("✅ หมุน Bloodline ครบ 50 รอบ!")
    end)
    y = y + 0.09

    createButton("⚡ หมุน Element 50 ครั้ง", y, Color3.fromRGB(100, 200, 255), function()
        for i = 1, 50 do
            player.startevent:FireServer("spin", "element1")
            task.wait(0.1)
        end
        print("✅ หมุน Element ครบ 50 รอบ!")
    end)
    y = y + 0.09

    createButton("📍 ไป Shindai Valley", y, Color3.fromRGB(50, 200, 100), function()
        player.Character.HumanoidRootPart.CFrame = CFrame.new(-2500, 100, -2500)
        print("✅ ไป Shindai Valley แล้ว!")
    end)
    y = y + 0.09

    createButton("📍 ไป Dunes Village", y, Color3.fromRGB(50, 200, 100), function()
        player.Character.HumanoidRootPart.CFrame = CFrame.new(2000, 50, 2000)
        print("✅ ไป Dunes Village แล้ว!")
    end)
    y = y + 0.09

    createButton("🧬 เปลี่ยนเป็น Akuma", y, Color3.fromRGB(150, 50, 200), function()
        player.startevent:FireServer("equipkg", player.statz.main["kg1"])
        print("✅ เปลี่ยนเป็น Akuma!")
    end)
    y = y + 0.09

    createButton("🧬 เปลี่ยนเป็น Rengoku", y, Color3.fromRGB(150, 50, 200), function()
        player.startevent:FireServer("equipkg", player.statz.main["kg2"])
        print("✅ เปลี่ยนเป็น Rengoku!")
    end)
    y = y + 0.09

    createButton("✈️ เปิดโหมดบิน", y, Color3.fromRGB(0, 150, 255), function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TerminalZer0/ShindoLife/main/Fly"))()
        print("✅ เปิดโหมดบิน!")
    end)
    y = y + 0.09

    createButton("🔄 รีเซ็ตสเตตัส", y, Color3.fromRGB(200, 50, 50), function()
        player.startevent:FireServer("resetstats")
        print("✅ รีเซ็ตสเตตัสแล้ว!")
    end)
end

-- สร้างปุ่มหลักและเชื่อมกับการเปิดเมนู
local mainButton = createMainButton()
mainButton.MouseButton1Click:Connect(createMenu)

print("✅ DZ HUB [ภาษาไทย] โหลดสำเร็จ!")
print("💡 กดปุ่ม Dz ที่มุมซ้ายเพื่อเปิดเมนู")
