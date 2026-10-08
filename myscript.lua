local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- รายการคำศัพท์ภาษาอังกฤษและคำแปลภาษาไทยที่คุณต้องการ
local translations = {
    ["Farm"] = "ฟาร์ม",
    ["Quests, mobs, bosses and pickups"] = "เควส, มอนสเตอร์, บอส และของดรอป",
    ["Quests & Mobs"] = "เควส & มอนสเตอร์",
    ["Bosses"] = "บอส",
    ["Caches"] = "แคช/กล่อง",
    ["Schematics"] = "แปลน/คัมภีร์",
    ["Craft & Refine"] = "คราฟต์ & ตีบวก",
    ["Leveling"] = "เก็บเลเวล",
    ["One Click Level Up"] = "อัปเลเวลคลิกเดียว",
    ["Mobs"] = "มอนสเตอร์",
    ["Auto Farm Mobs"] = "ออโต้ฟาร์มมอนสเตอร์",
    ["Slayer Gourds"] = "ขวดปราณ (Gourds)",
    ["Auto Gourd"] = "ออโต้ฝึกขวดปราณ",
    ["Buy Gourds From Ren"] = "ซื้อขวดปราณจากเร็น",
    ["Large Gourd"] = "ขวดปราณขนาดใหญ่",
    ["Keep Wen"] = "เก็บเงินเวน (Wen)",
    ["Status"] = "สถานะ",
    ["Slayer Progress"] = "ความคืบหน้านักล่า",
    ["Home"] = "หน้าแรก",
    ["Cloud"] = "คลาวด์",
    ["Market"] = "ตลาด",
    ["Priority"] = "ลำดับความสำคัญ",
    ["Player"] = "ผู้เล่น",
    ["Webhook"] = "เว็บฮุค",
    ["Settings"] = "ตั้งค่า"
}

-- ฟังก์ชันแปลงข้อความ
local function applyTranslation(obj)
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        local originalText = obj.Text
        if translations[originalText] then
            obj.Text = translations[originalText]
        end
        -- คอยฟังการเปลี่ยนแปลงข้อความ
        obj:GetPropertyChangedSignal("Text"):Connect(function()
            if translations[obj.Text] then
                obj.Text = translations[obj.Text]
            end
        end)
    end
end

-- สแกนใน PlayerGui และ CoreGui ทั้งหมด
local function scanContainer(container)
    for _, descendant in ipairs(container:GetDescendants()) do
        applyTranslation(descendant)
    end
    container.DescendantAdded:Connect(function(child)
        task.wait(0.1) -- รอ UI โหลดแป๊บหนึ่ง
        applyTranslation(child)
    end)
end

pcall(function()
    scanContainer(playerGui)
    scanContainer(CoreGui)
end)

print("ระบบแปลภาษาไทยเริ่มทำงานแล้ว!")

