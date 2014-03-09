-- Utility for lazy loading modules from packages
-- Suppose folder A has files init.lua and B.lua
-- Then if in init.lua we do 
--
--   local common = require 'common'
--   local A = common.package(...)
--   -- Populate here A with some vales
--   return A
--   
-- Then we will be able to do:
--
--   local A = require('A')
--   -- At this moment A.B is not loaded
--   local B = A.B -- equivalent to local B = require('A.B')
--   

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

local common = package(...)

common.package = package

return common