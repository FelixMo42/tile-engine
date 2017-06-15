--set up

tabs.editor:addLayer("world" , 1)
editor.world:add( {} , "map" )
editor.mode = ""
mouse.tile = {}

--tile

editor.ui:add( ellement.menu:new({
	text = "tile", b_over = 0 , bu_over = 0, bodyColor_over = color.grey,
	y = var:new( function() return screen.height - 20 end ), x = 0,
	width = var:new( function() return screen.width / 5 end ),
	func = function() editor.reset("tile") end
}) , "tile" )

editor.ui.tile:addChild( ellement.menu:new({
	text = "tiles" , b_over = 0 , bodyColor_over = color.grey,
}) , "tiles" )

for i , t in ipairs( tiles ) do
	editor.ui.tile.child.tiles:addChild( button:new({
		text = t.name, tile = t, y = 20 * i, func = function(self)
			editor.ui.tile.child.tiles.text = self.tile.name
			editor.selected = self.tile
		end
	}) )
end

--object

editor.ui:add( ellement.menu:new({
	text = "object", b_over = 0 , bu_over = 0, bodyColor_over = color.grey,
	y = var:new( function() return screen.height - 20 end ),
	x = var:new( function() return screen.width / 5 end ),
	width = var:new( function() return screen.width / 5 end ),
	func = function() editor.reset("object") end
}) , "object" )

editor.ui.object:addChild( ellement.menu:new({
	text = "objects" , b_over = 0 , bodyColor_over = color.grey,
}) , "objects" )

for i , o in ipairs( objects ) do
	editor.ui.object.child.objects:addChild( button:new({
		text = o.name, object = o, y = 20 * i, func = function(self)
			editor.ui.object.child.objects.text = self.object.name
			editor.selected = self.object
		end
	}) )
end

editor.ui.object:addChild( ellement.menu:new({
	text = "delet" , b_over = 0 , bodyColor_over = color.grey, x = 100,
	func = function() editor.selected = "delet" end
}) , "delet" )

--item

editor.ui:add( ellement.menu:new({
	text = "item", b_over = 0 , bu_over = 0, bodyColor_over = color.grey,
	y = var:new( function() return screen.height - 20 end ),
	x = var:new( function() return 2 * (screen.width / 5) end ),
	width = var:new( function() return screen.width / 5 end ),
	func = function() editor.reset("item") end
}) , "item" )

editor.ui.item:addChild( ellement.menu:new({
	text = "items" , b_over = 0 , bodyColor_over = color.grey,
}) , "items" )

for i , o in ipairs( items ) do
	editor.ui.item.child.items:addChild( button:new({
		text = o.name, item = o, y = 20 * i, func = function(self)
			editor.ui.item.child.items.text = self.item.name
			editor.selected = self.item
		end
	}) )
end

editor.ui.item:addChild( ellement.menu:new({
	text = "delet" , b_over = 0 , bodyColor_over = color.grey, x = 100,
	func = function() editor.selected = "delet" end
}) , "delet" )

--players

editor.ui:add( ellement.menu:new({
	text = "players", b_over = 0 , bodyColor_over = color.grey,
	y = var:new( function() return screen.height - 20 end ),
	x = var:new( function() return 3 * (screen.width / 5) end ),
	width = var:new( function() return screen.width / 5 end ),
	func = function() editor.reset("players") end
}) , "players" )

editor.ui.players:addChild( ellement.menu:new({
	text = "npc", b_over = 0 , bodyColor_over = color.grey
}) , "npc" )

for i , n in ipairs( npcs ) do
	editor.ui.players.child.npc:addChild( button:new({
		text = n.name, npc = n, y = 20 * i, func = function(self)
			editor.selected = self.npc
		end
	}) )
end

editor.ui.players:addChild( button:new({
	text = "delet", b_over = 0 , bodyColor_over = color.grey,
	func = function() editor.selected = "delet" end,x = 100
}) , "delet")

editor.ui.players:addChild( button:new({
	text = "spawn", b_over = 0 , bodyColor_over = color.grey,
	func = function() editor.selected = "spawn" end,x = 200
}) , "spawn")

--options

editor.ui:add( ellement.menu:new({
	text = "options", b_over = 0 , bu_over = 0, bodyColor_over = color.grey,
	y = var:new( function() return screen.height - 20 end ),
	x = var:new( function() return 4 * (screen.width / 5) end ),
	width = var:new( function() return screen.width / 5 end ),
	func = function() editor.reset("options") end
}) , "options" )

editor.ui.options:addChild( button:new({
	text = "save", b_over = 0, bodyColor_over = color.grey,
	func = function() filesystem:saveClass( editor.map ) end
}) , "save")

--world

local function onClick()
	if editor.mode == "tile" then
		if editor.selected then
			editor.map:setTile(editor.selected,mouse.tile.sx,mouse.tile.sy,mouse.tile.ex,mouse.tile.ey)
		end
	elseif editor.mode == "object" then
		if editor.selected == "delet" then
			editor.map:deletObject(mouse.tile.sx,mouse.tile.sy,mouse.tile.ex,mouse.tile.ey)
		elseif editor.selected then
			editor.map:setObject(editor.selected,mouse.tile.sx,mouse.tile.sy,mouse.tile.ex,mouse.tile.ey)
		end
	elseif editor.mode == "item" then
		if editor.selected == "delet" then
			editor.map:deletItem(mouse.tile.sx,mouse.tile.sy,mouse.tile.ex,mouse.tile.ey)
		elseif editor.selected then
			editor.map:setItem(editor.selected,mouse.tile.sx,mouse.tile.sy,mouse.tile.ex,mouse.tile.ey)
		end
	elseif editor.mode == "players" then
		if editor.selected == "spawn" then
			editor.map.spawn.x = mouse.tile.sx
			editor.map.spawn.y = mouse.tile.sy
		elseif editor.selected == "delet" then
			editor.map:deletPlayer(mouse.tile.sx,mouse.tile.sy,mouse.tile.ex,mouse.tile.ey)
		elseif editor.selected then
			editor.map:setPlayer(editor.selected,mouse.tile.sx,mouse.tile.sy,mouse.tile.ex,mouse.tile.ey)
		end
	end
end

editor.ui:add( {
	mousereleased = function(self,x,y,button)
		if not mouse.used and button == 1 then onClick() end
	end,
	wheelmoved = function(self,x,y)
		editor.map:setScale(map_setting.scale + y)
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

function editor.reset(name)
	editor.mode = name
	editor.selected = nil
end

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