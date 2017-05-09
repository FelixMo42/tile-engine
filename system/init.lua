require "system/system"

utf8 = require "utf8"
ltn12 = require "ltn12"
http = require "socket.http"

class = require "system/class"
client = require "system/client"
console = require "system/console"
lambda = require "system/lambda"
tab = require "system/tab"
ui = require "system/ui"
button = require "system/button"

print = lambda:new(console.print , console)
print "console on"