local ui = class:new({
	type = "ui",
	child = {},
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
	for i , child in pairs(self.child) do
		if item.dofunc then
			item:dofunc(f,...)
		else
			call(child,f,...)
		end
	end
	call(self,f,...)
end

function ui:addChild(c,i,n)
	c = c or button:new()
	if type(i) == "string" then
		child[i] = c
		i = n
	end
	i = i or #self.child + 1
	c.parent = self
	table.insert(self.child , i , c)
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

package.preload["ui"] = function() return ui end

return ui