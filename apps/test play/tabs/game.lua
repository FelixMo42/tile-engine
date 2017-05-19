--set up

tabs.game:addLayer("world" , 1)
game.world:add( {} , "map" )
mouse.tile = {}
game.player = player:new()

--functions

function game.open(map)
	game.map = map
	game.world.map = map
	game.world[1] = map
	map:addPlayer( game.player )
end

function game.mousemoved(x,y,dx,dy)
	mouse.tile.sx = math.floor(mouse.sx / map_setting.scale + game.map.x)
	mouse.tile.sy = math.floor(mouse.sy / map_setting.scale + game.map.y)
	mouse.tile.ex = math.floor(mouse.ex / map_setting.scale + game.map.x)
	mouse.tile.ey = math.floor(mouse.ey / map_setting.scale + game.map.y)
end

function game.mousepressed(x,y)
	local x , y = math.floor(mouse.tile.sx) , math.floor(mouse.tile.sy)
	game.player:setPos(x , y)
	game.map:setPos(x - (screen.width / map_setting.scale) / 2, y - (screen.height / map_setting.scale) / 2)
end