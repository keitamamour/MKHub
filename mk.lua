-- ========================================
-- MK HUB FINAL - CAMERA LIBRE
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

    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                
                local dist = (char.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                
                if dist < shortest then
                    shortest = dist
                    closest = char
                end
            end
        end
    end

    return closest
end

-- 🧱 GUI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 160)
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
toggle.Position = UDim2.new(0, 10, 0, 40)
toggle.Text = "AIM: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.TextScaled = true

local switchBtn = Instance.new("TextButton", frame)
switchBtn.Size = UDim2.new(1, -20, 0, 40)
switchBtn.Position = UDim2.new(0, 10, 0, 90)
switchBtn.Text = "CHANGE TARGET"
switchBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
switchBtn.TextColor3 = Color3.fromRGB(255,255,255)
switchBtn.TextScaled = true

-- 🔘 ON / OFF
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

-- 🔄 bouton mobile changer cible
switchBtn.MouseButton1Click:Connect(function()
    lockedTarget = getClosestPlayer()
end)

-- ⌨️ touche PC changer cible
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Q then
        lockedTarget = getClosestPlayer()
    end
end)

-- 🎯 AUTO AIM (CAMERA LIBRE) + AUTO ATTACK
RunService.RenderStepped:Connect(function()
    if aiming then
        
        -- lock automatique
        if not lockedTarget or not lockedTarget:FindFirstChild("HumanoidRootPart") then
            lockedTarget = getClosestPlayer()
        end

        if lockedTarget then
            local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetRoot = lockedTarget.HumanoidRootPart

            if myRoot and targetRoot then
                
                -- 🎯 direction vers cible (sans caméra)
                local direction = (targetRoot.Position - myRoot.Position).Unit

                -- 🔥 attaque universelle (PC + mobile)
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end

                -- debug
                print("TARGET:", lockedTarget.Name)
            end
        end
    end
end)
