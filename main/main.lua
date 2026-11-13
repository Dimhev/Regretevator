local base = "https://raw.githubusercontent.com/Dimhev/Regretevator/refs/heads/main/main/"
local lib = loadstring(game:HttpGet(base .. "lib.lua"))()
local player = loadstring(game:HttpGet(base .. "Player.lua"))()

local window = lib:createwindow()
local playertab = window:createtab("player")

local movesec = playertab:createsection("movement")
local charsec = playertab:createsection("character")

movesec:createtoggle("lock walkspeed", false, function(state)
	player:togglewalkspeed(state)
end, "locks walkspeed and prevents game overrides")

movesec:createslider("walkspeed", 16, 120, 16, function(val)
	player:setwalkspeed(val)
end, "target walkspeed value")

movesec:createtoggle("speedboost", false, function(state)
	player:togglespeedboost(state)
end, "cframe movement boost without touching walkspeed")

movesec:createslider("boost power", 1, 80, 15, function(val)
	player:setspeedboost(val)
end, "extra movement speed multiplier")

charsec:createtoggle("lock jumppower", false, function(state)
	player:togglejumppower(state)
end, "enables custom jump height")

charsec:createslider("jumppower", 50, 250, 50, function(val)
	player:setjumppower(val)
end, "target jumppower value")

charsec:createtoggle("custom gravity", false, function(state)
	player:togglegravity(state)
end, "overrides workspace gravity")

charsec:createslider("gravity", 10, 300, 196, function(val)
	player:setgravity(val)
end, "lower value means higher and floatier jumps")

charsec:createtoggle("infinite jump", false, function(state)
	player:toggleinfjump(state)
end, "jump mid air infinitely")

charsec:createtoggle("noclip", false, function(state)
	player:togglenoclip(state)
end, "walk through walls and obstacles")

lib:notify({
	title = "crescent",
	content = "loaded successfully",
	duration = 3
})
