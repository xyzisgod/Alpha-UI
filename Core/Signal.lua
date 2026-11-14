-- Signal.lua
-- Simple event emitter used throughout Alpha UI Library

local Signal = {}
Signal.__index = Signal

function Signal.new()
    local self = setmetatable({}, Signal)
    self._connections = {}
    return self
end

function Signal:Connect(callback)
    if type(callback) ~= "function" then
        error("Signal:Connect expects a function")
    end
    table.insert(self._connections, callback)
    -- Return a simple disconnect handle
    local connection = {}
    local signal = self  -- capture reference to the Signal instance
    function connection:Disconnect()
        for i, fn in ipairs(signal._connections) do
            if fn == callback then
                table.remove(signal._connections, i)
                break
            end
        end
    end
    return connection
end

function Signal:Fire(...)
    for _, fn in ipairs(self._connections) do
        pcall(fn, ...)
    end
end

return Signal
