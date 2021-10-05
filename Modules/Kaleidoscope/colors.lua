--[[
##    ##    ###    ##       ######## #### ########   #######   ######   ######   #######  ########  ######## 
##   ##    ## ##   ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##     ## ##       
##  ##    ##   ##  ##       ##        ##  ##     ## ##     ## ##       ##       ##     ## ##     ## ##       
#####    ##     ## ##       ######    ##  ##     ## ##     ##  ######  ##       ##     ## ########  ######   
##  ##   ######### ##       ##        ##  ##     ## ##     ##       ## ##       ##     ## ##        ##       
##   ##  ##     ## ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##        ##       
##    ## ##     ## ######## ######## #### ########   #######   ######   ######   #######  ##        ########  COLORS

Kaleidoscope Colors module By Coussini 2021
]]     
                                                                                                                                                                                                         
--+========================================+
--|  R E Q U I R E D   L I B R A R I E S   |
--+========================================+
local M_UTILITIES = require("Kaleidoscope.utilities")

--+==================================+
--|  L O C A L   V A R I A B L E S   |
--+==================================================================+
--| They will be available when this library has loaded with require |
--+==================================================================+
local M_COLORS = {}

--++---------------------------------------------------------------------------++
--|| M_COLORS.Hex2RGB() return the individual R,G,B values for a one hex color || 
--++---------------------------------------------------------------------------++
function M_COLORS.Hex2RGB(hex)

    local hex = hex:gsub("#","")
    local R,G,B
    
    if hex:len() == 3 then
        R = M_UTILITIES.Round(((tonumber("0x"..hex:sub(1,1))*17)/255),2)
        G = M_UTILITIES.Round(((tonumber("0x"..hex:sub(2,2))*17)/255),2)
        B = M_UTILITIES.Round(((tonumber("0x"..hex:sub(3,3))*17)/255),2)
    else
        R = M_UTILITIES.Round((tonumber("0x"..hex:sub(1,2))/255),2)
        G = M_UTILITIES.Round((tonumber("0x"..hex:sub(3,4))/255),2)
        B = M_UTILITIES.Round((tonumber("0x"..hex:sub(5,6))/255),2)
    end

    return R,G,B
end

--++------------------------------------------------------------------++
--|| M_COLORS.RGB2Array return a special array format for a RGB color || 
--++------------------------------------------------------------------++
function M_COLORS.RGB2Array(R,G,B)

    local array = {}
    array.red = R
    array.green = G
    array.blue = B

    return array
end

--++--------------------------------------------------------------------++
--|| M_COLORS.Hex2Array() return a special array format for a hex color || 
--++--------------------------------------------------------------------++
function M_COLORS.Hex2Array(hex)

    local array = M_COLORS.RGB2Array(M_COLORS.Hex2RGB(hex))
    
    return array
