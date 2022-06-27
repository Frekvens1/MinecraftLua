local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")


local files = {
	--"https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/Tubthumping.dfpwm",
	"https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/Electronic%20Super%20Joy%20OST%20-%2002%20Flare.dfpwm",
	"https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/Teminite%20%26%20Panda%20Eyes%20-%20Highscore.dfpwm",
	"https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/Kaivon%20-%20Reborn.dfpwm",
	--"https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/Trololo.dfpwm",
	"https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/miss_kobayashis_dragon_maid_opening.dfpwm",
	"https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/Pirates%20Of%20The%20Caribbean%20Theme%20Song.dfpwm",
	--"https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/",
}


function main()
	while true do
		
		for i=1, #files, 1 do
			playURL( files[i] )
		end
		
	end
end


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


function playFile(file_path)
	local decoder = dfpwm.make_decoder()
	for chunk in io.lines(file_path, 16 * 1024) do
		local buffer = decoder(chunk)

		while not speaker.playAudio(buffer) do
			os.pullEvent("speaker_audio_empty")
		end
	end
end


function playURL(url)
	local file = get(url)
	local chunk_size = 16 * 1024
	
	local chunks = {}
    for index = 1, #file, chunk_size do
        chunks[#chunks + 1] = file:sub(index, index + chunk_size - 1)
    end

	local decoder = dfpwm.make_decoder()
	for index, chunk in pairs(chunks) do
		local buffer = decoder(chunk)

		while not speaker.playAudio(buffer) do
			os.pullEvent("speaker_audio_empty")
		end
	end
end


main()
