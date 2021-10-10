--[[
##    ##    ###    ##       ######## #### ########   #######   ######   ######   #######  ########  ######## 
##   ##    ## ##   ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##     ## ##       
##  ##    ##   ##  ##       ##        ##  ##     ## ##     ## ##       ##       ##     ## ##     ## ##       
#####    ##     ## ##       ######    ##  ##     ## ##     ##  ######  ##       ##     ## ########  ######   
##  ##   ######### ##       ##        ##  ##     ## ##     ##       ## ##       ##     ## ##        ##       
##   ##  ##     ## ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##        ##       
##    ## ##     ## ######## ######## #### ########   #######   ######   ######   #######  ##        ########  DRAWING 

Kaleidoscope Drawing module By Coussini 2021
]]                                                                                                                                                                               
                                                                                                                                                                                                         
--+========================================+
--|  R E Q U I R E D   L I B R A R I E S   |
--+========================================+
local I_GRAPHICS = require("graphics")
local M_COMPONENTS = require("Kaleidoscope.components")

--+==================================+
--|  L O C A L   V A R I A B L E S   |
--+==================================================================+
--| They will be available when this library has loaded with require |
--+==================================================================+
local M_DRAWING = {}

-- THE TOP_BOTTOM_CORNER_HEIGHT CHANGE THE APPARENCE OF THE ROUND CORNER
-- CAN BE CHANGE USING M_DRAWING.SETTOPBOTTOMCORNERHEIGHT()
M_DRAWING.TOP_BOTTOM_CORNER_HEIGHT = 10

--+==============================================================+
--|    T H E   F O L L O W I N G   A R E   L O W   L E V E L     |
--|           D R A W I N G   F U N C T I O N S                  |
--|                                                              |
--| CONVENTION: These functions are lowercase and use underscore |
--+==============================================================+

--++------------------------------------------------------------------------------------------------------------------------------++
--|| M_DRAWING.draw_rectangle() Draw a 2d 4-sided flat shape with straight sides where all interior angles are right angles (90°).|| 
--|| Also opposite sides are parallel and of equal length.                                                                        ||
--++------------------------------------------------------------------------------------------------------------------------------++
function M_DRAWING.draw_rectangle(coordinates,color)

    -- set color
    glColor4f(color.rgb.red, color.rgb.green, color.rgb.blue, color.alpha)
    
    local x1 = coordinates.x1 or 0
    local y1 = coordinates.y1 or 0
    local x2 = coordinates.x2 or 0
    local y2 = coordinates.y2 or 0
    
    if x1 > x2 then
        x1, x2 = x2, x1
    end
    if y1 > y2 then
        y1, y2 = y2, y1
    end

    -- Draw the rectangle
    glRectf(x1, y1, x2, y2)
end

--++------------------------------------------------------------------------------++
--|| M_DRAWING.draw_capsule() Draw a rectangle with two half circles at each end. ||                                                            
--++------------------------------------------------------------------------------++
function M_DRAWING.draw_capsule(coordinates,color)

    -- Set color
    glColor4f(color.rgb.red, color.rgb.green, color.rgb.blue, color.alpha)
    
    local coord = {}
    coord.x1 = coordinates.x1 or 0
    coord.y1 = coordinates.y1 or 0
    coord.x2 = coordinates.x2 or 0
    coord.y2 = coordinates.y2 or 0

    -- Calculate the radius from the half of the rectangle height
    local r = (coord.y1 - coord.y2) / 2

    -- Cut/resize the rectangle to include 2 half circle to give the original width
    coord.x1 = coord.x1 + r
    coord.x2 = coord.x2 - r

    -- calculate the starting point (y) of a drawing for each filled arc
    local y = coord.y2 + r

    -- Add half circles at the end of the rectangle
    if coord.x1 > coord.x2 then
        coord.x1, coord.x2 = coord.x2, coord.x1
    end
    if coord.y1 > coord.y2 then
        coord.y1, coord.y2 = coord.y2, coord.y1
    end

    -- Draw two half circles
    I_GRAPHICS.draw_filled_arc(coord.x1, y, 180, 360, r)
    I_GRAPHICS.draw_filled_arc(coord.x2, y, 0, 180, r)
