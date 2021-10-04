--[[
########  #######  ##       ####  ######   ######         ######     ###    ##       ##        #######  ##     ## ######## 
   ##    ##     ## ##        ##  ##    ## ##    ##       ##    ##   ## ##   ##       ##       ##     ## ##     ##    ##    
   ##    ##     ## ##        ##  ##       ##             ##        ##   ##  ##       ##       ##     ## ##     ##    ##    
   ##    ##     ## ##        ##   ######   ######        ##       ##     ## ##       ##       ##     ## ##     ##    ##    
   ##    ##     ## ##        ##        ##       ##       ##       ######### ##       ##       ##     ## ##     ##    ##    
   ##    ##     ## ##        ##  ##    ## ##    ##       ##    ## ##     ## ##       ##       ##     ## ##     ##    ##    
   ##     #######  ######## ####  ######   ######         ######  ##     ## ######## ########  #######   #######     ##  PRO    

ToLiss Callout Pro By Coussini 2021
]]
                                                                                                                                                                                                        
--+========================================+
--|  R E Q U I R E D   L I B R A R I E S   |
--+========================================+
local M_UTILITIES = require("Kaleidoscope.utilities")
local M_COLORS = require("Kaleidoscope.colors")
local C_SOUNDS = require("Kaleidoscope.classes.C_SOUNDS")

--+==================================+
--|  L O C A L   V A R I A B L E S   |
--+==================================+
    local TOLISS_CP = {} -- Toliss Callout Pro

--+====================================================================+
--|       T H E   F O L L O W I N G   A R E   H I G H   L E V E L      |
--|                       F U N C T I O N S                            |
--|                                                                    |
--| CONVENTION: These functions use Uper Camel Case without underscore |
--+====================================================================+

--++---------------------------------------------------------++
--|| TOLISS_CP.CatchTODTime() return the Top Of Descent time || 
--++---------------------------------------------------------++
function TOLISS_CP.CatchTODTime(s)

  local stringTrim = M_UTILITIES.TrimLeading(s)
  
  return M_UTILITIES.LastWord(stringTrim)

end

function CheckAutoThrustMode()

--[[
ATHRmode2 = {}
ATHRmode2[0] = "MCT Thrust (maximum continuous thrust)"
ATHRmode2[1] = "Thrust Climb"
ATHRmode2[2] = "Thrust Idle"
ATHRmode2[3] = "Flare (idle)"
ATHRmode2[4] = "Speed"
ATHRmode2[5] = "Mach"

--toliss_airbus/pfdoutputs/general/alpha_floor_mode 1 = alpha floor 2 = toga lock
]]
    if TOLISS_CP.Value.THRLeverMode ~= REF_THRLeverMode then
        TOLISS_CP.Timer.THRLeverMode = M_UTILITIES.SetTimer(2)
        TOLISS_CP.Value.THRLeverMode = REF_THRLeverMode
        if     REF_THRLeverMode == 1 then TOLISS_CP.Object_sound:set_isPlayed_flags("ManThrust",false) 
        elseif REF_THRLeverMode == 2 then TOLISS_CP.Object_sound:set_isPlayed_flags("ManFlex",false) 
        elseif REF_THRLeverMode == 3 then TOLISS_CP.Object_sound:set_isPlayed_flags("ManTOGA",false) 
        elseif REF_THRLeverMode == 4 then TOLISS_CP.Object_sound:set_isPlayed_flags("ManMCT",false) 
        end 
    end

    if TOLISS_CP.Timer.THRLeverMode ~= 0 and REF_total_running_time_sec > TOLISS_CP.Timer.THRLeverMode then
        TOLISS_CP.Timer.THRLeverMode = 0
        if     REF_THRLeverMode == 1 and not TOLISS_CP.Object_sound:is_played("ManThrust") then TOLISS_CP.Object_sound:insert("ManThrust",0.5) 
        elseif REF_THRLeverMode == 2 and not TOLISS_CP.Object_sound:is_played("ManFlex") then TOLISS_CP.Object_sound:insert("ManFlex",0.5) 
        elseif REF_THRLeverMode == 3 and not TOLISS_CP.Object_sound:is_played("ManTOGA") then TOLISS_CP.Object_sound:insert("ManTOGA",0.5) 
        elseif REF_THRLeverMode == 4 and not TOLISS_CP.Object_sound:is_played("ManMCT") then TOLISS_CP.Object_sound:insert("ManMCT",0.5) 
        end 
    end

    if TOLISS_CP.Value.ATHRmode2 ~= REF_ATHRmode2 then
        TOLISS_CP.Timer.ATHRmode2 = M_UTILITIES.SetTimer(2)
        TOLISS_CP.Value.ATHRmode2 = REF_ATHRmode2
        if     REF_ATHRmode2 == 1 then TOLISS_CP.Object_sound:set_isPlayed_flags("ThrustClimb",false) 
        elseif REF_ATHRmode2 == 2 then TOLISS_CP.Object_sound:set_isPlayed_flags("ThrustIdle",false) 
        elseif REF_ATHRmode2 == 4 then TOLISS_CP.Object_sound:set_isPlayed_flags("Speed",false) 
        elseif REF_ATHRmode2 == 5 then TOLISS_CP.Object_sound:set_isPlayed_flags("Mach",false) 
        end 
    end

    if TOLISS_CP.Timer.ATHRmode2 ~= 0 and REF_total_running_time_sec > TOLISS_CP.Timer.ATHRmode2 then
        TOLISS_CP.Timer.ATHRmode2 = 0
        if     REF_ATHRmode2 == 1 and not TOLISS_CP.Object_sound:is_played("ThrustClimb") then TOLISS_CP.Object_sound:insert("ThrustClimb",0.5) 
        elseif REF_ATHRmode2 == 2 and not TOLISS_CP.Object_sound:is_played("ThrustIdle") then TOLISS_CP.Object_sound:insert("ThrustIdle",0.5) 
        elseif REF_ATHRmode2 == 4 and not TOLISS_CP.Object_sound:is_played("Speed") then TOLISS_CP.Object_sound:insert("Speed",0.5) 
        elseif REF_ATHRmode2 == 5 and not TOLISS_CP.Object_sound:is_played("Mach") then TOLISS_CP.Object_sound:insert("Mach",0.5) 
        end 
    end

end

