include("autorun/shared/sh_rtdcore.lua")

local function onRoundBegin() 
    RTDCore:begin_round()
end

hook.Add("TTTBeginRound", "guskikalola_rtd_beginround", onRoundBegin)