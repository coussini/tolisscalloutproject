--[[
##    ##    ###    ##       ######## #### ########   #######   ######   ######   #######  ########  ######## 
##   ##    ## ##   ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##     ## ##       
##  ##    ##   ##  ##       ##        ##  ##     ## ##     ## ##       ##       ##     ## ##     ## ##       
#####    ##     ## ##       ######    ##  ##     ## ##     ##  ######  ##       ##     ## ########  ######   
##  ##   ######### ##       ##        ##  ##     ## ##     ##       ## ##       ##     ## ##        ##       
##   ##  ##     ## ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##        ##       
##    ## ##     ## ######## ######## #### ########   #######   ######   ######   #######  ##        ########  WRITING 

Kaleidoscope Writing module By Coussini 2021
]]    
                                                                                                                                                                                                         
--+========================================+
--|  R E Q U I R E D   L I B R A R I E S   |
--+========================================+
local M_UTILITIES = require("Kaleidoscope.utilities")
local M_COLORS = require("Kaleidoscope.colors")
local M_COMPONENTS = require("Kaleidoscope.components")
                                                                                                                                                                                                         
--+==================================+
--|  L O C A L   V A R I A B L E S   |
--+==================================================================+
--| They will be available when this library has loaded with require |
--+==================================================================+
local M_WRITING = {}

M_WRITING.fonts_pseudo_valid = {"H10","H12","H18","T10","T24","H10B","H12B","H18B","T10B","T24B","H10E","H12E","H18E","T10E","T24E"}

M_WRITING.FONTS =
{
    H10 = 
    {
        pseudo = "H10",
        name   = "Helvetica_10",
        type   = "normal"
    },
    H12 = 
    {
        pseudo = "H12",
        name   = "Helvetica_12",
        type   = "normal"
    },
    H18 = 
    {
        pseudo = "H18",
        name   = "Helvetica_18",
        type   = "normal"
    },
    T10 = 
    {
        pseudo = "T10",
        name   = "Times_Roman_10",
        type   = "normal"
    },
    T24 = 
    {
        pseudo = "T24",
        name   = "Times_Roman_24",
        type   = "normal"
    },
    H10B = 
    {
        pseudo = "H10B",
        name   = "Helvetica_10",
        type   = "bold"
    },
    H12B = 
    {
        pseudo = "H12B",
        name   = "Helvetica_12",
        type   = "bold"
    },
    H18B = 
    {
        pseudo = "H18B",
        name   = "Helvetica_18",
        type   = "bold"
    },
    T10B = 
    {
        pseudo = "T10B",
        name   = "Times_Roman_10",
        type   = "bold"
    },
    T24B = 
    {
        pseudo = "T24B",
        name   = "Times_Roman_24",
        type   = "bold"
    },
    H10E = 
    {
        pseudo = "H10E",
        name   = "Helvetica_10",
        type   = "emboss"
    },

    H12E = 
    {
        pseudo = "H12E",
        name   = "Helvetica_12",
        type   = "emboss"
    },

    H18E = 
    {
        pseudo = "H18E",
        name   = "Helvetica_18",
        type   = "emboss"
    },

    T10E = 
    {
        pseudo = "T10E",
        name   = "Times_Roman_10",
        type   = "emboss"
    },

    T24E = 
    {
        pseudo = "T24E",
        name   = "Times_Roman_24",
        type   = "emboss"
    }
}

--+==============================================================+
--|    T H E   F O L L O W I N G   A R E   L O W   L E V E L     |
--|           W R I T I N G   F U N C T I O N S                  |
--|                                                              |
--| CONVENTION: These functions are lowercase and use underscore |
--+==============================================================+

