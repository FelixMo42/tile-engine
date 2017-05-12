tabs.editor:addLayer("world" , 1)

editor.ui:add( button:new({
	text = "tile", b_over = 0 , bu_over = 6,
	y = var:new( function() return window.height - 20 end ), x = 0,
	width = var:new( function() return window.width / 5 end )
}) , "tile" )

editor.ui:add( button:new({
	text = "object", b_over = 0 , bu_over = 6,
	y = var:new( function() return window.height - 20 end ),
	x = var:new( function() return window.width / 5 end ),
	width = var:new( function() return window.width / 5 end )
}) , "object" )

editor.ui:add( button:new({
	text = "item", b_over = 0 , bu_over = 6,
	y = var:new( function() return window.height - 20 end ),
	x = var:new( function() return 2 * (window.width / 5) end ),
	width = var:new( function() return window.width / 5 end )
}) , "item" )

editor.ui:add( button:new({
	text = "players", b_over = 0 , bu_over = 6,
	y = var:new( function() return window.height - 20 end ),
	x = var:new( function() return 3 * (window.width / 5) end ),
	width = var:new( function() return window.width / 5 end )
}) , "players" )

editor.ui:add( button:new({
	text = "options", b_over = 0 , bu_over = 6,
	y = var:new( function() return window.height - 20 end ),
	x = var:new( function() return 4 * (window.width / 5) end ),
	width = var:new( function() return window.width / 5 end )
}) , "options" )

function editor.open(map)
	editor.map = map
	editor.world:add( editor.map , "map" )
end

function editor.close()
	for k , v in pairs(editor.world) do
		editor.world[k] = nil
	end
end