function CheckVerticalMode()

    --[[
APVerticalMode[0] = "SRS"
APVerticalMode[2] = "DES"
APVerticalMode[3] = "ALT CST*"
APVerticalMode[4] = "ALT CST"
APVerticalMode[6] = "G/S*"
APVerticalMode[7] = "G/S"
APVerticalMode[8] = "FINAL"
APVerticalMode[10] = "FLARE"
APVerticalMode[11] = "LAND"
APVerticalMode[102] = "OP DES"
APVerticalMode[103] = "ALT*"
APVerticalMode[104] = "ALT"
APVerticalMode[105] = "ALT CRZ"
APVerticalMode[107] = "V/S or FPA"
APVerticalMode[112] = "EXP CLB"
APVerticalMode[113] = "EXP DES"
    ]]

    if TOLISS_CP.Value.APVerticalMode ~= REF_APVerticalMode then
        TOLISS_CP.Timer.APVerticalMode = M_UTILITIES.SetTimer(2)
        TOLISS_CP.Value.APVerticalMode = REF_APVerticalMode
        if     REF_APVerticalMode == 0 then TOLISS_CP.Object_sound:set_isPlayed_flags("SRS",false) 
        elseif REF_APVerticalMode == 1 then TOLISS_CP.Object_sound:set_isPlayed_flags("Climb",false) 
        elseif REF_APVerticalMode == 2 then TOLISS_CP.Object_sound:set_isPlayed_flags("Des",false) 
        elseif REF_APVerticalMode == 3 then TOLISS_CP.Object_sound:set_isPlayed_flags("AltCSTStar",false) 
        elseif REF_APVerticalMode == 4 then TOLISS_CP.Object_sound:set_isPlayed_flags("AltCST",false) 
        elseif REF_APVerticalMode == 6 then TOLISS_CP.Object_sound:set_isPlayed_flags("GlideSlopeStar",false) 
        elseif REF_APVerticalMode == 7 then TOLISS_CP.Object_sound:set_isPlayed_flags("GlideSlope",false) 
        elseif REF_APVerticalMode == 8 then TOLISS_CP.Object_sound:set_isPlayed_flags("FinalApproach",false) 
        elseif REF_APVerticalMode == 11 then TOLISS_CP.Object_sound:set_isPlayed_flags("LandGreen",false) 
        elseif REF_APVerticalMode == 101 then TOLISS_CP.Object_sound:set_isPlayed_flags("OpenClimb",false)
        elseif REF_APVerticalMode == 102 then TOLISS_CP.Object_sound:set_isPlayed_flags("OpenDescent",false) 
        elseif REF_APVerticalMode == 103 then TOLISS_CP.Object_sound:set_isPlayed_flags("AltStar",false) 
        elseif REF_APVerticalMode == 104 then TOLISS_CP.Object_sound:set_isPlayed_flags("Alt",false) 
        elseif REF_APVerticalMode == 105 then TOLISS_CP.Object_sound:set_isPlayed_flags("AltCruise",false) 
        elseif REF_APVerticalMode == 107 then TOLISS_CP.Object_sound:set_isPlayed_flags("VS",false) 
        end 
    end

    if TOLISS_CP.Timer.APVerticalMode ~= 0 and REF_total_running_time_sec > TOLISS_CP.Timer.APVerticalMode then
        TOLISS_CP.Timer.APVerticalMode = 0
        if     REF_APVerticalMode == 0 and not TOLISS_CP.Object_sound:is_played("SRS") then TOLISS_CP.Object_sound:insert("SRS",0.5) 
        elseif REF_APVerticalMode == 1 and not TOLISS_CP.Object_sound:is_played("Climb") then TOLISS_CP.Object_sound:insert("Climb",0.5) 
        elseif REF_APVerticalMode == 2 and not TOLISS_CP.Object_sound:is_played("Des") then TOLISS_CP.Object_sound:insert("Des",0.5) 
        elseif REF_APVerticalMode == 3 and not TOLISS_CP.Object_sound:is_played("AltCSTStar") then TOLISS_CP.Object_sound:insert("AltCSTStar",0.5) 
        elseif REF_APVerticalMode == 4 and not TOLISS_CP.Object_sound:is_played("AltCST") then TOLISS_CP.Object_sound:insert("AltCST",0.5) 
        elseif REF_APVerticalMode == 6 and not TOLISS_CP.Object_sound:is_played("GlideSlopeStar") then 
            TOLISS_CP.Object_sound:insert("GlideSlopeStar",0.5) 
            TOLISS_CP.Object_sound:insert("PleaseSetGoAroundAltitude",0.5) 
            TOLISS_CP.isMissedApproachWarning = true
        elseif REF_APVerticalMode == 7 and not TOLISS_CP.Object_sound:is_played("GlideSlope") then TOLISS_CP.Object_sound:insert("GlideSlope",0.5) 
        elseif REF_APVerticalMode == 8 and not TOLISS_CP.Object_sound:is_played("FinalApproach") then 
            TOLISS_CP.Object_sound:insert("FinalApproach",0.5)
            TOLISS_CP.Object_sound:insert("PleaseSetGoAroundAltitude",0.5) 
            TOLISS_CP.isMissedApproachWarning = true
        elseif REF_APVerticalMode == 11 and not TOLISS_CP.Object_sound:is_played("LandGreen") then TOLISS_CP.Object_sound:insert("LandGreen",0.5) 
        elseif REF_APVerticalMode == 101 and not TOLISS_CP.Object_sound:is_played("OpenClimb") then TOLISS_CP.Object_sound:insert("OpenClimb",0.5)
        elseif REF_APVerticalMode == 102 and not TOLISS_CP.Object_sound:is_played("OpenDescent") then TOLISS_CP.Object_sound:insert("OpenDescent",0.5) 
        elseif REF_APVerticalMode == 103 and not TOLISS_CP.Object_sound:is_played("AltStar") then TOLISS_CP.Object_sound:insert("AltStar",0.5) 
        elseif REF_APVerticalMode == 104 and not TOLISS_CP.Object_sound:is_played("Alt") then 
            TOLISS_CP.Object_sound:insert("Alt",0.5) 
        elseif REF_APVerticalMode == 105 and not TOLISS_CP.Object_sound:is_played("AltCruise") then 
            TOLISS_CP.Object_sound:insert("AltCruise",0.5) 
            TOLISS_CP.Object_sound:insert("FlightLevel",0.5) 
            TOLISS_CP.Object_sound:insert_number(REF_ap_altitude_reference,0.5) 
            TOLISS_CP.Object_sound:insert("Blue",1) 
            if REF_XPDRTCASAltSelect ~= 1 then -- status of the button in the cockpit
                TOLISS_CP.Object_sound:insert("SetTCASToNeutral",0.5)
            end
        elseif REF_APVerticalMode == 107 and not TOLISS_CP.Object_sound:is_played("VS") then 
            TOLISS_CP.Timer.vertical_velocity = M_UTILITIES.SetTimer(5)
            TOLISS_CP.Value.vertical_velocity = REF_vertical_velocity
        end
    end

    if REF_APVerticalMode == 107 and TOLISS_CP.Value.vertical_velocity ~= REF_vertical_velocity then
        TOLISS_CP.Timer.vertical_velocity = M_UTILITIES.SetTimer(5)
        TOLISS_CP.Value.vertical_velocity = REF_vertical_velocity
    end

    if TOLISS_CP.Timer.vertical_velocity ~= 0 and REF_total_running_time_sec > TOLISS_CP.Timer.vertical_velocity then
        TOLISS_CP.Timer.vertical_velocity = 0
        local vertical_velocity_integer_part = REF_vertical_velocity
        local vertical_velocity_decimal_part = 0
        if M_UTILITIES.IndexOff(REF_FMA1g," FPA ") then
            vertical_velocity_integer_part = math.ceil(tonumber(REF_vertical_velocity)/1000)
            vertical_velocity_decimal_part = M_UTILITIES.GetDecimal(tonumber(REF_vertical_velocity)/1000)
            TOLISS_CP.Object_sound:insert("FPA",1) 
            TOLISS_CP.Object_sound:set_isPlayed_flags("VS",true)
        else
            TOLISS_CP.Object_sound:insert("VS",1) 
        end
        if REF_vertical_velocity < 0 then 
            TOLISS_CP.Object_sound:insert("Minus",0.5) 
        end
        if vertical_velocity_integer_part < 0 then 
            vertical_velocity_integer_part = vertical_velocity_integer_part * -1
        end
        TOLISS_CP.Object_sound:insert_number(vertical_velocity_integer_part,0.5)
        if vertical_velocity_decimal_part ~= nil and tonumber(vertical_velocity_decimal_part) > 0 then 
            TOLISS_CP.Object_sound:insert("Dot",0.5) 
            TOLISS_CP.Object_sound:insert_number(vertical_velocity_decimal_part,0.5)
        end 
    end

end

function CheckLateralMode()