--++-------------------------------------------------------------------------------------++
--|| M_WRITING.get_height_in_pixel() Find the height in pixels of a specific font pseuso || 
--++-------------------------------------------------------------------------------------++
function M_WRITING.get_height_in_pixel(font_pseudo)

    local font_pseudo = M_UTILITIES.ItemListValid(M_WRITING.fonts_pseudo_valid,string.upper(font_pseudo)) and string.upper(font_pseudo) or "H10"
    local height_in_pixel = 8.5

    if     M_UTILITIES.IndexOff(font_pseudo,"H10") then height_in_pixel = 8.5
    elseif M_UTILITIES.IndexOff(font_pseudo,"H12") then height_in_pixel = 9.5
    elseif M_UTILITIES.IndexOff(font_pseudo,"H18") then height_in_pixel = 14.5
    elseif M_UTILITIES.IndexOff(font_pseudo,"T10") then height_in_pixel = 7.5
    elseif M_UTILITIES.IndexOff(font_pseudo,"T24") then height_in_pixel = 17.5 
    end

    return height_in_pixel
end

--++---------------------------------------------------------------------------++
--|| M_WRITING.write() Write a text using axes coordinates, color, font pseuso || 
--++---------------------------------------------------------------------------++
function M_WRITING.write(coordinates,colors,writing)

    local font_pseudo = M_UTILITIES.ItemListValid(M_WRITING.fonts_pseudo_valid,string.upper(writing.font_pseudo)) and string.upper(writing.font_pseudo) or "H10"

    -- Select the last color for the normal text and bold only (because the emboss use another colors)
    if not M_UTILITIES.IndexOff(font_pseudo,"E") then
        glColor4f(colors[3].rgb.red, colors[3].rgb.green, colors[3].rgb.blue, colors[3].alpha)
    end

    -- You have to imagine that you are writing a text just above a thin horizontal imaginary line. 
    -- The X & Y axis corresponds to this imaginary horizontal line. 
    -- To write a text at the bottom and left side of the screen, you have to use 0 for the X and Y axis.
    --
    -- To write a text at the top and left side of the screen, You must know the height in pixels to a font.
    -- The Y axis = (Screen Height - height in pixels to a font)
    -- You can write this text in the top and left of the screen using X=0 and the calculated Y
    --
    -- To write a text at the top and right side of the screen, You must know the height in pixels to a font
    -- and the width in pixels corresponding to a font with this text.
    -- The X axis = (Screen width - width in pixels to a font with a specific text)
    -- The Y axis = (Screen Height - height in pixels to a font)

    if     font_pseudo == "H10"  then draw_string_Helvetica_10(coordinates.x1, coordinates.y1, writing.text) 
    elseif font_pseudo == "H12"  then draw_string_Helvetica_12(coordinates.x1 ,coordinates.y1, writing.text) 
    elseif font_pseudo == "H18"  then draw_string_Helvetica_18(coordinates.x1, coordinates.y1, writing.text) 
    elseif font_pseudo == "T10"  then draw_string_Times_Roman_10(coordinates.x1, coordinates.y1, writing.text) 
    elseif font_pseudo == "T24"  then draw_string_Times_Roman_24(coordinates.x1, coordinates.y1, writing.text) 
    elseif font_pseudo == "H10B" then M_WRITING.draw_string_Helvetica_10_bold(coordinates.x1,coordinates.y1,writing.text)
    elseif font_pseudo == "H12B" then M_WRITING.draw_string_Helvetica_12_bold(coordinates.x1,coordinates.y1,writing.text) 
    elseif font_pseudo == "H18B" then M_WRITING.draw_string_Helvetica_18_bold(coordinates.x1,coordinates.y1,writing.text) 
    elseif font_pseudo == "T10B" then M_WRITING.draw_string_Times_Roman_10_bold(coordinates.x1,coordinates.y1,writing.text) 
    elseif font_pseudo == "T24B" then M_WRITING.draw_string_Times_Roman_24_bold(coordinates.x1,coordinates.y1,writing.text) 
    elseif font_pseudo == "H10E" then M_WRITING.draw_string_Helvetica_10_emboss(coordinates.x1,coordinates.y1,writing.text,colors)
    elseif font_pseudo == "H12E" then M_WRITING.draw_string_Helvetica_12_emboss(coordinates.x1,coordinates.y1,writing.text,colors) 
    elseif font_pseudo == "H18E" then M_WRITING.draw_string_Helvetica_18_emboss(coordinates.x1,coordinates.y1,writing.text,colors) 
    elseif font_pseudo == "T10E" then M_WRITING.draw_string_Times_Roman_10_emboss(coordinates.x1,coordinates.y1,writing.text,colors) 
    elseif font_pseudo == "T24E" then M_WRITING.draw_string_Times_Roman_24_emboss(coordinates.x1,coordinates.y1,writing.text,colors) 
    end
