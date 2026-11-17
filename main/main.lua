local base = "https://raw.githubusercontent.com/Dimhev/Regretevator/refs/heads/main/main/"

local function loadmodule(file)
    local ok, src = pcall(function()
        return game:HttpGet(base .. file)
    end)
    if not ok or type(src) ~= "string" or #src < 5 then
        warn("[Crescent] Failed to fetch: " .. tostring(file))
        return nil
    end

    local fn, err = loadstring(src)
    if type(fn) ~= "function" then
        warn("[Crescent] Syntax error in " .. tostring(file) .. ": " .. tostring(err))
        return nil
    end

    local runok, res = pcall(fn)
    if not runok then
        warn("[Crescent] Runtime error in " .. tostring(file) .. ": " .. tostring(res))
        return nil
    end

    return res
end

local env = (type(getgenv) == "function" and getgenv()) or _G
if env.CrescentCleanup then
    pcall(env.CrescentCleanup)
end

local lib = loadmodule("lib.lua")
local player = loadmodule("Player.lua")
local gamemod = loadmodule("Game.lua")
local visuals = loadmodule("Visuals.lua")
local autofloor = loadmodule("AutoFloor.lua")
local autofarm = loadmodule("AutoFarm.lua")

if not (lib and player and gamemod and visuals and autofloor and autofarm) then
    warn("[Crescent] Initialization aborted: one or more modules failed to load")
    return
end

env.CrescentCleanup = function()
    if player and player.destroy then pcall(player.destroy, player) end
    if gamemod and gamemod.destroy then pcall(gamemod.destroy, gamemod) end
    if autofarm and autofarm.destroy then pcall(autofarm.destroy, autofarm) end
    local vclean = visuals and (visuals.destroy or visuals.unload)
    if vclean then pcall(vclean, visuals) end
end

local window = lib:createwindow()

local playertab = window:createtab("Player")
local gametab = window:createtab("Game")
local funtab = window:createtab("Fun")
local autofarmtab = window:createtab("AutoFarm")
local visualstab = window:createtab("Visuals")

local movesec = playertab:createsection("Movement")
local charsec = playertab:createsection("Character")

movesec:createtoggle("SpeedBoost", false, function(state)
    player:togglespeedboost(state)
end, "Physics-based horizontal velocity boost without clipping through walls")

movesec:createslider("Boost Power", 1, 80, 15, function(val)
    player:setspeedboost(val)
end, "Extra horizontal speed added to base movement (1 - 80)")

movesec:createtextbox("Custom Boost Power", "1 - 80", "15", function(val)
    local num = tonumber(val)
    if num then
        player:setspeedboost(num)
    end
end, "Type exact Boost Power value")

charsec:createslider("JumpPower", 50, 250, 50, function(val)
    player:setjumppower(val)
end, "Sets and locks JumpPower when above 50 (restores default at 50)")

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
end, "Walk through walls and restore exact collisions when disabled")

local propssec = gametab:createsection("Props Protection")

propssec:createtoggle("Disable Banana Peels", false, function(state)
    gamemod:togglebanana(state)
end, "Disables banana touch triggers across the map")

propssec:createtoggle("Disable Red Balls", false, function(state)
    gamemod:toggleredball(state)
end, "Destroys red balls and removes collision")

propssec:createtoggle("Disable Purple Balls", false, function(state)
    gamemod:togglepurpleball(state)
end, "Destroys purple balls and removes collision")

propssec:createtoggle("Disable Mines", false, function(state)
    gamemod:togglemines(state)
end, "Disables CanTouch on all mines in Minefield")

propssec:createtoggle("Repel Props", false, function(state)
    gamemod:togglerepel(state)
end, "Flings nearby bananas, red balls and purple balls away")

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
end, "Continuously teleports bananas, red balls and purple balls to target player")

targetsec:createbutton("TP Props Once", function()
    gamemod:tppropstotarget()
end, "Teleports all current bananas, red balls and purple balls to target player")

local floorsec = autofarmtab:createsection("Auto Floor")

floorsec:createbutton("Complete Floor", function()
    local ok, msg = autofloor:complete()
    lib:notify({
        title = ok and "AutoFloor" or "AutoFloor Error",
        content = tostring(msg),
        duration = 3
    })
end, "Teleports directly inside WinPart or custom floor target")

floorsec:createbutton("Elevator SafeSpot", function()
    local ok, msg = autofloor:safespot()
    lib:notify({
        title = ok and "SafeSpot" or "SafeSpot Error",
        content = tostring(msg),
        duration = 2
    })
end, "Teleports on top of workspace.Elevator.Ceiling.Concrete")

local farmfloorsec = autofarmtab:createsection("Floors")

farmfloorsec:createtoggle("Auto Farm Bugbo Rocks", false, function(state)
    autofarm:togglebugborocks(state)
end, "Automatically teleports to Rocks on bugbo floor and triggers PickUpRock")

farmfloorsec:createbutton("Farm Bugbo Rocks Once", function()
    task.spawn(function()
        local ok, msg = autofarm:farmbugboonce()
        lib:notify({
            title = ok and "Bugbo Farm" or "Bugbo Farm Error",
            content = tostring(msg),
            duration = 3
        })
    end)
end, "Collects all rocks on bugbo floor right now")

local farmsec = autofarmtab:createsection("GPU Farm")

farmsec:createtoggle("Auto Spin GPU", false, function(state)
    autofarm:toggleautogpu(state)
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
