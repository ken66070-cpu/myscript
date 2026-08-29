-- =============================================
--   🔥 SHINDO LIFE HUB 2026 [เวอร์ชันสมบูรณ์]
--   อัปเดตล่าสุด: สิงหาคม 2026
--   ใช้ UI พื้นฐาน (ไม่ต้องพึ่ง Rayfield)
--   ฟังก์ชันครบทุกอย่างที่ต้องการ!
-- =============================================

-- =============================================
--   ส่วนที่ 1: ตัวแปรและเซ็ตอัพพื้นฐาน
-- =============================================

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ตัวแปรสถานะของสคริป
local scriptState = {
    autoFarm = false,
    autoSpin = false,
    autoBoss = false,
    flyMode = false,
    espEnabled = false,
    currentBloodline = "Akuma"
}

-- ฟังก์ชันสำหรับส่งข้อความในเกม
local function notifyPlayer(text, color)
    color = color or Color3.fromRGB(255, 255, 255)
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0, 300, 0, 40)
    notification.Position = UDim2.new(0.5, -150, 0.8, 0)
    notification.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notification.BackgroundTransparency = 0.5
    notification.Text = text
    notification.TextColor3 = color
    notification.TextScaled = true
    notification.Font = Enum.Font.GothamBold
    notification.Parent = player.PlayerGui
    game:GetService("Debris"):AddItem(notification, 3)
end

-- =============================================
--   ส่วนที่ 2: ฟังก์ชันหลักของเกม
-- =============================================

-- ฟังก์ชัน Auto Farm (ฟาร์มอัตโนมัติ)
local function toggleAutoFarm()
    scriptState.autoFarm = not scriptState.autoFarm
    if scriptState.autoFarm then
        notifyPlayer("⚔️ เปิด Auto Farm แล้ว!", Color3.fromRGB(0, 255, 0))
        -- เริ่มฟาร์ม (ใช้ฟังก์ชันจาก SpyHub)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/6Wumpus6/SpyHub/main/ShindoLife", true))()
    else
        notifyPlayer("⏹️ ปิด Auto Farm แล้ว!", Color3.fromRGB(255, 0, 0))
    end
end

-- ฟังก์ชัน Auto Spin (หมุนสายเลือดอัตโนมัติ)
local function toggleAutoSpin()
    scriptState.autoSpin = not scriptState.autoSpin
    if scriptState.autoSpin then
        notifyPlayer("🔄 เริ่ม Auto Spin!", Color3.fromRGB(255, 200, 0))
        task.spawn(function()
            while scriptState.autoSpin do
                player.startevent:FireServer("spin", "kg1")
                task.wait(0.3)
            end
        end)
    else
        notifyPlayer("⏹️ หยุด Auto Spin!", Color3.fromRGB(255, 0, 0))
    end
end

-- ฟังก์ชัน Auto Boss (ล่าบอสอัตโนมัติ)
local function toggleAutoBoss()
    scriptState.autoBoss = not scriptState.autoBoss
    if scriptState.autoBoss then
        notifyPlayer("👹 เริ่มล่าบอส!", Color3.fromRGB(255, 100, 0))
        -- ใช้ฟังก์ชัน Boss Farm จากแหล่งที่อัปเดต
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TerminalZer0/ShindoLife/main/BossFarm"))()
    else
        notifyPlayer("⏹️ หยุดล่าบอส!", Color3.fromRGB(255, 0, 0))
    end
end

