player = class:new({
	type = "player",
	x = 1, y = 1,
	color = color.blue
})

function player:draw()
	local x = (self.x - self.map.x) * map_setting.scale
	local y = (self.y - self.map.y - 1) * map_setting.scale
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill" , x , y , map_setting.scale , 2 * map_setting.scale )
end

function player:setPos(x,y)
	self.map.playerMap[self.x][self.y] = nil
	self.x , self.y = x , y
	self.map.playerMap[x][y] = self
end

player_setting = {speed = 5}