local players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local lp = players.LocalPlayer

local pg = lp:WaitForChild("PlayerGui")
local gui = Instance.new("ScreenGui")
gui.Name = "RemoteAdminPanel"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = pg

local outer = Instance.new("Frame")
outer.Size = UDim2.new(0, 260, 0, 360)
outer.Position = UDim2.new(0, 20, 0.2, 0)
outer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
outer.Active = true
outer.ZIndex = 998
outer.Parent = gui
Instance.new("UICorner", outer).CornerRadius = UDim.new(0, 10)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(60, 30, 120)
titleBar.Active = true
titleBar.ZIndex = 999
titleBar.Parent = outer
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "REMOTE ADMIN"
title.ZIndex = 999
title.Parent = titleBar

local dragging, dragStart, startPos = false, nil, nil
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = outer.Position
    end
end)
titleBar.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local d = input.Position - dragStart
        outer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local argBox = Instance.new("TextBox")
argBox.Size = UDim2.new(1, -20, 0, 34)
argBox.Position = UDim2.new(0, 10, 0, 36)
argBox.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
argBox.TextColor3 = Color3.new(1, 1, 1)
argBox.PlaceholderText = "arg (ör. egg adı)"
argBox.Font = Enum.Font.Gotham
argBox.TextSize = 13
argBox.ClearTextOnFocus = false
argBox.ZIndex = 999
argBox.Parent = outer
Instance.new("UICorner", argBox).CornerRadius = UDim.new(0, 6)

local scroller = Instance.new("ScrollingFrame")
scroller.Size = UDim2.new(1, -20, 1, -120)
scroller.Position = UDim2.new(0, 10, 0, 76)
scroller.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
scroller.BorderSizePixel = 0
scroller.ScrollBarThickness = 4
scroller.CanvasSize = UDim2.new(0, 0, 0, 0)
scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroller.ZIndex = 999
scroller.Parent = outer
Instance.new("UICorner", scroller).CornerRadius = UDim.new(0, 6)

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 3)
list.Parent = scroller

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 1, -34)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.TextWrapped = true
statusLabel.Text = ""
statusLabel.ZIndex = 999
statusLabel.Parent = outer

local keywords = { "egg", "spawn", "admin", "give", "pet", "brainrot", "buy", "purchase", "rebirth" }

local function matches(name)
    local n = name:lower()
    for _, k in ipairs(keywords) do
        if n:find(k) then return true end
    end
    return false
end

local function fire_remote(obj, argText)
    local arg = argText ~= "" and argText or nil
    local ok, err = pcall(function()
        if obj:IsA("RemoteEvent") then
            if arg then obj:FireServer(arg) else obj:FireServer() end
        elseif obj:IsA("RemoteFunction") then
            if arg then obj:InvokeServer(arg) else obj:InvokeServer() end
        end
    end)
    statusLabel.Text = obj.Name .. ": " .. (ok and "gönderildi" or ("hata: " .. tostring(err)))
end

local function build_list()
    for _, c in ipairs(scroller:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local found = {}
    local function scan(root)
        for _, d in ipairs(root:GetDescendants()) do
            if (d:IsA("RemoteEvent") or d:IsA("RemoteFunction")) and matches(d.Name) then
                table.insert(found, d)
            end
        end
    end
    scan(rs)
    pcall(function() scan(workspace) end)

    for i, obj in ipairs(found) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -8, 0, 28)
        b.LayoutOrder = i
        b.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.Gotham
        b.TextSize = 12
        b.Text = (obj:IsA("RemoteFunction") and "[F] " or "[E] ") .. obj.Name
        b.Active = true
        b.ZIndex = 999
        b.Parent = scroller
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
        b.Activated:Connect(function()
            fire_remote(obj, argBox.Text)
        end)
    end
    statusLabel.Text = #found .. " remote bulundu"
end

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(1, -20, 0, 26)
refreshBtn.Position = UDim2.new(0, 10, 1, -66)
refreshBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 120)
refreshBtn.TextColor3 = Color3.new(1, 1, 1)
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 13
refreshBtn.Text = "YENİDEN TARA"
refreshBtn.Active = true
refreshBtn.ZIndex = 999
refreshBtn.Parent = outer
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 6)
refreshBtn.Activated:Connect(build_list)

build_list()
