--[[
##    ##    ###    ##       ######## #### ########   #######   ######   ######   #######  ########  ######## 
##   ##    ## ##   ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##     ## ##       
##  ##    ##   ##  ##       ##        ##  ##     ## ##     ## ##       ##       ##     ## ##     ## ##       
#####    ##     ## ##       ######    ##  ##     ## ##     ##  ######  ##       ##     ## ########  ######   
##  ##   ######### ##       ##        ##  ##     ## ##     ##       ## ##       ##     ## ##        ##       
##   ##  ##     ## ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##        ##       
##    ## ##     ## ######## ######## #### ########   #######   ######   ######   #######  ##        ########  C_WRITING 

Kaleidoscope C_WRITING class By Coussini 2021
]]                                                                                                                                                                               
                                                                                                                                                                                                         
--+========================================+
--|  R E Q U I R E D   L I B R A R I E S   |
--+========================================+
local M_UTILITIES = require("Kaleidoscope.utilities")
local M_COLORS = require("Kaleidoscope.colors")
local M_COMPONENTS = require("Kaleidoscope.components")
local M_WRITING = require("Kaleidoscope.writing")
local C_BASE = require("Kaleidoscope.classes.C_BASE")

--+======================================================================+
--|                    T H E   F O L L O W I N G   I S                   |
--|       T H E   W R I T I N G   C L A S S   D E F I N I T I O N S      |
--+======================================================================+

--------------------------------------
-- ATTRIBUTES FOR THE WRITING CLASS --
--------------------------------------
local C_WRITING = {
    text = "",
    font_pseudo = ""
}

---------------------------------------
-- CONSTRUCTOR FOR THE WRITING CLASS --
---------------------------------------
C_WRITING.__index = C_WRITING

setmetatable(C_WRITING, {
    __index = C_BASE, 
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:_init(...)
        return self
    end,
})

function C_WRITING:_init(parent_coordinates,horizontal_type,horizontal_value,vertical_type,vertical_value)
    C_WRITING.set_type(self,"writing")
    C_BASE._init(self,parent_coordinates,horizontal_type,horizontal_value,vertical_type,vertical_value) -- call the base class constructor
end

-----------------------------------
-- METHODS FOR THE WRITING CLASS --
-----------------------------------

--++-------------------------------------------------------------++
--|| C_WRITING:set_default() Set the default value for a WRITING || 
--++-------------------------------------------------------------++
function C_WRITING:set_default ()
    C_WRITING._init(self,M_COMPONENTS.screen_coordinates,"c",0,"c",0)
end

--++--------------------------------------------------------------++
--|| C_WRITING:show() Write something using properties and colors || 
--++--------------------------------------------------------------++
function C_WRITING:show(text,font_pseudo,colors)
    self.text = (tostring(text) ~= nil and tostring(text) ~= "") and tostring(text) or ""
    self.font_pseudo = M_UTILITIES.ItemListValid(M_WRITING.fonts_pseudo_valid,font_pseudo) and font_pseudo or "H10"
    self.properties = {
        text = self.text,
        font_pseudo = self.font_pseudo,
        parent_coordinates = self.parent_coordinates,
        horizontal_type = self.horizontal_type,
        horizontal_value = self.horizontal_value,
        vertical_type = self.vertical_type,
        vertical_value = self.vertical_value
    }
    self.colors = M_COLORS.ColorsValid(colors) and colors or M_COLORS.SetColorsTheme(1,"XPLANE11")        
    self.coordinates = M_WRITING.WritingText(self.properties,self.colors)

    return self.coordinates
end

return C_WRITING