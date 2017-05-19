require "system/system"

utf8 = require "utf8"
ltn12 = require "ltn12"
http = require "socket.http"

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

--set up

filesystem.base = "save/"

print = lambda:new(console.print , console)
print "console on"