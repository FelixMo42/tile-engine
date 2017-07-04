require "system/system"

--lua libraries

utf8 = require "utf8"

--local libraries

class = require "system/class"
color = require "system/color"
console = require "system/console"
lambda = require "system/lambda"
tab = require "system/tab"
ui = require "system/ui"
var = require "system/var"
button = require "system/button"
ellement = require "system/ellement"
filesystem = require "system/filesystem"

--filesystem set up

if love.filesystem.getSource():find(".love") then
	filesystem.dir = love.filesystem.getSourceBaseDirectory().."/data/"
else
	filesystem.dir = love.filesystem.getSource().."/save/"
end

filesystem.saveClass = function(self,data)
	--file
	local f = _G[data.type.."_setting"] and _G[data.type.."_setting"].file or data.type.."s"
	if not data.file then
		local dir = filesystem:getDirectory(f,".lua")
		if #dir > 0 then
			data.file = f:sub(1,1)..tostring( tonumber( dir[#dir]:match("%d+") ) + 1 )
		else
			data.file = f:sub(1,1).."1"
		end
	end
	--data
	local tables = tables or {}
	local s = "return "
	if data.save then
		s = s..data:save()
	else
		s = s..data.type..":new({"
	    for k , v in pairs(data) do
	    	if data[k] ~= _G[data.type][k] then
		        if type(v) == "table" then
		        	if not table.empty(v) then
			            if not tables[v] then
			                tables[v] = #tables + 1
			                tables[#tables + 1] = v
			                s = self:format( v , "local T"..tables[v].." =" , tables).."\n"..s
			            end
			            s = s.."["..self:str(k).."] = ".."T"..tables[v]..", "
			        end
		        elseif type(v) ~= "function" then
		            s = s.."["..self:str(k).."] = "..self:str(v)..", "
		        end
		 	end
		 	s = s.."})"
	    end
	end
	self:write(f.."/"..data.file..".lua" , s)
	return s , f
end

filesystem.loadClass = function(self,f)
	for i , n in ipairs(self:getDirectory(f,".lua")) do
		_G[f][ #_G[f] + 1] = self:load(f.."/"..n)
        _G[f][ _G[f][ #_G[f] ].name ] = _G[f][ #_G[f] ]
        _G[f][ _G[f][ #_G[f] ].file ] = _G[f][ #_G[f] ]
        _G[f][ _G[f][ #_G[f] ] ] = _G[f][ #_G[f] ]
	end
end

--console set up

print = lambda:new(console.print , console)
print "console on"