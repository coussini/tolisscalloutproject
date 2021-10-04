--[[
##    ##    ###    ##       ######## #### ########   #######   ######   ######   #######  ########  ######## 
##   ##    ## ##   ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##     ## ##       
##  ##    ##   ##  ##       ##        ##  ##     ## ##     ## ##       ##       ##     ## ##     ## ##       
#####    ##     ## ##       ######    ##  ##     ## ##     ##  ######  ##       ##     ## ########  ######   
##  ##   ######### ##       ##        ##  ##     ## ##     ##       ## ##       ##     ## ##        ##       
##   ##  ##     ## ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##        ##       
##    ## ##     ## ######## ######## #### ########   #######   ######   ######   #######  ##        ########  C_BUTTON 

Kaleidoscope C_BUTTON class By Coussini 2021
]]                                                                                                                                                                               
                                                                                                                                                                                                         
--+========================================+
--|  R E Q U I R E D   L I B R A R I E S   |
--+========================================+
local M_UTILITIES = require("Kaleidoscope.utilities")
local M_COLORS = require("Kaleidoscope.colors")
local M_COMPONENTS = require("Kaleidoscope.components")
local M_DRAWING = require("Kaleidoscope.drawing")
local M_WRITING = require("Kaleidoscope.writing")
local C_BASE = require("Kaleidoscope.classes.C_BASE")

--+======================================================================+
--|                    T H E   F O L L O W I N G   I S                   |
--|       T H E   D R A W I N G   C L A S S   D E F I N I T I O N S      |
--+======================================================================+

---------------------------------------------------
-- ATTRIBUTES FOR THE DRAWING CLASS --
---------------------------------------------------
local C_BUTTON = {
    width = 1,
    height = 1,
    border_size = 0
}

---------------------------------------
-- CONSTRUCTOR FOR THE DRAWING CLASS --
---------------------------------------
C_BUTTON.__index = C_BUTTON