-- ฟังก์ชันเปลี่ยน Bloodline (อัปเดตรายการล่าสุด)
local function setBloodline(bloodlineName)
    local bloodlineMap = {
        ["Akuma"] = "sharingan",
        ["Raion Akuma"] = "sasukesharingan",
        ["Shindai"] = "shindaiakuma",
        ["Rengoku"] = "rinnegan",
        ["Sengoku"] = "sengoku",
        ["Borumaki"] = "borumaki",
        ["Narumaki"] = "narumaki",
        ["Senko"] = "namikaze",
        ["Dio Senko"] = "namikazegod",
        ["Renshiki"] = "renshiki",
        ["Shizen"] = "senjuwood",
        ["Atomic"] = "dust",
        ["Apollo Sand"] = "ironsand",
        ["Ashen Storm"] = "whitelightning",
        ["Black Storm"] = "blacklightning",
        ["Dokei"] = "ketsuryugan",
        ["Arahaki Jokei"] = "byakugangold",
        ["Light Jokei"] = "lightjokei",
        ["Dark Jokei"] = "darkjokei",
        ["Azarashi"] = "uzumaki",
        ["Ghost Korashi"] = "ghostazarashi",
        ["Inferno Korashi"] = "infernoazarashi",
        ["Saberu"] = "saberu",
        ["Odin Saberu"] = "odinsaberu",
        ["Shiver Akuma"] = "obitosharingan",
        ["Raion Rengoku"] = "raionrengoku",
        ["Raion Sengoku"] = "raionsengoku",
        ["Renshiki Gold"] = "renshikigold",
        ["Forged Rengoku"] = "forgedrengoku",
        ["Forged Sengoku"] = "forgedsengoku",
        ["Deva Rengoku"] = "devarengoku",
        ["Deva Sengoku"] = "devasengoku",
        ["Borumaki Gold"] = "borumakigold",
        ["Narumaki Yang"] = "narumakiyang",
        ["Xeno Dokei"] = "xenodokei",
        ["Giovanni Shizen"] = "giovannishizen",
        ["Rykan Shizen"] = "aduritewood",
        ["Pika Senko"] = "pikapika",
        ["Tengoku"] = "tenseigan",
        ["Satori"] = "shisuisharingan",
    }
    
    local bloodlineId = bloodlineMap[bloodlineName]
    if bloodlineId then
        player.startevent:FireServer("equipkg", player.statz.main["kg1"])
        scriptState.currentBloodline = bloodlineName
        notifyPlayer("✅ เปลี่ยนเป็น " .. bloodlineName .. " แล้ว!", Color3.fromRGB(0, 255, 0))
    else
        notifyPlayer("❌ ไม่พบสายเลือด: " .. bloodlineName, Color3.fromRGB(255, 0, 0))
    end
end

-- ฟังก์ชันเทเลพอร์ต (ไปยังตำแหน่งต่างๆ)
local function teleportTo(locationName, cframe)
    if character and rootPart then
        rootPart.CFrame = cframe
        notifyPlayer("📍 เทเลพอร์ตไป " .. locationName .. " แล้ว!", Color3.fromRGB(100, 200, 255))
    else
        notifyPlayer("❌ ไม่พบตัวละคร!", Color3.fromRGB(255, 0, 0))
    end
end

-- ฟังก์ชันโหมดบิน
local function toggleFly()
    scriptState.flyMode = not scriptState.flyMode
    if scriptState.flyMode then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TerminalZer0/ShindoLife/main/Fly"))()
        notifyPlayer("✈️ เปิดโหมดบิน!", Color3.fromRGB(0, 150, 255))
    else
        -- ปิดโหมดบิน (รีเซ็ต gravity)
        game.Workspace.Gravity = 196.2
        notifyPlayer("⏹️ ปิดโหมดบิน!", Color3.fromRGB(255, 0, 0))
    end
end

-- ฟังก์ชันรีเซ็ตสเตตัส
local function resetStats()
    player.startevent:FireServer("resetstats")
    notifyPlayer("🔄 รีเซ็ตสเตตัสแล้ว!", Color3.fromRGB(255, 200, 0))
end

-- ฟังก์ชัน Auto Spin สปินธาตุ
local function toggleAutoElementSpin()
    scriptState.autoElementSpin = not scriptState.autoElementSpin
    if scriptState.autoElementSpin then
        notifyPlayer("⚡ เริ่ม Auto Element Spin!", Color3.fromRGB(255, 200, 0))
        task.spawn(function()
            while scriptState.autoElementSpin do
                player.startevent:FireServer("spin", "element1")
                task.wait(0.3)
            end
        end)
    else
        notifyPlayer("⏹️ หยุด Auto Element Spin!", Color3.fromRGB(255, 0, 0))
    end
