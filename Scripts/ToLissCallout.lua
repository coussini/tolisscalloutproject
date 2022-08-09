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
local M_SOUNDS = require("Kaleidoscope.sounds")

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
    -------------------------------------------------------------------------------------------------
    -- Note : Keep only some values and bypass the other                                           --
    --        The 0 is important because it possible to go for speed event and after THR CLB event --
    -------------------------------------------------------------------------------------------------
    if M_UTILITIES.ItemListValid({0,1,2,3,4},DATAREF_THRLeverMode) then 
        if TolissCP.Value.THRLeverMode ~= DATAREF_THRLeverMode then
            TolissCP.Value.THRLeverMode = DATAREF_THRLeverMode
            TolissCP.Object_sound:set_isPlayed_flags("PF","Speed",false) -- reset this flag to allow another event like this
            TolissCP.Object_sound:set_isPlayed_flags("PF","Mach",false) -- reset this flag to allow another event like this
            TolissCP.Timer.ThrustEngagedMode = M_UTILITIES.SetTimer(1) -- waiting for the thrust lever to stay is in right position 
        end
    end

    ------------------------------------------
    -- MODE THAT THE AUTO THRUST IS ENGAGED --
    -------------------------------------------------------------------------------------------------
    -- Note : Keep only some values and bypass the other                                           --
    --        The 0 is important because it possible to go for speed event and after THR CLB event --
    -------------------------------------------------------------------------------------------------
    if M_UTILITIES.ItemListValid({0,1,2,3,4},DATAREF_athr_thrust_mode) and DATAREF_radio_altimeter_height_ft_pilot > 50 then
        if TolissCP.Value.athr_thrust_mode ~= DATAREF_athr_thrust_mode then
            TolissCP.Value.athr_thrust_mode = DATAREF_athr_thrust_mode
            TolissCP.Object_sound:set_isPlayed_flags("PF","Speed",false) -- reset this flag to allow another event like this
            TolissCP.Object_sound:set_isPlayed_flags("PF","Mach",false) -- reset this flag to allow another event like this
            TolissCP.Timer.ThrustEngagedMode = M_UTILITIES.SetTimer(1) -- waiting for the thrust lever to stay is in right position
        end
    end

    ----------------------------------------------------------------
    -- CHECK THE RELETED FMA COLUMNS AGAINST THE THRUST SITUATION --
    ----------------------------------------------------------------
    if TolissCP.Timer.ThrustEngagedMode ~= 0 and DATAREF_total_running_time_sec > TolissCP.Timer.ThrustEngagedMode then
        TolissCP.Timer.ThrustEngagedMode = 0
        if     DATAREF_THRLeverMode == 1 then 
            TolissCP.Object_sound:set_and_insert("PF","Man",0) 
            TolissCP.Object_sound:set_and_insert("PF","Thrust",0) 
        elseif DATAREF_THRLeverMode == 2 then 
            TolissCP.Object_sound:set_and_insert("PF","Man",0) 
            TolissCP.Object_sound:set_and_insert("PF","Flex",0) 
        elseif DATAREF_THRLeverMode == 3 then 
            TolissCP.Object_sound:set_and_insert("PF","Man",0) 
            TolissCP.Object_sound:set_and_insert("PF","TOGA",0) 
        elseif DATAREF_THRLeverMode == 4 then 
            TolissCP.Object_sound:set_and_insert("PF","Man",0) 
            TolissCP.Object_sound:set_and_insert("PF","MCT",0) 
        elseif DATAREF_athr_thrust_mode == 1 then 
            TolissCP.Object_sound:set_and_insert("PF","Thrust",0) 
            TolissCP.Object_sound:set_and_insert("PF","Climb",0) 
        elseif DATAREF_athr_thrust_mode == 2 then 
            TolissCP.Object_sound:set_and_insert("PF","Thrust",0) 
            TolissCP.Object_sound:set_and_insert("PF","MCT",0) 
        elseif DATAREF_athr_thrust_mode == 3 then 
            TolissCP.Object_sound:set_and_insert("PF","Thrust",0) 
            TolissCP.Object_sound:set_and_insert("PF","LVR",0) 
        elseif DATAREF_athr_thrust_mode == 4 then 
            TolissCP.Object_sound:set_and_insert("PF","Thrust",0) 
            TolissCP.Object_sound:set_and_insert("PF","Idle",0) 
        end
    end

end

--++---------------------------------------------------------------------------------++
--|| TolissCP.CheckFmaAutoThrustEngagedMode() check the FMA auto thrust engaged mode || 
--++---------------------------------------------------------------------------------++
function TolissCP.CheckFmaAutoThrustEngagedMode()

        if     DATAREF_ATHRmode2 == 4 and not TolissCP.Object_sound:is_played("PF","Speed") then 
            TolissCP.Object_sound:set_and_insert("PF","Speed",0) 
            TolissCP.Object_sound:set_isPlayed_flags("PF","Mach",false) -- reset this flag to allow another event like this
        elseif DATAREF_ATHRmode2 == 5 and not TolissCP.Object_sound:is_played("PF","Mach") then 
            TolissCP.Object_sound:set_and_insert("PF","Mach",0) 
            TolissCP.Object_sound:set_isPlayed_flags("PF","Speed",false) -- reset this flag to allow another event like this
        end 
    
end 

