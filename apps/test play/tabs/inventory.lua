--ui

inventory.ui:add( button:new({
	text = "back", b_over = 0, bodyColor_over = color.grey, width = 50,
	x = var:new( function() return screen.width - 72 end ), y = 20,
	func = function() love.open( game ) end
}) , "back" )

inventory.ui:add( ellement.menu:new({
	text = "inventory", b_over = 0, bodyColor_over = color.grey, x = 20, y = 20
}) , "inventory" )

--functions

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
	inventory.ui.inventory:addChild(button:new({width = 1000,height = 1000,draw = {}}),"bg")
end

function inventory.open(t)
	setUpInventory()
	--open right tab
	t = t or "inventory"
	inventory.ui[t].child.active = true
end