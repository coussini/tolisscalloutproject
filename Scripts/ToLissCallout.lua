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
                 

--RAFINER LA VALEUR DE TOT OF DESCENT SELON LE REPORT... 

--+========================================+
--|  R E Q U I R E D   L I B R A R I E S   |
--+========================================+
local M_UTILITIES = require("Kaleidoscope.utilities")
local M_COLORS = require("Kaleidoscope.colors")
local C_SOUNDS = require("Kaleidoscope.classes.C_SOUNDS")

--+==================================+
--|  L O C A L   V A R I A B L E S   |
--+==================================+
local TolissCP = {} -- Toliss Callout Pro

--+====================================================================+
--|       T H E   F O L L O W I N G   A R E   H I G H   L E V E L      |
--|                       F U N C T I O N S                            |
--|                                                                    |
--| CONVENTION: These functions use Uper Camel Case without underscore |
--+====================================================================+

--++--------------------------------------------------------++
--|| TolissCP.CatchTODTime() return the Top Of Descent time || 
--++--------------------------------------------------------++
function TolissCP.CatchTODTime(str)

    return M_UTILITIES.LastWord(M_UTILITIES.TrimLeading(str))

end

--++----------------------------------------------------------------------++
--|| TolissCP.CheckFmaThrustEngagedMode() check the FMA thrust lever mode || 
--++----------------------------------------------------------------------++
function TolissCP.CheckFmaThrustEngagedMode()

    ----------------------------------------
    -- MODE THAT THE AUTO THRUST IS ARMED --
    ----------------------------------------
    if TolissCP.Value.THRLeverMode ~= DATAREF_THRLeverMode then
        TolissCP.Value.THRLeverMode = DATAREF_THRLeverMode
        TolissCP.Timer.ThrustEngagedMode = M_UTILITIES.SetTimer(1) -- waiting for the thrust lever to stay is in right position 
    end

    ------------------------------------------
    -- MODE THAT THE AUTO THRUST IS ENGAGED --
    ------------------------------------------
    if TolissCP.Value.athr_thrust_mode ~= DATAREF_athr_thrust_mode then
        TolissCP.Value.athr_thrust_mode = DATAREF_athr_thrust_mode
        if     DATAREF_athr_thrust_mode ~= 0 then 
            TolissCP.Timer.ThrustEngagedMode = M_UTILITIES.SetTimer(1) -- waiting for the thrust lever to stay is in right position
        end 
    end

    --------------------------------------------------------------------
    -- CHECK THE RELETED COLUMN 1 THRU 5 AGAINST THE THRUST SITUATION --
    --------------------------------------------------------------------
    if TolissCP.Timer.ThrustEngagedMode ~= 0 and DATAREF_total_running_time_sec > TolissCP.Timer.ThrustEngagedMode then
        TolissCP.Timer.ThrustEngagedMode = 0
        if     DATAREF_THRLeverMode == 1 then TolissCP.Object_sound:reset_and_insert("ManThrust",0) 
        elseif DATAREF_THRLeverMode == 2 then TolissCP.Object_sound:reset_and_insert("ManFlex",0) 
        elseif DATAREF_THRLeverMode == 3 then TolissCP.Object_sound:reset_and_insert("ManTOGA",0) 
        elseif DATAREF_THRLeverMode == 4 then TolissCP.Object_sound:reset_and_insert("ManMCT",0) 
        elseif DATAREF_athr_thrust_mode == 1 then TolissCP.Object_sound:reset_and_insert("ThrustClimb",0) 
        elseif DATAREF_athr_thrust_mode == 2 then TolissCP.Object_sound:reset_and_insert("ThrustMCT",0) 
        elseif DATAREF_athr_thrust_mode == 3 then TolissCP.Object_sound:reset_and_insert("ThrustLVR",0) 
        elseif DATAREF_athr_thrust_mode == 4 then TolissCP.Object_sound:reset_and_insert("ThrustIdle",0) 
        end
        -- vertical mode --
        if     DATAREF_APVerticalMode == 0 then TolissCP.Object_sound:reset_and_insert("SRS",0) 
        elseif DATAREF_APVerticalMode == 1 then 
            TolissCP.Value.APVerticalMode = DATAREF_APVerticalMode 
            TolissCP.Object_sound:reset_and_insert("Climb",0) 
        elseif DATAREF_APVerticalMode == 101 then 
            TolissCP.Value.APVerticalMode = DATAREF_APVerticalMode 
            TolissCP.Object_sound:reset_and_insert("OpenClimb",0)
        elseif DATAREF_APVerticalMode == 102 then 
            TolissCP.Value.APVerticalMode = DATAREF_APVerticalMode 
            TolissCP.Object_sound:reset_and_insert("OpenDescent",0)            
        end 
        -- lateral mode --
        if     DATAREF_APLateralMode == 0 then TolissCP.Object_sound:reset_and_insert("RWY",0) 
        elseif DATAREF_APLateralMode == 1 then TolissCP.Object_sound:reset_and_insert("RWYTRK",0) 
        elseif DATAREF_APLateralMode == 12 then TolissCP.Object_sound:reset_and_insert("GATRK",0) 
        end 
        -- auto pilot, flight director and auto thrust status
        if     TolissCP.Value.ATHRmode ~= DATAREF_ATHRmode then 
            TolissCP.Value.ATHRmode = DATAREF_ATHRmode 
            if     DATAREF_ATHRmode == 1 then TolissCP.Object_sound:reset_and_insert("ATHRBlue",0) 
            elseif DATAREF_ATHRmode == 2 then TolissCP.Object_sound:reset_and_insert("ATHR",0) 
            end 
        end 
    end

    ------------------------------------------
    -- CHECK THE SPEED OR MACH ANNUNCIATION --
    ------------------------------------------
    if TolissCP.Value.ATHRmode2 ~= DATAREF_ATHRmode2 then
        TolissCP.Value.ATHRmode2 = DATAREF_ATHRmode2
        if     DATAREF_ATHRmode2 == 4 then TolissCP.Object_sound:reset_and_insert("Speed",0) 
        elseif DATAREF_ATHRmode2 == 5 then TolissCP.Object_sound:reset_and_insert("Mach",0) 
        end 
    end

end

