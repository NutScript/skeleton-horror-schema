ITEM.name = "Lantern"
ITEM.desc = "A larger light, able to illuminate entire rooms.\n\nIt is at battery level: %s"
ITEM.model = "models/Items/battery.mdl"
ITEM.width = 1
ITEM.height = 1

function ITEM:getDesc()
	return string.format(self.desc,self:getData("battery",0)/100)
end

ITEM.functions.EquipUn = {
	name = "Turn Off",
	onRun = function(item)
		item.player:EmitSound("buttons/lightswitch2.wav")
		item.player:setNetVar("lanternOn",nil)
		item:setData("equip",nil)
		return false
	end,
	onCanRun = function(item)
		return !IsValid(item.entity) and item:getData("equip")
	end,
}

ITEM.functions.Equip = {
	name = "Turn On",
	onRun = function(item)
		local character = item.player:getChar()
		local inventory = character:getInv()
		local bHasLantern
		
		for k,v in pairs(inventory:getItems()) do
			if (v:getData("equip")) then
				bHasLantern = true
				break
			end
		end
		
		if (bHasLantern) then
			item.player:notify("You already have a lantern on.")
			return
		end
	
		item.player:EmitSound("buttons/lightswitch2.wav")
		item.player:setNetVar("lanternOn",true)
		item:setData("equip",true)
		return false
	end,
	onCanRun = function(item)
		return !IsValid(item.entity) and !item:getData("equip")
	end,
}

ITEM.functions.Battery = {
	name = "Insert Battery",
	onRun = function(item)
		local character = item.player
		local inventory = character:getInv()
		
		local foundBattery
		
		for k,v in pairs(inventory:getItems()) do
			if (v.uniqueID == "battery") then
				foundBattery = v
				break
			end
		end
		
		item:setData("battery",math.Clamp(item:getData("battery",0) + 2000,0,10000))
		foundBattery:remove()
	end,
}

ITEM:hook("drop",function(item)
	if (item:getData("equip")) then
		item:setData("equip",nil)
		item.player:setNetVar("lanternOn",nil)
	end
end)