setmetatable(C_BUTTON, {
    __index = C_BASE, -- this is what makes the inheritance work
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

function C_BUTTON:_init(width,height,border_size,parent_coordinates,horizontal_type,horizontal_value,vertical_type,vertical_value)
    C_BUTTON.set_type(self,"drawing")
    C_BUTTON.set_size(self,width,height,border_size)
    C_BASE._init(self,parent_coordinates,horizontal_type,horizontal_value,vertical_type,vertical_value) -- call the base class constructor
end

-----------------------------------
-- METHODS FOR THE DRAWING CLASS --
-----------------------------------

--++----------------------------------------------------------------++
--|| C_BUTTON:set_size() Set the size of the object and border_size || 
--++----------------------------------------------------------------++
function C_BUTTON:set_size(width,height,border_size)
    self.width = (tonumber(width) ~= nil and width <= SCREEN_WIDTH and width >= 1) and width or 1
    self.height = (tonumber(height) ~= nil and height <= SCREEN_HIGHT and height >= 1) and height or 1
    self.border_size = (tonumber(border_size) ~= nil and border_size >= 0) and border_size or 0
end

--++-----------------------------------------------------------++
--|| C_BUTTON:set_default() Set the default value for a button || 
--++-----------------------------------------------------------++
function C_BUTTON:set_default ()
    C_BUTTON._init(self,200,300,2,M_COMPONENTS.screen_coordinates,"r",60,"t",40)
end

--++-------------------------------------------------------------++
--|| C_BUTTON:show() Draw something using properties and colors || 
--++-------------------------------------------------------------++
function C_BUTTON:show(text,font_pseudo,to_show,colors)
    self.to_show = M_UTILITIES.ItemListValid(M_COMPONENTS.shape_type_valid,to_show) and to_show or M_COMPONENTS.shape_type.R
    -- set properties
    self.properties = {
        width = self.width,
        height = self.height, 
        border_size = self.border_size, 
        parent_coordinates = self.parent_coordinates,
        horizontal_type = self.horizontal_type,
        horizontal_value = self.horizontal_value,
        vertical_type = self.vertical_type,
        vertical_value = self.vertical_value
    }

    self.colors = M_COLORS.ColorsValid(colors) and colors or M_COLORS.SetColorsTheme(1,"XPLANE11")     
       
    if self.to_show == M_COMPONENTS.shape_type.R then
        self.coordinates = M_DRAWING.DrawingRectangle(self.properties,self.colors)
    elseif self.to_show == M_COMPONENTS.shape_type.RO then
        self.coordinates = M_DRAWING.DrawingRectangleOutlined(self.properties,self.colors)
    elseif self.to_show == M_COMPONENTS.shape_type.RRC then
        self.coordinates = M_DRAWING.DrawingRectangleRoundedCorner(self.properties,self.colors)
    elseif self.to_show == M_COMPONENTS.shape_type.RBC then
        self.coordinates = M_DRAWING.DrawingRectangleBeveledCorner(self.properties,self.colors)
    elseif self.to_show == M_COMPONENTS.shape_type.C then
        self.coordinates = M_DRAWING.DrawingCapsule(self.properties,self.colors)
    elseif self.to_show == M_COMPONENTS.shape_type.HH then
        self.coordinates = M_DRAWING.DrawingHorizontalHoneycomb(self.properties,self.colors)
    elseif self.to_show == M_COMPONENTS.shape_type.VH then
        self.coordinates = M_DRAWING.DrawingVerticalHoneycomb(self.properties,self.colors)
    else
        -- DEFAULT
        self.coordinates = M_DRAWING.DrawingRectangle(self.properties,self.colors)
    end

    self.text = (tostring(text) ~= nil and tostring(text) ~= "") and tostring(text) or ""
    self.font_pseudo = M_UTILITIES.ItemListValid(M_WRITING.fonts_pseudo_valid,font_pseudo) and font_pseudo or "H10"
    self.writing_properties = {
        text = self.text,
        font_pseudo = self.font_pseudo,
        parent_coordinates = self.coordinates,
        horizontal_type = "c",
        horizontal_value = 0,
        vertical_type = "c",
        vertical_value = 0
    }
    self.writing_colors = M_COLORS.ColorsValid(colors) and colors or M_COLORS.SetColorsTheme(1,"XPLANE11")        
    self.writing_coordinates = M_WRITING.WritingText(self.writing_properties,self.writing_colors)
        
    return self.coordinates
end

function C_BUTTON:dump_result(title)
    l_title = title:len()
    big_title = ""
    for i = 1, l_title do
        big_title = big_title..string.sub(title, i,i).." "
    end
    big_title = "= "..big_title.."="
    l_big_title = big_title:len()
    M_UTILITIES.OutputLog("")
    M_UTILITIES.OutputLog(string.rep("=",l_big_title))
    M_UTILITIES.OutputLog(big_title)
    M_UTILITIES.OutputLog(string.rep("=",l_big_title))
    M_UTILITIES.OutputLog("type = "..self.type)
    M_UTILITIES.OutputLog("theme_name = "..self.theme_name)
    M_UTILITIES.OutputLog("alpha = "..self.alpha)
    M_UTILITIES.OutputLog("color_center = "..M_UTILITIES.DumpTable(self.color_center))
    M_UTILITIES.OutputLog("color_border = "..M_UTILITIES.DumpTable(self.color_border))
    M_UTILITIES.OutputLog("color_text = "..M_UTILITIES.DumpTable(self.color_text))
    M_UTILITIES.OutputLog("colors = "..M_UTILITIES.DumpTable(self.colors))
    -- all properties
    M_UTILITIES.OutputLog("width = "..self.width)
    M_UTILITIES.OutputLog("height = "..self.height)
    M_UTILITIES.OutputLog("border_size = "..self.border_size)
    M_UTILITIES.OutputLog("parent_coordinates = "..M_UTILITIES.DumpTable(self.parent_coordinates))
    M_UTILITIES.OutputLog("horizontal_type = "..self.horizontal_type)
    M_UTILITIES.OutputLog("horizontal_value = "..self.horizontal_value)
    M_UTILITIES.OutputLog("vertical_type = "..self.vertical_type)
    M_UTILITIES.OutputLog("vertical_value = "..self.vertical_value)
    -- properties
    M_UTILITIES.OutputLog("properties = "..M_UTILITIES.DumpTable(self.properties))
    M_UTILITIES.OutputLog("to_show = "..self.to_show)
    -- coordinates
    M_UTILITIES.OutputLog("coordinates = "..M_UTILITIES.DumpTable(self.coordinates))
    M_UTILITIES.OutputLog("==================")
end

return C_BUTTON