--++--------------------------------------------------------------------++
--|| TolissCP.CheckFmaVerticalEngagedMode() check the FMA vertical mode || 
--++--------------------------------------------------------------------++
function TolissCP.CheckFmaVerticalEngagedMode()

    ----------------------------------------
    -- MODE THAT THE AUTO THRUST IS ARMED --
    ----------------------------------------

    if TolissCP.Value.APVerticalMode ~= DATAREF_APVerticalMode then
        TolissCP.Value.APVerticalMode = DATAREF_APVerticalMode
        if     DATAREF_APVerticalMode == 1 then TolissCP.Object_sound:reset_and_insert("Climb",0) 
        elseif DATAREF_APVerticalMode == 2 then TolissCP.Object_sound:reset_and_insert("Des",0) 
        elseif DATAREF_APVerticalMode == 3 then TolissCP.Object_sound:reset_and_insert("AltCSTStar",0) 
        elseif DATAREF_APVerticalMode == 4 then TolissCP.Object_sound:reset_and_insert("AltCST",0) 
        elseif DATAREF_APVerticalMode == 6 then 
            TolissCP.Object_sound:reset_and_insert("GlideSlopeStar",0) 
            TolissCP.Object_sound:reset_and_insert("PleaseSetGoAroundAltitude",0) 
            TolissCP.isMissedApproachWarning = true
        elseif DATAREF_APVerticalMode == 7 then TolissCP.Object_sound:reset_and_insert("GlideSlope",0) 
        elseif DATAREF_APVerticalMode == 8 then 
            TolissCP.Object_sound:reset_and_insert("FinalApproach",0) 
            TolissCP.Object_sound:reset_and_insert("PleaseSetGoAroundAltitude",0) 
            TolissCP.isMissedApproachWarning = true
        elseif DATAREF_APVerticalMode == 101 then TolissCP.Object_sound:reset_and_insert("OpenClimb",0)
        elseif DATAREF_APVerticalMode == 103 then TolissCP.Object_sound:reset_and_insert("AltStar",0) 
        elseif DATAREF_APVerticalMode == 104 then 
            if DATAREF_altitude_ft_pilot + 400 > DATAREF_cruise_alt then -- patch because ALT appear just before ALT CRZ
            else 
                TolissCP.Object_sound:reset_and_insert("Alt",0) 
            end 
        elseif DATAREF_APVerticalMode == 105 then 
            TolissCP.isReachCruise = true            
            TolissCP.Object_sound:reset_and_insert("AltCruise",4) -- alt play before alt cruise so... only cruise 
            if DATAREF_XPDRTCASAltSelect ~= 1 then -- status of the button in the cockpit
                TolissCP.Object_sound:reset_and_insert("SetTCASToNeutral",0)
            end
        -- VERTICAL MODE 107 can be V/S or FPA
        elseif DATAREF_APVerticalMode == 107 then TolissCP.Object_sound:reset_and_insert("VS",0) 
        elseif DATAREF_APVerticalMode == 112 then TolissCP.Object_sound:reset_and_insert("ExpediteClimb",0) 
        elseif DATAREF_APVerticalMode == 113 then TolissCP.Object_sound:reset_and_insert("ExpediteDescent",0) 
        end 
    end

    --------------------------------------------------------------------
    -- CHECK THE RELETED COLUMN 1 THRU 5 AGAINST THE THRUST SITUATION --
    --------------------------------------------------------------------
    if TolissCP.Timer.VerticalEngagedMode ~= 0 and DATAREF_total_running_time_sec > TolissCP.Timer.VerticalEngagedMode then
        TolissCP.Timer.VerticalEngagedMode = 0
        if DATAREF_APVerticalMode == 11 then TolissCP.Object_sound:reset_and_insert("LandGreen",0) 
        end 
    end

    --[[
    if TolissCP.Timer.VerticalEngagedMode ~= 0 and DATAREF_total_running_time_sec > TolissCP.Timer.VerticalEngagedMode then
        TolissCP.Timer.VerticalEngagedMode = 0
        if     DATAREF_APVerticalMode == 0 and not TolissCP.Object_sound:is_played("SRS") then TolissCP.Object_sound:insert("SRS",0.5) 
        elseif DATAREF_APVerticalMode == 1 and not TolissCP.Object_sound:is_played("Climb") then TolissCP.Object_sound:insert("Climb",0.5) 
        elseif DATAREF_APVerticalMode == 2 and not TolissCP.Object_sound:is_played("Des") then TolissCP.Object_sound:insert("Des",0.5) 
        elseif DATAREF_APVerticalMode == 3 and not TolissCP.Object_sound:is_played("AltCSTStar") then TolissCP.Object_sound:insert("AltCSTStar",0.5) 
        elseif DATAREF_APVerticalMode == 4 and not TolissCP.Object_sound:is_played("AltCST") then TolissCP.Object_sound:insert("AltCST",0.5) 
        elseif DATAREF_APVerticalMode == 6 and not TolissCP.Object_sound:is_played("GlideSlopeStar") then 
            TolissCP.Object_sound:insert("GlideSlopeStar",0.5) 
            TolissCP.Object_sound:insert("PleaseSetGoAroundAltitude",0.5) 
            TolissCP.isMissedApproachWarning = true
        elseif DATAREF_APVerticalMode == 7 and not TolissCP.Object_sound:is_played("GlideSlope") then TolissCP.Object_sound:insert("GlideSlope",0.5) 
        elseif DATAREF_APVerticalMode == 8 and not TolissCP.Object_sound:is_played("FinalApproach") then 
            TolissCP.Object_sound:insert("FinalApproach",0.5)
            TolissCP.Object_sound:insert("PleaseSetGoAroundAltitude",0.5) 
            TolissCP.isMissedApproachWarning = true
        elseif DATAREF_APVerticalMode == 11 and not TolissCP.Object_sound:is_played("LandGreen") then TolissCP.Object_sound:insert("LandGreen",0.5) 
        elseif DATAREF_APVerticalMode == 101 and not TolissCP.Object_sound:is_played("OpenClimb") then TolissCP.Object_sound:insert("OpenClimb",0.5)
        elseif DATAREF_APVerticalMode == 102 and not TolissCP.Object_sound:is_played("OpenDescent") then TolissCP.Object_sound:insert("OpenDescent",0.5) 
        elseif DATAREF_APVerticalMode == 103 and not TolissCP.Object_sound:is_played("AltStar") then TolissCP.Object_sound:insert("AltStar",0.5) 
        elseif DATAREF_APVerticalMode == 104 and not TolissCP.Object_sound:is_played("Alt") then 
            TolissCP.Object_sound:insert("Alt",0.5) 
        elseif DATAREF_APVerticalMode == 105 and not TolissCP.Object_sound:is_played("AltCruise") then 
            TolissCP.Object_sound:insert("AltCruise",0.5) 
            TolissCP.Object_sound:insert("FlightLevel",0.5) 
            TolissCP.Object_sound:insert_number(DATAREF_ap_altitude_reference,0.5) 
            TolissCP.Object_sound:insert("Blue",1) 
            if DATAREF_XPDRTCASAltSelect ~= 1 then -- status of the button in the cockpit
                TolissCP.Object_sound:insert("SetTCASToNeutral",0.5)
            end
        elseif DATAREF_APVerticalMode == 107 and not TolissCP.Object_sound:is_played("VS") then 
            TolissCP.Timer.vertical_velocity = M_UTILITIES.SetTimer(TolissCP.default_timer)
            TolissCP.Value.vertical_velocity = DATAREF_vertical_velocity
        elseif DATAREF_APVerticalMode == 112 and not TolissCP.Object_sound:is_played("ExpediteClimb") then 
            TolissCP.Object_sound:insert("ExpediteClimb",0.5) 
        elseif DATAREF_APVerticalMode == 113 and not TolissCP.Object_sound:is_played("ExpediteDescent") then 
            TolissCP.Object_sound:insert("ExpediteDescent",0.5) 
        end
    end

    if DATAREF_APVerticalMode == 107 and TolissCP.Value.vertical_velocity ~= DATAREF_vertical_velocity then
        TolissCP.Timer.vertical_velocity = M_UTILITIES.SetTimer(TolissCP.default_timer)
        TolissCP.Value.vertical_velocity = DATAREF_vertical_velocity
    end

    if TolissCP.Timer.vertical_velocity ~= 0 and DATAREF_total_running_time_sec > TolissCP.Timer.vertical_velocity then
        TolissCP.Timer.vertical_velocity = 0
        local vertical_velocity_integer_part = DATAREF_vertical_velocity
        local vertical_velocity_decimal_part = 0
        if M_UTILITIES.IndexOff(DATAREF_FMA1g," FPA ") then
            vertical_velocity_integer_part = math.ceil(tonumber(DATAREF_vertical_velocity)/1000)
            vertical_velocity_decimal_part = M_UTILITIES.GetDecimal(tonumber(DATAREF_vertical_velocity)/1000)
            TolissCP.Object_sound:insert("FPA",1) 
            TolissCP.Object_sound:set_isPlayed_flags("VS",true)
        else
            TolissCP.Object_sound:insert("VS",1) 
        end
        if DATAREF_vertical_velocity < 0 then 
            TolissCP.Object_sound:insert("Minus",0.5) 
        end
        if vertical_velocity_integer_part < 0 then 
            vertical_velocity_integer_part = vertical_velocity_integer_part * -1
        end
        TolissCP.Object_sound:insert_number(vertical_velocity_integer_part,0.5)
        if vertical_velocity_decimal_part ~= nil and tonumber(vertical_velocity_decimal_part) > 0 then 
            TolissCP.Object_sound:insert("Dot",0.5) 
            TolissCP.Object_sound:insert_number(vertical_velocity_decimal_part,0.5)
        end 
    end
    ]]
