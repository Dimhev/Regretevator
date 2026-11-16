local ws = game:GetService("Workspace")
local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer

local autofloor = {}

local ignorednames = {
	["Terrain"] = true,
	["Camera"] = true,
	["Props"] = true,
	["Values"] = true,
	["Elevator"] = true,
	["Lobby"] = true
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
	local char, hrp = getchar()
	if not char or not hrp or not target then
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
		hrp.AssemblyLinearVelocity = Vector3.zero
		hrp.CFrame = targetcf
		return true
	end

	return false
end

local function isplayerchar(inst)
	for _, plr in ipairs(plrs:GetPlayers()) do
		if plr.Character == inst then
			return true
		end
	end
	return false
end

local function findwinpart(room)
	if not room then return nil end

	local direct = room:FindFirstChild("WinPart") or room:FindFirstChild("WinPoint")
	if direct then return direct end

	local build = room:FindFirstChild("Build")
	if build then
		local bwin = build:FindFirstChild("WinPart") or build:FindFirstChild("WinPoint")
		if bwin then return bwin end
	end

	return room:FindFirstChild("WinPart", true) or room:FindFirstChild("WinPoint", true)
end

local customfloors = {
	["SLIDE_9999999999_FEET_DOWN_RAINBOW"] = function(room)
		local build = room:FindFirstChild("Build")
		local target = build and build:FindFirstChild("Target")
		local ring = (target and target:FindFirstChild("MiddleRing")) or room:FindFirstChild("MiddleRing", true)
		if ring then
			return tp(ring)
		end
		return false
	end
}

local function getcurrentroom()
	local values = ws:FindFirstChild("Values")
	local curroom = values and values:FindFirstChild("CurrentRoom")
	if curroom and curroom.Value then
		local val = curroom.Value
		if typeof(val) == "Instance" then
			return val.Name, val
		end
		local name = tostring(val)
		local model = ws:FindFirstChild(name)
		if model then
			return name, model
		end
	end

	for _, child in ipairs(ws:GetChildren()) do
		if (child:IsA("Model") or child:IsA("Folder")) and not ignorednames[child.Name] and not isplayerchar(child) then
			if customfloors[child.Name] or findwinpart(child) then
				return child.Name, child
			end
		end
	end

	return nil, nil
end

function autofloor:complete()
	local name, room = getcurrentroom()
	if not name or not room then
		return false, "Floor with WinPart not found"
	end

	if customfloors[name] then
		if customfloors[name](room) then
			return true, "Completed: " .. name
		end
		return false, "Target part not found on: " .. name
	end

	local win = findwinpart(room)
	if win then
		if tp(win) then
			return true, "Completed: " .. name
		end
	end

	return false, "Unsupported floor: " .. tostring(name)
end

return autofloor
