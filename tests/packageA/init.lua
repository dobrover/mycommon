local common = require 'common'

local packageA = common.package(...)

local package_name = ...

packageA.foo = function() return package_name .. '.foo' end

return packageA