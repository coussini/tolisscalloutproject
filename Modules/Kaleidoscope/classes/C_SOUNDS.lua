--[[
##    ##    ###    ##       ######## #### ########   #######   ######   ######   #######  ########  ######## 
##   ##    ## ##   ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##     ## ##       
##  ##    ##   ##  ##       ##        ##  ##     ## ##     ## ##       ##       ##     ## ##     ## ##       
#####    ##     ## ##       ######    ##  ##     ## ##     ##  ######  ##       ##     ## ########  ######   
##  ##   ######### ##       ##        ##  ##     ## ##     ##       ## ##       ##     ## ##        ##       
##   ##  ##     ## ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##        ##       
##    ## ##     ## ######## ######## #### ########   #######   ######   ######   #######  ##        ########  C_SOUNDS 

Kaleidoscope C_SOUNDS class By Coussini 2021
]]                                                                                                                                                                               
                                                                                                                                                                                                         
--+========================================+
--|  R E Q U I R E D   L I B R A R I E S   |
--+========================================+
local M_UTILITIES = require("Kaleidoscope.utilities")
 
-- DATAREF REQUIRED FOR C_SOUNDS CLASS
DataRef("C_SOUNDS_total_running_time_sec","sim/time/total_running_time_sec","readonly")

--+======================================================================+
--|                    T H E   F O L L O W I N G   I S                   |
--|        T H E   S O U N D S   C L A S S   D E F I N I T I O N S       |
--+======================================================================+

-------------------------------------
-- ATTRIBUTES FOR THE SOUNDS CLASS --
-------------------------------------
local C_SOUNDS = {
    gap = 0.25,
    directory = "",
    -----------------------
    -- SOUND IMFORMATION --
    -----------------------
    sounds_informations = {}, -- Informations for each sounds (indexed by "sound name")
--    The sounds_informations contains these folowing element:
--    isPlayed : a played status for each sound sources (use a name as index)
--    source_pointer : a pointer for each sound sources (use a name as index)
--    duration : a duration in seconds for each sound sources (use a name as index)
    -----------------------------------------
    -- STACK FOR PROCESSING SOUND SOURCES --
    ----------------------------------------
    sounds_queue = {} -- (INDEXED BY NUMBER)
}
--    The sounds_queue contains these folowing element:
--    name = "", -- the sound name as reference (for to tostring for any number)
--    stop_at = 0, -- when the sound will be playing (time out)
--    extra_gap = 0 -- An extra gap to add to the stop_at value

--------------------------------------
-- CONSTRUCTOR FOR THE SOUNDS CLASS --
--------------------------------------
C_SOUNDS.__index = C_SOUNDS

setmetatable(C_SOUNDS, {
    __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
    end,
})

function C_SOUNDS:_init(directory,list_sounds,gap,sound_gain)
    C_SOUNDS:set_sounds_directory(directory)
    C_SOUNDS:initialise_the_sounds_informations(list_sounds,sound_gain)
    C_SOUNDS:set_default_gap_for_sounds_in_stack(gap)    
end

----------------------------------
-- METHODS FOR THE SOUNDS CLASS --
----------------------------------

--++----------------------------------------------------------------------------------++
--|| C_SOUNDS:set_sounds_directory() Set the name of the folder that containts sounds || 
--++----------------------------------------------------------------------------------++
function C_SOUNDS:set_sounds_directory(directory)
    self.directory = directory
end

--++-------------------------------------------------------------------------------------------++
--|| C_SOUNDS:initialise_the_sounds_informations() Initialise some information for each sounds || 
--++-------------------------------------------------------------------------------------------++
function C_SOUNDS:initialise_the_sounds_informations(list_sounds,sound_gain)
    for a_sound = 1, #list_sounds do
        local sound_name = tostring(list_sounds[a_sound])
        local file_name = self.directory..sound_name..".wav"
        -- GET DURATION 
        local libs_file = io.open(file_name,"r")
        local size = M_UTILITIES.FindSize(libs_file)
        libs_file:close()
        self.sounds_informations_elements = {
            isPlayed = false,
            source_pointer = load_WAV_file(file_name),
            duration = size / (16000 * 2 * 16 /8)
        }
        self.sounds_informations[sound_name] = self.sounds_informations_elements
        set_sound_gain(self.sounds_informations[sound_name].source_pointer, sound_gain)
    end
end

