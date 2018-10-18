tape = peripheral.find("tape_drive")

local url = "https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/Computronics/Golang/dfpwm/Tubthumping.dfpwm"
local response = http.get(url, nil, true)
local file = response.readAll()
response.close()

tape.seek(-tape.getPosition()) -- Rewind
tape.write(file)
tape.seek(-tape.getPosition()) -- Rewind
