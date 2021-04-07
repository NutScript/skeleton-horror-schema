-- The name used to display the faction
FACTION.name = "Monsters"
-- Set a basic description for the faction,
-- this will show on the character creation menu.
FACTION.desc = "Default antagonist faction, spawns with 200 health."

FACTION.models = { --Some monster models.
	"models/player/zombie_classic.mdl",
	"models/player/zombie_fast.mdl",
	"models/player/skeleton.mdl",
	"models/player/corpse1.mdl",
}

-- Set the faction color, this color is used in various areas,
-- such as the scoreboard and chat.
FACTION.color = Color(200, 0, 0)
-- Whether or not the faction is whitelisted.
FACTION.isDefault = false
-- Set a unique identifier for this faction,
-- this is used when deriving the faction from the player.
FACTION_MONSTERS = FACTION.index

function FACTION:onSpawn(client)
	client:SetHealth(200)
	client:SetWalkSpeed(300)
	client:SetRunSpeed(300)
end