end

--++---------------------------------------------------------------------------------------------------++
--|| M_WRITING.draw_string_bold() Simulate a bold mode, using twice the draw_string function in offset || 
--++---------------------------------------------------------------------------------------------------++
function M_WRITING.draw_string_bold(x1, y1, text)

	local x1 = x1 or 0
	local y1 = y1 or 0
	local text = text or "please give me a text"

	draw_string(x1, y1, text)
    x1 = x1 - 1.0
    y1 = y1 + 0.1
    draw_string(x1, y1, text)
end

--++---------------------------------------------------------------------------------------------------------++
--|| M_WRITING.draw_string_color_bold() Simulate a bold mode, using twice the draw_string function in offset || 
--++---------------------------------------------------------------------------------------------------------++
function M_WRITING.draw_string_color_bold(x1, y1, text, color_name)

	local x1 = x1 or 0
	local y1 = y1 or 0
	local text = text or "please give me a text"
	local color_name = string.lower(color_name)
    local color_name = M_UTILITIES.ItemListValid(M_COLORS.basic_writing_valid,string.lower(color_name)) and string.lower(color_name) or "white"

    draw_string(x1, y1, text, color_name)
    x1 = x1 - 1.0
    y1 = y1 + 0.1
    draw_string(x1, y1, text, color_name)
end

--++-------------------------------------------------------------------------------------------------------++
--|| M_WRITING.draw_string_rgb_bold() Simulate a bold mode, using twice the draw_string function in offset || 
--++-------------------------------------------------------------------------------------------------------++
function M_WRITING.draw_string_rgb_bold(x1, y1, text, red, green, blue)

	local x1 = x1 or 0
	local y1 = y1 or 0
	local text = text or "please give me a text"
	local red = red or 1
	local green = green or 1
	local blue = blue or 1

	draw_string(x1, y1, text, red, green, blue)
    x1 = x1 - 1.0
    y1 = y1 + 0.1
    draw_string(x1, y1, text, red, green, blue)
end

--++-----------------------------------------------------------------------------------------------------------------------------++
--|| M_WRITING.draw_string_Helvetica_10_bold() Simulate a bold mode, using twice the draw_string_Helvetica_10 function in offset || 
--++-----------------------------------------------------------------------------------------------------------------------------++
function M_WRITING.draw_string_Helvetica_10_bold(x1, y1, text)

	local x1 = x1 or 0
	local y1 = y1 or 0
	local text = text or "please give me a text"

	draw_string_Helvetica_10(x1, y1, text)
    x1 = x1 - 1.0
    y1 = y1 + 0.1
    draw_string_Helvetica_10(x1, y1, text)
end

--++-----------------------------------------------------------------------------------------------------------------------------++
--|| M_WRITING.draw_string_Helvetica_12_bold() Simulate a bold mode, using twice the draw_string_Helvetica_12 function in offset || 
--++-----------------------------------------------------------------------------------------------------------------------------++
function M_WRITING.draw_string_Helvetica_12_bold(x1, y1, text)

	local x1 = x1 or 0
	local y1 = y1 or 0
	local text = text or "please give me a text"

	draw_string_Helvetica_12(x1, y1, text)
    x1 = x1 - 1.0
    y1 = y1 + 0.1
    draw_string_Helvetica_12(x1, y1, text)
end

--++-----------------------------------------------------------------------------------------------------------------------------++
--|| M_WRITING.draw_string_Helvetica_18_bold() Simulate a bold mode, using twice the draw_string_Helvetica_18 function in offset || 
--++-----------------------------------------------------------------------------------------------------------------------------++
function M_WRITING.draw_string_Helvetica_18_bold(x1, y1, text)

	local x1 = x1 or 0
	local y1 = y1 or 0
	local text = text or "please give me a text"

	draw_string_Helvetica_18(x1, y1, text)
    x1 = x1 - 1.0
    y1 = y1 + 0.1
    draw_string_Helvetica_18(x1, y1, text)
end

