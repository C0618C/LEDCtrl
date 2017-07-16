-- local data =[[POST /setgpio HTTP/1.1
-- Host: 192.168.0.115
-- User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3157.3 Safari/537.36
-- Content-Length: 7
-- Accept: */*
-- Accept-Encoding: gzip, deflate
-- Accept-Language: zh-CN,zh;q=0.8
-- Content-Type: application/x-www-four-urlencoded;charset=UTF-8
-- Origin: http://192.168.0.115
-- Proxy-Connection: keep-alive
-- Referer: http://192.168.0.115/
-- X-Lantern-Version: 3.7.3

-- id=abcc]]

-- local contentLength = 0
-- for word in string.gmatch(data, "[^\r\n]+") do 
--     local _,__,___,cl = word:find("Content%-Length:(%s*)(%d*)");
--     if _ ~= nil then
--         contentLength = cl
--         break
--     end
-- end

--print("rsl:["..data:sub(-1*contentLength).."]")


local s= "T"
s = (s and s.."a" or "").."abc"
print(s)