end

--++-------------------------------------------------------------------------------------++
--|| M_DRAWING.draw_half_capsule() Draw a rectangle with two quarts circles at each end. ||                                                                        
--++-------------------------------------------------------------------------------------++
function M_DRAWING.draw_half_capsule(coordinates,color,top_half)

    -- Set color
    glColor4f(color.rgb.red, color.rgb.green, color.rgb.blue,color.alpha)

    local coord = {}
    coord.x1 = coordinates.x1 or 0
    coord.y1 = coordinates.y1 or 0
    coord.x2 = coordinates.x2 or 0
    coord.y2 = coordinates.y2 or 0

    if top_half == nil then top_half = true end

    -- Calculate the radius on rectangle height
    local r = (coord.y1 - coord.y2)

    -- Cut/resize the rectangle to include 2 quart circle to give the original width
    coord.x2 = coord.x2 - r
    coord.x1 = coord.x1 + r
    
    -- Calculate the center point (coordinate) where the arc are drawing
    local arc_center_y
    if top_half then
        arc_center_y = coord.y2 
    else
        arc_center_y = coord.y1 
    end
    
    -- Draw a rectangle
    M_DRAWING.draw_rectangle(coord,color)
    
    -- Draw two quart circles
    if top_half then
        I_GRAPHICS.draw_filled_arc(coord.x1, arc_center_y, 270, 360, r)
        I_GRAPHICS.draw_filled_arc(coord.x2, arc_center_y, 0, 90, r)
    else 
        I_GRAPHICS.draw_filled_arc(coord.x1, arc_center_y, 180, 270, r)
        I_GRAPHICS.draw_filled_arc(coord.x2, arc_center_y, 90, 180, r)
    end
    
end

--++------------------------------------------------------------------------------------------------++
--|| M_DRAWING.draw_horizontal_honeycomb() Draw a honeycomb in such way that 2 edges are horizontal ||                                                                        
--|| To do that, you have to imagine a rectangle with 2 triangles at the end                        ||                                                                        
--++------------------------------------------------------------------------------------------------++
function M_DRAWING.draw_horizontal_honeycomb(coordinates,color)

    -- Set color
    glColor4f(color.rgb.red, color.rgb.green, color.rgb.blue, color.alpha)
    
    local coord = {}
    coord.x1 = coordinates.x1 or 0
    coord.y1 = coordinates.y1 or 0
    coord.x2 = coordinates.x2 or 0
    coord.y2 = coordinates.y2 or 0

    -- Calculate the radius from the half of the rectangle height
    local r = (coord.y1 - coord.y2) / 2

    -- Cut/resize the rectangle to include 2 half circle to give the original width
    coord.x1 = coord.x1 + r
    coord.x2 = coord.x2 - r

    -- calculate the starting point (y) of a drawing for each filled arc
    local y = coord.y2 + r

    -- Add half circles at the end of the rectangle
    if coord.x1 > coord.x2 then
        coord.x1, coord.x2 = coord.x2, coord.x1
    end
    if coord.y1 > coord.y2 then
        coord.y1, coord.y2 = coord.y2, coord.y1
    end
    
    glBegin_TRIANGLES()
    glVertex2f(coordinates.x1, y)
    glVertex2f(coord.x1, coordinates.y1)
    glVertex2f(coord.x1, coordinates.y2)
    glEnd()
    
    glBegin_TRIANGLES()
    glVertex2f(coordinates.x2, y)
    glVertex2f(coord.x2, coordinates.y2)
    glVertex2f(coord.x2, coordinates.y1)
    glEnd()
end

