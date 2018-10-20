--    wget http://127.0.0.1/CC/SkellyAimbot.lua protec    --
local masters = {"Frekvens1"}
interface = peripheral.find("neuralInterface")

if not interface.hasModule("plethora:kinetic", 0) then error("Must have a kinetic agument", 0) end
if not interface.hasModule("plethora:sensor") then error("Must have a sensor", 0) end
if not interface.hasModule("plethora:laser") then error("Must have a laser", 0) end
if not interface.hasModule("plethora:introspection") then error("Must have a introspection", 0) end

--[[ -- Super fast sleep --
local function yield()
	os.queueEvent( "sleep" )
	coroutine.yield( "sleep" )
end
--]]

-- FUNCTIONS --

local mobs = { -- entity.name = {entity.displayName, isFriendly}
	Zombie = {"Zombie", false}, 
	Skeleton = {"Skeleton", false},
	Creeper = {"Creeper", false},
	Spider = {"Spider", false},
	CaveSpider = {"Cave Spider", false},
	Slime = {"Slime", false},
	Ghast = {"Ghast", false},
	Blaze = {"Blaze", false},
	Shulker = {"Shulker", false},
	Endermite = {"Endermite", false},
	Evoker = {"Evoker", false},
	MagmaCube = {"Magma Cube", false},
	Guardian = {"Guardian", false},
	Husk = {"Husk", false},
	Silverfish = {"Silverfish", false},
	Stray = {"Stray", false},
	Vex = {"Vex", false},
	Witch = {"Witch", false},
	
	Bat = {"Bat", true},
	Horse = {"Horse", true},
	Pig = {"Pig", true},
	Cow = {"Cow", true},
	Sheep = {"Sheep", true},
	Chicken = {"Chicken", true},
	Squid = {"Squid", true},
	Rabbit = {"Rabbit", true},
	Donkey = {"Donkey", true},
	Mushroom = {"Mushroom", true},
	Llama = {"Llama", true},
	Parrot = {"Parrot", true},
	PolarBear = {"Polar Bear", true},
	Mule = {"Mule", true},
	SkeletonHorse = {"Skeleton Horse", true},
	Ocelot = {"Ocelot", true},
	Villager = {"Villager", true},
	
	PigZombie = {"Zombie Pigman", true},
	Enderman = {"Enderman", true},
	VillagerGolem = {"Iron Golem", true},
}

local ignore = {
	Item = true,
	Arrow = true,
	ItemFrame = true,
}
ignore["pletgora:laser"] = true

local function filter(entity)
	
	if entity.id == meta.id then
		return false, "Self"
	end
	
	if ignore[entity.name] then
		return false, "Ignored"
	end
	
	if not mobs[entity.name] then
		return false, "Player"
	end
	
	if not (mobs[entity.name][1] == entity.displayName) then
		return false, "Named"
	end
	
	if (mobs[entity.name][2]) then
		return false, "Friendly"
	end 
	
	return true, "Hostile"

end


function Buffer()
	local self = {}
	self.bufferText = {}

	
	function self.add(text)
		table.insert(self.bufferText, text)
	end
	
	
	function self.print()
		term.clear()
		for k, v in pairs(self.bufferText) do
			term.setCursorPos(1, k)
			term.write(v)
		end
		self.bufferText = {}
	end
	
	return self
end

local Angle = {}
function Angle.towards(entity)
	
	local x = entity.x + entity.motionX
	local y = entity.y + entity.motionY
	local z = entity.z + entity.motionZ
	
	local yaw = math.deg(math.atan2(-x, z))
	local pitch = -math.deg(math.atan2(entity.y, math.sqrt(entity.x^2 + entity.z^2)))
	
	return yaw, pitch
end

-- VARIABLES --

meta = interface.getMetaOwner()
interface.disableAI()
buffer = Buffer()

-- SOFTWARE START --

while true do
			
	buffer.print()
	for k, entity in pairs(interface.sense()) do
		hostile, tag = filter(entity)
		if not (tag == "Ignored") then
			buffer.add(entity.name..": "..tag.."("..entity.displayName..")")
		end
	end
	
	for k, entity in pairs(interface.sense()) do
		hostile, tag = filter(entity)
		
		if hostile then
			local yaw, pitch = Angle.towards(entity)
			interface.look(yaw, pitch)
			interface.fire(yaw, pitch, 0.5) --0.5 Doesn't destroy blocks, and weaker.
			break
		end
	end	
	
end
