-- Library.lua
-- Entry point for the Alpha UI Library

local Alpha = {}

-- Load core modules
local Theme   = require(script.Parent.Theme)
local Config  = require(script.Parent.Config)
local Signal  = require(script.Parent.Signal)
local Util    = require(script.Parent.Util)

-- Expose core utilities
Alpha.Theme   = Theme
Alpha.Config  = Config
Alpha.Signal  = Signal
Alpha.Util    = Util

-- Create a new Window instance
function Alpha:Window(opts)
    local Window = require(script.Parent.Parent.UI.Window)
    return Window.new(opts)
end

return Alpha
