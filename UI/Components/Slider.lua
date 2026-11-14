-- Slider.lua
-- Simple slider component

local Alpha   = require(script.Parent.Parent.Core.Library)
local Theme   = Alpha.Theme
local Signal  = Alpha.Signal
local Util    = Alpha.Util

local Slider = {}
Slider.__index = Slider

function Slider.new(opts)
    opts = opts or {}
    local self = setmetatable({}, Slider)
    self.label    = opts.label or ""
    self.min      = opts.min or 0
    self.max      = opts.max or 100
    self.step     = opts.step or 1
    self.default  = opts.default or self.min
    self.flag     = opts.flag or nil
    self.callback = opts.callback or function() end
    self.value    = self.default
    self.OnChanged = Signal.new()
    return self
end

function Slider:Create(parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, Theme.tokens.fontSize * 3)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = self.label
    label.Font = Theme.tokens.font
    label.TextSize = Theme.tokens.fontSize
    label.TextColor3 = Theme.tokens.text
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0, 100, 0, Theme.tokens.fontSize * 2)
    label.Position = UDim2.fromOffset(0, 0)
    label.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -110, 0, 8)
    bar.Position = UDim2.fromOffset(110, Theme.tokens.fontSize)
    bar.BackgroundColor3 = Theme.tokens.border
    bar.BorderSizePixel = 0
    bar.Parent = frame

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.fromScale(0, -4)
    knob.BackgroundColor3 = Theme.tokens.accent
    knob.Text = ""
    knob.AutoButtonColor = false
    knob.Parent = bar

    local function updateKnob()
        local ratio = (self.value - self.min) / (self.max - self.min)
        knob.Position = UDim2.fromScale(ratio, -0.25)
    end

    updateKnob()

    local dragging = false
    local UserInputService = game:GetService("UserInputService")
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relX = input.Position.X - bar.AbsolutePosition.X
            local clamped = Util.clamp(relX / bar.AbsoluteSize.X, 0, 1)
            local raw = self.min + clamped * (self.max - self.min)
            -- snap to step
            local stepped = math.floor((raw - self.min) / self.step + 0.5) * self.step + self.min
            self.value = Util.clamp(stepped, self.min, self.max)
            updateKnob()
            self.callback(self.value)
            self.OnChanged:Fire(self.value)
        end
    end)

    self._ui = {frame = frame, knob = knob, bar = bar, label = label}
    return frame
end

function Slider:Set(value)
    if type(value) ~= "number" then return end
    self.value = Util.clamp(value, self.min, self.max)
    if self._ui then
        local ratio = (self.value - self.min) / (self.max - self.min)
        self._ui.knob.Position = UDim2.fromScale(ratio, -0.25)
    end
    self.callback(self.value)
    self.OnChanged:Fire(self.value)
end

return Slider
