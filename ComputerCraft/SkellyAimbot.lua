--    wget http://127.0.0.1/CC/SkellyAimbot.lua protec    --
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
	Spider = true,
	Slime = true
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
function Angle.towards(entity)
	
	local x = entity.x + entity.motionX
	local y = entity.y + entity.motionY
	local z = entity.z + entity.motionZ
	
	local yaw = math.deg(math.atan2(-x, z))
	local pitch = -math.deg(math.atan2(entity.y, math.sqrt(entity.x^2 + entity.z^2)))
	
	return yaw, pitch
end

function Angle.predict(entity)
	
	local x = entity.x + (entity.motionX^2)*2
	local y = entity.y + (entity.motionY^2)*2
	local z = entity.z + (entity.motionZ^2)*2
	
	local yaw = math.deg(math.atan2(-x, z))
	local pitch = -math.deg(math.atan2(entity.y, math.sqrt(entity.x^2 + entity.z^2)))
	
	return yaw, pitch
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
							
							local yaw, pitch = Angle.predict(entity)
							interface.look(yaw, pitch)
							interface.fire(yaw, pitch, 5)
						end
					end
				end
				
			end
		end
)
