-- Alpha.lua
-- Top-level module that re-exports the library

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xyzisgod/Alpha-UI/main/Alpha/Core/Library.lua"))()

-- Return the Alpha library itself
return Library
