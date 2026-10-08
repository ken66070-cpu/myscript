-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- การตั้งค่าระบบ Auto อัปเกรด
local CONFIG = {
    AutoFarmEnabled = true,     -- เปิด/ปิด การเดินเข้าหาเป้าหมาย
    AutoHitEnabled = true,      -- เปิด/ปิด การตี/ปัดบอลออโต้
    AutoDodgeEnabled = true,    -- เปิด/ปิด ระบบหลบสกิลอัตโนมัติ
    HitDistance = 15,           -- ระยะโจมตี (studs)
    DodgeDistance = 18,         -- ระยะที่จะเริ่มทำการหลบเมื่อมีสกิลหรือศัตรูพุ่งเข้ามา
    DetectionRadius = 120,      -- รัศมีในการค้นหาเป้าหมาย
}

-- ฟังก์ชันเลือกเป้าหมายอัจฉริยะ (เลือกตัวที่เลือดน้อยที่สุด หรืออยู่ใกล้ที่สุด)
local function getSmartTarget()
    local bestTarget = nil
    local lowestHealth = math.huge
    local shortestDistance = CONFIG.DetectionRadius

    local targetsFolder = Workspace:FindFirstChild("Balls") or Workspace:FindFirstChild("Enemies")
    if not targetsFolder then return nil end

    for _, target in ipairs(targetsFolder:GetChildren()) do
        local targetHRP = target:FindFirstChild("HumanoidRootPart") or (target:IsA("BasePart") and target)
        local targetHumanoid = target:FindFirstChild("Humanoid")

        if targetHRP then
            local distance = (humanoidRootPart.Position - targetHRP.Position).Magnitude
            
            if distance <= CONFIG.DetectionRadius then
                -- เงื่อนไข: ถ้ามี Humanoid ให้เน้นตัวที่เลือดน้อยกว่าเพื่อกำจัดไว หรือถ้าไม่มีให้เทียบจากระยะ
                local health = targetHumanoid and targetHumanoid.Health or 100
                
                if health < lowestHealth or distance < shortestDistance then
                    lowestHealth = health
                    shortestDistance = distance
                    bestTarget = targetHRP
                end
            end
        end
    end

    return bestTarget
end

-- ฟังก์ชันตรวจสอบและหลบสกิลอัตโนมัติ
local function checkAndDodge()
    if not CONFIG.AutoDodgeEnabled then return end

    local dangerFolder = Workspace:FindFirstChild("Projectiles") or Workspace:FindFirstChild("Skills")
    if not dangerFolder then return end

    for _, skill in ipairs(dangerFolder:GetChildren()) do
        local part = skill:FindFirstChild("Handle") or skill:IsA("BasePart") and skill
        if part then
            local distance = (humanoidRootPart.Position - part.Position).Magnitude
            if distance <= CONFIG.DodgeDistance then
                -- สั่งให้ตัวละครสไลด์หลบไปด้านข้างแบบสุ่มทิศทางทันที
                local randomOffset = Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
                humanoid:MoveTo(humanoidRootPart.Position + randomOffset)
                return -- หลบเสร็จให้ออกจากการเช็คชั่วคราว
            end
        end
    end
end

-- ฟังก์ชันจำลองการโจมตี / ปัดบอล
local function performHit()
    local remoteFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if remoteFolder and remoteFolder:FindFirstChild("HitEvent") then
        remoteFolder.HitEvent:FireServer()
    else
        print("Auto-Hit: ปัดบอลอนิเมะอัตโนมัติเรียบร้อย!")
    end
end

-- ลูปหลักการทำงาน
RunService.RenderStepped:Connect(function()
    if not character or not humanoid or humanoid.Health <= 0 then return end

    -- 1. เช็คระบบหลบสกิลก่อนเป็นลำดับแรก (ความปลอดภัยมาอันดับหนึ่ง)
    checkAndDodge()

    -- 2. หาระบบเป้าหมายอัจฉริยะ
    local target = getSmartTarget()

    if target then
        local distance = (humanoidRootPart.Position - target.Position).Magnitude

        -- โจมตีอัตโนมัติเมื่ออยู่ในระยะ
        if CONFIG.AutoHitEnabled and distance <= CONFIG.HitDistance then
            performHit()
        end

        -- เดินเข้าหาเป้าหมายเพื่อฟาร์ม
        if CONFIG.AutoFarmEnabled and distance > CONFIG.HitDistance then
            humanoid:MoveTo(target.Position)
        end
    end
end)

-- จัดการรีเซ็ตตัวละคร
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    humanoid = newChar:WaitForChild("Humanoid")
end)
