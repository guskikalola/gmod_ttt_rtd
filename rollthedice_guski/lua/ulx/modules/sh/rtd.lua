include("autorun/shared/sh_rtdcore.lua")

function ulx.rtd(calling_ply)
	local result = RTDCore:can_use_rtd(calling_ply) 
	local can_use = result["can_use"]
	local message = result["message"]
	if not can_use then
		ULib.tsayError( calling_ply, "[RTD] " .. message, true )
	else
		RTDCore:runRTD(calling_ply)
	end
	
end

local rtd = ulx.command("Roll The Dice", "ulx rtd", ulx.rtd, "!rtd")

rtd:defaultAccess(ULib.ACCESS_ALL)

rtd:help("Roll The Dice. Consigue algo aleatorio.")


function ulx.rtd_force(calling_ply, target_plys)

	local affected_plys = {}

	for i=1, #target_plys do
		local v = target_plys[i]
		local result = RTDCore:can_use_rtd(v) 
		local can_use = result["can_use"]
		if v == calling_ply then
			can_use = false
		end
		if can_use then
			table.insert( affected_plys, v )
			ulx.rtd(v)
		end
	end

	ulx.fancyLogAdmin( calling_ply, "#A ha forzado a usar RTD a #T", affected_plys)
end

local frtd = ulx.command("Roll The Dice", "ulx frtd", ulx.rtd_force, "!frtd")

frtd:defaultAccess(ULib.ACCESS_ADMIN)

frtd:help("Fuerza a hacer RTD a otro jugador.")

frtd:addParam{ type=ULib.cmds.PlayersArg }