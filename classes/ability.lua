ability = class:new({
	type = "ability",
	cost = 0,
	range = 1,
	moveType = "action",
	moves = 1
})

function ability:save()
	
end

local mt = getmetatable(ability)

mt.__call = function(self,x,y)
	--cheak it
	if not self.player then return end
	if self.player.mana < self.cost then return end
	--range
	if self.range > 0 then
		local o,d = pathfinder:line(self.player.map,self.player.tile.x,self.player.tile.y,x,y,true)
		if not o or d > self.range then return end
	elseif self.range == 0 then
		if not self.map[x][y].player == self.player then return end
	end
	--actions
	if self.moves > 0 then
		if self.player.actions[self.moveType] < self.moves then
			return
		end
		self.player:use(self.moveType,self.moves)
	end
	--do it
	self.player.mana = self.player.mana - self.cost
	self:func(x,y)
end

mt.__tostring = function(self)
	return "abilities."..self.file..":new()"
end

abilities = {}

ability_setting = {file = "abilities"}