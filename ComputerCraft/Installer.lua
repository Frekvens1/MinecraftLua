print("Creating directories...\n\n")
shell.run("mkdir ./songs/")
shell.run("mkdir ./advanced_songs/") -- Not fully supported yet

print("Downloading music player")
shell.run("wget https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/ComputerCraft/BasicMusicPlayer.lua startup")

print("Downloading songs\n\n")
shell.run("wget https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/ComputerCraft/AllStar.lua ./songs/AllStar")
shell.run("wget https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/ComputerCraft/FireFlies.lua ./songs/FireFlies")
shell.run("wget https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/ComputerCraft/He%20is%20a%20pirate.lua ./songs/HeIsAPirate")
shell.run("wget https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/ComputerCraft/Tetris.lua ./songs/Tetris")
shell.run("wget https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/ComputerCraft/TurkishMarch.lua ./songs/TurkishMarch")
shell.run("wget https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/ComputerCraft/SongOfStorms.lua ./songs/SongOfStorms")
--shell.run("wget link ./songs/name")

print("Downloading other songs...\n\n")
shell.run("wget https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/ComputerCraft/GangnamStyle.lua ./advanced_songs/GangnamStyle")
shell.run("wget https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/ComputerCraft/MortalKombat.lua ./advanced_songs/MortalKombat")
shell.run("wget https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/ComputerCraft/GetReadyForThis.lua ./advanced_songs/GetReadyForThis")
--shell.run("wget link ./advanced_songs/name")

print("\n\nInstall complete!\n\n")
print("Rebooting in 3 seconds...")
os.sleep(3)
os.reboot()
