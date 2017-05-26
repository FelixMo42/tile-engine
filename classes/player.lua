player = class:new({
	type = "player",
	x = 1, y = 1,
	color = color.blue,
	path = {}
})

function player:draw(x,y,s)
	local x = x or (self.x - self.map.x) * map_setting.scale
	local y = y or (self.y - self.map.y - 1) * map_setting.scale
	local s = s or map_setting.scale
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill" , x , y , s , 2 * s )
end

function player:goTo(x,y)
	self.path = pathfinder:path(self.map , math.floor(self.x),math.floor(self.y) , x,y)
end

function player:update(dt)
	if #self.path > 0 then
		local d = 1 / math.sqrt( (self.path[1].x - self.tile.x) ^ 2 + (self.path[1].y - self.tile.y) ^ 2 )
		self.x = self.x + ( (self.path[1].x - self.tile.x) * dt * player_setting.speed * d )
		self.y = self.y + ( (self.path[1].y - self.tile.y) * dt * player_setting.speed * d )
		local cx = math.abs(self.x - self.tile.x) >= math.abs(self.path[1].x - self.tile.x)
		local cy = math.abs(self.y - self.tile.y) >= math.abs(self.path[1].y - self.tile.y)
		if cx and cy then
			self:setPos(self.path[1].x, self.path[1].y)
			table.remove( self.path , 1 )
		end
	end
end

function player:setPos(x,y)
	self.map.playerMap[self.tile.x][self.tile.y] = nil
	self.x , self.y = x , y
	self.tile = self.map[x][y]
	self.map.playerMap[x][y] = self
end

npcs = {}

player_setting = {speed = 5 , file = "npcs"}