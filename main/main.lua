local base = "https://raw.githubusercontent.com/Dimhev/Regretevator/refs/heads/main/main/"
local lib = loadstring(game:HttpGet(base .. "lib.lua"))()
local player = loadstring(game:HttpGet(base .. "Player.lua"))()
local gamemod = loadstring(game:HttpGet(base .. "Game.lua"))()

local window = lib:createwindow()

local playertab = window:createtab("Player")
local gametab = window:createtab("Game")

local movesec = playertab:createsection("Movement")
local charsec = playertab:createsection("Character")

movesec:createslider("WalkSpeed", 16, 120, 16, function(val)
	player:setwalkspeed(val)
end, "Sets and auto locks WalkSpeed when above 16")

movesec:createtoggle("SpeedBoost", false, function(state)
	player:togglespeedboost(state)
end, "CFrame movement boost without touching WalkSpeed")

movesec:createslider("Boost Power", 1, 80, 15, function(val)
	player:setspeedboost(val)
end, "Extra movement speed multiplier")

charsec:createslider("JumpPower", 50, 250, 50, function(val)
	player:setjumppower(val)
end, "Sets and auto locks JumpPower when above 50")

charsec:createtoggle("Custom Gravity", false, function(state)
	player:togglegravity(state)
end, "Overrides workspace gravity")

charsec:createslider("Gravity", 10, 300, 196, function(val)
	player:setgravity(val)
end, "Lower value means higher and floatier jumps")

charsec:createtoggle("Infinite Jump", false, function(state)
	player:toggleinfjump(state)
end, "Jump mid air with safe cooldown")

charsec:createtoggle("Noclip", false, function(state)
	player:togglenoclip(state)
end, "Walk through walls and obstacles")

local propssec = gametab:createsection("Props Protection")

propssec:createtoggle("Disable Banana Peels", false, function(state)
	gamemod:togglebanana(state)
end, "I HATE BANANAS")

propssec:createtoggle("Disable Red Balls", false, function(state)
	gamemod:toggleredball(state)
end, "I HATE RED BALLS")

propssec:createtoggle("Repel Props", false, function(state)
	gamemod:togglerepel(state)
end, "Flings nearby unanchored bananas and red balls away using network physics")

lib:notify({
	title = "Crescent",
	content = "Loaded successfully",
	duration = 3
})
