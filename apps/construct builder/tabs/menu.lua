--tile

menu.ui:add( ellement.menu:new({
	text = "tile", y = 5, x = 5
}) , "tile" )

menu.ui.tile:addChild( button:new({
	text = "new tile",x = 5,y = screen.height - 25,width = screen.width - 10,
	func = function() love.open(tile_editor) end
}) , "new")

for i , t in ipairs(tiles) do
	menu.ui.tile:addChild(button:new({
		text = t.name, y = 10 + 25 * i, x = 5,width = var:new(function()
			return screen.width - 10
		end)
	}) , "tile_"..i )
end

menu.ui.tile:addChild( button:new({
	draw = {},x = 0,y = 30,width = 10000,height = 10000
}) , "bg")

--object

menu.ui:add( ellement.menu:new({
	text = "object", y = 5, x = 110
}) , "object" )

menu.ui.object:addChild( button:new({
	text = "new object",x = 5,y = screen.height - 25,width = screen.width - 10,
	func = function() love.open(tile_editor) end
}) , "new")

menu.ui.object:addChild( button:new({
	draw = {},x = 0,y = 30,width = 10000,height = 10000
}) , "bg")

--item

menu.ui:add( ellement.menu:new({
	text = "item", y = 5, x = 215
}) , "item" )

menu.ui.item:addChild( button:new({
	text = "new item",x = 5,y = screen.height - 25,width = screen.width - 10,
	func = function() love.open(tile_editor) end
}) , "new")

menu.ui.item:addChild( button:new({
	draw = {},x = 0,y = 30,width = 10000,height = 10000
}) , "bg")

--functions

function menu.draw()
	love.graphics.line(5,30 , screen.width - 5,30)
	love.graphics.line(5,screen.height - 30 , screen.width - 5,screen.height - 30)
end