--++--------------------------------------------------------------------------------------------++
--|| M_DRAWING.draw_vertical_honeycomb() Draw a honeycomb in such way that 2 edges are vertical ||      
--|| To do that, you have to imagine a rectangle with 2 triangles at the end                    ||                                                                        
--++--------------------------------------------------------------------------------------------++
function M_DRAWING.draw_vertical_honeycomb(coordinates,color)

    -- Set color
    glColor4f(color.rgb.red, color.rgb.green, color.rgb.blue, color.alpha)

    local r = (coordinates.y1 - coordinates.y2) / 2
    
    glBegin_TRIANGLES()
    glVertex2f(coordinates.x1+((coordinates.x2-coordinates.x1) / 2), (coordinates.y1+r))
    glVertex2f(coordinates.x2, coordinates.y1)
    glVertex2f(coordinates.x1, coordinates.y1)
    glEnd()
    
    glBegin_TRIANGLES()
    glVertex2f(coordinates.x1+((coordinates.x2-coordinates.x1) / 2), (coordinates.y2-r))
    glVertex2f(coordinates.x1, coordinates.y2)
    glVertex2f(coordinates.x2, coordinates.y2)
    glEnd()
end

--++-----------------------------------------------------------------------------------------------------++
--|| M_DRAWING.draw_half_horizontal_honeycomb() Draw a honeycomb in such way that 2 edges are horizontal ||                                                                      
--|| To do that, you have to imagine a rectangle with 2 triangles at the end BUT, this shape is cut      || 
--|| in its center horizontally                                                                          ||                                                                     
--++-----------------------------------------------------------------------------------------------------++
function M_DRAWING.draw_half_horizontal_honeycomb(coordinates,color,top_half)

    -- Set color
    glColor4f(color.rgb.red, color.rgb.green, color.rgb.blue, color.alpha)
    
    local x1 = coordinates.x1 or 0
    local y1 = coordinates.y1 or 0
    local x2 = coordinates.x2 or 0
    local y2 = coordinates.y2 or 0

    -- keep original x axes
    local ox1 = x1
    local ox2 = x2

    -- Calculate the half of the rectangle height, where to place the vertice for those triangles
    local height = y1 - y2
    local half_height = coordinates.height / 2

    -- Cut/resize the rectangle to include 2 triangles to give the original width
    x2 = x2 - M_DRAWING.TOP_BOTTOM_CORNER_HEIGHT
    x1 = x1 + M_DRAWING.TOP_BOTTOM_CORNER_HEIGHT

    -- draw the half horizontal honeycomb
    if top_half then
        glBegin_POLYGON()
        glVertex2f(ox1, y2)
        glVertex2f(x1, y1)
        glVertex2f(x2, y1)
        glVertex2f(ox2, y2)
        glEnd()
    else 
        glBegin_POLYGON()
        glVertex2f(ox1, y1)
        glVertex2f(ox2, y1)
        glVertex2f(x2, y2)
        glVertex2f(x1, y2)
        glEnd()
    end
end

--+====================================================================+
--|       T H E   F O L L O W I N G   A R E   H I G H   L E V E L      |
--|                D R A W I N G   F U N C T I O N S                   |
--|                                                                    |
--| CONVENTION: These functions use Uper Camel Case without underscore |
--+====================================================================+

--++----------------------------------------------------------------------------------++
--|| M_DRAWING.SetTopBottomCornerHeight() change the default TOP_BOTTOM_CORNER_HEIGHT || 
--++----------------------------------------------------------------------------------++
function M_DRAWING.SetTopBottomCornerHeight(top_bottom_corner_height)

    M_DRAWING.TOP_BOTTOM_CORNER_HEIGHT = top_bottom_corner_height

end

--++-----------------------------------------------------------------------------++
--|| M_DRAWING.SetDrawingProperties() set the drawing properties for any drawing || 
--++-----------------------------------------------------------------------------++
function M_DRAWING.SetDrawingProperties(width,height,border_size,parent_coordinates,horizontal_type,horizontal_value,vertical_type,vertical_value)

    local drawing = {
        width = width,
        height = height, 
        border_size = border_size, 
        parent_coordinates = parent_coordinates,
        horizontal_type = horizontal_type,
        horizontal_value = horizontal_value,
        vertical_type = vertical_type,
        vertical_value = vertical_value
    }

    return drawing
end

