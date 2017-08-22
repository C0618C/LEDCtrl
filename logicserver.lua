local httpServer = require("httpServer")
local gct = require("gpioctrl")
local mx = require("matrixctrl")


httpServer:listen(80,20)
httpServer:use('/welcome', function(req, res)
    res:send('Hello ' .. req.query.name) -- /welcome?name=doge
end)

--[[
        GPIO Handel
]]
httpServer:use('/gpiolist', function(req, res)
    local gInfo = gct:Info()
    local rsl_str="["
    for i=0,12 do
        rsl_str = rsl_str .. gInfo[i]..(i==12 and "]" or ",")
    end
    res:send(rsl_str)
end)

httpServer:use('/setgpio', function(req, res)
    local rsl = "false" --gct:Toggle(req.query.id) and "true" or "false"

    local ac = req.query.ac+0
    rsl = ac == 0 and tostring(gct:On(req.query.id)) or tostring(gct:Off(req.query.id))

    res:send('{"rsl":'..rsl..'}')
end)


--[[
        8*8 Led Matrix
]]
httpServer:use('/mx/setdata', function(req, res)
    local rsl = "false"
    local nn=req.query.id/8
    local r=math.ceil(nn)
    if r == nn then r = r+1 end
    local c=req.query.id%8+1

    mx:SetData(r,c,req.query.ac)

    res:send('{"rsl":'..rsl..'}')
    collectgarbage()
end)

httpServer:use('/mx/getall', function(req, res)
    local status = mx:GetStatus()
    res:send('[]')
end)

httpServer:use('/mx/switch', function(req, res)
    local rsl = false
    if req.query.ac == "true" then
        rsl = mx:On()
    else
        rsl = mx:Off()
    end
    res:send('{"rsl":'..(rsl and 'true' or 'false')..'}')
    collectgarbage()
end)

httpServer:use('/mx/brightness', function(req, res)
    mx:SetBrightness(req.query.v);
    res:send('{"rsl":"'..req.query.v..'"}')
    collectgarbage()
end)

httpServer:use('/mx/getinfo',function(req,res)
    local info = mx:GetInfo()
    local rsl = ''
    for k in pairs(info.status) do
        for j=7,0,-1 do
            rsl = rsl .. (bit.isset(info.status[k],j) and "1" or "0") .. ","            
        end
    end
    res:send('{"status":['..string.sub(rsl,1,-2)..'],"brightness":'.. info.brightness ..'}')
end)

httpServer:use('/mx/test', function(req, res)
    mx:Test(req.query.v);
    res:send('{"rsl":"'..req.query.v..'"}')
    collectgarbage()
end)

httpServer:use('/mx/fix', function(req, res)
    mx:Test('false');
    res:send('{"rsl":"'..req.query.v..'"}')
    collectgarbage()
end)

mx:SetUp()
print('Logic Server Run!!!')