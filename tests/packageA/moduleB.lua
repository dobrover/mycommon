local moduleB = {}

local module_name = ...

moduleB.bar = function() return module_name .. '.bar' end

return moduleB