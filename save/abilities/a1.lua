return ability:new({ name = "attack",folder = "offensive",file = "a1",func = function(self,x,y)
	if not self.player.map[x][y].player then return end
	local d = (self.player.inventory.primary or items.fist):damage()
	self.player.map[x][y].player:addHp( -d )
end })