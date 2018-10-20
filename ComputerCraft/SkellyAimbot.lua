--    wget http://127.0.0.1/CC/SkellyAimbot.lua protec    --
local master = "Frekvens1"

interface = peripheral.find("neuralInterface")
local meta = interface.getMetaOwner()

if not meta.name == "Skeleton" then error("Entity must be a skeleton!") end
if not interface.hasModule("plethora:kinetic", 0) then error("Must have a kinetic agument", 0) end
if not interface.hasModule("plethora:sensor") then error("Must have a sensor", 0) end

--[[ -- Super fast sleep --
local function yield()
	os.queueEvent( "sleep" )
	coroutine.yield( "sleep" )
end
--]]

local mobs = {
	Zombie = "Zombie",
	Skeleton = "Skeleton",
	Creeper = "Creeper",
	Spider = "Spider",
	CaveSpider = "Cave Spider",
	Slime = "Slime"
}


local function filter(entity)
	if mobs[entity.name] then
		if mobs[entity.name] == entity.displayName then
			return true, entity.name
		else
			return false, "Friendly"
		end
	else
		return false, "Player"
	end
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

interface.disableAI()
buffer = Buffer()

while true do
			
	buffer.print()
	for k, entity in pairs(interface.sense()) do
		if filter(entity) and not (entity.id == meta.id) then
			buffer.add(entity.name)
							
			local yaw, pitch = Angle.predict(entity)
			interface.look(yaw, pitch)
			interface.fire(yaw, pitch, 0.5) --0.5 Doesn't destroy blocks, and weaker.
							
		end
	end	
	
end
