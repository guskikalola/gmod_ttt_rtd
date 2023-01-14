include("autorun/shared/sh_events.lua")

RTDCore = {}
RTDCore.__index = RTDCore

-- Store RTD used in this round ( will clear when new round begins )
rtd_used_logs = {}
-- This variable is changed using TTT hooks
round_active = false
-- Current round identifier, set using hooks and calculated with current date
current_round_identifier = nil

local function inTable(player)
    for key, value in pairs(rtd_used_logs) do
        if key == player then return true end
    end
    return false
end

function RTDCore:can_use_rtd(player)
    local can_use = true 
    local message = ""

    if not round_active then
        can_use = false
        message = "La ronda no esta activa, no puedes usarlo ahora."        
    elseif not player:Alive() or player:IsFrozen() then
        can_use = false
        message = "Solo puedes usar esto estando vivo durante la ronda."
    elseif inTable(player) then
        can_use = false
        message = "Solo se puede usar una vez por ronda!"
    end

    local result = {}
    result["can_use"] = can_use
    result["message"] = message

    if engine.ActiveGamemode() == "sandbox" then -- Disable limitations in sandbox, spam it lets gooo 
        result["can_use"] = true
    end
    
    return result
end

function RTDCore:store_log(player, rtd_result)
    rtd_used_logs[player] = rtd_result
end

function RTDCore:clear_logs()
    rtd_used_logs = {}
end

function RTDCore:run_disable()
    for player, event in pairs(rtd_used_logs) do
        event:disable(player)
    end
end

function RTDCore:begin_round()
    RTDCore:clear_logs()
    current_round_identifier = CurTime()
    round_active = true
end

function RTDCore:end_round()
    current_round_identifier = nil
    round_active = false
    -- RTDCore:run_disable()
end

function RTDCore:sameRound(round_identifier)
    return true -- round_identifier == current_round_identifier
end

function RTDCore:random_event()
    local cumulativeProbability = 0
    for k, v in pairs(events) do
        cumulativeProbability = cumulativeProbability + v["probability"]
    end
    local remainingDistance = math.random() * cumulativeProbability
    for k, v in RandomPairs(events) do
        remainingDistance = remainingDistance - v["probability"]
        if remainingDistance < 0 then
            return v
        end
    end
end

function RTDCore:globalNotify(player, message)
    ULib.tsayColor(player, true, Color(200,0,205,255),  "[RTD] " , Color(204,100,255,255), event["name"] .. ": " , Color(204,255,255,255), message )
    ULib.csay(player, "[RTD] " .. event["name"] .. ": " .. message, Color(200,0,205,255), 10, 0.5)
end

function RTDCore:notificate(player, event)
    ULib.tsayColor(player, true, Color(200,0,205,255),  "[RTD] " , Color(204,100,255,255), event["name"] .. ": " , Color(204,255,255,255), event["description"] )
    ULib.csay(player, "[RTD] " .. event["name"] .. ": " .. event["description"], Color(200,0,205,255), 10, 0.5)
end

function RTDCore:notifyEnd(player, event_name)
    ULib.tsayColor(player, true, Color(200,0,205,255), "[RTD] ", Color(204,255,255,255), "Se ha acabado el efecto: " .. event_name )
end

function RTDCore:runRTD(player)
    event = RTDCore:random_event()
    RTDCore:store_log(player,event)
    RTDCore:notificate(player,event)
    event:run(event, player, current_round_identifier)
end