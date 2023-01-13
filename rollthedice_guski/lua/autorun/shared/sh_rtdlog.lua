RTDLog = {}
RTDLog.__index = RTDLog

function RTDLog:create(player, rtd_result)
   local log = {}             
   setmetatable(log,RTDLog) 
   log.player = player
   log.rtd_result = rtd_result
   return acnt
end

function RTDLog:is_player(player)
   return player.GetBySteamID64() == self.player.GetBySteamID64()
end