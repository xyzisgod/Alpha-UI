-- TabBar.lua
-- Horizontal tab bar with active underline

local Alpha   = require(script.Parent.Parent.Core.Library)
local Theme  = Alpha.Theme
local Signal = Alpha.Signal

local TabBar = {}
TabBar.__index = TabBar

-- Helper to create UI objects
local function create(className, props)
    local obj = Instance.new(className)
    if props then
        for k, v in pairs(props) do
            obj[k] = v
        end
    end
    return obj
end

function TabBar.new(parent)
    local self = setmetatable({}, TabBar)
    self.parent = parent
    self.tabs = {}
    self.active = nil
    self.OnTabClicked = Signal.new()

    -- Bar container
    self.frame = create("Frame", {
        Name = "TabBar",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Theme.tokens.panel,
        BorderSizePixel = 0,
    })
    self.frame.Parent = parent

    -- Layout for tab buttons
    local layout = create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
    })
    layout.Parent = self.frame

    -- Underline indicator (1px height)
    self.underline = create("Frame", {
        Name = "Underline",
        Size = UDim2.new(0, 0, 0, 2),
        BackgroundColor3 = Theme.tokens.accent,
        BorderSizePixel = 0,
    })
    self.underline.Parent = self.frame

    return self
end

-- Add a tab button; callback fires when tab is selected
function TabBar:AddTab(name, callback)
    local btn = create("TextButton", {
        Name = "TabButton_" .. name,
        Text = name,
        Font = Theme.tokens.font,
        TextSize = Theme.tokens.fontSize,
        TextColor3 = Theme.tokens.text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 100, 1, 0),
        AutoButtonColor = false,
    })
    btn.Parent = self.frame
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
        self:SetActive(name)
        self.OnTabClicked:Fire(name)
    end)
    self.tabs[name] = btn
    -- If first tab, make it active automatically
    if not self.active then
        self:SetActive(name)
    end
end

function TabBar:SetActive(name)
    if not self.tabs[name] then return end
    self.active = name
    -- Update underline position/size to match active button
    local btn = self.tabs[name]
    self.underline.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, 2)
    self.underline.Position = UDim2.new(0, btn.AbsolutePosition.X - self.frame.AbsolutePosition.X, 1, -2)
    -- Update button colors
    for n, b in pairs(self.tabs) do
        b.TextColor3 = (n == name) and Theme.tokens.accent or Theme.tokens.textDim
    end
end

return TabBar
