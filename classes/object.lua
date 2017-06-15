object = class:new({
	type = "object",
	color = color.brown,
	walkable = false
})

function object:draw(x,y,s)
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill",x,y,s,s)
end

function object:getActions()
	return {}
end

local mt = getmetatable(object)

mt.__tostring = function(self)
	return "objects."..self.file..":new()"
end

objects = {}