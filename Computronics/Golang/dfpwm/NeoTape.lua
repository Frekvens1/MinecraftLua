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
	get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/RISE.dfpwm"),
	get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/OliverTree_Alie%20Boy.dfpwm"),
}

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
