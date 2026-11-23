
-- EGG HUB | EGG FINDER
-- Roblox Studio LocalScript
-- Kendi oyunun için prototip

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

local old = gui:FindFirstChild("EggFinder")
if old then old:Destroy() end

local screen = Instance.new("ScreenGui")
screen.Name = "EggFinder"
screen.ResetOnSpawn = false
screen.Parent = gui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(300, 330)
frame.Position = UDim2.new(0.5, -150, 0.5, -165)
frame.BackgroundColor3 = Color3.fromRGB(23,23,27)
frame.BorderSizePixel = 0
frame.Parent = screen

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,6)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,42)
title.BackgroundColor3 = Color3.fromRGB(190,35,42)
title.Text = "EGG FINDER"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

local list = Instance.new("ScrollingFrame")
list.Position = UDim2.fromOffset(10,55)
list.Size = UDim2.new(1,-20,1,-110)
list.BackgroundColor3 = Color3.fromRGB(32,32,37)
list.BorderSizePixel = 0
list.ScrollBarThickness = 4
list.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,5)
layout.Parent = list

local function scanEggs()
    for _,v in ipairs(list:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end

    local count = 0

    for _,obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("egg") then
            if obj:IsA("BasePart") then
                count += 1

                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1,-8,0,35)
                button.BackgroundColor3 = Color3.fromRGB(55,55,60)
                button.TextColor3 = Color3.new(1,1,1)
                button.Font = Enum.Font.Gotham
                button.TextSize = 11
                button.Text = obj.Name
                button.Parent = list

                button.MouseButton1Click:Connect(function()
                    local pos = obj.Position
                    button.Text = string.format(
                        "%s | %.0f, %.0f, %.0f",
                        obj.Name,pos.X,pos.Y,pos.Z
                    )
                end)
            end
        end
    end

    list.CanvasSize = UDim2.fromOffset(
        0,count * 40
    )
end

local refresh = Instance.new("TextButton")
refresh.Size = UDim2.new(1,-20,0,38)
refresh.Position = UDim2.new(0,10,1,-47)
refresh.BackgroundColor3 = Color3.fromRGB(190,35,42)
refresh.Text = "REFRESH"
refresh.TextColor3 = Color3.new(1,1,1)
refresh.Font = Enum.Font.GothamBold
refresh.TextSize = 13
refresh.Parent = frame

refresh.MouseButton1Click:Connect(scanEggs)

scanEggs()
