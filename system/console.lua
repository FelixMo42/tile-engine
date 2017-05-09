local console = require("class"):new()

console.log = {}
console.split = " "
console.input = ""

function console:dofunc(f,...)
	if self[f] then
		return self[f](self,...)
	end
end

function console:print(...)
	local msgs , msg = {...} , ""
	for i , v in pairs(msgs) do
		msg = msg..tostring(msgs[i])
		if i ~= #msgs then
			msg = msg..self.split
		end
	end
	console.log[#console.log + 1] = msg
end

function console:draw()
	local y = love.graphics.getFont():getHeight() / 2
	for i = 1 , #self.log do
		love.graphics.printf(console.log[i] , 10 , y , love.graphics.getWidth() - 20)
		y = y + math.ceil(love.graphics.getFont():getWidth(self.log[i]) / (love.graphics.getWidth() - 20)) * love.graphics.getFont():getHeight()
		if y >= love.graphics.getHeight() then break end
	end
	love.graphics.print(self.input , 10 , love.graphics.getHeight() - love.graphics.getFont():getHeight() * 1.5)
end

function console:textinput(text)
    self.input = self.input..text
end

function console:keypressed(key)
    if key == "backspace" then
        self.input = string.sub(self.input, 1, -2)
    elseif key == "return" then
    	self:enter(self.input)
    	self:print(self.input)
    	self.input = ""
    end
end

function console:enter()
end

function console:clear(reset)
	self.log = {}
	if reset then
		self.enter = function()
		end
	end
end

package.preload["console"] = function() return console end

return console