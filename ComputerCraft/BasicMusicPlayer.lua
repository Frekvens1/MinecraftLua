local FileList = fs.list("./songs") -- Song folder

while true do
  for _, file in ipairs(FileList) do
    os.sleep(1)
    term.clear()
    term.setCursorPos(1, 1)
    print("Now playing: "..file)
    shell.run("./songs/"..file)
  end
end
