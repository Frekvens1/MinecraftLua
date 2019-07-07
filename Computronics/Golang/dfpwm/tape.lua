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
	--get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/Tubthumping.dfpwm"),
	get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/Electronic%20Super%20Joy%20OST%20-%2002%20Flare.dfpwm"),
	get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/Teminite%20%26%20Panda%20Eyes%20-%20Highscore.dfpwm"),
	get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/Kaivon%20-%20Reborn.dfpwm"),
	get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/Tubthumping.dfpwm"),
	--get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/Trololo.dfpwm"),
	get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/miss_kobayashis_dragon_maid_opening.dfpwm"),
	--get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/"),
}


while true do
	
	
	for i=1, #files, 1 do
		tape.stop()
		tape.seek(-tape.getPosition()) -- Rewind
		
		tape.write(files[i])
		
		tape.seek(-tape.getPosition()) -- Rewind
		tape.play()
		
		while not ((tape.getPosition() >= #files[i]) or tape.isEnd()) do
			os.sleep(1)
		end
		
	
	end
	
end
