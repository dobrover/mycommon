local string_module = {}

-- Interpolate, see tests. 
function string_module.interpolate(s, tbl)
    tbl = tbl or {}
    local has_number_keys, has_non_number_keys = false, false
    for k, v in pairs(tbl) do
        if type(k) == 'number' then
            has_number_keys = true
        else
            has_non_number_keys = true
        end
        if has_number_keys and has_non_number_keys then
            error("Can't mix integer keys with non-integer in string interpolation!")
        end
    end
    if not has_non_number_keys then
        return s:format(unpack(tbl))
    else
        -- TODO: Refactor?
        -- TODO: Rewrite as DFA?
        -- The idea here is the following.
        -- We use & symbol as escape sequence begin.
        -- If we see '%%' in string, we should replace it with
        -- something that doesn't end with %% and that will be converted
        -- later back.
        -- So, we replace '%%' with '&%%2'. Note that we should also do this to strings by which
        -- %(name)s is replaced.
        -- After we have done all replacements, we just replace back '&%%2' -> '%%' and '&&' to '&'.
        local function escape(str)
            return str:gsub('&', '&&'):gsub('%%%%', '&%%2')
        end
        local function unescape(str)
            return str:gsub('%&%%2', '%%'):gsub('&&', '&')
        end
        s = escape(s)
        s = (s:gsub('%%%((%a%w*)%)([-0-9%.]*[cdeEfgGiouxXsq])',
            function(k, fmt) 
                local string_fmt = fmt:len() and fmt or 's'
                local result = tbl[k] and ("%"..string_fmt ):format(tbl[k]) or '%('..k..')'..fmt 
                return escape(result)
            end)
        )
        return unescape(s)
    end
end

return string_module