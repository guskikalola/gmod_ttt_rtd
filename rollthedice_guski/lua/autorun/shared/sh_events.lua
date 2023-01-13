include("autorun/shared/sh_rtdevent.lua")

local COMMON = 40
local UNCOMMON = 35
local RARE = 30
local ULTRARARE = 10

-- List of possible events
events = {}

events["ignite"] = RTDEvent:create("ignite", "Estas en llamas por 3 segundos!", UNCOMMON, function(player)
    player:Ignite(3,0)
end)

events["invisibility"] = RTDEvent:create("invisibility", "Eres invisible por 15 segundos", RARE, function(player)
    ULib.invisible(player, true)
    timer.Simple( 15, function()
        ULib.invisible(player, false)
    end)
end)

events["ragdoll"] = RTDEvent:create("ragdoll", "Ragdoll por 20s", RARE, function(player)
    ulx.ragdoll(player, {player}, false)
    timer.Simple( 20, function()
        ulx.ragdoll(player, {player}, true)
    end)
end)


events["slap"] = RTDEvent:create("slap", "Slap!", UNCOMMON, function(player)
    ULib.slap(player, 10)
end)