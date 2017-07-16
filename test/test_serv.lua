wifi.ap.config({ ssid = 'mymcu', auth = AUTH_OPEN })
wifi.setmode(wifi.SOFTAP)
dofile('httpServer.lua')