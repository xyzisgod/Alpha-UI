-- Section.lua
-- Section component for Alpha UI Library, used inside a Tab

local Alpha   = require(script.Parent.Parent.Core.Library)
local Theme  = Alpha.Theme
local Signal = Alpha.Signal

local Section = {}
Section.__index = Section

-- Creates a new Section under the given parent frame.
-- label: string shown as the section header.
function Section.new(label, parent)
    local self = setmetatable({}, Section)
    self.labelText = label or ""
    self.parent = parent
    self.visible = false
    self.OnVisibilityChanged = Signal.new()

    -- Container frame for the whole section
    self.frame = Instance.new("Frame")
    self.frame.Name = "SectionFrame"
    self.frame.Size = UDim2.new(1, 0, 0, 0) -- height will grow with content
    self.frame.BackgroundTransparency = 1
    self.frame.AutomaticSize = Enum.AutomaticSize.Y
    self.frame.LayoutOrder = 0
    self.frame.Parent = parent

    -- Header label with inline rule
    local header = Instance.new("TextLabel")
    header.Name = "Header"
    header.Text = "  " .. self.labelText .. "  "
    header.Font = Theme.tokens.font
    header.TextSize = Theme.tokens.fontSize
    header.TextColor3 = Theme.tokens.text
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, 0, 0, Theme.tokens.fontSize * 2)
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = self.frame

    -- Inline rule (a thin line extending the rest of the width)
    local rule = Instance.new("Frame")
    rule.Name = "Rule"
    rule.Size = UDim2.new(1, 0, 0, 1)
    rule.Position = UDim2.new(0, 0, 1, -1)
    rule.BackgroundColor3 = Theme.tokens.border
    rule.BorderSizePixel = 0
    rule.Parent = header

    -- Content holder where child components will be placed
    self.content = Instance.new("Frame")
    self.content.Name = "Content"
    self.content.Size = UDim2.new(1, 0, 0, 0)
    self.content.Position = UDim2.new(0, 0, 0, header.Size.Y.Offset)
    self.content.BackgroundTransparency = 1
    self.content.AutomaticSize = Enum.AutomaticSize.Y
    self.content.Parent = self.frame

    -- Layout for children inside content
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = self.content

    return self
end

function Section:Show()
    if self.visible then return end
    self.visible = true
    self.frame.Visible = true
    self.OnVisibilityChanged:Fire(true)
end

function Section:Hide()
    if not self.visible then return end
    self.visible = false
    self.frame.Visible = false
    self.OnVisibilityChanged:Fire(false)
end

return Section
