local plrs = game:GetService("Players")
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local stats = game:GetService("Stats")
local gs = game:GetService("GuiService")
local lp = plrs.LocalPlayer
assert(lp, "crescent requires a client")
local cg = lp:WaitForChild("PlayerGui")
local crescent = {}

local thm = {
	bg = Color3.fromRGB(10, 10, 10),
	sb = Color3.fromRGB(13, 13, 13),
	tb = Color3.fromRGB(15, 15, 15),
	crd = Color3.fromRGB(18, 18, 18),
	line = Color3.fromRGB(39, 39, 39),
	div = Color3.fromRGB(31, 31, 31),
	acc = Color3.fromRGB(238, 238, 238),
	text = Color3.fromRGB(233, 233, 233),
	sec = Color3.fromRGB(181, 181, 181),
	mut = Color3.fromRGB(137, 137, 137),
	off = Color3.fromRGB(26, 26, 26),
	edge = Color3.fromRGB(55, 55, 55),
	knob = Color3.fromRGB(143, 143, 143),
	hover = Color3.fromRGB(28, 28, 28)
}

local function create(classname, properties)
	local inst = Instance.new(classname)
	if inst:IsA("GuiObject") then
		inst.BorderSizePixel = 0
	end
	if inst:IsA("GuiButton") then
		inst.AutoButtonColor = false
	end
	for prop, val in pairs(properties or {}) do
		inst[prop] = val
	end
	return inst
end

local function round(parent, radius)
	return create("UICorner", {CornerRadius = UDim.new(0, radius or 6), Parent = parent})
end

local function stroke(parent, color)
	return create("UIStroke", {
		Color = color or thm.line, Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = parent
	})
end

local function padding(parent, x, y)
	return create("UIPadding", {
		PaddingLeft = UDim.new(0, x), PaddingRight = UDim.new(0, x),
		PaddingTop = UDim.new(0, y), PaddingBottom = UDim.new(0, y), Parent = parent
	})
end

local function label(parent, text, size, color)
	return create("TextLabel", {
		BackgroundTransparency = 1, Font = Enum.Font.GothamMedium,
		Text = tostring(text or ""), TextSize = size or 12, TextColor3 = color or thm.sec,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		Size = UDim2.new(1, 0, 1, 0), Parent = parent
	})
end

