--abilites

menu.ui:add( ellement.menu:new({
	y = 5, x = 5, text = "abilites",
	width = var:new( function() return screen.width / 2 - 7.5 end )
}) , "abilites")

--skills

menu.ui:add( ellement.menu:new({
	y = 5, x = var:new( function() return screen.width / 2 + 2.5 end ), text = "skills",
	width = var:new( function() return screen.width / 2 - 7.5 end )
}) , "skill" )

menu.ui.skill:addChild( ui:new() , "skills" )

local function setup_skills()
	menu.ui.skill.child.skills.child:clear()
	for i , s in ipairs(skills) do
		menu.ui.skill.child.skills:addChild( ellement.textbox:new({
			startText = " ", text = s.name, y = i * 25 + 10, s = s, textMode = "left",
			x = 5, width = var:new( function() return screen.width - 225 end ) ,
			onEdit = function(self) self.s.name = self.text  end
		}) , "skill_"..i.."_name" )

		menu.ui.skill.child.skills:addChild( ellement.textbox:new({
			startText = "stat: ", text = skill.stat, y = i * 25 + 10, s = s,
			x = var:new( function() return screen.width - 215 end ),
			onEdit = function(self) self.s.stat = self.text  end
		}) , "skill_"..i.."_state" )

		menu.ui.skill.child.skills:addChild( button:new({
			text = "delete", y = i * 25 + 10, width = 50, s = s, i = i,
			x = var:new( function() return screen.width - 110 end ),
			func = function(self)
				filesystem.delet( "skills/"..self.s.file..".lua" )
				skills[ self.s ] = nil
				skills[ self.s.file ] = nil
				table.remove(skills , self.i)
				setup_skills()
			end
		}) , "skill_"..i.."_delete" )

		menu.ui.skill.child.skills:addChild( button:new({
			text = "save", y = i * 25 + 10, width = 50, s = s,
			x = var:new( function() return screen.width - 55 end ),
			func = function(self) filesystem.save( self.s ) end
		}) , "skill_"..i.."_save" )
	end
end

setup_skills()

menu.ui.skill:addChild( button:new({
	x = 5, width = var:new( function() return screen.width - 10 end ),
	y = var:new( function() return screen.height - 25 end ), text = "new skill",
	func = function()
		local s = skill:new()
		filesystem.save( s )
		skills[ s ] = s
		skills[ s.file ] = s
		skills[ #skills + 1 ] = s
		setup_skills()
	end
}) , "new" )

--function

function menu.draw()
	love.graphics.line(5,30 , screen.width-5,30)
	love.graphics.line(5,screen.height-30 , screen.width-5,screen.height-30)
end