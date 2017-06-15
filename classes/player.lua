player = class:new({
	type = "player",
	x = 1, y = 1,
	color = color.blue,
	path = {},
	mode = "npc",
	name = "def",
	dialog = {text = "hello"},
	inventory = {},
	states = {
		int = 0, wil = 0, chr = 0,
		str = 0, con = 0, dex = 0,
	},
	actions = {
		movement = 5, action = 1
	},
	skills = {},
	abilities = {}
})

function player:load(orig)
	self.maxHp = self.maxHp or self.hp or (self.states.con+1)*25
	self.hp = self.maxHp
	self.maxMana = self.maxMana or self.mana or (self.states.wil+1)*25
	self.mana = self.maxMana
	local a = self.abilities
	self.abilities = {}
	for k , v in pairs(a) do
		if type(v) == "table" then
			for k , v in pairs(v) do
				self:addAbility( v:new() )
			end
		else
			self:addAbility( v:new() )
		end
	end
end

function player:draw(x,y,s)
	local x = x or (self.x - self.map.x) * map_setting.scale
	local y = y or (self.y - self.map.y - 1) * map_setting.scale
	local s = s or map_setting.scale
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill" , x , y , s , 2 * s )
end

function player:update(dt)
	local function nt(self) if self.mode == "npc" and self == game.player then game.nextTurn() end end
	if #self.path == 0 then return nt(self) end
	--call function
	if type(self.path[1]) == "function" then
		self.path[1](self)
		table.remove(self.path , 1)
		return self:update(dt)
	end
	--move
	if self.actions.movement == 0 then return nt(self) end
	local d = 1 / math.sqrt( (self.path[1].x - self.tile.x) ^ 2 + (self.path[1].y - self.tile.y) ^ 2 )
	self.x = self.x + ( (self.path[1].x - self.tile.x) * dt * player_setting.speed * d )
	self.y = self.y + ( (self.path[1].y - self.tile.y) * dt * player_setting.speed * d )
	local cx = math.abs(self.x - self.tile.x) >= math.abs(self.path[1].x - self.tile.x)
	local cy = math.abs(self.y - self.tile.y) >= math.abs(self.path[1].y - self.tile.y)
	if cx and cy then
		self:setPos(self.path[1].x, self.path[1].y)
		table.remove(self.path , 1)
		self:use("movement")
	end
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

function player:setPos(x,y)
	self.map[self.tile.x][self.tile.y].player = nil
	self.map.playerMap[self.tile.x][self.tile.y] = nil
	self.map[x][y].player = self
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
	if (a.folder and self.abilities[a.folder] and self.abilities[a.folder][a.name]) or self.abilities[a.name] then
		return
	end
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

function player:damage(a)
	a = -math.max(a,0)
	self.hp = self.hp + a
	if self.hp <= 0 then
		self.map:deletPlayer( self.x , self.y )
		if game.initiative[self] then
			game.initiative[self] = nil
			for i , v in ipairs(game.initiative) do
				if v == self then
					table.remove( game.initiative , i )
					break
				end
			end
		end
		return
	end
	game.activate(self)
end

function player:turn()
	self.actions.action = 1
	self.actions.movement = 5
	for k , s in pairs(self.skills) do s:update() end
	if self.mode == "npc" then
		self.path = {}
		self:goTo( game.party.x , game.party.y , function(self)
			self.abilities.offensive.attack(game.party.x,game.party.y)
		end )
	elseif self.mode == "player" then
		if #game.initiative > 1 then
			game.ability = self.abilities.tactical.move
			self.path = {}
		end
	end
end

function player:use(t,a)
	a = a or 1
	self.actions[t] = self.actions[t] - 1
	local f = true
	for k , v in pairs( self.actions ) do
		if v ~= 0 then f = false end
	end
	if f or #game.initiative == 1 then
		game.nextTurn()
	end
end

function player:addSkill(s)
	if self.skills[s.name] then return s end
	s.player = self
	self.skills[s.name] = s
	self.skills[s.file] = s
	self.skills[#self.skills + 1] = s
	return s
end

function player:getSkill(s,xp)
	xp = xp or 10
	if not self.skills[s] then
		if skills[s] then
			self:addSkill( skills[s]:new() )
		else
			return 1
		end
	end
	self.skills[s]:addXP(xp)
	return self.skills[s]:getLevel()
end

local mt = getmetatable(player)

mt.__tostring = function(self)
	return self.mode.."s."..self.file..":new()"
end

npcs = {}
players = {}

player_setting = {speed = 5 , file = "npcs"}