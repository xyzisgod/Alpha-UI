-- Window.lua
-- Root window for Alpha UI Library

local Alpha   = require(script.Parent.Parent.Core.Library)
local Theme  = Alpha.Theme
local Signal = Alpha.Signal

local Window = {}
Window.__index = Window

-- Helper to create UI elements with common properties
local function createInstance(className, props)
    local obj = Instance.new(className)
    if props then
        for k, v in pairs(props) do
            obj[k] = v
        end
    end
    return obj
end

function Window.new(opts)
    opts = opts or {}
    local self = setmetatable({}, Window)

    -- ScreenGui container
    self.gui = createInstance("ScreenGui", {ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    self.gui.Name = "AlphaWindowGui"
    self.gui.Parent = opts.parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Main frame
    local size = opts.size or {500, 400}
    self.frame = createInstance("Frame", {
        Name = "WindowFrame",
        Size = UDim2.fromOffset(size[1], size[2]),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.tokens.bg,
        BorderSizePixel = 0,
    })
    self.frame.Parent = self.gui

    -- Title bar
    self.titleBar = createInstance("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Theme.tokens.panel,
        BorderSizePixel = 0,
    })
    self.titleBar.Parent = self.frame

    local titleLabel = createInstance("TextLabel", {
        Name = "TitleLabel",
        Text = opts.title or "Alpha Window",
        Font = Theme.tokens.font,
        TextSize = Theme.tokens.fontSize,
        TextColor3 = Theme.tokens.text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    })
    titleLabel.Parent = self.titleBar

    -- Bottom accent border (1px)
    local bottomBorder = createInstance("Frame", {
        Name = "BottomBorder",
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Theme.tokens.accent,
        BorderSizePixel = 0,
    })
    bottomBorder.Parent = self.titleBar

    -- Dragging support
    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragStart, startPos
    self.titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    self.titleBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            self.frame.Position = newPos
        end
    end)

    -- Tab container (holds TabBar and content area)
    self.contentArea = createInstance("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, 0, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundTransparency = 1,
    })
    self.contentArea.Parent = self.frame

    self.tabBar = require(script.Parent.TabBar).new(self.contentArea)
    self.tabs = {}
    self.activeTab = nil

    -- Signal for when a tab changes
    self.OnTabChanged = Signal.new()

    return self
end

-- Add a new tab with the given name; returns the Tab object
function Window:Tab(name)
    local TabClass = require(script.Parent.Tab)
    local tab = TabClass.new(name, self.contentArea)
    table.insert(self.tabs, tab)
    self.tabBar:AddTab(name, function()
        self:SelectTab(tab)
    end)
    if not self.activeTab then
        self:SelectTab(tab)
    end
    return tab
end

function Window:SelectTab(tab)
    if self.activeTab == tab then return end
    if self.activeTab then
        self.activeTab:Hide()
    end
    self.activeTab = tab
    tab:Show()
    self.tabBar:SetActive(tab.name)
    self.OnTabChanged:Fire(tab.name)
end

function Window:Destroy()
    if self.gui then self.gui:Destroy() end
end

return Window
