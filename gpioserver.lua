dofile('httpServer.lua')
httpServer:listen(80)
httpServer:use('/welcome', function(req, res)
    res:send('Hello ' .. req.query.name) -- /welcome?name=doge
end)
httpServer:use('/gpiolist', function(req, res)
    res:send('{"aa":"bb"}') -- /welcome?name=doge
end)