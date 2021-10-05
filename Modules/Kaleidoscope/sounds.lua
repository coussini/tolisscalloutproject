--[[
##    ##    ###    ##       ######## #### ########   #######   ######   ######   #######  ########  ######## 
##   ##    ## ##   ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##     ## ##       
##  ##    ##   ##  ##       ##        ##  ##     ## ##     ## ##       ##       ##     ## ##     ## ##       
#####    ##     ## ##       ######    ##  ##     ## ##     ##  ######  ##       ##     ## ########  ######   
##  ##   ######### ##       ##        ##  ##     ## ##     ##       ## ##       ##     ## ##        ##       
##   ##  ##     ## ##       ##        ##  ##     ## ##     ## ##    ## ##    ## ##     ## ##        ##       
##    ## ##     ## ######## ######## #### ########   #######   ######   ######   #######  ##        ########  SOUNDS

Kaleidoscope Sounds module By Coussini 2021
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
local M_SOUNDS = {}

M_SOUNDS.GAP = 0.25 -- second of gap between sounds
M_SOUNDS.SOUNDDIR = ""

M_SOUNDS.isPlayed = {} -- table that contains list of sound sources with a status (is played)
M_SOUNDS.SoundPointer = {} -- pointer in the sound source file

-- STACK (Sound Table)
M_SOUNDS.TableSoundPointer = {}
M_SOUNDS.TableSoundDuration = {}
M_SOUNDS.TableSoundStartAt = {}
M_SOUNDS.TableSoundStopAt = {}
M_SOUNDS.TableSoundisPlaying = {}
-- GLOBAL VARIABLE
M_SOUNDS.CurrentIndexPlaying = nil

function M_SOUNDS.SetSoundsDirectory(sound_directory)
    
    M_SOUNDS.SOUNDDIR = sound_directory

end

function M_SOUNDS.SetGapBetweenSounds(gap)
    
    M_SOUNDS.GAP = gap

end

--FAIT
function M_SOUNDS.GetSoundDuration(sound_name)
    libs_file = io.open(M_SOUNDS.SOUNDDIR..sound_name..".wav","r")
    size = M_UTILITIES.FindSize(libs_file)
    libs_file:close()
    duration = size / (16000 * 2 * 16 /8)
    return duration
end

function M_SOUNDS.TreatANumberForPlaying(number,extra_gap)
    local i = 0
    local nb_of_words = 0
    str = M_UTILITIES.NumberInWords(number)
    _,nb_of_words = str:gsub("%S+","")
    for word in str:gmatch("%S+") do
        i = i + 1
        if i == nb_of_words then extra_gap = 0.5 end -- add a gap
        M_SOUNDS.TreatASoundToPlay(word,extra_gap)
    end
end

--FAIT
function M_SOUNDS.TreatASoundToPlay(sound_name,extra_gap)
    M_SOUNDS.Set_isPlayed(sound_name,true) -- sometimes this flag is set here but not use in other places 
    index = table.getn(M_SOUNDS.TableSoundPointer) + 1 -- get array size and add 1 for the new sound
    duration = M_SOUNDS.GetSoundDuration(sound_name) + GAP + extra_gap
    M_SOUNDS.InsertASoundInStack(index,M_SOUNDS.SoundPointer[sound_name],duration)
    OutputLog("M_SOUNDS.InsertASoundInStack : "..sound_name)
end

--FAIT
function M_SOUNDS.InsertASoundInStack(index,sound_pointer,duration)
    M_SOUNDS.TableSoundPointer[index] = sound_pointer -- sound pointer
    M_SOUNDS.TableSoundDuration[index] = duration 
    M_SOUNDS.TableSoundStartAt[index] = nil -- when the sound will be playing, it will be initialize
    M_SOUNDS.TableSoundStopAt[index] = nil -- when the sound will be playing, it will be initialize
    M_SOUNDS.TableSoundisPlaying[index] = false
    return true
end -- function M_SOUNDS.InsertASoundInStack(index,sound_pointer,duration)

function M_SOUNDS.RemoveASoundFromStack(index)
    table.remove(M_SOUNDS.TableSoundPointer, index)
    table.remove(M_SOUNDS.TableSoundDuration,index)
    table.remove(M_SOUNDS.TableSoundStartAt,index)
    table.remove(M_SOUNDS.TableSoundStopAt,index)
    table.remove(M_SOUNDS.TableSoundisPlaying,index)
end -- function M_SOUNDS.RemoveASoundFromStack(index)

function M_SOUNDS.FindIfSoundPlaying()
    nothing = nil
    for i = 1, table.getn(M_SOUNDS.TableSoundPointer) do -- from 1 thru number of occurs in M_SOUNDS.TableSoundPointer
        return i -- index
    end
    return nothing
end -- function M_SOUNDS.FindIfSoundPlaying()

function M_SOUNDS.VerifyIfSoundToPlay()
    if M_SOUNDS.CurrentIndexPlaying ~= nil then -- find a playing sound
        if M_SOUNDS.TableSoundStopAt[M_SOUNDS.CurrentIndexPlaying] ~= nil and M_SOUNDS.TableSoundStopAt[M_SOUNDS.CurrentIndexPlaying] < os.clock() then -- find a playing sound to delete in the table
            M_SOUNDS.RemoveASoundFromStack(M_SOUNDS.CurrentIndexPlaying)
        end
    end
    return M_SOUNDS.FindIfSoundPlaying()
end -- function M_SOUNDS.FindIfSoundPlaying()

function M_SOUNDS.PlayASound(index)
    if not M_SOUNDS.TableSoundisPlaying[index] then
        play_sound(M_SOUNDS.TableSoundPointer[index])
        stop_play = SetTimer(M_SOUNDS.TableSoundDuration[index])
        start_play = stop_play - M_SOUNDS.TableSoundDuration[index]
        M_SOUNDS.TableSoundStartAt[index] = start_play
        M_SOUNDS.TableSoundStopAt[index] = stop_play
        M_SOUNDS.TableSoundisPlaying[index] = true
    end
    return index
end -- function PlayASond(index)

function M_SOUNDS.ProcessStackOfSounds()
    index = M_SOUNDS.VerifyIfSoundToPlay() -- in the same time, this function delete old played sound
    if index == nil then
        M_SOUNDS.CurrentIndexPlaying = nil
    else
        M_SOUNDS.CurrentIndexPlaying = M_SOUNDS.PlayASound(index)
    end
end -- function M_SOUNDS.ProcessStackOfSounds()

function M_SOUNDS.PrepareSoundFileByName(sound_name)

    -- Set default sound level to max
    local sound_level = 1.00

    --OutputLog("Sound_name : "..(M_SOUNDS.SOUNDDIR or "").."/"..sound_name..".wav")
    M_SOUNDS.SoundPointer[sound_name] = load_WAV_file(M_SOUNDS.SOUNDDIR.."/"..sound_name..".wav")
    set_sound_gain(M_SOUNDS.SoundPointer[sound_name], sound_level)

end -- function PrepareSoundFile()

function M_SOUNDS.Set_isPlayed(sound_name,status)

    M_SOUNDS.isPlayed[sound_name] = status

end -- function PrepareSoundFile()

function M_SOUNDS.Get_isPlayed(sound_name)

    return M_SOUNDS.isPlayed[sound_name]

end -- function PrepareSoundFile()

return M_SOUNDS