end

--++------------------------------------------------------------------++
--|| TolissCP.CheckFmaLateralEngagedMode() check the FMA lateral mode || 
--++------------------------------------------------------------------++
function TolissCP.CheckFmaLateralEngagedMode()

    if TolissCP.Value.APLateralMode ~= DATAREF_APLateralMode then
        TolissCP.Value.APLateralMode = DATAREF_APLateralMode
        if     DATAREF_APLateralMode == 2 then TolissCP.Object_sound:reset_and_insert("NAV",0) 
        elseif DATAREF_APLateralMode == 6 then TolissCP.Object_sound:reset_and_insert("LocStar",0) 
        elseif DATAREF_APLateralMode == 7 then TolissCP.Object_sound:reset_and_insert("Loc",0) 
        elseif DATAREF_APLateralMode == 101 then 
            if M_UTILITIES.IndexOff(DATAREF_FMA1g," TRACK ") then
                TolissCP.Object_sound:reset_and_insert("TRACK",0) 
            else
                TolissCP.Object_sound:reset_and_insert("HDG",0) 
            end
        end 
    end

end

--++-------------------------------------------------------------------------------------------------------------------------++
--|| TolissCP.CheckFmaStatusAndSpecialMessagesEngagedMode() check the FMA Auto pilot, flight director and auto thrust status || 
--++-------------------------------------------------------------------------------------------------------------------------++
function TolissCP.CheckFmaStatusAndSpecialMessagesEngagedMode()

    if TolissCP.Value.AP1Engage ~= DATAREF_AP1Engage then
        TolissCP.Value.AP1Engage = DATAREF_AP1Engage
        if DATAREF_AP1Engage == 1 then 
            TolissCP.Object_sound:reset_and_insert("AP1On",0) 
        end 
    end

    if TolissCP.Value.AP2Engage ~= DATAREF_AP2Engage then
        TolissCP.Value.AP2Engage = DATAREF_AP2Engage
        if DATAREF_AP2Engage == 1 then 
            TolissCP.Object_sound:reset_and_insert("AP2On",0) 
        end 
    end

end

--++------------------------------------------------------------------------++
--|| TolissCP.CheckFmaVerticalArmedMode() check the FMA vertical armed mode || 
--++------------------------------------------------------------------------++
function TolissCP.CheckFmaVerticalArmedMode()


    --[[

   1: G/S (cyan)
    2: CLB armed, 4: ALT (cyan) armed, 6: DES armed, 8: ALT CSTR (magenta) armed, 10: OP CLB armed
APVerticalArmed[2] = "CLB armed"
APVerticalArmed[4] = "DES armed"
APVerticalArmed[6] = "ALT blue armed"
APVerticalArmed[8] = "ALT CSTR magenta armed"
APVerticalArmed[10] = "OP CLB armed"
    ]]

    if TolissCP.Value.APVerticalArmed ~= DATAREF_APVerticalArmed then
        TolissCP.Value.APVerticalArmed = DATAREF_APVerticalArmed
        TolissCP.Timer.VerticalArmedMode = M_UTILITIES.SetTimer(2) -- waiting for the alt button to stay is in right position
    end

    if TolissCP.Value.AltitudeTargetChanged ~= DATAREF_ap_alt_target_value then
        TolissCP.Value.AltitudeTargetChanged = DATAREF_ap_alt_target_value
        TolissCP.Timer.VerticalArmedMode = M_UTILITIES.SetTimer(2) -- waiting for the alt button to stay is in right position
    end

    if TolissCP.Timer.VerticalArmedMode ~= 0 and DATAREF_total_running_time_sec > TolissCP.Timer.VerticalArmedMode then
        TolissCP.Timer.VerticalArmedMode = 0
        if     DATAREF_APVerticalArmed == 6 then 
            TolissCP.Object_sound:reset_and_insert("Alt",0.5) 
            TolissCP.Object_sound:reset_and_insert("FlightLevel",0) 
            TolissCP.Object_sound:insert_number(DATAREF_ap_alt_target_value,0) 
            TolissCP.Object_sound:reset_and_insert("Blue",0) 
        elseif DATAREF_APVerticalArmed == 8 then 
            TolissCP.Object_sound:reset_and_insert("Alt",0.5) 
            TolissCP.Object_sound:reset_and_insert("FlightLevel",0) 
            TolissCP.Object_sound:insert_number(DATAREF_ConstraintAlt,0) 
            TolissCP.Object_sound:reset_and_insert("Magenta",0) 
        end 
    end

