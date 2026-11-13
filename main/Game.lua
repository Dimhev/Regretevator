local ws = game:GetService("Workspace")

local gamemod = {
	nobanana = false,
	noredball = false,
	repelprops = false,
	propsconn = nil,
	wsconn = nil
}

local function isbanana(name)
	return name == "BananaPeel" or name == "bananer"
end

local function isredball(name)
	return name == "RedBall"
end

local function setitemtouch(item, cantouch)
	if item:IsA("BasePart") then
		item.CanTouch = cantouch
	end
	for idx, part in ipairs(item:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanTouch = cantouch
		end
	end
end

local function impulseitem(item)
	local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
	if part and not part.Anchored then
		local dir = Vector3.new(math.random(-180, 180), 450, math.random(-180, 180))
		part.AssemblyLinearVelocity = dir
		part:ApplyImpulse(dir * part.AssemblyMass)
	end
end

local function processprop(item)
	if isbanana(item.Name) then
		if gamemod.nobanana then
			setitemtouch(item, false)
		end
		if gamemod.repelprops then
			impulseitem(item)
		end
	elseif isredball(item.Name) then
		if gamemod.noredball then
			setitemtouch(item, false)
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

	gamemod.propsconn = props.ChildAdded:Connect(function(item)
		task.wait(0.05)
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

function gamemod:togglebanana(state)
	self.nobanana = state
	local props = ws:FindFirstChild("Props")
	if not props then return end

	for idx, item in ipairs(props:GetChildren()) do
		if isbanana(item.Name) then
			setitemtouch(item, not state)
		end
	end
end

function gamemod:toggleredball(state)
	self.noredball = state
	local props = ws:FindFirstChild("Props")
	if not props then return end

	for idx, item in ipairs(props:GetChildren()) do
		if isredball(item.Name) then
			setitemtouch(item, not state)
		end
	end
end

function gamemod:togglerepel(state)
	self.repelprops = state
	if not state then return end

	local props = ws:FindFirstChild("Props")
	if not props then return end

	for idx, item in ipairs(props:GetChildren()) do
		if isbanana(item.Name) or isredball(item.Name) then
			impulseitem(item)
		end
	end
end

function gamemod:destroy()
	if self.propsconn then
		self.propsconn:Disconnect()
		self.propsconn = nil
	end
	if self.wsconn then
		self.wsconn:Disconnect()
		self.wsconn = nil
	end
end

return gamemod
