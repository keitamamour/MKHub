-- ========================================
-- MK HUB PRO (STYLE REDZ MAIS CLEAN)
-- ========================================

local player = game.Players.LocalPlayer
repeat wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")

local RunService = game:GetService("RunService")
local event = game.ReplicatedStorage:WaitForChild("AttackEvent")

-- STATES
local farm = false
local boss = false
local fruit = false

-- 🔴 BOUTON LOGO MK
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local open = false

local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0,60,0,60)
logo.Position = UDim2.new(0,20,0,200)
logo.Text = "MK"
logo.BackgroundColor3 = Color3.fromRGB(0,0,0)
logo.TextColor3 = Color3.fromRGB(255,0,0)
logo.TextScaled = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,200)
frame.Position = UDim2.new(0,100,0,150)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = false
frame.Active = true
frame.Draggable = true

logo.MouseButton1Click:Connect(function()
    open = not open
    frame.Visible = open
end)

-- BOUTONS
local function makeButton(name, posY, callback)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,40)
    b.Position = UDim2.new(0,10,0,posY)
    b.Text = name.." OFF"
    b.TextScaled = true

    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = name .. (state and " ON" or " OFF")
        callback(state)
    end)
end

makeButton("AUTO FARM", 10, function(v) farm = v end)
makeButton("AUTO BOSS", 60, function(v) boss = v end)
makeButton("AUTO FRUIT", 110, function(v) fruit = v end)

-- 🔍 FUNCTIONS
local function getMob()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:FindFirstChild("Humanoid") and v ~= player.Character then
            return v
        end
    end
end

local function getBoss()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("katakuri") and v:FindFirstChild("Humanoid") then
            return v
        end
    end
end

local function getFruit()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("fruit") then
            return v
        end
    end
end

-- 🔄 LOOP
RunService.RenderStepped:Connect(function()
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if farm then
        local mob = getMob()
        if mob then
            root.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
            event:FireServer(mob)
        end
    end

    if boss then
        local b = getBoss()
        if b then
            root.CFrame = b.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
            event:FireServer(b)
        end
    end

    if fruit then
        local f = getFruit()
        if f then
            root.CFrame = f.CFrame
        end
    end
end)
