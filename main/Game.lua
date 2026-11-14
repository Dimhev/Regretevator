local ws = game:GetService("Workspace")
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")

local lp = plrs.LocalPlayer
local fti = firetouchinterest

local gamemod = {
	nobanana = false,
	noredball = false,
	repelprops = false,
	tpprops = false,
	autocoins = false,
	target = nil,
	propsconn = nil,
	wsconn = nil,
	tpconn = nil,
	plrconn = nil,
	coinconn = nil,
	coinaddconn = nil,
	coinslist = setmetatable({}, { __mode = "k" })
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

local function getlphrp()
	local char = lp and lp.Character
	if not char then return nil end
	return char:FindFirstChild("HumanoidRootPart")
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

local function isinsidecoins(obj)
	local parent = obj.Parent
	while parent and parent ~= ws do
		if parent.Name == "Coins" then
			return true
		end
		parent = parent.Parent
	end
	return false
end

local function registercoin(obj)
	if obj:IsA("BasePart") then
		obj.CanCollide = false
		gamemod.coinslist[obj] = true
	end
end

local function registercoincontainer(container)
	for idx, desc in ipairs(container:GetDescendants()) do
		registercoin(desc)
	end
end

local function scancoins()
	table.clear(gamemod.coinslist)
	for idx, obj in ipairs(ws:GetDescendants()) do
		if obj.Name == "Coins" then
			registercoincontainer(obj)
		end
	end
end

local function pullcoin(part, hrp, instant)
	if not part or not part.Parent then
		gamemod.coinslist[part] = nil
		return
	end

	part.CanCollide = false
	if not part.Anchored then
		part.AssemblyLinearVelocity = Vector3.zero
	end

	if instant then
		part.CFrame = hrp.CFrame
	else
		local dist = (part.Position - hrp.Position).Magnitude
		if dist < 5 then
			part.CFrame = hrp.CFrame
		else
			part.CFrame = part.CFrame:Lerp(hrp.CFrame, 0.35)
		end
	end

	if fti then
		pcall(fti, hrp, part, 0)
		pcall(fti, hrp, part, 1)
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

function gamemod:collectcoinsonce()
	scancoins()
	local hrp = getlphrp()
	if not hrp then return end

	for part in pairs(self.coinslist) do
		pullcoin(part, hrp, true)
	end
end

function gamemod:toggleautocoins(state)
	self.autocoins = state

	if self.coinconn then
		self.coinconn:Disconnect()
		self.coinconn = nil
	end
	if self.coinaddconn then
		self.coinaddconn:Disconnect()
		self.coinaddconn = nil
	end
	table.clear(self.coinslist)

	if not state then return end

	scancoins()

	self.coinaddconn = ws.DescendantAdded:Connect(function(desc)
		if not self.autocoins then return end
		if desc.Name == "Coins" then
			task.wait()
			if desc and desc.Parent then
				registercoincontainer(desc)
			end
		elseif desc:IsA("BasePart") and isinsidecoins(desc) then
			registercoin(desc)
		end
	end)

	self.coinconn = rs.Heartbeat:Connect(function()
		if not self.autocoins then return end
		local hrp = getlphrp()
		if not hrp then return end

		for part in pairs(self.coinslist) do
			pullcoin(part, hrp, false)
		end
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
	self.autocoins = false
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
	if self.coinconn then
		self.coinconn:Disconnect()
		self.coinconn = nil
	end
	if self.coinaddconn then
		self.coinaddconn:Disconnect()
		self.coinaddconn = nil
	end
	table.clear(self.coinslist)
end

return gamemod
