return ability:new({name = "fire bolt",folder = "offensive",file = "a4",range = 5,moves = 1,cost = 10,func = function(self,x,y)
	if not self.player.map[x][y].player then return end

	--[[local s = math.random(0,20) + self.player:getSkill("aim")
	local r = math.random(0,10) + self.player.map[x][y].player:getSkill("dodge" , 5)
	if s > r then return end]]

	local d = math.random(5,10)
	d = d + self.player:getSkill("pyromancy") - self.player.map[x][y].player:getSkill("defence",5)
	self.player.map[x][y].player:damage( d )
end})