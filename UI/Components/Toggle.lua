-- Toggle.lua
-- Simple toggle (checkbox) component

local Alpha   = require(script.Parent.Parent.Core.Library)
local Theme   = Alpha.Theme
local Signal  = Alpha.Signal
local Util    = Alpha.Util

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(opts)
    opts = opts or {}
    local self = setmetatable({}, Toggle)
    self.label   = opts.label or ""
    self.default = opts.default or false
    self.flag    = opts.flag or nil
    self.callback = opts.callback or function() end
    self.state   = self.default
    self.OnChanged = Signal.new()
    return self
end

function Toggle:Create(parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, Theme.tokens.fontSize * 2)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local checkbox = Instance.new("TextButton")
    checkbox.Size = UDim2.new(0, 20, 0, 20)
    checkbox.Position = UDim2.fromOffset(0, (Theme.tokens.fontSize * 2 - 20) / 2)
    checkbox.BackgroundColor3 = Theme.tokens.border
    checkbox.Text = self.state and "✔" or ""
    checkbox.Font = Theme.tokens.font
    checkbox.TextSize = Theme.tokens.fontSize
    checkbox.TextColor3 = Theme.tokens.text
    checkbox.BackgroundTransparency = 0
    checkbox.Parent = frame

    local label = Instance.new("TextLabel")
    label.Text = self.label
    label.Font = Theme.tokens.font
    label.TextSize = Theme.tokens.fontSize
    label.TextColor3 = Theme.tokens.text
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(30, 0)
    label.Size = UDim2.new(1, -30, 1, 0)
    label.Parent = frame

    checkbox.MouseButton1Click:Connect(function()
        self.state = not self.state
        checkbox.Text = self.state and "✔" or ""
        self.callback(self.state)
        self.OnChanged:Fire(self.state)
    end)

    self._ui = {frame = frame, checkbox = checkbox, label = label}
    return frame
end

function Toggle:Set(state)
    if type(state) ~= "boolean" then return end
    self.state = state
    if self._ui then
        self._ui.checkbox.Text = state and "✔" or ""
    end
    self.callback(state)
    self.OnChanged:Fire(state)
end

return Toggle