--++--------------------------------------------------------------------++
--|| TolissCP.CheckFmaVerticalEngagedMode() check the FMA vertical mode || 
--++--------------------------------------------------------------------++
function TolissCP.CheckFmaVerticalEngagedMode()

    ----------------------------------------
    -- MODE THAT THE AUTO THRUST IS ARMED --
    ----------------------------------------

    if M_UTILITIES.ItemListValid({0,1,2,3,4,6,7,8,101,102,103,104,105,112,113},DATAREF_APVerticalMode) then -- bypass all others values
        if TolissCP.Value.APVerticalMode ~= DATAREF_APVerticalMode then
            TolissCP.Value.APVerticalMode = DATAREF_APVerticalMode
            if     DATAREF_APVerticalMode == 0 then TolissCP.Object_sound:set_and_insert("PF","SRS",0) 
            elseif DATAREF_APVerticalMode == 1 then TolissCP.Object_sound:set_and_insert("PF","Climb",0) 
            elseif DATAREF_APVerticalMode == 2 then TolissCP.Object_sound:set_and_insert("PF","Descent",0) 
            elseif DATAREF_APVerticalMode == 3 then 
                TolissCP.Object_sound:set_and_insert("PF","Alt",0) 
                TolissCP.Object_sound:set_and_insert("PF","CST",0) 
                TolissCP.Object_sound:set_and_insert("PF","Star",0) 
            elseif DATAREF_APVerticalMode == 4 then 
                TolissCP.Object_sound:set_and_insert("PF","Alt",0) 
                TolissCP.Object_sound:set_and_insert("PF","CST",0) 
            elseif DATAREF_APVerticalMode == 6 then 
                TolissCP.Object_sound:set_and_insert("PF","GlideSlope",0) 
                TolissCP.Object_sound:set_and_insert("PF","Star",0) 
                TolissCP.Object_sound:set_and_insert("PF","PleaseSetGoAroundAltitude",0) 
                TolissCP.isMissedApproachWarning = true
            elseif DATAREF_APVerticalMode == 7 then TolissCP.Object_sound:set_and_insert("PF","GlideSlope",0) 
            elseif DATAREF_APVerticalMode == 8 then 
                TolissCP.Object_sound:set_and_insert("PF","FinalApproach",0) 
                TolissCP.Object_sound:set_and_insert("PF","PleaseSetGoAroundAltitude",0) 
                TolissCP.isMissedApproachWarning = true
            elseif DATAREF_APVerticalMode == 101 then 
                TolissCP.Object_sound:set_and_insert("PF","Open",0)
                TolissCP.Object_sound:set_and_insert("PF","Climb",0)
            elseif DATAREF_APVerticalMode == 102 then 
                TolissCP.Object_sound:set_and_insert("PF","Open",0)            
                TolissCP.Object_sound:set_and_insert("PF","Descent",0)            
            elseif DATAREF_APVerticalMode == 103 then 
                TolissCP.Object_sound:set_and_insert("PF","Alt",0) 
                TolissCP.Object_sound:set_and_insert("PF","Star",0) 
            elseif DATAREF_APVerticalMode == 104 then 
                if DATAREF_ALTCapt + 400 > DATAREF_cruise_alt then -- patch because ALT appear just before ALT CRZ
                else 
                    TolissCP.Object_sound:set_and_insert("PF","Alt",0) 
                end 
            elseif DATAREF_APVerticalMode == 105 then 
                TolissCP.isReachCruise = true            
                TolissCP.Object_sound:set_and_insert("PF","Alt",0) -- alt play before alt cruise so... only cruise 
                TolissCP.Object_sound:set_and_insert("PF","Cruise",0) -- alt play before alt cruise so... only cruise 
            elseif DATAREF_APVerticalMode == 112 then 
                TolissCP.Object_sound:set_and_insert("PF","Expedite",0) 
                TolissCP.Object_sound:set_and_insert("PF","Climb",0) 
            elseif DATAREF_APVerticalMode == 113 then 
                TolissCP.Object_sound:set_and_insert("PF","Expedite",0) 
                TolissCP.Object_sound:set_and_insert("PF","Descent",0) 
            end 
        end
    end

end

--++------------------------------------------------------------------++
--|| TolissCP.CheckFmaLateralEngagedMode() check the FMA lateral mode || 
--++------------------------------------------------------------------++
function TolissCP.CheckFmaLateralEngagedMode()

    if M_UTILITIES.ItemListValid({0,1,2,6,7,12,101},DATAREF_APLateralMode) then -- bypass all others values
        if TolissCP.Value.APLateralMode ~= DATAREF_APLateralMode then
            TolissCP.Value.APLateralMode = DATAREF_APLateralMode
            if     DATAREF_APLateralMode == 0 then TolissCP.Object_sound:set_and_insert("PF","RWY",0) 
            elseif DATAREF_APLateralMode == 1 then 
                TolissCP.Object_sound:set_and_insert("PF","RWY",0) 
                TolissCP.Object_sound:set_and_insert("PF","Track",0) 
            elseif DATAREF_APLateralMode == 2 then TolissCP.Object_sound:set_and_insert("PF","NAV",0) 
            elseif DATAREF_APLateralMode == 6 then 
                TolissCP.Object_sound:set_and_insert("PF","LOC",0) 
                TolissCP.Object_sound:set_and_insert("PF","Star",0) 
            elseif DATAREF_APLateralMode == 7 then TolissCP.Object_sound:set_and_insert("PF","LOC",0) 
            elseif DATAREF_APLateralMode == 12 then 
                TolissCP.Object_sound:set_and_insert("PF","GoAround",0) 
                TolissCP.Object_sound:set_and_insert("PF","Track",0) 
            elseif DATAREF_APLateralMode == 101 then 
                if M_UTILITIES.IndexOff(DATAREF_FMA1g," TRACK ") then
                    TolissCP.Object_sound:set_and_insert("PF","Track",0) 
                else
                    TolissCP.Object_sound:set_and_insert("PF","HDG",0) 
                end
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
            TolissCP.Object_sound:set_and_insert("PF","AP1On",0.5) 
            TolissCP.Object_sound:set_and_insert("PM","Checked",0) 
        end 
    end

    if TolissCP.Value.AP2Engage ~= DATAREF_AP2Engage then
        TolissCP.Value.AP2Engage = DATAREF_AP2Engage
        if DATAREF_AP2Engage == 1 then 
            TolissCP.Object_sound:set_and_insert("PF","AP2On",0.5) 
            TolissCP.Object_sound:set_and_insert("PM","Checked",0) 
        end 
    end

    -- auto pilot, flight director and auto thrust status
    if TolissCP.Value.ATHRmode ~= DATAREF_ATHRmode then 
        TolissCP.Value.ATHRmode = DATAREF_ATHRmode 
        if     DATAREF_ATHRmode == 1 then 
            TolissCP.Object_sound:set_and_insert("PF","ATHR",0) 
            TolissCP.Object_sound:set_and_insert("PF","Blue",0.5) 
            TolissCP.Object_sound:set_and_insert("PM","Checked",0.5) 
        elseif DATAREF_ATHRmode == 2 then 
            TolissCP.Object_sound:set_and_insert("PF","ATHR",0.5) 
            TolissCP.Object_sound:set_and_insert("PM","Checked",1) 
        end 
    end 

end

--++------------------------------------------------------------------------++
--|| TolissCP.CheckFmaVerticalArmedMode() check the FMA vertical armed mode || 
--++------------------------------------------------------------------------++
function TolissCP.CheckFmaVerticalArmedMode()
    -- 4 = DES; 5 = DES G/S; 7 = ALT G/S ;
    if M_UTILITIES.ItemListValid({6,7,8},DATAREF_APVerticalArmed) then -- bypass all others values
        if TolissCP.Value.APVerticalArmed ~= DATAREF_APVerticalArmed then
            TolissCP.Value.APVerticalArmed = DATAREF_APVerticalArmed
            TolissCP.Timer.VerticalArmedMode = M_UTILITIES.SetTimer(2) -- waiting for the alt button to stay is in right position
        end
    end

    if TolissCP.Value.AltitudeTargetChanged ~= DATAREF_ap_alt_target_value then
        TolissCP.Value.AltitudeTargetChanged = DATAREF_ap_alt_target_value
        TolissCP.Timer.VerticalArmedMode = M_UTILITIES.SetTimer(2) -- waiting for the alt button to stay is in right position
    end

    if TolissCP.Timer.VerticalArmedMode ~= 0 and DATAREF_total_running_time_sec > TolissCP.Timer.VerticalArmedMode then
        TolissCP.Timer.VerticalArmedMode = 0
        if     DATAREF_APVerticalArmed == 6 then 
            TolissCP.Object_sound:set_and_insert("PF","Alt",0) 
            --TolissCP.Object_sound:set_and_insert("FlightLevel",0) 
            TolissCP.Object_sound:insert_number("PF",DATAREF_ap_alt_target_value,0) 
            TolissCP.Object_sound:set_and_insert("PF","Blue",0) 
        elseif DATAREF_APVerticalArmed == 7 then 
            TolissCP.Object_sound:set_and_insert("PF","Alt",0) 
            TolissCP.Object_sound:set_and_insert("PF","GlideSlope",0) 
            --TolissCP.Object_sound:set_and_insert("FlightLevel",0) 
            TolissCP.Object_sound:insert_number("PF",DATAREF_ap_alt_target_value,0) 
            TolissCP.Object_sound:set_and_insert("PF","Blue",0) 
        elseif DATAREF_APVerticalArmed == 8 then 
            TolissCP.Object_sound:set_and_insert("PF","Alt",0) 
            --TolissCP.Object_sound:set_and_insert("FlightLevel",0) 
            TolissCP.Object_sound:insert_number("PF",DATAREF_ConstraintAlt,0) 
            TolissCP.Object_sound:set_and_insert("PF","Magenta",0) 
        end 
    end

