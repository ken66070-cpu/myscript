print("--- เริ่มเทสสคริปต์ ---")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TestGui"
screenGui.Parent = playerGui

local textButton = Instance.new("TextButton")
textButton.Size = UDim2.new(0, 200, 0, 50)
textButton.Position = UDim2.new(0.5, -100, 0.5, -25)
textButton.Text = "ทำงานสำเร็จ!"
textButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
textButton.Parent = screenGui

print("--- สร้างปุ่มเสร็จแล้ว ---")
