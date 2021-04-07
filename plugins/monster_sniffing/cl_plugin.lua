local PLUGIN = PLUGIN
local solidMat = Material("models/debug/debugwhite")

function PLUGIN:HUDPaint()
	if (!PLUGIN.nearbyPlayers or LocalPlayer():Team() != FACTION_MONSTERS) then
		return
	end
	
	cam.Start3D( EyePos(), EyeAngles() )
		for _,v in ipairs( self.nearbyPlayers ) do
			if (!IsValid(v) or !v:getChar()) then continue end --A quick check to make sure our players are valid.
			local playerHealth = v:Health()
			
			render.SuppressEngineLighting( false )
			render.SetColorModulation( 255 - (playerHealth*2.55), playerHealth*2.55, 0 )
			render.SetMaterial( solidMat )
			v:DrawModel()
		end
	cam.End3D()
end

function PLUGIN:RenderScreenspaceEffects()
	DrawBloom( 0.8, 2, 9, 9, 1, 1, 1, 1, 1 )
	DrawSharpen( 1.2, 0.6 )

	if (LocalPlayer():Team() == FACTION_MONSTERS) then
		DrawColorModify( {
			[ "$pp_colour_addr" ] = 0,
			[ "$pp_colour_addg" ] = 0,
			[ "$pp_colour_addb" ] = 0,
			[ "$pp_colour_brightness" ] = PLUGIN.nearbyPlayers and -0.7 or -0.3,
			[ "$pp_colour_contrast" ] = 1,
			[ "$pp_colour_colour" ] = 1,
			[ "$pp_colour_mulr" ] = 5,
			[ "$pp_colour_mulg" ] = 0,
			[ "$pp_colour_mulb" ] = 0
		} )

		if (PLUGIN.nearbyPlayers) then
			util.ScreenShake(LocalPlayer():GetPos(),2,2,0.1,0)
		end
	else
		DrawColorModify( {
			[ "$pp_colour_addr" ] = 0,
			[ "$pp_colour_addg" ] = 0,
			[ "$pp_colour_addb" ] = 0,
			[ "$pp_colour_brightness" ] = -0.2,
			[ "$pp_colour_contrast" ] = 1,
			[ "$pp_colour_colour" ] = 0.5,
			[ "$pp_colour_mulr" ] = 0,
			[ "$pp_colour_mulg" ] = 0,
			[ "$pp_colour_mulb" ] = 0
		} )
	end
end

netstream.Hook("UpdateSniffingTargets",function(nearbyPlayers)
	PLUGIN.nearbyPlayers = nearbyPlayers
end)