--++---------------------------------------------------------------------------------------------------------------------------------++
--|| M_WRITING.draw_string_Times_Roman_10_bold() Simulate a bold mode, using twice the draw_string_Times_Roman_10 function in offset || 
--++---------------------------------------------------------------------------------------------------------------------------------++
function M_WRITING.draw_string_Times_Roman_10_bold(x1, y1, text)

	local x1 = x1 or 0
	local y1 = y1 or 0
	local text = text or "please give me a text"

	draw_string_Times_Roman_10(x1, y1, text)
    x1 = x1 - 1.0
    y1 = y1 + 0.1
    draw_string_Times_Roman_10(x1, y1, text)
end

--++---------------------------------------------------------------------------------------------------------------------------------++
--|| M_WRITING.draw_string_Times_Roman_24_bold() Simulate a bold mode, using twice the draw_string_Times_Roman_24 function in offset || 
--++---------------------------------------------------------------------------------------------------------------------------------++
function M_WRITING.draw_string_Times_Roman_24_bold(x1, y1, text)

	local x1 = x1 or 0
	local y1 = y1 or 0
	local text = text or "please give me a text"

	draw_string_Times_Roman_24(x1, y1, text)
    x1 = x1 - 1.0
    y1 = y1 + 0.1
    draw_string_Times_Roman_24(x1, y1, text)
end

--++------------------------------------------------------------------------------------------++
--|| M_WRITING.draw_string_Helvetica_10_emboss() Simulate an emboss letter using three colors ||
--|| and using three times the draw_string_Helvetica_10 function in offset                    || 
--++------------------------------------------------------------------------------------------++
function M_WRITING.draw_string_Helvetica_10_emboss(x1, y1, text, colors)

    local ox1 = x1 or 0
    local oy1 = y1 or 0
    local text = text or "please give me a text"

    local x1 = ox1 + 1
    local y1 = oy1 
    glColor4f(M_COLORS.WHITE.red, M_COLORS.WHITE.green, M_COLORS.WHITE.blue, (0.8*colors[1].alpha))
    draw_string_Helvetica_10(x1, y1, text)
    
    x1 = ox1 - 1
    y1 = oy1 - 1
    glColor4f(M_COLORS.BLACK.red, M_COLORS.BLACK.green, M_COLORS.BLACK.blue, (0.8*colors[1].alpha))
    draw_string_Helvetica_10(x1, y1, text)
    
    glColor4f(colors[1].rgb.red, colors[1].rgb.green, colors[1].rgb.blue, colors[1].alpha)
    draw_string_Helvetica_10(ox1, oy1, text)
end

--++------------------------------------------------------------------------------------------++
--|| M_WRITING.draw_string_Helvetica_12_emboss() Simulate an emboss letter using three colors ||
--|| and using three times the draw_string_Helvetica_12 function in offset                    || 
--++------------------------------------------------------------------------------------------++
function M_WRITING.draw_string_Helvetica_12_emboss(x1, y1, text, colors)

    local ox1 = x1 or 0
    local oy1 = y1 or 0
    local text = text or "please give me a text"

    local x1 = ox1 + 1
    local y1 = oy1 
    glColor4f(M_COLORS.WHITE.red, M_COLORS.WHITE.green, M_COLORS.WHITE.blue, (0.8*colors[1].alpha))
    draw_string_Helvetica_12(x1, y1, text)
    
    x1 = ox1 - 1
    y1 = oy1 - 1
    glColor4f(M_COLORS.BLACK.red, M_COLORS.BLACK.green, M_COLORS.BLACK.blue, (0.8*colors[1].alpha))
    draw_string_Helvetica_12(x1, y1, text)
    
    glColor4f(colors[1].rgb.red, colors[1].rgb.green, colors[1].rgb.blue, colors[1].alpha)
    draw_string_Helvetica_12(ox1, oy1, text)
end

