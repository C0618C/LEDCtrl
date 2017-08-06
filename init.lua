local gct = require("gpioctrl")
gct:Low(4)

wifi.setmode(wifi.STATIONAP)

server_run = false
function StartServer()
    --print("Start Http Server!")
    dofile('logicserver.lc')
    server_run = true
    gct:High(4)
end

function FindTarget(t)
  for k,v in pairs(t) do
    if k == "VMWED_2G" then 
        wifi.sta.config("VMWED_2G","779686611") 
        --wifi.sta.connect()
        wifi.sta.autoconnect(1)
        tmr.alarm(1, 5000, tmr.ALARM_AUTO, function()
            if wifi.sta.getip() == nil then
                print('Waiting for IP ...')
            else
                print('Wifi Info: ' .. wifi.sta.getip())
                tmr.stop(1)
                StartServer()
            end
        end)
        break
    end
  end
end
wifi.sta.getap(FindTarget)
--]]

--[[
i=1
gpio.mode(i,gpio.OUTPUT)
gpio.mode(i+1,gpio.OUTPUT)
t=0
tmr.alarm(0,100,1,function() 
    if(server_run) then
        gpio.write(i,t%2==0 and gpio.HIGH or gpio.LOW)
        gpio.write(i+1,t%2~=0 and gpio.HIGH or gpio.LOW)
    end
    t=t+1
end)

print('Wifi is Ok ')
wifi.ap.config({ ssid = 'NodeMCU', auth = wifi.WPA_WPA2_PSK,pwd="779686611" });
wifi.ap.setip({ip="1.8.8.1",netmask="255.255.255.0",gateway="1.8.8.1"})
wifi.setmode(wifi.SOFTAP)

dofile('logicserver.lua')
--]]


--[[
spi.setup(1,spi.MASTER,spi.CPOL_LOW,spi.CPHA_LOW,8,8)
spi.send(1,0x0f,0x01)
]]
