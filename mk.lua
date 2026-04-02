-- ========================================
-- MK AUTO FARM
-- ========================================

local player = game.Players.LocalPlayer
repeat wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")

local RunService = game:GetService("RunService")

local farming = true

print("MK AUTO FARM LOADED 🔥")

-- 🔍 Trouver mob le plus proche
local function getClosestMob()
    local closest = nil
    local shortest = math.huge

    for _, mob in pairs(workspace:GetDescendants()) do
        if mob:IsA("Model")
        and mob:FindFirstChild("Humanoid")
        and mob:FindFirstChild("HumanoidRootPart")
        and mob ~= player.Character
        and not game.Players:GetPlayerFromCharacter(mob) then
            
            local dist = (mob.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            
            if dist < shortest then
                shortest = dist
                closest = mob
            end
        end
    end

    return closest
end

-- 🔄 AUTO FARM LOOP
RunService.RenderStepped:Connect(function()
    if farming then
        
        local target = getClosestMob()

        if target and target:FindFirstChild("HumanoidRootPart") then
            
            local myRoot = player.Character.HumanoidRootPart
            local targetRoot = target.HumanoidRootPart

            -- 🚀 Se téléporter au mob
            myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)

            -- ⚔️ Attaquer automatiquement
            local tool = player.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end

            print("FARMING:", target.Name)
        end
    end
end)