--[[ 
APLateralMode = {}
APLateralMode[0] = "RWY"
APLateralMode[1] = "RWYTRK"
APLateralMode[2] = "NAV"
APLateralMode[6] = "LOC*"
APLateralMode[7] = "LOC"
APLateralMode[9] = "APP NAV"
APLateralMode[9] = "SRS"
APLateralMode[10] = "ROLL OUT"
APLateralMode[11] = "LAND"
APLateralMode[12] = "GA TRK"
APLateralMode[101] = "HDG or TRK"
]]
    if TOLISS_CP.Value.APLateralMode ~= REF_APLateralMode then
        TOLISS_CP.Timer.APLateralMode = M_UTILITIES.SetTimer(2)
        TOLISS_CP.Value.APLateralMode = REF_APLateralMode
        if     REF_APLateralMode == 0 then TOLISS_CP.Object_sound:set_isPlayed_flags("RWY",false) 
        elseif REF_APLateralMode == 1 then TOLISS_CP.Object_sound:set_isPlayed_flags("RWYTRK",false) 
        elseif REF_APLateralMode == 2 then TOLISS_CP.Object_sound:set_isPlayed_flags("NAV",false) 
        elseif REF_APLateralMode == 6 then TOLISS_CP.Object_sound:set_isPlayed_flags("LocStar",false) 
        elseif REF_APLateralMode == 7 then TOLISS_CP.Object_sound:set_isPlayed_flags("Loc",false) 
        elseif REF_APLateralMode == 12 then TOLISS_CP.Object_sound:set_isPlayed_flags("GATRK",false) 
        elseif REF_APLateralMode == 101 then TOLISS_CP.Object_sound:set_isPlayed_flags("HDG",false) 
        end 
    end

    if TOLISS_CP.Timer.APLateralMode ~= 0 and REF_total_running_time_sec > TOLISS_CP.Timer.APLateralMode then
        TOLISS_CP.Timer.APLateralMode = 0
        if     REF_APLateralMode == 0 and not TOLISS_CP.Object_sound:is_played("RWY") then TOLISS_CP.Object_sound:insert("RWY",0.5) 
        elseif REF_APLateralMode == 1 and not TOLISS_CP.Object_sound:is_played("RWYTRK") then TOLISS_CP.Object_sound:insert("RWYTRK",0.5) 
        elseif REF_APLateralMode == 2 and not TOLISS_CP.Object_sound:is_played("NAV") then TOLISS_CP.Object_sound:insert("NAV",0.5) 
        elseif REF_APLateralMode == 6 and not TOLISS_CP.Object_sound:is_played("LocStar") then TOLISS_CP.Object_sound:insert("LocStar",0.5) 
        elseif REF_APLateralMode == 7 and not TOLISS_CP.Object_sound:is_played("Loc") then TOLISS_CP.Object_sound:insert("Loc",0.5) 
        elseif REF_APLateralMode == 12 and not TOLISS_CP.Object_sound:is_played("GATRK") then TOLISS_CP.Object_sound:insert("GATRK",0.5) 
        elseif REF_APLateralMode == 101 and not TOLISS_CP.Object_sound:is_played("HDG") then 
            if M_UTILITIES.IndexOff(REF_FMA1g," TRACK ") then
                TOLISS_CP.Object_sound:insert("TRACK",0.5) 
                TOLISS_CP.Object_sound:set_isPlayed_flags("HDG",true)
            else
                TOLISS_CP.Object_sound:insert("HDG",0.5) 
            end
        end 
    end

end

function CheckAutoFlightStatus()

--[[
ATHRmode = {}
ATHRmode[0] = "disengaged"
ATHRmode[1] = "Auto Thrust Blue"
ATHRmode[2] = "Auto Thrust"

]]
    if TOLISS_CP.Value.AP1Engage ~= REF_AP1Engage then
        TOLISS_CP.Timer.AP1Engage = M_UTILITIES.SetTimer(2)
        TOLISS_CP.Value.AP1Engage = REF_AP1Engage
        if REF_AP1Engage == 1 then 
            TOLISS_CP.Object_sound:set_isPlayed_flags("AP1On",false) 
        end 
    end

    if TOLISS_CP.Timer.AP1Engage ~= 0 and REF_total_running_time_sec > TOLISS_CP.Timer.AP1Engage then
        TOLISS_CP.Timer.AP1Engage = 0
        if REF_AP1Engage == 1 and not TOLISS_CP.Object_sound:is_played("AP1On") then 
            TOLISS_CP.Object_sound:insert("AP1On",0.5) 
        end 
    end

    if TOLISS_CP.Value.AP2Engage ~= REF_AP2Engage then
        TOLISS_CP.Timer.AP2Engage = M_UTILITIES.SetTimer(2)
        TOLISS_CP.Value.AP2Engage = REF_AP2Engage
        if REF_AP2Engage == 1 then 
            TOLISS_CP.Object_sound:set_isPlayed_flags("AP2On",false) 
        end 
    end

    if TOLISS_CP.Timer.AP2Engage ~= 0 and REF_total_running_time_sec > TOLISS_CP.Timer.AP2Engage then
        TOLISS_CP.Timer.AP2Engage = 0
        if REF_AP2Engage == 1 and not TOLISS_CP.Object_sound:is_played("AP2On") then 
            TOLISS_CP.Object_sound:insert("AP2On",0.5) 
        end 
    end

    if TOLISS_CP.Value.ATHRmode ~= REF_ATHRmode then
        TOLISS_CP.Timer.ATHRmode = M_UTILITIES.SetTimer(2)
        TOLISS_CP.Value.ATHRmode = REF_ATHRmode
        if     REF_ATHRmode == 1 then TOLISS_CP.Object_sound:set_isPlayed_flags("ATHRBlue",false) 
        elseif REF_ATHRmode == 2 then TOLISS_CP.Object_sound:set_isPlayed_flags("ATHR",false) 
        end 
    end

    if TOLISS_CP.Timer.ATHRmode ~= 0 and REF_total_running_time_sec > TOLISS_CP.Timer.ATHRmode then
        TOLISS_CP.Timer.ATHRmode = 0
        if     REF_ATHRmode == 1 and not TOLISS_CP.Object_sound:is_played("ATHRBlue") then TOLISS_CP.Object_sound:insert("ATHRBlue",0,5) 
        elseif REF_ATHRmode == 2 and not TOLISS_CP.Object_sound:is_played("ATHR") then TOLISS_CP.Object_sound:insert("ATHR",0.5) 
        end 
    end

end

function CheckVerticalModeArmed()


    --[[

   1: G/S (cyan)
    2: CLB armed, 4: ALT (cyan) armed, 6: DES armed, 8: ALT CSTR (magenta) armed, 10: OP CLB armed
APVerticalArmed[2] = "CLB armed"
APVerticalArmed[4] = "DES armed"
APVerticalArmed[6] = "ALT blue armed"
APVerticalArmed[8] = "ALT CSTR magenta armed"
APVerticalArmed[10] = "OP CLB armed"
    ]]

    if     TOLISS_CP.Value.APVerticalArmed ~= REF_APVerticalArmed then
        TOLISS_CP.Timer.APVerticalArmed = M_UTILITIES.SetTimer(8)
        TOLISS_CP.Value.APVerticalArmed = REF_APVerticalArmed
        if     REF_APVerticalArmed == 6 then TOLISS_CP.Object_sound:set_isPlayed_flags("Alt",false) 
        elseif REF_APVerticalArmed == 8 then TOLISS_CP.Object_sound:set_isPlayed_flags("Alt",false) 
        end 
    elseif TOLISS_CP.Value.AltitudeTargetChanged ~= REF_ap_alt_target_value then
        TOLISS_CP.Timer.AltitudeTargetChanged = M_UTILITIES.SetTimer(8)
        TOLISS_CP.Value.AltitudeTargetChanged = REF_ap_alt_target_value
        if     REF_APVerticalArmed == 6 then TOLISS_CP.Object_sound:set_isPlayed_flags("Alt",false) 
        elseif REF_APVerticalArmed == 8 then TOLISS_CP.Object_sound:set_isPlayed_flags("Alt",false) 
        end 
    end

    --[[
    if TOLISS_CP.Timer.APVerticalArmed ~= 0 and REF_total_running_time_sec > TOLISS_CP.Timer.APVerticalArmed then
        TOLISS_CP.Timer.APVerticalArmed = 0
        if     REF_APVerticalArmed == 6 and not TOLISS_CP.Object_sound:set_isPlayed_flags("Alt"] then 
            TOLISS_CP.Object_sound:insert("Alt",0.5) 
            TOLISS_CP.Object_sound:insert_number(REF_ap_alt_target_value,0.5) 
            TOLISS_CP.Object_sound:insert("Blue",0.5) 
        elseif REF_APVerticalArmed == 8 and not TOLISS_CP.Object_sound:set_isPlayed_flags("Alt"] then 
            TOLISS_CP.Object_sound:insert("Alt",0.5) 
            TOLISS_CP.Object_sound:insert_number(REF_ConstraintAlt,0.5) 
            TOLISS_CP.Object_sound:insert("Magenta",0.5) 
        end 
    end
    ]]
    if (TOLISS_CP.Timer.APVerticalArmed ~= 0 and REF_total_running_time_sec > TOLISS_CP.Timer.APVerticalArmed) or
       (TOLISS_CP.Timer.AltitudeTargetChanged ~= 0 and REF_total_running_time_sec > TOLISS_CP.Timer.AltitudeTargetChanged) then
        TOLISS_CP.Timer.APVerticalArmed = 0
        TOLISS_CP.Timer.AltitudeTargetChanged = 0
        if     REF_APVerticalArmed == 6 and not TOLISS_CP.Object_sound:is_played("Alt") then 
            TOLISS_CP.Object_sound:insert("Alt",1) 
            TOLISS_CP.Object_sound:insert("FlightLevel",0.5) 
            TOLISS_CP.Object_sound:insert_number(REF_ap_alt_target_value,0.5) 
            TOLISS_CP.Object_sound:insert("Blue",0.5) 
        elseif REF_APVerticalArmed == 8 and not TOLISS_CP.Object_sound:is_played("Alt") then 
            TOLISS_CP.Object_sound:insert("Alt",1) 
            TOLISS_CP.Object_sound:insert("FlightLevel",0.5) 
            TOLISS_CP.Object_sound:insert_number(REF_ConstraintAlt,0.5) 
            TOLISS_CP.Object_sound:insert("Magenta",0.5) 
        end 
    end

