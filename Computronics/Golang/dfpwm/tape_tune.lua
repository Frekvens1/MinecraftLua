tape = peripheral.find("tape_drive")
args = {...}

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

if #args == 0 then
  print("Usage tape_tune {url}")
  return nil
 end
 
 file = get(args[1])
 if file then
  tape.stop()
  tape.seek(-tape.getPosition()) -- Rewind
  tape.write(file)
  tape.seek(-tape.getPosition()) -- Rewind
 else
  print("An error occured while handling your request!")
  return nil
 end
