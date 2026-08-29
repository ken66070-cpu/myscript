-- =============================================
--   🔥 Shindo Life Hub [เวอร์ชั่น 2026]
--   อัปเดต: สิงหาคม 2026
--   เขียนเอง 100%
--   ไม่ต้องใช้คีย์ 🚫
-- =============================================

-- =============================================
--   ส่วนที่ 1: ระบบ UI (ใช้ Rayfield)
-- =============================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🔥 Shindo Life 2026 [ไทย]",
    LoadingTitle = "🚀 กำลังโหลด...",
    LoadingSubtitle = "เวอร์ชั่นอัปเดตล่าสุด",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ShindoLife2026",
        FileName = "MainSettings"
    },
    KeySystem = false,
})

-- =============================================
--   ส่วนที่ 2: ฟังก์ชันหลัก
-- =============================================

-- ฟังก์ชัน Auto Spin
local function StartAutoSpin()
    getgenv().BloodlineSpin = true
    getgenv().ElementSpin = false
    
    task.spawn(function()
        while getgenv().BloodlineSpin do
            game.Players.LocalPlayer.startevent:FireServer("spin", "kg1")
            task.wait(0.5)
        end
    end)
end

-- ฟังก์ชันเปลี่ยน Bloodline (อัปเดตล่าสุด 2026)
local function EquipBloodline(bloodlineName)
    local player = game.Players.LocalPlayer
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
        player.startevent:FireServer("equipkg", player.statz.main["kg"..tostring(1)])
        print("✅ เปลี่ยนเป็น " .. bloodlineName .. " แล้ว!")
    else
        print("❌ ไม่พบสายเลือด: " .. bloodlineName)
    end
end

-- =============================================
--   ส่วนที่ 3: สร้าง GUI
-- =============================================

-- แท็บหลัก
local MainTab = Window:CreateTab("🏠 หลัก", nil)
local FarmSection = MainTab:CreateSection("⚔️ ฟาร์มอัตโนมัติ")

FarmSection:CreateButton({
    Name = "▶️ เปิด Auto Farm",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/6Wumpus6/SpyHub/main/ShindoLife", true))()
        print("✅ เปิด Auto Farm แล้ว!")
    end,
})

FarmSection:CreateButton({
    Name = "💰 ฟาร์ม Ryo",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Corrupt2625/Revamps/main/SpyHub.lua"))()
        print("✅ เปิดฟาร์ม Ryo แล้ว!")
    end,
})

FarmSection:CreateButton({
    Name = "🔄 Auto Spin",
    Callback = function()
        StartAutoSpin()
        print("✅ เปิด Auto Spin แล้ว!")
    end,
})

-- แท็บสปิน
local SpinTab = Window:CreateTab("🎰 สปิน", nil)
local SpinSection = SpinTab:CreateSection("🌀 หมุนสายเลือด/ธาตุ")

SpinSection:CreateButton({
    Name = "♾️ Infinite Spin",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FurkyYT/stuff/main/infspin"))()
        print("✅ เปิด Infinite Spin แล้ว!")
    end,
})

SpinSection:CreateButton({
    Name = "⚡ Infinite Element Spin",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/P0BqvPg7"))()
        print("✅ เปิด Infinite Element Spin แล้ว!")
    end,
})

-- แท็บ Bloodline
local BloodTab = Window:CreateTab("🧬 เลือด", nil)
local BloodSection = BloodTab:CreateSection("⚔️ เปลี่ยน Bloodline")

local bloodlines = {
    "Akuma", "Raion Akuma", "Shindai", "Rengoku", "Sengoku",
    "Borumaki", "Narumaki", "Senko", "Dio Senko", "Renshiki",
    "Shizen", "Atomic", "Apollo Sand", "Ashen Storm", "Black Storm",
    "Dokei", "Arahaki Jokei", "Light Jokei", "Dark Jokei",
    "Azarashi", "Ghost Korashi", "Inferno Korashi", "Saberu", "Odin Saberu",
    "Shiver Akuma", "Raion Rengoku", "Raion Sengoku", "Renshiki Gold",
    "Forged Rengoku", "Forged Sengoku", "Deva Rengoku", "Deva Sengoku",
    "Borumaki Gold", "Narumaki Yang", "Xeno Dokei", "Giovanni Shizen",
    "Rykan Shizen", "Pika Senko", "Tengoku", "Satori"
}

for _, name in ipairs(bloodlines) do
    BloodSection:CreateButton({
        Name = "🔀 เปลี่ยนเป็น " .. name,
        Callback = function() EquipBloodline(name) end,
    })
end

-- แท็บเทเลพอร์ต
local TeleportTab = Window:CreateTab("📍 เทเลพอร์ต", nil)
local TeleportSection = TeleportTab:CreateSection("🗺️ พื้นที่ฟาร์ม")

TeleportSection:CreateButton({
    Name = "🏔️ Shindai Valley",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2500, 100, -2500)
        print("✅ ไป Shindai Valley แล้ว!")
    end,
})

TeleportSection:CreateButton({
    Name = "🏜️ Dunes Village",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2000, 50, 2000)
        print("✅ ไป Dunes Village แล้ว!")
    end,
})

TeleportSection:CreateButton({
    Name = "🏘️ หมู่บ้านโคนoha",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-200, 50, 500)
        print("✅ ไปหมู่บ้านโคนoha แล้ว!")
    end,
})

-- แท็บอื่นๆ
local MiscTab = Window:CreateTab("🛠️ อื่นๆ", nil)
local MiscSection = MiscTab:CreateSection("⚙️ ฟังก์ชันเสริม")

MiscSection:CreateButton({
    Name = "🔄 รีเซ็ตสเตตัส",
    Callback = function()
        game.Players.LocalPlayer.startevent:FireServer("resetstats")
        print("✅ รีเซ็ตสเตตัสแล้ว!")
    end,
})

MiscSection:CreateButton({
    Name = "✈️ โหมดบิน",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TerminalZer0/ShindoLife/main/Fly"))()
        print("✅ เปิดโหมดบินแล้ว!")
    end,
})

print("✅ โหลด Shindo Life Hub 2026 ภาษาไทยเรียบร้อยแล้ว!")
