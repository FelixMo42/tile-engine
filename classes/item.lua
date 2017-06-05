item = class:new({
	type = "item",
	slot = "usable",
	color = color.brown,
	max = 2, min = 0,
	equiped = false
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
	if self.player.tile.item then return false end
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

function item:use()
	if self.player.inventory[self.slot] then
		self.player.inventory[self.slot].equiped = false
		self.player.inventory[self.slot] = nil
	end
	self.equiped = true
	self.player.inventory[self.slot] = self
end

function item:getActions()
	return {
		["pick up"] = function(self) self:pickUp( game.player )  end
	}
end

function item:damage()
	return math.random(self.min,self.max)
end

items = {}