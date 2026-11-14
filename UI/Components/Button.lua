-- Button.lua
-- Simple button component

local Alpha   = loadstring(game:HttpGet("https://raw.githubusercontent.com/xyzisgod/Alpha-UI/main/Alpha/Core/Library.lua"))()
local Theme   = Alpha.Theme
local Signal  = Alpha.Signal

local Button = {}
Button.__index = Button

function Button.new(opts)
    opts = opts or {}
    local self = setmetatable({}, Button)
    self.label    = opts.label or "Button"
    self.callback = opts.callback or function() end
    self.OnClicked = Signal.new()
    return self
end

function Button:Create(parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, Theme.tokens.fontSize * 2)
    btn.BackgroundColor3 = Theme.tokens.btnFill
    btn.BorderColor3 = Theme.tokens.border
    btn.BorderSizePixel = 1
    btn.Text = self.label
    btn.Font = Theme.tokens.font
    btn.TextSize = Theme.tokens.fontSize
    btn.TextColor3 = Theme.tokens.text
    btn.BackgroundTransparency = 0
    btn.AutoButtonColor = false
    btn.Parent = parent

    btn.MouseButton1Click:Connect(function()
        self.callback()
        self.OnClicked:Fire()
    end)

    self._ui = {button = btn}
    return btn
end

function Button:SetLabel(text)
    if self._ui then
        self._ui.button.Text = text or ""
    end
    self.label = text
end

return Button
