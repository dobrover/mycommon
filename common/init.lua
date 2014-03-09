local function package(package_name)
    local M = {__name = package_name}
    local mt = {
        __index = function (t, k) 
            local status, maybe_module = pcall(require, package_name .. '.'  .. k)
            if status then 
                t[k] = maybe_module
                return maybe_module
            end
        end
    }
    setmetatable(M, mt)
    return M
end

local utils = package(...)

utils.package = package

return utils