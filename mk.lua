-- ========================================
-- MK HUB ULTRA AUTO FARM
-- Auteur : Keitamamour
-- ========================================

local player = game.Players.LocalPlayer
repeat wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local farming = false
local autoKatakuri = false
local autoFruit = false

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,250,0,220)
frame.Position = UDim2.new(0,50,0,100)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "MK HUB ULTRA"
title.TextColor3 = Color3.fromRGB(255,0,0)
title.TextScaled = true
title.BackgroundTransparency = 1

-- Boutons
local toggleFarm = Instance.new("TextButton", frame)
toggleFarm.Size = UDim2.new(1,-20,0,40)
toggleFarm.Position = UDim2.new(0,10,0,40)
toggleFarm.Text = "AUTO FARM: OFF"
toggleFarm.TextScaled = true

local toggleKatakuri = Instance.new("TextButton", frame)
toggleKatakuri.Size = UDim2.new(1,-20,0,40)
toggleKatakuri.Position = UDim2.new(0,10,0,90)
toggleKatakuri.Text = "AUTO KATAKURI: OFF"
toggleKatakuri.TextScaled = true

local toggleFruit = Instance.new("TextButton", frame)
toggleFruit.Size = UDim2.new(1,-20,0,40)
toggleFruit.Position = UDim2.new(0,10,0,140)
toggleFruit.Text = "AUTO FRUIT: OFF"
toggleFruit.TextScaled = true

-- 🔘 Boutons toggle
toggleFarm.MouseButton1Click:Connect(function()
    farming = not farming
    toggleFarm.Text = farming and "AUTO FARM: ON" or "AUTO FARM: OFF"
end)

toggleKatakuri.MouseButton1Click:Connect(function()
    autoKatakuri = not autoKatakuri
    toggleKatakuri.Text = autoKatakuri and "AUTO KATAKURI: ON" or "AUTO KATAKURI: OFF"
end)

toggleFruit.MouseButton1Click:Connect(function()
    autoFruit = not autoFruit
    toggleFruit.Text = autoFruit and "AUTO FRUIT: ON" or "AUTO FRUIT: OFF"
end)

-- 🔍 Functions
local function getClosestMob()
    local closest = nil
    local shortest = math.huge

    for _, mob in pairs(workspace:GetDescendants()) do
        if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob ~= player.Character then
            local dist = (mob.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = mob
            end
        end
    end

    return closest
end

local function getKatakuriMob()
    for _, mob in pairs(workspace:GetDescendants()) do
        if mob:IsA("Model") and mob.Name:lower():find("katakuri") and mob:FindFirstChild("HumanoidRootPart") then
            return mob
        end
    end
end

local function getClosestFruit()
    local closest = nil
    local shortest = math.huge
    for _, fruit in pairs(workspace:GetDescendants()) do
        if fruit:IsA("Part") and fruit.Name:lower():find("fruit") then
            local dist = (fruit.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = fruit
            end
        end
    end
    return closest
end

-- 🔄 Loop Auto Farm
RunService.RenderStepped:Connect(function()
    local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    -- Auto Katakuri
    if autoKatakuri then
        local kat = getKatakuriMob()
        if kat then
            local targetRoot = kat.HumanoidRootPart
            myRoot.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0,0,3))
            local tool = player.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end

    -- Auto Fruit
    if autoFruit then
        local fruit = getClosestFruit()
        if fruit then
            myRoot.CFrame = CFrame.new(fruit.Position + Vector3.new(0,3,0))
        end
    end

    -- Auto Farm Mob normal
    if farming then
        local mob = getClosestMob()
        if mob then
            local targetRoot = mob.HumanoidRootPart
            myRoot.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0,0,3))
            local tool = player.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end
end)