end

--++---------------------------------------------------------------------------------------------------++
--|| TOLISS_CP.EvaluateFlapsValue() check what is the state of the flaps, then play a sound about that || 
--++---------------------------------------------------------------------------------------------------++
function TOLISS_CP.EvaluateFlapsValue(value)

    if     value == TOLISS_CP.Flaps_valid[1] then TOLISS_CP.Object_sound:insert("FlapsUP",0.5)
    elseif value == TOLISS_CP.Flaps_valid[2] then TOLISS_CP.Object_sound:insert("Flaps1",0.5) 
    elseif value == TOLISS_CP.Flaps_valid[3] then TOLISS_CP.Object_sound:insert("Flaps2",0.5) 
    elseif value == TOLISS_CP.Flaps_valid[4] then TOLISS_CP.Object_sound:insert("Flaps3",0.5) 
    elseif value == TOLISS_CP.Flaps_valid[5] then TOLISS_CP.Object_sound:insert("FlapsFULL",0.5) 
    else return TOLISS_CP.LastFlapSet
    end

    return value

end

function TOLISS_CP.CheckFlapsAndGear()

    if REF_FlapLeverRatio ~= TOLISS_CP.LastFlapSet and M_UTILITIES.ItemListValid(TOLISS_CP.Flaps_valid,REF_FlapLeverRatio) then
        TOLISS_CP.LastFlapSet = TOLISS_CP.EvaluateFlapsValue(REF_FlapLeverRatio)
    end

    if TOLISS_CP.Value.gear ~= REF_GearLever then
        TOLISS_CP.Timer.gear = M_UTILITIES.SetTimer(1)
        TOLISS_CP.Value.gear = REF_GearLever
    end

    -- POSITIVE CLIMB EVENT  
    if not TOLISS_CP.Object_sound:is_played("PositiveClimb") then 
        if (M_UTILITIES.Round(REF_vvi_fpm_pilot) > 500 and M_UTILITIES.Round(REF_vvi_fpm_pilot) < 505 and REF_APPhase == 1) or  
           M_UTILITIES.Round(REF_vvi_fpm_pilot) > 500 and REF_APPhase == 6 then 
            TOLISS_CP.Object_sound:insert("PositiveClimb",0) 
        end
    end

    if TOLISS_CP.Timer.gear ~= 0 and REF_total_running_time_sec > TOLISS_CP.Timer.gear then
        TOLISS_CP.Timer.gear = 0
        if REF_GearLever == 0 then 
            TOLISS_CP.Object_sound:insert("GearUp",0.5) 
        else
            TOLISS_CP.Object_sound:insert("GearDown",0.5)
        end
    end

end

function TOLISS_CP.CheckFlightModeAnnunciations()

    CheckAutoThrustMode()  
    CheckVerticalMode()
    CheckLateralMode()
    CheckAutoFlightStatus()   
    CheckVerticalModeArmed()         

end

function TOLISS_CP.CheckAutopilotPhasePreflight()
    -- ESSAYER POUR VOIR UN RELOAD DE SITUATION SANS REFRESH POUR VOIR SI LES SONS SONT EFFECTUÉS.
    -- ESSAYER POUR VOIR UN RELOAD DE SITUATION SANS REFRESH POUR VOIR SI LES SONS SONT EFFECTUÉS.
    -- ESSAYER POUR VOIR UN RELOAD DE SITUATION SANS REFRESH POUR VOIR SI LES SONS SONT EFFECTUÉS.
    -- ESSAYER POUR VOIR UN RELOAD DE SITUATION SANS REFRESH POUR VOIR SI LES SONS SONT EFFECTUÉS.

    if not TOLISS_CP.isAutopilotPhasePreflight then
        TOLISS_CP.Object_sound:reset_isPlayed_flags_to_false(TOLISS_CP.list_sounds)
        TOLISS_CP.SetDefaultValues()
        TOLISS_CP.isAutopilotPhasePreflight = true
    end

end

function TOLISS_CP.CheckAutopilotPhase_TakeOff()


    --[1] AirbusFBW/THRLeverMode
    -- 0: None; 1: MAN THR, 2: MAN FLX, 3: MAN TOGA, 4: MAN MCT"
    -- [2] AirbusFBW/APVerticalMode 
    -- 0=SRS, 1=CLB, 2=DES, 3=ALT CST*, 4=ALT CST, 6=G/S*, 7=G/S, 8=FINAL, 10=FLARE, 11=LAND; 101=OP CLB, 
    -- 102=OP DES, 103=ALT*, 104=ALT, 105: ALT CRZ, 107=V/S or FPA, 112: EXP CLB, 113: EXP DES"
    -- [3] AirbusFBW/APLateralMode
    -- 0=RWY, 1=RWYTRK, 2=NAV, 6=LOC*, 7=LOC, 9=APP NAV, 10=ROLL OUT, 11=LAND, 12 GA TRK, 101=HDG or TRK" 

    -- AirbusFBW/ATHRmode
    --0: disengaged, 1: armed (auto thrust blue), 2: engaged/active
    --AirbusFBW/ATHRmode2
    --0: MCT Thrust, 1=Climb Thrust, 2=Idle thrust, 3=Flare (idle), 4: Speed, 5: Mach"

    --[[
    if string.find(REF_FMA1w,"%sMAN%s") ~= nil  and string.find(REF_FMA1g,"%SRS%s") ~= nil then
        -- TOGA EVENT
        if string.find(REF_FMA2w,"%sTOGA%s") ~= nil then
            if string.find(REF_FMA1g,"%RWY%s") == nil then
                if not TOLISS_CP.Object_sound:set_isPlayed_flags("ManTogaSRSATHR"] then
                    TOLISS_CP.Object_sound:insert("ManTogaSRSATHR",0)
                end
            else
                if not TOLISS_CP.Object_sound:set_isPlayed_flags("ManTogaSRSRWYATHR"] then
                    TOLISS_CP.Object_sound:insert("ManTogaSRSRWYATHR",0)
                    TOLISS_CP.Object_sound:set_isPlayed_flags("ManTogaSRSATHR"] = true
                end
            end
        -- FLEX EVENT
        elseif string.find(REF_FMA2w,"FLX%s") ~= nil  then 
            if string.find(REF_FMA1g,"%RWY%s") == nil then 
                if not TOLISS_CP.Object_sound:set_isPlayed_flags("ManFlexSRSATHR"] then
                    TOLISS_CP.Object_sound:insert("ManFlexSRSATHR",0)
                end
            else
                if not TOLISS_CP.Object_sound:set_isPlayed_flags("ManFlexSRSRWYATHR"] then
                    TOLISS_CP.Object_sound:insert("ManFlexSRSRWYATHR",0)
                    TOLISS_CP.Object_sound:set_isPlayed_flags("ManFlexSRSATHR"] = true
                end
                if string.find(REF_FMA1g,"%TRK%s") and not TOLISS_CP.Object_sound:set_isPlayed_flags("RWYTRK"] then
                    TOLISS_CP.Object_sound:insert("RWYTRK",0)
                end
            end
        end
    end
     ]]

    -- TAKE-OFF SPEEDS EVENT        
    if REF_IASCapt > 78 and not TOLISS_CP.Object_sound:is_played("ThrustSet") then 
        TOLISS_CP.Object_sound:insert("ThrustSet",0) 
    end

    if REF_IASCapt > 98 and REF_IASCapt < 105 and not TOLISS_CP.Object_sound:is_played("100kts") then 
        TOLISS_CP.Object_sound:insert("100kts",0) 
    end
        
    if (M_UTILITIES.Round(REF_IASCapt) + 2) == REF_V1 and not TOLISS_CP.Object_sound:is_played("V1") and REF_V1 > 0 then 
        TOLISS_CP.Object_sound:insert("V1",0) 
    end

    if (M_UTILITIES.Round(REF_IASCapt) + 2) ==  REF_VR and not TOLISS_CP.Object_sound:is_played("VR") and REF_VR > 0 then 
        TOLISS_CP.Object_sound:insert("VR",0) 
    end

    if (M_UTILITIES.Round(REF_IASCapt) - 2) == REF_V2 and not TOLISS_CP.Object_sound:is_played("V2") and REF_V2 > 0 then 
        TOLISS_CP.Object_sound:insert("V2",0) 
    end

    -- after takeoff
    --MAN FLEX | STR | RWY TRK | AutoThrust blue

