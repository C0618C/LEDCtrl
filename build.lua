collectgarbage()

print("============ build start ==========")
local luaFile = {"httpServer","logicserver","matrixctrl","gpioctrl"}
for i,f in ipairs(luaFile) do
    f = f..".lua"
    if file.open(f) then
        file.close()
        node.compile(f)
        file.remove(f)
    end
end
print("============ build finish ==========")
luaFile = nil
collectgarbage()
file.remove("build.lua")
print("============ remove build.lua ==========")

collectgarbage()
