volume = 0.5
paused = false
requests = 0
requestedTick = -1
menuid = 0

soundFile = {}
maxTicks = 0
currentSong = ""
speakers = {}

function play(song)

	if (fs.exists(song)) then
		f = fs.open(song, "r")
		file = f.readAll()
		f.close()
		
		soundFile = textutils.unserialize(file)
		
		for _, name in pairs(peripheral.getNames()) do
			if (peripheral.getType(name) == "speaker") then
				table.insert(speakers, peripheral.wrap(name))
			end
		end
		
		currentSong = soundFile.n
		drawGUI()
		
		maxTicks = soundFile.f[#soundFile.f].t
		t = 1
		firstReset = true
		
		while t <= #soundFile.f do
			tone = soundFile.f[t]
			
			if not (requestedTick == -1) then
				
				if firstReset then
					firstReset = false
					t = 0
				else
				
					if (tone.t >= requestedTick) then
						t = t - 1
						requestedTick = -1
						firstReset = true
						
						if (t <= 0) then
							t = 1
						end		
					end
				end
				
				
			else
				wait(tone.s*soundFile.s)
				
				while (paused) do
					if not (requests == 0) then
						break
					end
					
					if (requestedTick >= 0) then
						requests = -1
						break
					end
					
					if (menuid == 0) then
						term.setTextColor(colors.black)
						term.setBackgroundColor(colors.cyan)
			
						term.setCursorPos(1,12)
						term.write(formatTime((tone.t / 10)*soundFile.s))
						
						term.setCursorPos(22,12)
						term.write(formatTime((maxTicks/10)*soundFile.s))
					end
					
					wait(0.5)
				end
				
				if not (requests == 0) then
					break
				end
				
				for n=1, #tone.n, 1 do
					note = tone.n[n]
					
					for _, speaker in pairs(speakers) do
						speaker.playNote(getInstrument(note.i), volume, note.n)
					end
				end
				
				if (menuid == 0) then
					term.setTextColor(colors.black)
					term.setBackgroundColor(colors.cyan)
		
					term.setCursorPos(1,12)
					term.write(formatTime((tone.t / 10)*soundFile.s))
					
					term.setCursorPos(22,12)
					term.write(formatTime((maxTicks/10)*soundFile.s))
					
					if (requestedTick == -1) then
						audioslide.setValue((tone.t / maxTicks)*100)
					end
				end
			end
			
			t = t + 1
		end
		
	else
		return nil
	end
	
	if (requests == -1) then
		requests = 0
		play(song)
	end
	
	requestedTick = -1
end

function formatTime(t)
	minutes = math.floor(t / 60)..""
	seconds = math.floor(t % 60)..""

	if (string.len(minutes) <= 1) then
		minutes = "0"..minutes
	end
	
	if (string.len(seconds) <= 1) then
		seconds = "0"..seconds
	end
	
	return minutes..":"..seconds

end

function wait(millis)
	local timer = os.startTimer(millis)
	
	while true do
		local event = {os.pullEvent()}
		if (event[1] == "timer" and event[2] == timer) then
			break
		else
			eventHandler(event)
		end
	end

end

function eventHandler(event)
	if not (event[1] == "task_complete") then
		
		if (menuid == 0) then
			audioslide.eventHandler(event)
		end
		
		--print(event[1], event[2], event[3], event[4])
		
		if (event[1] == "mouse_click") then
			if (event[2] == 1) then
			
				if (clickTest(1, 1, 26, 1, event[3], event[4])) then --Menu
					
					if (clickTest(1,1,7,1, event[3], event[4])) then
						menuid = 0
						
					elseif (clickTest(7,1,10,1, event[3], event[4])) then
						menuid = 1
					
					elseif (clickTest(16,1,10,1, event[3], event[4])) then
						menuid = 2
					end
					
					drawGUI()
				end
			
				if (menuid == 0) then --Player menu
					if (clickPlay(event[3], event[4])) then
						togglePause()
					end
					
					if (clickForward(event[3], event[4])) then
						requests = 1
					end
					
					if (clickBack(event[3], event[4])) then
						requests = -2
					end
				end
			end
		end
		
		if (event[1] == "key_up") then
			if (event[2] == 203) then -- Previous song
				requests = -2
			end
			
			if (event[2] == 205) then -- Next song
				requests = 1
			end
			
			if (event[2] == 25) then -- Pause
				togglePause()
			end
		end
		
	end
end

function togglePause()
	paused = not paused
	
	if not (paused) then
		pauseButton()
	else
		playButton()
	end
	
end

function getInstrument(id)
	if (id == 0) then -- Piano
		return "harp"
		
	elseif (id == 1) then -- DoubleBass
		return "bass"
		
	elseif (id == 2) then -- BassDrum
		return "basedrum"
		
	elseif (id == 3) then -- SnareDrum
		return "snare"
		
	elseif (id == 4) then -- Cclick
		return "hat"
	end
	
	return nil
end

local function get(fileurl, savepath)
	local ok, err = http.checkURL(fileurl)
	if not ok then
		return nil
	end
	
	local response = http.get(fileurl, nil, true)
	if not response then
		return nil
	end
	
	local file = response.readAll()
	response.close()
	
	if (fs.exists(savepath)) then
		fs.delete(savepath)
	end
	
	local f = fs.open(savepath, "w")
	f.write(file)
	f.close()
	
	return true
end

function main(album)
	if (album == nil) then
		album = "./album.lua"
		
		if not (fs.exists(album)) then
		
			get("https://raw.githubusercontent.com/Frekvens1/MinecraftLua/master/ComputerCraft/Album.lua", album)
		
		end
		
	end
	
	if not (fs.exists(album)) then
		print("No album found!")
		return nil
	end
	
	f = fs.open(album, "r")
	file = f.readAll()
	f.close()
		
	albumFile = textutils.unserialize(file)
	songid = 0
	while true do
		songid = songid + 1
		if (songid > #albumFile.songs) then
			songid = 1
		end

		song = albumFile.songs[songid]
		if (fs.exists("./tmp/musicplayer/")) then
			fs.delete("./tmp/musicplayer/")
		end
		
		if not (fs.exists("./tmp/musicplayer/")) then
			fs.makeDir("./tmp/musicplayer/")
		end
		
		get(song.url, "./tmp/musicplayer/"..song.name)
			
		play("./tmp/musicplayer/"..song.name)
			
		fs.delete("./tmp/musicplayer/")
			
		if not (requests == 0) then
			if (requests == -1) then
				songid = songid-1
		
			elseif (requests == -2) then
				songid = songid-2
				
				if (songid == 0) then
					songid = 0
					
				elseif (songid < 0) then
					songid = #albumFile.songs-1
				end
			end
				
			requests = 0
		end
	end

end

-- GUI for MusicPlayer

function playButton()
	x = 11
	y = 16
	
	paintutils.drawFilledBox(x, y, x+5, y+4, colors.black)
	paintutils.drawFilledBox(x+1, y+1, x+4, y+3, colors.green)	
	
	term.setTextColor(colors.black)
	term.setBackgroundColor(colors.green)
	
	term.setCursorPos(x+4, y+2)
	term.write(">")
	
	term.setCursorPos(x+3, y+1)
	term.write("\\")
	
	term.setCursorPos(x+3, y+3)
	term.write("/")
	
	term.setCursorPos(x+2, y+3)
	term.write("|")
	term.setCursorPos(x+2, y+2)
	term.write("|")
	term.setCursorPos(x+2, y+1)
	term.write("|")
end

function pauseButton()
	x = 11
	y = 16
	
	paintutils.drawFilledBox(x, y, x+5, y+4, colors.black)
	paintutils.drawFilledBox(x+1, y+1, x+4, y+3, colors.red)
	
	term.setTextColor(colors.black)
	term.setBackgroundColor(colors.red)
	
	term.setCursorPos(x+2, y+3)
	term.write("\\")
	term.setCursorPos(x+3, y+3)
	term.write("/")
	
	term.setCursorPos(x+1, y+2)
	term.write("<")
	term.setCursorPos(x+4, y+2)
	term.write(">")
	
	term.setCursorPos(x+2, y+1)
	term.write("/")
	term.setCursorPos(x+3, y+1)
	term.write("\\")
end

function clickPlay(x1, y1)

	x = 11
	y = 16
	width = 5
	height = 5

	if ((x1 >= x) and (x1 <= width+x)) then
		if ((y1 >= y) and (y1 <= height+y)) then
			return true
		end
	end
	
	return false
end

function clickTest(x, y, width, height, x1, y1)

	if ((x1 >= x) and (x1 <= width+x)) then
		if ((y1 >= y) and (y1 <= height+y)) then
			return true
		end
	end
	
	return false
end

function clickForward(x1, y1)

	x = 19
	y = 16
	width = 5
	height = 5

	if ((x1 >= x) and (x1 <= width+x)) then
		if ((y1 >= y) and (y1 <= height+y)) then
			return true
		end
	end
	
	return false
end

function clickBack(x1, y1)

	x = 3
	y = 16
	width = 5
	height = 5

	if ((x1 >= x) and (x1 <= width+x)) then
		if ((y1 >= y) and (y1 <= height+y)) then
			return true
		end
	end
	
	return false
end

function forwardButton()
	x = 19
	y = 16
	
	paintutils.drawFilledBox(x, y, x+5, y+4, colors.black)
	paintutils.drawFilledBox(x+1, y+1, x+4, y+3, colors.orange)
	
	term.setTextColor(colors.black)
	term.setBackgroundColor(colors.orange)
	
	term.setCursorPos(x+3, y+1)
	term.write("\\")
	
	term.setCursorPos(x+4, y+2)
	term.write(">")
	
	term.setCursorPos(x+3, y+3)
	term.write("/")
	
	term.setCursorPos(x+1, y+1)
	term.write("__")
	
	term.setCursorPos(x+1, y+2)
	term.write("__")

end

function backButton()
	x = 3
	y = 16
	
	paintutils.drawFilledBox(x, y, x+5, y+4, colors.black)
	paintutils.drawFilledBox(x+1, y+1, x+4, y+3, colors.orange)
	
	term.setTextColor(colors.black)
	term.setBackgroundColor(colors.orange)
	
	term.setCursorPos(x+2, y+1)
	term.write("/")
	
	term.setCursorPos(x+1, y+2)
	term.write("<")
	
	term.setCursorPos(x+2, y+3)
	term.write("\\")
	
	term.setCursorPos(x+3, y+1)
	term.write("__")
	
	term.setCursorPos(x+3, y+2)
	term.write("__")
end

function slidebar(x1, y1, width1, height1)
	
	local self = {}
	
	local x = x1
	local y = y1
	local width = width1
	local height = height1
	local value = 0
	
	function self.draw()
		paintutils.drawFilledBox(x, y, x+width, y+height, colors.lightGray)
		
		drawX = (width * (value/100)) + x
		
		paintutils.drawFilledBox(drawX, y, drawX, y+height, colors.gray)
		
	end
	
	function self.eventHandler(event)
		if (event[1] == "mouse_click") or (event[1] == "mouse_drag") then
			if (event[2] == 1) then
				if (clickTest(x, y, width, height, event[3], event[4])) then
					val = ( ((event[3] - x) / (width))*100 )
					self.setValue(val)
					requestedTick = (val / 100) * maxTicks
				end
			end
		end
	end
	
	function self.setValue(val)
		value = val
		self.draw()
	end
	
	function self.getValue()
		return value
	end
	
	return self
	
end

function drawGUI()
	term.setBackgroundColor(colors.cyan)

	term.clear()
	
	paintutils.drawFilledBox(1, 1, 26, 1, colors.lightGray) -- Menu
	
	term.setCursorPos(1,1)
	term.setTextColor(colors.black)
	term.setBackgroundColor(colors.lightGray)
	term.write("Player | Browse | Settings")
	
	term.setBackgroundColor(colors.gray)
	
	if (menuid == 0) then
		term.setCursorPos(1,1)
		term.write("Player |")
		
		paintutils.drawFilledBox(0, 15, 26, 20, colors.gray)
		paintutils.drawFilledBox(0, 14, 26, 14, colors.black)
		
		if paused then
			playButton()
		else
			pauseButton()
		end
		
		forwardButton()
		backButton()
		
		term.setTextColor(colors.black)
		term.setBackgroundColor(colors.cyan)
		
		term.setCursorPos(1,3)
		print("Now playing:")
		print(currentSong)
		
		audioslide.draw()
	
	elseif (menuid == 1) then
		term.setCursorPos(8,1)
		term.write("| Browse |")
		
	elseif (menuid == 2) then
		term.setCursorPos(17,1)
		term.write("| Settings")
		
	end
	
	term.setCursorPos(1,1)
end

audioslide = slidebar(1, 13, 25, 0)

drawGUI()
args = {...}
main(args[1])
