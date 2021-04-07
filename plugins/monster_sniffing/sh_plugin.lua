local PLUGIN = PLUGIN

PLUGIN.name = "Sniffing"
PLUGIN.author = "Seamus"
PLUGIN.desc = "A plugin that allows monsters to sniff out survivors nearby."

nut.config.add("sniffRadiusMin",10000,"The minimum random radius of a sniff.",nil,{category = "horror", data = {min = 0, max = 20000}}) --Two configs that admins can set.
nut.config.add("sniffRadiusMax",20000,"The maximum random radius of a sniff.",nil,{category = "horror", data = {min = 5000, max = 40000}})
nut.config.add("sniffDelay",30,"The number in seconds a player has to wait before they can sniff out survivors again.",nil,{category = "horror", data = {min = 3, max = 60}})
nut.config.add("sniffTime",5,"The number in seconds that a sniff lasts for.",nil,{category = "horror", data = {min = 1, max = 10}})

nut.util.include("sv_plugin.lua")
nut.util.include("cl_plugin.lua")

nut.command.add("sniff",{
	onRun = function(client) --Only one argument since this is a command with no input data.
		if (client:Team() != FACTION_MONSTERS) then --Check if the player is a monster.
			client:notify("All you smell is the stench of chemicals.")
			return
		end
	
		if (client.lastSniff and CurTime() < client.lastSniff + nut.config.get("sniffDelay",30)) then
			client:notify("Your nose feels blocked, you can't seem to smell anything.")
			return --Stop the rest of the logic running if the player has sniffed recently.
		end
		
		client:doSniff()
		client.lastSniff = CurTime()
	end,
})