print("Creating directories...")
shell.run("mkdir ./songs/")

print("Downloading music player")
shell.run("wget https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/ComputerCraft/BasicMusicPlayer.lua startup")

print("Downloading songs")
shell.run("wget https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/ComputerCraft/AllStar.lua ./songs/AllStar")
shell.run("wget https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/ComputerCraft/FireFlies.lua ./songs/FireFlies")
shell.run("wget https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/ComputerCraft/GangnamStyle.lua ./songs/GangnamStyle")
shell.run("wget https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/ComputerCraft/He%20is%20a%20pirate.lua ./songs/HeIsAPirate")
shell.run("wget https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/ComputerCraft/Tetris.lua ./songs/Tetris")
shell.run("wget https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/ComputerCraft/TurkishMarch.lua ./songs/TurkishMarch")
--shell.run("wget link ./songs/name")

print("Install complete!\n\n")
print("Rebooting in 3 seconds...")
os.sleep(3)
os.reboot()
