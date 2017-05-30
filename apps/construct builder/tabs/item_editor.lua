--actions

item_editor.ui:add( ellement.textbox:new({
	x = var:new(function() return screen.width/2 + 5 end), y = 5,
	width = var:new(function() return screen.width/2 - 10 end),
	onEdit = function(self) item_editor.item.name = self.text end
}) , "name" )

item_editor.ui:add( button:new({
	text = "save", x = var:new(function() return screen.width/2 + 5 end),
	width = var:new(function() return screen.width/4 - 7.5 end),
	y = var:new(function() return screen.height - 25 end), func = function()
		filesystem.save( item_editor.item )
	end
}) , "save" )

item_editor.ui:add( button:new({
	text = "delet", x = var:new(function() return screen.width/4 * 3 + 2.5 end),
	width = var:new(function() return screen.width/4 - 7.5 end),
	y = var:new(function() return screen.height - 25 end)
}) , "delet" )

--states

item_editor.ui:add( ellement.textbox:new({
	x = 5, startText = "red: ", y = 5, filter = "0123456789",
	width = var:new(function() return screen.width / 2 - 10 end),
	onEdit = function(self)
		if #self.text > 0 then
			item_editor.item.color[1] = tonumber(self.text)
		else
			item_editor.item.color[1] = 0
		end
	end
}) , "red" )

item_editor.ui:add( ellement.textbox:new({
	x = 5, startText = "green: ", y = 30, filter = "0123456789",
	width = var:new(function() return screen.width / 2 - 10 end),
	onEdit = function(self)
		if #self.text > 0 then
			item_editor.item.color[2] = tonumber(self.text)
		else
			item_editor.item.color[2] = 0
		end
	end
}) , "green" )

item_editor.ui:add( ellement.textbox:new({
	x = 5, startText = "blue: ", y = 55, filter = "0123456789",
	width = var:new(function() return screen.width / 2 - 10 end),
	onEdit = function(self)
		if #self.text > 0 then
			item_editor.item.color[3] = tonumber(self.text)
		else
			item_editor.item.color[3] = 0
		end
	end
}) , "blue" )

item_editor.ui:add( ellement.textbox:new({
	x = 5, startText = "equipe slot: ", y = 80,
	width = var:new(function() return screen.width / 2 - 10 end),
	onEdit = function(self)
		if #self.text > 0 then
			item_editor.item.slot = self.text
		else
			item_editor.item.slot = item.slot
		end
	end
}) , "slot" )

--functions

function item_editor.open(t)
	item_editor.item = t or item:new({ color = {255,255,255} })
	--set values
	item_editor.ui.name.text = item_editor.item.name or ""
	item_editor.ui.red.text = tostring( item_editor.item.color[1] )
	item_editor.ui.green.text = tostring( item_editor.item.color[2] )
	item_editor.ui.blue.text = tostring( item_editor.item.color[3] )
	item_editor.ui.slot.text = item_editor.item.name or item.slot
end

function item_editor.draw()
	love.graphics.line(screen.width/2,5 , screen.width/2,screen.height-5)
	local d = 20
	local s = screen.width / 2 - d
	local x = screen.width / 2 + d / 2
	local y = screen.height / 2 - s / 2
	item_editor.item:draw(x , y , s)
end