local function tween(inst, properties, duration)
	local tw = ts:Create(inst, TweenInfo.new(duration or 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
	tw:Play()
	return tw
end

local function clean(text)
	return tostring(text or "")
end

local function finite(value, fallback)
	local num = tonumber(value)
	if not num or num ~= num or math.abs(num) == math.huge then
		return fallback
	end
	return num
end

local function invoke(callback, ...)
	if type(callback) ~= "function" then return nil end
	local ok, result = pcall(callback, ...)
	if not ok then warn("crescent: " .. tostring(result)) return nil end
	return result
end

local function formatkey(key)
	if not key or key == Enum.KeyCode.Unknown then return "none" end
	local map = {
		LeftAlt = "lalt", RightAlt = "ralt", LeftShift = "lshift", RightShift = "rshift",
		LeftControl = "lctrl", RightControl = "rctrl", Backspace = "back",
		Return = "enter", Space = "space", Tab = "tab", Insert = "ins", Delete = "del"
	}
	return map[key.Name] or string.lower(key.Name)
end

local function moon(parent, position, diameter)
	local disk = create("Frame", {
		Position = position, Size = UDim2.fromOffset(diameter, diameter),
		BackgroundColor3 = thm.acc, Parent = parent
	})
	round(disk, diameter)
	create("UIGradient", {
		Rotation = 40,
		Color = ColorSequence.new(Color3.fromRGB(249, 249, 249), Color3.fromRGB(175, 175, 175)),
		Parent = disk
	})
	for index, spot in ipairs({{0.24, 0.22, 0.22}, {0.52, 0.49, 0.27}, {0.23, 0.62, 0.13}}) do
		local crater = create("Frame", {
			Position = UDim2.fromScale(spot[1], spot[2]), Size = UDim2.fromScale(spot[3], spot[3]),
			BackgroundColor3 = Color3.fromRGB(120, 120, 120), BackgroundTransparency = 0.76,
			Parent = disk
		})
		round(crater, diameter)
	end
	return disk
end

function crescent:notify(data)
	data = data or {}
	local parent = data.parent or cg
	local duration = math.clamp(finite(data.duration, 4), 0.5, 60)
	local gui = parent:FindFirstChild("crescentnotifygui")
	if not gui then
		gui = create("ScreenGui", {
			Name = "crescentnotifygui", ResetOnSpawn = false, DisplayOrder = 31,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = parent
		})
	end
	local container = gui:FindFirstChild("container")
	if not container then
		container = create("Frame", {
			Name = "container", AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, -16),
			Size = UDim2.new(1, -32, 1, -32), BackgroundTransparency = 1, Parent = gui
		})
		create("UISizeConstraint", {MaxSize = Vector2.new(272, 10000), Parent = container})
		create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, 10), Parent = container
		})
	end
	local count = 0
	for index, child in ipairs(container:GetChildren()) do
		if child:IsA("Frame") then count = count + 1 end
	end
	if count >= 4 then
		for index, child in ipairs(container:GetChildren()) do
			if child:IsA("Frame") then child:Destroy() break end
		end
	end
	local card = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = thm.crd, Parent = container
	})
	round(card, 8)
	stroke(card)
	padding(card, 14, 12)
	create("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = card})
	local title = label(card, clean(data.title or "crescent"), 12, thm.text)
	title.Size = UDim2.new(1, 0, 0, 16)
	title.Font = Enum.Font.GothamBold
	title.LayoutOrder = 1
	local text = label(card, clean(data.content), 12, thm.sec)
	text.Size = UDim2.new(1, 0, 0, 16)
	text.AutomaticSize = Enum.AutomaticSize.Y
	text.TextWrapped = true
	text.TextTruncate = Enum.TextTruncate.None
	text.TextYAlignment = Enum.TextYAlignment.Top
	text.LayoutOrder = 2
	local track = create("Frame", {
		LayoutOrder = 3, Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = thm.div, Parent = card
	})
	local progress = create("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = thm.acc, Parent = track})
	ts:Create(progress, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.fromScale(0, 1)}):Play()
	task.delay(duration, function()
		if card.Parent then card:Destroy() end
	end)
end

function crescent:createwindow(cfg)
	cfg = cfg or {}
	local parent = cfg.parent or cg
	local old = parent:FindFirstChild("crescentgui")
	if old then old:Destroy() end
	local connections = {}
	local dead = false
	local isopen = true
	local isanimating = false
	local capture = nil
	local keybinds = {}
	local togglekey = cfg.togglekey or Enum.KeyCode.LeftAlt
	local gui = create("ScreenGui", {
		Name = "crescentgui", ResetOnSpawn = false, DisplayOrder = 30,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = parent
	})
	local root = create("Frame", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = gui})
	local main = create("Frame", {
		Name = "main", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(720, 480), BackgroundColor3 = thm.bg, Parent = root
	})
	round(main, 9)
	stroke(main)
	local mainscale = create("UIScale", {Scale = 1, Parent = main})
	local window = {gui = gui, main = main, tabs = {}, activetab = nil, connections = connections}
	local function connect(signal, callback)
		local conn = signal:Connect(callback)
		table.insert(connections, conn)
		return conn
	end
	connect(gui.Destroying, function()
		dead = true
		capture = nil
		for index, conn in ipairs(connections) do conn:Disconnect() end
		table.clear(connections)
		table.clear(keybinds)
	end)
	local function cancelcapture()
		if capture then
			local previous = capture
			capture = nil
			previous.cancel()
		end
	end
	local function beginbind(item)
		cancelcapture()
		capture = item
		item.begin()
	end
	local tooltip = create("Frame", {
		Size = UDim2.fromOffset(220, 0), AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = thm.tb, Visible = false, ZIndex = 100, Parent = root
	})
	round(tooltip, 6)
	stroke(tooltip)
	padding(tooltip, 10, 8)
	local tooltiptext = label(tooltip, "", 12)
	tooltiptext.Size = UDim2.new(1, 0, 0, 16)
	tooltiptext.AutomaticSize = Enum.AutomaticSize.Y
	tooltiptext.TextWrapped = true
	tooltiptext.TextTruncate = Enum.TextTruncate.None
	tooltiptext.ZIndex = 101
	local function movetooltip()
		local inset = gs:GetGuiInset()
		local mouse = uis:GetMouseLocation() - inset
		local bounds = root.AbsoluteSize
		local size = tooltip.AbsoluteSize
		tooltip.Position = UDim2.fromOffset(
			math.clamp(mouse.X + 14, 8, math.max(8, bounds.X - size.X - 8)),
			math.clamp(mouse.Y + 16, 8, math.max(8, bounds.Y - size.Y - 8))
		)
	end
	local function hidetooltip()
		tooltip.Visible = false
	end
	local function showtooltip(text)
		if not isopen or not text or text == "" then return end
		tooltiptext.Text = clean(text)
		tooltip.Visible = true
		movetooltip()
	end
	connect(tooltip:GetPropertyChangedSignal("AbsoluteSize"), function()
		if tooltip.Visible then movetooltip() end
	end)
	local function hover(target, surface, desc)
		connect(target.MouseEnter, function()
			if surface then tween(surface, {BackgroundTransparency = 0.45}) end
			showtooltip(desc)
		end)
		connect(target.MouseLeave, function()
			if surface then tween(surface, {BackgroundTransparency = 1}) end
			hidetooltip()
		end)
	end
	local topbar = create("Frame", {Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = thm.tb, Parent = main})
	round(topbar, 9)
	create("Frame", {Position = UDim2.new(0, 0, 1, -9), Size = UDim2.new(1, 0, 0, 9), BackgroundColor3 = thm.tb, Parent = topbar})
	create("Frame", {Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = thm.line, Parent = topbar})
	create("ImageLabel", {
	Position = UDim2.new(0, 18, 0.5, -11),
	Size = UDim2.fromOffset(22, 22),
	BackgroundTransparency = 1,
	Image = "rbxassetid://132049320741473",
	Parent = topbar
	})
	local title = label(topbar, clean(cfg.title or "crescent"), 13, thm.text)
	title.Font = Enum.Font.GothamBold
	title.Position = UDim2.fromOffset(52, 0)
	title.Size = UDim2.new(1, -152, 1, 0)
	local dragarea = create("TextButton", {Size = UDim2.new(1, -90, 1, 0), BackgroundTransparency = 1, Text = "", Parent = topbar})
	local bindbadge = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -16, 0.5, 0),
		Size = UDim2.fromOffset(64, 24), BackgroundColor3 = thm.off, Font = Enum.Font.GothamMedium,
		Text = "[" .. formatkey(togglekey) .. "]", TextColor3 = thm.sec, TextSize = 11, Parent = topbar
	})
	round(bindbadge, 5)
	local bindstroke = stroke(bindbadge)
	local function restorebadge()
		bindbadge.Text = "[" .. formatkey(togglekey) .. "]"
		tween(bindstroke, {Color = thm.line})
	end
	connect(bindbadge.Activated, function()
		beginbind({
			begin = function() bindbadge.Text = "[...]" tween(bindstroke, {Color = thm.acc}) end,
			cancel = restorebadge,
			accept = function(key)
				if key ~= Enum.KeyCode.Escape then togglekey = key end
				restorebadge()
			end
		})
	end)
	hover(bindbadge, nil, "change menu key · escape to cancel")
	local sidebar = create("Frame", {
		Position = UDim2.fromOffset(0, 47), Size = UDim2.new(0, 128, 1, -75), BackgroundColor3 = thm.sb, Parent = main
	})
	create("Frame", {Position = UDim2.new(1, -1, 0, 0), Size = UDim2.new(0, 1, 1, 0), BackgroundColor3 = thm.line, Parent = sidebar})
	local tabcontainer = create("ScrollingFrame", {
		Position = UDim2.fromOffset(10, 16), Size = UDim2.new(1, -21, 1, -32), BackgroundTransparency = 1,
		ScrollBarThickness = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y, Parent = sidebar
	})
	create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = tabcontainer})
	local contentholder = create("Frame", {
		Position = UDim2.fromOffset(128, 47), Size = UDim2.new(1, -128, 1, -75),
		BackgroundTransparency = 1, ClipsDescendants = true, Parent = main
	})
	local footer = create("Frame", {
		Position = UDim2.new(0, 0, 1, -28), Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = thm.tb, Parent = main
	})
	round(footer, 9)
	create("Frame", {Size = UDim2.new(1, 0, 0, 9), BackgroundColor3 = thm.tb, Parent = footer})
	create("Frame", {Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = thm.line, Parent = footer})
	local footertext = label(footer, clean(cfg.footer or "crescent | by dimhev"), 11, thm.mut)
	footertext.Position = UDim2.fromOffset(16, 0)
	footertext.Size = UDim2.new(0.55, -16, 1, 0)
	local statslabel = label(footer, "", 11, thm.mut)
	statslabel.Position = UDim2.fromScale(0.55, 0)
	statslabel.Size = UDim2.new(0.45, -28, 1, 0)
	statslabel.TextXAlignment = Enum.TextXAlignment.Right
	local watermark = create("Frame", {
		Position = UDim2.fromOffset(16, 16), Size = UDim2.fromOffset(0, 28), AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = thm.tb, Visible = cfg.watermark == true, Parent = root
	})
	round(watermark, 6)
	stroke(watermark)
	padding(watermark, 10, 0)
	local wmtext = label(watermark, "crescent", 11)
	wmtext.Size = UDim2.new(0, 0, 1, 0)
	wmtext.AutomaticSize = Enum.AutomaticSize.X
	window.watermark = watermark
	local frames = 0
	local elapsed = 0
	connect(rs.RenderStepped, function(dt)
		frames = frames + 1
		elapsed = elapsed + dt
		if elapsed < 1 then return end
		local fps = math.floor(frames / elapsed + 0.5)
		frames = 0
		elapsed = 0
		local ping = "—"
		pcall(function() ping = tostring(math.floor(stats.Network.ServerStatsItem["Data Ping"]:GetValue())) end)
		statslabel.Text = tostring(fps) .. " fps  ·  " .. ping .. " ms"
		if watermark.Visible then wmtext.Text = "crescent  ·  " .. statslabel.Text end
	end)
	local dragging = nil
	local resizing = nil
	local dragstart = nil
	local startpos = nil
	local startsize = nil
	local grip = create("TextButton", {
		AnchorPoint = Vector2.new(1, 1), Position = UDim2.fromScale(1, 1), Size = UDim2.fromOffset(22, 22),
		BackgroundTransparency = 1, Text = "", Parent = main
	})
	for index = 1, 3 do
		local dot = create("Frame", {
			Position = UDim2.new(1, -5 - index * 3, 1, -5), Size = UDim2.fromOffset(2, 2),
			BackgroundColor3 = thm.mut, Parent = grip
		})
		round(dot, 1)
	end
	local function bounds()
		local size = root.AbsoluteSize
		return Vector2.new(math.max(1, size.X - 24), math.max(1, size.Y - 24))
	end
	local function clampwindow()
		if dead then return end
		local available = bounds()
		local width = math.clamp(main.Size.X.Offset, math.min(640, available.X), math.min(1200, available.X))
		local height = math.clamp(main.Size.Y.Offset, math.min(420, available.Y), math.min(850, available.Y))
		main.Size = UDim2.fromOffset(width, height)
		local screen = root.AbsoluteSize
		local center = Vector2.new(screen.X * main.Position.X.Scale + main.Position.X.Offset, screen.Y * main.Position.Y.Scale + main.Position.Y.Offset)
		main.Position = UDim2.fromOffset(
			math.clamp(center.X, width / 2 + 12, math.max(width / 2 + 12, screen.X - width / 2 - 12)),
			math.clamp(center.Y, height / 2 + 12, math.max(height / 2 + 12, screen.Y - height / 2 - 12))
		)
		local side = width < 580 and 108 or 128
		sidebar.Size = UDim2.new(0, side, 1, -75)
		contentholder.Position = UDim2.fromOffset(side, 47)
		contentholder.Size = UDim2.new(1, -side, 1, -75)
	end
	local requested = typeof(cfg.size) == "Vector2" and cfg.size or Vector2.new(720, 480)
	main.Size = UDim2.fromOffset(finite(requested.X, 720), finite(requested.Y, 480))
	connect(root:GetPropertyChangedSignal("AbsoluteSize"), clampwindow)
	task.defer(clampwindow)
	connect(dragarea.InputBegan, function(input)
		if isanimating then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = input
			dragstart = input.Position
			startpos = main.Position
			hidetooltip()
		end
	end)
	connect(grip.InputBegan, function(input)
		if isanimating then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = input
			dragstart = input.Position
			startsize = main.Size
			startpos = main.Position
			hidetooltip()
		end
	end)
	connect(uis.InputEnded, function(input)
		if input == dragging or input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = nil end
		if input == resizing or input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = nil end
	end)
	connect(uis.InputChanged, function(input)
		if tooltip.Visible and input.UserInputType == Enum.UserInputType.MouseMovement then movetooltip() end
		local active = dragging or resizing
		if not active then return end
		if input ~= active and not (active.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement) then return end
		local delta = input.Position - dragstart
		if dragging then
			main.Position = UDim2.new(startpos.X.Scale, startpos.X.Offset + delta.X, startpos.Y.Scale, startpos.Y.Offset + delta.Y)
		else
			local available = bounds()
			local width = math.clamp(startsize.X.Offset + delta.X, math.min(640, available.X), math.min(1200, available.X))
			local height = math.clamp(startsize.Y.Offset + delta.Y, math.min(420, available.Y), math.min(850, available.Y))
			main.Size = UDim2.fromOffset(width, height)
			main.Position = UDim2.new(startpos.X.Scale, startpos.X.Offset + (width - startsize.X.Offset) / 2, startpos.Y.Scale, startpos.Y.Offset + (height - startsize.Y.Offset) / 2)
		end
		clampwindow()
	end)
	local function toggleui()
		if dead or isanimating then return end
		cancelcapture()
		hidetooltip()
		dragging = nil
		resizing = nil
		isanimating = true
		isopen = not isopen
		local opening = isopen
		if opening then main.Visible = true end
		local tw = tween(mainscale, {Scale = opening and 1 or 0.97}, 0.16)
		tw.Completed:Once(function()
			if dead then return end
			main.Visible = opening
			isanimating = false
		end)
	end
	connect(uis.WindowFocusReleased, function()
		dragging = nil
		resizing = nil
		cancelcapture()
		hidetooltip()
	end)
	connect(uis.InputBegan, function(input, processed)
		if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
		if capture then
			local current = capture
			capture = nil
			current.accept(input.KeyCode)
			return
		end
		if processed or uis:GetFocusedTextBox() then return end
		local alt = togglekey == Enum.KeyCode.LeftAlt or togglekey == Enum.KeyCode.RightAlt
		if input.KeyCode == togglekey or (alt and (input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt)) then
			toggleui()
			return
		end
		for index, bind in ipairs(keybinds) do
			if bind.frame.Parent and bind.key ~= Enum.KeyCode.Unknown and input.KeyCode == bind.key then
				invoke(bind.callback, bind.key)
			end
		end
	end)

	function window:setwatermark(state)
		if not dead then self.watermark.Visible = not not state end
	end
	function window:toggle()
		toggleui()
	end
	function window:destroy()
		if not dead then self.gui:Destroy() end
	end
	function window:createtab(tabname)
		assert(not dead, "window is destroyed")
		local cleanname = clean(tabname)
		local tabbtn = create("TextButton", {
			LayoutOrder = #self.tabs + 1, Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = thm.hover,
			BackgroundTransparency = 1, Text = "", Parent = tabcontainer
		})
		round(tabbtn, 6)
		local tabtext = label(tabbtn, cleanname, 12, thm.mut)
		tabtext.Position = UDim2.fromOffset(12, 0)
		tabtext.Size = UDim2.new(1, -24, 1, 0)
		local indicator = create("Frame", {
			Position = UDim2.new(0, 0, 0.5, -7), Size = UDim2.fromOffset(2, 14),
			BackgroundColor3 = thm.acc, BackgroundTransparency = 1, Parent = tabbtn
		})
		round(indicator, 1)
		local page = create("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ScrollBarThickness = 3,
			ScrollBarImageColor3 = thm.edge, CanvasSize = UDim2.new(), Visible = false,
			ScrollingDirection = Enum.ScrollingDirection.Y, Parent = contentholder
		})
		local colleft = create("Frame", {BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Parent = page})
		local colright = create("Frame", {BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Parent = page})
		local leftlayout = create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 18), Parent = colleft})
		local rightlayout = create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 18), Parent = colright})
		local function layoutpage()
			if dead then return end
			local width = page.AbsoluteSize.X
			local leftheight = leftlayout.AbsoluteContentSize.Y
			local rightheight = rightlayout.AbsoluteContentSize.Y
			local total
			if width >= 492 then
				local colwidth = math.max(1, math.floor((width - 60) / 2))
				colleft.Position = UDim2.fromOffset(20, 20)
				colright.Position = UDim2.fromOffset(40 + colwidth, 20)
				colleft.Size = UDim2.fromOffset(colwidth, 0)
				colright.Size = UDim2.fromOffset(colwidth, 0)
				total = math.max(leftheight, rightheight) + 40
			else
				local colwidth = math.max(1, width - 40)
				local gap = leftheight > 0 and rightheight > 0 and 18 or 0
				colleft.Position = UDim2.fromOffset(20, 20)
				colright.Position = UDim2.fromOffset(20, 20 + leftheight + gap)
				colleft.Size = UDim2.fromOffset(colwidth, 0)
				colright.Size = UDim2.fromOffset(colwidth, 0)
				total = leftheight + rightheight + gap + 40
			end
			page.CanvasSize = UDim2.fromOffset(0, total)
		end
		connect(page:GetPropertyChangedSignal("AbsoluteSize"), layoutpage)
		connect(leftlayout:GetPropertyChangedSignal("AbsoluteContentSize"), layoutpage)
		connect(rightlayout:GetPropertyChangedSignal("AbsoluteContentSize"), layoutpage)
		local tab = {
			name = cleanname, btn = tabbtn, indicator = indicator, page = page,
			colleft = colleft, colright = colright, sections = {}, sectionscount = 0, text = tabtext
		}
		local function selecttab()
			cancelcapture()
			hidetooltip()
			for index, item in ipairs(window.tabs) do
				local active = item == tab
				item.page.Visible = active
				tween(item.btn, {BackgroundTransparency = active and 0 or 1})
				tween(item.text, {TextColor3 = active and thm.text or thm.mut})
				tween(item.indicator, {BackgroundTransparency = active and 0 or 1})
			end
			window.activetab = tab
			layoutpage()
		end
		connect(tabbtn.Activated, selecttab)
		table.insert(self.tabs, tab)
		if #self.tabs == 1 then selecttab() end
		layoutpage()

		function tab:createsection(secname, side)
			self.sectionscount = self.sectionscount + 1
			local parentcol
			if side == "left" then parentcol = self.colleft
			elseif side == "right" then parentcol = self.colright
			else parentcol = self.sectionscount % 2 == 1 and self.colleft or self.colright end
			local card = create("Frame", {
				LayoutOrder = self.sectionscount, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = thm.crd, Parent = parentcol
			})
			round(card, 7)
			stroke(card)
			padding(card, 12, 12)
			create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), Parent = card})
			local heading = label(card, clean(secname), 12, thm.text)
			heading.Font = Enum.Font.GothamBold
			heading.LayoutOrder = 1
			heading.Size = UDim2.new(1, 0, 0, 16)
			create("Frame", {LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = thm.div, Parent = card})
			local list = create("Frame", {
				LayoutOrder = 3, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1, Parent = card
			})
			create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = list})
			local section = {name = clean(secname), card = card, list = list, items = {}}
			table.insert(self.sections, section)
			local order = 0
			local function registeritem(name, frame)
				order = order + 1
				frame.LayoutOrder = order
				table.insert(section.items, {name = clean(name), frame = frame})
			end
			local function row(name, height)
				local frame = create("Frame", {
					Size = UDim2.new(1, 0, 0, height or 32), BackgroundColor3 = thm.hover,
					BackgroundTransparency = 1, Parent = list
				})
				round(frame, 5)
				padding(frame, 4, 0)
				registeritem(name, frame)
				return frame
			end

			function section:createlabel(text)
				local lbl = label(self.list, clean(text), 12, thm.mut)
				lbl.Size = UDim2.new(1, 0, 0, 20)
				lbl.AutomaticSize = Enum.AutomaticSize.Y
				lbl.TextWrapped = true
				lbl.TextTruncate = Enum.TextTruncate.None
				registeritem(text, lbl)
				local ctrl = {}
				function ctrl:set(newtext) lbl.Text = clean(newtext) end
				return ctrl
			end
			function section:createdivider()
				local div = row("", 9)
				create("Frame", {Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = thm.div, Parent = div})
				return div
			end
			function section:createtoggle(name, defaultval, callback, desc)
				local state = not not defaultval
				local frame = row(name)
				local text = label(frame, clean(name), 12, state and thm.text or thm.sec)
				text.Size = UDim2.new(1, -48, 1, 0)
				local track = create("Frame", {
					Position = UDim2.new(1, -34, 0.5, -9), Size = UDim2.fromOffset(34, 18),
					BackgroundColor3 = state and thm.acc or thm.off, Parent = frame
				})
				round(track, 9)
				local edge = stroke(track, state and thm.acc or thm.edge)
				local knob = create("Frame", {
					Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
					Size = UDim2.fromOffset(12, 12), BackgroundColor3 = state and thm.bg or thm.knob, Parent = track
				})
				round(knob, 6)
				local button = create("TextButton", {Size = UDim2.fromScale(1, 1), Text = "", BackgroundTransparency = 1, Parent = frame})
				local function applystate(val, silent)
					state = not not val
					tween(track, {BackgroundColor3 = state and thm.acc or thm.off})
					tween(edge, {Color = state and thm.acc or thm.edge})
					tween(knob, {
						Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
						BackgroundColor3 = state and thm.bg or thm.knob
					})
					tween(text, {TextColor3 = state and thm.text or thm.sec})
					if not silent then invoke(callback, state) end
				end
				connect(button.Activated, function() applystate(not state, false) end)
				hover(button, frame, desc)
				local ctrl = {frame = frame}
				function ctrl:set(val, silent) applystate(val, silent) end
				function ctrl:get() return state end
				return ctrl
			end
			function section:createbutton(name, callback, desc)
				local frame = row(name)
				local button = create("TextButton", {
					Size = UDim2.fromScale(1, 1), BackgroundColor3 = thm.off,
					Text = clean(name), Font = Enum.Font.GothamMedium, TextSize = 12,
					TextColor3 = thm.sec, TextTruncate = Enum.TextTruncate.AtEnd, Parent = frame
				})
				round(button, 5)
				local edge = stroke(button)
				connect(button.MouseEnter, function() tween(edge, {Color = thm.knob}) tween(button, {TextColor3 = thm.text}) end)
				connect(button.MouseLeave, function() tween(edge, {Color = thm.line}) tween(button, {TextColor3 = thm.sec}) end)
				connect(button.Activated, function() invoke(callback) end)
				hover(button, nil, desc)
				return button
			end
			function section:createslider(name, minval, maxval, defaultval, callback, desc)
				minval = finite(minval, 0)
				maxval = finite(maxval, 100)
				if minval > maxval then minval, maxval = maxval, minval end
				local curval = math.clamp(finite(defaultval, minval), minval, maxval)
				local range = maxval - minval
				local function percent(value) return range > 0 and (value - minval) / range or 0 end
				local box = row(name, 48)
				local text = label(box, clean(name))
				text.Position = UDim2.fromOffset(0, 3)
				text.Size = UDim2.new(1, -60, 0, 18)
				local valbox = create("TextBox", {
					Position = UDim2.new(1, -56, 0, 3), Size = UDim2.fromOffset(56, 18),
					BackgroundTransparency = 1, Text = tostring(curval), Font = Enum.Font.GothamMedium,
					TextColor3 = thm.text, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right,
					ClearTextOnFocus = false, Parent = box
				})
				local bar = create("Frame", {Position = UDim2.new(0, 0, 0, 33), Size = UDim2.new(1, 0, 0, 4), BackgroundColor3 = thm.edge, Parent = box})
				round(bar, 2)
				local fill = create("Frame", {Size = UDim2.fromScale(percent(curval), 1), BackgroundColor3 = thm.acc, Parent = bar})
				round(fill, 2)
				local knob = create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(percent(curval), 0.5),
					Size = UDim2.fromOffset(8, 8), BackgroundColor3 = thm.acc, Parent = bar
				})
				round(knob, 4)
				local hit = create("TextButton", {Position = UDim2.fromOffset(0, 23), Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1, Text = "", Parent = box})
				local sliding = nil
				local function setval(num, silent)
					curval = math.clamp(math.floor(finite(num, curval) + 0.5), minval, maxval)
					valbox.Text = tostring(curval)
					fill.Size = UDim2.fromScale(percent(curval), 1)
					knob.Position = UDim2.fromScale(percent(curval), 0.5)
					if not silent then invoke(callback, curval) end
				end
				local function updateslider(input)
					local pct = math.clamp((input.Position.X - bar.AbsolutePosition.X) / math.max(1, bar.AbsoluteSize.X), 0, 1)
					local value = math.clamp(math.floor(minval + range * pct + 0.5), minval, maxval)
					if value ~= curval then setval(value, false) end
				end
				connect(valbox.FocusLost, function() setval(finite(valbox.Text, curval), false) end)
				connect(hit.InputBegan, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						sliding = input
						page.ScrollingEnabled = false
						updateslider(input)
					end
				end)
				local function stopslide()
					if sliding then sliding = nil page.ScrollingEnabled = true end
				end
				connect(uis.InputEnded, function(input)
					if input == sliding or input.UserInputType == Enum.UserInputType.MouseButton1 then stopslide() end
				end)
				connect(uis.WindowFocusReleased, stopslide)
				connect(main:GetPropertyChangedSignal("Visible"), stopslide)
				connect(page:GetPropertyChangedSignal("Visible"), stopslide)
				connect(uis.InputChanged, function(input)
					if not sliding then return end
					if not isopen or not page.Visible then stopslide() return end
					if input == sliding or (sliding.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement) then updateslider(input) end
				end)
				hover(box, box, desc)
				local ctrl = {frame = box}
				function ctrl:set(val, silent) setval(val, silent) end
				function ctrl:get() return curval end
				return ctrl
			end
			function section:createtextbox(name, placeholder, defaultval, callback, desc)
				if type(defaultval) == "function" then desc = callback callback = defaultval defaultval = "" end
				local frame = row(name)
				local text = label(frame, clean(name))
				text.Size = UDim2.new(0.48, -8, 1, 0)
				local inputbg = create("Frame", {Position = UDim2.new(0.48, 0, 0.5, -12), Size = UDim2.new(0.52, 0, 0, 24), BackgroundColor3 = thm.off, Parent = frame})
				round(inputbg, 5)
				local edge = stroke(inputbg, thm.edge)
				local input = create("TextBox", {
					Position = UDim2.fromOffset(7, 0), Size = UDim2.new(1, -14, 1, 0), BackgroundTransparency = 1,
					Text = defaultval ~= nil and tostring(defaultval) or "", PlaceholderText = clean(placeholder or "value..."),
					PlaceholderColor3 = thm.mut, TextColor3 = thm.text, Font = Enum.Font.GothamMedium, TextSize = 11,
					TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, ClipsDescendants = true, Parent = inputbg
				})
				connect(input.Focused, function() tween(edge, {Color = thm.acc}) end)
				connect(input.FocusLost, function()
					tween(edge, {Color = thm.edge})
					local result = invoke(callback, input.Text)
					if type(result) == "string" then input.Text = result end
				end)
				hover(frame, frame, desc)
				local ctrl = {frame = frame}
				function ctrl:set(val) input.Text = tostring(val) end
				function ctrl:get() return input.Text end
				return ctrl
			end
			function section:createkeybind(name, defaultkey, callback, desc)
				local frame = row(name)
				local bind = {key = defaultkey or Enum.KeyCode.Unknown, callback = callback, frame = frame}
				table.insert(keybinds, bind)
				local text = label(frame, clean(name))
				text.Size = UDim2.new(1, -76, 1, 0)
				local button = create("TextButton", {
					Position = UDim2.new(1, -66, 0.5, -12), Size = UDim2.fromOffset(66, 24), BackgroundColor3 = thm.off,
					Text = "[" .. formatkey(bind.key) .. "]", TextColor3 = thm.sec, Font = Enum.Font.GothamMedium, TextSize = 11, Parent = frame
				})
				round(button, 5)
				local edge = stroke(button, thm.edge)
				local function restore()
					button.Text = "[" .. formatkey(bind.key) .. "]"
					tween(edge, {Color = thm.edge})
				end
				connect(button.Activated, function()
					beginbind({
						begin = function() button.Text = "[...]" tween(edge, {Color = thm.acc}) end,
						cancel = restore,
						accept = function(key)
							bind.key = (key == Enum.KeyCode.Escape or key == Enum.KeyCode.Backspace) and Enum.KeyCode.Unknown or key
							restore()
						end
					})
				end)
				hover(frame, frame, desc)
				return frame
			end
			function section:createdropdown(name, options, defaultopt, callback, desc)
				options = options or {}
				local selected = "none"
				local opened = false
				local wrapper = create("Frame", {Size = UDim2.new(1, 0, 0, 32), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = self.list})
				registeritem(name, wrapper)
				create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = wrapper})
				local header = create("TextButton", {LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = thm.off, Text = "", Parent = wrapper})
				round(header, 5)
				local edge = stroke(header, thm.edge)
				local text = label(header, clean(name))
				text.Position = UDim2.fromOffset(8, 0)
				text.Size = UDim2.new(0.49, -8, 1, 0)
				local seltext = label(header, "", 11, thm.text)
				seltext.Position = UDim2.fromScale(0.49, 0)
				seltext.Size = UDim2.new(0.51, -26, 1, 0)
				seltext.TextXAlignment = Enum.TextXAlignment.Right
				local arrow = label(header, "+", 14, thm.mut)
				arrow.Position = UDim2.new(1, -20, 0, 0)
				arrow.Size = UDim2.new(0, 14, 1, 0)
				arrow.TextXAlignment = Enum.TextXAlignment.Center
				local dropbox = create("ScrollingFrame", {
					LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = thm.sb,
					CanvasSize = UDim2.new(), ScrollBarThickness = 2, ScrollBarImageColor3 = thm.edge,
					ScrollingDirection = Enum.ScrollingDirection.Y, Visible = false, Parent = wrapper
				})
				round(dropbox, 5)
				stroke(dropbox)
				padding(dropbox, 4, 4)
				create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3), Parent = dropbox})
				local optionconnections = {}
				local function close()
					opened = false
					dropbox.Visible = false
					arrow.Text = "+"
					tween(edge, {Color = thm.edge})
				end
				local function choose(preferred)
					for index, opt in ipairs(options) do
						if preferred ~= nil and string.lower(clean(opt)) == string.lower(clean(preferred)) then
						return clean(opt)
						end
					end
					return options[1] ~= nil and clean(options[1]) or "none"
				end
				local function rebuild(opts)
					for index, conn in ipairs(optionconnections) do conn:Disconnect() end
					table.clear(optionconnections)
					for index, child in ipairs(dropbox:GetChildren()) do
						if child:IsA("TextButton") then child:Destroy() end
					end
					local height = #opts == 0 and 0 or #opts * 29 - 3 + 8
					dropbox.Size = UDim2.new(1, 0, 0, math.min(150, height))
					dropbox.CanvasSize = UDim2.fromOffset(0, height)
					for index, opt in ipairs(opts) do
						local value = opt
						local opttext = clean(value)
						local button = create("TextButton", {
							LayoutOrder = index, Size = UDim2.new(1, -2, 0, 26), BackgroundColor3 = thm.hover,
							BackgroundTransparency = opttext == selected and 0 or 1, Font = Enum.Font.GothamMedium,
							Text = opttext, TextColor3 = opttext == selected and thm.text or thm.sec, TextSize = 11,
							TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = dropbox
						})
						round(button, 4)
						padding(button, 8, 0)
						table.insert(optionconnections, button.Activated:Connect(function()
							selected = opttext
							seltext.Text = selected
							close()
							rebuild(options)
							invoke(callback, value)
						end))
					end
				end
				connect(wrapper.Destroying, function()
					for index, conn in ipairs(optionconnections) do conn:Disconnect() end
					table.clear(optionconnections)
				end)
				selected = choose(defaultopt)
				seltext.Text = selected
				rebuild(options)
				connect(header.Activated, function()
					if #options == 0 then return end
					opened = not opened
					dropbox.Visible = opened
					arrow.Text = opened and "−" or "+"
					tween(edge, {Color = opened and thm.acc or thm.edge})
				end)
				connect(page:GetPropertyChangedSignal("Visible"), close)
				connect(main:GetPropertyChangedSignal("Visible"), close)
				hover(header, nil, desc)
				local ctrl = {frame = wrapper}
				function ctrl:refresh(newopts, newdef)
					options = newopts or {}
					selected = choose(newdef ~= nil and newdef or selected)
					seltext.Text = selected
					close()
					rebuild(options)
				end
				function ctrl:get() return selected end
				return ctrl
			end
			return section
		end
		return tab
	end
	return window
end

return crescent
