local time = {}

-- Try getting time in milliseconds
local succeed, socket = pcall(require, "socket")
local get_time = nil
if succeed and socket ~= nil then
    get_time = function ()
        return socket.gettime()
    end
else
    get_time = function()
        return os.time()
    end
end

time.time = get_time

return time