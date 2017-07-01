tile_editor.ui:add( ellement.textbox:new({
	startText = " map: ", x = 5 , y = 5, textMode = "left",
	width = var:new(function() return screen.width - 10 end),
	onEdit = function(self)
		if maps[self.text] then
			tile_editor.tile.spawn = self.text
		else
			tile_editor.tile.spawn = nil
		end
	end
}) , "map" )

tile_editor.ui:add( button:new({
	text = "back", x = 5 , y = var:new(function() return screen.height - 25 end),
	width = var:new(function() return screen.width - 10 end),
	func = function() love.open( editor ) end
}) , "back" )

function tile_editor.open(tile)
	if not tile then return end
	tile_editor.tile = tile
	if tile_editor.tile.spawn then
		tile_editor.ui.map.text = maps[tile_editor.tile.spawn].name
	end
end