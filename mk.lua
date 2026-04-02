-- ========================================
-- MK HUB - Player Aim System
-- Auteur : Keitamamour
-- ========================================

local player = game.Players.LocalPlayer
repeat wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local aiming = false
local lockedTarget = nil

print("MK HUB LOADED 🔥")

-- 🔍 Trouver joueur le plus proche
local function getClosestPlayer()
    local closest = nil
    local shortest = math.huge

    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = plr.Character
            end
        end
    end

    return closest
end

-- 🧱 GUI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0, 50, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "MK HUB"
title.TextColor3 = Color3.fromRGB(255,0,0)
title.BackgroundTransparency = 1
title.TextScaled = true

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1, -20, 0, 40)
toggle.Position = UDim2.new(0, 10, 0, 50)
toggle.Text = "AIM: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.TextScaled = true

-- 🔘 Bouton ON/OFF
toggle.MouseButton1Click:Connect(function()
    aiming = not aiming

    if aiming then
        lockedTarget = getClosestPlayer()
        toggle.Text = "AIM: ON"
    else
        lockedTarget = nil
        toggle.Text = "AIM: OFF"
    end
end)

-- ⌨️ Changer cible (Q)
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Q then
        lockedTarget = getClosestPlayer()
    end
end)

-- 🎯 Auto aim (attaque seulement, pas caméra)
RunService.RenderStepped:Connect(function()
    if aiming and lockedTarget and lockedTarget:FindFirstChild("HumanoidRootPart") then
        
        local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = lockedTarget.HumanoidRootPart
        
        if myRoot and targetRoot then
            local direction = (targetRoot.Position - myRoot.Position).Unit

            -- ⚡ ADAPTE ICI TON SYSTEME D'ATTAQUE
            -- Exemple :
            -- game.ReplicatedStorage.AttackEvent:FireServer(direction)
        end
    end
end)
