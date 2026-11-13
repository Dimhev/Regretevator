local url = "https://raw.githubusercontent.com/Dimhev/Regretevator/refs/heads/main/main/lib.lua"
local lib = loadstring(game:HttpGet(url))()

local win = lib:CreateWindow()

local tbmn = win:CreateTab("main")

local sectst = tbmn:CreateSection("test")

sectst:CreateButton("test button", function()
	lib:Notify({
		Title = "crescent",
		Content = "script loaded",
		Duration = 3
	})
end, "click to test")