--++-----------------------------------------------------------------------++
--|| M_DRAWING.GetDrawingCoordinates() get the coordinates for any drawing || 
--++-----------------------------------------------------------------------++
function M_DRAWING.GetDrawingCoordinates(drawing)

    -- Get the width and the height of the parent
    local parent_width = drawing.parent_coordinates.width
    local parent_height = drawing.parent_coordinates.height

    -- Set the shift factor for translation (x and y) 
    local shift_factor_x = 0
    local shift_factor_y = 0

    local child_coordinates = {}

    child_coordinates.is_a_drawing = true        
    child_coordinates.width = drawing.width
    child_coordinates.height = drawing.height

    if drawing.parent_coordinates.is_a_drawing then
        -- Set the child at the bottom left into the parent's rectangle (coordinates)
        child_coordinates.x1 = drawing.parent_coordinates.x1
        child_coordinates.y1 = drawing.parent_coordinates.y2 + drawing.height
        child_coordinates.x2 = drawing.parent_coordinates.x1 + drawing.width
        child_coordinates.y2 = drawing.parent_coordinates.y2
    else
        -- Set the child just bellow and left a parent's writing
        child_coordinates.x1 = drawing.parent_coordinates.x1
        child_coordinates.y1 = drawing.parent_coordinates.y1
        child_coordinates.x2 = drawing.parent_coordinates.x1 + drawing.width
        child_coordinates.y2 = drawing.parent_coordinates.y1 - drawing.height
    end
    
    -----------------------------
    -- Horizontal displacement --
    -----------------------------
    if drawing.horizontal_type == M_COMPONENTS.position.LEFT then
        shift_factor_x = drawing.horizontal_value
    end 
    
    if drawing.horizontal_type == M_COMPONENTS.position.RIGHT then
        shift_factor_x = parent_width - drawing.width - drawing.horizontal_value
    end 
    
    if drawing.horizontal_type == M_COMPONENTS.position.CENTER then
        shift_factor_x = (parent_width - drawing.width) / 2
    end 
    
    ---------------------------
    -- Vertical displacement --
    ---------------------------
    if drawing.vertical_type == M_COMPONENTS.position.TOP then
        if drawing.parent_coordinates.is_a_drawing then 
            shift_factor_y = parent_height - drawing.height - drawing.vertical_value
        else
            shift_factor_y = 0 - drawing.vertical_value
        end
    end 
    
    if drawing.vertical_type == M_COMPONENTS.position.BOTTOM then
        shift_factor_y = drawing.vertical_value
    end 
    
    if drawing.vertical_type == M_COMPONENTS.position.CENTER then
        if drawing.parent_coordinates.is_a_drawing then 
            shift_factor_y = (parent_height - drawing.height) / 2
        else
            shift_factor_y = 0
        end
    end 
    
    ----------------------------------------------------------------------
    -- Shift child coordinates according to the shift factor (x and y)  --
    -- Important Note : do not allow to exceed the limits of the screen --
    ----------------------------------------------------------------------
    child_coordinates.x1 = child_coordinates.x1 + shift_factor_x 
    child_coordinates.x2 = child_coordinates.x2 + shift_factor_x 
    
    if child_coordinates.x1 < 0 then 
        child_coordinates.x1 = 0
        child_coordinates.x2 = drawing.width 
    end
    
    if child_coordinates.x2 > SCREEN_WIDTH then 
        child_coordinates.x1 = SCREEN_WIDTH - drawing.width
        child_coordinates.x2 = SCREEN_WIDTH 
    end

    child_coordinates.y1 = child_coordinates.y1 + shift_factor_y 
    child_coordinates.y2 = child_coordinates.y2 + shift_factor_y
    
    if child_coordinates.y1 > SCREEN_HIGHT then 
        child_coordinates.y1 = SCREEN_HIGHT
        child_coordinates.y2 = SCREEN_HIGHT - drawing.height 
    end
    
    if child_coordinates.y2 < 0 then 
        child_coordinates.y1 = drawing.heigth
        child_coordinates.y2 = 0 
    end

    return child_coordinates
end 

