--------------------
-- helper
--------------------
function urlDecode(url)
	return url:gsub('%%(%x%x)', function(x)
		return string.char(tonumber(x, 16))
	end)
end

function guessType(filename)
	local types = {
		['.css'] = 'text/css', 
		['.js'] = 'application/x-javascript', 
		['.html'] = 'text/html;charset=utf-8',
		['.png'] = 'image/png',
		['.jpg'] = 'image/jpeg',
		['.ico'] = 'image/x-icon',
		['.gif'] = 'image/gif'
	}
	for ext, type in pairs(types) do
		if string.sub(filename, -string.len(ext)) == ext
			or string.sub(filename, -string.len(ext .. '.gz')) == ext .. '.gz' then
			return type
		end
	end
	return 'text/plain'
end

--------------------
-- Response
--------------------
local Res = {
	_skt = nil,
	_type = nil,
	_status = nil,
	_redirectUrl = nil,
	_timeout=30
}

function Res:new(skt)
	local o = {}
	setmetatable(o, self) --元表
    self.__index = self
    o._skt = skt
    return o
end

function Res:redirect(url, status)
	status = status or 302

	self:status(status)
	self._redirectUrl = url
	self:send(status)
end

function Res:type(type)
	self._type = type
end

function Res:status(status)
	self._status = status
end

function Res:send(body)
	self._status = self._status or 200
	self._type = self._type or 'text/html'

	local buf = 'HTTP/1.1 ' .. self._status .. '\r\n'
		.. 'Cache-Control: private\r\nConnection: Keep-Alive\r\n'	
		.. 'Content-Type: ' .. self._type .. '\r\n'
		.. 'Content-Length: ' .. string.len(body) .. '\r\n'
		.. 'Access-Control-Allow-Origin: '..'*\r\n'
	if self._redirectUrl ~= nil then
		buf = buf .. 'Location: ' .. self._redirectUrl .. '\r\n'
	end
	buf = buf .. '\r\n' .. body

	local function doSend()
		if buf == '' then 
			self:close()
		else
			self._skt:send(string.sub(buf, 1, 512))
			buf = string.sub(buf, 513)
		end
	end
	self._skt:on('sent', doSend)

	doSend()
end

function Res:sendFile(filename)
	if file.exists(filename .. '.gz') then
		filename = filename .. '.gz'
	elseif not file.exists(filename) then
		self:status(404)
		if filename == '404.html' then
			self:send(404)
		else
			self:sendFile('404.html')
		end
		return
	end

	self._status = self._status or 200
	local curstatus = self._status  == 200 and self._status..' OK' or self._status
	self._type = self._type or guessType(filename)

	local header = 'HTTP/1.1 ' .. curstatus .. '\r\n'
	header = header .. 'Cache-Control: private\r\nConnection: Keep-Alive\r\n'	
	
	if string.sub(filename, -3) == '.gz' then
		header = header .. 'Content-Encoding: gzip\r\n'
	end
	header = header .. 'Content-Type: ' .. self._type .. '\r\n'
	header = header .. 'Server: NMHS/1.0\r\n'
	header = header .. 'Keep-Alive: timeout=' .. self._timeout .. '\r\n'
	header = header .. '\r\n'

	--print('* Sending ', filename)
	local pos = 0
	local function doSend()
		file.open(filename, 'r')
		if file.seek('set', pos) == nil then
			self:close()
			--print('* Finished ', filename)
		else
			local buf = file.read(512)
			pos = pos + 512
			self._skt:send(buf)
		end
		file.close()
	end
	self._skt:on('sent', doSend)
	
	self._skt:send(header)
end

function Res:close()
	self._skt:on('sent', function() end) -- release closures context
	self._skt:on('receive', function() end)
	self._skt:close()
	self._skt = nil
	collectgarbage()
end

--------------------
-- Middleware
--------------------
function parseHeader(req, res)
	--print("-----------------",req.ip)
	--print(req.source)
	local _, _, method, path, vars = string.find(req.source, '([A-Z]+) (.+)?(.+) HTTP')
	if method == nil then
		_, _, method, path = string.find(req.source, '([A-Z]+) (.+) HTTP')
	end

	if method == nil then  return false end

	if method:upper() == "POST" then
		for word in string.gmatch(req.source, "[^\r\n]+") do 
			local _,__,___,cl = word:find("Content%-Length:(%s*)(%d*)");
			if _ ~= nil then
				vars = (vars and vars.."&" or "")..req.source:sub(-1*cl)
				break
			end
		end
	end
	local _GET = {}
	if vars ~= nil then
		vars = urlDecode(vars)
		for k, v in string.gmatch(vars, '([^&]+)=([^&]*)&*') do
			_GET[k] = v
		end
	end
	
	req.method = method
	req.query = _GET
	req.path = path

	return true
end

function staticFile(req, res)
	local filename = ''
	if req.path == '/' then
		filename = 'index.html'
	else
		filename = string.gsub(string.sub(req.path, 2), '/', '_')
	end
	
	res:sendFile(filename)
end

--------------------
-- HttpServer
--------------------
local httpServer = {
	_srv = nil,
	_mids = {{
		url = '.*',
		cb = parseHeader
	}, {
		url = '.*',
		cb = staticFile
	}}
}

function httpServer:use(url, cb)
	table.insert(self._mids, #self._mids, {
		url = url,
		cb = cb
	})
end

function httpServer:close()
	self._srv:close()
	self._srv = nil
	collectgarbage()
end

local postQueue={}

function httpServer:listen(port,timeout)
	Res._timeout =  timeout or Res._timeout
	self._srv = net.createServer(net.TCP,Res._timeout)
	self._srv:listen(port, function(conn)
		conn:on('receive', function(skt, msg)
			local req = { source = msg, path = '', ip = skt:getpeer() }
		
			if msg:sub(0,4):upper() == "POST" and msg:sub(-1) == "\n" then
				postQueue[req.ip]=msg
				return
			elseif postQueue[req.ip] then
				req.source = postQueue[req.ip]..msg
				postQueue[req.ip] = nil
			end

			local res = Res:new(skt)

			for i = 1, #self._mids do
				if string.find(req.path, '^' .. self._mids[i].url .. '$') and not self._mids[i].cb(req, res) then
					break
				end
			end
			collectgarbage()
		end)
	end)
end

return httpServer