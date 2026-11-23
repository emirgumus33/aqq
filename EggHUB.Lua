
-- EGG HUB V2 | UI
-- Interface prototype

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

local GUI_PARENT = (gethui and gethui())
    or game:GetService("CoreGui")

local old = GUI_PARENT:FindFirstChild("EggHubV2")
if old then old:Destroy() end

local GUI = Instance.new("ScreenGui")
GUI.Name = "EggHubV2"
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.Parent = GUI_PARENT

local C = {
    Red = Color3.fromRGB(220, 38, 45),
    Red2 = Color3.fromRGB(255, 75, 78),
    Dark = Color3.fromRGB(24, 24, 24),
    Panel = Color3.fromRGB(42, 42, 39),
    Panel2 = Color3.fromRGB(55, 55, 50),
    White = Color3.fromRGB(245,245,245),
    Gray = Color3.fromRGB(165,165,165),
    Green = Color3.fromRGB(45,220,50),
    Black = Color3.fromRGB(5,5,5)
}

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function corner(obj, radius)
    make("UICorner", {
        CornerRadius = UDim.new(0,radius)
    }, obj)
end

local function stroke(obj, color, thickness)
    make("UIStroke", {
        Color = color or C.Black,
        Thickness = thickness or 2
    }, obj)
end

local function label(parent, text, size, pos, font)
    return make("TextLabel", {
        Size = size,
        Position = pos,
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = C.White,
        TextSize = 14,
        Font = font or Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, parent)
end

-- MAIN WINDOW

local Main = make("Frame", {
    Size = UDim2.fromOffset(720, 490),
    Position = UDim2.new(0.5,-360,0.5,-245),
    BackgroundColor3 = C.Panel,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, GUI)

stroke(Main,C.Black,3)

-- HEADER

local Header = make("Frame", {
    Size = UDim2.new(1,0,0,52),
    BackgroundColor3 = C.Red,
    BorderSizePixel = 0
}, Main)

local HeaderGradient = make("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,C.Red2),
        ColorSequenceKeypoint.new(1,C.Red)
    })
}, Header)

label(Header,"Egg Hub",UDim2.fromOffset(250,45),
    UDim2.fromOffset(18,3))

label(Header,"V2.0",UDim2.fromOffset(50,40),
    UDim2.fromOffset(125,6),
    Enum.Font.Gotham)

local Min = make("TextButton", {
    Size=UDim2.fromOffset(38,36),
    Position=UDim2.new(1,-83,0,8),
    BackgroundColor3=Color3.fromRGB(160,25,30),
    Text="−",
    TextSize=25,
    TextColor3=C.White,
    Font=Enum.Font.GothamBold
},Header)
corner(Min,4)
stroke(Min,C.Black,2)

local Close = make("TextButton", {
    Size=UDim2.fromOffset(38,36),
    Position=UDim2.new(1,-42,0,8),
    BackgroundColor3=Color3.fromRGB(160,25,30),
    Text="X",
    TextSize=19,
    TextColor3=C.White,
    Font=Enum.Font.GothamBold
},Header)
corner(Close,4)
stroke(Close,C.Black,2)

Close.MouseButton1Click:Connect(function()
    GUI:Destroy()
end)

-- SIDEBARS

local Left = make("Frame", {
    Position=UDim2.fromOffset(9,63),
    Size=UDim2.fromOffset(145,370),
    BackgroundTransparency=1
},Main)

local Right = make("Frame", {
    Position=UDim2.new(1,-154,0,63),
    Size=UDim2.fromOffset(145,370),
    BackgroundTransparency=1
},Main)

local Center = make("Frame", {
    Position=UDim2.fromOffset(164,63),
    Size=UDim2.fromOffset(402,370),
    BackgroundColor3=C.Panel,
    BorderSizePixel=0
},Main)

stroke(Center,C.Black,2)

-- CONTENT SCROLL

local Scroll = make("ScrollingFrame", {
    Position=UDim2.fromOffset(5,5),
    Size=UDim2.new(1,-10,1,-10),
    BackgroundTransparency=1,
    BorderSizePixel=0,
    ScrollBarThickness=4,
    ScrollBarImageColor3=C.Red,
    CanvasSize=UDim2.new(0,0,0,0)
},Center)

