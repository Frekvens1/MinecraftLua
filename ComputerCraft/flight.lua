local modules = peripheral.find("neuralInterface")
local meta = modules.getMetaOwner()

local key_fly = 76
local force_fly = 2 -- 1-4
local key_launch = 57
local force_launch = 1.5 -- 1-4

local key_multiplier = 29
local multiplier_mode = true
local multiplier = 2
local multiplier_now = 1

function readTable(tb)
	for k, v in pairs(tb) do
		print(tostring(k)..": "..tostring(v))
	end
end

function handleMultiplier()
	local isOn = false
	
	if multiplier_now ==  multiplier then
		multiplier_now = 1
	else
		multiplier_now = multiplier
		isOn = true
	end
	
	if modules.hasModule("plethora:glasses") then
		canvas = modules.canvas()
		
		canvas.clear()
		local text = canvas.addText({x=1, y=1}, "Multiplier mode: "..tostring(isOn))
		text.setScale(3)
	end
end

handleMultiplier(false)

while true do
	local event = {os.pullEvent()}
	
	--readTable(event)
	
	if event[1] == "key" and event[2] == key_fly then
		if not pressed then
			meta = modules.getMetaOwner()
			modules.launch(meta.yaw, meta.pitch, force_fly)
		end
		
	elseif event[1] == "key" and event[2] == key_launch then
		modules.launch(0, -90, force_launch*multiplier_now)
		
	elseif event[1] == "key" and event[2] == key_multiplier and not multiplier_mode then
		handleMultiplier()
	end
	
	if event[1] == "key_up" and event[2] == key_multiplier then
		multiplier_mode = false
	end
end
