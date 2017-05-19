map = class:new({
	type = "map",
	width = 100, height = 100,
	x = 1, y = 1,
	playerMap = {},
	players = {}
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
	for k , p in pairs(self.players) do
		p.map = self
		p.tile = self[p.x][p.y]
		self.playerMap[p.x][p.y] = p
	end
end

function map:draw()
	--tiles
	sx = math.max( math.floor(self.x) , 1)
	ex = math.min( math.floor( self.x + screen.width / map_setting.scale ) , self.width)
	sy = math.max( math.floor(self.y) , 1 ) 
	ey = math.min( math.floor( self.y + screen.height / map_setting.scale ) , self.height)
	for x = sx , ex do
		for y = sy , ey do
			self[x][y]:draw()
		end
	end
	--players
	for x = sx , ex do
		for y = sy , ey do
			if self.playerMap[x][y] then
				self.playerMap[x][y]:draw()
			end
		end
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

function map:addPlayer(p)
	p = p or player:new()
	self.players[#self.players] = p
	p.map = self
	p.tile = self[p.x][p.y]
	self.playerMap[p.x][p.y] = p
	return p
end

function map:save()
	local s = "map:new({width = "..self.width..",height = "..self.width..","
	s = s.."file = \""..self.file.."\"," 
	for x = 1 , self.width do
		s = s.."{"
		for y = 1 , self.height do
			if self[x][y].file then
				s = s.."["..y.."] = tiles."..self[x][y].file..":new(),"
			end
		end
		s = s.."},\n"
	end
	return s.."name = \""..self.name.."\"})"
end

maps = {}

map_setting = {
	scale = 60 , minZoom = 10 , maxZoom = 100,
	line = true , clamp = true
}