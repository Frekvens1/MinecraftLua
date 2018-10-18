tape = peripheral.find("tape_drive")

local url = ""
--url = "https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/Tubthumping.dfpwm"
--url = "https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/Electronic%20Super%20Joy%20OST%20-%2002%20Flare.dfpwm"
--url = "https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/Teminite%20%26%20Panda%20Eyes%20-%20Highscore.dfpwm"
url = "https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/Kaivon%20-%20Reborn.dfpwm"

local response = http.get(url, nil, true)
local file = response.readAll()
response.close()

tape.seek(-tape.getPosition()) -- Rewind
tape.write(file)
tape.seek(-tape.getPosition()) -- Rewind
