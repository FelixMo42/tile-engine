local pathfinder = class:new({
	type = "pathfinder"
})

--local micro-functions

local function add(l,t) l[t.x.."_"..t.y] = t end

local function get(l,x,y) return l[x.."_"..y] or false end

local function remove(l,x,y) l[x.."_"..y] = nil end

--local functions

local function dist(sx,sy , ex,ey)
	return math.floor(math.sqrt((sx-ex)^2+(sy-ey)^2)*10)
end

local function neighbours(node , tx , ty , map)
	local n = {}
	for x = node.x - 1 , node.x + 1 do
		for y = node.y - 1 , node.y + 1 do
			if map[x][y] then
				if (x == node.x and y ~= node.y) or (x ~= node.x and y == node.y) then
					n[#n + 1] = {x = x , y = y}
					n[#n].s = node.s + 10
					n[#n].e = dist(sx,sy , ex,ey)
					n[#n].t = n[#n].s + n[#n].e
					n[#n].p = node
				end
			end
		end
	end
	return n
end

local function calc(open , closed , x , y , map)
	if not get(closed , x , y) then return {} , closed , open end
	local path = { get(closed , x , y) }
	while path[#path].p do
		path[#path+1] = path[#path].p
	end
	local new = {}
	for i = #path - 1 , 1 , -1 do
		new[#path - i] = map[ path[i].x ][ path[i].y ]
	end
	if not map[x][y]:open() then
		new[#new] = nil
	end
	return new , closed , open
end

--functions

function pathfinder:path(map , sx,sy , ex,ey)
	--setup
	local open , closed = {} , {}
	local current
	add(open , { x = sx , y = sy} )
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
		add(closed , current)
		if get(closed , ex , ey) then break end
		--cheak neighbours
		local n = neighbours(current , ex , ey , map)
		for i = 1 , #n do
			if (map[n[i].x][n[i].y]:open() or (n[i].x == ex and n[i].y == ey)) and not get(closed , n[i].x , n[i].y) then
				add(open , n[i])
			end
		end
		current = nil
	end
	return calc(open , closed , ex , ey , map)
end

function pathfinder:line(map , sx,sy , ex,ey , e)
	local open = true
	local steps = math.max(math.abs(sx-ex),math.abs(sy-ey))
	for step = 0 , steps do
		local p = step / steps
		local x = math.floor(sx * (1-p) + ex * (p))
		local y = math.floor(sy * (1-p) + ey * (p))
		if x ~= sx and y ~= sy then
			if e and x == ex and y == ey then break end
			if not map[x][y]:open() then
				open = false
				break
			end
		end
	end
	return open , steps
end

class = require "system/class"

package.preload["pathfinder"] = function() return pathfinder end

return pathfinder