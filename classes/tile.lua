tile = class:new({
	type = "tile",
	color = color.green
})

function tile:draw(x,y,s)
	local s = s or map_setting.scale
	local x = x or (self.x - self.map.x) * map_setting.scale
	local y = y or (self.y - self.map.y) * map_setting.scale
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill",x,y,s,s)
	if map_setting.line then
		love.graphics.setColor(color.black)
		love.graphics.rectangle("line",x,y,s,s)
	end
end

tiles = {}