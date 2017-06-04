return ability:new({name = "attack",folder = "fight",file = "a1",func = function(p,x,y)
	if game.map[x][y].player then
		game.map[x][y].player:addHp(-25)
	end
end})