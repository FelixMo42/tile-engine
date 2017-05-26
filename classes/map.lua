map = class:new({
	type = "map",
	width = 100, height = 100,
	x = 1, y = 1,
	playerMap = {},
	players = {},
	spawn = {x = 1,y = 1}
})

function map:load()
	--setup
	self:setScale( map_setting.scale )
	--tiles
	for x = 1 , self.width do
		self[x] = self[x] or {}
		for y = 1 , self.height do
			self[x][y] = self[x][y] or (self.defTile or tile):new()
			self[x][y].x , self[x][y].y = x , y
			self[x][y].map = self
		end
	end
	--player map
	for x = 1 , self.width do
		self.playerMap[x] = self.playerMap[x] or {}
	end
	for k , p in ipairs(self.players) do
		self[p.x][p.y].player = p
		p.map = self
		p.tile = self[p.x][p.y]
		self.playerMap[p.x][p.y] = p
		self.players[p] = p
		self.players[k] = nil
	end
end

function map:draw()
	--tiles
	sx = math.max( math.floor(self.x) , 1)
	ex = math.min( math.floor( self.x + screen.width / map_setting.scale ) , self.width)
	sy = math.max( math.floor(self.y) , 1 ) 
	ey = math.min( math.floor( self.y + screen.height / map_setting.scale ) , self.height)
	for y = sy , ey do
		for x = sx , ex do
			self[x][y]:draw()
		end
	end
	--players
	for y = sy , ey do
		for x = sx , ex do
			if self.playerMap[x][y] then
				self.playerMap[x][y]:draw()
			end
		end
	end
end

function map:update(dt)
	for k , p in pairs(self.players) do
		p:update(dt)
	end
end

function map:resize(w,h)
	self:setScale(map_setting.scale)
end

function map:setScale(s)
	local minZoom = math.max(screen.height / self.height , screen.width / self.width , map_setting.minZoom )
	local maxZoom = math.min(screen.height , screen.width , map_setting.maxZoom)
	s = math.clamp(s,minZoom,maxZoom)
	self:setPos(self.x+((screen.width/map_setting.scale)-(screen.width/s))/2 ,  self.y+((screen.width/map_setting.scale)-(screen.width/s))/2)
	map_setting.scale = s
end

function map:move(dx,dy)
	if love.mouse.isDown(2, 3) then
		self:setPos(self.x-(dx/map_setting.scale) , self.y-(dy/map_setting.scale))
	end
end

function map:setPos(x,y)
	if x then
		if map_setting.clamp then
			self.x = math.clamp(x , 1 , self.width - screen.width / map_setting.scale + 1)
		else
			self.x = x
		end
	end
	if y then
		if map_setting.clamp then
			self.y = math.clamp(y , 1 , self.height - screen.height / map_setting.scale + 1)
		else
			self.y = y
		end
	end
end

function map:setTile(t,sx,sy,ex,ey)
	ex , ey = ex or sx , ey or sy
	for x = sx , ex , math.sign(ex - sx) == 0 and 1 or math.sign(ex - sx) do
		for y = sy , ey , math.sign(ey - sy) == 0 and 1 or math.sign(ey - sy) do
			self[x][y] = t:new()
			self[x][y].map = self
			self[x][y].x = x
			self[x][y].y = y
		end
	end
end

function map:setObject(o,sx,sy,ex,ey)
	ex , ey = ex or sx , ey or sy
	for x = sx , ex , math.sign(ex - sx) == 0 and 1 or math.sign(ex - sx) do
		for y = sy , ey , math.sign(ey - sy) == 0 and 1 or math.sign(ey - sy) do
			self[x][y]:setObject( o:new() )
		end
	end
end

function map:setPlayer(p,sx,sy,ex,ey)
	ex , ey = ex or sx , ey or sy
	for x = sx , ex , math.sign(ex - sx) == 0 and 1 or math.sign(ex - sx) do
		for y = sy , ey , math.sign(ey - sy) == 0 and 1 or math.sign(ey - sy) do
			self:addPlayer( p:new({x = x,y = y}) )
		end
	end
end

function map:deletPlayer(sx,sy,ex,ey)
	ex , ey = ex or sx , ey or sy
	for x = sx , ex , math.sign(ex - sx) == 0 and 1 or math.sign(ex - sx) do
		for y = sy , ey , math.sign(ey - sy) == 0 and 1 or math.sign(ey - sy) do
			if self.playerMap[x][y] then
				self.players[self.playerMap[x][y]] = nil
				self[x][y].player = nil
				self.playerMap[x][y] = nil
			end
		end
	end
end

function map:deletObject(sx,sy,ex,ey)
	ex , ey = ex or sx , ey or sy
	for x = sx , ex , math.sign(ex - sx) == 0 and 1 or math.sign(ex - sx) do
		for y = sy , ey , math.sign(ey - sy) == 0 and 1 or math.sign(ey - sy) do
			if self[x][y].object then
				self[x][y].object = nil
			end
		end
	end
end

function map:addPlayer(p)
	p = p or player:new()
	self.players[p] = p
	p.map = self
	p.tile = self[p.x][p.y]
	self.playerMap[p.x][p.y] = p
	self[p.x][p.y].player = p
	return p
end

function map:saveTile(x,y)
	local s = "tiles."..self[x][y].file..":new({"
		if self[x][y].object then
			s = s.."object = objects."..self[x][y].object.file
		end
	return s.."}),"
end

function map:save()
	local s = "map:new({"
	for k , v in pairs(self) do
		if rawtype(v) ~= "table" and v ~= map[k] and type(k) == "string" then
			if type(v) == "string" then
				s = s..k.." = \""..v.."\","
			else
				s = s..k.." = "..v..","
			end
		end
	end
	for x = 1 , self.width do
		s = s.."{"
		for y = 1 , self.height do
			if self[x][y].file then
				s = s.."["..y.."] = "..self:saveTile(x,y)
			end
		end
		s = s.."},\n"
	end
	s = s.."players = {"
	for k , p in pairs(self.players) do
		s = s.."npcs."..p.file..":new({x = "..p.x..",y = "..p.y.."}),"
	end
	s = s.."},\n"
	s = s.."spawn = {x = "..self.spawn.x..",y = "..self.spawn.y.."}"
	return s.."})"
end

local mt = getmetatable(map)

mt.__rawget = function(self , key)
	if defrawget(self,key) then
		return defrawget(self,key)
	elseif type(key) == "number" then
		return {}
	end
end

maps = {}

map_setting = {
	scale = 60 , minZoom = 10 , maxZoom = 100,
	line = true , clamp = true
}