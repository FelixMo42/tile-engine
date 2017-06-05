player = class:new({
	type = "player",
	x = 1, y = 1,
	color = color.blue,
	path = {},
	dialog = {text = "hello"},
	hp = 100,
	mana = 100,
	inventory = {},
	states = {
		int = 0, will = 0, chr = 0,
		str = 0, con = 0, dex = 0,
	},
	skills = {},
	abilities = {}
})

function player:draw(x,y,s)
	local x = x or (self.x - self.map.x) * map_setting.scale
	local y = y or (self.y - self.map.y - 1) * map_setting.scale
	local s = s or map_setting.scale
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill" , x , y , s , 2 * s )
end

function player:goTo(x,y,f)
	local path = pathfinder:path(self.map , math.floor(self.x),math.floor(self.y) , x,y)
	if #self.path == 0 then
		self.path = path
	else
		for i = 1 , math.max(#path , #self.path) do
			self.path[i + 1] = path[i]
		end
	end
	if f then self.path[#self.path + 1] = f end
end

function player:update(dt)
	if #self.path == 0 then return end
	if type(self.path[1]) == "function" then
		self.path[1](self)
		self.path[1] = nil
		return self:update(dt)
	else
		local d = 1 / math.sqrt( (self.path[1].x - self.tile.x) ^ 2 + (self.path[1].y - self.tile.y) ^ 2 )
		self.x = self.x + ( (self.path[1].x - self.tile.x) * dt * player_setting.speed * d )
		self.y = self.y + ( (self.path[1].y - self.tile.y) * dt * player_setting.speed * d )
		local cx = math.abs(self.x - self.tile.x) >= math.abs(self.path[1].x - self.tile.x)
		local cy = math.abs(self.y - self.tile.y) >= math.abs(self.path[1].y - self.tile.y)
		if cx and cy then
			self:setPos(self.path[1].x, self.path[1].y)
			table.remove(self.path , 1)
		end
	end
end

function player:setPos(x,y)
	self.map.playerMap[self.tile.x][self.tile.y] = nil
	self.x , self.y = x , y
	self.tile = self.map[x][y]
	self.map.playerMap[x][y] = self
	if self.tile.item then
		self.tile.item:pickUp( self )
	end
end

function player:getActions()
	local actions = {}
	actions["talk"] = function() love.open(talk , self) end
	return actions
end

function player:addAbility(a)
	a.player = self
	if a.folder then
		if not self.abilities[a.folder] then
			self.abilities[a.folder] = {}
		end
		self.abilities[a.folder][a.name] = a
	else
		self.abilities[a.name] = a
	end
end

function player:addHp(a)
	self.hp = self.hp + a
	if self.hp <= 0 then
		self.map:deletPlayer( self.x , self.y )
	end
end

npcs = {}

player_setting = {speed = 5 , file = "npcs"}