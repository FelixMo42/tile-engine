local filesystem = {}
 
--varibles
 
filesystem.dir = "/"
 
--local functions
 
function filesystem:str(v)
    if type(v) == "string" then
        return "\""..tostring(v):gsub("\n","\\n"):gsub("\"","\\\"").."\""
    end
    return tostring(v)
end

function filesystem:format(t,b,tables)
    local s = (b or "return")
    s = s.." {"
    local tables = tables or {}
    for k , v in pairs(t) do
        if type(v) == "table" then
            if not tables[v] then
                tables[v] = #tables + 1
                tables[#tables + 1] = v
                s = self:format( v , "local T"..tables[v].." =" , tables).."\n"..s
            end
            s = s.."["..self:str(k).."] = ".."T"..tables[v]..", "
        elseif type(v) ~= "function" then
            s = s.."["..self:str(k).."] = "..self:str(v)..", "
        end
    end
    return s.."}"
end
 
function filesystem:write(file, data)
	local path = self.dir..file
	local f = io.open(path, "w")
    if not f then return end
	f:write(data)
	f:close()
end
 
function filesystem:get(file,mode)
    local path = self.dir..file
	local f = io.open(path, "r")
    if not f then return end
	local t = f:read(mode or "*all")
	f:close()
	return t
end
 
function filesystem:load(file,...)
    return assert(loadfile(self.dir..file))(...)
end

function filesystem:delet(file)
    local path = (self.dir..file):gsub(" ","\\ ")
	io.popen("rm "..path)
end
 
function filesystem:getDirectory(file,ext)
	local path = (self.dir..file):gsub(" ","\\ ")
	local i, t = 1, {}
    local pfile = io.popen('ls -a '..path)
    for filename in pfile:lines() do
        if filename:sub(1,1) ~= "." then
            if not ext or filename:find(ext) then
                t[i] = filename
                i = i + 1
            end
        end
	end
    pfile:close()
    return t
end
 
function filesystem:save(file,data)
    --file
    if type(file) == "function" then
        file = file(file)
    end
    --data
    data = data or file
    local s = ""
    if type(data) == "function" then
        s = data(data)
    elseif type(data) == "table" then
        if s.save then
            s = s:save()
        else
            s = self:format(data)
        end
    else
        s = "return "..self:str(data)
    end
    self:write(file , s)
    return s
end

function filesystem:build(app)
    local name = (app or "tile engine")
    filesystem:write("setting/build",(app or ""))
    local cmd = "cp -r Applications/love.app "..filesystem.dir:gsub(" ","\\ ")..name..".app\n"
    cmd = cmd.. "cd "..love.filesystem.getSource():gsub(" ","\\ ").."\n"
    cmd = cmd.. "zip -r -X save/"..name..".app/Contents/Resources/game.love *\n"
    cmd = cmd.. "zip -d save/"..name..".app/Contents/Resources/game.love README.md\n"
    cmd = cmd.. "zip -d save/"..name..".app/Contents/Resources/game.love \"save/*\"\n"
    cmd = cmd.. "cp -r save save/"..name..".app/Contents/Resources/data\n"
    cmd = cmd.. "rm -r save/"..name..".app/Contents/Resources/data/"..name..".app/\n"
    io.popen(cmd):read("*a")
    filesystem:delet("setting/build")
end

return filesystem