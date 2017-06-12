skill = class:new({
	type = "skill",
	name = "def",
	stat = "str",
	level = 0,
	xp = 0
})

function skill:addXP(xp)
	self.xp = self.xp + xp
	local r = 5 * 2 ^ self.level
	while self.xp >= r do
		self.xp = self.xp - r
		self.level = self.level + 1
		r = 5 * 2 ^ self.level
	end
end

function skill:getLevel(b)
	return self.level + self.player.states[self.stat] + (b or 0)
end

skills = {}