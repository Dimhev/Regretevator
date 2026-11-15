local ws = game:GetService("Workspace")
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")

local lp = plrs.LocalPlayer

local trackedbananas = setmetatable({}, { __mode = "k" })

local gamemod = {
	nobanana = false,
	noredball = false,
	repelprops = false,
	tpprops = false,
	autogpu = false,
	gpurunning = false,
	target = nil,
	wsaddconn = nil,
	wsremconn = nil,
	tpconn = nil,
	plrconn = nil
}

local function isbanana(name)
	return name == "BananaPeel" or name == "bananer"
end

local function isredball(name)
	return name == "RedBall"
end

local function istargetprop(name)
	return isbanana(name) or isredball(name)
end

local function isvalidworldprop(item)
	if not item or not item.Parent then return false end

	if item:IsA("Tool") or item:FindFirstAncestorOfClass("Tool") then
		return false
	end

	for _, plr in ipairs(plrs:GetPlayers()) do
		local char = plr.Character
		if char and (item == char or item:IsDescendantOf(char)) then
			return false
		end
	end

	return true
end

local function disarmparttouch(part)
	if part:IsA("BasePart") then
		part.CanTouch = false
		local ti = part:FindFirstChildOfClass("TouchTransmitter") or part:FindFirstChild("TouchInterest")
		if ti then
			ti:Destroy()
		end
	elseif part:IsA("TouchTransmitter") or part.Name == "TouchInterest" then
		local parent = part.Parent
		if parent and parent:IsA("BasePart") then
			parent.CanTouch = false
		end
		part:Destroy()
	end
end

local function disarmbanana(item)
	if not isvalidworldprop(item) then return end
	disarmparttouch(item)
	for _, desc in ipairs(item:GetDescendants()) do
		disarmparttouch(desc)
	end
end

