--[[
##    ##    ###    ##       ######## #### ########   #######   ######   ######   #######  ########  ######## 
##   ##    ## ##   ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##     ## ##       
##  ##    ##   ##  ##       ##        ##  ##     ## ##     ## ##       ##       ##     ## ##     ## ##       
#####    ##     ## ##       ######    ##  ##     ## ##     ##  ######  ##       ##     ## ########  ######   
##  ##   ######### ##       ##        ##  ##     ## ##     ##       ## ##       ##     ## ##        ##       
##   ##  ##     ## ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##        ##       
##    ## ##     ## ######## ######## #### ########   #######   ######   ######   #######  ##        ########  UTILITIES 

Kaleidoscope Utilities module By Coussini 2021
]]                       

--+==================================+
--|  L O C A L   V A R I A B L E S   |
--+==================================================================+
--| They will be available when this library has loaded with require |
--+==================================================================+
local M_UTILITIES = {}
 
-- dataref required for M_UTILITIES
DataRef("M_UTILITIES_total_running_time_sec","sim/time/total_running_time_sec","readonly")

--+=============================================================+
--|   T H E   F O L L O W I N G   A R E   H I G H   L E V E L   |
--|          U T I L I T I E S   F U N C T I O N S              |
--|                                                             |
--| CONVENTION: These functions use Uper Camel Case without "_" |
--+=============================================================+

--++------------------------------------------------------------------------------------------------------++
--|| M_UTILITIES.OutputLog() Create a log within with the lua name that call this function with a message || 
--++------------------------------------------------------------------------------------------------------++
function M_UTILITIES.OutputLog(message)

    local message = tostring(message)
	local info = debug.getinfo (2,"Sl")
	local src = info.short_src
	
    src = M_UTILITIES.ReplaceString(src,"/"," ")
	src = M_UTILITIES.ReplaceString(src,"]"," ")
	src = M_UTILITIES.LastWord(src)
	
    logMsg("["..src.."] Line : "..string.format("%d",info.currentline).." Message : "..message)
end

--++------------------------------------------------++
--|| M_UTILITIES.DumpTable() Dump a table containts || 
--++------------------------------------------------++
function M_UTILITIES.DumpTable(table)

    local dump = tostring(table)

    if type(table) == 'table' then
        dump = '{ '

            for k,v in pairs(table) do
                if type(k) ~= 'number' then 
                    k = '"'..k..'"' 
                end
                dump = dump .. '['..k..'] = ' .. M_UTILITIES.DumpTable(v) .. ','
            end

        dump = dump .. '} '
    end

    return dump
end

--++-------------------------------------------------------------------++
--|| M_UTILITIES.TrimLeading() Remove the leading spaces from a string || 
--|| Force any kind of input argument by using tostring()              || 
--++-------------------------------------------------------------------++
function M_UTILITIES.TrimLeading(str)

    local str = tostring(str)
    
    return ( type(str) == "string" and str:gsub("^%s*", "") or nil )
end

--++---------------------------------------------------------------------++
--|| M_UTILITIES.TrimTrailing() Remove the trailing spaces from a string || 
--|| Force any kind of input argument by using tostring()                || 
--++---------------------------------------------------------------------++
function M_UTILITIES.TrimTrailing(str)

    local str = tostring(str)
	local count = #str

	while count > 0 and str:find("^%s", count) do 
		count = count - 1 
	end

	return str:sub(1, count)
end

--++-----------------------------------------------------------------------------++
--|| M_UTILITIES.TrimBoth() Remove the leading and trailing spaces from a string || 
--|| Force any kind of input argument by using tostring()                        || 
--++-----------------------------------------------------------------------------++
function M_UTILITIES.TrimBoth(str)

    local str = tostring(str)

	return (str:gsub("^%s*(.-)%s*$", "%1"))
end

