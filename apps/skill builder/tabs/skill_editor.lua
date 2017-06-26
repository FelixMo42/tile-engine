skill_editor.ui:add( ui:new() , "abilities" )

skill_editor.ui:add( button:new({
	x = var:new(function() return screen.width / 2 + 2.5 end),
	y = var:new(function() return screen.height - 25 end),
	width = var:new(function() return screen.width / 2 - 10 end),
	text = "back", func = function(self)
		filesystem:saveClass(skill_editor.skill)
		love.open(menu)
	end
}) , "back" )

skill_editor.ui:add( button:new({
	y = var:new(function() return screen.height - 25 end), x = 5,
	width = var:new(function() return screen.width / 2 - 10 end),
	text = "add",  func = function(self)
		skill_editor.skill.abilities[#skill_editor.skill.abilities + 1] = ability:new()
		skill_editor.set_abilities()
	end
}) , "add" )

function skill_editor.open(s)
	skill_editor.skill = s
	skill_editor.set_abilities()
end

function skill_editor.set_abilities()
	for i , v in pairs( skill_editor.skill.abilities ) do
		skill_editor.ui.abilities:addChild( ellement.textbox:new({
			i = i, x = 5, y = i * 25 - 20, text = v.name,
			width = var:new(function() return screen.width - 115 end),
			onEdit = function(self)
				if abilities[self.text] then
					skill_editor.skill.abilities[i] = abilities[self.text]:new()
				end
			end
		}) )
		skill_editor.ui.abilities:addChild( button:new({
			i = i, x = var:new(function() return screen.width - 105 end), y = i * 25 - 20,
			text = "delete", width = 100, onEdit = function(self)
				table.remove(skill_editor.skill.abilities , self.i)
				skill_editor.set_abilities()
			end
		}) )
	end
end