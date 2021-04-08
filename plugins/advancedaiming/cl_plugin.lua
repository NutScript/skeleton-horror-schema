local PLUGIN = PLUGIN

PLUGIN.lerpAngles = LocalPlayer():GetViewModel(0):GetAngles()

CreateConVar("nut_advaim", "0", true, false)

function PLUGIN:CalcView(client,pos,ang,fov)
	if (hook.Run("CanPlayerUseAdvAim") != false and GetConVar("nut_advaim"):GetBool()) then
		local weapon = client:GetViewModel(0)
		
		self.lerpAngles = LerpAngle(0.02,self.lerpAngles,weapon:GetAngles())

		local view = {
			origin = client:GetShootPos(),
			angles = self.lerpAngles,
			fov = 80,
			drawviewer = false
		}

		return view
	end
end

function PLUGIN:SetupQuickMenu(menu)
	local toggleAdvancedAiming = menu:addCheck("Toggle Advanced Aiming", function(panel, state)
		if (state) then
			RunConsoleCommand("nut_advaim", "1")
		else
			RunConsoleCommand("nut_advaim", "0")
		end
	end, GetConVar("nut_advaim"):GetBool())
end