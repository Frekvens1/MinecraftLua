local master = "Frekvens1"
interface = peripheral.find("neuralInterface")

if not interface.hasModule("plethora:kinetic", 0) then error("Must have a kinetic agument", 0) end
if not interface.hasModule("plethora:sensor") then error("Must have a sensor", 0) end
	
local function yield()
	os.queueEvent( "sleep" )
	coroutine.yield( "sleep" )
end

local meta = interface.getMetaOwner()

if not meta.name == "Skeleton" then error("Entity must be a skeleton!") end
interface.disableAI()

local mobs = {
	Zombie = true,
	Skeleton = true,
	Creeper = true,
	Spider = true
}

local function filter(name)
	if mobs[name] then
		return true, name
	else
		return false, "Player"
	end
end

function clear()
	term.clear()
	term.setCursorPos(1,1)
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

local Angle = { }

function Angle.towards(x, y, z)
  return math.deg(math.atan2(-x, z)), 0
end

function Angle.away(x, y, z)
  return math.deg(math.atan2(x, -z)), 0
end

buffer = Buffer()

parallel.waitForAny(

		function()
			while true do
				meta = interface.getMetaOwner()
				yield()
			end
		end,
		
		
		function()
			while true do
			
				event = {os.pullEvent()}
				if event[1] == "chat_message" then
					username = event[2]
					message = event[3]
					if (username == master) and (message == "fire") then
						interface.shoot(1)
					end
				end
				
			end
		end,
		
		function()
			while true do
			
				buffer.print()
				for k, entity in pairs(interface.sense()) do
					if not (entity.id == meta.id) then
						if filter(entity.name) and (entity.name == entity.displayName) then
							buffer.add(entity.name)
							
							local yaw, pitch = Angle.towards(entity.x - .5, entity.y + 1, entity.z - .5)
							local pitch = -math.deg(math.atan2(entity.y, math.sqrt(entity.x * entity.x + entity.z * entity.z)))
							
							interface.look(yaw, pitch)
							--interface.shoot(1)
							interface.fire(yaw, pitch, 5)
							
							--shootAt2(entity, 1)
							--os.sleep(0.1)
						end
					end
				end
				
				--os.sleep(0.5)
				
			end
		end
)
