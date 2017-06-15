--actions

npc_editor.ui:add( ellement.textbox:new({
	x = var:new( function() return screen.width/2 + 5 end ), y = 5,
	width = var:new( function() return screen.width/2 - 10 end ),
	onEdit = function(self) npc_editor.player.name = self.text end,
	startText = "name: "
}) , "name" )

npc_editor.ui:add( button:new({
	x = var:new( function() return screen.width/2 + 5 end ),
	y = var:new( function() return screen.height - 25 end ),
	width = var:new( function() return screen.width/2 - 10 end ),
	func = function(self) filesystem:saveClass(npc_editor.player) end,
	text = "save"
}) , "save" )

--values

npc_editor.ui:add( ellement.textbox:new({
	x = 5, y = 5, filter = "0123456789", startText = "red: ",
	width = var:new( function() return screen.width/2 - 10 end ),
	onEdit = function(self) npc_editor.player.color[1] = tonumber(self.text) or 0 end
}) , "red" )

npc_editor.ui:add( ellement.textbox:new({
	x = 5, y = 30, filter = "0123456789",
	width = var:new( function() return screen.width/2 - 10 end ),
	onEdit = function(self) npc_editor.player.color[2] = tonumber(self.text) or 0 end,
	startText = "green: "
}) , "green" )

npc_editor.ui:add( ellement.textbox:new({
	x = 5, y = 55, filter = "0123456789", startText = "blue: ",
	width = var:new( function() return screen.width/2 - 10 end ),
	onEdit = function(self) npc_editor.player.color[3] = tonumber(self.text) or 0 end
}) , "blue" )

npc_editor.ui:add( button:new({
	x = 5, y = 80, text = "dialog",
	width = var:new( function() return screen.width/2 - 10 end ),
	func = function(self) love.open( dialog ) end
}) , "dialog" )

--functions

function npc_editor.open(p)
	if p then
		npc_editor.player = p
		npc_editor.ui.name.text = p.name or ""
		npc_editor.ui.red.text = tostring(p.color[1])
		npc_editor.ui.green.text = tostring(p.color[2])
		npc_editor.ui.blue.text = tostring(p.color[3])
	end
end

function npc_editor.draw()
	love.graphics.line(screen.width/2,5 , screen.width/2,screen.height-5)
	local s = math.min(screen.height-60,screen.width/2-60)
	npc_editor.player:draw(screen.width/2+30,30,s)
end