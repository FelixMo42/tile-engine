--actions

tile_editor.ui:add( ellement.textbox:new({
	x = var:new(function() return screen.width/2 + 5 end), y = 5,
	width = var:new(function() return screen.width/2 - 10 end),
	onEdit = function(self) tile_editor.tile.name = self.text end
}) , "name" )

tile_editor.ui:add( button:new({
	text = "save", x = var:new(function() return screen.width/2 + 5 end),
	width = var:new(function() return screen.width/4 - 7.5 end),
	y = var:new(function() return screen.height - 25 end), func = function()
		filesystem.save( tile_editor.tile )
	end
}) , "save" )

tile_editor.ui:add( button:new({
	text = "delet", x = var:new(function() return screen.width/4 * 3 + 2.5 end),
	width = var:new(function() return screen.width/4 - 7.5 end),
	y = var:new(function() return screen.height - 25 end)
}) , "delet" )

--states

tile_editor.ui:add( ellement.textbox:new({
	x = 5, startText = "red: ", y = 5, filter = "0123456789",
	width = var:new(function() return screen.width / 2 - 10 end),
	onEdit = function(self)
		if #self.text > 0 then
			tile_editor.tile.color[1] = tonumber(self.text)
		else
			tile_editor.tile.color[1] = 0
		end
	end
}) , "red" )

tile_editor.ui:add( ellement.textbox:new({
	x = 5, startText = "green: ", y = 30, filter = "0123456789",
	width = var:new(function() return screen.width / 2 - 10 end),
	onEdit = function(self)
		if #self.text > 0 then
			tile_editor.tile.color[2] = tonumber(self.text)
		else
			tile_editor.tile.color[2] = 0
		end
	end
}) , "green" )

tile_editor.ui:add( ellement.textbox:new({
	x = 5, startText = "blue: ", y = 55, filter = "0123456789",
	width = var:new(function() return screen.width / 2 - 10 end),
	onEdit = function(self)
		if #self.text > 0 then
			tile_editor.tile.color[3] = tonumber(self.text)
		else
			tile_editor.tile.color[3] = 0
		end
	end
}) , "blue" )

--functions

function tile_editor.open(t)
	tile_editor.tile = t or tile:new({ color = {255,255,255} })
	--set values
	tile_editor.ui.name.text = tile_editor.tile.name or ""
	tile_editor.ui.red.text = tostring( tile_editor.tile.color[1] )
	tile_editor.ui.green.text = tostring( tile_editor.tile.color[2] )
	tile_editor.ui.blue.text = tostring( tile_editor.tile.color[3] )
end

function tile_editor.draw()
	love.graphics.line(screen.width/2,5 , screen.width/2,screen.height-5)
	local d = 20
	local s = screen.width / 2 - d
	local x = screen.width / 2 + d / 2
	local y = screen.height / 2 - s / 2
	tile_editor.tile:draw(x , y , s)
end