end

--++---------------------------------------------------------------------------------------------------++
--|| TolissCP.EvaluateFlapsValue() check what is the state of the flaps, then play a sound about that || 
--++---------------------------------------------------------------------------------------------------++
function TolissCP.EvaluateFlapsValue(value)

    if     value == TolissCP.Flaps_valid[1] then 
        TolissCP.Object_sound:set_and_insert("PF","Flaps",0)
        TolissCP.Object_sound:set_and_insert("PF","0",0)
        TolissCP.Object_sound:set_and_insert("PM","Speed",0)
        TolissCP.Object_sound:set_and_insert("PM","Checked",0)
        TolissCP.Object_sound:set_and_insert("PM","Flaps",0)
        TolissCP.Object_sound:set_and_insert("PM","0",3)
        if DATAREF_APPhase < 3 then  
            TolissCP.Object_sound:set_and_insert("PF","ToTheLine",0)
        end
        TolissCP.Object_sound:set_isPlayed_flags("PM","VFE",false) -- reset this flag to allow another event like this
    elseif value == TolissCP.Flaps_valid[2] then 
        TolissCP.Object_sound:set_and_insert("PF","Flaps",0)
        TolissCP.Object_sound:set_and_insert("PF","1",0)
        TolissCP.Object_sound:set_and_insert("PM","Speed",0)
        TolissCP.Object_sound:set_and_insert("PM","Checked",0)
        TolissCP.Object_sound:set_and_insert("PM","Flaps",0)
        TolissCP.Object_sound:set_and_insert("PM","1",0)
        TolissCP.Object_sound:set_isPlayed_flags("PM","VFE",false) -- reset this flag to allow another event like this
    elseif value == TolissCP.Flaps_valid[3] then 
        TolissCP.Object_sound:set_and_insert("PF","Flaps",0)
        TolissCP.Object_sound:set_and_insert("PF","2",0)
        TolissCP.Object_sound:set_and_insert("PM","Speed",0)
        TolissCP.Object_sound:set_and_insert("PM","Checked",0)
        TolissCP.Object_sound:set_and_insert("PM","Flaps",0)
        TolissCP.Object_sound:set_and_insert("PM","2",0)
        TolissCP.Object_sound:set_isPlayed_flags("PM","VFE",false) -- reset this flag to allow another event like this
    elseif value == TolissCP.Flaps_valid[4] then 
        TolissCP.Object_sound:set_and_insert("PF","Flaps",0)
        TolissCP.Object_sound:set_and_insert("PF","3",0)
        TolissCP.Object_sound:set_and_insert("PM","Speed",0)
        TolissCP.Object_sound:set_and_insert("PM","Checked",0)
        TolissCP.Object_sound:set_and_insert("PM","Flaps",0)
        TolissCP.Object_sound:set_and_insert("PM","3",0)
    elseif value == TolissCP.Flaps_valid[5] then 
        TolissCP.Object_sound:set_and_insert("PF","Flaps",0)
        TolissCP.Object_sound:set_and_insert("PF","Full",0)
        TolissCP.Object_sound:set_and_insert("PM","Speed",0)
        TolissCP.Object_sound:set_and_insert("PM","Checked",0)
        TolissCP.Object_sound:set_and_insert("PM","Flaps",0)
        TolissCP.Object_sound:set_and_insert("PM","Full",0)
    else return TolissCP.LastFlapSet
    end

    return value

end

--++---------------------------------------------------------------++
--|| TolissCP.CheckFlapsAndGear() check all event around the flaps || 
--++---------------------------------------------------------------++
function TolissCP.CheckFlapsAndGear()

    if DATAREF_APPhase == 1 or DATAREF_APPhase == 2 then
        if DATAREF_IASCapt >= DATAREF_VF_value and DATAREF_VF_value > 0 and not TolissCP.Object_sound:is_played("PM","FSpeed") then
            TolissCP.Object_sound:set_and_insert("PM","FSpeed",0.5) 
        end
        if DATAREF_IASCapt >= DATAREF_VS_value and DATAREF_VS_value > 0 and not TolissCP.Object_sound:is_played("PM","SSpeed") then
            TolissCP.Object_sound:set_and_insert("PM","SSpeed",0.5) 
        end
    elseif DATAREF_APPhase == 4 or DATAREF_APPhase == 5 then
        if DATAREF_IASCapt <= DATAREF_VFENext_value and not TolissCP.Object_sound:is_played("PM","VFE") then
            TolissCP.Object_sound:set_and_insert("PM","VFE",0.5) 
        end
    end

    if DATAREF_FlapLeverRatio ~= TolissCP.LastFlapSet and M_UTILITIES.ItemListValid(TolissCP.Flaps_valid,DATAREF_FlapLeverRatio) then
        TolissCP.LastFlapSet = TolissCP.EvaluateFlapsValue(DATAREF_FlapLeverRatio)
    end

    if TolissCP.Value.gear ~= DATAREF_GearLever then
        TolissCP.Value.gear = DATAREF_GearLever
        if DATAREF_GearLever == 0 then 
            TolissCP.Object_sound:set_and_insert("PF","GearUp",0.5) 
            TolissCP.Object_sound:set_and_insert("PM","GearUp",0) 
        else
            TolissCP.Object_sound:set_and_insert("PF","GearDown",0.5)
            TolissCP.Object_sound:set_and_insert("PM","GearDown",0)
        end
    end

    if DATAREF_radio_altimeter_height_ft_pilot > 0 and DATAREF_radio_altimeter_height_ft_pilot < 500 then
        if not TolissCP.Object_sound:is_played("PM","PositiveClimb") then 
            if (M_UTILITIES.Round(DATAREF_vvi_fpm_pilot) > 500 and DATAREF_APPhase == 1) or  
               M_UTILITIES.Round(DATAREF_vvi_fpm_pilot) > 500 and DATAREF_APPhase == 6 then 
                TolissCP.Object_sound:set_and_insert("PM","PositiveClimb",1) 
            end
        end
    end

end

--++-----------------------------------------------------------------------------------------------------------++
--|| TolissCP.CalculateNowEvent() calculate the now event (barometer crosscheck) depending the VSI and the ALT || 
--++-----------------------------------------------------------------------------------------------------------++
function TolissCP.CalculateNowEvent(vsi,alt,climb)

    if climb then 
        return alt + ((vsi / 60) * 17)
    else
        return alt - ((vsi / 60) * 17)
    end

end

