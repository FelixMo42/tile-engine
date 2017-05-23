--actions

object_editor.ui:add( ellement.textbox:new({
	x = var:new(function() return screen.width/2 + 5 end), y = 5,
	width = var:new(function() return screen.width/2 - 10 end),
	onEdit = function(self) object_editor.object.name = self.text end
}) , "name" )

object_editor.ui:add( button:new({
	text = "save", x = var:new(function() return screen.width/2 + 5 end),
	width = var:new(function() return screen.width/4 - 7.5 end),
	y = var:new(function() return screen.height - 25 end), func = function()
		filesystem.save( object_editor.object )
	end
}) , "save" )

object_editor.ui:add( button:new({
	text = "delet", x = var:new(function() return screen.width/4 * 3 + 2.5 end),
	width = var:new(function() return screen.width/4 - 7.5 end),
	y = var:new(function() return screen.height - 25 end)
}) , "delet" )

--states

object_editor.ui:add( ellement.textbox:new({
	x = 5, startText = "red: ", y = 5, filter = "0123456789",
	width = var:new(function() return screen.width / 2 - 10 end),
	onEdit = function(self)
		if #self.text > 0 then
			object_editor.object.color[1] = tonumber(self.text)
		else
			object_editor.object.color[1] = 0
		end
	end
}) , "red" )

object_editor.ui:add( ellement.textbox:new({
	x = 5, startText = "green: ", y = 30, filter = "0123456789",
	width = var:new(function() return screen.width / 2 - 10 end),
	onEdit = function(self)
		if #self.text > 0 then
			object_editor.object.color[2] = tonumber(self.text)
		else
			object_editor.object.color[2] = 0
		end
	end
}) , "green" )

object_editor.ui:add( ellement.textbox:new({
	x = 5, startText = "blue: ", y = 55, filter = "0123456789",
	width = var:new(function() return screen.width / 2 - 10 end),
	onEdit = function(self)
		if #self.text > 0 then
			object_editor.object.color[3] = tonumber(self.text)
		else
			object_editor.object.color[3] = 0
		end
	end
}) , "blue" )

object_editor.ui:add( button:new({
	x = 5, text = "walkable: ", y = 80,
	width = var:new(function() return screen.width / 2 - 10 end),
	func = function(self)
		object_editor.object.walkable = not object_editor.object.walkable
		self.text = "walkable: "..tostring(object_editor.object.walkable)
	end
}) , "walkable" )

--functions

function object_editor.open(t)
	object_editor.object = t or object:new({ color = {255,255,255} })
	--set values
	object_editor.ui.name.text = object_editor.object.name or ""
	object_editor.ui.red.text = tostring( object_editor.object.color[1] )
	object_editor.ui.green.text = tostring( object_editor.object.color[2] )
	object_editor.ui.blue.text = tostring( object_editor.object.color[3] )
	object_editor.ui.walkable.text = "walkable: "..tostring(object_editor.object.walkable)
end

function object_editor.draw()
	love.graphics.line(screen.width/2,5 , screen.width/2,screen.height-5)
	local d = 20
	local s = screen.width / 2 - d
	local x = screen.width / 2 + d / 2
	local y = screen.height / 2 - s / 2
	object_editor.object:draw(x , y , s)
end