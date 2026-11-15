local cg = game:GetService("CoreGui")
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local rep = game:GetService("ReplicatedStorage")
local cs = game:GetService("CollectionService")

local lp = plrs.LocalPlayer

local visuals = {
	hudenabled = false,
	notifyfloor = false,
	notifycallback = nil,
	coinespenabled = false,
	coinesptag = "Coin",
	coinespcolor = Color3.fromRGB(255, 215, 80),
	cointracked = {},
	coinconnections = {},
	connections = {}
}

local thm = {
	bg = Color3.fromRGB(12, 12, 14),
	crd = Color3.fromRGB(15, 15, 17),
	crdstk = Color3.fromRGB(32, 32, 36),
	crddiv = Color3.fromRGB(25, 25, 28),
	acc = Color3.fromRGB(245, 245, 250),
	txtpri = Color3.fromRGB(245, 245, 250),
	txtsec = Color3.fromRGB(180, 180, 188),
	txtmut = Color3.fromRGB(110, 110, 118)
}

local function create(classname, properties)
	local inst = Instance.new(classname)
	for prop, val in pairs(properties or {}) do
		inst[prop] = val
	end
	return inst
end

local BomiSpawnShared = nil
local ServerTime = nil
pcall(function()
	BomiSpawnShared = require(rep:WaitForChild("Scripts", 5):WaitForChild("BomiSpawn", 5):WaitForChild("BomiSpawnShared", 5))
	ServerTime = require(rep:WaitForChild("Scripts", 5):WaitForChild("ServerTime", 5))
end)

local function formattime(seconds)
	seconds = math.max(seconds or 0, 0)
	local ms = math.floor((seconds - math.floor(seconds)) * 100)
	return string.format("%02d:%02d.%02d", math.floor(seconds / 60), math.floor(seconds % 60), ms)
end

local function formatbomitimer(seconds)
	seconds = math.max(math.floor(seconds or 0), 0)
	local h = math.floor(seconds / 3600)
	local m = math.floor((seconds % 3600) / 60)
	local s = seconds % 60
	if h > 0 then
		return string.format("%dh %dm", h, m)
	elseif m > 0 then
		return string.format("%dm %ds", m, s)
	else
		return string.format("%ds", s)
	end
end

local function getcurrentroomname()
	local values = workspace:FindFirstChild("Values")
	local curroom = values and values:FindFirstChild("CurrentRoom")
	if not curroom then
		return "none"
	end
	local val = curroom.Value
	if typeof(val) == "Instance" then
		return string.lower(val.Name)
	elseif val ~= nil and tostring(val) ~= "" then
		return string.lower(tostring(val))
	end
	return "elevator"
end

local oldgui = cg:FindFirstChild("crescenthudgui")
if oldgui then
	oldgui:Destroy()
end

local oldesp = cg:FindFirstChild("crescentcoinesp")
if oldesp then
	oldesp:Destroy()
end

local gui = create("ScreenGui", {
	Name = "crescenthudgui",
	Parent = cg,
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local espcontainer = create("Folder", {
	Name = "crescentcoinesp",
	Parent = cg
})

local hudframe = create("Frame", {
	Name = "infohud",
	Position = UDim2.new(0, 16, 0, 50),
	Size = UDim2.new(0, 225, 0, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundColor3 = thm.bg,
	BorderSizePixel = 0,
	Visible = false,
	Parent = gui
})

local hudscale = create("UIScale", {
	Scale = 1.35,
	Parent = hudframe
})

create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = hudframe })
create("UIStroke", {
	Color = thm.crdstk,
	Thickness = 1,
	ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	Parent = hudframe
})
create("UIPadding", {
	PaddingTop = UDim.new(0, 8),
	PaddingBottom = UDim.new(0, 8),
	PaddingLeft = UDim.new(0, 10),
	PaddingRight = UDim.new(0, 10),
	Parent = hudframe
})
create("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 5),
	Parent = hudframe
})

local header = create("TextLabel", {
	LayoutOrder = 1,
	Size = UDim2.new(1, 0, 0, 14),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = "crescent  |  floor info",
	TextColor3 = thm.acc,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = hudframe
})

create("Frame", {
	LayoutOrder = 2,
	Size = UDim2.new(1, 0, 0, 1),
	BackgroundColor3 = thm.crddiv,
	BorderSizePixel = 0,
	Parent = hudframe
})

local function createrow(order, title)
	local row = create("Frame", {
		LayoutOrder = order,
		Size = UDim2.new(1, 0, 0, 15),
		BackgroundTransparency = 1,
		Parent = hudframe
	})
	create("TextLabel", {
		Size = UDim2.new(0.42, 0, 1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		Text = string.lower(title),
		TextColor3 = thm.txtmut,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row
	})
	local val = create("TextLabel", {
		Position = UDim2.new(0.42, 0, 0, 0),
		Size = UDim2.new(0.58, 0, 1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		Text = "...",
		TextColor3 = thm.txtsec,
		TextSize = 11,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = row
	})
	return val, row
end

local roomval = createrow(3, "floor:")
local timerval = createrow(4, "timer:")
local swval, swrow = createrow(5, "stopwatch:")
local bomival = createrow(6, "bomi:")

local dragging = false
local dragstart = nil
local startpos = nil

table.insert(visuals.connections, hudframe.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragstart = input.Position
		startpos = hudframe.Position
		local endconn
		endconn = input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				if endconn then
					endconn:Disconnect()
				end
			end
		end)
	end
end))

table.insert(visuals.connections, uis.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragstart
		hudframe.Position = UDim2.new(
			startpos.X.Scale,
			startpos.X.Offset + delta.X,
			startpos.Y.Scale,
			startpos.Y.Offset + delta.Y
		)
	end
end))

