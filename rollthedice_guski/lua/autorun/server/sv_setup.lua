include("autorun/shared/sh_rtdcore.lua")

local function onRoundBegin() 
    RTDCore:begin_round()
end

local function onRoundEnd(result)
    RTDCore:end_round()
end

hook.Add("TTTBeginRound", "guskikalola_rtd_beginround", onRoundBegin)
hook.Add("TTTEndRound", "guskikalola_rtd_endround", onRoundEnd)