local Layout = make("UIListLayout", {
    Padding=UDim.new(0,5),
    SortOrder=Enum.SortOrder.LayoutOrder
},Scroll)

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.fromOffset(
        0,Layout.AbsoluteContentSize.Y+10
    )
end)

local function clear()
    for _,v in ipairs(Scroll:GetChildren()) do
        if v:IsA("GuiObject") and v ~= Layout then
            v:Destroy()
        end
    end
end

-- OPTION ROW

local function row(text)
    local Frame = make("Frame", {
        Size=UDim2.new(1,-8,0,44),
        BackgroundColor3=C.Panel2,
        BorderSizePixel=0
    },Scroll)

    stroke(Frame,C.Black,2)

    label(Frame,text,UDim2.new(1,-145,1,0),
        UDim2.fromOffset(12,0))

    return Frame
end

-- TOGGLE

local function toggle(text)
    local Frame = row(text)

    local enabled = false

    local Button = make("TextButton", {
        Size=UDim2.fromOffset(65,30),
        Position=UDim2.new(1,-74,0,7),
        BackgroundColor3=Color3.fromRGB(55,55,55),
        Text="OFF",
        TextColor3=C.White,
        TextSize=11,
        Font=Enum.Font.GothamBold
    },Frame)

    corner(Button,3)
    stroke(Button,C.Black,2)

    Button.MouseButton1Click:Connect(function()
        enabled = not enabled

        Button.Text = enabled and "ON" or "OFF"
        Button.BackgroundColor3 = enabled
            and C.Green
            or Color3.fromRGB(55,55,55)
    end)
end

-- DROPDOWN

local function dropdown(text,options)
    local Frame = row(text)

    local selected = 1

    local Button = make("TextButton", {
        Size=UDim2.fromOffset(130,30),
        Position=UDim2.new(1,-139,0,7),
        BackgroundColor3=Color3.fromRGB(28,28,28),
        Text=options[selected].."  v",
        TextColor3=C.White,
        TextSize=11,
        Font=Enum.Font.GothamBold
    },Frame)

    corner(Button,3)
    stroke(Button,C.Black,2)

    Button.MouseButton1Click:Connect(function()
        selected = selected % #options + 1
        Button.Text = options[selected].."  v"
    end)
end

-- SEARCH

local Search = make("Frame", {
    Position=UDim2.fromOffset(9,441),
    Size=UDim2.fromOffset(702,38),
    BackgroundColor3=C.Panel2
},Main)

stroke(Search,C.Black,2)

label(Search,"Search",UDim2.fromOffset(70,35),
    UDim2.fromOffset(10,0))

local SearchBox = make("TextBox", {
    Position=UDim2.fromOffset(85,5),
    Size=UDim2.new(1,-95,0,28),
    BackgroundColor3=Color3.fromRGB(25,25,25),
    Text="",
    PlaceholderText="Filter features...",
    PlaceholderColor3=C.Gray,
    TextColor3=C.White,
    TextSize=12,
    Font=Enum.Font.Gotham,
    ClearTextOnFocus=false
},Search)

stroke(SearchBox,C.Black,1)

-- TAB CONTENT

