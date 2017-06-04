local ui = class:new({
	type = "ui",
	child = {active = true},
	modes = {}
})

function ui:dofunc(f,...)
	local function call(item,f,...)
		if item[f] ~= nil then
			if type(item[f]) == "function" then
				return item[f](item,...)
			elseif item[f].dofunc then
				return item[f].dofunc(item,...)
			else
				for i , v in ipairs(item[f]) do
					if type(v) == "function" then
						v(item,...)
					elseif type(v) == "string" and item[f][v] then
						item[f][v](item,...)
					end
				end
			end
		end
	end
	call(self,f,...)
	if self.child.active then
		for i , child in ipairs(self.child) do
			if rawtype(child) == "table" then
				if child.dofunc then
					child:dofunc(f,...)
				else
					call(child,f,...)
				end
			end
		end
	end
end

function ui:addChild(c,i,n)
	c = c or button:new()
	if type(i) == "string" then
		self.child[i] = c
		i = n
	end
	i = i or #self.child + 1
	c.parent = self
	table.insert(self.child , i , c)
	return c
end

function ui:addCallback(list,name,func,i)
	if self[list] then
		i = i or #self[list] + 1
	else
		i = 1
		self[list] = {}
	end
	self[list][name] = func
	table.insert(self[list],i,name)
end

function ui:calc(val,...)
	if type(val) == "function" then
		return val(...)
	end
	return val
end

function ui.child:is(var)
	local is = false
	for k , item in pairs(self) do
		if rawtype(item) == "table" then
			if item[var] then
				is = item[var] or is
			end
			if #(item.child or {}) > 0 and item.child.is then
				is = item[var] or item.child:is(var) or is
			end
		end
	end
	return is
end

function ui.child:get(var)
	local vars = {}
	for k , item in pairs(self) do
		if item[var] then
			vars[#vars + 1] = item[var]
		end
	end
	return unpack(vars)
end

function ui.child:clear(new)
	for k , v in pairs(self) do
		if rawtype(v) == "table" then
			self[k] = nil
		end
	end
end

package.preload["ui"] = function() return ui end

return ui