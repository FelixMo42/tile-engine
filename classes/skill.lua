skill = class:new({
	type = "skill",
	name = "def",
	stat = "str",
	bonuses = {},
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
	local t = self.level + self.player.states[self.stat]
	for k , v in ipairs(self.bonuses) do
		t = t + v.a
	end
	for k , v in pairs(self.player.inventory) do
		if type(k) == "string" then
			t = t + (v.bonuses[self.name] or 0)
		end
	end
	return t + (b or 0)
end

function skill:bonus(a,t)
	self.bonuses[#self.bonuses + 1] = {a = a,t = t or 5}
end

function skill:update()
	for i , b in ipairs(self.bonuses) do
		b.t = b.t - 1
		if b.t <= 0 then
			table.remove( self.bonuses , i )
		end
	end
end

local mt = getmetatable(skill)

mt.__tostring = function(self)
	return "skills."..self.file..":new()"
end

skills = {}