end

--++---------------------------------------------------------------------------------------------------++
--|| TolissCP.EvaluateFlapsValue() check what is the state of the flaps, then play a sound about that || 
--++---------------------------------------------------------------------------------------------------++
function TolissCP.EvaluateFlapsValue(value)

    if     value == TolissCP.Flaps_valid[1] then TolissCP.Object_sound:reset_and_insert("FlapsUP",0)
    elseif value == TolissCP.Flaps_valid[2] then TolissCP.Object_sound:reset_and_insert("Flaps1",0) 
    elseif value == TolissCP.Flaps_valid[3] then TolissCP.Object_sound:reset_and_insert("Flaps2",0) 
    elseif value == TolissCP.Flaps_valid[4] then TolissCP.Object_sound:reset_and_insert("Flaps3",0) 
    elseif value == TolissCP.Flaps_valid[5] then TolissCP.Object_sound:reset_and_insert("FlapsFULL",0) 
    else return TolissCP.LastFlapSet
    end

    return value

end

function TolissCP.CheckFlapsAndGear()

    if DATAREF_FlapLeverRatio ~= TolissCP.LastFlapSet and M_UTILITIES.ItemListValid(TolissCP.Flaps_valid,DATAREF_FlapLeverRatio) then
        TolissCP.LastFlapSet = TolissCP.EvaluateFlapsValue(DATAREF_FlapLeverRatio)
    end

    if TolissCP.Value.gear ~= DATAREF_GearLever then
        TolissCP.Timer.gear = M_UTILITIES.SetTimer(TolissCP.default_timer)
        TolissCP.Value.gear = DATAREF_GearLever
    end

    if not TolissCP.Object_sound:is_played("PositiveClimb") then 
        if (M_UTILITIES.Round(DATAREF_vvi_fpm_pilot) > 500 and DATAREF_APPhase == 1) or  
           M_UTILITIES.Round(DATAREF_vvi_fpm_pilot) > 500 and DATAREF_APPhase == 6 then 
            TolissCP.Object_sound:insert("PositiveClimb",0) 
        end
    end

    if TolissCP.Timer.gear ~= 0 and DATAREF_total_running_time_sec > TolissCP.Timer.gear then
        TolissCP.Timer.gear = 0
        if DATAREF_GearLever == 0 then 
            TolissCP.Object_sound:insert("GearUp",0) 
        else
            TolissCP.Object_sound:insert("GearDown",0)
        end
    end

end

function TolissCP.CheckFlightModeAnnunciationsColumns()

    TolissCP.CheckFmaThrustEngagedMode()  

    if TolissCP.Timer.ThrustEngagedMode == 0 then
        TolissCP.CheckFmaVerticalEngagedMode()
        TolissCP.CheckFmaLateralEngagedMode()
        TolissCP.CheckFmaStatusAndSpecialMessagesEngagedMode()   
        TolissCP.CheckFmaVerticalArmedMode()
    end         

end

function TolissCP.CheckAutopilotPhasePreflight()

    if not TolissCP.isAutopilotPhasePreflightDone then
        TolissCP.Object_sound:reset_isPlayed_flags_to_false(TolissCP.list_sounds)
        TolissCP.SetDefaultValues()
        TolissCP.isAutopilotPhasePreflightDone = true
    end

end

function TolissCP.CheckAutopilotPhase_TakeOff()

    if DATAREF_IASCapt > 78 and DATAREF_IASCapt < 95 and not TolissCP.Object_sound:is_played("ThrustSet") then 
        TolissCP.Object_sound:insert("ThrustSet",0) 
    end

    if DATAREF_IASCapt > 98 and DATAREF_IASCapt < 105 and not TolissCP.Object_sound:is_played("100kts") then 
        TolissCP.Object_sound:insert("100kts",0) 
    end
        
    if (M_UTILITIES.Round(DATAREF_IASCapt) + 2) == DATAREF_V1 and not TolissCP.Object_sound:is_played("V1") and DATAREF_V1 > 0 then 
        TolissCP.Object_sound:insert("V1",0) 
    end

    if (M_UTILITIES.Round(DATAREF_IASCapt) + 2) ==  DATAREF_VR and not TolissCP.Object_sound:is_played("VR") and DATAREF_VR > 0 then 
        TolissCP.Object_sound:insert("VR",0) 
    end

    if (M_UTILITIES.Round(DATAREF_IASCapt) - 2) == DATAREF_V2 and not TolissCP.Object_sound:is_played("V2") and DATAREF_V2 > 0 then 
        TolissCP.Object_sound:insert("V2",0) 
    end

end

function TolissCP.CheckAutopilotPhase_Climb()

    if DATAREF_VGreenDot_value > 0 and  M_UTILITIES.Round(DATAREF_IASCapt) > DATAREF_VGreenDot_value  and M_UTILITIES.Round(DATAREF_IASCapt) < (DATAREF_VGreenDot_value + 5) and not TolissCP.Object_sound:is_played("DownToTheLine")  then
        TolissCP.Object_sound:insert("DownToTheLine",0) 
    end

    if M_UTILITIES.Round(DATAREF_altitude_ft_pilot) > 9999 and M_UTILITIES.Round(DATAREF_altitude_ft_pilot) < 10005 and M_UTILITIES.Round(DATAREF_vvi_fpm_pilot) > 0 and not TolissCP.Object_sound:is_played("Pass10000LightsOff")  then
        TolissCP.Object_sound:insert("Pass10000LightsOff",0) 
    end

    if M_UTILITIES.Round(DATAREF_altitude_ft_pilot) > DATAREF_DeptTrans and  M_UTILITIES.Round(DATAREF_altitude_ft_pilot) < (DATAREF_DeptTrans + 5) and not TolissCP.Object_sound:is_played("StandardCrossChecked")  then
        TolissCP.Object_sound:reset_and_insert("StandardCrossChecked",0.5) 
        TolissCP.Object_sound:insert_number(DATAREF_DeptTrans,0)
    end

