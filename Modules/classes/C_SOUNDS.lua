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
    directory_PF = "",
    directory_PM = "",
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
--    pilot = "", -- the pilot can be PF or PM
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

function C_SOUNDS:_init(directory_PF,directory_PM,list_sounds,gap,sound_gain)
    self:set_sounds_directory(directory_PF,directory_PM)
    self:initialise_the_sounds_informations(list_sounds,sound_gain)
    self:set_default_gap_for_sounds_in_stack(gap)    
end

----------------------------------
-- METHODS FOR THE SOUNDS CLASS --
----------------------------------

--++----------------------------------------------------------------------------------++
--|| C_SOUNDS:set_sounds_directory() Set the name of the folder that containts sounds || 
--++----------------------------------------------------------------------------------++
function C_SOUNDS:set_sounds_directory(directory_PF,directory_PM)
    self.directory_PF = directory_PF
    self.directory_PM = directory_PM
end

--++-------------------------------------------------------------------------------------------++
--|| C_SOUNDS:initialise_the_sounds_informations() Initialise some information for each sounds || 
--++-------------------------------------------------------------------------------------------++
function C_SOUNDS:initialise_the_sounds_informations(list_sounds,sound_gain)
    local sounds_informations = {}
    for a_sound = 1, #list_sounds do
        local sound_name = tostring(list_sounds[a_sound])
        -- PROCEED TO PF
        local file_name_PF = self.directory_PF..sound_name..".wav"
        local file_name_PM = self.directory_PM..sound_name..".wav"
        M_UTILITIES.OutputLog("initialise_the_sounds_informations FOR .."..file_name_PF)
        M_UTILITIES.OutputLog("initialise_the_sounds_informations FOR .."..file_name_PM)
        -- GET DURATIONS
        local libs_file_PF = io.open(file_name_PF,"r")
        local size_PF = M_UTILITIES.FindSize(libs_file_PF)
        libs_file_PF:close()
        local libs_file_PM = io.open(file_name_PM,"r")
        local size_PM = M_UTILITIES.FindSize(libs_file_PM)
        libs_file_PM:close()
        local sounds_informations_elements = {
            isPlayed_PF = false,
            isPlayed_PM = false,
            source_pointer_PF = load_WAV_file(file_name_PF),
            source_pointer_PM = load_WAV_file(file_name_PM),
            duration_PF = size_PF / (16000 * 2 * 16 /8),
            duration_PM = size_PM / (16000 * 2 * 16 /8)
        }
        sounds_informations[sound_name] = sounds_informations_elements
        set_sound_gain(sounds_informations[sound_name].source_pointer_PF, sound_gain)
        set_sound_gain(sounds_informations[sound_name].source_pointer_PM, sound_gain)
    end
    self.sounds_informations = sounds_informations
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
        self.sounds_informations[sound_name].isPlayed_PF = false
        self.sounds_informations[sound_name].isPlayed_PM = false
    end
end

--++-------------------------------------------------------++
--|| C_SOUNDS:set_isPlayed_flags() Set the is played flags || 
--++-------------------------------------------------------++
function C_SOUNDS:set_isPlayed_flags(pilot,sound_name,is_played)
    sound_name = tostring(sound_name)
    M_UTILITIES.OutputLog("SET_ISPLAYED_FLAGS : "..sound_name)
    if pilot == "PF" then 
        M_UTILITIES.OutputLog("SET_ISPLAYED_FLAGS FOR .."..self.directory_PF..sound_name..".wav")
        self.sounds_informations[sound_name].isPlayed_PF = is_played
    else 
        M_UTILITIES.OutputLog("SET_ISPLAYED_FLAGS FOR .."..self.directory_PM..sound_name..".wav")
        self.sounds_informations[sound_name].isPlayed_PM = is_played
    end
end

--++--------------------------------------------------------++
--|| C_SOUNDS:insert() Insert a sound into the sounds stack || 
--++--------------------------------------------------------++
function C_SOUNDS:insert(pilot,sound_name,extra_gap)

    local array = self.sounds_queue
    local var_extra_gap = extra_gap or 0
    sound_name = tostring(sound_name)
    if pilot == "PF" then 
        self.sounds_informations[sound_name].isPlayed_PF = true  
    else
        self.sounds_informations[sound_name].isPlayed_PM = true  
    end
    local sounds_queue_elements = {
        pilot = pilot,
        name = sound_name,
        stop_at = nil,
        extra_gap = var_extra_gap
    }
    table.insert(array,sounds_queue_elements) -- add this element to the end of sounds_queue
    self.sounds_queue = array
    M_UTILITIES.OutputLog("INSERT A SOUND : "..sound_name)
    if pilot == "PF" then 
        M_UTILITIES.OutputLog("INSERT A SOUND FOR .."..self.directory_PF..sound_name..".wav")  
    else
        M_UTILITIES.OutputLog("INSERT A SOUND FOR .."..self.directory_PM..sound_name..".wav")  
    end
    
