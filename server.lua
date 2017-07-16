
s_h = "HTTP/1.1 200 OK\r\nServer: NodeMCU on ESP8266\r\nContent-Type: text/html; charset=utf-8\r\n\r\n<!DOCTYPE HTML>\r\n<html>\r\n<body><p style=\"font-size:20px;\">"
s_e = "</p></body></html>\r\n\r\n"
he_404 =[[HTTP/1.1 404 Not Found\r\n]]

srv=net.createServer(net.TCP,1)
function onReceive(n_sck,data)
    print("Recive Data:\n\r",data)
    local response = {}
    Router(data,response)
    
    local function send(localSocket)
    if #response > 0 then
      localSocket:send(table.remove(response, 1))
    else
      localSocket:close()
      response = nil
    end
    end
    
    n_sck:on("sent", send)
    send(n_sck)
end
srv:listen(80,function(n_socket) 
    n_socket:on("receive",onReceive)
    n_socket:on("connection",function(s,d) print(d) end)
end)


function Router(data,response)
    response[#response + 1] = s_h
    response[#response + 1] = "<h1>Welcome Too!</h1>"
    response[#response + 1] = "<pre>"..data.."</pre>"
    response[#response + 1] = s_e
end

print("Server Created!")

--srv:getaddr()
--srv:close()
[[
Recive Data:    POST /a HTTP/1.1
Host: 192.168.0.115
User-Agent: Go-http-client/1.1
Content-Length: 9
Content-Type: application/x-www-form-urlencoded
Accept-Encoding: gzip
]]