local function showTab(tab)
    clear()

    if tab == "Farm" then
        toggle("Auto Steal (UI demo)")
        dropdown("Move To Egg",{"Teleport","Walk","Tween"})
        dropdown("Delivery",{"Fast Tween","Teleport","Normal"})
        dropdown("Steal Priority",{"Highest Value","Closest","Random"})
        dropdown("Min Rarity",{"Common","Rare","Epic","Secret"})
        toggle("Auto Collect (UI demo)")
        toggle("Auto Sell (UI demo)")

    elseif tab == "Event" then
        toggle("Event Notifications")
        dropdown("Event Filter",{"All","Rare","Limited"})
        toggle("Show Event Timer")

    elseif tab == "Player" then
        toggle("Speed Display")
        toggle("Jump Display")
        dropdown("Movement Preset",{"Normal","Fast","Custom"})

    elseif tab == "Predictor" then
        toggle("Prediction Display")
        dropdown("Prediction Mode",{"Normal","Advanced"})

    elseif tab == "Server" then
        toggle("Server Information")
        dropdown("Server Region",{"All","Nearby","Low Ping"})

    elseif tab == "Misc" then
        toggle("Show Notifications")
        toggle("Compact Interface")
        toggle("Interface Animations")

    elseif tab == "Auto Hop" then
        toggle("Auto Hop Display")
        dropdown("Hop Mode",{"Random","Low Player","New Server"})

    elseif tab == "Settings" then
        toggle("Show Floating Button")
        toggle("UI Animations")
        toggle("Remember Selected Tab")

    elseif tab == "Config" then
        toggle("Save Interface Preferences")
        toggle("Load Interface Preferences")

    elseif tab == "Quick & Keys" then
        label(Scroll,"Keyboard shortcuts",UDim2.new(1,-10,0,35),
            UDim2.fromOffset(10,0))
        label(Scroll,"RightShift - Toggle UI",
            UDim2.new(1,-10,0,35),UDim2.fromOffset(10,0),
            Enum.Font.Gotham)

    elseif tab == "Discord" or tab == "Venyx"
        or tab == "Admin Abuse" then
        label(Scroll,tab.." - UI section",
            UDim2.new(1,-10,0,40),UDim2.fromOffset(10,0))
    end
end

-- CATEGORY BUTTONS

local function category(parent,text,index)
    local Button = make("TextButton", {
        Position=UDim2.fromOffset(0,(index-1)*47),
        Size=UDim2.fromOffset(145,42),
        BackgroundColor3=C.Red,
        Text=text,
        TextColor3=C.White,
        TextSize=17,
        Font=Enum.Font.GothamBold,
        BorderSizePixel=0
    },parent)

    local gradient = make("UIGradient",{
        Color=ColorSequence.new(
            Color3.fromRGB(255,90,90),
            Color3.fromRGB(190,20,30)
        ),
        Rotation=90
    },Button)

    stroke(Button,C.Black,3)
    corner(Button,3)

    Button.MouseButton1Click:Connect(function()
        showTab(text)
    end)
end

local leftTabs = {
    "Farm","Event","Player","Predictor",
    "Server","Misc","Auto Hop"
}

local rightTabs = {
    "Admin Abuse","Discord","Venyx",
    "Quick & Keys","Settings","Config"
}

for i,v in ipairs(leftTabs) do
    category(Left,v,i)
end

for i,v in ipairs(rightTabs) do
    category(Right,v,i)
end

-- SEARCH FILTER

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = SearchBox.Text:lower()

    for _,v in ipairs(Scroll:GetChildren()) do
        if v:IsA("Frame") then
            local txt = v:FindFirstChildWhichIsA("TextLabel")
            v.Visible = query == ""
                or (txt and txt.Text:lower():find(query,1,true) ~= nil)
        end
    end
end)

-- DRAG

local dragging = false
local dragStart, startPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset+delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset+delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- MINIMIZE

local minimized = false

Min.MouseButton1Click:Connect(function()
    minimized = not minimized

    Center.Visible = not minimized
    Left.Visible = not minimized
    Right.Visible = not minimized

    Search.Visible = not minimized

    Main.Size = minimized
        and UDim2.fromOffset(720,52)
        or UDim2.fromOffset(720,490)
end)

-- FLOATING BUTTON

local Floating = make("TextButton", {
    Size=UDim2.fromOffset(48,48),
    Position=UDim2.new(0,20,0.5,0),
    BackgroundColor3=C.Red,
    Text="E",
    TextColor3=C.White,
    TextSize=22,
    Font=Enum.Font.GothamBold
},GUI)

corner(Floating,5)
stroke(Floating,C.Black,3)

Floating.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- RIGHT SHIFT TOGGLE

UIS.InputBegan:Connect(function(input,processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

showTab("Farm")

print("[Egg Hub] Interface loaded")
