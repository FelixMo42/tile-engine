--set up

tabs.game:addLayer("world" , 1)
game.world:add( {} , "map" )
game.initiative = {}
mouse.tile = {}
game.turn = 1

--ui

game.world:add( ui:new({x = 0 , y = 0}) , "actions")

game.world:add( button:new({
	text = "inventory", b_over = 0, bodyColor_over = color.grey,
	x = 100, func = function()
		if game.player.mode == "player" then
			love.open( inventory )
		end
	end
}) , "inventory")

game.world:add( button:new({
	text = "skills", b_over = 0, bodyColor_over = color.grey,
	x = 200, func = function()
		if game.player.mode == "player" then
			love.open( inventory , "skills" )
		end
	end
}) , "skills")

--moves

game.world:add( ellement.menu:new({
	text = "moves", b_over = 0, bodyColor_over = color.grey
}) , "move" )

game.moves_setup = function(ui , abilities , x)
	ui.child:clear()
	local y , x = 20 , x or 0
	for k , v in pairs(abilities) do
		if type(v) == "table" then
			local t = ui:addChild( ellement.menu:new({
				b_over = 0, bodyColor_over = color.grey,
				x = x, y = y, text = k
			}) )
			game.moves_setup(t , v , x + 100)
		else
			ui:addChild( button:new({
				b_over = 0, bodyColor_over = color.grey, a = v,
				x = x, y = y, text = v.name,func = function(self)
					game.ability = self.a
				end
			}) )
		end
		y = y + 20
	end
end

--info

game.world:add( ui:new({ draw = function(self)
	--bg
	love.graphics.setFont( font[11] )
	love.graphics.setColor( color.grey )
	love.graphics.rectangle("fill",-10,screen.height-45,170,50,5)
	love.graphics.setColor( color.black )
	love.graphics.rectangle("line",-10,screen.height-45,170,50,5)
	--mana
	love.graphics.setColor( color.blue )
	local mana = game.party.mana/game.party.maxMana*150
	love.graphics.rectangle("fill",5,screen.height-19,mana,15,5)
	love.graphics.setColor( color.black )
	love.graphics.rectangle("line",5,screen.height-19,150,15,5)
	love.graphics.prints( "Mana: "..game.party.mana.." / "..game.party.maxMana,5,screen.height-19,150,15)
	--hp
	love.graphics.setColor( color.red )
	local hp = game.party.hp/game.party.maxHp*150
	love.graphics.rectangle("fill",5,screen.height-39,hp,15,5)
	love.graphics.setColor( color.black )
	love.graphics.rectangle("line",5,screen.height-39,150,15,5)
	love.graphics.prints( "HP: "..game.party.hp.." / "..game.party.maxHp,5,screen.height-39,150,15)
	love.graphics.setFont( font[12] )
end }) , "party info")

game.world:add( ui:new({ draw = function(self)
	local text = ""
	text = text.."player: "..game.player.name.."\n"
	if game.player.mode == "player" then
		text = text.."main actions: "..game.player.actions.action.."\n"
		text = text.."movement actions: "..game.player.actions.movement.."\n"
		text = text.."curent ability: "..game.ability.name.."\n"
	end
	love.graphics.setColor( color.black )
	love.graphics.setFont( font[13] )
	love.graphics.prints(text,2 ,5,160,screen.height-50,"left","bottom")
	love.graphics.setFont( font[12] )
end }) , "player info")

--love functions

function game.open(map,player)
	if not map then return end
	--player
	player.x = map.spawn.x
	player.y = map.spawn.y
	game.activate( player )
	game.party = player
	game.player = player
	game.ability = game.party.abilities.tactical.move
	game.moves_setup( game.world.move , player.abilities )
	--map
	game.map = map
	game.world.map = map
	game.world[1] = map
	map:addPlayer( player )
	local px = player.x - (screen.width / map_setting.scale) / 2 + .5
	local py = player.y - (screen.height / map_setting.scale) / 2 + .5
	game.map:setPos( px , py )
end

function game.update(dt)
	local s = player_setting.speed -- speed in tiles per second
	local px = game.player.x - (screen.width / map_setting.scale) / 2 + .5
	local py = game.player.y - (screen.height / map_setting.scale) / 2 + .5
	local cx = game.map.x
	local cy = game.map.y
	game.map:setPos( math.approach(cx , px , s * dt) , math.approach(cy , py , s * dt) )
end

function game.mousemoved(x,y,dx,dy)
	mouse.tile.sx = math.floor(mouse.sx / map_setting.scale + game.map.x)
	mouse.tile.sy = math.floor(mouse.sy / map_setting.scale + game.map.y)
	mouse.tile.ex = math.floor(mouse.ex / map_setting.scale + game.map.x)
	mouse.tile.ey = math.floor(mouse.ey / map_setting.scale + game.map.y)
end

function game.mousepressed(x,y)
	if mouse.used then return end
	if game.player.mode ~= "player" then return end
	if mouse.button == 1 then
		local x , y = math.floor(mouse.tile.sx) , math.floor(mouse.tile.sy)
		game.ability(x , y)
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

function game.keyreleased(key)
	if game.player.mode == "player" then
		if key == "space" then
			game.ability = game.party.abilities.tactical.move
		elseif key == "return" then
			game.nextTurn()
		end
	end
end

--functions

function game.nextTurn()
	game.turn = math.loop( game.turn + 1 , #game.initiative )
	game.player = game.initiative[game.turn]
	game.player:turn()
end

function game.activate(p)
	if game.initiative[p] then return false end
	game.initiative[p] = p
	game.initiative[#game.initiative + 1] = p
	return true
end