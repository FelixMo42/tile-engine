--ui

inventory.ui:add( button:new({
	text = "back", b_over = 0, bodyColor_over = color.grey, width = 50,
	x = var:new( function() return screen.width - 72 end ), y = 20,
	func = function() love.open( game ) end
}) , "back" )

inventory.ui:add( ellement.menu:new({
	text = "inventory", b_over = 0, bodyColor_over = color.grey, x = 20, y = 20
}) , "inventory" )

inventory.ui:add( ellement.menu:new({
	text = "skills", b_over = 0, bodyColor_over = color.grey, x = 120, y = 20
}) , "skills" )

--love functions

function inventory.open(t)
	inventory.player = game.party
	setUpInventory()
	setUpSkills()
	--open right tab
	t = t or "inventory"
	inventory.ui[t].child.active = true
end

function inventory.draw()
	--draw box
	game.map:draw()
	love.graphics.setColor(color.black)
	love.graphics.rectangle("fill",18,18,screen.width-36,screen.height-36)
	for i = 1 , 2 do
		love.graphics.setColor(color.white)
		love.graphics.rectangle("line",20,20,screen.width-40,screen.height-40)
		love.graphics.line(20,40 , screen.width-22,40)
	end
end

--functions

function setUpInventory()
	inventory.ui.inventory.child:clear()
	for i , item in ipairs(game.player.inventory) do
		inventory.ui.inventory:addChild( button:new({
			textMode = "left" , x = 25, y = i * 25 + 20, text = " "..item.name,
			width = var:new( function() return screen.width - 157 end ), item = item
		}) , "item_"..i )
		if item.equiped then
			inventory.ui.inventory.child["item_"..i].text = " "..item.name.." - "..item.slot
		end
		inventory.ui.inventory:addChild( button:new({
			func = function(self)
				self.item:drop()
				setUpInventory()
				inventory.ui.inventory.child.active = true
			end, text = "D" , width = 20 , item = item ,
			x = var:new( function() return screen.width - 127 end ), y = i * 25 + 20,
		}) )
		inventory.ui.inventory:addChild( button:new({
			func = function(self)
				self.item:use()
				setUpInventory()
				inventory.ui.inventory.child.active = true
			end, text = "use" , width = 50 , item = item ,
			x = var:new( function() return screen.width - 102 end ), y = i * 25 + 20,
		}) )
		inventory.ui.inventory:addChild( button:new({
			text = "T" , width = 20 , item = item ,
			x = var:new( function() return screen.width - 47 end ), y = i * 25 + 20,
		}) )
	end
	inventory.ui.inventory:addChild(button:new({x = 20,y = 40,width = 1000,height = 1000,draw = {}}),"bg")
end

function setUpSkills()
	inventory.ui.skills.child:clear()
	local i = 1
	for k , s in ipairs( inventory.player.skills ) do
		local ui = inventory.ui.skills:addChild( button:new({
			text = s.name.." - lv "..s.level.." + "..inventory.player:getSkill(s.name)-s.level.." - xp "..s.xp,
			x = 25, y = i * 25 + 20, width = 200
		}) , s.name )
		for i , a in ipairs( s.abilities ) do
			inventory.ui.skills.child[s.name]:addChild( button:new({
				x = 235, y = i * 25 + 20, text = a.name, ability = a, func = function(self)
					if inventory.player.ap > 0 then
						inventory.player.ap = inventory.player.ap - 1
						inventory.player:addAbility( self.ability )
						game.moves_setup( game.world.move , inventory.player.abilities )
					end
				end
			}) )
		end
		i = i + 1
	end
	inventory.ui.skills:addChild(button:new({x = 20,y = 40,width = 1000,height = 1000,draw = function()
		love.graphics.line(230,45 , 230,screen.height-25)
	end}),"bg")
end