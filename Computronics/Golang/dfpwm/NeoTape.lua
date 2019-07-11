tape = peripheral.find("tape_drive")
screen = peripheral.find("monitor")
term.redirect( screen )

screen.setTextScale(0.5)
screen.clear()
screen.setCursorPos(1,1)

isPaused = false

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

function drawNavigation(files, id)
	screen.clear()
	screen.setCursorPos(1,1)
	paintutils.drawFilledBox(0, 0, 36, 10, colors.lightGray)
	
	screen.setCursorPos(1,1)
	screen.write("Currently playing:")
	
	screen.setCursorPos(1,2)
	screen.write(files[id][2])
	
	paintutils.drawFilledBox(0, 7, 15, 10, colors.lightBlue) -- Back
	if (isPaused) then
		paintutils.drawFilledBox(16, 7, 21, 10, colors.green) -- Pause
		
		screen.setCursorPos(1,4)
		screen.write("PAUSED!")
	else	
		paintutils.drawFilledBox(16, 7, 21, 10, colors.red) -- Unpause
	end
	
	paintutils.drawFilledBox(22, 7, 36, 10, colors.orange)-- Forward
	
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
	
	drawNavigation(files, id)

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
				if (x<=15) then
					id = id - 2
					break
					
				elseif ((x>=15) and (x<=21)) then
					if (isPaused) then
						isPaused = false
						tape.play()
					else
						isPaused = true
						tape.stop()
					end
					
					drawNavigation(files, id)
					
				else
					if (id == #files) then
						id = 1
					end
					
					break
				end
				
			end
			
		end
	end
	
	id = id + 1
end
