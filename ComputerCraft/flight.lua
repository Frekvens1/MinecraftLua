local modules = peripheral.find("neuralInterface")
local meta = modules.getMetaOwner()

local pressed = false

function readTable(tb)
	for k, v in pairs(tb) do
		print(tostring(k)..": "..tostring(v))
	end
end

while true do
	local event = {os.pullEvent()}
	
	readTable(event)
	
	if event[1] == "key" and event[2] == 76 then
		if not pressed then
			meta = modules.getMetaOwner()
			modules.launch(meta.yaw, meta.pitch, 3)
			
			pressed = true
		end
	end
	
	if event[1] == "key_up" and event[2] == 76 then
		pressed = false
	end
end
