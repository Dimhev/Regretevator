local url = "https://raw.githubusercontent.com/Dimhev/Regretevator/refs/heads/main/main/lib.lua"
local lib = loadstring(game:HttpGet(url))()

local window = lib:createwindow()
local maintab = window:createtab("main")
local testsection = maintab:createsection("controls")

testsection:createbutton("test notify", function()
	lib:notify({
		title = "crescent",
		content = "monochrome ui loaded",
		duration = 3
	})
end, "send test notification")

testsection:createtoggle("test toggle", false, function(state)
	print(state)
end, "toggle example")

testsection:createslider("test slider", 0, 100, 50, function(val)
	print(val)
end, "slider example")