end

function TolissCP.CheckAutopilotPhase_Cruize()

    if DATAREF_MCDU1cont3g ~= "" or DATAREF_MCDU1cont3g ~= nil then 
        TolissCP.DESCENTNM = tonumber(TolissCP.CatchTODTime(DATAREF_MCDU1cont3g))
    end

    if tonumber(TolissCP.CatchTODTime(DATAREF_MCDU1cont3g)) == 100 or tonumber(TolissCP.CatchTODTime(DATAREF_MCDU1cont3g)) == 75 then 
        command_once("AirbusFBW/MCDU1Perf")
        TolissCP.Object_sound:insert("TopOfDescentValueCaptured",2) 
        TODvalue = TolissCP.CatchTODTime(DATAREF_MCDU1cont3g)
        DESCENTNM = DATAREF_DistToDest - TODvalue
    end

    if TolissCP.isReachCruise and not TolissCP.isTodCaptured then
        command_once("AirbusFBW/MCDU1Perf")
    end

    -- CAPTURE TOP OF DESCENT
    if TolissCP.isReachCruise and string.find(DATAREF_MCDU1cont2g,"(T/D)") ~= nil and not TolissCP.isTodCaptured then
        TolissCP.Object_sound:insert("TopOfDescentValueCaptured",2) 
        TolissCP.isTodCaptured = true
        TODvalue = TolissCP.CatchTODTime(DATAREF_MCDU1cont3g)
        DESCENTNM = DATAREF_DistToDest - TODvalue
    end

    -- DISPLAY THE TOP OF DESCENT AGAINST THE DISTANCE OF DESTINATION
    if TolissCP.isTodCaptured then
        TolissCP.Top_of_descent_value = DATAREF_DistToDest-DESCENTNM
        CUS_distance_to_tod = TolissCP.Top_of_descent_value
    end

    if M_UTILITIES.Round(DATAREF_DistToDest) <= 180 and not TolissCP.Object_sound:is_played("Pass180NM") then 
        TolissCP.Object_sound:insert("Pass180NM",1) 
    end

    if TolissCP.Top_of_descent_value <= 10 and not TolissCP.Object_sound:is_played("Pass10NM") and TolissCP.isTodCaptured then 
        TolissCP.Object_sound:insert("Pass10NM",0) 
    end    

end

function TolissCP.CheckAutopilotPhase_Descent()

    if not TolissCP.Object_sound:is_played("SetTCASToBelow") and DATAREF_XPDRTCASAltSelect ~= 2 then 
        TolissCP.Object_sound:insert("SetTCASToBelow",2) 
        TolissCP.Object_sound:set_isPlayed_flags("AltimeterCrossChecked",false)
    end

    if M_UTILITIES.Round(DATAREF_altitude_ft_pilot) <= 9999 and M_UTILITIES.Round(DATAREF_altitude_ft_pilot) > 9995 and M_UTILITIES.Round(DATAREF_vvi_fpm_pilot) < 0 and not TolissCP.Object_sound:is_played("Pass10000LightsOn")  then
        TolissCP.Object_sound:insert("Pass10000LightsOn",0) 
    end

    if M_UTILITIES.Round(DATAREF_altitude_ft_pilot) < DATAREF_DestTrans and  M_UTILITIES.Round(DATAREF_altitude_ft_pilot) > (DATAREF_DestTrans - 5) and not TolissCP.Object_sound:is_played("AltimeterCrossChecked")  then
        TolissCP.Object_sound:reset_and_insert("AltimeterCrossChecked",0.5) 
        TolissCP.Object_sound:insert_number(DATAREF_DestTrans,0)
    end

end

function TolissCP.CheckAutopilotPhase_Approach()


    ----------------------------------
    -- Land Green event (REACH 400) --
    ----------------------------------
    if DATAREF_radio_altimeter_height_ft_pilot < 380  and DATAREF_APVerticalMode == 11 and not TolissCP.Object_sound:is_played("LandGreen") then
        TolissCP.Object_sound:reset_and_insert("LandGreen",0) 
    end

    ---------------------------------------------
    -- Missed Approach Set advice (REACH 2000) --
    ---------------------------------------------
    if DATAREF_radio_altimeter_height_ft_pilot < 1980 and TolissCP.isMissedApproachWarning and not TolissCP.Object_sound:is_played("MissedApproachSet") then
        if DATAREF_approach_type == 0 then -- ILS Approach
            TolissCP.Object_sound:insert("ApproachSet",0) 
            if DATAREF_AP1Engage == 0 and DATAREF_AP2Engage == 0  and DATAREF_APPRilluminated == 1 and DATAREF_APVerticalMode ~= 8 then 
                TolissCP.Object_sound:insert("Cat1",0) 
                --TolissCP.Object_sound:insert("Single",0) 
            elseif DATAREF_AP1Engage == 1 and DATAREF_AP2Engage == 1 and DATAREF_APPRilluminated == 1 then 
                TolissCP.Object_sound:insert("Cat3",0) 
                TolissCP.Object_sound:insert("Dual",0) 
            elseif DATAREF_AP1Engage == 1 or DATAREF_AP2Engage == 1 and DATAREF_APPRilluminated == 1 then 
                TolissCP.Object_sound:insert("Cat3",0) 
                TolissCP.Object_sound:insert("Single",0) 
            end
        end
        --[[
        if DATAREF_MDA > 0 then 
            TolissCP.Object_sound:insert("MDA",0.5) 
            TolissCP.Object_sound:insert_number(DATAREF_MDA,0.5) 
        elseif DATAREF_DH > 0 then 
            TolissCP.Object_sound:insert("DH",0.5) 
            TolissCP.Object_sound:insert_number(DATAREF_DH,0.5) 
        else  
]]        
        if DATAREF_MDA == 0 and DATAREF_DH == 0 then 
            TolissCP.Object_sound:insert("NODH",0) 
        end

        TolissCP.Object_sound:insert("MissedApproachSet",0) 
        TolissCP.Object_sound:insert_number(DATAREF_ap_altitude_reference,0) 
        TolissCP.Object_sound:insert("Blue",0) 
    end

    if DATAREF_thrust_reverser_deploy_ratio > 0.99 and not TolissCP.Object_sound:is_played("ReversersGreen") then 
        TolissCP.Object_sound:insert("ReversersGreen",0) 
    end

    if DATAREF_IASCapt < 62  and not TolissCP.Object_sound:is_played("60kts") then 
        TolissCP.Object_sound:insert("60kts",0) 
    end

