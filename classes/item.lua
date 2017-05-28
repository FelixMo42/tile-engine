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

items = {}