end

function TOLISS_CP.CheckAutopilotPhase_Climb()

    -- THR CLB SET AFTER LVR CLB FLASHING
    -- 3000 feet is the max value according to a real pilot of Airbus for the Thrust reduction takeoff, in feet. That's important
    -- to do that in case a reload of a situation from the ISCS menu

  --THR CLB | OP CLB | RWY TRK | AutoThrust blue (A HDG IS SET)
  --THR CLB | OP CLB | NAV | (HDG AUTO...DOT)

    --[[
    if TOLISS_CP.Value.ATHRmode2 ~= REF_ATHRmode2 and REF_ATHRmode2 == 1 then
        TOLISS_CP.Timer.ATHRmode2 = M_UTILITIES.SetTimer(2)
        TOLISS_CP.Value.ATHRmode2 = REF_ATHRmode2
        TOLISS_CP.Object_sound:set_isPlayed_flags("ThrustClimb",false) 
        TOLISS_CP.Object_sound:set_isPlayed_flags("Climb",false)
    end

    if TOLISS_CP.Timer.ATHRmode2 ~= 0  and REF_ATHRmode2 == 1 and REF_total_running_time_sec > TOLISS_CP.Timer.ATHRmode2 then
        TOLISS_CP.Timer.ATHRmode2 = 0
        if REF_ATHRmode2 == 1 and not TOLISS_CP.Object_sound:is_played("ThrustClimb") then TOLISS_CP.Object_sound:insert("ThrustClimb",0.5) end
        if REF_APVerticalMode == 1 and not TOLISS_CP.Object_sound:is_played("Climb") then TOLISS_CP.Object_sound:insert("Climb",0.5) end 
    end
    ]]
    -- REACH 10000 FEETS EVENT (CLIMB)
    -- 9999-10005 feet are important, to do that in case a reload of a situation from the ISCS menu

    if REF_VGreenDot_value > 0 and  M_UTILITIES.Round(REF_IASCapt) > REF_VGreenDot_value  and M_UTILITIES.Round(REF_IASCapt) < (REF_VGreenDot_value + 5) and not TOLISS_CP.Object_sound:is_played("DownToTheLine")  then
        TOLISS_CP.Object_sound:insert("DownToTheLine",0.5) 
    end

    if M_UTILITIES.Round(REF_altitude_ft_pilot) > 9999 and M_UTILITIES.Round(REF_altitude_ft_pilot) < 10005 and M_UTILITIES.Round(REF_vvi_fpm_pilot) > 0 and not TOLISS_CP.Object_sound:is_played("Pass10000LightsOff")  then
        TOLISS_CP.Object_sound:insert("Pass10000LightsOff",0.5) 
    end

    if M_UTILITIES.Round(REF_altitude_ft_pilot) > REF_DeptTrans and  M_UTILITIES.Round(REF_altitude_ft_pilot) < (REF_DeptTrans + 5) and not TOLISS_CP.Object_sound:is_played("StandardCrossChecked")  then
        TOLISS_CP.Object_sound:insert("StandardCrossChecked",2) 
        TOLISS_CP.Object_sound:insert_number(REF_DeptTrans,0.5)
    end

end

function TOLISS_CP.CheckAutopilotPhase_Cruize()

    -- CAPTURE TOP OF DESCENT
    if TOLISS_CP.Object_sound:is_played("AltCruise") and string.find(REF_MCDU1cont2g,"(T/D)") ~= nil and not TOLISS_CP.isTodCaptured then
        TOLISS_CP.Object_sound:insert("TopOfDescentValueCaptured",2) 
        TOLISS_CP.isTodCaptured = true
        TODvalue = TOLISS_CP.CatchTODTime(REF_MCDU1cont3g)
        DESCENTNM = REF_DistToDest - TODvalue
    end

    -- Display the TOP OF DESCENT against the Distance of destination
    if TOLISS_CP.isTodCaptured then
        TOLISS_CP.Top_of_descent_value = REF_DistToDest-DESCENTNM
        CUS_distance_to_tod = TOLISS_CP.Top_of_descent_value
    end

    -- REACH 180 NM BEFORE DESTINATION, FEED APPROACH DATA TO PERFORMANCE PAGE
    if M_UTILITIES.Round(REF_DistToDest) <= 180 and not TOLISS_CP.Object_sound:is_played("Pass180NM") then 
        TOLISS_CP.Object_sound:insert("Pass180NM",1) 
    end

    -- REACH 180 NM BEFORE DESTINATION, FEED APPROACH DATA TO PERFORMANCE PAGE
    if TOLISS_CP.Top_of_descent_value <= 10 and not TOLISS_CP.Object_sound:is_played("Pass10NM") and TOLISS_CP.isTodCaptured then 
        TOLISS_CP.Object_sound:insert("Pass10NM",0) 
    end    

end

function TOLISS_CP.CheckAutopilotPhase_Descent()

    -- DESCENT TO ARRIVAL ALTITUDE
    if not TOLISS_CP.Object_sound:is_played("SetTCASToBelow") and REF_XPDRTCASAltSelect ~= 2 then 
        TOLISS_CP.Object_sound:insert("SetTCASToBelow",2) 
        TOLISS_CP.Object_sound:set_isPlayed_flags("AltimeterCrossChecked",false)
    end

    -- REACH 10000 FEETS EVENT (DESCENT)
    -- 9995-9999 feet are important, to do that in case a reload of a situation from the ISCS menu
    if M_UTILITIES.Round(REF_altitude_ft_pilot) <= 9999 and M_UTILITIES.Round(REF_altitude_ft_pilot) > 9995 and M_UTILITIES.Round(REF_vvi_fpm_pilot) < 0 and not TOLISS_CP.Object_sound:is_played("Pass10000LightsOn")  then
        TOLISS_CP.Object_sound:insert("Pass10000LightsOn",0.5) 
    end

    if M_UTILITIES.Round(REF_altitude_ft_pilot) < REF_DestTrans and  M_UTILITIES.Round(REF_altitude_ft_pilot) > (REF_DestTrans - 5) and not TOLISS_CP.Object_sound:is_played("AltimeterCrossChecked")  then
        TOLISS_CP.Object_sound:insert("AltimeterCrossChecked",2) 
        TOLISS_CP.Object_sound:insert_number(REF_DestTrans,0.5)
    end

end

function TOLISS_CP.CheckAutopilotPhase_Approach()

    ---------------------------------------------
    -- Missed Approach Set advice (REACH 2000) --
    ---------------------------------------------
    -- REF_GearLever == 1 -- down
    --  AirbusFBW/NoSmokingSignsOn == 1 and AirbusFBW/SeatBeltSignsOn == 1
    -- AirbusFBW/purser/fwd (done once and more)
    -- 
    if REF_radio_altimeter_height_ft_pilot < 1980 and TOLISS_CP.isMissedApproachWarning and not TOLISS_CP.Object_sound:is_played("MissedApproachSet") then
        if REF_approach_type == 0 then -- ILS Approach
            TOLISS_CP.Object_sound:insert("ApproachSet",1) 
            if REF_AP1Engage == 0 and REF_AP2Engage == 0  and REF_APPRilluminated == 1 and REF_APVerticalMode ~= 8 then 
                TOLISS_CP.Object_sound:insert("Cat1",1) 
                --TOLISS_CP.Object_sound:insert("Single",0.5) 
            elseif REF_AP1Engage == 1 and REF_AP2Engage == 1 and REF_APPRilluminated == 1 then 
                TOLISS_CP.Object_sound:insert("Cat3",0.5) 
                TOLISS_CP.Object_sound:insert("Dual",1) 
            elseif REF_AP1Engage == 1 or REF_AP2Engage == 1 and REF_APPRilluminated == 1 then 
                TOLISS_CP.Object_sound:insert("Cat3",0.5) 
                TOLISS_CP.Object_sound:insert("Single",1) 
            end
        end
        --[[
        if REF_MDA > 0 then 
            TOLISS_CP.Object_sound:insert("MDA",0.5) 
            TOLISS_CP.Object_sound:insert_number(REF_MDA,0.5) 
        elseif REF_DH > 0 then 
            TOLISS_CP.Object_sound:insert("DH",0.5) 
            TOLISS_CP.Object_sound:insert_number(REF_DH,0.5) 
        else  
]]        
        if REF_MDA == 0 and REF_DH == 0 then 
            TOLISS_CP.Object_sound:insert("NODH",0.5) 
        end

        TOLISS_CP.Object_sound:insert("MissedApproachSet",0.5) 
        TOLISS_CP.Object_sound:insert_number(REF_ap_altitude_reference,0.5) 
        TOLISS_CP.Object_sound:insert("Blue",0.5) 
    end

    -- Reversers EVENT
    if REF_thrust_reverser_deploy_ratio > 0.99 and not TOLISS_CP.Object_sound:is_played("ReversersGreen") then 
        TOLISS_CP.Object_sound:insert("ReversersGreen",0) 
    end

    -- Stoping EVENT
    if REF_IASCapt < 62  and not TOLISS_CP.Object_sound:is_played("60kts") then 
        TOLISS_CP.Object_sound:insert("60kts",0) 
    end

