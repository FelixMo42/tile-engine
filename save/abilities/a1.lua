return ability:new({ name = "attack",folder = "offensive",file = "a1",func = function(self,x,y)
	if not self.player.map[x][y].player then return end

	local s = math.random(0,20) + self.player:getSkill("aim")
	local r = math.random(0,10) + self.player.map[x][y].player:getSkill("dodge" , 5)
	if s > r then return end

	local d = (self.player.inventory.primary or items.fist):damage()
	d = d + self.player:getSkill("attack") - self.player.map[x][y].player:getSkill("defence",5)
	self.player.map[x][y].player:damage( d )
end })