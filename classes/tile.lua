tile = class:new({
	type = "tile",
	color = color.green,
	walkable = true
})

function tile:load()
	if self.object then
		self:setObject(self.object:new())
	end
	if self.item then
		self:setItem(self.item:new())
	end
end

function tile:draw(x,y,s)
	--tile
	local s = s or map_setting.scale
	local x = x or (self.x - self.map.x) * map_setting.scale
	local y = y or (self.y - self.map.y) * map_setting.scale
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill",x,y,s,s)
	if map_setting.line then
		love.graphics.setColor(color.black)
		love.graphics.rectangle("line",x,y,s,s)
	end
	--object
	if self.object then
		self.object:draw(x,y,s)
	end
	--item
	if self.item then
		self.item:draw(x,y,s)
	end
end

function tile:open()
	if self.object and not self.object.walkable then return false end
	if self.player then return false end
	return self.walkable
end

function tile:setObject(o)
	o.map = self.map
	o.tile = self
	self.object = o
end

function tile:setItem(i)
	i.map = self.map
	i.tile = self
	self.item = i
end

tiles = {}