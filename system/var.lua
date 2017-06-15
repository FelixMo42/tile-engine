local var = class:new({
	type = "number",
	isvar = true
})

mt = getmetatable(var)

mt.__new = function(self, func, parent)
	self.value = func
	self.parent = parent or self
end

mt.__add = function(self, outher)
	return self.value(self.parent) + outher
end

mt.__sub = function(self, outher)
	return self.value(self.parent) - outher
end

mt.__mul = function(self, outher)
	return self.value(self.parent) * outher
end

mt.__div = function(self, outher)
	return self.value(self.parent) / outher
end

mt.__pow = function(self, outher)
	return self.value(self.parent) ^ outher
end

mt.__mod = function(self, outher)
	return self.value(self.parent) % outher
end

mt.__concat = function(self, outher)
	return self.value(self.parent) .. outher
end

mt.__eq = function(self, outher)
	return self.value(self.parent) == outher
end

mt.__lt = function(self, outher)
	return self.value(self.parent) > outher
end

mt.__le = function(self, outher)
	return self.value(self.parent) >= outher
end

mt.__tostirng = function(self)
	return tostring( self.value(self.parent) )
end

return var