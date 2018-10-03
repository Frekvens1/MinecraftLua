local FileList = fs.list("./songs") -- Song folder

while true do
  for _, file in ipairs(FileList) do
    print("Now playing: "..file)
    shell.run("./songs/"...file)
  end
end