end

function TOLISS_CP.CheckAutopilotPhase_Go_around()

    if not TOLISS_CP.Object_sound:is_played("GoAround") then 
        TOLISS_CP.Object_sound:set_isPlayed_flags("PositiveClimb",false)
        TOLISS_CP.Object_sound:insert("GoAround",0) 
    end

end

function TOLISS_CP.CheckAutopilotPhase_Done()
end

--+====================================================================+
--|       T H E   F O L L O W I N G   F U N C T I O N S   A R E        |
--|            U S E   F O R   I N I T I A L I Z A T I O N             |
--|                                                                    |
--| CONVENTION: These functions use Uper Camel Case without underscore |
--+====================================================================+

--++--------------------------------------------------------------------++
--|| TOLISS_CP.LoadingDataFromDataref() get datarefs for internal usage || 
--++--------------------------------------------------------------------++
function TOLISS_CP.LoadingDataFromDataref()

    DataRef("REF_alpha_floor_mode","toliss_airbus/pfdoutputs/general/alpha_floor_mode","readonly")
    DataRef("REF_AlphaProtActive","AirbusFBW/AlphaProtActive","readonly")
    DataRef("REF_ALTisCstr","AirbusFBW/ALTisCstr","readonly")
    DataRef("REF_altitude_ft_pilot","sim/cockpit2/gauges/indicators/altitude_ft_pilot","readonly")
    DataRef("REF_AP1Engage","AirbusFBW/AP1Engage","readonly")
    DataRef("REF_AP2Engage","AirbusFBW/AP2Engage","readonly")
    DataRef("REF_ap_alt_target_value","toliss_airbus/pfdoutputs/general/ap_alt_target_value","readonly")
    DataRef("REF_ap_altitude_reference","toliss_airbus/pfdoutputs/general/ap_altitude_reference","readonly")
    DataRef("REF_APLateralMode","AirbusFBW/APLateralMode","readonly")
    DataRef("REF_APPhase","AirbusFBW/APPhase","readonly")  
    DataRef("REF_APPRilluminated","AirbusFBW/APPRilluminated","readonly")
    DataRef("REF_approach_type","toliss_airbus/pfdoutputs/general/approach_type","readonly")  
    DataRef("REF_APVerticalArmed","AirbusFBW/APVerticalArmed","readonly")  
    DataRef("REF_APVerticalMode","AirbusFBW/APVerticalMode","readonly")
    DataRef("REF_ATHRmode","AirbusFBW/ATHRmode","readonly")
    DataRef("REF_ATHRmode2","AirbusFBW/ATHRmode2","readonly")
    DataRef("REF_ConstraintAlt","AirbusFBW/ConstraintAlt","readonly")
    DataRef("REF_cruise_alt","toliss_airbus/init/cruise_alt","readonly")
    DataRef("REF_DeptTrans","toliss_airbus/performance/DeptTrans","readonly")
    DataRef("REF_DestTrans","toliss_airbus/performance/DestTrans","readonly")
    DataRef("REF_DH","toliss_airbus/performance/DH","readonly")
    DataRef("REF_DistToDest","AirbusFBW/DistToDest","readonly")
    DataRef("REF_FlapLeverRatio","AirbusFBW/FlapLeverRatio","readonly")
    DataRef("REF_FMA1g","AirbusFBW/FMA1g","readonly",0) 
    DataRef("REF_FMA1w","AirbusFBW/FMA1w","readonly",0) 
    DataRef("REF_FMA2w","AirbusFBW/FMA2w","readonly",0) 
    DataRef("REF_GearLever","AirbusFBW/GearLever","readonly")
    DataRef("REF_GSCapt","AirbusFBW/GSCapt","readonly")
    DataRef("REF_IASCapt","AirbusFBW/IASCapt","readonly")
    DataRef("REF_m_fuel_total","sim/flightmodel/weight/m_fuel_total","readonly")
    DataRef("REF_MCDU1cont2g","AirbusFBW/MCDU1cont2g","readonly",0)
    DataRef("REF_MCDU1cont3g","AirbusFBW/MCDU1cont3g","readonly",0)
    DataRef("REF_MDA","toliss_airbus/performance/MDA","readonly")
    DataRef("REF_radio_altimeter_height_ft_pilot","sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot","readonly")
    DataRef("REF_SpdBrakeDeployed","AirbusFBW/SpdBrakeDeployed","readonly")    
    DataRef("REF_THRLeverMode","AirbusFBW/THRLeverMode","readonly")
    DataRef("REF_thrust_reverser_deploy_ratio","sim/flightmodel2/engines/thrust_reverser_deploy_ratio","readonly",0)    
    DataRef("REF_total_running_time_sec","sim/time/total_running_time_sec","readonly")
    DataRef("REF_V1","toliss_airbus/performance/V1","readonly")
    DataRef("REF_V2","toliss_airbus/performance/V2","readonly")
    DataRef("REF_vertical_velocity","sim/cockpit/autopilot/vertical_velocity","readonly")
    DataRef("REF_VGreenDot_value","toliss_airbus/pfdoutputs/general/VGreenDot_value","readonly")
    DataRef("REF_VR","toliss_airbus/performance/VR","readonly")
    DataRef("REF_vvi_fpm_pilot","sim/cockpit2/gauges/indicators/vvi_fpm_pilot","readonly")
    DataRef("REF_XPDRTCASAltSelect","AirbusFBW/XPDRTCASAltSelect","readonly")

    M_UTILITIES.OutputLog("Loading Data done")

end   

--++----------------------------------------------------------------------++
--|| TOLISS_CP.CreatingCustomDataref() create datarefs for internal usage || 
--++----------------------------------------------------------------------++
function TOLISS_CP.CreatingCustomDataref()

    DataRefName = "TolissCalloutPro/indicators/distance_to_tod"

    define_shared_DataRef(DataRefName,"Float")
    DataRef("CUS_distance_to_tod",DataRefName,"writable")
    CUS_distance_to_tod = 0.00

    M_UTILITIES.OutputLog("Creating : "..DataRefName)

    DataRefName = "TolissCalloutPro/indicators/set_default_done"

    define_shared_DataRef(DataRefName,"Float")
    DataRef("CUS_set_default_done",DataRefName,"writable")
    CUS_set_default_done = 0.00

    M_UTILITIES.OutputLog("Creating : "..DataRefName)

end 

