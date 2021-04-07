local PLUGIN = PLUGIN

PLUGIN.name = "Flashlights and Lanterns"
PLUGIN.author = "Seamus"
PLUGIN.desc = "Adds flashlights and lanterns for survivors to use."

if (SERVER) then
	function PLUGIN:PlayerSwitchFlashlight(client,bEnabled)
		if (bEnabled) then
			local character = client:getChar()
			local bHasFlashlight = character:getInv():getItemCount("flashlight") != 0
			
			return bHasFlashlight
		else
			return true
		end
	end
else
	function PLUGIN:Think()
		for k,v in ipairs(player.GetAll()) do
			if (!v:getChar() or !v:getNetVar("lanternOn")) then continue end
			local dlight = DynamicLight( v:EntIndex() )
			if ( dlight ) then
				dlight.pos = LocalPlayer():LocalToWorld(LocalPlayer():OBBCenter())
				dlight.r = 255
				dlight.g = 255
				dlight.b = 255
				dlight.brightness = 5
				dlight.Decay = 1000
				dlight.Size = 256
				dlight.DieTime = CurTime() + 0.1
			end
		end
	end
end