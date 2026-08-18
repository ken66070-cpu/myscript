-- โครงสร้างสคริปต์ Auto Farm / Auto Quest - Shindo Life
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- ตัวแปรตั้งค่าการทำงาน (สามารถปรับเปลี่ยนค่าได้)
_G.AutoFarm = true
_G.AutoQuest = true
_G.AutoBoss = true
_G.FastAttack = true
_G.AboveOffset = CFrame.new(0, 5, 0) -- ตำแหน่งลอยตัวอยู่เหนือหัวมอนสเตอร์ (สูงขึ้นไป 5 หน่วย)

-- ฟังก์ชันสำหรับวาร์ป (Tween / CFrame TP)
local function TpTo(targetCFrame)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
    end
end

-- ฟังก์ชันจำลองการตีไว (Fast Attack)
task.spawn(function()
    while task.wait(0.1) do
        if _G.FastAttack then
            pcall(function()
                -- เรียกใช้งาน Event การโจมตีของเกม Shindo Life (ขึ้นอยู่กับการอัปเดต Remotes ของเกม)
                -- ตัวอย่างจำลองการเรียก Remote โจมตี
                local combatRemote = ReplicatedStorage:FindFirstChild("Combat", true)
                if combatRemote and combatRemote:IsA("RemoteEvent") then
                    combatRemote:FireServer("Attack")
                end
            end)
        end
    end
end)

-- ฟังก์ชันหลัก: ออโต้รับเควสและฟาร์มมอนสเตอร์
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoFarm then
            pcall(function()
                -- ค้นหามอนสเตอร์และเควสภายในเกม (ปรับชื่อ Folder ตามโครงสร้างจริงของแมพ Shindo Life)
                local npcsFolder = Workspace:FindFirstChild("NPCs") or Workspace:FindFirstChild("Live")
                
                if npcsFolder then
                    for _, enemy in pairs(npcsFolder:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
                            -- เช็คเงื่อนไขว่าเป็นมอนสเตอร์เป้าหมาย
                            if enemy.Name ~= LocalPlayer.Name then
                                
                                -- 1. วาร์ปไปลอยตัวอยู่บนหัวมอนสเตอร์
                                repeat
                                    task.wait()
                                    if enemy:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                        -- ล็อคตำแหน่งให้อยู่บนหัวมอนพอดี
                                        LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * _G.AboveOffset
                                        
                                        -- ปิดการตกลงพื้นเพื่อให้ลอยอยู่ได้
                                        if LocalPlayer.Character:FindFirstChild("Humanoid") then
                                            LocalPlayer.Character.Humanoid.PlatformStand = true
                                        end
                                    end
                                until not _G.AutoFarm or not enemy or not enemy.Parent or enemy.Humanoid.Health <= 0
                                
                                -- คืนค่าการทรงตัวเมื่อมอนตาย
                                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                                    LocalPlayer.Character.Humanoid.PlatformStand = false
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

print("Shindo Life Script Loaded Successfully!")
