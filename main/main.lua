local base = "https://raw.githubusercontent.com/Dimhev/Regretevator/refs/heads/main/main/"
local lib = loadstring(game:HttpGet(base .. "lib.lua"))()
local player = loadstring(game:HttpGet(base .. "Player.lua"))()
local gamemod = loadstring(game:HttpGet(base .. "Game.lua"))()
local visuals = loadstring(game:HttpGet(base .. "Visuals.lua"))()
local autofloor = loadstring(game:HttpGet(base .. "AutoFloor.lua"))()

local window = lib:createwindow()

local playertab = window:createtab("Player")
local gametab = window:createtab("Game")
local funtab = window:createtab("Fun")
local autofarmtab = window:createtab("AutoFarm")
local visualstab = window:createtab("Visuals")

local movesec = playertab:createsection("Movement")
local charsec = playertab:createsection("Character")

movesec:createslider("WalkSpeed", 16, 120, 16, function(val)
	player:setwalkspeed(val)
end, "Sets and auto locks WalkSpeed when above 16")

movesec:createtextbox("Custom WalkSpeed", "16 - 120", "16", function(val)
	local num = tonumber(val)
	if num then
		player:setwalkspeed(num)
	end
end, "Type exact WalkSpeed value")

movesec:createtoggle("SpeedBoost", false, function(state)
	player:togglespeedboost(state)
end, "CFrame movement boost without touching WalkSpeed")

movesec:createslider("Boost Power", 1, 80, 15, function(val)
	player:setspeedboost(val)
end, "Extra movement speed multiplier")

charsec:createslider("JumpPower", 50, 250, 50, function(val)
	player:setjumppower(val)
end, "Sets and auto locks JumpPower when above 50")

charsec:createtextbox("Custom JumpPower", "50 - 250", "50", function(val)
	local num = tonumber(val)
	if num then
		player:setjumppower(num)
	end
end, "Type exact JumpPower value")

charsec:createtoggle("Custom Gravity", false, function(state)
	player:togglegravity(state)
end, "Overrides workspace gravity")

charsec:createslider("Gravity", 10, 300, 196, function(val)
	player:setgravity(val)
end, "Lower value means higher and floatier jumps")

charsec:createtoggle("Infinite Jump", false, function(state)
	player:toggleinfjump(state)
end, "Jump mid-air with safe cooldown")

charsec:createtoggle("Noclip", false, function(state)
	player:togglenoclip(state)
end, "Walk through walls and obstacles")

local propssec = gametab:createsection("Props Protection")

propssec:createtoggle("Disable Banana Peels", false, function(state)
	gamemod:togglebanana(state)
end, "Disables banana touch triggers across the map")

propssec:createtoggle("Disable Red Balls", false, function(state)
	gamemod:toggleredball(state)
end, "Destroys red balls and removes collision")

propssec:createtoggle("Disable Mines", false, function(state)
	gamemod:togglemines(state)
end, "Disables CanTouch on all mines in Minefield")

propssec:createtoggle("Repel Props", false, function(state)
	gamemod:togglerepel(state)
end, "Flings nearby unanchored bananas and red balls away")

local targetsec = funtab:createsection("Target Props")

targetsec:createtextbox("Target Player", "2-3 letters...", "", function(val)
	local matched = gamemod:settarget(val)
	if matched ~= "" then
		lib:notify({
			title = "Target Locked",
			content = matched,
			duration = 2
		})
	end
	return matched
end, "Auto-completes player name or display name by 2-3 letters")

targetsec:createtoggle("Loop TP Props", false, function(state)
	gamemod:toggletpprops(state)
end, "Continuously teleports bananas and red balls to target player")

targetsec:createbutton("TP Props Once", function()
	gamemod:tppropstotarget()
end, "Teleports all current bananas and red balls to target player")

local floorsec = autofarmtab:createsection("Auto Floor")

floorsec:createbutton("Complete Floor", function()
	local ok, msg = autofloor:complete()
	lib:notify({
		title = ok and "AutoFloor" or "AutoFloor Error",
		content = tostring(msg),
		duration = 3
	})
end, "Teleports directly inside WinPart or custom floor target")

local farmsec = autofarmtab:createsection("GPU Farm")

farmsec:createtoggle("Auto Spin GPU", false, function(state)
	gamemod:toggleautogpu(state)
end, "Equips GPU and activates it automatically after cooldown")

local espsec = visualstab:createsection("Info HUD")

espsec:createtoggle("Info Overlay", false, function(state)
	visuals:togglehud(state)
end, "Shows draggable mini-window with floor, timer and BOMi info")

espsec:createtoggle("Notify Next Floor", false, function(state)
	visuals:togglefloornotify(state, function(floorname)
		lib:notify({
			title = "Next Floor",
			content = "loaded: " .. tostring(floorname),
			duration = 4
		})
	end)
end, "Notifies you as soon as the next room loads in workspace")

lib:notify({
	title = "Crescent",
	content = "Loaded successfully",
	duration = 3
})
