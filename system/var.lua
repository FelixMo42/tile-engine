--[[local var = require("class"):new()

mt = getmetatable(var)

mt.__new = function(self, func)
	self.value = func
end

package.preload["var"] = function() return var end

return var]]