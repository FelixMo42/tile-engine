--set up

menu.map = maps[filesystem:get("setting/map")]
menu.player = players[filesystem:get("setting/player")]

--maps and players

for i , m in ipairs(maps) do
	menu.ui:add( button:new({
		text = var:new( function(m)
			if menu.map and m.name == menu.map.name then
				return m.name.." √ "
			end
			return m.name 
		end , m , "string"), map = m, y = i * 25 - 20, x = 5,
		width = var:new(function() return screen.width / 2 - 10 end),
		func = function(self) menu.map = self.map end
	}) )
end

for i , p in ipairs(players) do
	menu.ui:add( button:new({
		text = var:new( function(p)
			if menu.player and p.name == menu.player.name then
				return p.name.." √ "
			end
			return p.name
		end , p , "string"), p.name, player = p, y = i * 25 - 20,
		x = var:new(function() return screen.width / 2 + 5 end),
		width = var:new(function() return screen.width / 2 - 10 end),
		func = function(self) menu.player = self.player end
	}) )
end

--ui

menu.ui:add( button:new({
	text = "set as default", width = var:new(function() return screen.width / 2 - 7.5 end),
	y = var:new(function() return screen.height - 50 end), x = 5,
	func = function(self)
		filesystem:write("setting/map",menu.map.file)
		filesystem:write("setting/player",menu.player.file)
	end
}) , "set")

menu.ui:add( button:new({
	text = "build", width = var:new(function() return screen.width / 2 - 7.5 end),
	y = var:new(function() return screen.height - 50 end),
	x = var:new(function() return screen.width / 2 + 2.5 end),
	func = function(self)
		filesystem:build("game")
	end
}) , "build")

menu.ui:add( button:new({
	text = "open", width = var:new(function() return screen.width - 10 end),
	y = var:new(function() return screen.height - 25 end), x = 5,
	func = function(self)
		if menu.map and menu.player then
			love.open(game , menu.map , menu.player)
		end
	end
}) , "new")

--function

function menu.draw()
	local b = 55
	love.graphics.line( screen.width/2,5 , screen.width/2,screen.height-b-5 )
	love.graphics.line( 5,screen.height-b , screen.width-5,screen.height-b )
end