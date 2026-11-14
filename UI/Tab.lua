-- Tab.lua
-- Represents a single tab and its sections within a Window

local Alpha   = require(script.Parent.Parent.Core.Library)
local Theme  = Alpha.Theme
local Signal = Alpha.Signal
local Util   = Alpha.Util

local Tab = {}
Tab.__index = Tab

function Tab.new(name, parent)
    local self = setmetatable({}, Tab)
    self.name = name
    self.parent = parent -- container frame for the tab's content area
    self.sections = {}
    self.visible = false
    self.OnSectionAdded = Signal.new()
    return self
end

-- Add a new Section to this tab; returns the Section object
function Tab:Section(label)
    local Section = require(script.Parent.Section)
    local sec = Section.new(label, self.parent)
    table.insert(self.sections, sec)
    self.OnSectionAdded:Fire(sec)
    return sec
end

function Tab:Show()
    if self.visible then return end
    self.visible = true
    for _, sec in ipairs(self.sections) do
        sec:Show()
    end
end

function Tab:Hide()
    if not self.visible then return end
    self.visible = false
    for _, sec in ipairs(self.sections) do
        sec:Hide()
    end
end

return Tab
