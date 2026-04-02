-- MK HUB TOUT-EN-UN
-- Auteur : runato_7m
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local RepStorage = game:GetService("ReplicatedStorage")

-- Crée l'event admin si pas existant
local event = RepStorage:FindFirstChild("MK_Admin")
if not event then
    event = Instance.new("RemoteEvent")
    event.Name = "MK_Admin"
    event.Parent = RepStorage
end

-- Variables
local tradeFrozen = false
local farm, boss, fruit = false, false, false

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0,60,0,60)
logo.Position = UDim2.new(0,20,0,200)
logo.Text = "MK"
logo.TextScaled = true
logo.BackgroundColor3 = Color3.fromRGB(0,0,0)
logo.TextColor3 = Color3.fromRGB(255,0,0)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,380)
frame.Position = UDim2.new(0,100,0,150)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = false
frame.Active = true
frame.Draggable = true

logo.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Helper function pour créer boutons
local function makeBtn(text, y, callback)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,40)
    b.Position = UDim2.new(0,10,0,y)
    b.Text = text
    b.TextScaled = true
    b.MouseButton1Click:Connect(callback)
end

-- Boutons MK
makeBtn("FREEZE TRADE", 10, function() 
    tradeFrozen = true
    event:FireServer("freeze")
end)
makeBtn("UNFREEZE TRADE", 60, function() 
    tradeFrozen = false
    event:FireServer("unfreeze")
end)
makeBtn("CANCEL TRADES", 110, function() 
    event:FireServer("cancel")
end)
makeBtn("GIVE ITEM", 160, function()
    local target = player -- changer si besoin
    event:FireServer("give", target, "NomDeTonItem")
end)

-- Auto functions
makeBtn("AUTO FARM", 210, function() farm = not farm end)
makeBtn("AUTO BOSS", 260, function() boss = not boss end)
makeBtn("AUTO FRUIT", 310, function() fruit = not fruit end)

-- Fonctions pour trouver mobs/boss/fruit
local function getMob()
    local closest, dist = nil, math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= player.Character then
            local hrp = v:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = v
                end
            end
        end
    end
    return closest
end

local function getBoss()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():find("katakuri") then
            return v
        end
    end
end

local function getFruit()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and v.Name:lower():find("fruit") then
            return v
        end
    end
end

-- Boucle principale
RunService.RenderStepped:Connect(function()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = player.Character.HumanoidRootPart

    -- Auto Farm
    if farm then
        local mob = getMob()
        if mob and mob:FindFirstChild("HumanoidRootPart") then
            root.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
        end
    end

    -- Auto Boss
    if boss then
        local b = getBoss()
        if b and b:FindFirstChild("HumanoidRootPart") then
            root.CFrame = b.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
        end
    end

    -- Auto Fruit
    if fruit then
        local f = getFruit()
        if f then
            root.CFrame = f.CFrame
        end
    end
end)
