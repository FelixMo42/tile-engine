return ability:new({name = "stone skin",folder = "defencive",file = "a5",range = 1,moves = 1,cost = 10,func = function(self,x,y)
	if not self.player.map[x][y].player then return end
	self.player.map[x][y].player:bonus("defence",5,10)
end})