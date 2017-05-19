--creat map buttons

for i , m in ipairs(maps) do
	menu.ui:add( button:new({
		text = m.name, map = m, y = i * 25 - 20, x = 5,
		width = var:new(function() return screen.width - 10 end),
		func = function(self) love.open(game , self.map) end
	}) )
end