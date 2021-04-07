local PLUGIN = PLUGIN
local PLAYER = FindMetaTable("Player") --To keep in line with how meta variables are defined, we use PLAYER in all caps.

function PLAYER:doSniff()
	--Get all our necessary information and variables.
	local radMin,radMax = nut.config.get("sniffRadiusMin",10000),nut.config.get("sniffRadiusMax",20000)
	local radius = math.random(radMin,radMax)
	
	--Now we're going to search through the list of players and see who's within the radius.
	local playersInArea = {}
	
	for _,v in ipairs(player.GetAll()) do
		if self != v and v:getChar() and v:Team() != FACTION_MONSTERS and v:GetPos():DistToSqr(self:GetPos()) < (radius*radius) then --We use brackets around everything because it looks clean.
		--We do v:getChar() to make sure our player is valid and in the world, and we do radius*radius to make sure they're within distance (due to using DistToSqr).
			table.insert(playersInArea,v) --Insert our player into the table of within radius players.
		end
	end
	
	self:EmitSound("physics/flesh/flesh_scrape_rough_loop.wav") --A sound that sounds like sniffing, an audible giveaway for nearby survivors.
	self:SetDSP(10)
	self:SetWalkSpeed(600)
	
	local numberString
	
	if (#playersInArea == 1) then
		numberString = "a scent."
	elseif (#playersInArea == 2) then
		numberString = "a couple scents."
	elseif (#playersInArea > 2) then
		numberString = "a few scents."
	else
		numberString = "nothing."
	end
	
	self:notify("You begin to sniff the air loudly, and you pick up "..numberString)
	
	netstream.Start(self,"UpdateSniffingTargets",playersInArea) --Network the players in the area to the monster.
	
	timer.Simple(nut.config.get("sniffTime",5),function()
		netstream.Start(self,"UpdateSniffingTargets",nil) --Overwrite the targets after a select period of time.
		self:StopSound("physics/flesh/flesh_scrape_rough_loop.wav")
		self:SetDSP(0)
		self:SetWalkSpeed(300)
	end)
end