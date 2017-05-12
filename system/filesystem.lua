local filesystem = {}

filesystem.base = ""

filesystem.save = function()
end

filesystem.read = function()
	
end

filesystem.parse = function(self , data)
	
end

filesystem.toString = function(self , data)
	if type(data) ~= "table" then
		return tostring(data)
	end
	local s = ""
	for k , v in pairs(data) do
		s = s..k.." "..tostring(v).."\n"
	end
	return s
end

filesystem.getDirectory = function(self)
	local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -a "'..self.base..path..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

package.preload["filesystem"] = function() return filesystem end

return filesystem