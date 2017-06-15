local lambda = class:new({type = "function"})

mt = getmetatable(lambda)

mt.__new = function(self , func , ...)
	self.functions = {func}
	self.parameters = {...}
end

mt.__call = function(self , ...)
	for i , func in ipairs(self.functions) do
		func(unpack(self.parameters),...)
	end
end

function lambda:addFunc(func)
	self.functions[#self.functions + 1] = func
end

function lambda:removeFunc(func)
	for i , f in ipairs(self.functions) do
		if f == func then
			table.remove(self.functions,i)
			return
		end 
	end
end

function lambda:setParameters(...)
	self.parameters = {...}
end

lambda = lambda:new()

return lambda