--++---------------------------------------------------------------------------------++
--|| TolissCP.CheckFlightModeAnnunciationsColumns() check severals FMA column events || 
--++---------------------------------------------------------------------------------++
function TolissCP.CheckFlightModeAnnunciationsColumns()

    TolissCP.CheckFmaThrustEngagedMode()  

    if TolissCP.Timer.ThrustEngagedMode == 0 then -- the throttle levers are not moving
        TolissCP.CheckFmaAutoThrustEngagedMode()
        TolissCP.CheckFmaVerticalEngagedMode()
        TolissCP.CheckFmaLateralEngagedMode()
        TolissCP.CheckFmaStatusAndSpecialMessagesEngagedMode()   
        TolissCP.CheckFmaVerticalArmedMode()
    end         

end

--++--------------------------------------------------------------------++
--|| TolissCP.CheckAutopilotPhasePreflight() check all preflight events || 
--++--------------------------------------------------------------------++
function TolissCP.CheckAutopilotPhasePreflight()

    --------------------------------------------
    -- ETAT AVION AVEC CHOCKS (STATIONNEMENT) --
    --------------------------------------------
    if DATAREF_Chocks == 1 then 
        --------------------------------
        -- ETAT AVION AVANT PUSH BACK --
        --------------------------------
        if DATAREF_beacon_on == 0 then 
            if not TolissCP.isAutopilotPhaseDone then 
                -- BOARDING COMPLETED --
                if DATAREF_SeatBeltSignsOn == 1 and DATAREF_CargoDoorArray == 0 and DATAREF_ExtPwr_on == 0 and not TolissCP.Object_sound:is_played("PF","FlightBoardingCompleted") then 
                    TolissCP.Object_sound:set_and_insert("PF","FlightBoardingCompleted",5) 
                    TolissCP.Object_sound:set_and_insert("PF","CptWelcome",1) 
                end
            else 
                -- AIRCRAFT / PARKING --
                if DATAREF_APUBleedSwitch == 1 and not TolissCP.Object_sound:is_played("PF","CptParking") then 
                    TolissCP.Object_sound:set_and_insert("PF","CptParking",1) 
                end
                -- RESET FOR NEXT FLIGHT --
                if  DATAREF_SeatBeltSignsOn == 0 and DATAREF_APUBleedSwitch == 0 then 
                    TolissCP.Object_sound:reset_isPlayed_flags_to_false(TolissCP.list_sounds)
                    TolissCP.SetDefaultValues()
                    TolissCP.isAutopilotPhaseDone = false                
                end
            end 
        ------------------------------------------
        -- ETAT AVION DURANT OU APRES PUSH BACK --
        ------------------------------------------
        else 
            -- JUST BEFORE PUSHBACK OU A L'ARRIVÉE AU TERMINAL --
            if not TolissCP.isAutopilotPhaseDone and not TolissCP.Object_sound:is_played("PF","DoorsCrossCheck") then 
                TolissCP.Object_sound:set_and_insert("PF","DoorsCrossCheck",1) 
            end
        end

    ----------------------------------------------------------------
    -- ETAT AVION SANS CHOCKS (PUSH BACK OU ROULEMENT VERS PISTE) --
    ----------------------------------------------------------------
    else 
        -- DURING PUSHBACK --
        if DATAREF_APUBleedSwitch == 1 and not TolissCP.Object_sound:is_played("PF","FlightAttAdvice") then 
            TolissCP.Object_sound:set_and_insert("PF","FlightAttAdvice",1) 
        end
        -- PREPARE TO TAKEOFF --
        if DATAREF_LeftLandLightExtended == 1 and DATAREF_RightLandLightExtended == 1 and not TolissCP.Object_sound:is_played("PF","CptTakeoff") then 
            TolissCP.Object_sound:set_and_insert("PF","CptTakeoff",1) 
        end
    end

    TolissCP.LastFlapSet = DATAREF_FlapLeverRatio

end

--++-----------------------------------------------------------------++
--|| TolissCP.CheckAutopilotPhase_TakeOff() check all takeoff events || 
--++-----------------------------------------------------------------++
function TolissCP.CheckAutopilotPhase_TakeOff()

    if DATAREF_IASCapt > 78 and DATAREF_IASCapt < 95 and not TolissCP.Object_sound:is_played("PM","Set") then 
        TolissCP.Object_sound:set_and_insert("PM","Thrust",0) 
        TolissCP.Object_sound:set_and_insert("PM","Set",0.5) 
        TolissCP.Object_sound:set_and_insert("PF","Checked",0) 
    end

    if DATAREF_IASCapt > 98 and DATAREF_IASCapt < 105 and not TolissCP.Object_sound:is_played("PM","100kts") then 
        TolissCP.Object_sound:set_and_insert("PM","100kts",0.5) 
        TolissCP.Object_sound:set_and_insert("PF","Checked",0) 
    end
        
    if M_UTILITIES.Round(DATAREF_IASCapt) >= DATAREF_V1 and not TolissCP.Object_sound:is_played("PM","V1") and DATAREF_V1 > 0 then 
        TolissCP.Object_sound:set_and_insert("PM","V1",0) 
    end

    if M_UTILITIES.Round(DATAREF_IASCapt) >=  DATAREF_VR and not TolissCP.Object_sound:is_played("PM","Rotate") and DATAREF_VR > 0 then 
        TolissCP.Object_sound:set_and_insert("PM","Rotate",0) 
    end

end

--++-------------------------------------------------------------++
--|| TolissCP.CheckAutopilotPhase_Climb() check all climb events || 
--++-------------------------------------------------------------++
function TolissCP.CheckAutopilotPhase_Climb()

    --if DATAREF_VGreenDot_value > 0 and  M_UTILITIES.Round(DATAREF_IASCapt) > DATAREF_VGreenDot_value  and M_UTILITIES.Round(DATAREF_IASCapt) < (DATAREF_VGreenDot_value + 5) and not TolissCP.Object_sound:is_played("DownToTheLine")  then
    --    TolissCP.Object_sound:set_and_insert("DownToTheLine",0) 
    --end

    if M_UTILITIES.Round(DATAREF_ALTCapt) > 9999 and M_UTILITIES.Round(DATAREF_ALTCapt) < 10005 and M_UTILITIES.Round(DATAREF_vvi_fpm_pilot) > 0 and not TolissCP.Object_sound:is_played("PF","Pass10000Feet")  then
        TolissCP.Object_sound:set_and_insert("PF","Pass10000Feet",0) 
    end

    if DATAREF_SeatBeltSignsOn == 0 and TolissCP.Object_sound:is_played("PF","Pass10000Feet") and not TolissCP.Object_sound:is_played("PF","ReleasedDuty") then
        TolissCP.Object_sound:set_and_insert("PF","ReleasedDuty",0) 
    end
    
    if DATAREF_ALTCapt > (DATAREF_DeptTrans + 200) and not TolissCP.Object_sound:is_played("PF","SetStandard") then
        TolissCP.Object_sound:set_and_insert("PF","SetStandard",2) 
    end

    if DATAREF_BaroStdCapt and M_UTILITIES.Round(DATAREF_barometer_setting,2) == 29.92 and TolissCP.Object_sound:is_played("PF","SetStandard") and not TolissCP.Object_sound:is_played("PM","StandardSet") then
        TolissCP.Object_sound:set_and_insert("PM","StandardSet",2) 
        TolissCP.Object_sound:set_and_insert("PM","Crosschecked",0)
        TolissCP.Object_sound:set_and_insert("PM","Passing",0) 
        TolissCP.Object_sound:set_and_insert("PM","FlightLevel",0)
        local now_event = M_UTILITIES.Round(TolissCP.CalculateNowEvent(M_UTILITIES.Round(DATAREF_vvi_fpm_pilot),M_UTILITIES.Round(DATAREF_ALTCapt),true))
        local fl = M_UTILITIES.Round(now_event / 100) -- Attention, ne dois pas dépasser le TOC
        TolissCP.Value.ALTCapt = fl * 100 
        TolissCP.Object_sound:insert_number("PM",fl)
    end

    if DATAREF_ALTCapt >= TolissCP.Value.ALTCapt and TolissCP.Object_sound:is_played("PM","StandardSet") and not TolissCP.Object_sound:is_played("PM","Now") then
        TolissCP.Object_sound:set_and_insert("PM","Now",3) 
        TolissCP.Object_sound:set_and_insert("PF","BelowTheLine",0) 
    end

