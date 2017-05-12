menu.map = {width = 100 , height = 100}

--new map

menu.ui:add( ellement.menu:new({
	text = "new map", x = 5,
	width = var:new(function() return  (window.width / 3) - 10 end),
	y = var:new(function() return window.height - 25 end)
}) , "new_map" )

--new map name

menu.ui.new_map:addChild( ellement.textbox:new({
	y = 5, width = var:new(function() return 2 * (window.width / 3) - 10 end),
	x = var:new(function() return (window.width / 3) + 5 end),
	text_def = "name"
}) , "name" )

menu.ui.new_map.child.name:addCallback("keyreleased","update",function(self)
	menu.map.name = self.text
end)

--new map width

menu.ui.new_map:addChild( ui:new({
	x = var:new(function() return (window.width / 3) + 5 end), y = 30
}) , "width_text" )

menu.ui.new_map.child.width_text:addCallback("draw","text",function(self)
	love.graphics.setColor( color.white )
	local y = self.y + 10 -  love.graphics.getFont():getHeight()/2
	love.graphics.print("width:",self.x + 0,y)
end)

menu.ui.new_map:addChild( ellement.textbox:new({
	x = var:new( function(self)
		return self.x + love.graphics.getFont():getWidth("width: ") + 25
	end , menu.ui.new_map.child.width_text),
	text = tostring( menu.map.width ), y = 30, width = var:new( function(self) 
		return window.width - 30 - menu.ui.new_map.child.width.x
	end)
}) , "width")

menu.ui.new_map:addChild( button:new({
	text = "-", width = 20, func = function()
		menu.map.width = menu.map.width - 1
		menu.ui.new_map.child.width.text = tostring(menu.map.width)
	end , y = 30, x = var:new(function(self)
		return self.x + love.graphics.getFont():getWidth("width: ")
	end, menu.ui.new_map.child.width_text)
}) , "width_minus" )

menu.ui.new_map:addChild( button:new({
	text = "+", width = 20, func = function()
		menu.map.width = menu.map.width + 1
		menu.ui.new_map.child.width.text = tostring(menu.map.width)
	end , y = 30,
	x = var:new(function(self) return window.width - 25 end)
}) , "width_plus" )

--new map height

menu.ui.new_map:addChild( ui:new({
	x = var:new(function() return (window.width / 3) + 5 end), y = 55
}) , "height_text" )

menu.ui.new_map.child.height_text:addCallback("draw","text",function(self)
	love.graphics.setColor( color.white )
	local y = self.y + 10 -  love.graphics.getFont():getHeight()/2
	love.graphics.print("height:",self.x + 0,y)
end)

menu.ui.new_map:addChild( ellement.textbox:new({
	x = var:new( function(self)
		return self.x + love.graphics.getFont():getWidth("height: ") + 25
	end , menu.ui.new_map.child.height_text),
	text = tostring( menu.map.height ), y = 55, width = var:new( function(self) 
		return window.width - 30 - menu.ui.new_map.child.height.x
	end )
}) , "height")

menu.ui.new_map.child.height:addCallback("keyreleased","update",function(self)
	menu.map.height = tonumber(self.text)
end)

menu.ui.new_map:addChild( button:new({
	text = "-", width = 20, func = function()
		menu.map.height = menu.map.height - 1
		menu.ui.new_map.child.height.text = tostring(menu.map.height)
	end , y = 55, x = var:new(function(self)
		return self.x + love.graphics.getFont():getWidth("height: ")
	end, menu.ui.new_map.child.height_text)
}) , "height_minus" )

menu.ui.new_map:addChild( button:new({
	text = "+", width = 20, func = function()
		menu.map.height = menu.map.height + 1
		menu.ui.new_map.child.height.text = tostring(menu.map.height)
	end , y = 55,
	x = var:new(function(self) return window.width - 25 end)
}) , "height_plus" )

--save(not!) and open

menu.ui.new_map:addChild( button:new({
	text = "save and open", func = function() return menu.new() end,
	y = var:new(function() return window.height - 25 end),
	x = var:new(function(self) return window.width / 3 + 5 end),
	width = var:new(function() return 2 * (window.width / 3) - 10 end)
}) , "open" )

--new map backdrop

menu.ui.new_map:addChild( button:new({
	x = var:new(function() return window.width / 3 end) , y = 0,
	width = var:new(function() return (window.width / 3) * 2 end),
	height = var:new(function() return window.height end), b_over = 0,
	draw = {}
}) , "backdrop" )

--functions

function menu.new()
	if not menu.map.name then return end
	love.open( editor , map:new( menu.map ) )
end

function menu.draw()
	love.graphics.line(window.width / 3,5 , window.width / 3,window.height-5)
end