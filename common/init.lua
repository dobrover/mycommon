local common = {}
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
-- @param tbl Module to be converted into package.
-- @param package_name Package name, all modules will be imported relative to this name.
function common.package(tbl, package_name)
    local meta = {
        __index = function (t, k) 
            local status, maybe_module = pcall(require, package_name .. '.'  .. k)
            if status then 
                t[k] = maybe_module
                return maybe_module
            end
        end
    }
    return setmetatable(tbl, meta)
end

return common.package(common, ...)
