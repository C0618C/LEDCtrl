local httpServer = require("httpServer")
local gct = require("gpioctrl")
local mx = require("matrixctrl")


httpServer:listen(80,20)
httpServer:use('/welcome', function(req, res)
    res:send('Hello ' .. req.query.name) -- /welcome?name=doge
end)
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

httpServer:use('/setmatrix', function(req, res)
    local rsl = "false" --gct:Toggle(req.query.id) and "true" or "false"

    --local ac = req.query.ac+0
    --rsl = ac == 0 and tostring(gct:On(req.query.id)) or tostring(gct:Off(req.query.id))
    print("req:",req.query.id,req.query.ac)

    local nn=req.query.id/8
    local r=math.ceil(nn)
    if r == nn then r = r+1 end
    local c=req.query.id%8+1

    mx.SetData(_,r,c,req.query.ac)

    res:send('{"rsl":'..rsl..'}')
end)

mx.SetUp()
print('GPIO Server Run!!!')