--++---------------------------------------------------------------------------------------++
--|| TOLISS_CP.PrepareSoundList() prepare a list of sound file name for the C_SOUNDS usage || 
--++---------------------------------------------------------------------------------------++
function TOLISS_CP.PrepareSoundList()

    local list_sounds = {}

    -- 0 thru 19
    for number=0,19 do
        table.insert(list_sounds,number)
    end

    -- 20 thru 90 (scale of tens)
    for number=20,90,10 do
        table.insert(list_sounds,number)
    end

    table.insert(list_sounds,"100kts")
    table.insert(list_sounds,"60kts")
    table.insert(list_sounds,"AFLOOR")
    table.insert(list_sounds,"Alt")
    table.insert(list_sounds,"AltCruise")
    table.insert(list_sounds,"AltCST")
    table.insert(list_sounds,"AltCSTStar")
    table.insert(list_sounds,"AltimeterCrossChecked")
    table.insert(list_sounds,"AltStar")
    table.insert(list_sounds,"AP1On")
    table.insert(list_sounds,"AP2On")
    table.insert(list_sounds,"ApproachSet")
    table.insert(list_sounds,"ATHR")
    table.insert(list_sounds,"ATHRBlue")
    table.insert(list_sounds,"Blue")
    table.insert(list_sounds,"Cat1")
    table.insert(list_sounds,"Cat2")
    table.insert(list_sounds,"Cat3")
    table.insert(list_sounds,"Climb")
    table.insert(list_sounds,"DefaultDone")
    table.insert(list_sounds,"Des")
    table.insert(list_sounds,"DH")
    table.insert(list_sounds,"Dot")
    table.insert(list_sounds,"DownToTheLine")
    table.insert(list_sounds,"Dual")
    table.insert(list_sounds,"FinalApproach")
    table.insert(list_sounds,"Flaps1")
    table.insert(list_sounds,"Flaps2")
    table.insert(list_sounds,"Flaps3")
    table.insert(list_sounds,"FlapsFULL")
    table.insert(list_sounds,"FlapsUP")
    table.insert(list_sounds,"FlightLevel")
    table.insert(list_sounds,"FPA")
    table.insert(list_sounds,"GATRK")
    table.insert(list_sounds,"GearDown")
    table.insert(list_sounds,"GearUp")
    table.insert(list_sounds,"GlideSlope")
    table.insert(list_sounds,"GlideSlopeStar")
    table.insert(list_sounds,"GoAround")
    table.insert(list_sounds,"GoAroundAltitudeSet")
    table.insert(list_sounds,"HDG")
    table.insert(list_sounds,"Hundred")
    table.insert(list_sounds,"LandGreen")
    table.insert(list_sounds,"Loc")
    table.insert(list_sounds,"LocStar")
    table.insert(list_sounds,"Mach")
    table.insert(list_sounds,"Magenta")
    table.insert(list_sounds,"ManFlex") 
    table.insert(list_sounds,"ManMCT") 
    table.insert(list_sounds,"ManThrust") 
    table.insert(list_sounds,"ManTOGA") 
    table.insert(list_sounds,"MDA")
    table.insert(list_sounds,"Minus")
    table.insert(list_sounds,"MissedApproachSet")
    table.insert(list_sounds,"NAV")
    table.insert(list_sounds,"NODH")
    table.insert(list_sounds,"OpenClimb")
    table.insert(list_sounds,"OpenDescent")
    table.insert(list_sounds,"Pass10000LightsOff")
    table.insert(list_sounds,"Pass10000LightsOn")
    table.insert(list_sounds,"Pass10NM")
    table.insert(list_sounds,"Pass180NM")
    table.insert(list_sounds,"PleaseSetGoAroundAltitude")
    table.insert(list_sounds,"Plus")
    table.insert(list_sounds,"PositiveClimb")
    table.insert(list_sounds,"ReversersGreen")
    table.insert(list_sounds,"RWY")
    table.insert(list_sounds,"RWYTRK")
    table.insert(list_sounds,"SetTCASToBelow")
    table.insert(list_sounds,"SetTCASToNeutral")
    table.insert(list_sounds,"Single")
    table.insert(list_sounds,"Speed")
    table.insert(list_sounds,"SRS")
    table.insert(list_sounds,"StandardCrossChecked")
    table.insert(list_sounds,"Thousand")
    table.insert(list_sounds,"ThrustClimb") 
    table.insert(list_sounds,"ThrustIdle") 
    table.insert(list_sounds,"ThrustSet")
    table.insert(list_sounds,"TOGALK")
    table.insert(list_sounds,"TOGASet")
    table.insert(list_sounds,"TopOfDescentValueCaptured")
    table.insert(list_sounds,"TRACK")
    table.insert(list_sounds,"V1")
    table.insert(list_sounds,"V2")
    table.insert(list_sounds,"VR")
    table.insert(list_sounds,"VS")

    M_UTILITIES.OutputLog("TOLISS_CP.PrepareSoundList")

    return list_sounds

end 

--++---------------------------------------------------------------------------------------++
--|| TOLISS_CP.SetDefaultValues() important function to initialize some critical variables || 
--++---------------------------------------------------------------------------------------++
function TOLISS_CP.SetDefaultValues()

    TOLISS_CP.WINDOWX = 150 -- Display position from right edge of window
    TOLISS_CP.WINDOWY = 250 -- Display position from top edge of window

    -----------
    -- flags --
    -----------
    TOLISS_CP.isTodCaptured = false 
    TOLISS_CP.isMissedApproachWarning = false 
    TOLISS_CP.isAutopilotPhasePreflight = true 

    ----------------------------------
    -- variable that affects events --
    ----------------------------------
    TOLISS_CP.Flaps_valid = {0.00,0.25,0.50,0.75,1.00}
    TOLISS_CP.LastFlapSet = REF_FlapLeverRatio
    TOLISS_CP.last_fuel_total = REF_m_fuel_total -- Important line. Do not delete it
    TOLISS_CP.Top_of_descent_value = 0

    -----------------------------------
    -- timer for a specific variable --
    -----------------------------------
    TOLISS_CP.Timer = {}
    TOLISS_CP.Timer.THRLeverMode = 0 
    TOLISS_CP.Timer.ATHRmode2 = 0 
    TOLISS_CP.Timer.APVerticalMode = 0
    TOLISS_CP.Timer.APVerticalArmed = 0
    TOLISS_CP.Timer.APLateralMode = 0
    TOLISS_CP.Timer.AP1Engage = 0
    TOLISS_CP.Timer.ATHRmode = 0
    TOLISS_CP.Timer.AltitudeTargetChanged = 0
    TOLISS_CP.Timer.vertical_velocity = 0
    TOLISS_CP.Timer.gear = 0
   
    ---------------------------------------
    -- variable value related to a timer --
    ---------------------------------------
    TOLISS_CP.Value = {}
    TOLISS_CP.Value.THRLeverMode = REF_THRLeverMode or 0 -- column 1
    TOLISS_CP.Value.ATHRmode2 = REF_ATHRmode2 or 0 -- column 1
    TOLISS_CP.Value.APVerticalMode = REF_APVerticalMode or 0-- column 2
    TOLISS_CP.Value.APVerticalArmed = REF_APVerticalArmed or 0-- column 2 line 2
    TOLISS_CP.Value.APLateralMode = REF_APLateralMode or 0 -- column 3
    TOLISS_CP.Value.AP1Engage = REF_AP1Engage or 0 -- column 5
    TOLISS_CP.Value.ATHRmode = REF_ATHRmode or 0 -- column 5
    TOLISS_CP.Value.AltitudeTargetChanged = REF_ap_alt_target_value or 0
    TOLISS_CP.Value.vertical_velocity = REF_vertical_velocity or 0
    TOLISS_CP.Value.gear = REF_GearLever or 0

    -------------------------------------------------------------------------------
    -- temporary message to make sure that the default is done in the right time --
    -------------------------------------------------------------------------------
    if not TOLISS_CP.Object_sound:is_played("DefaultDone") then 
        TOLISS_CP.Object_sound:insert("DefaultDone",2)
    end

    M_UTILITIES.OutputLog("Set Default Values done")

end 

--+====================================================================+
--|       T H E   F O L L O W I N G   F U N C T I O N S   A R E        |
--|           U S E   I N   "DO_EVERY..."  F U N C T I O N S           |
--|                                                                    |
--| CONVENTION: These functions use Uper Camel Case without underscore |
--+====================================================================+