end

--++---------------------------------------------------------------++
--|| TolissCP.CheckAutopilotPhase_Cruize() check all cruize events || 
--++---------------------------------------------------------------++
function TolissCP.CheckAutopilotPhase_Cruize()

    if TolissCP.isReachCruise and not TolissCP.Object_sound:is_played("PF","SetTCASToNeutral") and DATAREF_XPDRTCASAltSelect ~= 1 then 
        TolissCP.Object_sound:set_and_insert("PF","SetTCASToNeutral",4) 
        TolissCP.Object_sound:set_and_insert("PF","CptCruiseLvl",1) 
    end

    if M_UTILITIES.Round(DATAREF_DistToDest) <= 180 and M_UTILITIES.Round(DATAREF_DistToDest) >= 170 and not TolissCP.Object_sound:is_played("PF","Pass180NM") then 
        TolissCP.Object_sound:set_and_insert("PF","Pass180NM",1) 
    end

    if TolissCP.Top_of_descent_value <= 10 and not TolissCP.Object_sound:is_played("PF","Pass10NM") and TolissCP.isTodCaptured then 
        TolissCP.Object_sound:set_and_insert("PF","Pass10NM",0) 
    end    

end

--++-----------------------------------------------------------------++
--|| TolissCP.CheckAutopilotPhase_Descent() check all descent events || 
--++-----------------------------------------------------------------++
function TolissCP.CheckAutopilotPhase_Descent()

    if not TolissCP.Object_sound:is_played("PF","SetTCASToBelow") and DATAREF_XPDRTCASAltSelect ~= 2 then 
        TolissCP.Object_sound:set_and_insert("PF","SetTCASToBelow",4) 
        TolissCP.Object_sound:set_and_insert("PF","CptDescent",1) 
    end

    if M_UTILITIES.Round(DATAREF_ALTCapt) <= 9999 and M_UTILITIES.Round(DATAREF_ALTCapt) > 9995 and M_UTILITIES.Round(DATAREF_vvi_fpm_pilot) < 0 and not TolissCP.Object_sound:is_played("PF","Pass10000Feet")  then
        TolissCP.Object_sound:set_and_insert("PF","Pass10000Feet",0) 
    end
    
    if DATAREF_ALTCapt < (DATAREF_DestTrans - 200) and not TolissCP.Object_sound:is_played("PF","SetAltimeter") then
        airports = TolissCP.GetAirportNames()
        TolissCP.Object_sound:set_and_insert("PF","SetAltimeter",0.5) 
        if (DATAREF_DestQNH * 100) >= 2300 and (DATAREF_DestQNH * 100) <= 3300 then -- 23.00 - 33.00
            local DestQNH = M_UTILITIES.Round(DATAREF_DestQNH, 2)
            local DestQNHpart1 = math.floor(DestQNH)
            local DestQNHpart2 = M_UTILITIES.GetDecimal(DestQNH) 
            TolissCP.Object_sound:insert_number("PF",DestQNHpart1)
            TolissCP.Object_sound:set_and_insert("PF","DOT",0) 
            TolissCP.Object_sound:insert_number("PF",DestQNHpart2)
        else -- 779 - 1118 
            TolissCP.Object_sound:insert_number("PF",DATAREF_DestQNH)
        end
    end

    if M_UTILITIES.Round(DATAREF_barometer_setting,2) == M_UTILITIES.Round(DATAREF_DestQNH,2) and TolissCP.Object_sound:is_played("PF","SetAltimeter") and not TolissCP.Object_sound:is_played("PM","AltimeterSet") then
        TolissCP.Object_sound:set_and_insert("PM","AltimeterSet",2) 
        TolissCP.Object_sound:set_and_insert("PM","Crosschecked",0)
        TolissCP.Object_sound:set_and_insert("PM","Passing",0) 
        TolissCP.Object_sound:set_and_insert("PM","FlightLevel",0)
        local now_event = M_UTILITIES.Round(TolissCP.CalculateNowEvent(M_UTILITIES.Round(DATAREF_vvi_fpm_pilot),M_UTILITIES.Round(DATAREF_ALTCapt),true))
        local fl = M_UTILITIES.Round(now_event / 100) -- Attention, ne dois pas dépasser le TOC
        TolissCP.Value.ALTCapt = fl * 100 
        TolissCP.Object_sound:insert_number("PM",fl,0)
    end

    if DATAREF_ALTCapt <= TolissCP.Value.ALTCapt and TolissCP.Object_sound:is_played("PM","AltimeterSet") and not TolissCP.Object_sound:is_played("PM","Now") then
        TolissCP.Object_sound:set_and_insert("PM","Now",0) 
    end

end

--++-------------------------------------------------------------------++
--|| TolissCP.CheckAutopilotPhase_Approach() check all approach events || 
--++-------------------------------------------------------------------++
function TolissCP.CheckAutopilotPhase_Approach()

    ----------------------------------
    -- Land Green event (REACH 400) --
    ----------------------------------
    if DATAREF_radio_altimeter_height_ft_pilot < 360  and DATAREF_APVerticalMode == 11 and not TolissCP.Object_sound:is_played("PF","Land") then
        TolissCP.Object_sound:set_and_insert("PF","Land",0) 
        TolissCP.Object_sound:set_and_insert("PF","Green",0) 
    end

    -------------------------------------------------------------------------
    -- ILS approach capability and Missed Approach Set advice (REACH 2000) --
    -------------------------------------------------------------------------
    if DATAREF_radio_altimeter_height_ft_pilot < 1980 and TolissCP.isMissedApproachWarning and not TolissCP.Object_sound:is_played("PF","MissedApproachSet") then
        if DATAREF_approach_type == 0 then -- ILS Approach
            TolissCP.Object_sound:set_and_insert("PF","ApproachSet",0) 
            if DATAREF_AP1Engage == 0 and DATAREF_AP2Engage == 0  and DATAREF_APPRilluminated == 1 and DATAREF_APVerticalMode ~= 8 then 
                TolissCP.Object_sound:set_and_insert("PF","CAT1",0) 
            elseif DATAREF_AP1Engage == 1 and DATAREF_AP2Engage == 1 and DATAREF_APPRilluminated == 1 then 
                TolissCP.Object_sound:set_and_insert("PF","CAT3",0) 
                TolissCP.Object_sound:set_and_insert("PF","Dual",0) 
            elseif DATAREF_AP1Engage == 1 or DATAREF_AP2Engage == 1 and DATAREF_APPRilluminated == 1 then 
                TolissCP.Object_sound:set_and_insert("PF","CAT3",0) 
                TolissCP.Object_sound:set_and_insert("PF","Single",0) 
            end
        end

        if DATAREF_MDA <= 0 and DATAREF_DH <= 0 then -- the value can be negative (probably feed by the toliss managment) 
            TolissCP.Object_sound:set_and_insert("PF","NODH",0) 
        end

        TolissCP.Object_sound:set_and_insert("PF","CptLanding",2) 
        TolissCP.Object_sound:set_and_insert("PF","MissedApproachSet",0) 
        TolissCP.Object_sound:insert_number("PF",DATAREF_ap_altitude_reference,0) 
        TolissCP.Object_sound:set_and_insert("PF","Blue",0) 
    end

    if DATAREF_thrust_reverser_deploy_ratio > 0.99 and not TolissCP.Object_sound:is_played("PF","Reversers") then 
        TolissCP.Object_sound:set_and_insert("PF","Reversers",0) 
        TolissCP.Object_sound:set_and_insert("PF","Green",0) 
    end

    if DATAREF_IASCapt < 62  and not TolissCP.Object_sound:is_played("PM","60kts") then 
        TolissCP.Object_sound:set_and_insert("PM","60kts",0) 
    end

