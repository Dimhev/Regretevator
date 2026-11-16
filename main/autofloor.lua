local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer

local autofloor = {
	repourl = "https://raw.githubusercontent.com/username/repo/main/autofloors/",
	cache = {},
	utils = {}
}

local function getchar()
	local char = lp.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if char and hrp then
		return char, hrp
	end
	return nil, nil
end

local function tp(target, offset)
	local char = getchar()
	if not char or not target then
		return false
	end

	local targetcf = nil
	if typeof(target) == "Instance" then
		if target:IsA("BasePart") then
			targetcf = target.CFrame
		elseif target:IsA("Model") then
			targetcf = target:GetPivot()
		end
	elseif typeof(target) == "CFrame" then
		targetcf = target
	elseif typeof(target) == "Vector3" then
		targetcf = CFrame.new(target)
	end

	if targetcf then
		if typeof(offset) == "Vector3" then
			targetcf = targetcf + offset
		elseif typeof(offset) == "CFrame" then
			targetcf = targetcf * offset
		end
		char:PivotTo(targetcf)
		return true
	end

	return false
end

local function getcurrentroom()
	local values = workspace:FindFirstChild("Values")
	local curroom = values and values:FindFirstChild("CurrentRoom")
	if not curroom or not curroom.Value then
		return nil, nil
	end

	local val = curroom.Value
	if typeof(val) == "Instance" then
		return val.Name, val
	end

	local name = tostring(val)
	local model = workspace:FindFirstChild(name)
	return name, model
end

autofloor.utils.tp = tp
autofloor.utils.getchar = getchar
autofloor.utils.getcurrentroom = getcurrentroom

local simplefloors = {
	["Superhighway"] = function(room)
		local win = room:FindFirstChild("WinPoint", true)
		if win then
			tp(win, Vector3.new(0, 3, 0))
		end
	end,

	["AnotherSimpleFloor"] = function(room)
		local finish = room:FindFirstChild("FinishPart")
		if finish then
			tp(finish)
		end
	end
}

local complexfloors = {
	["ComplexMaze"] = "mazefloor.lua",
	["HardObby"] = "obbyfloor.lua"
}

local function loadcomplex(filename)
	if autofloor.cache[filename] then
		return autofloor.cache[filename]
	end

	local ok, res = pcall(function()
		return loadstring(game:HttpGet(autofloor.repourl .. filename))()
	end)

	if ok and type(res) == "function" then
		autofloor.cache[filename] = res
		return res
	end

	return nil
end

function autofloor:complete()
	local name, room = getcurrentroom()
	if not name or not room then
		return false, "no active floor"
	end

	if simplefloors[name] then
		task.spawn(simplefloors[name], room)
		return true, name
	end

	local complexfile = complexfloors[name]
	if complexfile then
		local fn = loadcomplex(complexfile)
		if fn then
			task.spawn(fn, room, self.utils)
			return true, name
		end
		return false, "failed to load module"
	end

	local genericwin = room:FindFirstChild("WinPoint", true)
	if genericwin then
		tp(genericwin, Vector3.new(0, 3, 0))
		return true, name .. " (generic)"
	end

	return false, "unsupported floor: " .. tostring(name)
end

return autofloor