--++---------------------------------------------------------------------------------------------------++
--|| TOLISS_CP_DisplayValuesPanel() Display some informations for the Toliss Callout Pro into a widget || 
--++---------------------------------------------------------------------------------------------------++
function TOLISS_CP_DisplayValuesPanel()
    
    local sGS = M_UTILITIES.Round(REF_GSCapt)
    local sIAS = M_UTILITIES.Round(REF_IASCapt)
    local sALT = M_UTILITIES.Round(REF_altitude_ft_pilot)
    local sVSI = M_UTILITIES.Round(REF_vvi_fpm_pilot)
    local sV1 = REF_V1
    local sVR = REF_VR
    local sREV = M_UTILITIES.Round(REF_thrust_reverser_deploy_ratio)
    local sDistToDest = M_UTILITIES.Round(REF_DistToDest,2)
    local sAPPhase = REF_APPhase
    local sTOD = ""

    if TOLISS_CP.isTodCaptured and TOLISS_CP.Top_of_descent_value ~= 0 then
        sTOD = M_UTILITIES.Round(TOLISS_CP.Top_of_descent_value,2).." NM"
    end

    XPLMSetGraphicsState(0,0,0,1,1,0,0)
    
    -- DRAW THE TITLE BOX (BOX COLOR CHANGE DEPENDING A WARNING)
    if REF_APPhase == 3 and TOLISS_CP.Top_of_descent_value == 0 then
        graphics.set_color(1, 0, 0, 0.8)
    else
        graphics.set_color(0.12,0.54,0.56, 1)
    end

    graphics.draw_rectangle(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 0, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 200, SCREEN_WIDTH - TOLISS_CP.WINDOWX + 180, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 220)

    -- DRAW THE TITLE 
    graphics.set_color(1, 1, 1, 0.8)
    draw_string_Helvetica_18(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 5, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 202, "Toliss Callouts")       
    
    -- DRAW THE TRANSPARENT BACKGROUND
    graphics.set_color(0, 0, 0, 0.5) 
    graphics.draw_rectangle(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 0, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 10, SCREEN_WIDTH - TOLISS_CP.WINDOWX + 180, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 200)
        
    glColor4f(M_COLORS.YELLOW.red, M_COLORS.YELLOW.green, M_COLORS.YELLOW.blue, 1)
    
    draw_string_Times_Roman_24(800, 900, "PHASE          = "..REF_APPhase or "")
    draw_string_Times_Roman_24(800, 870, "THRLeverMode   = "..REF_THRLeverMode or "")
    draw_string_Times_Roman_24(800, 840, "ATHRmode2      = "..REF_ATHRmode2 or "")
    draw_string_Times_Roman_24(800, 810, "APVerticalMode = "..REF_APVerticalMode or "")
    draw_string_Times_Roman_24(800, 780, "APLateralMode  = "..REF_APLateralMode or "")
    draw_string_Times_Roman_24(800, 750, "TOLISS_CP.Value.vertical  = "..TOLISS_CP.Value.vertical_velocity or "")
    draw_string_Times_Roman_24(800, 720, "REF_vertical   = "..REF_vertical_velocity or "")
    draw_string_Times_Roman_24(800, 690, "LUA_RUN        = "..LUA_RUN)
    
    -- DRAW THE PARAMETERS VALUES
    graphics.set_color(1, 1, 1, 0.8)

    if REF_APPhase == 3 and TOLISS_CP.Top_of_descent_value == 0 then
        draw_string_Helvetica_12(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 10, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 180, "WARNING")
        draw_string_Helvetica_12(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 10, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 160, "PLEASE PRESS")
        draw_string_Helvetica_12(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 10, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 140 , "PERF IN THE")
        draw_string_Helvetica_12(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 10, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 120, "LEFT FMS")
        draw_string_Helvetica_12(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 10, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 100, "TO CATCH")
        draw_string_Helvetica_12(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 10, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 80, " THE TOD VALUE")
        draw_string_Helvetica_12(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 10, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 60, "Dist brut: "..sDistToDest.." NM")
        draw_string_Helvetica_12(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 10, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 40, "tot_run_sec: "..M_UTILITIES.Round(REF_total_running_time_sec,2))
        draw_string_Helvetica_12(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 10, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 20, "PHASE: "..sAPPhase)
    else
        draw_string_Helvetica_12(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 10, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 180, "GS: "..sGS.." m/sec")
        draw_string_Helvetica_12(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 10, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 160, "IAS: "..sIAS.." Kts")
        draw_string_Helvetica_12(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 10, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 140 , "ALT: "..sALT.." VSI: "..sVSI)
        draw_string_Helvetica_12(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 10, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 120, "BUG_V1: "..sV1)
        draw_string_Helvetica_12(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 10, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 100, "BUG_VR: "..sVR)
        draw_string_Helvetica_12(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 10, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 80, "REV: "..sREV)
        draw_string_Helvetica_12(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 10, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 60, "Dist brut: "..sDistToDest.." NM")
        draw_string_Helvetica_12(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 10, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 40, "PHASE: "..sAPPhase)
        draw_string_Helvetica_12(SCREEN_WIDTH - TOLISS_CP.WINDOWX + 10, SCREEN_HIGHT - TOLISS_CP.WINDOWY + 20, "TOD: "..sTOD)
    end

end 

--++--------------------------------------------------------------------------++
--|| TOLISS_CP_TolissCallouts() is the main process of the Toliss Callout Pro || 
--++--------------------------------------------------------------------------++
function TOLISS_CP_TolissCallouts()

    -- IMPORTANT STEP : DO NOT REMOVE IT (IN CASE OF RELOADING SITUATION FROM ISCS)
    if TOLISS_CP.last_fuel_total < (REF_m_fuel_total-3) or TOLISS_CP.last_fuel_total > (REF_m_fuel_total+3) then
        TOLISS_CP.Object_sound:reset_isPlayed_flags_to_false(TOLISS_CP.list_sounds)
        TOLISS_CP.SetDefaultValues()
        TOLISS_CP.last_fuel_total = REF_m_fuel_total
        do return end        
    else
        TOLISS_CP.last_fuel_total = REF_m_fuel_total
    end

    TOLISS_CP.Object_sound:process_sounds_queue() -- Process all sound in the sound queue

    -- CHECK AUTOPILOT PHASE
    if      REF_APPhase == 0 then
            TOLISS_CP.CheckAutopilotPhasePreflight()
    elseif  REF_APPhase == 1 then
            TOLISS_CP.CheckFlightModeAnnunciations()
            TOLISS_CP.CheckAutopilotPhase_TakeOff()
            TOLISS_CP.CheckFlapsAndGear()
    elseif  REF_APPhase == 2 then
            TOLISS_CP.CheckFlightModeAnnunciations()
            TOLISS_CP.CheckAutopilotPhase_Climb()
            TOLISS_CP.CheckFlapsAndGear()
    elseif  REF_APPhase == 3 then
            TOLISS_CP.CheckFlightModeAnnunciations()
            TOLISS_CP.CheckAutopilotPhase_Cruize()
            TOLISS_CP.CheckFlapsAndGear()
    elseif  REF_APPhase == 4 then
            TOLISS_CP.CheckFlightModeAnnunciations()
            TOLISS_CP.CheckAutopilotPhase_Descent()
            TOLISS_CP.CheckFlapsAndGear()
    elseif  REF_APPhase == 5 then
            TOLISS_CP.CheckFlightModeAnnunciations()
            TOLISS_CP.CheckAutopilotPhase_Approach()
            TOLISS_CP.CheckFlapsAndGear()
            TOLISS_CP.isAutopilotPhasePreflight = false
    elseif  REF_APPhase == 6 then
            TOLISS_CP.CheckAutopilotPhase_Go_around()
            TOLISS_CP.CheckFlapsAndGear()
            TOLISS_CP.CheckFlightModeAnnunciations()
            TOLISS_CP.isAutopilotPhasePreflight = false
    elseif  REF_APPhase == 7 then
            TOLISS_CP.CheckAutopilotPhase_Done()
    end
end 

--+====================================================================+
--|       T H E   F O L L O W I N G   I S   T H E    M A I N           |
--|                          S E C T I O N                             |
--|                                                                    |
--| CONVENTION: These functions use Uper Camel Case without underscore |
--+====================================================================+

if  (PLANE_ICAO == "A319" and AIRCRAFT_FILENAME == "a319.acf") or
    (PLANE_ICAO == "A321" and AIRCRAFT_FILENAME == "a321.acf") then

    require("graphics")

    M_UTILITIES.OutputLog("Toliss Callouts Pro by Coussini loaded")

    TOLISS_CP.LoadingDataFromDataref()
    TOLISS_CP.CreatingCustomDataref()

    TOLISS_CP.list_sounds = TOLISS_CP.PrepareSoundList()
    TOLISS_CP.directory_sounds = SCRIPT_DIRECTORY.."ToLissCallout_sounds/"
    TOLISS_CP.Object_sound = C_SOUNDS(TOLISS_CP.directory_sounds,TOLISS_CP.list_sounds,0.25,1)

    TOLISS_CP.SetDefaultValues()

    do_every_draw("TOLISS_CP_DisplayValuesPanel()")
    do_every_frame("TOLISS_CP_TolissCallouts()")
    
end