--++------------------------------------------------------------------------------------------++
--|| M_WRITING.draw_string_Helvetica_18_emboss() Simulate an emboss letter using three colors ||
--|| and using three times the draw_string_Helvetica_18 function in offset                    || 
--++------------------------------------------------------------------------------------------++
function M_WRITING.draw_string_Helvetica_18_emboss(x1, y1, text, colors)

    local ox1 = x1 or 0
    local oy1 = y1 or 0
    local text = text or "please give me a text"

    local x1 = ox1 + 1
    local y1 = oy1 
    glColor4f(M_COLORS.WHITE.red, M_COLORS.WHITE.green, M_COLORS.WHITE.blue, (0.8*colors[1].alpha))
    draw_string_Helvetica_18(x1, y1, text)
    
    x1 = ox1 - 1
    y1 = oy1 - 1
    glColor4f(M_COLORS.BLACK.red, M_COLORS.BLACK.green, M_COLORS.BLACK.blue, (0.8*colors[1].alpha))
    draw_string_Helvetica_18(x1, y1, text)
    
    glColor4f(colors[1].rgb.red, colors[1].rgb.green, colors[1].rgb.blue, colors[1].alpha)
    draw_string_Helvetica_18(ox1, oy1, text)
end

--++--------------------------------------------------------------------------------------------++
--|| M_WRITING.draw_string_Times_Roman_10_emboss() Simulate an emboss letter using three colors ||
--|| and using three times the draw_string_Times_Roman_10 function in offset                    || 
--++--------------------------------------------------------------------------------------------++
function M_WRITING.draw_string_Times_Roman_10_emboss(x1, y1, text, colors)

    local ox1 = x1 or 0
    local oy1 = y1 or 0
    local text = text or "please give me a text"

    local x1 = ox1 + 1
    local y1 = oy1 
    glColor4f(M_COLORS.WHITE.red, M_COLORS.WHITE.green, M_COLORS.WHITE.blue, (0.8*colors[1].alpha))
    draw_string_Times_Roman_10(x1, y1, text)
    
    x1 = ox1 - 1
    y1 = oy1 - 1
    glColor4f(M_COLORS.BLACK.red, M_COLORS.BLACK.green, M_COLORS.BLACK.blue, (0.8*colors[1].alpha))
    draw_string_Times_Roman_10(x1, y1, text)
    
    glColor4f(colors[1].rgb.red, colors[1].rgb.green, colors[1].rgb.blue, colors[1].alpha)
    draw_string_Times_Roman_10(ox1, oy1, text)
end

--++--------------------------------------------------------------------------------------------++
--|| M_WRITING.draw_string_Times_Roman_24_emboss() Simulate an emboss letter using three colors ||
--|| and using three times the draw_string_Times_Roman_24 function in offset                    || 
--++--------------------------------------------------------------------------------------------++
function M_WRITING.draw_string_Times_Roman_24_emboss(x1, y1, text, colors)

    local ox1 = x1 or 0
    local oy1 = y1 or 0
    local text = text or "please give me a text"

    local x1 = ox1 + 1
    local y1 = oy1 
    glColor4f(M_COLORS.WHITE.red, M_COLORS.WHITE.green, M_COLORS.WHITE.blue, (0.8*colors[1].alpha))
    draw_string_Times_Roman_24(x1, y1, text)
    
    x1 = ox1 - 1
    y1 = oy1 - 1
    glColor4f(M_COLORS.BLACK.red, M_COLORS.BLACK.green, M_COLORS.BLACK.blue, (0.8*colors[1].alpha))
    draw_string_Times_Roman_24(x1, y1, text)
    
    glColor4f(colors[1].rgb.red, colors[1].rgb.green, colors[1].rgb.blue, colors[1].alpha)
    draw_string_Times_Roman_24(ox1, oy1, text)
end

--+====================================================================+
--|       T H E   F O L L O W I N G   A R E   H I G H   L E V E L      |
--|                W R I T I N G   F U N C T I O N S                   |
--|                                                                    |
--| CONVENTION: These functions use Uper Camel Case without underscore |
--+====================================================================+

--++-----------------------------------------------------------------------------++
--|| M_WRITING.SetWritingProperties() set the writing properties for any writing || 
--++-----------------------------------------------------------------------------++
function M_WRITING.SetWritingProperties(text,font_pseudo,parent_coordinates,horizontal_type,horizontal_value,vertical_type,vertical_value)

    local writing = {
        text = text,
        font_pseudo = font_pseudo, 
        parent_coordinates = parent_coordinates,
        horizontal_type = horizontal_type,
        horizontal_value = horizontal_value,
        vertical_type = vertical_type,
        vertical_value = vertical_value
    }
    
    return writing
