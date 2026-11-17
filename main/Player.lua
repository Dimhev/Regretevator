local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local ws = game:GetService("Workspace")

local lp = plrs.LocalPlayer
local defgrav = ws.Gravity
local lastjump = 0

local origcollide = setmetatable({}, { __mode = "k" })
local origjump = setmetatable({}, { __mode = "k" })

local player = {
	booststate = false,
	boostval = 15,
	jpactive = false,
	jpval = 50,
	gravstate = false,
	gravval = 196,
	infjump = false,
	jumpcd = 0.18,
	noclip = false,
	hbconn = nil,
	stepconn = nil,
	jumpconn = nil
}

local function savejumpdefaults(hum)
	if not origjump[hum] then
		origjump[hum] = {
			usejp = hum.UseJumpPower,
			jp = hum.JumpPower
		}
	end
end

local function restorejump(hum)
	local data = origjump[hum]
	if data then
		hum.UseJumpPower = data.usejp
		hum.JumpPower = data.jp
		origjump[hum] = nil
	end
end

local function restorenoclip()
	for part, state in pairs(origcollide) do
		if part and part.Parent then
			part.CanCollide = state
		end
		origcollide[part] = nil
	end
end

function player:togglespeedboost(state)
	self.booststate = (state == true)
end

function player:setspeedboost(val)
	local num = tonumber(val)
	if not num then return end
	self.boostval = math.clamp(num, 1, 80)
end

function player:setjumppower(val)
	local num = tonumber(val)
	if not num then return end

	num = math.clamp(num, 50, 250)
	self.jpval = num
	self.jpactive = (num > 50)

	local chr = lp and lp.Character
	local hum = chr and chr:FindFirstChildOfClass("Humanoid")
	if hum then
		if self.jpactive then
			savejumpdefaults(hum)
			hum.UseJumpPower = true
			hum.JumpPower = num
		else
			restorejump(hum)
		end
	end
end

function player:togglegravity(state)
	self.gravstate = (state == true)
	ws.Gravity = self.gravstate and self.gravval or defgrav
end

function player:setgravity(val)
	local num = tonumber(val)
	if not num then return end

	self.gravval = math.clamp(num, 10, 300)
	if self.gravstate then
		ws.Gravity = self.gravval
	end
end

function player:toggleinfjump(state)
	self.infjump = (state == true)
end

function player:togglenoclip(state)
	self.noclip = (state == true)
	if not self.noclip then
		restorenoclip()
	end
end

player.hbconn = rs.Heartbeat:Connect(function()
	local chr = lp and lp.Character
	if not chr then return end

	local hum = chr:FindFirstChildOfClass("Humanoid")
	local hrp = chr:FindFirstChild("HumanoidRootPart")

	if hum then
		if player.jpactive then
			savejumpdefaults(hum)
			if not hum.UseJumpPower then
				hum.UseJumpPower = true
			end
			if hum.JumpPower ~= player.jpval then
				hum.JumpPower = player.jpval
			end
		end

		if player.booststate and hrp then
			local dir = hum.MoveDirection
			if dir.Magnitude > 0 then
				local vel = hrp.AssemblyLinearVelocity
				local targetspeed = hum.WalkSpeed + player.boostval
				hrp.AssemblyLinearVelocity = Vector3.new(dir.X * targetspeed, vel.Y, dir.Z * targetspeed)
			end
		end
	end

	if player.gravstate and ws.Gravity ~= player.gravval then
		ws.Gravity = player.gravval
	end
end)

player.stepconn = rs.Stepped:Connect(function()
	if not player.noclip then return end
	local chr = lp and lp.Character
	if not chr then return end

	for _, part in ipairs(chr:GetDescendants()) do
		if part:IsA("BasePart") then
			if origcollide[part] == nil then
				origcollide[part] = part.CanCollide
			end
			if part.CanCollide then
				part.CanCollide = false
			end
		end
	end
end)

player.jumpconn = uis.JumpRequest:Connect(function()
	if not player.infjump then return end
	local now = tick()
	if now - lastjump < player.jumpcd then return end

	local chr = lp and lp.Character
	local hum = chr and chr:FindFirstChildOfClass("Humanoid")
	if hum and hum.Health > 0 then
		lastjump = now
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

function player:destroy()
	self.booststate = false
	self.jpactive = false
	self.gravstate = false
	self.infjump = false
	self.noclip = false

	if self.hbconn then
		self.hbconn:Disconnect()
		self.hbconn = nil
	end
	if self.stepconn then
		self.stepconn:Disconnect()
		self.stepconn = nil
	end
	if self.jumpconn then
		self.jumpconn:Disconnect()
		self.jumpconn = nil
	end

	ws.Gravity = defgrav
	restorenoclip()

	local chr = lp and lp.Character
	local hum = chr and chr:FindFirstChildOfClass("Humanoid")
	if hum then
		restorejump(hum)
	end
end

return player
