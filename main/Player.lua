local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local ws = game:GetService("Workspace")

local lp = plrs.LocalPlayer
local defgrav = ws.Gravity

local player = {
	wsstate = false,
	wsval = 16,
	booststate = false,
	boostval = 15,
	jpstate = false,
	jpval = 50,
	gravstate = false,
	gravval = 196,
	infjump = false,
	noclip = false
}

function player:togglewalkspeed(state)
	self.wsstate = state
	local chr = lp.Character
	local hum = chr and chr:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = state and self.wsval or 16
	end
end

function player:setwalkspeed(val)
	self.wsval = val
	if self.wsstate then
		local chr = lp.Character
		local hum = chr and chr:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = val
		end
	end
end

function player:togglespeedboost(state)
	self.booststate = state
end

function player:setspeedboost(val)
	self.boostval = val
end

function player:togglejumppower(state)
	self.jpstate = state
	local chr = lp.Character
	local hum = chr and chr:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.UseJumpPower = true
		hum.JumpPower = state and self.jpval or 50
	end
end

function player:setjumppower(val)
	self.jpval = val
	if self.jpstate then
		local chr = lp.Character
		local hum = chr and chr:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.UseJumpPower = true
			hum.JumpPower = val
		end
	end
end

function player:togglegravity(state)
	self.gravstate = state
	ws.Gravity = state and self.gravval or defgrav
end

function player:setgravity(val)
	self.gravval = val
	if self.gravstate then
		ws.Gravity = val
	end
end

function player:toggleinfjump(state)
	self.infjump = state
end

function player:togglenoclip(state)
	self.noclip = state
	if not state then
		local chr = lp.Character
		if chr then
			for idx, part in ipairs(chr:GetDescendants()) do
				if part:IsA("BasePart") and (part.Name == "HumanoidRootPart" or part.Name == "Torso" or part.Name == "UpperTorso" or part.Name == "LowerTorso") then
					part.CanCollide = true
				end
			end
		end
	end
end

rs.Heartbeat:Connect(function(dt)
	local chr = lp.Character
	if not chr then return end

	local hum = chr:FindFirstChildOfClass("Humanoid")
	local hrp = chr:FindFirstChild("HumanoidRootPart")

	if hum then
		if player.wsstate and hum.WalkSpeed ~= player.wsval then
			hum.WalkSpeed = player.wsval
		end

		if player.jpstate then
			if not hum.UseJumpPower then
				hum.UseJumpPower = true
			end
			if hum.JumpPower ~= player.jpval then
				hum.JumpPower = player.jpval
			end
		end

		if player.booststate and hrp and hum.MoveDirection.Magnitude > 0 then
			hrp.CFrame = hrp.CFrame + (hum.MoveDirection * player.boostval * dt)
		end
	end

	if player.gravstate and ws.Gravity ~= player.gravval then
		ws.Gravity = player.gravval
	end
end)

rs.Stepped:Connect(function()
	if not player.noclip then return end
	local chr = lp.Character
	if not chr then return end

	for idx, part in ipairs(chr:GetDescendants()) do
		if part:IsA("BasePart") and part.CanCollide then
			part.CanCollide = false
		end
	end
end)

uis.JumpRequest:Connect(function()
	if not player.infjump then return end
	local chr = lp.Character
	local hum = chr and chr:FindFirstChildOfClass("Humanoid")
	if hum then
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

return player
