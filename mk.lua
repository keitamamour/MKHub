-- ========================================
-- MK HUB FULL (WORKING)
-- ========================================

local player = game.Players.LocalPlayer
repeat wait() until player.Character

local RunService = game:GetService("RunService")
local event = game.ReplicatedStorage:WaitForChild("AttackEvent")

-- STATES
local farm = false
local boss = false
local fruit = false

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- LOGO MK
local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0,60,0,60)
logo.Position = UDim2.new(0,20,0,200)
logo.Text = "MK"
logo.TextScaled = true
logo.BackgroundColor3 = Color3.fromRGB(0,0,0)
logo.TextColor3 = Color3.fromRGB(255,0,0)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,200)
frame.Position = UDim2.new(0,100,0,150)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = false
frame.Active = true
frame.Draggable = true

logo.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- CREATE BUTTON
local function createButton(text, y, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1,-20,0,40)
    btn.Position = UDim2.new(0,10,0,y)
    btn.Text = text.." OFF"
    btn.TextScaled = true
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " ON" or " OFF")
        callback(state)
    end)
end

createButton("AUTO FARM", 10, function(v) farm = v end)
createButton("AUTO BOSS", 60, function(v) boss = v end)
createButton("AUTO FRUIT", 110, function(v) fruit = v end)

-- FUNCTIONS
local function getMob()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= player.Character then
            return v
        end
    end
end

local function getBoss()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("katakuri") then
            return v
        end
    end
end

local function getFruit()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("fruit") and v:IsA("Part") then
            return v
        end
    end
end

-- LOOP
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if farm then
        local mob = getMob()
        if mob and mob:FindFirstChild("HumanoidRootPart") then
            root.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
            event:FireServer(mob)
        end
    end

    if boss then
        local b = getBoss()
        if b and b:FindFirstChild("HumanoidRootPart") then
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
