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
	for i , s in ipairs( inventory.player.skills ) do
		local skill_ui = inventory.ui.skills:addChild( ellement.menu:new({
			text = s.name.." - lv "..s.level.." + "..inventory.player:getSkill(s.name)-s.level.." - xp "..s.xp,
			x = 25, y = (i-1) * 25 + 75, width = 200
		}) , s.name )
		for i , a in ipairs( s.abilities ) do
			local c = skill_ui:addChild( button:new({
				x = 235, y = (i-1) * 25 + 75, text = a.name, ability = a, func = function(self)
					if self.ability:available() and inventory.player.ap > 0 then
						inventory.player.ap = inventory.player.ap - 1
						inventory.player:addAbility( self.ability )
						game.moves_setup( game.world.move , inventory.player.abilities )
						setUpSkills()
					end
				end
			}) )
			if a:gotten(inventory.player) then
				c.bodyColor = color.blue
			elseif a:available(inventory.player) then
				c.bodyColor = color.black
			else
				c.bodyColor = color.grey
			end
		end
	end
	inventory.ui.skills:addChild(button:new({x = 20,y = 40,width = 1000,height = 1000,draw = function()
		love.graphics.line(25,70 , screen.width-25,70)
		love.graphics.line(230,75 , 230,screen.height-25)
		local text = "name: "..inventory.player.name.." / "
		text = text.."level: "..inventory.player.level.." / ".."xp: "..inventory.player.xp.." / "
		text = text.."hp: "..inventory.player.hp.." / ".."mana: "..inventory.player.mana.." / "
		text = text.."ap: "..inventory.player.ap.." / ".."sp: "..inventory.player.sp.."\n"
		for k , v in pairs(inventory.player.stats) do text = text..k..": "..v.." / " end
		love.graphics.prints(text, 25 , 40 , screen.height - 50, 30, "center")
	end}),"bg")
end