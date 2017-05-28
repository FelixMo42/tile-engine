local ellement = {}

--menu

ellement.menu = button:new({
	type = "menu"
})

ellement.menu.child.active = false

ellement.menu:addCallback("mousereleased","open",function(self)
	if self.child.is then
		self.child.active = self.over or self.child:is("over")
	else
		self.child.active = self.over
	end
end)

--textbox

ellement.textbox = button:new({
	type = "textbox",
	active = false,
	b_over = 0,
	textColor_empty = color.grey,
	text = "",
	modes = {
		"active",
		"empty",
		"pressed",
		"over"
	}
})

ellement.textbox:addCallback("mousereleased","active",function(self)
	self.active = self.over
end)

ellement.textbox:addCallback("textinput","textinput",function(self,key,s)
	if not s then
		if not self.active then return end
		if love.keyboard.isDown("rgui","lgui") then return end
	end
	if not self.filter or self.filter:find(key) then 
		self.text = self.text..key
		if self.onEdit then self:onEdit(key) end
	end
end)

ellement.textbox:addCallback("keyreleased","key actions",function(self,key)
	if not self.active then return end
	if key == "backspace" then
		self.text = string.sub(self.text, 1, -2)
		if self.onEdit then self:onEdit(key) end
	elseif love.keyboard.isDown("rgui","lgui") then
		if key == "v" then
			local text = love.system.getClipboardText()
			for i = 1 , #text do
				self:dofunc("textinput",text:sub(i,i),true)
			end
		end
	end
end)

ellement.textbox:addCallback("keyreleased","empty",function(self,key)
	if not self.active then return end
	if #self.text == 0 then 
		self.empty = true
	else
		self.empty = false
	end
end)

ellement.textbox.draw.text = function(self)
	local text = (self.startText or "")..(self.text or self.defText or "")..(self.endText or "")
	love.graphics.setColor(self.textColor)
	local l = #( ( {love.graphics.getFont():getWrap(text,self.width)} )[2] )
	local y = self.y + self.height / 2 -  (l * love.graphics.getFont():getHeight())/2
	love.graphics.printf(text,self.x,y,self.width,self.textMode or "center")
end

package.preload["ellement"] = function() return ellement end

return ellement