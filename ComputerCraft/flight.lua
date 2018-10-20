local modules = peripheral.find("neuralInterface")
local meta = modules.getMetaOwner()

local key_fly = 76
local force_fly = 3 -- 1-4
local key_launch = 57
local force_launch = 1.5 -- 1-4


function readTable(tb)
	for k, v in pairs(tb) do
		print(tostring(k)..": "..tostring(v))
	end
end


while true do
	local event = {os.pullEvent()}
	
	--readTable(event)
	
	if event[1] == "key" and event[2] == key_fly then
		if not pressed then
			meta = modules.getMetaOwner()
			modules.launch(meta.yaw, meta.pitch, force_fly)
		end
		
	elseif event[1] == "key" and event[2] == key_launch then
		modules.launch(meta.yaw, meta.pitch, force_launch)
	end
end
