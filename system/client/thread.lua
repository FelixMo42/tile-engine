arg = {...}

--get channels
action = arg[1]
send = arg[2]
get = arg[3]
port = arg[4]
ipchoice = arg[5]


--ip's
ip = {
	personal = "0.0.0.0",
	home = "192.168.1.180",
	school = "10.120.113.75",
	server = "75.119.201.4"
}

--get host and port
host = ip[ipchoice]
if port == "get" then
	until port and port >= 0 do
		port = tonumber(send:demand())
	end
elseif port == "server" then
	port = tonumber( ({http.request("http://mosegames.com/data/port.txt")})[1] )
end

--open client
socket = require("socket")
client = socket.tcp()
client:connect(host, port)
client:settimeout(0)

--actions
actions = {}
actions.getIP = function()
	local s = socket.udp()
	s:setpeername("74.125.115.104",80)
	local ip , _ = s:getsockname()
	s:close()
	return ip
end

--main loop
while true do
	--receive data
	local msg , status , partial = client:receive()
	if msg then
		get:push(msg)
	end
	--send data
	local value = send:pop()
	if value then
		client:send(value.."\n")
	end
	--actions
	local command = action:pop()
	if command and actions[command] then
		get:push( actions[command]() )
	end
end