--[[
##    ##    ###    ##       ######## #### ########   #######   ######   ######   #######  ########  ######## 
##   ##    ## ##   ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##     ## ##       
##  ##    ##   ##  ##       ##        ##  ##     ## ##     ## ##       ##       ##     ## ##     ## ##       
#####    ##     ## ##       ######    ##  ##     ## ##     ##  ######  ##       ##     ## ########  ######   
##  ##   ######### ##       ##        ##  ##     ## ##     ##       ## ##       ##     ## ##        ##       
##   ##  ##     ## ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##        ##       
##    ## ##     ## ######## ######## #### ########   #######   ######   ######   #######  ##        ########  C_BASE 

Kaleidoscope C_BASE class By Coussini 2021
]]                                                                                                                                                                               
                                                                                                                                                                                                         
--+========================================+
--|  R E Q U I R E D   L I B R A R I E S   |
--+========================================+
local M_UTILITIES = require("Kaleidoscope.utilities")
local M_COLORS = require("Kaleidoscope.colors")
local M_COMPONENTS = require("Kaleidoscope.components")

--+===================================================================+
--|                 T H E   F O L L O W I N G   I S                   |
--|       T H E   B A S E   C L A S S   D E F I N I T I O N S         |
--+===================================================================+

-----------------------------------
-- ATTRIBUTES FOR THE BASE CLASS --
-----------------------------------
local C_BASE = {
    type = "", -- DRAWING OR WRITING
    ----------------
    -- PROPERTIES --
    ----------------
    parent_coordinates = {},
    horizontal_type = "",
    horizontal_value = 0,
    vertical_type = "",
    vertical_value = 0,
    properties = {}, -- OBJECT FOR CALLING ROUTINE
    ------------
    -- RESULT --
    ------------
    coordinates = {}  -- OBJECT FOR CALLING ROUTINE (WILL BE A PARENT_COORDINATES)
}

------------------------------------
-- CONSTRUCTOR FOR THE BASE CLASS --
------------------------------------
C_BASE.__index = C_BASE

setmetatable(C_BASE, {
    __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
    end,
})

function C_BASE:_init(parent_coordinates,horizontal_type,horizontal_value,vertical_type,vertical_value)
    C_BASE:set_parent_coordinates(parent_coordinates)
    C_BASE:set_position(horizontal_type,horizontal_value,vertical_type,vertical_value)
end

--------------------------------
-- METHODS FOR THE BASE CLASS --
--------------------------------

--++-------------------------------------------------------------------++
--|| C_BASE:set_parent_coordinates() Set the coordinates for an object || 
--++-------------------------------------------------------------------++
function C_BASE:set_parent_coordinates(parent_coordinates)
    self.parent_coordinates = C_BASE.is_coordinates_valid(parent_coordinates) and parent_coordinates or M_COMPONENTS.screen_coordinates
end

--++---------------------------------------------------------++
--|| C_BASE:set_disposition() Set the position of the object || 
--++---------------------------------------------------------++
function C_BASE:set_position(horizontal_type,horizontal_value,vertical_type,vertical_value)
    self.horizontal_type = M_UTILITIES.ItemListValid(M_COMPONENTS.horizontal_position_valid,horizontal_type) and horizontal_type or M_COMPONENTS.position.RIGHT
    self.horizontal_value = (tonumber(horizontal_value) ~= nil and horizontal_value <= SCREEN_WIDTH and horizontal_value >= 0) and horizontal_value or 0
    self.vertical_type = M_UTILITIES.ItemListValid(M_COMPONENTS.vertical_position_valid,vertical_type) and vertical_type or M_COMPONENTS.position.TOP
    self.vertical_value = (tonumber(vertical_value) ~= nil and vertical_value <= SCREEN_HIGHT and vertical_value >= 0) and vertical_value or 0
end

--++-----------------------------------------------------++
--|| C_BASE:set_type() Set the type (drawing or writing) || 
--++-----------------------------------------------------++
function C_BASE:set_type(type)
    self.type = M_UTILITIES.ItemListValid(M_COMPONENTS.type_valid,type) and type or "drawing"
end

--++----------------------------------------------------------------------++
--|| C_BASE.is_coordinates_valid() Validate a coordinates object contents || 
--++----------------------------------------------------------------------++
function C_BASE.is_coordinates_valid(coordinates)

    local match = false

    if type(coordinates) == "table" then 

        local coordinates_table = M_UTILITIES.CountedTable(coordinates)

        if coordinates_table.keyCount == 7 and coordinates_table.entriesCount == 7 then -- a drawing
            if (coordinates.x1 ~= nil and tonumber(coordinates.x1) ~= nil and coordinates.x1 <= SCREEN_WIDTH and coordinates.x1 >= 0) and
               (coordinates.y1 ~= nil and tonumber(coordinates.y1) ~= nil and coordinates.y1 <= SCREEN_HIGHT and coordinates.y1 >= 0) and
               (coordinates.x2 ~= nil and tonumber(coordinates.x2) ~= nil and coordinates.x2 <= SCREEN_WIDTH and coordinates.x2 >= 0) and
               (coordinates.y2 ~= nil and tonumber(coordinates.y2) ~= nil and coordinates.y2 <= SCREEN_HIGHT and coordinates.y2 >= 0) and
               (coordinates.width ~= nil and tonumber(coordinates.width) ~= nil and coordinates.width <= SCREEN_WIDTH and coordinates.width >= 1) and
               (coordinates.height ~= nil and tonumber(coordinates.height) ~= nil and coordinates.height <= SCREEN_HIGHT and coordinates.height >= 1) and
               (coordinates.is_a_drawing ~= nil and coordinates.is_a_drawing == true) then
               match = true
            end
        elseif coordinates_table.keyCount == 5 and coordinates_table.entriesCount == 5 then -- a writing
            if (coordinates.x1 ~= nil and tonumber(coordinates.x1) ~= nil and coordinates.x1 <= SCREEN_WIDTH and coordinates.x1 >= 0) and
               (coordinates.y1 ~= nil and tonumber(coordinates.y1) ~= nil and coordinates.y1 <= SCREEN_HIGHT and coordinates.y1 >= 0) and
               (coordinates.width ~= nil and tonumber(coordinates.width) ~= nil and coordinates.width <= SCREEN_WIDTH and coordinates.width >= 1) and
               (coordinates.height ~= nil and tonumber(coordinates.height) ~= nil and coordinates.height <= SCREEN_HIGHT and coordinates.height >= 1) and
               (coordinates.is_a_drawing ~= nil and coordinates.is_a_drawing == false) then
               match = true
            end
        end
    end
    return match
end

return C_BASE