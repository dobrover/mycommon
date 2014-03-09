local packageA = {}

local common = require 'common'

local package_name = ...

packageA.foo = function() return package_name .. '.foo' end

return common.package(packageA, ...)