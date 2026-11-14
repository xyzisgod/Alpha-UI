-- Config.lua
-- Simple JSON config loader/saver for Alpha UI Library

local Config = {}
Config.__index = Config

local HttpService = game:GetService("HttpService")

-- Path to the config file. Using writefile/readfile APIs (available in Roblox Studio environment).
local CONFIG_PATH = "Alpha/config.json"

function Config:load()
    local success, data = pcall(readfile, CONFIG_PATH)
    if success then
        local ok, parsed = pcall(HttpService.JSONDecode, data)
        if ok then
            return parsed
        end
    end
    return {} -- return empty table if missing or malformed
end

function Config:save(tbl)
    local ok, json = pcall(HttpService.JSONEncode, tbl)
    if not ok then return false, "Failed to encode JSON" end
    local success, err = pcall(writefile, CONFIG_PATH, json)
    if not success then
        return false, err
    end
    return true
end

return Config
