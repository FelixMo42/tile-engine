local filesystem = {}

filesystem.base = ""

filesystem.getIndex = function(dir)
	local dir = filesystem.getDirectory(dir,".lua")
	if #dir > 0 then
		return tostring( tonumber( dir[#dir]:match("%d+") ) + 1 )
	else
		return "1"
	end
end

filesystem.toString = function(data)
	if type(data) == "string" then
		return '"'..tostring(data)..'"'
	elseif type(data) == "number" then
		return '['..tostring(data)..']'
	end
	return data
end

filesystem.classToString = function(data)
	local s = data.type..":new({"
	for key , value in pairs( data ) do
		if data[key] ~= _G[data.type][key] then
			if rawtype(value) == "table" then
				if value.save then
					s = s..key.." = "..value:save()..","
				elseif value.new then
					s = s..key.." = "..filesystem.classToString(value)..","
				else
					s = s..key.." = "..filesystem.tableToString(value)..","
				end
			else
				s = s..key.." = "..filesystem.toString(value)..","
			end
		end
	end
	return s:sub(1,-2).."})"
end

filesystem.tableToString = function(data)
	local s = "{"
	for key , value in pairs( data ) do
		if rawtype(value) == "table" then
			if value.save then
				s = s..key.." = "..value:save()..","
			elseif value.new then
				s = s..key.." = "..filesystem.classToString(value)..","
			else
				s = s..key.." = "..filesystem.tableToString(value)..","
			end
		end
		s = s..key.." = "..filesystem.toString(value)..","
	end
	return s:sub(1,-2).."}"
end

filesystem.save = function(data,dir)
	if not data.file then
		local dir = data.type:sub(1,1)..filesystem.getIndex( (dir or data.type.."s") )
		data.file = dir
	end
	local t = "return "
	if data.save then
		t = t..data:save()
	else
		t = t..filesystem.classToString(data)
	end
	return filesystem.write( (dir or data.type.."s").."/"..data.file..".lua" , t )
end

filesystem.write = function(dir , data)
	local path = love.filesystem.getSourceBaseDirectory().."/tile engine/"..filesystem.base
	local f = io.open(path..dir, "w")
	f:write(data)
	f:close()
end

filesystem.getDirectory = function(dir,ext)
	local path = love.filesystem.getSourceBaseDirectory().."/tile engine/"..filesystem.base
	local i, t = 0, {}
    local pfile = io.popen('ls -a "'..path..dir..'"')
    for filename in pfile:lines() do
    	if filename:sub(1,1) ~= "." then
	    	if not ext or ext:find(ext) then
		        i = i + 1
		        t[i] = filename
		    end
		end
    end
    pfile:close()
    return t
end

filesystem.loadClass = function(dir,ext)
	ext = ext or ".lua"
	local path = love.filesystem.getSourceBaseDirectory().."/tile engine/"..filesystem.base
	local i , t , c = 0 , {} , _G[dir]
    local pfile = io.popen('ls -a "'..path..dir..'"')
    for filename in pfile:lines() do
    	if filename:sub(1,1) ~= "." then
	    	if not ext or ext:find(ext) then
		        c[#c + 1] = dofile(path..dir.."/"..filename)
		        c[ c[#c].name ] = c[#c]
		        c[ c[#c] ] = c[#c]
		    end
		end
    end
end

package.preload["filesystem"] = function() return filesystem end

return filesystem