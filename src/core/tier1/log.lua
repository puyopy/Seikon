-- log.lua
-- Purpose: Prettifies logs.
-- 2022/01/28

local log = {}

local function _print(prefix,call,...)

    if call == error then
        -- hide the unnecessary error trace
        error("["..prefix.."]".. ... .. "\n" .. debug.traceback(),0)
        
    else
        call("["..prefix.."]",...)
    end
end

function log:info(...)
    _print("INFO",print,...)
end

function log:warn(...)
    _print("WARN",warn,...)
end

function log:alert(...)
    _print("ALERT Failure:",error,...)
end

return log