local base = "https://raw.githubusercontent.com/Dimhev/Regretevator/refs/heads/main/main/"
local lib = loadstring(game:HttpGet(base .. "lib.lua"))()
local player = loadstring(game:HttpGet(base .. "Player.lua"))()
local gamemod = loadstring(game:HttpGet(base .. "Game.lua"))()

local window = lib:createwindow()

local playertab = window:createtab("player")
local gametab = window:createtab("game")

local movesec = playertab:createsection("movement")
local charsec = playertab:createsection("character")

movesec:createslider("walkspeed", 16, 120, 16, function(val)
	player:setwalkspeed(val)
end, "sets and auto locks walkspeed when above 16")

movesec:createtextbox("custom walkspeed", "16 - 120", "16", function(val)
	local num = tonumber(val)
	if num then
		player:setwalkspeed(num)
	end
end, "type exact walkspeed value")

movesec:createtoggle("speedboost", false, function(state)
	player:togglespeedboost(state)
end, "cframe movement boost without touching walkspeed")

movesec:createslider("boost power", 1, 80, 15, function(val)
	player:setspeedboost(val)
end, "extra movement speed multiplier")

charsec:createslider("jumppower", 50, 250, 50, function(val)
	player:setjumppower(val)
end, "sets and auto locks jumppower when above 50")

charsec:createtextbox("custom jumppower", "50 - 250", "50", function(val)
	local num = tonumber(val)
	if num then
		player:setjumppower(num)
	end
end, "type exact jumppower value")

charsec:createtoggle("custom gravity", false, function(state)
	player:togglegravity(state)
end, "overrides workspace gravity")

charsec:createslider("gravity", 10, 300, 196, function(val)
	player:setgravity(val)
end, "lower value means higher and floatier jumps")

charsec:createtoggle("infinite jump", false, function(state)
	player:toggleinfjump(state)
end, "jump mid air with safe cooldown")

charsec:createtoggle("noclip", false, function(state)
	player:togglenoclip(state)
end, "walk through walls and obstacles")

local propssec = gametab:createsection("props protection")
local targetsec = gametab:createsection("target props")
local coinssec = gametab:createsection("coins")

propssec:createtoggle("disable banana peels", false, function(state)
	gamemod:togglebanana(state)
end, "destroys banana peels and removes collision")

propssec:createtoggle("disable red balls", false, function(state)
	gamemod:toggleredball(state)
end, "destroys red balls and removes collision")

propssec:createtoggle("repel props", false, function(state)
	gamemod:togglerepel(state)
end, "flings nearby unanchored bananas and red balls away")

targetsec:createtextbox("target player", "2-3 letters...", "", function(val)
	local matched = gamemod:settarget(val)
	if matched ~= "" then
		lib:notify({
			title = "target locked",
			content = matched,
			duration = 2
		})
	end
	return matched
end, "auto completes player name or display name by 2-3 letters")

targetsec:createtoggle("loop tp props", false, function(state)
	gamemod:toggletpprops(state)
end, "continuously teleports props to target player")

targetsec:createbutton("tp props once", function()
	gamemod:tppropstotarget()
end, "teleports all current props to target player")

coinssec:createtoggle("auto collect coins", false, function(state)
	gamemod:toggleautocoins(state)
end, "experimental magnet that pulls all map coins to you")

coinssec:createbutton("collect coins once", function()
	gamemod:collectcoinsonce()
end, "instantly pulls all current map coins once")

lib:notify({
	title = "crescent",
	content = "loaded successfully",
	duration = 3
})local base = "https://raw.githubusercontent.com/Dimhev/Regretevator/refs/heads/main/main/"
local lib = loadstring(game:HttpGet(base .. "lib.lua"))()
local player = loadstring(game:HttpGet(base .. "Player.lua"))()
local gamemod = loadstring(game:HttpGet(base .. "Game.lua"))()

local window = lib:createwindow()

local playertab = window:createtab("player")
local gametab = window:createtab("game")

local movesec = playertab:createsection("movement")
local charsec = playertab:createsection("character")

movesec:createslider("walkspeed", 16, 120, 16, function(val)
	player:setwalkspeed(val)
end, "sets and auto locks walkspeed when above 16")

movesec:createtextbox("custom walkspeed", "16 - 120", "16", function(val)
	local num = tonumber(val)
	if num then
		player:setwalkspeed(num)
	end
end, "type exact walkspeed value")

movesec:createtoggle("speedboost", false, function(state)
	player:togglespeedboost(state)
end, "cframe movement boost without touching walkspeed")

movesec:createslider("boost power", 1, 80, 15, function(val)
	player:setspeedboost(val)
end, "extra movement speed multiplier")

charsec:createslider("jumppower", 50, 250, 50, function(val)
	player:setjumppower(val)
end, "sets and auto locks jumppower when above 50")

charsec:createtextbox("custom jumppower", "50 - 250", "50", function(val)
	local num = tonumber(val)
	if num then
		player:setjumppower(num)
	end
end, "type exact jumppower value")

charsec:createtoggle("custom gravity", false, function(state)
	player:togglegravity(state)
end, "overrides workspace gravity")

charsec:createslider("gravity", 10, 300, 196, function(val)
	player:setgravity(val)
end, "lower value means higher and floatier jumps")

charsec:createtoggle("infinite jump", false, function(state)
	player:toggleinfjump(state)
end, "jump mid air with safe cooldown")

charsec:createtoggle("noclip", false, function(state)
	player:togglenoclip(state)
end, "walk through walls and obstacles")

local propssec = gametab:createsection("props protection")
local targetsec = gametab:createsection("target props")
local coinssec = gametab:createsection("coins")

propssec:createtoggle("disable banana peels", false, function(state)
	gamemod:togglebanana(state)
end, "destroys banana peels and removes collision")

propssec:createtoggle("disable red balls", false, function(state)
	gamemod:toggleredball(state)
end, "destroys red balls and removes collision")

propssec:createtoggle("repel props", false, function(state)
	gamemod:togglerepel(state)
end, "flings nearby unanchored bananas and red balls away")

targetsec:createtextbox("target player", "2-3 letters...", "", function(val)
	local matched = gamemod:settarget(val)
	if matched ~= "" then
		lib:notify({
			title = "target locked",
			content = matched,
			duration = 2
		})
	end
	return matched
end, "auto completes player name or display name by 2-3 letters")

targetsec:createtoggle("loop tp props", false, function(state)
	gamemod:toggletpprops(state)
end, "continuously teleports props to target player")

targetsec:createbutton("tp props once", function()
	gamemod:tppropstotarget()
end, "teleports all current props to target player")

coinssec:createtoggle("auto collect coins", false, function(state)
	gamemod:toggleautocoins(state)
end, "experimental magnet that pulls all map coins to you")

coinssec:createbutton("collect coins once", function()
	gamemod:collectcoinsonce()
end, "instantly pulls all current map coins once")

lib:notify({
	title = "crescent",
	content = "loaded successfully",
	duration = 3
})
