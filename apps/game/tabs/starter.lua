function starter.open()
	if filesystem:get("setting/map") and filesystem:get("setting/player") then
		loadApp("test play")
		love.open(game , menu.map , menu.player)
	else
		love.graphics.setFont(font[20])
		starter.draw = function()
			love.graphics.prints("default map and player are not set. open test play to set them.",0,0,screen.width,screen.height)
		end
		starter.keyreleased = function()
			love.open(menu)
		end
	end
end