end
    
    ---------------------------------------------
    -- BASIC 16 VGA COLORS DEFINED IN THE HTML --
    ---------------------------------------------
    M_COLORS.AQUA = {red=0,green=1,blue=1}
    M_COLORS.BLACK = {red=0,green=0,blue=0}
    M_COLORS.BLUE = {red=0,green=0,blue=1}
    M_COLORS.FUCHSIA = {red=1,green=0,blue=1}
    M_COLORS.GREY = {red=0.5,green=0.5,blue=0.5}
    M_COLORS.GREEN = {red=0,green=0.5,blue=0}
    M_COLORS.LIME = {red=0,green=1,blue=0}
    M_COLORS.MAROON = {red=0.5,green=0,blue=0}
    M_COLORS.NAVY = {red=0,green=0,blue=0.5}
    M_COLORS.OLIVE = {red=0.5,green=0.5,blue=0}
    M_COLORS.PURPLE = {red=0.5,green=0,blue=0.5}
    M_COLORS.RED = {red=1,green=0,blue=0}
    M_COLORS.SILVER = {red=0.75,green=0.75,blue=0.75}
    M_COLORS.TEAL = {red=0,green=0.5,blue=0.5}
    M_COLORS.WHITE = {red=1,green=1,blue=1}
    M_COLORS.YELLOW = {red=1,green=1,blue=0}

    -------------------
    -- THEMES COLORS --
    -------------------

    -- XPLANE11 --
    --gunmetal (243241)
    --Rich Black FOGRA 29 (131C24)
    --white
    --blue jeans (30A1F2)
    --white
    M_COLORS.XPLANE11 = {
        center = M_COLORS.Hex2Array('#243241'),
        border = M_COLORS.Hex2Array('#131C24'),
        text = M_COLORS.Hex2Array('#FFFFFF'),
        button = M_COLORS.Hex2Array('#30A1F2'),
        text_button = M_COLORS.Hex2Array('#FFFFFF')
    }

    -- TOLISS --
    --dark cyan (2B8890)
    --gunmetal (243241)
    --white
    --maximum blue green (3CC1CB)
    --white
    M_COLORS.TOLISS = {
        center = M_COLORS.Hex2Array('#2B8890'),
        border = M_COLORS.Hex2Array('#243241'),
        text = M_COLORS.Hex2Array('#FFFFFF'),
        button = M_COLORS.Hex2Array('#3CC1CB'),
        text_button = M_COLORS.Hex2Array('#FFFFFF')
    }

    -- CHERRY --
    --auburn (9E2626)
    --dark_byzantium (4E2D3D)
    --white
    --middle red (E9866F)
    --black
    M_COLORS.CHERRY = {
        center = M_COLORS.Hex2Array('#9E2626'),
        border = M_COLORS.Hex2Array('#4E2D3D'),
        text = M_COLORS.Hex2Array('#FFFFFF'),
        button = M_COLORS.Hex2Array('#E9866F'),
        text_button = M_COLORS.Hex2Array('#FFFFFF')
    }

    -- WOOD --
    --brown (7D4B0A)
    --camel (BE9156)
    --white
    --peach crayola (FFCFAB)
    --black
    M_COLORS.WOOD = {
        center = M_COLORS.Hex2Array('#7D4B0A'),
        border = M_COLORS.Hex2Array('#BE9156'),
        text = M_COLORS.Hex2Array('#FFFFFF'),
        button = M_COLORS.Hex2Array('#FFCFAB'),
        text_button = M_COLORS.Hex2Array('#000000')
    }

    -- PLUM --
    --orange yellow crayola (F6D567)
    --old mauve (4E2A30)
    --black
    --harvest gold (CF933C)
    --white
    M_COLORS.PLUM = {
        center = M_COLORS.Hex2Array('#F6D567'),
        border = M_COLORS.Hex2Array('#4E2A30'),
        text = M_COLORS.Hex2Array('#000000'),
        button = M_COLORS.Hex2Array('#CF933C'),
        text_button = M_COLORS.Hex2Array('#FFFFFF')
    }

    -- PACIFIC --
    --baby blue eyes (ABCDFF)
    --space cadet (35355A)
    --black
    --french blue (0072BB)
    --white
    M_COLORS.PACIFIC = {
        center = M_COLORS.Hex2Array('#ABCDFF'),
        border = M_COLORS.Hex2Array('#35355A'),
        text = M_COLORS.Hex2Array('#000000'),
        button = M_COLORS.Hex2Array('#0072BB'),
        text_button = M_COLORS.Hex2Array('#FFFFFF')
    }

    -- PEACH --
    --Indian Yellow (EEAD5B)
    --Auburn (9A3232)
    --black
    --Salmon (FB7F71)
    --black
    M_COLORS.PEACH = {
        center = M_COLORS.Hex2Array('#EEAD5B'),
        border = M_COLORS.Hex2Array('#9A3232'),
        text = M_COLORS.Hex2Array('#000000'),
        button = M_COLORS.Hex2Array('#FB7F71'),
        text_button = M_COLORS.Hex2Array('#FFFFFF')
    }

    -- FOREST --
    --citron (93A626)
    --army green (3B5013)
    --black
    --Sage (D6CA99)
    --black
    M_COLORS.FOREST = {
        center = M_COLORS.Hex2Array('#93A626'),
        border = M_COLORS.Hex2Array('#3B5013'),
        text = M_COLORS.Hex2Array('#000000'),
        button = M_COLORS.Hex2Array('#D6CA99'),
        text_button = M_COLORS.Hex2Array('#000000')
    }

    -- EGGPLANT --
    --pink lavender (D4B2D8)
    --russian violet (400355)
    --black
    --green yellow crayola (E8DE94)
    --black
    M_COLORS.EGGPLANT = {
        center = M_COLORS.Hex2Array('#D4B2D8'),
        border = M_COLORS.Hex2Array('#400355'),
        text = M_COLORS.Hex2Array('#000000'),
        button = M_COLORS.Hex2Array('#E8DE94'),
        text_button = M_COLORS.Hex2Array('#000000')
    }

    -- CARAIBE --
    --robin egg blue (0AC9C4)
    --blue sapphire (035273)
    --black
    --green 0165BA (009AB8)
    --white
    M_COLORS.CARAIBE = {
        center = M_COLORS.Hex2Array('#0AC9C4'),
        border = M_COLORS.Hex2Array('#035273'),
        text = M_COLORS.Hex2Array('#000000'),
        button = M_COLORS.Hex2Array('#009AB8'),
        text_button = M_COLORS.Hex2Array('#FFFFFF')
    }

    -- AVOCADO --
    --middle green yellow (B9CA63)
    --olive drab 7 (473D25)
    --black
    --brown (8B5017)
    --white
    M_COLORS.AVOCADO = {
        center = M_COLORS.Hex2Array('#B9CA63'),
        border = M_COLORS.Hex2Array('#473D25'),
        text = M_COLORS.Hex2Array('#000000'),
        button = M_COLORS.Hex2Array('#8B5017'),
        text_button = M_COLORS.Hex2Array('#FFFFFF')
    }

    M_COLORS.basic_writing_valid = {"black","blue","cyan","green","grey","magenta","red","white","yellow"}
    M_COLORS.RGB_valid = {"red","green","blue"}

    M_COLORS.themes_name = {
        XPLANE11 = "XPLANE11",
        TOLISS = "TOLISS",
        CHERRY = "CHERRY",
        WOOD = "WOOD",
        PLUM = "PLUM",
        PACIFIC = "PACIFIC",
        PEACH = "PEACH",
        FOREST = "FOREST",
        EGGPLANT = "EGGPLANT",
        CARAIBE = "CARAIBE",
        AVOCADO = "AVOCADO"
    }
    M_COLORS.themes_name_valid = {"XPLANE11","TOLISS","CHERRY","WOOD","PLUM","PACIFIC","PEACH","FOREST","EGGPLANT","CARAIBE","AVOCADO"}

