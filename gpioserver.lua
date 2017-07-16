dofile('httpServer.lua')
httpServer:listen(80)
httpServer:use('/welcome', function(req, res)
    res:send('Hello ' .. req.query.name) -- /welcome?name=doge
end)
httpServer:use('/gpiolist', function(req, res)
    local rsl_str="["
    for i=0,12 do
        --gpio.mode(i, gpio.INPUT)
        rsl_str = rsl_str .. (gpio.read(i))..(i==12 and "]" or ",")
    end
    res:send(rsl_str)
end)

httpServer:use('/setgpio', function(req, res)
    res:send('{"x":"aaa"}')
end)