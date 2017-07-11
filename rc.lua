uart.setup(0, 9600, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)
-- when 4 chars is received.
uart.on("data", 
  function(data)
    print("receive from uart:", data)
    if data=="quit" then
      --uart.on("data") -- unregister callback function
    end
end, 0)
-- when '\r' is received.
uart.on("data", "\r",
  function(data)
    print("receive from uart:", data)
    if data=="quit\r" then
      --uart.on("data") -- unregister callback function
    end
end, 0)