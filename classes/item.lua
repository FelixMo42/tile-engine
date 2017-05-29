item = class:new({
	type = "item",
	color = color.brown
})

function item:draw(x,y,s)
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill",x + s/10,y + s/10,s - s/5,s - s/5)
end

function item:pickUp(p)
	self.player = p
	self.tile.item = nil
	self.item = nil
	self.map = nil
	p.inventory[#p.inventory + 1] = self
end

function item:drop()
	if self.player.tile then return false end
	for k , item in pairs(self.player.inventory) do
		if type(k) == "number" and item == self then
			table.remove(self.player.inventory,k)
		elseif item == self then
			self.player.inventory[k] = nil
		end
	end
	self.player.tile:setItem(self)
	return true
end

items = {}