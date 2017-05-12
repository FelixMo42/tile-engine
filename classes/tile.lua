tile = class:new({
	type = "tile",
	color = color.green
})

function tile:draw()
	local x = (self.x - self.map.x) * map_setting.scale
	local y = (self.y - self.map.y) * map_setting.scale
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill",x,y,map_setting.scale,map_setting.scale)
	if map_setting.line then
		love.graphics.setColor(color.black)
		love.graphics.rectangle("line",x,y,map_setting.scale,map_setting.scale)
	end
end