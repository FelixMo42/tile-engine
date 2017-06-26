local T10 = {[1] = 169, [2] = 169, [3] = 169, }
local T9 = {["movement"] = 5, ["action"] = 1, }
local T8 = {["con"] = 0, ["str"] = 0, ["wil"] = 0, ["chr"] = 0, ["int"] = 0, ["dex"] = 0, }
local T7 = {["attack"] = abilities.a1:new(), }
local T6 = {["offensive"] = T7, }
local T5 = {["text"] = "to bad", }
local T4 = {["text"] = "nice", }
local T3 = {["I'm good."] = T4, ["I'm not doing good."] = T5, ["text"] = "Thaks I'am doing good.\nHow about you?", }
local T2 = {["text"] = "I am a robot!", }
local T1 = {["Who are you?"] = T2, ["text"] = "Hello I'm Beta!", ["How are you doing?"] = T3, }
return player:new({["mana"] = 25, ["dialog"] = T1, ["file"] = "n1", ["abilities"] = T6, ["states"] = T8, ["actions"] = T9, ["color"] = T10, ["hp"] = 10, ["maxMana"] = 25, ["maxHp"] = 25, ["xp"] = 10, ["name"] = "Beta", })