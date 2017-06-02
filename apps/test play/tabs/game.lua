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
}) , "save")

game.world:add( ui:new({x = 0 , y = 0}) , "actions")

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
	if mouse.used then return end
	if mouse.button == 1 then
		local x , y = math.floor(mouse.tile.sx) , math.floor(mouse.tile.sy)
		game.player:goTo(x , y)
	elseif mouse.button == 2 then
		game.world.actions.child:clear()
		local actions = game.map[mouse.tile.sx][mouse.tile.sy]:getActions()
		local i = 1
		local x = (mouse.tile.sx - game.map.x + .9) * map_setting.scale
		local y = (mouse.tile.sy - game.map.y + .5) * map_setting.scale
		for k , v in pairs(actions) do
			game.world.actions:addChild( button:new({
				text = k, x = x, y = y - i * 20 + table.count(actions) * 10,
				tx = mouse.tile.sx, ty = mouse.tile.sy, f = v,
				b_over = 0, bodyColor_over = color.grey, func = function(self)
					game.player:goTo(self.tx , self.ty , self.f)
				end
			}) )
			i = i + 1
		end
		game.world.actions:addChild( ui:new() , "delet" )
		local f = lambda:new(game.world.actions.child.clear , game.world.actions.child)
		game.world.actions.child.delet:addCallback( "mousereleased" , "clear" , function()
			game.world.actions.child.delet.mousereleased.clear = f
		end )
	end
end