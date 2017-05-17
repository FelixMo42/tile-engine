screen = {
	width = love.graphics.getWidth(),
	height = love.graphics.getHeight()
}

mouse = {
	x = love.mouse.getX(), y = love.mouse.getY(),
	dx = 0, dy = 0, sx = 0, sy = 0,
	button = 0,
	drag = false,
	used = false
}

font = setmetatable( {} , {
	__index = function(self,key)
		self[key] = love.graphics.newFont(key)
	end
} )

require "system"
require "classes"
require "apps"

function love.open(t,...)
	tab:dofunc("close",...)
	if type(t) == "tab" then
		tab = t
		tab:dofunc("open",...)
	else
		tab = tabs[t]
		tab:dofunc("open",...)
	end
end

function love.draw(...)
	tab:dofunc("draw",...)
end

function love.update(...)
	tab:dofunc("update",...)
end

function love.keypressed(...)
	tab:dofunc("keypressed",...)
end

function love.keyreleased(...)
	tab:dofunc("keyreleased",...)
end

function love.mousemoved(x,y,dx,dy,...)
	--mouse
	mouse.dx , mouse.dy = dx , dy
	mouse.x , mouse.y = x , y
	if mouse.drag == false then
		mouse.drag = true
	end
	mouse.sx = mouse.x
	mouse.sy = mouse.y
	if mouse.drag == nil then
		mouse.ex = mouse.x
		mouse.ey = mouse.y
	end
	--tab
	tab:dofunc("mousemoved",x,y,dx,dy,...)
end

function love.mousepressed(x,y,button,...)
	--mouse
	mouse.used = false
	mouse.drag = false
	mouse.button = button
	mouse.ex = mouse.x
	mouse.ey = mouse.y
	--tab
	tab:dofunc("mousepressed",x,y,button,...)
end

function love.mousereleased(...)
	--mouse
	mouse.used = false
	--tab
	tab:dofunc("mousereleased",...)
	--mouse
	mouse.drag = nil
	mouse.ex = mouse.x
	mouse.ey = mouse.y
end

function love.wheelmoved(...)
	tab:dofunc("wheelmoved",...)
end

function love.mousefocus(...)
	tab:dofunc("mousefocus",...)
end

function love.visible(...)
	tab:dofunc("visible",...)
end

function love.textinput(...)
	tab:dofunc("textinput",...)
end

function love.resize(w,h,...)
	--screen
	screen.width = w
	screen.height = h
	--tab
	tab:dofunc("resize",w,h,...)
end

function love.quit(...)
	tab:dofunc("quit",...)
end