end

--++---------------------------------------------------------------------++
--|| TolissCP.CheckAutopilotPhase_Go_around() check all go around events || 
--++---------------------------------------------------------------------++
function TolissCP.CheckAutopilotPhase_Go_around()

    if not TolissCP.Object_sound:is_played("PF","GoAround") then 
        TolissCP.Object_sound:set_isPlayed_flags("PF","PositiveClimb",false) -- reset this event to allow another one
        TolissCP.Object_sound:set_and_insert("PF","GoAround",0) 
    end

end

--++-------------------------------------------------------------++
--|| TolissCP.CheckAutopilotPhase_Done() check all "done" events || 
--++-------------------------------------------------------------++
function TolissCP.CheckAutopilotPhase_Done()

    TolissCP.isAutopilotPhaseDone = true
    
end

--++-------------------------------------------------------------++
--|| TolissCP.GetAndUpdateTopOfDescent() check all "done" events || 
--++-------------------------------------------------------------++
function TolissCP.GetAndUpdateTopOfDescent()

    if string.find(DATAREF_MCDU2cont2g,"(T/D)") == nil or string.find(DATAREF_MCDU2cont2g,"(T/D)") == "" then 
        command_once("AirbusFBW/MCDU2Perf")
    else
        local tod_value = TolissCP.CatchTODTime(DATAREF_MCDU2cont3g)
        TolissCP.DESCENTNM = DATAREF_DistToDest - tod_value
        TolissCP.isTodCaptured = true            
        TolissCP.Top_of_descent_value = DATAREF_DistToDest-TolissCP.DESCENTNM -- the running value of the top of descent from the MDCU perf page
        CUS_distance_to_tod = TolissCP.Top_of_descent_value
    end

end

--++-------------------------------------------------------------++
--|| TolissCP.GetAirportNames() check all "done" events || 
--++-------------------------------------------------------------++
function TolissCP.GetAirportNames()

    if string.find(DATAREF_MCDU2cont1b,"LOAD") == nil or string.find(DATAREF_MCDU2cont1b,"LOAD") == "" then 
        command_once("AirbusFBW/MCDU2Init")
    else
        local airports = M_UTILITIES.LastWord(M_UTILITIES.TrimLeading(DATAREF_MCDU2cont1b))
        local airports = M_UTILITIES.SplitWord(M_UTILITIES.ReplaceString(airports,"/"," "))
        command_once("AirbusFBW/MCDU2Fpln")
        return airports
    end

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

    DataRef("DATAREF_ALTCapt","AirbusFBW/ALTCapt","readonly")
    DataRef("DATAREF_ALTisCstr","AirbusFBW/ALTisCstr","readonly")
    DataRef("DATAREF_AP1Engage","AirbusFBW/AP1Engage","readonly")
    DataRef("DATAREF_AP2Engage","AirbusFBW/AP2Engage","readonly")
    DataRef("DATAREF_ap_alt_target_value","toliss_airbus/pfdoutputs/general/ap_alt_target_value","readonly")
    DataRef("DATAREF_ap_altitude_reference","toliss_airbus/pfdoutputs/general/ap_altitude_reference","readonly")
    DataRef("DATAREF_APLateralMode","AirbusFBW/APLateralMode","readonly")
    DataRef("DATAREF_APPhase","AirbusFBW/APPhase","readonly")  
    DataRef("DATAREF_APPRilluminated","AirbusFBW/APPRilluminated","readonly")
    DataRef("DATAREF_approach_type","toliss_airbus/pfdoutputs/general/approach_type","readonly")  
    DataRef("DATAREF_APUBleedSwitch","AirbusFBW/APUBleedSwitch","readonly") -- FlightAttAdvice
    DataRef("DATAREF_APVerticalArmed","AirbusFBW/APVerticalArmed","readonly")  
    DataRef("DATAREF_APVerticalMode","AirbusFBW/APVerticalMode","readonly")
    DataRef("DATAREF_athr_thrust_mode","toliss_airbus/pfdoutputs/general/athr_thrust_mode","readonly")
    DataRef("DATAREF_ATHRmode","AirbusFBW/ATHRmode","readonly")
    DataRef("DATAREF_ATHRmode2","AirbusFBW/ATHRmode2","readonly")
    DataRef("DATAREF_barometer_setting","sim/cockpit/misc/barometer_setting","readonly")
    DataRef("DATAREF_barometer_setting2","sim/cockpit/misc/barometer_setting2","readonly")
    DataRef("DATAREF_BaroStdCapt","AirbusFBW/BaroStdCapt","readonly")
    DataRef("DATAREF_beacon_on","AirbusFBW/OHPLightSwitches","readonly",0) -- Indice 0 = Beacon 
    DataRef("DATAREF_CargoDoorArray","AirbusFBW/CargoDoorArray","readonly",0) -- Indice 0 de l'array
    DataRef("DATAREF_Chocks","AirbusFBW/Chocks","readonly")
    DataRef("DATAREF_ConstraintAlt","AirbusFBW/ConstraintAlt","readonly")
    DataRef("DATAREF_cruise_alt","toliss_airbus/init/cruise_alt","readonly")
    DataRef("DATAREF_DeptTrans","toliss_airbus/performance/DeptTrans","readonly")
    DataRef("DATAREF_DestQNH","toliss_airbus/performance/DestQNH","readonly")
    DataRef("DATAREF_DestTrans","toliss_airbus/performance/DestTrans","readonly")
    DataRef("DATAREF_DH","toliss_airbus/performance/DH","readonly")
    DataRef("DATAREF_DistToDest","AirbusFBW/DistToDest","readonly")
    DataRef("DATAREF_ExtPwr_on","AirbusFBW/ElecOHPArray","readonly",3) -- Indice 3 = Ext Pwr
    DataRef("DATAREF_FlapLeverRatio","AirbusFBW/FlapLeverRatio","readonly")
    DataRef("DATAREF_FMA1g","AirbusFBW/FMA1g","readonly",0) 
    DataRef("DATAREF_GearLever","AirbusFBW/GearLever","readonly")
    DataRef("DATAREF_GSCapt","AirbusFBW/GSCapt","readonly") -- for displaying value only ???
    DataRef("DATAREF_HideBaroCapt","AirbusFBW/HideBaroCapt","readonly")
    DataRef("DATAREF_IASCapt","AirbusFBW/IASCapt","readonly")
    DataRef("DATAREF_LeftLandLightExtended","AirbusFBW/LeftLandLightExtended","readonly") -- CptTakeoff
    DataRef("DATAREF_m_fuel_total","sim/flightmodel/weight/m_fuel_total","readonly")
    DataRef("DATAREF_MCDU2cont1b","AirbusFBW/MCDU2cont1b","readonly",0)
    DataRef("DATAREF_MCDU2cont2g","AirbusFBW/MCDU2cont2g","readonly",0)
    DataRef("DATAREF_MCDU2cont3g","AirbusFBW/MCDU2cont3g","readonly",0)
    DataRef("DATAREF_MDA","toliss_airbus/performance/MDA","readonly")
    DataRef("DATAREF_radio_altimeter_height_ft_pilot","sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot","readonly")
    DataRef("DATAREF_RightLandLightExtended","AirbusFBW/RightLandLightExtended","readonly") -- CptTakeoff
    DataRef("DATAREF_SeatBeltSignsOn","AirbusFBW/SeatBeltSignsOn","readonly")
    DataRef("DATAREF_THRLeverMode","AirbusFBW/THRLeverMode","readonly")
    DataRef("DATAREF_thrust_reverser_deploy_ratio","sim/flightmodel2/engines/thrust_reverser_deploy_ratio","readonly",0)    
    DataRef("DATAREF_total_running_time_sec","sim/time/total_running_time_sec","readonly")
    DataRef("DATAREF_V1","toliss_airbus/performance/V1","readonly")
    DataRef("DATAREF_VF_value","toliss_airbus/pfdoutputs/general/VF_value","readonly")
    DataRef("DATAREF_VFENext_value","toliss_airbus/pfdoutputs/general/VFENext_value","readonly")
    DataRef("DATAREF_VGreenDot_value","toliss_airbus/pfdoutputs/general/VGreenDot_value","readonly")
    DataRef("DATAREF_VR","toliss_airbus/performance/VR","readonly")
    DataRef("DATAREF_VS_value","toliss_airbus/pfdoutputs/general/VS_value","readonly")
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

