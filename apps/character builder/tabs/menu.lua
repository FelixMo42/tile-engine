--player

menu.ui:add( ellement.menu:new({
	text = "player", y = 5, x = 5,
	width = var:new( function() return screen.width / 2 - 7.5 end)
}) , "player" )

--npc

menu.ui:add( ellement.menu:new({
	text = "npc", y = 5, x = var:new( function() return screen.width/2 + 2.5 end),
	width = var:new( function() return screen.width / 2 - 7.5 end)
}) , "npc" )

menu.ui.npc:addChild( ui:new() , "npcs" )

local function npc_setup()
	menu.ui.npc.child.npcs.child = {active = true}
	for i , t in ipairs(npcs) do
		menu.ui.npc.child.npcs:addChild( button:new({
			text = "  "..t.name, y = 10 + 25 * i, x = 5, textMode = "left", npc = t,
			width = var:new(function() return screen.width / 8 * 3 - 5 end),
			func = function(self) love.open(npc_editor,self.npc) end
		}) , "npc_"..i )
		menu.ui.npc.child.npcs:addChild( button:new({
			text = "delet", y = 10 + 25 * i, npc = t, i = i,
			x = var:new(function() return screen.width / 8 * 3 + 5 end),
			width = var:new(function() return screen.width / 8 - 10 end),
			func = function(self)
				filesystem.delet( "npcs/"..self.npc.file..".lua" )
				npcs[ self.npc ] = nil
				npcs[ self.npc.name ] = nil
				npcs[ self.npc.file ] = nil
				npcs[ self.i ] = nil
				npc_setup()
			end
		}) , "npc_"..i.."_delet" )
	end
end

npc_setup()

menu.ui.npc:addChild( ellement.menu:new({
	text = "new npc", x = 5, y = var:new( function() return screen.height-25 end),
	width = var:new( function() return screen.width / 2 - 10 end)
}) , "new" )

menu.ui.npc.child.new:addChild( button:new({
	text = "save and open", y = var:new( function() return screen.height-25 end),
	x = var:new( function() return screen.width/2 + 5 end),
	width = var:new( function() return screen.width / 2 - 10 end),
	func = function() love.open(npc_editor,player:new()) end
}) , "save" )

menu.ui.npc:addChild( button:new({
	draw = {},x = 0,y = 30,width = 10000,height = 10000
}) , "bg")

--functions

function menu.draw()
	love.graphics.line(5,30 , screen.width-5,30)
	love.graphics.line(screen.width/2,35 , screen.width/2,screen.height-5)
end