--++----------------------------------------------------------++
--|| M_UTILITIES.TrimBoth() Remove all spaces inside a string || 
--|| Force any kind of input argument by using tostring()     || 
--++----------------------------------------------------------++
function M_UTILITIES.RemoveSpaces(str)

    local str = tostring(str)

	return (str:gsub("%s*", ""))
end

--++-----------------------------------------------------------------------------------------------------++
--|| M_UTILITIES.IndexOff() returns the position of the first occurrence of a specified part in a string || 
--|| Force any kind of input argument by using tostring()                                                || 
--|| N.B: str = string of characters                                                                     || 
--||      part = part to be find                                                                         || 
--++-----------------------------------------------------------------------------------------------------++
function M_UTILITIES.IndexOff(str,part)

    local str = tostring(str)
    local part = tostring(part)

    return (str:find(part,1,true))
end

--++-----------------------------------------------------------------------------------------------------++
--|| M_UTILITIES.ReplaceString() replace a part (a string or a character) from a string of characters    ||
--|| with another fied part in a string. You can replace several occurs                                  ||
--|| Force any kind of input argument by using tostring()                                                || 
--|| N.B: str = string of characters                                                                     || 
--||      old_part = part to be replace                                                                  || 
--||      new_part = new replacement part                                                                || 
--++-----------------------------------------------------------------------------------------------------++
function M_UTILITIES.ReplaceString(str,old_part,new_part)

    local str = tostring(str)
    local old_part = tostring(old_part)
    local new_part = tostring(new_part)

    return (str:gsub(old_part,new_part))
end

--++----------------------------------------------------------------------------++
--|| M_UTILITIES.SplitWord() Split all word from a string into the table result ||
--|| Force any kind of input argument by using tostring()                       || 
--++----------------------------------------------------------------------------++
function M_UTILITIES.SplitWord(str)

    local str = tostring(str)
    local result = {};
    
    for word in str:gmatch("%S+") do
        table.insert(result, word); 
    end
    
    return result;
end

--++-----------------------------------------------------------------++
--|| M_UTILITIES.CountWords() Count the number of word from a string ||
--|| Force any kind of input argument by using tostring()            || 
--++-----------------------------------------------------------------++
function M_UTILITIES.CountWords(str)

    local str = tostring(str)
    result = M_UTILITIES.SplitWord(str)

    return #result
end

--++-------------------------------------------------------------++
--|| M_UTILITIES.FirstWord() Return the first word from a string ||
--|| Force any kind of input argument by using tostring()        || 
--++-------------------------------------------------------------++
function M_UTILITIES.FirstWord(str)

    local str = tostring(str)
    result = M_UTILITIES.SplitWord(str)

    return result[1]
end

