-- Util.lua
-- Utility functions for the Alpha UI Library

local Util = {}
Util.__index = Util

-- Clamp a number between min and max
function Util.clamp(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
end

-- Linear interpolation between a and b by t (0‑1)
function Util.lerp(a, b, t)
    return a + (b - a) * Util.clamp(t, 0, 1)
end

-- Deep copy of a table
function Util.deepcopy(orig)
    local copy
    if type(orig) == "table" then
        copy = {}
        for k, v in next, orig, nil do
            copy[Util.deepcopy(k)] = Util.deepcopy(v)
        end
        setmetatable(copy, Util.deepcopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

-- Detect if running on a mobile device (Roblox)
function Util.isMobile()
    local UserInputService = game:GetService("UserInputService")
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

return Util
