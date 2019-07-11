tape = peripheral.find("tape_drive")

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


local files = {
	--get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/"),
	{
		get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/FallenKingdom.dfpwm"),
		"Fallen Kingdom",
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

for i=1, #files, 1 do

	term.clear()
	term.setCursorPos(1,1)
	
	print("Currently playing:")
	print(files[i][2])
	
	tape.stop()
	tape.seek(-tape.getPosition()) -- Rewind
		
	tape.write(files[i][1])
		
	tape.seek(-tape.getPosition()) -- Rewind
	tape.play()
		
	while not ((tape.getPosition() >= #files[i][1]) or tape.isEnd()) do
		os.sleep(1)
	end
end
