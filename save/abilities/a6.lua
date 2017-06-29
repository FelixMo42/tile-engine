return ability:new({ name = "power attack",folder = "offensive",file = "a6",cost = 5,func = function(self,x,y)
	if not self.player.map[x][y].player then return end

	local s = math.random(0,self.aim) + self.player:getSkill("aim")
	local r = math.random(0,10) + self.player.map[x][y].player:getSkill("dodge" , 5)
	if s > r then return end

	local d = (self.player.inventory.primary or items.fist):damage() * 2
	d = d + self.player:getSkill("attack") - self.player.map[x][y].player:getSkill("defence",5)
	self.player.map[x][y].player:damage( d , self.player )
end })