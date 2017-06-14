--set up

ability.save = function(self) return "abilities."..self.file..":new()" end

skill.save = function(self) return "skills."..self.file..":new()" end

for k , v in pairs(abilities) do
	v.save = ability.save
end

for k , v in pairs(skills) do
	v.save = skill.save
end

--player

menu.ui:add( ellement.menu:new({
	text = "player", y = 5, x = 5,
	width = var:new( function() return screen.width / 2 - 7.5 end)
}) , "player" )

menu.ui.player:addChild( ui:new() , "players" )

local function player_setup()
	menu.ui.player.child.players.child = {active = true}
	for i , t in ipairs(players) do
		menu.ui.player.child.players:addChild( button:new({
			text = "  "..t.name, y = 10 + 25 * i, x = 5, textMode = "left", player = t,
			width = var:new(function() return screen.width / 4 * 3 - 5 end),
			func = function(self) love.open(player_editor,self.player) end
		}) , "npc_"..i )
		menu.ui.player.child.players:addChild( button:new({
			text = "delete", y = 10 + 25 * i, player = t, i = i,
			x = var:new(function() return screen.width / 4 * 3 + 5 end),
			width = var:new(function() return screen.width / 4 - 10 end),
			func = function(self)
				filesystem.delet( "players/"..self.player.file..".lua" )
				players[ self.player ] = nil
				players[ self.player.name ] = nil
				players[ self.player.file ] = nil
				players[ self.i ] = nil
				npc_setup()
			end
		}) , "npc_"..i.."_delete" )
	end
end

player_setup()

menu.ui.player:addChild( button:new({
	text = "new player", x = 5, y = var:new( function() return screen.height-25 end),
	width = var:new( function() return screen.width - 10 end),
	func = function() love.open(player_editor,player:new()) end
}) , "save" )

menu.ui.player:addChild( button:new({
	draw = {},x = 0,y = 30,width = 10000,height = 10000
}) , "bg")

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
			width = var:new(function() return screen.width / 4 * 3 - 5 end),
			func = function(self) love.open(npc_editor,self.npc) end
		}) , "npc_"..i )
		menu.ui.npc.child.npcs:addChild( button:new({
			text = "delete", y = 10 + 25 * i, npc = t, i = i,
			x = var:new(function() return screen.width / 4 * 3 + 5 end),
			width = var:new(function() return screen.width / 4 - 10 end),
			func = function(self)
				filesystem.delet( "npcs/"..self.npc.file..".lua" )
				npcs[ self.npc ] = nil
				npcs[ self.npc.name ] = nil
				npcs[ self.npc.file ] = nil
				npcs[ self.i ] = nil
				npc_setup()
			end
		}) , "npc_"..i.."_delete" )
	end
end

npc_setup()

menu.ui.npc:addChild( ellement.menu:new({
	text = "new npc", x = 5, y = var:new( function() return screen.height-25 end),
	width = var:new( function() return screen.width - 10 end),
	func = function() love.open(npc_editor,player:new()) end
}) , "save" )

menu.ui.npc:addChild( button:new({
	draw = {},x = 0,y = 30,width = 10000,height = 10000
}) , "bg")

--functions

function menu.draw()
	love.graphics.line(5,30 , screen.width-5,30)
	love.graphics.line(5,screen.height-30 , screen.width-5,screen.height-30)
end