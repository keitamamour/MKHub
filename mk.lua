-- ========================================
-- MK HUB - Auto Aim / Aimbot System
-- Auteur : Keitamamour
-- ========================================

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

print("MK LOADED ✅")

-- ========== CONFIGURATION ==========
local aiming = false
local lockedTarget = nil

-- Trouver l’ennemi le plus proche
local function getClosestEnemy()
    local closest = nil
    local shortestDistance = math.huge

    for _, enemy in pairs(workspace:WaitForChild("Enemies"):GetChildren()) do
        if enemy:FindFirstChild("HumanoidRootPart") then
            local distance = (enemy.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closest = enemy
            end
        end
    end

    return closest
end

-- ========== CREATION DU BOUTON MK ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 120, 0, 50)
btn.Position = UDim2.new(0, 20, 0, 100)
btn.Text = "MK OFF"
btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
btn.TextColor3 = Color3.fromRGB(255,0,0)
btn.TextScaled = true
btn.Parent = screenGui

btn.MouseButton1Click:Connect(function()
    aiming = not aiming
    if aiming then
        lockedTarget = getClosestEnemy()
        btn.Text = "MK ON"
    else
        lockedTarget = nil
        btn.Text = "MK OFF"
    end
end)

-- ========== LOCK CIBLE AVEC TOUCHE Q ==========
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Q then
        lockedTarget = getClosestEnemy()
    end
end)

-- ========== BOUCLE AUTO-AIM ==========
RunService.RenderStepped:Connect(function()
    if aiming and lockedTarget and lockedTarget:FindFirstChild("HumanoidRootPart") then
        camera.CFrame = CFrame.new(camera.CFrame.Position, lockedTarget.HumanoidRootPart.Position)
    end
end)
