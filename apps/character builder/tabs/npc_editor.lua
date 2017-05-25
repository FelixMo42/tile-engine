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
	func = function(self) filesystem.save(npc_editor.player) end,
	text = "save"
}) , "save" )

function npc_editor.open(p)
	npc_editor.player = p
	npc_editor.ui.name.text = p.name or ""
end

function npc_editor.draw()
	love.graphics.line(screen.width/2,5 , screen.width/2,screen.height-5)
end