end

function TolissCP.CheckAutopilotPhase_Go_around()

    if not TolissCP.Object_sound:is_played("GoAround") then 
        TolissCP.Object_sound:set_isPlayed_flags("PositiveClimb",false)
        TolissCP.Object_sound:insert("GoAround",0) 
    end

end

function TolissCP.CheckAutopilotPhase_Done()
end

--+====================================================================+
--|       T H E   F O L L O W I N G   F U N C T I O N S   A R E        |
--|            U S E   F O R   I N I T I A L I Z A T I O N             |
--|                                                                    |
--| CONVENTION: These functions use Uper Camel Case without underscore |
--+====================================================================+

--++--------------------------------------------------------------------++
--|| TolissCP.LoadingDataFromDataref() get datarefs for internal usage || 
--++--------------------------------------------------------------------++
function TolissCP.LoadingDataFromDataref()

    DataRef("DATAREF_alpha_floor_mode","toliss_airbus/pfdoutputs/general/alpha_floor_mode","readonly")
    DataRef("DATAREF_AlphaProtActive","AirbusFBW/AlphaProtActive","readonly")
    DataRef("DATAREF_ALTisCstr","AirbusFBW/ALTisCstr","readonly")
    DataRef("DATAREF_altitude_ft_pilot","sim/cockpit2/gauges/indicators/altitude_ft_pilot","readonly")
    DataRef("DATAREF_AP1Engage","AirbusFBW/AP1Engage","readonly")
    DataRef("DATAREF_AP2Engage","AirbusFBW/AP2Engage","readonly")
    DataRef("DATAREF_ap_alt_target_value","toliss_airbus/pfdoutputs/general/ap_alt_target_value","readonly")
    DataRef("DATAREF_ap_altitude_reference","toliss_airbus/pfdoutputs/general/ap_altitude_reference","readonly")
    DataRef("DATAREF_APLateralMode","AirbusFBW/APLateralMode","readonly")
    DataRef("DATAREF_APPhase","AirbusFBW/APPhase","readonly")  
    DataRef("DATAREF_APPRilluminated","AirbusFBW/APPRilluminated","readonly")
    DataRef("DATAREF_approach_type","toliss_airbus/pfdoutputs/general/approach_type","readonly")  
    DataRef("DATAREF_APVerticalArmed","AirbusFBW/APVerticalArmed","readonly")  
    DataRef("DATAREF_APVerticalMode","AirbusFBW/APVerticalMode","readonly")
    DataRef("DATAREF_athr_thrust_mode","toliss_airbus/pfdoutputs/general/athr_thrust_mode","readonly")
    DataRef("DATAREF_ATHRmode","AirbusFBW/ATHRmode","readonly")
    DataRef("DATAREF_ATHRmode2","AirbusFBW/ATHRmode2","readonly")
    DataRef("DATAREF_ConstraintAlt","AirbusFBW/ConstraintAlt","readonly")
    DataRef("DATAREF_cruise_alt","toliss_airbus/init/cruise_alt","readonly")
    DataRef("DATAREF_DeptTrans","toliss_airbus/performance/DeptTrans","readonly")
    DataRef("DATAREF_DestTrans","toliss_airbus/performance/DestTrans","readonly")
    DataRef("DATAREF_DH","toliss_airbus/performance/DH","readonly")
    DataRef("DATAREF_DistToDest","AirbusFBW/DistToDest","readonly")
    DataRef("DATAREF_FlapLeverRatio","AirbusFBW/FlapLeverRatio","readonly")
    DataRef("DATAREF_FMA1g","AirbusFBW/FMA1g","readonly",0) 
    DataRef("DATAREF_FMA1w","AirbusFBW/FMA1w","readonly",0) 
    DataRef("DATAREF_FMA2w","AirbusFBW/FMA2w","readonly",0) 
    DataRef("DATAREF_GearLever","AirbusFBW/GearLever","readonly")
    DataRef("DATAREF_GSCapt","AirbusFBW/GSCapt","readonly")
    DataRef("DATAREF_IASCapt","AirbusFBW/IASCapt","readonly")
    DataRef("DATAREF_m_fuel_total","sim/flightmodel/weight/m_fuel_total","readonly")
    DataRef("DATAREF_MCDU1cont2g","AirbusFBW/MCDU1cont2g","readonly",0)
    DataRef("DATAREF_MCDU1cont3g","AirbusFBW/MCDU1cont3g","readonly",0)
    DataRef("DATAREF_MDA","toliss_airbus/performance/MDA","readonly")
    DataRef("DATAREF_radio_altimeter_height_ft_pilot","sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot","readonly")
    DataRef("DATAREF_SpdBrakeDeployed","AirbusFBW/SpdBrakeDeployed","readonly")    
    DataRef("DATAREF_THRLeverMode","AirbusFBW/THRLeverMode","readonly")
    DataRef("DATAREF_thrust_reverser_deploy_ratio","sim/flightmodel2/engines/thrust_reverser_deploy_ratio","readonly",0)    
    DataRef("DATAREF_total_running_time_sec","sim/time/total_running_time_sec","readonly")
    DataRef("DATAREF_V1","toliss_airbus/performance/V1","readonly")
    DataRef("DATAREF_V2","toliss_airbus/performance/V2","readonly")
    DataRef("DATAREF_vertical_velocity","sim/cockpit/autopilot/vertical_velocity","readonly")
    DataRef("DATAREF_VGreenDot_value","toliss_airbus/pfdoutputs/general/VGreenDot_value","readonly")
    DataRef("DATAREF_VR","toliss_airbus/performance/VR","readonly")
    DataRef("DATAREF_vvi_fpm_pilot","sim/cockpit2/gauges/indicators/vvi_fpm_pilot","readonly")
    DataRef("DATAREF_XPDRTCASAltSelect","AirbusFBW/XPDRTCASAltSelect","readonly")

    M_UTILITIES.OutputLog("Loading Data done")

