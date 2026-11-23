
-- EGG HUB | UI V1
-- Standalone Roblox UI prototype

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local old = PlayerGui:FindFirstChild("EggHub")
if old then old:Destroy() end

local Gui = Instance.new("ScreenGui")
Gui.Name = "EggHub"
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

local function New(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local Main = New("Frame", {
    Size = UDim2.fromOffset(530, 340),
    Position = UDim2.new(0.5, -265, 0.5, -170),
    BackgroundColor3 = Color3.fromRGB(16,16,20),
    BorderSizePixel = 0
}, Gui)

New("UICorner", {CornerRadius=UDim.new(0,8)}, Main)
New("UIStroke", {
    Color=Color3.fromRGB(48,48,56),
    Thickness=1
}, Main)

local Header = New("Frame", {
    Size=UDim2.new(1,0,0,43),
    BackgroundColor3=Color3.fromRGB(22,22,27),
    BorderSizePixel=0
}, Main)

New("UICorner", {CornerRadius=UDim.new(0,8)}, Header)

New("TextLabel", {
    Size=UDim2.new(1,-100,1,0),
    Position=UDim2.fromOffset(14,0),
    BackgroundTransparency=1,
    Text="egg hub",
    TextColor3=Color3.fromRGB(245,245,245),
    TextSize=17,
    Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left
}, Header)

local Close = New("TextButton", {
    Size=UDim2.fromOffset(30,30),
    Position=UDim2.new(1,-38,0,6),
    BackgroundColor3=Color3.fromRGB(42,42,49),
    Text="×",
    TextColor3=Color3.fromRGB(230,80,85),
    TextSize=20,
    Font=Enum.Font.Gotham,
    BorderSizePixel=0
}, Header)

Close.MouseButton1Click:Connect(function()
    Gui:Destroy()
end)

local Sidebar = New("Frame", {
    Position=UDim2.fromOffset(10,53),
    Size=UDim2.new(0,125,1,-63),
    BackgroundColor3=Color3.fromRGB(24,24,30),
    BorderSizePixel=0
}, Main)

New("UICorner", {CornerRadius=UDim.new(0,6)}, Sidebar)

local Content = New("Frame", {
    Position=UDim2.fromOffset(145,53),
    Size=UDim2.new(1,-155,1,-63),
    BackgroundTransparency=1
}, Main)

local function Clear()
    Content:ClearAllChildren()
end

local function Label(text,y)
    New("TextLabel", {
        Position=UDim2.fromOffset(12,y),
        Size=UDim2.new(1,-24,0,30),
        BackgroundTransparency=1,
        Text=text,
        TextColor3=Color3.fromRGB(235,235,240),
        TextSize=13,
        Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left
    }, Content)
end

local function Toggle(text,y)
    New("TextLabel", {
        Position=UDim2.fromOffset(12,y),
        Size=UDim2.new(1,-90,0,30),
        BackgroundTransparency=1,
        Text=text,
        TextColor3=Color3.fromRGB(210,210,215),
        TextSize=12,
        Font=Enum.Font.Gotham,
        TextXAlignment=Enum.TextXAlignment.Left
    }, Content)

    local enabled = false

    local btn = New("TextButton", {
        Position=UDim2.new(1,-65,0,y+3),
        Size=UDim2.fromOffset(48,23),
        BackgroundColor3=Color3.fromRGB(48,48,55),
        Text="OFF",
        TextColor3=Color3.new(1,1,1),
        TextSize=10,
        Font=Enum.Font.GothamBold,
        BorderSizePixel=0
    }, Content)

    New("UICorner", {CornerRadius=UDim.new(1,0)}, btn)

    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = enabled and "ON" or "OFF"
        btn.BackgroundColor3 = enabled
            and Color3.fromRGB(175,48,55)
            or Color3.fromRGB(48,48,55)
    end)
end

local function Show(tab)
    Clear()
    Label(tab,5)

    if tab == "Main" then
        Label("Welcome back.",40)
        Toggle("Interface effects",85)
        Toggle("Notifications",125)
    elseif tab == "Steal" then
        Label("Steal options",40)
        Toggle("Auto Steal (demo)",85)
        Toggle("Auto Collect (demo)",125)
    elseif tab == "Visuals" then
        Label("Visual options",40)
        Toggle("Egg ESP (demo)",85)
        Toggle("Show labels",125)
    elseif tab == "Settings" then
        Label("Interface settings",40)
        Toggle("Low graphics",85)
    end
end

for i, tab in ipairs({"Main","Steal","Visuals","Settings"}) do
    local btn = New("TextButton", {
        Position=UDim2.fromOffset(7,7+(i-1)*43),
        Size=UDim2.new(1,-14,0,36),
        BackgroundColor3=Color3.fromRGB(30,30,37),
        Text=tab,
        TextColor3=Color3.fromRGB(210,210,215),
        TextSize=12,
        Font=Enum.Font.GothamMedium,
        BorderSizePixel=0
    }, Sidebar)

    New("UICorner", {CornerRadius=UDim.new(0,5)}, btn)

    btn.MouseButton1Click:Connect(function()
        Show(tab)
        for _, b in ipairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3=Color3.fromRGB(30,30,37)
            end
        end
        btn.BackgroundColor3=Color3.fromRGB(125,38,44)
    end)
end

-- Floating open/close button
local Floating = New("TextButton", {
    Size=UDim2.fromOffset(45,45),
    Position=UDim2.new(0,20,0.5,-22),
    BackgroundColor3=Color3.fromRGB(175,45,52),
    Text="E",
    TextColor3=Color3.new(1,1,1),
    TextSize=19,
    Font=Enum.Font.GothamBold,
    BorderSizePixel=0
}, Gui)

New("UICorner", {CornerRadius=UDim.new(1,0)}, Floating)

Floating.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Drag window
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,startPos.X.Offset+delta.X,
            startPos.Y.Scale,startPos.Y.Offset+delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

Show("Main")