--++--------------------------------------------------------------------------------------++
--|| M_DRAWING.DrawingRectangle() draw a rectangle according to its properties and colors ||
--||                                                                                      ||
--|| N.B: Depending the border_size values passed in parameter :                          ||
--||      This draws a rectangle with a 4 border having a different color                 ||
--||      Otherwhise, this draws a rectangle with one color                               ||
--++--------------------------------------------------------------------------------------++
function M_DRAWING.DrawingRectangle(drawing,colors)

    -- Get the coordinates of the properties of this drawing
    local coordinates = M_DRAWING.GetDrawingCoordinates(drawing)
    
    --------------------------------------
    -- Create a rectangle with a border --
    --------------------------------------
    if drawing.border_size > 0 then
        M_DRAWING.DrawingRectangleOutlined(drawing,colors) 
        -- Establish a new properties for the rectangle itself (the rectangle without borders)
        local rectangleInside = M_DRAWING.SetDrawingProperties(drawing.width-(drawing.border_size*2),drawing.height-(drawing.border_size*2),0,coordinates,M_COMPONENTS.position.CENTER,0,M_COMPONENTS.position.CENTER,0)
        -- Get the coordinates of this new properties
        -- Draw the rectangle using the center color
        M_DRAWING.draw_rectangle(M_DRAWING.GetDrawingCoordinates(rectangleInside),colors[1])
    -----------------------------------------
    -- Create a rectangle without a border --
    -----------------------------------------
    else 
        -- Draw only a rectangle using the center color
        M_DRAWING.draw_rectangle(coordinates,colors[1])
    end

    -- Return the coordinate of this drawing 
    return coordinates
end

--++-------------------------------------------------------------------------------------------------------++
--|| M_DRAWING.DrawingRectangleOutlined() draw a outlined rectangle according to its properties and colors ||
--++-------------------------------------------------------------------------------------------------------++
function M_DRAWING.DrawingRectangleOutlined(drawing,colors)

    drawing.border_size = drawing.border_size or 1

    -- Get the coordinates of the properties of this drawing
    local coordinates = M_DRAWING.GetDrawingCoordinates(drawing)

    -- Establish a new properties for theses borders using 4 rectangles that do not overlap
    -- We retrieve the coordinates of each of these 4 rectangles in order to position them inside the area of this drawing (parent).
    -- Each rectangle are considered to be a child
    local rectangleA = M_DRAWING.SetDrawingProperties(drawing.border_size,drawing.height-drawing.border_size,0,coordinates,M_COMPONENTS.position.LEFT,0,M_COMPONENTS.position.TOP,0)
    local rectangleB = M_DRAWING.SetDrawingProperties(drawing.width-drawing.border_size,drawing.border_size,0,coordinates,M_COMPONENTS.position.RIGHT,0,M_COMPONENTS.position.TOP,0)
    local rectangleC = M_DRAWING.SetDrawingProperties(drawing.border_size,drawing.height-drawing.border_size,0,coordinates,M_COMPONENTS.position.RIGHT,0,M_COMPONENTS.position.BOTTOM,0)
    local rectangleD = M_DRAWING.SetDrawingProperties(drawing.width-drawing.border_size,drawing.border_size,0,coordinates,M_COMPONENTS.position.LEFT,0,M_COMPONENTS.position.BOTTOM,0)

    -- Get the coordinates of theses 4 properties
    -- Draw the borders using 4 rectangles that do not overlap, using the border color
    M_DRAWING.draw_rectangle(M_DRAWING.GetDrawingCoordinates(rectangleA),colors[2])
    M_DRAWING.draw_rectangle(M_DRAWING.GetDrawingCoordinates(rectangleB),colors[2])
    M_DRAWING.draw_rectangle(M_DRAWING.GetDrawingCoordinates(rectangleC),colors[2])
    M_DRAWING.draw_rectangle(M_DRAWING.GetDrawingCoordinates(rectangleD),colors[2])

    return coordinates
end