--++----------------------------------------------------------------------++
--|| TolissCP.CreatingCustomDataref() create datarefs for internal usage || 
--++----------------------------------------------------------------------++
function TolissCP.ReadMetarFile()

    M_UTILITIES.OutputLog("Metar Read : "..SYSTEM_DIRECTORY.."METAR.rwx")

    return M_UTILITIES.ReadFile(SYSTEM_DIRECTORY.."METAR.rwx")

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
    table.insert(list_sounds,"80kts")
    table.insert(list_sounds,"Alt")
    table.insert(list_sounds,"AltimeterSet")
    table.insert(list_sounds,"AP1On")
    table.insert(list_sounds,"AP2On")
    table.insert(list_sounds,"ApproachSet")
    table.insert(list_sounds,"ATHR")
    table.insert(list_sounds,"BelowTheLine")
    table.insert(list_sounds,"Blue")
    table.insert(list_sounds,"CAT1")
    table.insert(list_sounds,"CAT3")
    table.insert(list_sounds,"Checked")
    table.insert(list_sounds,"Climb")
    table.insert(list_sounds,"CptCruiseLvl")
    table.insert(list_sounds,"CptDescent")
    table.insert(list_sounds,"CptLanding")
    table.insert(list_sounds,"CptParking")
    table.insert(list_sounds,"CptTakeoff")
    table.insert(list_sounds,"CptWelcome")
    table.insert(list_sounds,"Crosschecked")
    table.insert(list_sounds,"Cruise")
    table.insert(list_sounds,"CST")
    table.insert(list_sounds,"Descent")
    table.insert(list_sounds,"DoorsCrossCheck")
    table.insert(list_sounds,"DOT")
    table.insert(list_sounds,"Dual")
    table.insert(list_sounds,"Expedite")
    table.insert(list_sounds,"FinalApproach")
    table.insert(list_sounds,"Flaps")
    table.insert(list_sounds,"Flex")
    table.insert(list_sounds,"FlightAttAdvice")
    table.insert(list_sounds,"FlightBoardingCompleted")
    table.insert(list_sounds,"FlightLevel")
    table.insert(list_sounds,"For")
    table.insert(list_sounds,"FSpeed")
    table.insert(list_sounds,"Full")
    table.insert(list_sounds,"GearDown")
    table.insert(list_sounds,"GearUp")
    table.insert(list_sounds,"GlideSlope")
    table.insert(list_sounds,"GoAround")
    table.insert(list_sounds,"Green")
    table.insert(list_sounds,"HDG")
    table.insert(list_sounds,"Hundred")
    table.insert(list_sounds,"Idle")
    table.insert(list_sounds,"Land")
    table.insert(list_sounds,"LOC")
    table.insert(list_sounds,"LVR")
    table.insert(list_sounds,"Mach")
    table.insert(list_sounds,"Magenta")
    table.insert(list_sounds,"Man")
    table.insert(list_sounds,"MCT")
    table.insert(list_sounds,"MissedApproachSet")
    table.insert(list_sounds,"NAV")
    table.insert(list_sounds,"Now")
    table.insert(list_sounds,"Open")
    table.insert(list_sounds,"Pass10000Feet")
    table.insert(list_sounds,"Pass10NM")
    table.insert(list_sounds,"Pass180NM")
    table.insert(list_sounds,"Passing")
    table.insert(list_sounds,"PleaseSetGoAroundAltitude")
    table.insert(list_sounds,"PositiveClimb")
    table.insert(list_sounds,"Ready")
    table.insert(list_sounds,"ReleasedDuty")
    table.insert(list_sounds,"Reversers")
    table.insert(list_sounds,"Rotate")
    table.insert(list_sounds,"RWY")
    table.insert(list_sounds,"Set")
    table.insert(list_sounds,"SetAltimeter")
    table.insert(list_sounds,"SetStandard")
    table.insert(list_sounds,"SetTCASToBelow")
    table.insert(list_sounds,"SetTCASToNeutral")
    table.insert(list_sounds,"Single")
    table.insert(list_sounds,"Speed")
    table.insert(list_sounds,"SRS")
    table.insert(list_sounds,"SSpeed")
    table.insert(list_sounds,"StandardSet")
    table.insert(list_sounds,"Star")
    table.insert(list_sounds,"Takeoff")
    table.insert(list_sounds,"Thousand")
    table.insert(list_sounds,"Thrust")
    table.insert(list_sounds,"TOGA")
    table.insert(list_sounds,"ToTheLine")
    table.insert(list_sounds,"Track")
    table.insert(list_sounds,"V1")
    table.insert(list_sounds,"VFE")
    
    M_UTILITIES.OutputLog("TolissCP.PrepareSoundList")

    return list_sounds

end 

