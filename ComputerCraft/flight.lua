local modules = peripheral.find("neuralInterface")
local meta = modules.getMetaOwner()

local pressed = false
key = 76
force = 3 -- 1-5

function readTable(tb)
	for k, v in pairs(tb) do
		print(tostring(k)..": "..tostring(v))
	end
end

hover = false

function doHover()

	while hover do
		-- We calculate the required motion we need to take
		local mY = meta.motionY
		mY = (mY - 0.138) / 0.8

		-- If it is sufficiently large then we fire ourselves in that direction.
		if mY > 0.5 or mY < 0 then
			local sign = 1
			if mY < 0 then sign = -1 end
				modules.launch(0, 90 * sign, math.min(4, math.abs(mY)))
		else
			sleep(0)
		end
	end
	
end


while true do
	local event = {os.pullEvent()}
	
	--readTable(event)
	
	if event[1] == "key" and event[2] == key then
		if not pressed then
			meta = modules.getMetaOwner()
			modules.launch(meta.yaw, meta.pitch, 3)
			
			pressed = true
		end
	elseif event[1] == "key" and event[2] == 35 then
		hover = true
	end
	
	if event[1] == "key_up" and event[2] == key then
		pressed = false
	end
	
	doHover()
end
