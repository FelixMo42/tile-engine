love.threaderror = love.threaderror or function(thread, errorstr)
	print(errorstr)
end

local client = {}

client.chanel = {
	action = love.thread.newChannel(),
	send = love.thread.newChannel(),
	get = love.thread.newChannel()
}

client.thread = love.thread.newThread("system/client/thread.lua")

client.port = "get"
client.host = "personal"

client.start = function(self)
	self.thread:start(self.chanel.action , self.chanel.send , self.chanel.get , self.port , self.host)
end

client.get = function(self)
	return self.chanel.get:pop()
end

client.demand = function(self)
	return self.chanel.get:demand()
end

client.send = function(self , msg)
	self.chanel.send:push()
end

client.action = function(self , command)
	self.chanel.action.command:push("command")
	return self.chanel.get:demand()
end

return client