--++---------------------------------------------------------------------------------------++
--|| TolissCP.SetDefaultValues() important function to initialize some critical variables || 
--++---------------------------------------------------------------------------------------++
function TolissCP.SetDefaultValues()

    TolissCP.WINDOWX = 150 -- DISPLAY POSITION FROM RIGHT EDGE OF WINDOW
    TolissCP.WINDOWY = 250 -- DISPLAY POSITION FROM TOP EDGE OF WINDOW

    -----------
    -- FLAGS --
    -----------
    TolissCP.isAutopilotPhaseDone = false 
    TolissCP.isMissedApproachWarning = false 
    TolissCP.isReachCruise = false 
    TolissCP.isTodCaptured = false 

    ----------------------------------
    -- VARIABLE THAT AFFECTS EVENTS --
    ----------------------------------
    TolissCP.Flaps_valid = {0.00,0.25,0.50,0.75,1.00}
    TolissCP.last_fuel_total = DATAREF_m_fuel_total -- IMPORTANT LINE. DO NOT DELETE IT
    TolissCP.LastFlapSet = DATAREF_FlapLeverRatio
    TolissCP.Top_of_descent_value = 0

    -----------------------------------
    -- TIMER FOR A SPECIFIC VARIABLE --
    -----------------------------------
    TolissCP.Timer = {}
    TolissCP.Timer.ThrustEngagedMode = 0
    TolissCP.Timer.VerticalArmedMode = 0
   
    ---------------------
    -- VARIABLE VALUE  --
    ---------------------
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
    TolissCP.Value.ALTCapt = DATAREF_ALTCapt or 0 -- ALTCapt

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
    local sALT = M_UTILITIES.Round(DATAREF_ALTCapt)
    local sVSI = M_UTILITIES.Round(DATAREF_vvi_fpm_pilot)
    local sV1 = DATAREF_V1
    local sVR = DATAREF_VR
    local sREV = M_UTILITIES.Round(DATAREF_thrust_reverser_deploy_ratio)
    local sDistToDest = M_UTILITIES.Round(DATAREF_DistToDest,2)
    local sAPPhase = DATAREF_APPhase

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
    draw_string_Times_Roman_24(800, 900, "PHASE                    = "..DATAREF_APPhase or "")
    draw_string_Times_Roman_24(800, 870, "DATAREF_APVerticalArmed     = "..DATAREF_APVerticalArmed or "")
    draw_string_Times_Roman_24(800, 840, "DATAREF_athr_thrust_mode = "..DATAREF_athr_thrust_mode or "")
    draw_string_Times_Roman_24(800, 810, "TolissCP.Value.athr_thrust_mode         = "..TolissCP.Value.athr_thrust_mode or "")
    draw_string_Times_Roman_24(800, 770, "DATAREF_ATHRmode2        = "..DATAREF_ATHRmode2)
    draw_string_Times_Roman_24(800, 740, "TolissCP.Value.ATHRmode2        = "..TolissCP.Value.ATHRmode2)
    ]]
    
    -- DRAW THE PARAMETERS VALUES
    graphics.set_color(1, 1, 1, 0.8)

    draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 180, "GS: "..sGS.." m/sec")
    draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 160, "IAS: "..sIAS.." Kts")
    draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 140 , "ALT: "..sALT.." VSI: "..sVSI)
    draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 120, "BUG_V1: "..sV1)
    draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 100, "BUG_VR: "..sVR)
    draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 80, "REV: "..sREV)
    draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 60, "Dist brut: "..sDistToDest.." NM")
    draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 40, "PHASE: "..sAPPhase)
    if TolissCP.isTodCaptured and TolissCP.Top_of_descent_value ~= 0 and DATAREF_APPhase == 3 then
        sTOD = M_UTILITIES.Round(TolissCP.Top_of_descent_value,2).." NM"
        draw_string_Helvetica_12(SCREEN_WIDTH - TolissCP.WINDOWX + 10, SCREEN_HIGHT - TolissCP.WINDOWY + 20, "TOD: "..sTOD)        
    end

    

end 

--++--------------------------------------------------------------------------++
--|| TolissCP_TolissCallouts() is the main process of the Toliss Callout Pro || 
--++--------------------------------------------------------------------------++
function TolissCP_TolissCallouts()

    ----------------------------------------------------------------------------------
    -- IMPORTANT STEP : DO NOT REMOVE IT (IN CASE OF RELOADING SITUATION FROM ISCS) --
    ----------------------------------------------------------------------------------
    if TolissCP.last_fuel_total < (DATAREF_m_fuel_total-3) or TolissCP.last_fuel_total > (DATAREF_m_fuel_total+3) then
        TolissCP.Object_sound:reset_isPlayed_flags_to_false(TolissCP.list_sounds)
        TolissCP.SetDefaultValues()
        TolissCP.last_fuel_total = DATAREF_m_fuel_total
        do return end        
    else
        TolissCP.last_fuel_total = DATAREF_m_fuel_total
    end

    ------------------------------------------
    -- PROCESS ALL SOUND IN THE SOUND QUEUE --
    ------------------------------------------
    TolissCP.Object_sound:process_sounds_queue()

    ---------------------------
    -- CHECK AUTOPILOT PHASE --
    ---------------------------
    if      DATAREF_APPhase == 0 then
            TolissCP.CheckAutopilotPhasePreflight()
    elseif  DATAREF_APPhase == 1 then
            if not TolissCP.Object_sound:is_played("PF","Takeoff") then 
                TolissCP.Object_sound:set_and_insert("PF","Takeoff",2) 
            end
            TolissCP.CheckFlightModeAnnunciationsColumns()
            TolissCP.CheckAutopilotPhase_TakeOff()
            TolissCP.CheckFlapsAndGear()
    elseif  DATAREF_APPhase == 2 then
            TolissCP.CheckFlightModeAnnunciationsColumns()
            TolissCP.CheckAutopilotPhase_Climb()
            TolissCP.CheckFlapsAndGear()
    elseif  DATAREF_APPhase == 3 then
            TolissCP.Object_sound:set_isPlayed_flags("PF","SetStandard",false) -- reset this flag to allow another event like this
            TolissCP.CheckFlightModeAnnunciationsColumns()
            TolissCP.CheckAutopilotPhase_Cruize()
            TolissCP.CheckFlapsAndGear()
            TolissCP.GetAndUpdateTopOfDescent()
    elseif  DATAREF_APPhase == 4 then
            TolissCP.CheckFlightModeAnnunciationsColumns()
            TolissCP.CheckAutopilotPhase_Descent()
            TolissCP.CheckFlapsAndGear()
    elseif  DATAREF_APPhase == 5 then
            TolissCP.CheckFlightModeAnnunciationsColumns()
            TolissCP.CheckAutopilotPhase_Approach()
            TolissCP.CheckFlapsAndGear()
    elseif  DATAREF_APPhase == 6 then
            TolissCP.CheckFlightModeAnnunciationsColumns()
            TolissCP.CheckAutopilotPhase_Go_around()
            TolissCP.CheckFlapsAndGear()
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
    TolissCP.metar_data = TolissCP.ReadMetarFile()

    TolissCP.list_sounds = TolissCP.PrepareSoundList()
    local directory_PF = SCRIPT_DIRECTORY.."ToLissCallout_sounds/Susan/"
    local directory_PM = SCRIPT_DIRECTORY.."ToLissCallout_sounds/Alex/"
    TolissCP.Object_sound = C_SOUNDS(directory_PF,directory_PM,TolissCP.list_sounds,0.25,1)

    TolissCP.SetDefaultValues()
    
    do_every_draw("TolissCP_DisplayValuesPanel()")
    do_every_frame("TolissCP_TolissCallouts()")
    
end