--++----------------------------------------------------------------------------------++
--|| M_DRAWING.DrawingCapsule() draw a capsule according to its properties and colors ||
--||                                                                                  ||
--|| N.B: This draws a form with one color only                                       ||
--++----------------------------------------------------------------------------------++
function M_DRAWING.DrawingCapsule(drawing,colors)

    local coordinates = M_DRAWING.GetDrawingCoordinates(drawing)

    -- Calculate the radius from the half of the rectangle height
    local r = (coordinates.y1 - coordinates.y2) / 2
    local rectangleInside = M_DRAWING.SetDrawingProperties(drawing.width-(r*2),drawing.height,drawing.border_size,coordinates,M_COMPONENTS.position.LEFT,r,M_COMPONENTS.position.TOP,0)
    
    M_DRAWING.DrawingRectangle(rectangleInside,colors) 
    M_DRAWING.draw_capsule(coordinates,colors[2])

    return coordinates
end 

--++--------------------------------------------------------------------------------------++
--|| M_DRAWING.DrawingHalfCapsule() draw a capsule according to its properties and colors ||
--||                                                                                      ||
--|| N.B: This draws a form with one color only                                           ||
--++--------------------------------------------------------------------------------------++
function M_DRAWING.DrawingHalfCapsule(drawing,colors,top_half)

    local coordinates = M_DRAWING.GetDrawingCoordinates(drawing)
    M_DRAWING.draw_half_capsule(coordinates,colors[2],top_half)

    return coordinates
end 

--++------------------------------------------------------------------------------------------------++
--|| M_DRAWING.DrawingHorizontalHoneycomb() draw a honeycomb according to its properties and colors ||
--||                                                                                                ||
--|| N.B: This draws a form with one color only                                                     ||
--++------------------------------------------------------------------------------------------------++
function M_DRAWING.DrawingHorizontalHoneycomb(drawing,colors)

    local coordinates = M_DRAWING.GetDrawingCoordinates(drawing)

    -- Calculate the radius from the half of the rectangle height
    local r = (coordinates.y1 - coordinates.y2) / 2
    local rectangleInside = M_DRAWING.SetDrawingProperties(drawing.width-(r*2),drawing.height,drawing.border_size,coordinates,M_COMPONENTS.position.LEFT,r,M_COMPONENTS.position.TOP,0)
    
    M_DRAWING.DrawingRectangle(rectangleInside,colors) 
    M_DRAWING.draw_horizontal_honeycomb(coordinates,colors[2])

    return coordinates
end 

--++----------------------------------------------------------------------------------------------++
--|| M_DRAWING.DrawingVerticalHoneycomb() draw a honeycomb according to its properties and colors ||
--||                                                                                              ||
--|| N.B: This draws a form with one color only                                                   ||
--++----------------------------------------------------------------------------------------------++
function M_DRAWING.DrawingVerticalHoneycomb(drawing,colors)

    local coordinates = M_DRAWING.GetDrawingCoordinates(drawing)
    
    M_DRAWING.DrawingRectangle(drawing,colors) 
    M_DRAWING.draw_vertical_honeycomb(coordinates,colors[2])

    return coordinates
end 

--++----------------------------------------------------------------------------------------------------------++
--|| M_DRAWING.DrawingHalfHorizontalHoneycomb() draw an half honeycomb according to its properties and colors ||
--||                                                                                                          ||
--|| N.B: This draws a form with one color only (takes the first color)                                       ||
--++----------------------------------------------------------------------------------------------------------++
function M_DRAWING.DrawingHalfHorizontalHoneycomb(drawing,color,top_half)

    local coordinates = M_DRAWING.GetDrawingCoordinates(drawing)
    M_DRAWING.draw_half_horizontal_honeycomb(coordinates,color,top_half)

    return coordinates
end 

