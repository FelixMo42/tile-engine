local T5 =  {["movement"] = 5, ["action"] = 1, }
local T4 =  {["con"] = 0, ["str"] = 0, ["wil"] = 0, ["chr"] = 0, ["int"] = 0, ["dex"] = 0, }
local T3 =  {["a1"] = abilities.a1:new(), ["a2"] = abilities.a2:new(), ["a3"] = abilities.a3:new(), }
local T2 =  {["text"] = "hello", }
local T1 =  {[1] = 0, [2] = 0, [3] = 255, }
return player:new({["color"] = T1, ["hp"] = 25, ["dialog"] = T2, ["maxHp"] = 25, ["file"] = "p1", ["mana"] = 25, ["maxMana"] = 25, ["name"] = "Zander", ["abilities"] = T3, ["mode"] = "player", ["states"] = T4, ["actions"] = T5, })