end

--++-----------------------------------------------------------------------++
--|| M_WRITING.GetDrawingCoordinates() get the coordinates for any writing || 
--++-----------------------------------------------------------------------++
function M_WRITING.GetWritingCoordinates(writing)

    local font_pseudo = M_UTILITIES.ItemListValid(M_WRITING.fonts_pseudo_valid,string.upper(writing.font_pseudo)) and string.upper(writing.font_pseudo) or "H10"

    -- Calculate the width and the height of the text
    local text_width = measure_string(writing.text,M_WRITING.FONTS[font_pseudo].name)
    local text_height = M_WRITING.get_height_in_pixel(font_pseudo)

    -- Get the width and the height of the parent
    local parent_width = writing.parent_coordinates.width
    local parent_height = writing.parent_coordinates.height

    -- Set the shift factor for translation (x and y) 
    local shift_factor_x = 0
    local shift_factor_y = 0

    local child_coordinates = {}

    child_coordinates.is_a_drawing = false
    child_coordinates.width = text_width
    child_coordinates.height = text_height

    if writing.parent_coordinates.is_a_drawing then
        -- Set the child at the bottom left into the parent's rectangle (coordinates)
        child_coordinates.x1 = writing.parent_coordinates.x1
        child_coordinates.y1 = writing.parent_coordinates.y2
    else
        -- Set the child just bellow and left a parent's writing
        child_coordinates.x1 = writing.parent_coordinates.x1
        child_coordinates.y1 = writing.parent_coordinates.y1-text_height
    end
    
    -----------------------------
    -- Horizontal displacement --
    -----------------------------
    if writing.horizontal_type == M_COMPONENTS.position.LEFT then
        shift_factor_x = writing.horizontal_value
    end 
    
    if writing.horizontal_type == M_COMPONENTS.position.RIGHT then
        shift_factor_x = parent_width - text_width - writing.horizontal_value
    end 
    
    if writing.horizontal_type == M_COMPONENTS.position.CENTER then
        shift_factor_x = (parent_width - text_width) / 2
    end 
    
    ---------------------------
    -- Vertical displacement --
    ---------------------------
    if writing.vertical_type == M_COMPONENTS.position.TOP then
        shift_factor_y = parent_height - text_height - writing.vertical_value
    end 
    
    if writing.vertical_type == M_COMPONENTS.position.BOTTOM then
        if writing.parent_coordinates.is_a_drawing then
            shift_factor_y = writing.vertical_value
        else
            shift_factor_y = 0
        end 
    end 
    
    if writing.vertical_type == M_COMPONENTS.position.CENTER then
        if writing.parent_coordinates.is_a_drawing then
            shift_factor_y = (parent_height - text_height) / 2
        else
            shift_factor_y = 0
        end 
    end 
    
    ----------------------------------------------------------------------
    -- Shift child coordinates according to the shift factor (x and y)  --
    -- Important Note : do not allow to exceed the limits of the screen --
    ----------------------------------------------------------------------
    child_coordinates.x1 = child_coordinates.x1 + shift_factor_x

    if child_coordinates.x1 < 0 then 
        child_coordinates.x1 = 0
    end

    if child_coordinates.x1 + text_width > SCREEN_WIDTH then 
        child_coordinates.x1 = SCREEN_WIDTH - text_width
    end

    child_coordinates.y1 = child_coordinates.y1 + shift_factor_y 
    
    if child_coordinates.y1 > SCREEN_HIGHT then 
        child_coordinates.y1 = SCREEN_HIGHT - text_height
    end
    
    if child_coordinates.y1 < 0 then 
        child_coordinates.y1 = 0
    end

    return child_coordinates
end 

--++--------------------------------------------------------------------------++
--|| M_WRITING.WritingText write a text according to its properties and color ||
--++--------------------------------------------------------------------------++
function M_WRITING.WritingText(writing,colors)

    local coordinates = M_WRITING.GetWritingCoordinates(writing)
    M_WRITING.write(coordinates,colors,writing)

    return coordinates
end

return M_WRITING