--++----------------------------------------------------------------------------------------------++
--|| C_SOUNDS:set_default_gap_between_sounds_in_stack() Set the gap value for the sounds in stack || 
--++----------------------------------------------------------------------------------------------++
function C_SOUNDS:set_default_gap_for_sounds_in_stack(gap)
    self.gap = gap
end

--++-----------------------------------------------------------------------------++
--|| C_SOUNDS:reset_isPlayed_flags_to_false() Reset the is played flags to false || 
--++-----------------------------------------------------------------------------++
function C_SOUNDS:reset_isPlayed_flags_to_false(list_sounds)
    for a_sound = 1, #list_sounds do
        local sound_name = tostring(list_sounds[a_sound])
        self.sounds_informations[sound_name].isPlayed = false
    end
end

--++-------------------------------------------------------++
--|| C_SOUNDS:set_isPlayed_flags() Set the is played flags || 
--++-------------------------------------------------------++
function C_SOUNDS:set_isPlayed_flags(sound_name,is_played)
    sound_name = tostring(sound_name)
    self.sounds_informations[sound_name].isPlayed = is_played
end

--++--------------------------------------------------------++
--|| C_SOUNDS:insert() Insert a sound into the sounds stack || 
--++--------------------------------------------------------++
function C_SOUNDS:insert(sound_name,extra_gap)

    local var_extra_gap = extra_gap or 0
    sound_name = tostring(sound_name)
    self.sounds_informations[sound_name].isPlayed = true  
    self.sounds_queue_elements = {
        name = sound_name,
        stop_at = nil,
        extra_gap = var_extra_gap
    }

    table.insert(self.sounds_queue,self.sounds_queue_elements) -- add this element to the end of sounds_queue
    M_UTILITIES.OutputLog("insert A Sound In Sound Queue : "..sound_name)
end

--++------------------------------------------------------------------++
--|| C_SOUNDS:insert() Insert a number as sound into the sounds stack || 
--++------------------------------------------------------------------++
function C_SOUNDS:insert_number(number,extra_gap)
    local i = 0
    local nb_of_words = 0
    str = M_UTILITIES.NumberInWords(number)
    _,nb_of_words = str:gsub("%S+","")
    for word in str:gmatch("%S+") do
        i = i + 1
        if i == nb_of_words then extra_gap = 0 end -- add a gap
        C_SOUNDS:insert(word,extra_gap)
    end
end

--++------------------------------------------------------------++
--|| C_SOUNDS:is_played() Return a played flag for a sound name || 
--++------------------------------------------------------------++
function C_SOUNDS:is_played(sound_name)
    sound_name = tostring(sound_name)
    return self.sounds_informations[sound_name].isPlayed
end

--++-------------------------------------------------------------------------------------------------------------++
--|| C_SOUNDS:play_the_first() Play the first sound in the queue, then set the get the duration for the time out || 
--++-------------------------------------------------------------------------------------------------------------++
function C_SOUNDS:play_the_first(index)
    local sound_name = self.sounds_queue[1].name
    local extra_gap = self.sounds_queue[1].extra_gap
    play_sound(self.sounds_informations[sound_name].source_pointer)
    self.sounds_queue[1].stop_at = M_UTILITIES.SetTimer(self.sounds_informations[sound_name].duration) + extra_gap
    M_UTILITIES.OutputLog("play the sound : "..sound_name.." stop At "..self.sounds_queue[1].stop_at.." current "..C_SOUNDS_total_running_time_sec)
end 

--++-------------------------------------------------------------------------------------------------------------++
--|| C_SOUNDS:process_sounds_queue() Check if a sound can be play and check if a sound has finished to delete it || 
--++-------------------------------------------------------------------------------------------------------------++
function C_SOUNDS:process_sounds_queue()
    -- find if something playing
    if #self.sounds_queue ~= 0 then
        -- find if a sound can be play
        if self.sounds_queue[1].stop_at == nil then
            C_SOUNDS:play_the_first()
        else
            if self.sounds_queue[1].stop_at < C_SOUNDS_total_running_time_sec then
                -- delete the current sound that has finish to play
                table.remove(self.sounds_queue, 1)
            end
        end
    end
end 

--++-------------------------------------------------------------------------------------------------------------++
--|| C_SOUNDS:play_the_first() Play the first sound in the queue, then set the get the duration for the time out || 
--++-------------------------------------------------------------------------------------------------------------++
function C_SOUNDS:reset_and_insert(sound_name,extra_gap)
    C_SOUNDS:set_isPlayed_flags(sound_name,false)
    C_SOUNDS:insert(sound_name,extra_gap)
end 

return C_SOUNDS