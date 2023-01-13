include("autorun/shared/sh_events.lua")

RTDCore = {}
RTDCore.__index = RTDCore

-- Store RTD used in this round ( will clear when new round begins )
rtd_used_logs = {}
-- This variable is changed using TTT hooks
round_active = false

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
    
    return result
end

function RTDCore:store_log(player, rtd_result)
    rtd_used_logs[player] = rtd_result
end

function RTDCore:clear_logs()
    rtd_used_logs = {}
end

function RTDCore:begin_round()
    RTDCore:clear_logs()
    round_active = true
end

function RTDCore:end_round()
    round_active = false
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

function RTDCore:runRTD(player)
    event = RTDCore:random_event()
    RTDCore:store_log(player,event)
    return event
end