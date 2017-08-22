local gct = require("gpioctrl")
gct:Low(4)

server_run = false
function StartServer()
    --print("Start Http Server!")
    dofile('logicserver.lc')
    server_run = true
    gct:High(4)
end


wifi.ap.config({ ssid = 'NodeMCU', auth = wifi.WPA_WPA2_PSK,pwd="779686611" });
wifi.ap.setip({ip="1.8.8.1",netmask="255.255.255.0",gateway="1.8.8.1"})
wifi.setmode(wifi.STATIONAP)

StartServer()