require "system"
require "classes"
require "apps"

window = {
	width = love.graphics.getWidth(),
	height = love.graphics.getHeight()
}

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

function love.mousemoved(...)
	tab:dofunc("mousemoved",...)
end

function love.mousepressed(...)
	tab:dofunc("mousepressed",...)
end

function love.mousereleased(...)
	tab:dofunc("mousereleased",...)
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
	window.width = w
	window.height = h
	tab:dofunc("resize",w,h,...)
end

function love.quit(...)
	tab:dofunc("quit",...)
end