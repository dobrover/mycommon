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

-- Just a handy functin for printing tables
function table_module.tostring(tbl)
    return '{' .. table.concat(tbl, ', ') .. '}'
end

-- Update tbl contents with tables in ...
function table_module.update(tbl, ...)
    for i = 1, select('#', ...) do
        for k, v in pairs(select(i, ...)) do
            tbl[k] = v
        end
    end
    return tbl
end

-- Used by vararg_to_table to denote keyword arguments
local kw_meta = {}

function table_module.kw(tbl)
    return setmetatable({value=tbl}, kw_meta)
end

function table_module.is_kw(tbl)
    return getmetatable(tbl) == kw_meta
end

-- Used to make vararg_to_table idempotent
local unpacked_vararg_meta = {}

function table_module.unpacked_vararg(tbl)
    return setmetatable(tbl, unpacked_vararg_meta)
end

function table_module.is_unpacked_vararg(tbl)
    return getmetatable(tbl) == unpacked_vararg_meta
end

-- Similar to table.unpack but with support of keyword arguments
-- f(41, nil, 43, {value=42}, kw{a=1, b=2}, kw{c=3}) ->
--      {[1] = 41, [2] = nil, [3] = 43, [4] = {value=42}, kw={a=1, b=2, c=3}}
-- f(f(...)) == f(...) so this function can be applied to the same result
-- multiple times
-- However, f(f(...), f(...)) will turn into a sequence with two elements.
function table_module.vararg_to_table(...)
    local result = {kw={}}
    local length = select('#', ...)
    if length == 0 then
        -- pass
    elseif length == 1 and table_module.is_unpacked_vararg(select(1, ...)) then
        result = select(1, ...)
    else
        for i = 1, length do
            local obj = select(i, ...)
            if table_module.is_kw(obj) then
                -- Merge keywords into result.kw
                table_module.update(result.kw, obj.value)
            else
                -- Other arguments are just elements of array
                local insert_index = (result.n or 0) + 1
                result[insert_index] = obj
                result.n = insert_index
            end
        end
    end
    return table_module.unpacked_vararg(result)
end

return table_module