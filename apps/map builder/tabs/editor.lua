--set up

tabs.editor:addLayer("world" , 1)
editor.world:add( {} , "map" )
mouse.tile = {}

--menu

editor.ui:add( button:new({
	text = "tile", b_over = 0 , bu_over = 0, bodyColor_over = color.grey,
	y = var:new( function() return screen.height - 20 end ), x = 0,
	width = var:new( function() return screen.width / 5 end )
}) , "tile" )

editor.ui:add( button:new({
	text = "object", b_over = 0 , bu_over = 0, bodyColor_over = color.grey,
	y = var:new( function() return screen.height - 20 end ),
	x = var:new( function() return screen.width / 5 end ),
	width = var:new( function() return screen.width / 5 end )
}) , "object" )

editor.ui:add( button:new({
	text = "item", b_over = 0 , bu_over = 0, bodyColor_over = color.grey,
	y = var:new( function() return screen.height - 20 end ),
	x = var:new( function() return 2 * (screen.width / 5) end ),
	width = var:new( function() return screen.width / 5 end )
}) , "item" )

editor.ui:add( button:new({
	text = "players", b_over = 0 , bu_over = 0, bodyColor_over = color.grey,
	y = var:new( function() return screen.height - 20 end ),
	x = var:new( function() return 3 * (screen.width / 5) end ),
	width = var:new( function() return screen.width / 5 end )
}) , "players" )

editor.ui:add( button:new({
	text = "options", b_over = 0 , bu_over = 0, bodyColor_over = color.grey,
	y = var:new( function() return screen.height - 20 end ),
	x = var:new( function() return 4 * (screen.width / 5) end ),
	width = var:new( function() return screen.width / 5 end )
}) , "options" )

--world

editor.ui:add( {
	mousereleased = function(self,x,y,button)
		if not mouse.used and button == 1 then
			editor.map:setTile( tile:new({color = color.red}) , mouse.tile.sx,mouse.tile.sy , mouse.tile.ex,mouse.tile.ey )
		end
	end,
	mousemoved = function(self,x,y,dx,dy)
		mouse.tile.sx = math.floor(mouse.sx / map_setting.scale + editor.map.x)
		mouse.tile.sy = math.floor(mouse.sy / map_setting.scale + editor.map.y)
		mouse.tile.ex = math.floor(mouse.ex / map_setting.scale + editor.map.x)
		mouse.tile.ey = math.floor(mouse.ey / map_setting.scale + editor.map.y)
		if not mouse.used and love.mouse.isDown(2,3) then
			editor.map:move(dx,dy)
		end
	end
} , "manager")

--functions

function editor.open(map)
	editor.map = map
	editor.world.map = map
	editor.world[1] = map
end

function editor.draw( ... )
	love.graphics.setColor(0,0,255,100)
	local s = map_setting.scale
	if mouse.button == 1 then
		local sx = (math.floor( math.min(mouse.sx , mouse.ex) / s + editor.map.x) - editor.map.x) * s
		local sy = (math.floor( math.min(mouse.sy , mouse.ey) / s + editor.map.y) - editor.map.y) * s
		local ex = (math.floor( math.max(mouse.sx , mouse.ex) / s + editor.map.x) - editor.map.x) * s
		local ey = (math.floor( math.max(mouse.sy , mouse.ey) / s + editor.map.y) - editor.map.y) * s
		love.graphics.rectangle("fill" , sx , sy , ex - sx + s , ey - sy + s)
	else
		local x = ( math.floor( mouse.x / s + editor.map.x) - editor.map.x) * s
		local y = ( math.floor( mouse.y / s + editor.map.y) - editor.map.y) * s
		love.graphics.rectangle("fill" , x , y , s , s)
	end
end