--ui

for i , m in ipairs(maps) do
	menu.ui:add( button:new({
		text = m.name, map = m, y = i * 25 - 20, x = 5,
		width = var:new(function() return screen.width / 2 - 10 end),
		func = function(self) menu.map = self.map end
	}) )
end

for i , p in ipairs(players) do
	menu.ui:add( button:new({
		text = p.name, player = p, y = i * 25 - 20,
		x = var:new(function() return screen.width / 2 + 5 end),
		width = var:new(function() return screen.width / 2 - 10 end),
		func = function(self) menu.player = self.player end
	}) )
end

menu.ui:add( button:new({
	text = "open", width = var:new(function() return screen.width - 10 end),
	y = var:new(function() return screen.height - 25 end), x = 5,
	func = function(self)
		if menu.map and menu.player then
			love.open(game , menu.map , menu.player)
		end
	end
}) )

--function

function menu.draw()
	love.graphics.line( screen.width/2,5 , screen.width/2,screen.height-35 )
	love.graphics.line( 5,screen.height-30 , screen.width-5,screen.height-30 )
end