local cachedbomi = nil
local lastbomicheck = 0

local function updatebomi()
	if not BomiSpawnShared or not ServerTime then
		bomival.Text = "unavailable"
		return
	end
	local now = ServerTime.Now()
	if not cachedbomi or now >= (cachedbomi.MoveTimestamp or 0) or (tick() - lastbomicheck > 5) then
		lastbomicheck = tick()
		pcall(function()
			cachedbomi = BomiSpawnShared.GetBomiSpawnForPlayer(lp)
		end)
	end
	if cachedbomi then
		local fname = string.lower(tostring(cachedbomi.FloorProperName or cachedbomi.FloorName or "unknown"))
		local rem = formatbomitimer((cachedbomi.MoveTimestamp or now) - now)
		bomival.Text = fname .. " (" .. rem .. ")"
	else
		bomival.Text = "none"
	end
end

table.insert(visuals.connections, rs.RenderStepped:Connect(function()
	if not visuals.hudenabled then
		return
	end

	roomval.Text = getcurrentroomname()

	local srvnow = workspace:GetServerTimeNow()
	local floorend = workspace:GetAttribute("FloorTimestampEnd")
	if floorend and floorend > srvnow then
		timerval.Text = formattime(floorend - srvnow)
		timerval.TextColor3 = thm.txtpri
	else
		timerval.Text = "00:00.00"
		timerval.TextColor3 = thm.txtsec
	end

	local char = lp.Character
	local mgstart = char and char:GetAttribute("MinigameTimestampStart")
	local mgend = char and char:GetAttribute("MinigameTimestampEnd")
	if mgstart or mgend then
		swrow.Visible = true
		local mgtime = 0
		if mgstart and mgend then
			mgtime = mgend - mgstart
		elseif mgend then
			mgtime = mgend - srvnow
		elseif mgstart then
			mgtime = srvnow - mgstart
		end
		swval.Text = formattime(mgtime)
	else
		swrow.Visible = false
	end

	updatebomi()
end))

local function setupfloorwatcher()
	local values = workspace:WaitForChild("Values", 10)
	local curroom = values and values:WaitForChild("CurrentRoom", 10)
	if curroom then
		table.insert(visuals.connections, curroom:GetPropertyChangedSignal("Value"):Connect(function()
			if visuals.notifyfloor and visuals.notifycallback then
				local rname = getcurrentroomname()
				if rname ~= "none" and rname ~= "elevator" then
					visuals.notifycallback(rname)
				end
			end
		end))
	end
end
task.spawn(setupfloorwatcher)

local function removecoinesp(obj)
	local data = visuals.cointracked[obj]
	if not data then
		return
	end
	visuals.cointracked[obj] = nil
	for _, conn in ipairs(data.conns) do
		conn:Disconnect()
	end
	if data.hl then
		data.hl:Destroy()
	end
	if data.bb then
		data.bb:Destroy()
	end
end

local function addcoinesp(obj)
	if not visuals.coinespenabled or visuals.cointracked[obj] then
		return
	end
	if not obj:IsDescendantOf(workspace) then
		return
	end

	local hl = create("Highlight", {
		Adornee = obj,
		FillColor = visuals.coinespcolor,
		OutlineColor = Color3.fromRGB(255, 255, 255),
		FillTransparency = 0.4,
		OutlineTransparency = 0.1,
		DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
		Parent = espcontainer
	})

	local bb = create("BillboardGui", {
		Adornee = obj,
		Size = UDim2.new(0, 60, 0, 20),
		StudsOffset = Vector3.new(0, 1.5, 0),
		AlwaysOnTop = true,
		Parent = espcontainer
	})

	create("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		Text = "coin",
		TextColor3 = visuals.coinespcolor,
		TextStrokeTransparency = 0.2,
		TextSize = 11,
		Parent = bb
	})

	local conns = {}
	table.insert(conns, obj.Destroying:Connect(function()
		removecoinesp(obj)
	end))
	table.insert(conns, obj.AncestryChanged:Connect(function(_, parent)
		if not parent or not obj:IsDescendantOf(workspace) then
			removecoinesp(obj)
		end
	end))

	visuals.cointracked[obj] = {
		hl = hl,
		bb = bb,
		conns = conns
	}
end

function visuals:togglecoinesp(state)
	self.coinespenabled = state
	for _, conn in ipairs(self.coinconnections) do
		conn:Disconnect()
	end
	table.clear(self.coinconnections)

	for obj in pairs(self.cointracked) do
		removecoinesp(obj)
	end

	if not state then
		return
	end

	table.insert(self.coinconnections, cs:GetInstanceAddedSignal(self.coinesptag):Connect(function(obj)
		task.defer(addcoinesp, obj)
	end))

	table.insert(self.coinconnections, cs:GetInstanceRemovedSignal(self.coinesptag):Connect(function(obj)
		removecoinesp(obj)
	end))

	for _, obj in ipairs(cs:GetTagged(self.coinesptag)) do
		addcoinesp(obj)
	end
end

function visuals:sethudscale(scale)
	if hudscale and typeof(scale) == "number" then
		hudscale.Scale = scale
	end
end

function visuals:togglehud(state)
	self.hudenabled = state
	hudframe.Visible = state
end

function visuals:togglefloornotify(state, callback)
	self.notifyfloor = state
	if callback then
		self.notifycallback = callback
	end
end

function visuals:unload()
	self:togglehud(false)
	self:togglecoinesp(false)
	for _, conn in ipairs(self.connections) do
		conn:Disconnect()
	end
	table.clear(self.connections)
	if gui then
		gui:Destroy()
	end
	if espcontainer then
		espcontainer:Destroy()
	end
end

return visuals
