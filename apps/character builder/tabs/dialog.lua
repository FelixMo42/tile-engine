--ui

dialog.ui:add( ellement.textbox:new({
	draw = {},x = 10,y = 10,
	width = var:new(function() return screen.width - 20 end ),
	height = var:new(function() return dialog.h end ),
	onEdit = function(self)
		dialog.option.text = self.text
		dialog.calc()
	end
}) , "text" )

dialog.ui:add( ui:new({}) , "options" )

dialog.ui:add( ui:new({}) , "select" )

dialog.ui:add( button:new({
	x = 5, y = var:new(function() return screen.height - 25 end ), text = "return",
	width = var:new(function() return screen.width / 2 - 7.5 end),
	func = function() love.open(npc_editor) end
}) , "return" )

dialog.ui:add( button:new({
	width = var:new(function() return screen.width - 20 end), x = 10,
	text = "new responce", func = function()
		if not dialog.option[""] then 
			dialog.option[""] = {text = ""}
			dialog.choose(dialog.option)
		end
	end
}) , "new" )

dialog.ui:add( button:new({
	x = var:new(function() return screen.width / 2 + 2.5 end ),
	y = var:new(function() return screen.height - 25 end ), text = "back",
	width = var:new(function() return screen.width / 2 - 7.5 end),
	func = function() dialog.choose( dialog.prev ) end
}) , "back" )

--functions

function dialog.draw()
	love.graphics.setColor( color.black )
	love.graphics.rectangle("fill",10,10,screen.width-20,dialog.h)
	love.graphics.setColor( color.white )
	love.graphics.rectangle("line",10,10,screen.width-20,dialog.h)
	love.graphics.printf(dialog.text,15,15,screen.width-30)
end

function dialog.open()
	dialog.player = npc_editor.player
	dialog.choose( dialog.player.dialog )
end

function dialog.choose(option)
	if dialog.option then dialog.prev = dialog.option end
	dialog.ui.options.child:clear()
	dialog.ui.select.child:clear()
	dialog.option = option
	dialog.ui.text.text = option.text
	local i = 1
	for k , v in pairs(dialog.option) do
		if type(v) == "table" then
			dialog.ui.options:addChild( ellement.textbox:new({
				text = k, oldText = k, x = 10,
				width = var:new(function() return screen.width - 125 end),
				onEdit = function(self)
					if dialog.option[self.text] then return end
					dialog.option[self.text] = dialog.option[self.oldText]
					dialog.option[self.oldText] = nil
					self.oldText = self.text
				end
			}) )
			dialog.ui.select:addChild( button:new({
				text = "select", i = i,
				x = var:new(function() return screen.width - 110 end),
				func = function(self)
					dialog.choose( dialog.option[dialog.ui.options.child[self.i].text] )
				end
			}) )
			i = i + 1
		end
	end
	dialog.calc()
end

function dialog.calc()
	--calc text
	dialog.text = npc_editor.player.name..": "..dialog.option.text
	dialog.l = #( ( {love.graphics.getFont():getWrap(dialog.text,screen.width-30)} )[2] )
	dialog.h = dialog.l * (love.graphics.getFont():getHeight() + 3) + 5
	--set pos
	local y = dialog.h + 15
	for i , child in ipairs(dialog.ui.options.child) do
		dialog.ui.select.child[i].y = y
		child.y = y
		y = y + 25
	end
	dialog.ui.new.y = y
end