end

--++------------------------------------------------------------------++
--|| C_SOUNDS:insert() Insert a number as sound into the sounds stack || 
--++------------------------------------------------------------------++
function C_SOUNDS:insert_number(pilot,number,extra_gap)
    local i = 0
    local nb_of_words = 0
    str = M_UTILITIES.NumberInWords(number)
    _,nb_of_words = str:gsub("%S+","")
    for word in str:gmatch("%S+") do
        i = i + 1
        if i == nb_of_words then extra_gap = 0 end -- add a gap
        self:insert(pilot,word,extra_gap)
    end
end

--++------------------------------------------------------------++
--|| C_SOUNDS:is_played() Return a played flag for a sound name || 
--++------------------------------------------------------------++
function C_SOUNDS:is_played(pilot,sound_name)
    sound_name = tostring(sound_name)
    if pilot == "PF" then 
        return self.sounds_informations[sound_name].isPlayed_PF
    else
        return self.sounds_informations[sound_name].isPlayed_PM
    end
end

--++-------------------------------------------------------------------------------------------------------------++
--|| C_SOUNDS:play_the_first() Play the first sound in the queue, then set the get the duration for the time out || 
--++-------------------------------------------------------------------------------------------------------------++
function C_SOUNDS:play_the_first()
    local pilot = self.sounds_queue[1].pilot
    local sound_name = self.sounds_queue[1].name
    local extra_gap = self.sounds_queue[1].extra_gap
    if pilot == "PF" then 
        play_sound(self.sounds_informations[sound_name].source_pointer_PF)
        self:set_isPlayed_flags(pilot,sound_name,true)
        self.sounds_queue[1].stop_at = M_UTILITIES.SetTimer(self.sounds_informations[sound_name].duration_PF) + extra_gap
    else
        play_sound(self.sounds_informations[sound_name].source_pointer_PM)
        self:set_isPlayed_flags(pilot,sound_name,true)
        self.sounds_queue[1].stop_at = M_UTILITIES.SetTimer(self.sounds_informations[sound_name].duration_PM) + extra_gap
    end
    M_UTILITIES.OutputLog("PLAY THE SOUND : "..sound_name.." stop At "..self.sounds_queue[1].stop_at.." current "..C_SOUNDS_total_running_time_sec)
    if pilot == "PF" then 
        M_UTILITIES.OutputLog("PLAY_THE_FIRST FOR .."..self.directory_PF..sound_name..".wav")
    else
        M_UTILITIES.OutputLog("PLAY_THE_FIRST FOR .."..self.directory_PM..sound_name..".wav")
    end
end 

--++-------------------------------------------------------------------------------------------------------------++
--|| C_SOUNDS:process_sounds_queue() Check if a sound can be play and check if a sound has finished to delete it || 
--++-------------------------------------------------------------------------------------------------------------++
function C_SOUNDS:process_sounds_queue()
    -- find if something playing
    if #self.sounds_queue ~= 0 then
        -- find if a sound can be play
        if self.sounds_queue[1].stop_at == nil then
            self:play_the_first()
        else
            if self.sounds_queue[1].stop_at < C_SOUNDS_total_running_time_sec then
                -- delete the current sound that has finish to play
                table.remove(self.sounds_queue, 1)
            end
        end
    end
end 

--++-------------------------------------------------------------------------------------------------------------++
--|| C_SOUNDS:set_and_insert() Set flag and insert a sound || 
--++-------------------------------------------------------------------------------------------------------------++
function C_SOUNDS:set_and_insert(pilot,sound_name,extra_gap)
    if pilot == "PF" then 
        M_UTILITIES.OutputLog("set_and_insert FOR .."..self.directory_PF..sound_name..".wav")
    else
        M_UTILITIES.OutputLog("set_and_insert FOR .."..self.directory_PM..sound_name..".wav")
    end
    self:set_isPlayed_flags(pilot,sound_name,false)
    self:insert(pilot,sound_name,extra_gap)
end 

return C_SOUNDS