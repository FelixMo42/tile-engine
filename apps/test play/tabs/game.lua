--set up

tabs.game:addLayer("world" , 1)
game.world:add( {} , "map" )
mouse.tile = {}
game.player = player:new()

--ui

game.world:add( button:new({
	text = "inventory", b_over = 0, bodyColor_over = color.grey,
	x = var:new( function() return screen.width - 100 end ),
	func = function() love.open( inventory ) end
}) , 2 , "save")

--functions

function game.open(map)
	if map then
		game.map = map
		game.world.map = map
		game.world[1] = map
		game.player.x = map.spawn.x
		game.player.y = map.spawn.y
		map:addPlayer( game.player )
	end
end

function game.update()
	local x = game.player.x - (screen.width / map_setting.scale) / 2
	local y = game.player.y - (screen.height / map_setting.scale) / 2
	game.map:setPos(x + .5, y + .5)
end

function game.mousemoved(x,y,dx,dy)
	mouse.tile.sx = math.floor(mouse.sx / map_setting.scale + game.map.x)
	mouse.tile.sy = math.floor(mouse.sy / map_setting.scale + game.map.y)
	mouse.tile.ex = math.floor(mouse.ex / map_setting.scale + game.map.x)
	mouse.tile.ey = math.floor(mouse.ey / map_setting.scale + game.map.y)
end

function game.mousepressed(x,y)
	if not mouse.used then
		local x , y = math.floor(mouse.tile.sx) , math.floor(mouse.tile.sy)
		game.player:goTo(x , y)
	end
end