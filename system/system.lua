-- pairs

rawnext = next
rawpairs = pairs

function next(t,k)
    local meta = rawgetmetatable(t)
    local next = meta and meta.__next or rawnext
    return next(t,k)
end

function pairs(t) return next, t, nil end

-- type

rawtype = type

function type(item)
	if rawtype(item) == "table" then
		local meta = rawgetmetatable(item)
	    return (meta and meta.__type or rawtype)(item)
	end
	return rawtype(item)
end

--setmetatable

rawsetmetatable = setmetatable

function setmetatable(item,mt)
	local meta = rawgetmetatable(item)
    return (meta and meta.__setmetatable or rawsetmetatable)(item,mt)
end

--getmetatable

rawgetmetatable = getmetatable

function getmetatable(item)
	local meta = rawgetmetatable(item)
	if meta and meta.__getmetatable  then
		return meta.__getmetatable(item)
	end
    return meta
end

--set and get

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