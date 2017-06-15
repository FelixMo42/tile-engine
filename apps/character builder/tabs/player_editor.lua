--actions

player_editor.ui:add( ellement.textbox:new({
	x = var:new( function() return screen.width/2 + 5 end ), y = 5,
	width = var:new( function() return screen.width/2 - 10 end ),
	onEdit = function(self) player_editor.player.name = self.text end,
	startText = "name: "
}) , "name" )

player_editor.ui:add( button:new({
	x = var:new( function() return screen.width/2 + 5 end ),
	y = var:new( function() return screen.height - 25 end ),
	width = var:new( function() return screen.width/2 - 10 end ),
	func = function(self) filesystem:saveClass(player_editor.player) end,
	text = "save"
}) , "save" )

--color

player_editor.ui:add( ellement.textbox:new({
	x = 5, y = 5, filter = "0123456789", startText = "red: ",
	width = var:new( function() return screen.width/2 - 10 end ),
	onEdit = function(self) player_editor.player.color[1] = tonumber(self.text) or 0 end
}) , "red" )

player_editor.ui:add( ellement.textbox:new({
	x = 5, y = 30, filter = "0123456789",
	width = var:new( function() return screen.width/2 - 10 end ),
	onEdit = function(self) player_editor.player.color[2] = tonumber(self.text) or 0 end,
	startText = "green: "
}) , "green" )

player_editor.ui:add( ellement.textbox:new({
	x = 5, y = 55, filter = "0123456789", startText = "blue: ",
	width = var:new( function() return screen.width/2 - 10 end ),
	onEdit = function(self) player_editor.player.color[3] = tonumber(self.text) or 0 end
}) , "blue" )

--abilites

player_editor.ui:add( ellement.textbox:new({
	x = 5, startText = "ability: ", y = 80,
	width = var:new(function() return screen.width / 2 - 60 end),
}) , "abilities" )

player_editor.ui.abilities:addChild( button:new({
	x = var:new(function() return screen.width / 2 - 25 end),
	text = "+", y = 80, width = 20, func = function(self)
		player_editor.player.abilities[ abilities[self.parent.text].file ] = abilities[self.parent.text]
	end
}) , "add" )

player_editor.ui.abilities:addChild( button:new({
	x = var:new(function() return screen.width / 2 - 50 end),
	text = "-", y = 80, width = 20, func = function()
		player_editor.player.abilities[ abilities[self.parent.text].file ] = nil
	end
}) , "sub" )

--functions

function player_editor.open(p)
	if not p then return end
	--set up
	p.mode = "player"
	player_editor.player = p
	player_setting.file = "players"
	--abilities
	local a = p.abilities
	p.abilities = {}
	for k , v in pairs(a) do
		if type(v) == "table" then
			for k , v in pairs(v) do
				p.abilities[v.file] = v
			end
		else
			p.abilities[v.file] = v
		end
	end
	p.abilities[abilities["end turn"].file] = abilities["end turn"]
	p.abilities[abilities["move"].file] = abilities["move"]
	--values
	player_editor.ui.name.text = p.name or ""
	player_editor.ui.red.text = tostring(p.color[1])
	player_editor.ui.green.text = tostring(p.color[2])
	player_editor.ui.blue.text = tostring(p.color[3])
end

function player_editor.draw()
	love.graphics.line(screen.width/2,5 , screen.width/2,screen.height-5)
	local s = math.min(screen.height-60,screen.width/2-60)
	player_editor.player:draw(screen.width/2+30,30,s)
end