--++---------------------------------------------------------------------------------------------------------------------++
--|| M_DRAWING.DrawingRectangleRoundedCorner() draw a rectangle with round corner according to its properties and colors ||
--||                                                                                                                     ||
--|| N.B: The top and bottom of this rectangle are always different color than the rectangle itself                      ||
--||      Depending the border_size values passed in parameter for this:                                                 ||
--||      This draws a rectangle with a 4 border having a different color                                                ||
--||      Otherwhise, this draws a rectangle with one color                                                              ||
--++---------------------------------------------------------------------------------------------------------------------++
function M_DRAWING.DrawingRectangleRoundedCorner(drawing,colors)

    -- Get the coordinates of the area of this drawing (This is considered to be a parent)
    local parent_coordinates = M_DRAWING.GetDrawingCoordinates(drawing)

    -- Establish the top half capsule & the bottom half capsule
    local top_half_capsule = M_DRAWING.SetDrawingProperties(drawing.width,M_DRAWING.TOP_BOTTOM_CORNER_HEIGHT,0,parent_coordinates,M_COMPONENTS.position.LEFT,0,M_COMPONENTS.position.TOP,0)
    local bottom_half_capsule = M_DRAWING.SetDrawingProperties(drawing.width,M_DRAWING.TOP_BOTTOM_CORNER_HEIGHT,0,parent_coordinates,M_COMPONENTS.position.LEFT,0,M_COMPONENTS.position.BOTTOM,0)
    -- Establish the rectangle
    local rectangleInside = M_DRAWING.SetDrawingProperties(drawing.width,drawing.height-(M_DRAWING.TOP_BOTTOM_CORNER_HEIGHT*2),drawing.border_size,parent_coordinates,M_COMPONENTS.position.LEFT,0,M_COMPONENTS.position.TOP,M_DRAWING.TOP_BOTTOM_CORNER_HEIGHT)

    -- Draw 2 half capsules
    M_DRAWING.DrawingHalfCapsule(top_half_capsule,colors,true)
    M_DRAWING.DrawingHalfCapsule(bottom_half_capsule,colors,false)
    -- Draw the rectangle
    M_DRAWING.DrawingRectangle(rectangleInside,colors)

    return parent_coordinates
end 

--++-----------------------------------------------------------------------------------------------------------------------++
--|| M_DRAWING.DrawingRectangleBeveledCorner() draw a rectangle with beveled corner according to its properties and colors ||
--||                                                                                                                       ||
--|| N.B: The top and bottom of this rectangle are always different color than the rectangle itself                        ||
--||      Depending the border_size values passed in parameter for this:                                                   ||
--||      This draws a rectangle with a 4 border having a different color                                                  ||
--||      Otherwhise, this draws a rectangle with one color                                                                ||
--++-----------------------------------------------------------------------------------------------------------------------++
function M_DRAWING.DrawingRectangleBeveledCorner(drawing,colors)

    -- Get the coordinates of the area of this drawing (This is considered to be a parent)
    local parent_coordinates = M_DRAWING.GetDrawingCoordinates(drawing)

    -- Establish the top half honeycomb & the bottom half honeycomb
    local top_half_honeycomb = M_DRAWING.SetDrawingProperties(drawing.width,M_DRAWING.TOP_BOTTOM_CORNER_HEIGHT,0,parent_coordinates,M_COMPONENTS.position.LEFT,0,M_COMPONENTS.position.TOP,0)
    local bottom_half_honeycomb = M_DRAWING.SetDrawingProperties(drawing.width,M_DRAWING.TOP_BOTTOM_CORNER_HEIGHT,0,parent_coordinates,M_COMPONENTS.position.LEFT,0,M_COMPONENTS.position.BOTTOM,0)
    -- Establish the rectangle
    local rectangleInside = M_DRAWING.SetDrawingProperties(drawing.width,drawing.height-(M_DRAWING.TOP_BOTTOM_CORNER_HEIGHT*2),drawing.border_size,parent_coordinates,M_COMPONENTS.position.LEFT,0,M_COMPONENTS.position.TOP,M_DRAWING.TOP_BOTTOM_CORNER_HEIGHT)

    -- Draw 2 half honeycomb
    M_DRAWING.DrawingHalfHorizontalHoneycomb(top_half_honeycomb,colors[2],true)
    M_DRAWING.DrawingHalfHorizontalHoneycomb(bottom_half_honeycomb,colors[2],false)
    -- Draw the rectangle
    M_DRAWING.DrawingRectangle(rectangleInside,colors)

    return parent_coordinates
end 

return M_DRAWING