end   

--++----------------------------------------------------------------------++
--|| TolissCP.CreatingCustomDataref() create datarefs for internal usage || 
--++----------------------------------------------------------------------++
function TolissCP.CreatingCustomDataref()

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
--|| TolissCP.PrepareSoundList() prepare a list of sound file name for the C_SOUNDS usage || 
--++---------------------------------------------------------------------------------------++
function TolissCP.PrepareSoundList()

    local list_sounds = {}

    -- 0 THRU 19
    for number=0,19 do
        table.insert(list_sounds,number)
    end

    -- 20 THRU 90 (SCALE OF TENS)
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
    table.insert(list_sounds,"ExpediteClimb")
    table.insert(list_sounds,"ExpediteDescent")
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
    table.insert(list_sounds,"ThrustLVR") 
    table.insert(list_sounds,"ThrustMCT") 
    table.insert(list_sounds,"ThrustSet")
    table.insert(list_sounds,"TOGALK")
    table.insert(list_sounds,"TOGASet")
    table.insert(list_sounds,"TopOfDescentValueCaptured")
    table.insert(list_sounds,"TRACK")
    table.insert(list_sounds,"V1")
    table.insert(list_sounds,"V2")
    table.insert(list_sounds,"VR")
    table.insert(list_sounds,"VS")

    M_UTILITIES.OutputLog("TolissCP.PrepareSoundList")

    return list_sounds

end 

--++---------------------------------------------------------------------------------------++
--|| TolissCP.SetDefaultValues() important function to initialize some critical variables || 
--++---------------------------------------------------------------------------------------++
function TolissCP.SetDefaultValues()

    TolissCP.WINDOWX = 150 -- DISPLAY POSITION FROM RIGHT EDGE OF WINDOW
    TolissCP.WINDOWY = 250 -- DISPLAY POSITION FROM TOP EDGE OF WINDOW
    TolissCP.default_timer = 0

    -----------
    -- FLAGS --
    -----------
    TolissCP.isAutopilotPhasePreflightDone = true 
    TolissCP.isReachCruise = false 
    TolissCP.isTodCaptured = false 
    TolissCP.isMissedApproachWarning = false 

    ----------------------------------
    -- VARIABLE THAT AFFECTS EVENTS --
    ----------------------------------
    TolissCP.Flaps_valid = {0.00,0.25,0.50,0.75,1.00}
    TolissCP.LastFlapSet = DATAREF_FlapLeverRatio
    TolissCP.last_fuel_total = DATAREF_m_fuel_total -- IMPORTANT LINE. DO NOT DELETE IT
    TolissCP.Top_of_descent_value = 0

    -----------------------------------
    -- TIMER FOR A SPECIFIC VARIABLE --
    -----------------------------------
    TolissCP.Timer = {}
    TolissCP.Timer.AltitudeTargetChanged = 0
    TolissCP.Timer.AP1Engage = 0
    TolissCP.Timer.APLateralMode = 0
    TolissCP.Timer.VerticalArmedMode = 0 -- OK
    TolissCP.Timer.VerticalEngagedMode = 0 -- OK
    TolissCP.Timer.ATHRmode = 0
    TolissCP.Timer.gear = 0
    TolissCP.Timer.ThrustEngagedMode = 0 --OK
    TolissCP.Timer.vertical_velocity = 0
   
    ---------------------------------------
    -- VARIABLE VALUE RELATED TO A TIMER --
    ---------------------------------------
    TolissCP.Value = {}
    TolissCP.Value.AltitudeTargetChanged = DATAREF_ap_alt_target_value or 0
    TolissCP.Value.AP1Engage = DATAREF_AP1Engage or 0
    TolissCP.Value.APLateralMode = DATAREF_APLateralMode or 0
    TolissCP.Value.APVerticalArmed = DATAREF_APVerticalArmed or 0
    TolissCP.Value.APVerticalMode = DATAREF_APVerticalMode or 0
    TolissCP.Value.athr_thrust_mode = DATAREF_athr_thrust_mode or 0 -- THRUST MODE ENGAGED
    TolissCP.Value.ATHRmode = DATAREF_ATHRmode or 0
    TolissCP.Value.ATHRmode2 = DATAREF_ATHRmode2 or 0 -- SPECIAL MODE WHEN THRUST MODE ENGAGED (mach or speed)
    TolissCP.Value.gear = DATAREF_GearLever or 0
    TolissCP.Value.THRLeverMode = DATAREF_THRLeverMode or 0 -- THRUST MODE ARMED
    TolissCP.Value.vertical_velocity = DATAREF_vertical_velocity or 0

    -------------------------------------------------------------------------------
    -- TEMPORARY MESSAGE TO MAKE SURE THAT THE DEFAULT IS DONE IN THE RIGHT TIME --
    -------------------------------------------------------------------------------
    if not TolissCP.Object_sound:is_played("DefaultDone") then 
        TolissCP.Object_sound:insert("DefaultDone",0)
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
--|| TolissCP_DisplayValuesPanel() Display some informations for the Toliss Callout Pro into a widget || 
--++---------------------------------------------------------------------------------------------------++
function TolissCP_DisplayValuesPanel()
    
    local sGS = M_UTILITIES.Round(DATAREF_GSCapt)
    local sIAS = M_UTILITIES.Round(DATAREF_IASCapt)
    local sALT = M_UTILITIES.Round(DATAREF_altitude_ft_pilot)
    local sVSI = M_UTILITIES.Round(DATAREF_vvi_fpm_pilot)
    local sV1 = DATAREF_V1
    local sVR = DATAREF_VR
    local sREV = M_UTILITIES.Round(DATAREF_thrust_reverser_deploy_ratio)
    local sDistToDest = M_UTILITIES.Round(DATAREF_DistToDest,2)
    local sAPPhase = DATAREF_APPhase
    local sTOD = ""

    if TolissCP.isTodCaptured and TolissCP.Top_of_descent_value ~= 0 then
        sTOD = M_UTILITIES.Round(TolissCP.Top_of_descent_value,2).." NM"
    end

    XPLMSetGraphicsState(0,0,0,1,1,0,0)
    
    -- DRAW THE TITLE BOX (BOX COLOR CHANGE DEPENDING A WARNING)
    if DATAREF_APPhase == 3 and TolissCP.Top_of_descent_value == 0 then
        graphics.set_color(1, 0, 0, 0.8)
    else
        graphics.set_color(0.12,0.54,0.56, 1)
    end

    graphics.draw_rectangle(SCREEN_WIDTH - TolissCP.WINDOWX + 0, SCREEN_HIGHT - TolissCP.WINDOWY + 200, SCREEN_WIDTH - TolissCP.WINDOWX + 180, SCREEN_HIGHT - TolissCP.WINDOWY + 220)

    -- DRAW THE TITLE 
    graphics.set_color(1, 1, 1, 0.8)
    draw_string_Helvetica_18(SCREEN_WIDTH - TolissCP.WINDOWX + 5, SCREEN_HIGHT - TolissCP.WINDOWY + 202, "Toliss Callouts")       
    
    -- DRAW THE TRANSPARENT BACKGROUND
    graphics.set_color(0, 0, 0, 0.5) 
    graphics.draw_rectangle(SCREEN_WIDTH - TolissCP.WINDOWX + 0, SCREEN_HIGHT - TolissCP.WINDOWY + 10, SCREEN_WIDTH - TolissCP.WINDOWX + 180, SCREEN_HIGHT - TolissCP.WINDOWY + 200)
        
    glColor4f(M_COLORS.YELLOW.red, M_COLORS.YELLOW.green, M_COLORS.YELLOW.blue, 1)
    
    --[[
    draw_string_Times_Roman_24(800, 900, "PHASE              = "..DATAREF_APPhase or "")
    draw_string_Times_Roman_24(800, 870, "APVerticalMode     = "..DATAREF_APVerticalMode or "")
    draw_string_Times_Roman_24(800, 840, "APVerticalMode arm = "..DATAREF_APVerticalArmed or "")
    draw_string_Times_Roman_24(800, 810, "APLateralMode      = "..DATAREF_APLateralMode or "")
    draw_string_Times_Roman_24(800, 770, "Timer Thrust.      = "..TolissCP.Timer.ThrustEngagedMode)
    ]]
    -- DRAW THE PARAMETERS VALUES
    graphics.set_color(1, 1, 1, 0.8)

    if DATAREF_APPhase == 3 and TolissCP.Top_of_descent_value == 0 then
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 180, "WARNING")
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 160, "PLEASE PRESS")
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 140 , "PERF IN THE")
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 120, "LEFT FMS")
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 100, "TO CATCH")
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 80, " THE TOD VALUE")
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 60, "Dist brut: "..sDistToDest.." NM")
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 40, "tot_run_sec: "..M_UTILITIES.Round(DATAREF_total_running_time_sec,2))
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 20, "PHASE: "..sAPPhase)
    else
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 180, "GS: "..sGS.." m/sec")
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 160, "IAS: "..sIAS.." Kts")
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 140 , "ALT: "..sALT.." VSI: "..sVSI)
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 120, "BUG_V1: "..sV1)
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 100, "BUG_VR: "..sVR)
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 80, "REV: "..sREV)
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 60, "Dist brut: "..sDistToDest.." NM")
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 40, "PHASE: "..sAPPhase)
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 20, "TOD: "..sTOD)
    end

