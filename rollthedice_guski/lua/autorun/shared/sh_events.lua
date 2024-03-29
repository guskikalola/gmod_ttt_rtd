include("autorun/shared/sh_rtdevent.lua")

local DEBUG = 1000000
local COMMON = 40
local UNCOMMON = 30
local RARE = 20
local ULTRARARE = 10
local UNIQUE = 5

-- List of possible events
events = {}

events["ignite"] = RTDEvent:create("En llamas", "Estas en llamas por 7 segundos!", ALL_EVENT, UNCOMMON, function(self, player, round_identifier)
    player:Ignite(7,0)
end)

local invisibility = RTDEvent:create("Invisibilidad", "Eres invisible por 15 segundos", ALL_EVENT, RARE, function(self, player, round_identifier)
    ULib.invisible(player, true)
    timer.Simple( 15, function()
        if RTDCore:sameRound(round_identifier) then
            ULib.invisible(player, false)
            RTDCore:notifyEnd(player, self.name)
        end
    end)
end)

invisibility:setDisableFunction(function(self, player)
    ULib.invisible(player, false)
end)

events["invisibility"] = invisibility

local ragdoll = RTDEvent:create("Ragdoll", "Ragdoll por 20s", ALL_EVENT, RARE, function(self, player, round_identifier)
    ulx.ragdoll(player, {player}, false)
    timer.Simple( 20, function()
        if RTDCore:sameRound(round_identifier) then
            ulx.ragdoll(player, {player}, true)
        end
    end)
end)

ragdoll:setDisableFunction(function(self, player)
    ulx.ragdoll(player, {player}, true)
end)

events["ragdoll"] = ragdoll

events["slap"] = RTDEvent:create("Slap", "Slap!", ALL_EVENT, UNCOMMON, function(self, player, round_identifier)
    ULib.slap(player, 10)
end)

events["1hp"] = RTDEvent:create("1HP", "Te quedas a 1 HP", ALL_EVENT, RARE, function(self, player, round_identifier)
    player:SetHealth(1)
end)

events["low_gravity"] = RTDEvent:create("Gravedad Baja", "Tienes menor gravedad por 25s", ALL_EVENT, RARE, function(self, player, round_identifier)
    local original_grav = player:GetGravity()
    player:SetGravity(0.3)
    timer.Simple( 25, function()
        player:SetGravity(original_grav)
        RTDCore:notifyEnd(player, self.name)
    end)
end)

events["high_gravity"] = RTDEvent:create("Gravedad Alta", "Tienes mayor gravedad por 25s", ALL_EVENT, RARE, function(self, player, round_identifier)
    local original_grav = player:GetGravity()
    player:SetGravity(1.4)
    timer.Simple( 25, function()
        player:SetGravity(original_grav)
        RTDCore:notifyEnd(player, self.name)
    end)
end)

events["smaller"] = RTDEvent:create("Diminuto", "Eres mas pequeño y velocidad por 20s", ALL_EVENT, ULTRARARE, function(self, player, round_identifier)
    local original_speed = player:GetWalkSpeed()
    local original_size = player:GetModelScale()
    player:SetWalkSpeed(original_speed * 1.3)
    player:SetModelScale(0.25, 1)
    timer.Simple( 20, function()
        player:SetWalkSpeed(original_speed)
        player:SetModelScale(original_size, 1)
        RTDCore:notifyEnd(player, self.name)
    end)
end)

events["bigger"] = RTDEvent:create("Gigante", "Eres mas grande y lento por 20s", ALL_EVENT, ULTRARARE, function(self, player, round_identifier)
    local original_speed = player:GetWalkSpeed()
    local original_size = player:GetModelScale()
    player:SetWalkSpeed(original_speed * 0.6)
    player:SetModelScale(1.5, 1)
    timer.Simple( 20, function()
        player:SetWalkSpeed(original_speed)
        player:SetModelScale(original_size, 1)
        RTDCore:notifyEnd(player, self.name)
    end)
end)

events["fraggrenade"] = RTDEvent:create("Granada", "Piensa rapido!", ALL_EVENT, ULTRARARE, function(self, player, round_identifier)
    frag = ents.Create( "npc_grenade_frag" )
    frag:SetPos(player:GetPos())
    frag:Fire( "SetTimer", 1.2)
    frag:Spawn()
    frag = ents.Create( "npc_grenade_frag" )
    frag:SetPos(player:GetPos() + Vector(1, 0, 0))
    frag:Fire( "SetTimer", 1.5)
    frag:Spawn()
    frag = ents.Create( "npc_grenade_frag" )
    frag:SetPos(player:GetPos()+ Vector(-1, 0, 0))
    frag:Fire( "SetTimer", 1.8)
    frag:Spawn()
    frag = ents.Create( "npc_grenade_frag" )
    frag:SetPos(player:GetPos() + Vector(0, 1, 0))
    frag:Fire( "SetTimer", 2)
    frag:Spawn()
end)

events["fly"] = RTDEvent:create("A volar", "Intenta no caer de culo", ALL_EVENT, RARE, function(self, player, round_identifier)
    ULib.applyAccel(player, 3000, Vector(0,0,1), 1)
end)

events["strip"] = RTDEvent:create("Limpieza", "Te has quedado sin nada", ALL_EVENT, ULTRARARE, function(self, player, round_identifier)
    ulx.stripweapons(player, {player})
end)

events["blind"] = RTDEvent:create("Ceguera", "Donde esta la luz, te has quedado ciego 10s", ALL_EVENT, RARE, function(self, player, round_identifier)
    ulx.blind(player,{player},255)
    timer.Simple( 10, function()
        ulx.blind(player,{player},0)
        RTDCore:notifyEnd(player, self.name)
    end)
end)

events["whip"] = RTDEvent:create("Whip", "A volar!", ALL_EVENT, UNCOMMON, function(self, player, round_identifier)
    ulx.whip(player,{player}, 10, 1)
end)

events["gimp"] = RTDEvent:create("Gimp", "Intenta hablar. Gimp por 15s", ALL_EVENT, RARE, function(self, player, round_identifier)
    ulx.gimp(player,{player})
    timer.Simple( 15, function()
        ulx.gimp(player,{player}, true)
        RTDCore:notifyEnd(player, self.name)
    end)
end)

events["death"] = RTDEvent:create("Muerte", "Vas a morir en los proximos 20s", ALL_EVENT, ULTRARARE, function(self, player, round_identifier)
    timer.Simple( 20, function()
        if RTDCore:sameRound(round_identifier) then
            ulx.maul(player,{player})
        end
    end)
end)

events["position_swap"] = RTDEvent:create("Cambio de Posición", "Has cambiado de posición con otro jugador", ALL_EVENT, UNCOMMON, function(self, player, round_identifier)
    local players = ULib.getAllReadyPlayers()
    local target = players[1]
    for i, ply in RandomPairs(players) do
        if ply ~= player then
            target = ply
            break
        end
    end

    local targetPos = target:GetPos()
    local playerPos = player:GetPos()

    target:SetPos(playerPos)
    player:SetPos(targetPos)
end)

events["credits_add"] = RTDEvent:create("Mas creditos", "Recives creditos extra", TRAITORDETECTIVE_EVENT, RARE, function(self, player, round_identifier)
    player:AddCredits(2)
end)

events["credits_sub"] = RTDEvent:create("Sin creditos", "Se te han restado todos los creditos", TRAITORDETECTIVE_EVENT, RARE, function(self, player, round_identifier)
    player:SetCredits(0)
end)

-- events["spawn_weapon"] -- Arma de T o de D ?
-- events["announce_role"]