--+====================================================================+
--|       T H E   F O L L O W I N G   A R E   H I G H   L E V E L      |
--|                  C O L O R   F U N C T I O N S                     |
--|                                                                    |
--| CONVENTION: These functions use Uper Camel Case without underscore |
--+====================================================================+

--++----------------------------------------------------------++
--|| M_COLORS.ColorValid() validate if a color table is valid || 
--++----------------------------------------------------------++
function M_COLORS.ColorValid(color)

    local count_match = 0

    if type(color) == "table" then 

        local color_table = M_UTILITIES.CountedTable(color)

        if color_table.keyCount == 3 and color_table.entriesCount == 3 then
            for key, value in next, color do
                if M_UTILITIES.ItemListValid(M_COLORS.RGB_valid,key) and value >= 0 and value <= 1 then
                    count_match = count_match + 1
                end
            end
        end
    end
    return (count_match == 3 and true or false)
end

--++------------------------------------------------------------------------++
--|| M_COLORS.ColorsValid() validate if a colors table (3 entries) is valid || 
--++------------------------------------------------------------------------++
function M_COLORS.ColorsValid(colors)

    local count_match = 0

    if type(colors) == "table" then 
        for i = 1, #colors do
            if M_COLORS.ColorValid(colors[i].rgb) and (colors[i].alpha >= 0 or colors[i].alpha <= 1) then 
                count_match = count_match + 1
            end
        end
    end
    return (count_match == 3 and true or false)
end

--++--------------------------------------------------------------------------++
--|| M_COLORS.SetColors() Set the color parameters with 3 entries             || 
--||                                                                          || 
--|| N.B: alpha = transparency level (0 thru 1)                               || 
--||      color_center  = Require one of the basic VGA color or custom colors || 
--||      color_border = Require one of the basic VGA color or custom colors  || 
--||      color_text = Require one of the basic VGA color or custom colors.   || 
--||                                                                          || 
--||      The color_center is use for a drawing or writing                    || 
--||      The color_border is use for a border or another special thing       || 
--++--------------------------------------------------------------------------++
function M_COLORS.SetColors(alpha,color_center,color_border,color_text)

    color_center = color_center or M_COLORS.BLACK
    color_border = color_border or color_center
    color_text = color_text or color_center

    local colors = {
        {rgb = color_center,alpha = alpha}, 
        {rgb = color_border,alpha = alpha},  
        {rgb = color_text,alpha = alpha}  
    }

    return colors
end

--++------------------------------------------------------------------------------++
--|| M_COLORS.SetColorsTheme() Set the color parameters with alpha and theme name || 
--||                                                                              || 
--|| N.B: alpha = transparency level (0 thru 1)                                   || 
--++------------------------------------------------------------------------------++
function M_COLORS.SetColorsTheme(alpha,theme_name)

    color_center = M_COLORS[theme_name].center
    color_border = M_COLORS[theme_name].border
    color_text = M_COLORS[theme_name].text

    local colors = {
        {rgb = color_center,alpha = alpha}, 
        {rgb = color_border,alpha = alpha}, 
        {rgb = color_text,alpha = alpha} 
    }

    return colors
end

--++------------------------------------------------------------------------------------++
--|| M_COLORS.SetColorsThemeButton() Set the color parameters with alpha and theme name || 
--||                                                                                    || 
--|| N.B: alpha = transparency level (0 thru 1)                                         || 
--++------------------------------------------------------------------------------------++
function M_COLORS.SetColorsThemeButton(alpha,theme_name)

    color_center = M_COLORS[theme_name].button
    color_border = M_COLORS[theme_name].border
    color_text = M_COLORS[theme_name].text_button

    local colors = {
        {rgb = color_center,alpha = alpha}, 
        {rgb = color_border,alpha = alpha}, 
        {rgb = color_text,alpha = alpha} 
    }

    return colors
end

return M_COLORS