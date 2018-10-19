local modules = peripheral.find("neuralInterface")

meta = modules.getMetaOwner()

local pressed = false

while true do
	local event = {os.pullEvent()}
	
	if event[1] == "char" and event[2] == 5 then
		if not pressed then
			meta = modules.getMetaOwner()
			modules.launch(meta.yaw, meta.pitch, 3)
			
			pressed = true
		end
	end
	
	if event[1] == "key_up" and key == 76 then
		pressed = false
	end
end