local function disablecollision(item)
	if item:IsA("BasePart") then
		item.CanTouch = false
		item.CanCollide = false
		item.CanQuery = false
	end
	for _, part in ipairs(item:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanTouch = false
			part.CanCollide = false
			part.CanQuery = false
		end
	end
end

local function destroyprop(item)
	if not isvalidworldprop(item) then return end
	disablecollision(item)
	item:Destroy()
end

local function impulseitem(item)
	if not isvalidworldprop(item) then return end
	local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
	if part and not part.Anchored then
		local dir = Vector3.new(math.random(-180, 180), 450, math.random(-180, 180))
		part.AssemblyLinearVelocity = dir
		part:ApplyImpulse(dir * part.AssemblyMass)
	end
end

local function gettargethrp()
	local trg = gamemod.target
	if not trg or not trg.Parent then
		gamemod.target = nil
		return nil
	end
	local char = trg.Character
	if not char then return nil end
	return char:FindFirstChild("HumanoidRootPart")
end

local function teleportitem(item, hrp)
	if not hrp or not isvalidworldprop(item) then return end
	disablecollision(item)
	if item:IsA("BasePart") and not item.Anchored then
		item.AssemblyLinearVelocity = Vector3.zero
		item.CFrame = hrp.CFrame
	elseif item:IsA("Model") then
		for _, part in ipairs(item:GetDescendants()) do
			if part:IsA("BasePart") and not part.Anchored then
				part.AssemblyLinearVelocity = Vector3.zero
				part.CFrame = hrp.CFrame
			end
		end
	else
		local part = item:FindFirstChildWhichIsA("BasePart", true)
		if part and not part.Anchored then
			part.AssemblyLinearVelocity = Vector3.zero
			part.CFrame = hrp.CFrame
		end
	end
end

local function processprop(item)
	if not isvalidworldprop(item) then
		trackedbananas[item] = nil
		return
	end

	if isbanana(item.Name) then
		trackedbananas[item] = true
		if gamemod.nobanana then
			disarmbanana(item)
		end
		if gamemod.tpprops then
			local hrp = gettargethrp()
			if hrp then
				teleportitem(item, hrp)
				return
			end
		end
		if gamemod.repelprops then
			impulseitem(item)
		end
		return
	end

	if gamemod.tpprops then
		local hrp = gettargethrp()
		if hrp and (isredball(item.Name) or item:IsA("BasePart") or item:FindFirstChildWhichIsA("BasePart", true)) then
			teleportitem(item, hrp)
			return
		end
	end

	if isredball(item.Name) then
		if gamemod.noredball then
			destroyprop(item)
			return
		end
		if gamemod.repelprops then
			impulseitem(item)
		end
	end
end

local function scanlight()
	for _, item in ipairs(ws:GetChildren()) do
		if isbanana(item.Name) and isvalidworldprop(item) then
			processprop(item)
		end
	end

	local props = ws:FindFirstChild("Props")
	if props then
		for _, item in ipairs(props:GetChildren()) do
			processprop(item)
		end
	end

	for banana in pairs(trackedbananas) do
		if isvalidworldprop(banana) then
			if gamemod.nobanana then
				disarmbanana(banana)
			end
		else
			trackedbananas[banana] = nil
		end
	end
end

scanlight()

gamemod.wsaddconn = ws.DescendantAdded:Connect(function(desc)
	local name = desc.Name

	if name == "TouchInterest" or desc:IsA("TouchTransmitter") then
		if gamemod.nobanana then
			local p = desc.Parent
			if p and (isbanana(p.Name) or (p.Parent and isbanana(p.Parent.Name))) and isvalidworldprop(p) then
				task.defer(disarmparttouch, desc)
			end
		end
		return
	end

	if isbanana(name) then
		task.defer(function()
			if isvalidworldprop(desc) then
				trackedbananas[desc] = true
				processprop(desc)
			end
		end)
		return
	end

	local parent = desc.Parent
	if parent and parent.Name == "Props" and parent.Parent == ws then
		task.defer(processprop, desc)
	end
end)

gamemod.wsremconn = ws.DescendantRemoving:Connect(function(desc)
	if trackedbananas[desc] then
		trackedbananas[desc] = nil
	end
end)

gamemod.plrconn = plrs.PlayerRemoving:Connect(function(plr)
	if gamemod.target == plr then
		gamemod.target = nil
	end
end)

function gamemod:toggleautogpu(state)
	self.autogpu = state
	if not state or self.gpurunning then return end

	self.gpurunning = true
	task.spawn(function()
		while self.autogpu do
			local char = lp and lp.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local bp = lp and lp:FindFirstChild("Backpack")

			if char and hum and hum.Health > 0 and not lp:HasTag("Spectators") then
				local gpu = char:FindFirstChild("GenerationProcessingUnit")
				if not gpu and bp then
					local bpgpu = bp:FindFirstChild("GenerationProcessingUnit")
					if bpgpu then
						hum:EquipTool(bpgpu)
						task.wait(1.1)
						gpu = char:FindFirstChild("GenerationProcessingUnit")
					end
				end

				if gpu and gpu.Parent == char then
					gpu:Activate()
				end
			end

			task.wait(0.85)
		end
		self.gpurunning = false
	end)
end

function gamemod:settarget(input)
	local query = tostring(input or ""):gsub("^%s*(.-)%s*$", "%1"):lower()
	if #query < 2 then
		self.target = nil
		return ""
	end

	local prefixmatch = nil
	local submatch = nil

	for _, plr in ipairs(plrs:GetPlayers()) do
		if plr ~= lp then
			local uname = plr.Name:lower()
			local dname = plr.DisplayName:lower()

			if uname:sub(1, #query) == query or dname:sub(1, #query) == query then
				prefixmatch = plr
				break
			elseif not submatch and (uname:find(query, 1, true) or dname:find(query, 1, true)) then
				submatch = plr
			end
		end
	end

	local found = prefixmatch or submatch
	self.target = found
	return found and found.Name or ""
end

function gamemod:tppropstotarget()
	local hrp = gettargethrp()
	if not hrp then return end

	local props = ws:FindFirstChild("Props")
	if props then
		for _, item in ipairs(props:GetChildren()) do
			teleportitem(item, hrp)
		end
	end

	for banana in pairs(trackedbananas) do
		if isvalidworldprop(banana) then
			teleportitem(banana, hrp)
		else
			trackedbananas[banana] = nil
		end
	end
end

function gamemod:toggletpprops(state)
	self.tpprops = state

	if self.tpconn then
		self.tpconn:Disconnect()
		self.tpconn = nil
	end

	if state then
		self:tppropstotarget()
		self.tpconn = rs.Heartbeat:Connect(function()
			if not self.tpprops then return end
			self:tppropstotarget()
		end)
	end
end

function gamemod:togglebanana(state)
	self.nobanana = state
	if not state then return end
	scanlight()
end

function gamemod:toggleredball(state)
	self.noredball = state
	if not state then return end

	local props = ws:FindFirstChild("Props")
	if not props then return end

	for _, item in ipairs(props:GetChildren()) do
		if isredball(item.Name) then
			destroyprop(item)
		end
	end
end

function gamemod:togglerepel(state)
	self.repelprops = state
	if not state then return end

	local props = ws:FindFirstChild("Props")
	if props then
		for _, item in ipairs(props:GetChildren()) do
			if istargetprop(item.Name) then
				impulseitem(item)
			end
		end
	end

	for banana in pairs(trackedbananas) do
		if isvalidworldprop(banana) then
			impulseitem(banana)
		else
			trackedbananas[banana] = nil
		end
	end
end

function gamemod:destroy()
	self.tpprops = false
	self.autogpu = false
	self.target = nil

	if self.wsaddconn then
		self.wsaddconn:Disconnect()
		self.wsaddconn = nil
	end
	if self.wsremconn then
		self.wsremconn:Disconnect()
		self.wsremconn = nil
	end
	if self.tpconn then
		self.tpconn:Disconnect()
		self.tpconn = nil
	end
	if self.plrconn then
		self.plrconn:Disconnect()
		self.plrconn = nil
	end

	table.clear(trackedbananas)
end

return gamemod
