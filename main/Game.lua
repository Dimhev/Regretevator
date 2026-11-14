local ws = game:GetService("Workspace")
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")

local lp = plrs.LocalPlayer

local gamemod = {
	nobanana = false,
	noredball = false,
	repelprops = false,
	tpprops = false,
	autogpu = false,
	gpurunning = false,
	target = nil,
	propsconn = nil,
	wsconn = nil,
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

local function disablecollision(item)
	if item:IsA("BasePart") then
		item.CanTouch = false
		item.CanCollide = false
		item.CanQuery = false
	end
	for idx, part in ipairs(item:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanTouch = false
			part.CanCollide = false
			part.CanQuery = false
		end
	end
end

local function destroyprop(item)
	if not item or not item.Parent then return end
	disablecollision(item)
	item:Destroy()
end

local function impulseitem(item)
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
	if not hrp then return end
	disablecollision(item)
	if item:IsA("BasePart") and not item.Anchored then
		item.AssemblyLinearVelocity = Vector3.zero
		item.CFrame = hrp.CFrame
	elseif item:IsA("Model") then
		for idx, part in ipairs(item:GetDescendants()) do
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
	if not item or not item.Parent then return end

	if gamemod.tpprops then
		local hrp = gettargethrp()
		if hrp and (istargetprop(item.Name) or item:IsA("BasePart") or item:FindFirstChildWhichIsA("BasePart", true)) then
			teleportitem(item, hrp)
			return
		end
	end

	if isbanana(item.Name) then
		if gamemod.nobanana then
			destroyprop(item)
			return
		end
		if gamemod.repelprops then
			impulseitem(item)
		end
	elseif isredball(item.Name) then
		if gamemod.noredball then
			destroyprop(item)
			return
		end
		if gamemod.repelprops then
			impulseitem(item)
		end
	end
end

local function hookprops(props)
	if gamemod.propsconn then
		gamemod.propsconn:Disconnect()
		gamemod.propsconn = nil
	end
	if not props then return end

	for idx, item in ipairs(props:GetChildren()) do
		task.spawn(processprop, item)
	end

	gamemod.propsconn = props.ChildAdded:Connect(function(item)
		task.wait()
		if item and item.Parent then
			processprop(item)
		end
	end)
end

hookprops(ws:FindFirstChild("Props"))

gamemod.wsconn = ws.ChildAdded:Connect(function(child)
	if child.Name == "Props" then
		hookprops(child)
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
						task.wait(1.05)
						gpu = char:FindFirstChild("GenerationProcessingUnit")
					end
				end

				if gpu and gpu.Parent == char then
					gpu:Activate()
				end
			end

			task.wait(0.15)
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

	for idx, plr in ipairs(plrs:GetPlayers()) do
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
	if not props then return end

	for idx, item in ipairs(props:GetChildren()) do
		teleportitem(item, hrp)
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

	local props = ws:FindFirstChild("Props")
	if not props then return end

	for idx, item in ipairs(props:GetChildren()) do
		if isbanana(item.Name) then
			destroyprop(item)
		end
	end
end

function gamemod:toggleredball(state)
	self.noredball = state
	if not state then return end

	local props = ws:FindFirstChild("Props")
	if not props then return end

	for idx, item in ipairs(props:GetChildren()) do
		if isredball(item.Name) then
			destroyprop(item)
		end
	end
end

function gamemod:togglerepel(state)
	self.repelprops = state
	if not state then return end

	local props = ws:FindFirstChild("Props")
	if not props then return end

	for idx, item in ipairs(props:GetChildren()) do
		if istargetprop(item.Name) then
			impulseitem(item)
		end
	end
end

function gamemod:destroy()
	self.tpprops = false
	self.autogpu = false
	self.target = nil

	if self.propsconn then
		self.propsconn:Disconnect()
		self.propsconn = nil
	end
	if self.wsconn then
		self.wsconn:Disconnect()
		self.wsconn = nil
	end
	if self.tpconn then
		self.tpconn:Disconnect()
		self.tpconn = nil
	end
	if self.plrconn then
		self.plrconn:Disconnect()
		self.plrconn = nil
	end
end

return gamemod
