include("autorun/shared/sh_rtdcore.lua")

function ulx.rtd(calling_ply)
	local result = RTDCore:can_use_rtd(calling_ply) 
	local can_use = result["can_use"]
	local message = result["message"]
	if not can_use then
		ULib.tsayError( calling_ply, message, true )
	else
		local event = RTDCore:runRTD(calling_ply)
		ULib.tsay(calling_ply, "[RTD] " .. event["description"], true)
		event:run(calling_ply)
	end
	
end

local rtd = ulx.command("Roll The Dice", "ulx rtd", ulx.rtd, "!rtd")

rtd:defaultAccess(ULib.ACCESS_ALL)

rtd:help("Roll The Dice. Consigue algo aleatorio.")
