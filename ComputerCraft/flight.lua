local modules = peripheral.find("neuralInterface")

meta = modules.getMetaOwner()

while true do
	local event = {os.pullEvent()}
	
	if event[1] == "key" and key == 76 then
		meta = modules.getMetaOwner()
		
		modules.launch(meta.yaw, meta.pitch, 3)
	end
end
