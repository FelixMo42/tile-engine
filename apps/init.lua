local apps = {}
print "apps:"

local num_apps = 1
for i , app in pairs(love.filesystem.getDirectoryItems("apps")) do
	if type(app) == "string" and not app:find(".lua") and app:sub(1,1) ~= "." then
		print( "  " , num_apps , app )
		apps[num_apps] = app
		apps[app] = num_apps
		num_apps = num_apps + 1
	end
end

tabs = {console = console}
tabs[console] = console
tabs[1] = console
tab = console

function loadApp(app)
	if love.filesystem.exists( "apps/"..app.."/system" ) then
		require("apps/"..app.."/system")
	end
	for i , file in pairs(love.filesystem.getDirectoryItems("apps/"..app.."/tabs")) do
		if file:find(".lua") then
			file = file:gsub(".lua","")
			_G[file] = {}
			local tab = require("tab"):new({name = file})
			tabs[#tabs + 1] = tab
			tabs[tab] = tab
			tabs[file] = tab
			tabs[ _G[file] ] = tab
			require("apps/"..app.."/tabs/"..file)
			tab:dofunc("load")
		end
	end
	tab = tabs.def or tabs.menu or tabs[2] or console
end

function console:enter(text)
	if tonumber(text) then
		text = tonumber(text)
		if apps[text] then
			loadApp(apps[text])
			console:clear(true)
		else
			print "number invalide. please re enter number."
		end
	else
		if apps[text] then
			loadApp(text)
			console:clear(true)
		else
			print "none valide app name. please re enter name."
		end
	end
end

if filesystem:get("setting/build") then
	console:enter(filesystem:get("setting/build"))
end