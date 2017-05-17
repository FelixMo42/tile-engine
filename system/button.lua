local button = require("ui"):new({
	width = 100, height = 20, b = 0,
	bodyColor = {0,0,0},
	lineColor = {255,255,255},
	textColor = {255,255,255},
	x = 0, y = 0,
	text = "button",
	getmode = "norm",
	over = false,
	pressed = false,
	b = 0,
	b_over = 4,
	modes = {
		"pressed",
		"over"
	}
})

button:addCallback("draw","body",function(self)
	love.graphics.setColor(self.bodyColor)
	love.graphics.rectangle("fill",self.x,self.y,self.width,self.height,self.edge or 0)
end )

button:addCallback("draw","outline",function(self)
	love.graphics.setColor(self.lineColor)
	love.graphics.rectangle("line",self.x,self.y,self.width,self.height,self.edge or 0)
end )

button:addCallback("draw","text",function(self)
	local text = self.text or self.text_def
	love.graphics.setColor(self.textColor)
	local l = #( ( {love.graphics.getFont():getWrap(self.text,self.width)} )[2] )
	local y = self.y + self.height / 2 -  (l * love.graphics.getFont():getHeight())/2
	love.graphics.printf(self.text,self.x,y,self.width,self.textMode or "center")
end )

button:addCallback("mousepressed","pressed",function(self)
	self.pressed = self.over
end )

button:addCallback("mousepressed","used",function(self)
	if not mouse.used and self.over then
		mouse.used = true
	end
end)

button:addCallback("mousereleased","callFunc",function(self)
	if self.over and self.func and not mouse.used then
		self:func()
	end
end )

button:addCallback("mousereleased","used",function(self)
	if not mouse.used and self.over then
		mouse.used = true
	end
end)

button:addCallback("mousereleased","released",function(self)
	self.pressed = false
end )

button:addCallback("mousemoved","over",function(self,x,y)
	if x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height then
		self.over = true
	else
		self.over = false
	end
end )

local mt = getmetatable(button)

mt.__index = function(self,key)
	local mt = getmetatable(self)
	if mt.__getter[key] then
		return mt.__getter[key](self,key)
	end
	if type(key) == "string" then
		for i , mode in ipairs(rawget(self,"modes")) do
			if rawget(self,mode) and rawget(self,key.."_"..mode) then
				return rawget(self,key.."_"..mode)
			end
		end
	end
	return rawget(self,key)
end

mt.__getter.x = function(self)
	for i , mode in ipairs(rawget(self,"modes")) do
		if rawget(self,mode) and rawget(self,"x_"..mode) then
			return rawget(self,"x_"..mode) - (self.bl or ( (self.bw or self.b) / 2 ) )
		end
	end
	return rawget(self,"x") - ( self.bl or ( (self.bw or self.b) / 2 ) )
end

mt.__getter.y = function(self)
	for i , mode in ipairs(rawget(self,"modes")) do
		if rawget(self,mode) and rawget(self,"y_"..mode) then
			return rawget(self,"y_"..mode) - ( self.bu or ( (self.bh or self.b) / 2 ) )
		end
	end
	return rawget(self,"y") - ( self.bu or ( (self.bh or self.b) / 2 ) )
end

mt.__getter.width = function(self)
	for i , mode in ipairs(rawget(self,"modes")) do
		if rawget(self,mode) and rawget(self,"width_"..mode) then
			return rawget(self,"width_"..mode) + (self.br or self.bw or self.b) + (self.bl or 0)
		end
	end
	return rawget(self,"width") + (self.br or self.bw or self.b) + (self.bl or 0)
end

mt.__getter.height = function(self)
	for i , mode in ipairs(rawget(self,"modes")) do
		if rawget(self,mode) and rawget(self,"height_"..mode) then
			return rawget(self,"height_"..mode) + (self.bd or self.bh or self.b) + (self.bu or 0)
		end
	end
	return rawget(self,"height") + (self.bd or self.bh or self.b) + (self.bu or 0)
end

package.preload["button"] = function() return button end

return button