--++-----------------------------------------------------------++
--|| M_UTILITIES.LastWord() Return the last word from a string ||
--|| Force any kind of input argument by using tostring()      || 
--++-----------------------------------------------------------++
function M_UTILITIES.LastWord(str)

    local str = tostring(str)
    result = M_UTILITIES.SplitWord(str)

    return result[#result]
end

--++------------------------------------------------------------++
--|| M_UTILITIES.ItemListValid() Validate if an item is present ||
--|| in a specific list                                         || 
--||  N.B: list = list of item                                  || 
--||       item = item to be find                               || 
--++------------------------------------------------------------++
function M_UTILITIES.ItemListValid(list,item)

    local is_valid = false 

    for _,v in pairs(list) do
        if v == item then
            is_valid = true
            break
        end
    end

    return is_valid
end 


--++----------------------------------------------------++
--|| M_UTILITIES.GetDecimal() get the decimal part only ||
--|| N.B: Can return nil when no decimal found          ||
--++----------------------------------------------------++
function M_UTILITIES.GetDecimal(number)  
    return tostring(number):match("%.(%d+)")
end


--++---------------------------------------------------------------++
--|| M_UTILITIES.Round() rounds a number to any number of decimals ||
--++---------------------------------------------------------------++
function M_UTILITIES.Round(number, number_decimal)
    return tonumber(string.format("%." .. (number_decimal or 0) .. "f", number))
end

--++-------------------------------------------------------------------++
--|| M_UTILITIES.FindSize() Return the size of the input argument file ||
--++-------------------------------------------------------------------++
function M_UTILITIES.FindSize(file)
    
    local current = file:seek()      -- get current position
    local size = file:seek("end")    -- get file size
    
    file:seek("set", current)        -- restore position

    return size
end

--++--------------------------------------------------------++
--|| M_UTILITIES.ReadFile() Return the contains of the file ||
--++--------------------------------------------------------++
function M_UTILITIES.ReadFile(file)
    
    lines = {}
    local f = io.open(file, "rb")
    
    if f then 
        f:close() 
        for line in io.lines(file) do 
            lines[#lines + 1] = line
        end
    end
  
    return lines
end

--++-----------------------------------------------------------++
--|| M_UTILITIES.Fsize() Return a time limit value for a timer ||
--++-----------------------------------------------------------++
function M_UTILITIES.SetTimer(time)
    return M_UTILITIES_total_running_time_sec + time
end

--++-----------------------------------------------------------------------------++
--|| M_UTILITIES.NumberInWords() this function translate a number in speach word ||
--++-----------------------------------------------------------------------------++
function M_UTILITIES.NumberInWords(num)

    -----------------------------------------------------------------------------------
    -- IF YOUR REPLACE THE FOLLOWING TABLE OF NUMBERS BY A STRING                    --
    -- FROM THE PREVIOUS TABLE IN COMMENT, YOU WILL CREATE A NUMBER IN SPEACH FORMAT --
    -----------------------------------------------------------------------------------
    -- local TNumber1 = ['one ','two ','three ','four ', 'five ','six ','seven ','eight ','nine ','ten ','eleven ','twelve ','thirteen ','fourteen ','fifteen ','sixteen ','seventeen ','eighteen ','nineteen '];
    -- local TNumber2 = ['', 'twenty','thirty','forty','fifty', 'sixty','seventy','eighty','ninety'];
    -- TNumber1[0] = "" -- force to have occurs 0 IN LUA PGM
    -- TNumber2[0] = "" -- force to have occurs 0 IN LUA PGM

    local TNumber1 = {"1 ","2 ","3 ","4 ", "5 ","6 ","7 ","8 ","9 ","10 ","11 ","12 ","13 ","14 ","15 ","16 ","17 ","18 ","19 "}
    local TNumber2 = {"", "20","30","40","50","60","70","80","90"}
    TNumber1[0] = "" -- force to have occurs 0 IN LUA PGM
    TNumber2[0] = "" -- force to have occurs 0 IN LUA PGM

    local str = ""
    local pad_num = ""
    local n = {}

    if tonumber(num) and tonumber(num) ~= 0 then 
        pad_num = "000000000"..num -- if num = 125
    else 
        return str 
    end

    n[0] = string.sub(pad_num, -9) -- padding 0 before number like 000000125
    n[1] = string.sub(n[0], 1,2) -- will be 00
    n[2] = string.sub(n[0], 3,4) -- will be 00
    n[3] = string.sub(n[0], 5,6) -- will be 00
    n[4] = string.sub(n[0], 7,7) -- will be 1
    n[5] = string.sub(n[0], 8,9) -- will be 25

    if (n[1] ~= "00") then
        local val1 = TNumber1[tonumber(n[1])]
        local val2a = tonumber(string.sub(n[1],1,1))
        local val2b = tonumber(string.sub(n[1],2,2))
        local val2 = TNumber2[val2a].." "..TNumber1[val2b]
        local valf = val1 or val2
        str = str..valf 
    end

    if (n[2] ~= "00") then
        local val1 = TNumber1[tonumber(n[2])]
        local val2a = tonumber(string.sub(n[2],1,1))
        local val2b = tonumber(string.sub(n[2],2,2))
        local val2 = TNumber2[val2a].." "..TNumber1[val2b]
        local valf = val1 or val2
        str = str..valf 
    end

    if (n[3] ~= "00") then
        local val1 = TNumber1[tonumber(n[3])]
        local val2a = tonumber(string.sub(n[3],1,1))
        local val2b = tonumber(string.sub(n[3],2,2))
        local val2 = TNumber2[val2a].." "..TNumber1[val2b]
        local valf = val1 or val2
        str = str..valf.."Thousand " 
    end

    if (n[4] ~= "0") then
        local val1 = TNumber1[tonumber(n[4])]
        local val2a = tonumber(string.sub(n[4],1,1))
        local val2b = "" -- pas present
        local val2 = TNumber2[val2a].." "
        local valf = val1 or val2
        str = str..valf.."Hundred " 
    end

    if (n[5] ~= "00") then
        local val1 = TNumber1[tonumber(n[5])]
        local val2a = tonumber(string.sub(n[5],1,1))
        local val2b = tonumber(string.sub(n[5],2,2))
        local val2 = TNumber2[val2a].." "..TNumber1[val2b]
        local valf = val1 or val2
        str = str..valf 
    end

    return str
end


--++-------------------------------------------------------------------------------------------++
--|| M_UTILITIES.CountedTable() returning an object that can count "index", "key" or "entries" ||
--||                                                                                           || 
--|| Exemple:                                                                                  ||
--|| local l1 = { 1, 2, 3, 4, [36.35433] = 36.35433, [54] = 54 }                               || 
--|| local l2 = { x = 23, y = 43, z = 334, [true] = true }                                     || 
--|| local l3 = { 1, 2, 3, x = 'x', [true] = true, [64] = 64 }                                 || 
--|| local t1 = CountedTable(l1)                                                               ||
--|| local t2 = CountedTable(l2)                                                               ||
--|| local t3 = CountedTable(l3)                                                               ||   
--||                                                                                           || 
--|| print(t1.indexCount)   --> 5                                                              ||
--|| print(t2.keyCount)     --> 4                                                              ||
--|| print(t3.entriesCount) --> 6                                                              ||        
--++-------------------------------------------------------------------------------------------++
function M_UTILITIES.CountedTable(a_table)

    local mt = {}
    local keys, indxs, all = 0, 0, 0

    for k, v in pairs(a_table) do
        if (type(k) == 'number') and (k == math.floor(k)) then 
            indxs = indxs + 1
        else 
            keys = keys + 1 
        end

        all = all + 1
    end

    mt.__newindex = function(t, k, v)
        if (type(k) == 'number') and (k == math.floor(k)) then 
            indxs = indxs + 1
        else 
            keys = keys + 1 
        end

        all = all + 1
        t[k] = v
    end

    mt.__index = function(t, k)
        if k == 'keyCount' then 
            return keys 
        elseif k == 'indexCount' then 
            return indxs 
        elseif k == 'entriesCount' then 
            return all 
        end
    end

    return setmetatable(a_table, mt)
end

--++-----------------------------------------------------------------------++
--|| M_UTILITIES.Counter() are methods of increment and decrement value    ||
--|| Exemple:                                                              ||
--|| local counter = M_UTILITIES.Counter(55) -- initialise a counter to 55 || 
--|| counter.add(15) -- return the increment result (55+15 = 70)           || 
--|| counter.sub(15) -- return the decrement result (55-15 = 40)           || 
--++-----------------------------------------------------------------------++
M_UTILITIES.Counter = {}

M_UTILITIES.Counter.__index = M_UTILITIES.Counter

setmetatable(M_UTILITIES.Counter, {
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

function M_UTILITIES.Counter:_init(line)
    self.line = line
end    

function M_UTILITIES.Counter:add (next)
    self.line = self.line + next
    return self.line
end

function M_UTILITIES.Counter:sub (next)
    self.line = self.line - next
    return self.line
end

return M_UTILITIES