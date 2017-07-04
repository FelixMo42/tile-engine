--lua

rawnext = next
rawpairs = pairs

function next(t,k)
    local meta = rawgetmetatable(t)
    local next = meta and meta.__next or rawnext
    return next(t,k)
end

function pairs(t) return next, t, nil end

rawtype = type

function type(item)
	if rawtype(item) == "table" then
		local meta = rawgetmetatable(item)
	    return (meta and meta.__type or rawtype)(item)
	end
	return rawtype(item)
end

rawsetmetatable = setmetatable

function setmetatable(item,mt)
	local meta = rawgetmetatable(item)
    return (meta and meta.__setmetatable or rawsetmetatable)(item,mt)
end

rawgetmetatable = getmetatable

function getmetatable(item)
	local meta = rawgetmetatable(item)
	if meta and meta.__getmetatable  then
		return meta.__getmetatable(item)
	end
    return meta
end

defrawset = rawset
defrawget = rawget

function rawget(table,key)
	local meta = rawgetmetatable(table)
    return (meta and meta.__rawget or defrawget)(table,key)
end

function rawset(table,key,value)
	local meta = rawgetmetatable(table)
    return (meta and meta.__rawset or defrawset)(table,key,value)
end

rawtostring = tostring

function tostring(v)
	if rawtype(v) == "table" then
		local mt = getmetatable(v)
		if mt and mt.__tostring then
			return mt.__tostring(v)
		end
	end
	return rawtostring(v)
end

--math

math.clamp = function(val,min,max)
	return math.min( math.max(val + 0,min + 0) , max + 0)
end

math.loop = function(val,max,min)
	if min then
		local m = min
		min = max
		max = m
	else
		min = 1
	end
	if val > max then
		val = min + (val - max - 1)
	end
	while val < min do
		val = max - (min - val)
	end
	return val
end

math.sign = function(n)
	if n > 0 then
		return 1
	elseif n < 0 then
		return -1
	else
		return 0
	end
end

math.approach = function(c,t,s)
	return math.min(c + s , t)
end

--table

table.reverse = function(t)
	local n = {}
	for k , v in pairs(t) do
		n[k] = v
	end
	for i , v in ipairs(t) do
		n[#t - (i - 1)] = v
	end
	return n
end

table.count = function(t)
	local c = 0
	for k , v in pairs(t) do
		c = c + 1
	end
	return c
end

table.empty = function(t)
	for k , v in pairs(t) do
		return false
	end
	return true
end
 
table.copy = function(s,t)
	local n , t = {} , t or {}
	for k , v in pairs(s) do
		if type(v) == "table" then
			if not t[v] then
				t[v] = {}
				t[v] = table.copy(v,t)
			end
			n[k] = t[v]
		else
			n[k] = v
		end
	end
	local m = getmetatable(s)
	if m then
		if not t[m] then
			t[m] = {}
			t[m] = table.copy(m,t)
		end
		getmetatable(n , t[m])
	end
	return n
end

--love

function love.graphics.prints(t,x,y,w,h,xa,ya)
	ya , t = ya or "center" , t..""
	if ya == "center" then
		local l = #( ( {love.graphics.getFont():getWrap(t,w)} )[2] )
		y = y + h / 2 -  (l * love.graphics.getFont():getHeight())/2
	elseif ya == "bottom" then
		local l = #( ( {love.graphics.getFont():getWrap(t,w)} )[2] )
		y = y + h - (l * love.graphics.getFont():getHeight())
	end
	love.graphics.printf(t,x,y,w,xa or "center")
end