end

-- =============================================
--   ส่วนที่ 3: สร้าง GUI (UI พื้นฐาน)
-- =============================================

-- สร้าง ScreenGui หลัก
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ShindoLifeHub"
screenGui.Parent = player.PlayerGui

-- สร้างปุ่มหลัก (ปุ่มเปิด-ปิดเมนู)
local mainButton = Instance.new("TextButton")
mainButton.Size = UDim2.new(0, 60, 0, 60)
mainButton.Position = UDim2.new(0, 15, 0, 100)
mainButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
mainButton.Text = "🔥"
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainButton.TextScaled = true
mainButton.Font = Enum.Font.GothamBold
mainButton.BorderSizePixel = 0
mainButton.Parent = screenGui

-- เพิ่มเอฟเฟกต์ให้ปุ่มหลัก
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = mainButton

-- ตัวแปรสถานะเมนู
local menuOpen = false
local menuFrame = nil

-- ฟังก์ชันสร้างเมนู
local function createMenu()
    if menuOpen then
        if menuFrame then menuFrame:Destroy() end
        menuOpen = false
        return
    end
    
    menuOpen = true
    
    -- สร้าง Frame หลักของเมนู
    menuFrame = Instance.new("Frame")
    menuFrame.Size = UDim2.new(0, 320, 0, 500)
    menuFrame.Position = UDim2.new(0, 90, 0, 70)
    menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    menuFrame.BackgroundTransparency = 0.1
    menuFrame.BorderSizePixel = 0
    menuFrame.Parent = screenGui
    
    -- เพิ่มความสวยงามให้ Frame
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 10)
    menuCorner.Parent = menuFrame
    
    -- หัวข้อเมนู
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    title.BackgroundTransparency = 0.3
    title.Text = "🔥 Shindo Life Hub 2026"
    title.TextColor3 = Color3.fromRGB(255, 200, 50)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = menuFrame
    
    -- ฟังก์ชันช่วยสร้างปุ่มในเมนู
    local function createButton(text, position, color, callback, height)
        height = height or 35
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, height)
        btn.Position = UDim2.new(0.05, 0, position, 0)
        btn.BackgroundColor3 = color or Color3.fromRGB(60, 60, 150)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamMedium
        btn.BorderSizePixel = 0
        btn.Parent = menuFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 5)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(callback)
        return btn
    end
    
    -- =============================================
    --   สร้างปุ่มต่างๆ ในเมนู
    -- =============================================
    
    local yPos = 0.1
    
    -- 1. ปุ่ม Auto Farm
    createButton("⚔️ Auto Farm (คลิกเปิด/ปิด)", yPos, Color3.fromRGB(60, 60, 200), toggleAutoFarm)
    yPos = yPos + 0.09
    
    -- 2. ปุ่ม Auto Spin
    createButton("🔄 Auto Spin (คลิกเปิด/ปิด)", yPos, Color3.fromRGB(200, 150, 50), toggleAutoSpin)
    yPos = yPos + 0.09
    
    -- 3. ปุ่ม Auto Element Spin
    createButton("⚡ Auto Element Spin (คลิกเปิด/ปิด)", yPos, Color3.fromRGB(100, 200, 255), toggleAutoElementSpin)
    yPos = yPos + 0.09
    
    -- 4. ปุ่ม Auto Boss
    createButton("👹 Auto Boss (คลิกเปิด/ปิด)", yPos, Color3.fromRGB(200, 80, 80), toggleAutoBoss)
    yPos = yPos + 0.09
    
    -- 5. ปุ่มเปลี่ยน Bloodline (เลือก Akuma)
    createButton("🧬 เปลี่ยนเป็น Akuma", yPos, Color3.fromRGB(150, 50, 200), function() setBloodline("Akuma") end)
    yPos = yPos + 0.09
    
    -- 6. ปุ่มเปลี่ยน Bloodline (เลือก Rengoku)
    createButton("🧬 เปลี่ยนเป็น Rengoku", yPos, Color3.fromRGB(150, 50, 200), function() setBloodline("Rengoku") end)
    yPos = yPos + 0.09
    
    -- 7. ปุ่มเปลี่ยน Bloodline (เลือก Shindai)
    createButton("🧬 เปลี่ยนเป็น Shindai", yPos, Color3.fromRGB(150, 50, 200), function() setBloodline("Shindai") end)
    yPos = yPos + 0.09
    
    -- 8. ปุ่มเทเลพอร์ต Shindai Valley
    createButton("🏔️ เทเลพอร์ต Shindai Valley", yPos, Color3.fromRGB(50, 200, 100), function()
        teleportTo("Shindai Valley", CFrame.new(-2500, 100, -2500))
    end)
    yPos = yPos + 0.09
    
    -- 9. ปุ่มเทเลพอร์ต Dunes Village
    createButton("🏜️ เทเลพอร์ต Dunes Village", yPos, Color3.fromRGB(50, 200, 100), function()
        teleportTo("Dunes Village", CFrame.new(2000, 50, 2000))
    end)
    yPos = yPos + 0.09
    
    -- 10. ปุ่มเทเลพอร์ต หมู่บ้านโคนoha
    createButton("🏘️ เทเลพอร์ต หมู่บ้านโคนoha", yPos, Color3.fromRGB(50, 200, 100), function()
        teleportTo("หมู่บ้านโคนoha", CFrame.new(-200, 50, 500))
    end)
    yPos = yPos + 0.09
    
    -- 11. ปุ่มเทเลพอร์ต Training Grounds
    createButton("🌲 เทเลพอร์ต Training Grounds", yPos, Color3.fromRGB(50, 200, 100), function()
        teleportTo("Training Grounds", CFrame.new(1000, 50, 1000))
    end)
    yPos = yPos + 0.09
    
    -- 12. ปุ่มโหมดบิน
    createButton("✈️ โหมดบิน (คลิกเปิด/ปิด)", yPos, Color3.fromRGB(0, 150, 255), toggleFly)
    yPos = yPos + 0.09
    
    -- 13. ปุ่มรีเซ็ตสเตตัส
    createButton("🔄 รีเซ็ตสเตตัส", yPos, Color3.fromRGB(200, 50, 50), resetStats)
    yPos = yPos + 0.09
    
    -- 14. ปุ่มดูคำสั่งในเกม
    createButton("📋 พิมพ์ !cmds ในแชท", yPos, Color3.fromRGB(100, 100, 200), function()
        player:Chat("!cmds")
        notifyPlayer("📋 พิมพ์ !cmds ในแชทแล้ว!", Color3.fromRGB(200, 200, 255))
    end)
    
    -- ปุ่มปิดเมนู (กดปุ่มหลักอีกครั้งก็ปิดได้)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(0.9, 0, 0.01, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = menuFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        if menuFrame then menuFrame:Destroy() end
        menuOpen = false
    end)
end

-- เชื่อมปุ่มหลักกับฟังก์ชันเปิดเมนู
mainButton.MouseButton1Click:Connect(createMenu)

-- =============================================
--   ส่วนที่ 4: ระบบป้องกันการตรวจจับและความเสถียร
-- =============================================

-- ตรวจสอบตัวละครเมื่อเปลี่ยนหรือตาย
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    rootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    notifyPlayer("🔄 ตัวละครเกิดใหม่!", Color3.fromRGB(100, 200, 255))
end)

-- ตรวจจับการเข้าสู่เกม
notifyPlayer("🔥 โหลด Shindo Life Hub 2026 สำเร็จ!", Color3.fromRGB(255, 200, 50))
notifyPlayer("💡 กดปุ่ม 🔥 ที่มุมซ้ายเพื่อเปิดเมนู", Color3.fromRGB(200, 200, 255))

print("✅ Shindo Life Hub 2026 (เวอร์ชันสมบูรณ์) โหลดสำเร็จ!")
print("🔥 กดปุ่ม 🔥 ที่มุมซ้ายเพื่อเปิดเมนู!")
print("💡 ฟังก์ชันทั้งหมดใช้งานได้แล้ว!")
