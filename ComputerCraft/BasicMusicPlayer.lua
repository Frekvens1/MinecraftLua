local FileList = fs.list("./songs") -- Song folder

for _, file in ipairs(FileList) do
  print(file) --Print the file name
end
