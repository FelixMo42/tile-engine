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
	love.graphics.rectangle("fill",18,18,screen.height-36,screen.width-36)
	for i = 1 , 2 do
		love.graphics.setColor(color.white)
		love.graphics.rectangle("line",20,20,screen.height-40,screen.width-40)
		love.graphics.line(20,40 , screen.width-22,40)
	end
end

function inventory.open(t)
	--set up inventory
	inventory.ui.inventory.child:clear()
	inventory.ui.inventory:addChild( button:new({width = 1000,height = 1000,draw = {}}) , "bg" )
	for i , item in ipairs(game.player.inventory) do
		inventory.ui.inventory:addChild( button:new({
			textMode = "left", text = " "..item.name , x = 25, y = i * 25 + 20,
			width = var:new( function() return screen.width - 52 end )
		}) )
	end
	--open right tab
	t = t or "inventory"
	inventory.ui[t].child.active = true
end