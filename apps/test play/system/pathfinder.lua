local pathfinder = class:new({
	type = "pathfinder"
})

--local functions

local function add(l,x,y)
	l[x.."_"..y] = {x = x,y = y}
end

local function get(l,x,y)
	return l[x.."_"..y]
end

local function remove(l,x,y)
	l[x.."_"..y] = nil
end

local function dist(sx,sy , ex,ey)
	return math.floor(math.sqrt((sx-ex)^2+(sy-ty)^2)*10)
end

--functions

function pathfinder:neighbours(node , tx , ty)
	local n = {}
	for x = tx - 1 , tx + 1 do
		for y = ty - 1 , ty + 1 do
			if (x == node.x and y ~= node.y) or (x ~= node.x and y == node.y) then
				n[#n + 1] = {x = x , y = y}
				n[#n].s = node.s + 10
				n[#n].e = dist(sx,sy , ex,ey)
				n[#n].t = n[#n].s + n[#n].e
			end
		end
	end
	return n
end

function pathfinder:find(map , sx,sy , ex,ey)
	--setup
	self.map = map
	local open , closed = {} , {}
	local current
	add(open , sx , sy)
	get(open , sx , sy).s = 0 --dist from start
	get(open , sx , sy).e = dist(sx,sy , ex,ey) --dist to end
	get(open , sx , sy).t = get(open , sx , sy).e --total dist
	--find path
	while true do
		--get current tile
		for pos , node in pairs(open) do
			if not current or current.t > node.t then
				current = node
			end
		end
		if not current then break end
		remove(open , current.x , current.y)
		add(closed , current.x , current.y)
		if get(closed , ex , ey) then break end
		--cheak neighbours
		local n = self:neighbours()
		for i = 1 , #n do
			if self.map[n[i].x][n[i].y] then
				open[n[i].x.."_"..n[i].y] = n[i]
			end
		end
		current = nil
	end
	--get path
	if not get(closed , ex , ty) then return {} , closed , open end
	local path = {}
	path[1] = get(closed , ex , ey)
	while path[#path].s ~= 0 do
		path[#path+1] = path[#path].p
	end
	local new = {}
	for i = #path , 1 , -1 do
		new[i] = self.map[ path[i].x ][ path[i].y ]
	end
	return new , closed , open
end

class = require "system/class"

package.preload["pathfinder"] = function() return pathfinder end

return pathfinder