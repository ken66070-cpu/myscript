-- นำโค้ดนี้ไปรันหลังจากที่เปิดสคริปต์หลักของคุณขึ้นมาแล้ว
local CoreGui = game:GetService("CoreGui")

-- กำหนดคำศัพท์ที่ต้องการแปล (คำอังกฤษ = คำภาษาไทยที่ต้องการเปลี่ยน)
local translations = {
    ["Auto Farm"] = "ออโต้ฟาร์ม",
    ["Auto Chest"] = "ออโต้เก็บกล่อง",
    ["Auto Drop"] = "ออโต้เก็บของดรอป",
    ["Auto Boss"] = "ออโต้ตีบอส",
    ["Teleport"] = "วาร์ป",
    ["Settings"] = "ตั้งค่า",
    ["Combat"] = "ระบบต่อสู้",
    ["Quests"] = "เควส",
    ["Shop"] = "ร้านค้า",
    ["Enable"] = "เปิด",
    ["Disable"] = "ปิด"
}

-- ฟังก์ชันคอยตรวจจับและเปลี่ยนข้อความอัตโนมัติ
local function translateGui(node)
    for _, descendant in ipairs(node:GetDescendants()) do
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
            local text = descendant.Text
            if translations[text] then
                descendant.Text = translations[text]
            end
            
            -- คอยฟัง Event เผื่อข้อความมีการเปลี่ยนแปลงทีหลัง
            descendant:GetPropertyChangedSignal("Text"):Connect(function()
                if translations[descendant.Text] then
                    descendant.Text = translations[descendant.Text]
                end
            end)
        end
    end
end

-- ค้นหาและแปลงข้อความใน CoreGui (ที่สคริปต์ส่วนใหญ่ชอบแสดงผล GUI)
translateGui(CoreGui)

-- เผื่อกรณีสคริปต์โหลดหน้าต่างทีหลัง ให้คอยสแกนเพิ่ม
CoreGui.DescendantAdded:Connect(function(child)
    if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
        if translations[child.Text] then
            child.Text = translations[child.Text]
        end
    end
end)

