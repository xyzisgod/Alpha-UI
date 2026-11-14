-- Theme.lua
-- Default theme tokens for Alpha UI Library
local Theme = {}

-- Default color tokens (Roblox Color3 values)
Theme.tokens = {
    bg       = Color3.fromRGB(13, 13, 13),   -- #0d0d0d
    panel    = Color3.fromRGB(17, 17, 17),   -- #111111
    accent   = Color3.fromRGB(139, 111, 212),-- #8b6fd4
    text     = Color3.fromRGB(200, 200, 200),-- #c8c8c8
    textDim  = Color3.fromRGB(90, 90, 90),   -- #5a5a5a
    border   = Color3.fromRGB(22, 22, 22),   -- #161616
    input    = Color3.fromRGB(26, 26, 26),   -- #1a1a1a (fill)
    btnFill  = Color3.fromRGB(30, 30, 30),   -- #1e1e1e
    font     = Enum.Font.SourceSansMono,
    fontSize = 14,
    mobile   = false,
}

-- Allows overriding any token at runtime. Merges with existing tokens.
function Theme:apply(overrides)
    if type(overrides) ~= "table" then return end
    for k, v in pairs(overrides) do
        self.tokens[k] = v
    end
end

return Theme

