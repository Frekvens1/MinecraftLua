tape = peripheral.find("tape_drive")
screen = peripheral.find("monitor")
term.redirect( screen )

screen.setTextScale(0.5)
screen.clear()
screen.setCursorPos(1,1)

function get(url)
	local result = nil
	
	if not http.checkURL(url) then
		return nil
	end
	
	local response = http.get(url, nil, true)
	if not response then
		return nil
	end
	
	result = response.readAll()
	response.close()
	
	return result
end

function drawNavigation()
	screen.clear()
	screen.setCursorPos(1,1)
	paintutils.drawFilledBox(0, 0, 36, 10, colors.lightGray)
	paintutils.drawFilledBox(0, 7, 18, 10, colors.lightBlue)
	paintutils.drawFilledBox(19, 7, 36, 10, colors.orange)
	
	screen.setBackgroundColor(colors.lightGray)
	screen.setTextColor(colors.black)
	
	screen.setCursorPos(1,1)
end


local files = {
	--get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/"),
	{
		get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/TakeBackTheNight.dfpwm"),
		"Take Back the Night",
	},
	{
		get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/FallenKingdom.dfpwm"),
		"Fallen Kingdom",
	},
	{
		get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/RunningToNever.dfpwm"),
		"Running to Never",
	},
	{
		get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/RISE.dfpwm"),
		"Rise - League of Legends",
	},
	{
		get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/OliverTree_Alie%20Boy.dfpwm"),
		"Oliver Tree - All I Got",
	},
}

id = 1
running = true

while running do

	if (id > #files) then
		running = false
		break
	end
	
	if (id <= 0) then
		id = #files
	end
	
	drawNavigation()
	screen.write("Currently playing:")
	
	screen.setCursorPos(1,2)
	screen.write(files[id][2])
	
	
	
	tape.stop()
	tape.seek(-tape.getPosition()) -- Rewind
		
	tape.write(files[id][1])
		
	tape.seek(-tape.getPosition()) -- Rewind
	tape.play()
		
	while not ((tape.getPosition() >= #files[id][1]) or tape.isEnd()) do
		os.startTimer(1)
		local event, button, x, y = os.pullEvent()
		if (event == "monitor_touch") then
			
			if (y>6) then
				if (x<=19) then
					id = id - 2
				else
					if (id == #files) then
						id = 1
					end
				end
				break
			end
			
		end
	end
	
	id = id + 1
end
