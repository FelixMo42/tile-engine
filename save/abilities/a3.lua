return ability:new({name = "end turn",folder = "tactical",file = "a3",range = -1,moves = 0,func = function(self,x,y)
	game.nextTurn()
end})