end 

--++--------------------------------------------------------------------------++
--|| TolissCP_TolissCallouts() is the main process of the Toliss Callout Pro || 
--++--------------------------------------------------------------------------++
function TolissCP_TolissCallouts()

    -- IMPORTANT STEP : DO NOT REMOVE IT (IN CASE OF RELOADING SITUATION FROM ISCS)
    if TolissCP.last_fuel_total < (DATAREF_m_fuel_total-3) or TolissCP.last_fuel_total > (DATAREF_m_fuel_total+3) then
        TolissCP.Object_sound:reset_isPlayed_flags_to_false(TolissCP.list_sounds)
        TolissCP.SetDefaultValues()
        TolissCP.last_fuel_total = DATAREF_m_fuel_total
        do return end        
    else
        TolissCP.last_fuel_total = DATAREF_m_fuel_total
    end

    TolissCP.Object_sound:process_sounds_queue() -- Process all sound in the sound queue

    -- CHECK AUTOPILOT PHASE
    if      DATAREF_APPhase == 0 then
            TolissCP.CheckAutopilotPhasePreflight()
    elseif  DATAREF_APPhase == 1 then
            TolissCP.CheckFlightModeAnnunciationsColumns()
            TolissCP.CheckAutopilotPhase_TakeOff()
            TolissCP.CheckFlapsAndGear()
    elseif  DATAREF_APPhase == 2 then
            TolissCP.CheckFlightModeAnnunciationsColumns()
            TolissCP.CheckAutopilotPhase_Climb()
            TolissCP.CheckFlapsAndGear()
    elseif  DATAREF_APPhase == 3 then
            TolissCP.CheckFlightModeAnnunciationsColumns()
            TolissCP.CheckAutopilotPhase_Cruize()
            TolissCP.CheckFlapsAndGear()
    elseif  DATAREF_APPhase == 4 then
            TolissCP.CheckFlightModeAnnunciationsColumns()
            TolissCP.CheckAutopilotPhase_Descent()
            TolissCP.CheckFlapsAndGear()
    elseif  DATAREF_APPhase == 5 then
            TolissCP.CheckFlightModeAnnunciationsColumns()
            TolissCP.CheckAutopilotPhase_Approach()
            TolissCP.CheckFlapsAndGear()
            TolissCP.isAutopilotPhasePreflightDone = false
    elseif  DATAREF_APPhase == 6 then
            TolissCP.CheckFlightModeAnnunciationsColumns()
            TolissCP.CheckAutopilotPhase_Go_around()
            TolissCP.CheckFlapsAndGear()
            TolissCP.isAutopilotPhasePreflightDone = false
    elseif  DATAREF_APPhase == 7 then
            TolissCP.CheckAutopilotPhase_Done()
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

    TolissCP.LoadingDataFromDataref()
    TolissCP.CreatingCustomDataref()

    TolissCP.list_sounds = TolissCP.PrepareSoundList()
    TolissCP.directory_sounds = SCRIPT_DIRECTORY.."ToLissCallout_sounds/"
    TolissCP.Object_sound = C_SOUNDS(TolissCP.directory_sounds,TolissCP.list_sounds,0.25,1)

    TolissCP.SetDefaultValues()

    do_every_draw("TolissCP_DisplayValuesPanel()")
    do_every_frame("TolissCP_TolissCallouts()")
    
end