local table_module = {}

-- Returns first position of value in tbl or nil.
function table_module.index(tbl, value)
    for i, v in ipairs(tbl) do
        if value == v then
            return i
        end
    end
    return nil
end

function table_module.tostring(tbl)
    return '{' .. table.concat(tbl, ', ') .. '}'
end

return table_module