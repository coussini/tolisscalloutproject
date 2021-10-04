--[[
##    ##    ###    ##       ######## #### ########   #######   ######   ######   #######  ########  ######## 
##   ##    ## ##   ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##     ## ##       
##  ##    ##   ##  ##       ##        ##  ##     ## ##     ## ##       ##       ##     ## ##     ## ##       
#####    ##     ## ##       ######    ##  ##     ## ##     ##  ######  ##       ##     ## ########  ######   
##  ##   ######### ##       ##        ##  ##     ## ##     ##       ## ##       ##     ## ##        ##       
##   ##  ##     ## ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##        ##       
##    ## ##     ## ######## ######## #### ########   #######   ######   ######   #######  ##        ########  COMPONENTS 

Kaleidoscope Components module By Coussini 2021
]]                                                                                                                                                                               

--+==================================+
--|  L O C A L   V A R I A B L E S   |
--+==================================+
    local M_COMPONENTS = {}
    
    -- Components shape type 
    M_COMPONENTS.type = {
        DRAWING = "drawing",
        WRITING = "writing"
    }
    M_COMPONENTS.type_valid = {"drawing","writing"}
    
    -- Components shape type 
    M_COMPONENTS.shape_type = {
        R   = "rectangle",
        RO  = "rectangle outlined",
        RRC = "rectangle with rounded corner",
        RBC = "rectangle with beveled corner",
        C   = "capsule",
        HH  = "horizontal honeycomb",
        VH  = "vertical honeycomb"
    }
    M_COMPONENTS.shape_type_valid = {
        "rectangle","rectangle outlined","rectangle with rounded corner",
        "rectangle with beveled corner","capsule","horizontal honeycomb",
        "vertical honeycomb"
    }

    -- Define the major positions
    M_COMPONENTS.position = {
        TOP = "t",
        BOTTOM = "b",
        LEFT = "l",
        RIGHT = "r",
        CENTER = "c"    
    }
    M_COMPONENTS.position_valid = {"t","b","l","r","c"}
    M_COMPONENTS.horizontal_position_valid = {"l","r","c"}
    M_COMPONENTS.vertical_position_valid = {"t","b","c"}

    -- Coordinates of the x-plane 11 windows
    M_COMPONENTS.screen_coordinates = {
        x1 = 0,
        y1 = SCREEN_HIGHT,
        x2 = SCREEN_WIDTH,
        y2 = 0,
        width = SCREEN_WIDTH,
        height = SCREEN_HIGHT,
        is_a_drawing=true
    }

return M_COMPONENTS