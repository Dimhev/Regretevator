local cg = game:GetService("CoreGui")
local plrs = game:GetService("Players")
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local stats = game:GetService("Stats")

local lp = plrs.LocalPlayer

local crescent = {}

local thm = {
	bg = Color3.fromRGB(9, 9, 10),
	sb = Color3.fromRGB(12, 12, 14),
	tb = Color3.fromRGB(12, 12, 14),
	ftr = Color3.fromRGB(12, 12, 14),
	crd = Color3.fromRGB(15, 15, 17),
	crdstk = Color3.fromRGB(32, 32, 36),
	crddiv = Color3.fromRGB(25, 25, 28),
	acc = Color3.fromRGB(245, 245, 250),
	accglw = Color3.fromRGB(235, 235, 242),
	accstk = Color3.fromRGB(250, 250, 255),
	tgloff = Color3.fromRGB(22, 22, 25),
	tgloffstk = Color3.fromRGB(40, 40, 46),
	knboff = Color3.fromRGB(125, 125, 132),
	knbon = Color3.fromRGB(10, 10, 12),
	rowhvr = Color3.fromRGB(22, 22, 26),
	btnbg = Color3.fromRGB(20, 20, 23),
	txtpri = Color3.fromRGB(245, 245, 250),
	txtsec = Color3.fromRGB(180, 180, 188),
	txtmut = Color3.fromRGB(110, 110, 118),
	tabact = Color3.fromRGB(20, 20, 24)
}

local function create(classname, properties)
	local inst = Instance.new(classname)
	for prop, val in pairs(properties or {}) do
		inst[prop] = val
	end
	return inst
end

local function formatkey(key)
	if not key or key == Enum.KeyCode.Unknown then
		return "none"
	end
	local map = {
		LeftAlt = "lalt",
		RightAlt = "ralt",
		LeftShift = "lshift",
		RightShift = "rshift",
		LeftControl = "lctrl",
		RightControl = "rctrl",
		Backspace = "back",
		Return = "enter",
		Space = "space",
		Tab = "tab",
		Insert = "ins",
		Delete = "del"
	}
	return map[key.Name] or string.lower(key.Name)
end

function crescent:notify(data)
	data = data or {}
	local notifytitle = string.lower(tostring(data.title or "crescent"))
	local notifycontent = string.lower(tostring(data.content or ""))
	local duration = data.duration or 4

	local gui = cg:FindFirstChild("crescentnotifygui")
	if not gui then
		gui = create("ScreenGui", {
			Name = "crescentnotifygui",
			Parent = cg,
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		})
	end

	local container = gui:FindFirstChild("container")
	if not container then
		container = create("Frame", {
			Name = "container",
			BackgroundTransparency = 1,
			Position = UDim2.new(1, -275, 1, -20),
			AnchorPoint = Vector2.new(0, 1),
			Size = UDim2.new(0, 255, 1, -40),
			Parent = gui
		})
		create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, 8),
			Parent = container
		})
	end

	local card = create("Frame", {
		Size = UDim2.new(1, 0, 0, 58),
		BackgroundColor3 = thm.crd,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = container
	})
	create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = card })
	local stroke = create("UIStroke", {
		Color = thm.crdstk,
		Thickness = 1,
		Transparency = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = card
	})

	local titlelabel = create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 8),
		Size = UDim2.new(1, -24, 0, 15),
		Font = Enum.Font.GothamBold,
		Text = notifytitle,
		TextColor3 = thm.acc,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTransparency = 1,
		Parent = card
	})

	local desclabel = create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 25),
		Size = UDim2.new(1, -24, 0, 24),
		Font = Enum.Font.GothamMedium,
		Text = notifycontent,
		TextColor3 = thm.txtsec,
		TextSize = 11,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextTransparency = 1,
		Parent = card
	})

	local progbar = create("Frame", {
		Position = UDim2.new(0, 0, 1, -2),
		Size = UDim2.new(1, 0, 0, 2),
		BackgroundColor3 = thm.acc,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Parent = card
	})

	ts:Create(card, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
	ts:Create(stroke, TweenInfo.new(0.22), { Transparency = 0 }):Play()
	ts:Create(titlelabel, TweenInfo.new(0.22), { TextTransparency = 0 }):Play()
	ts:Create(desclabel, TweenInfo.new(0.22), { TextTransparency = 0 }):Play()
	ts:Create(progbar, TweenInfo.new(0.22), { BackgroundTransparency = 0.25 }):Play()
	ts:Create(progbar, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 0, 2) }):Play()

	task.delay(duration, function()
		if card and card.Parent then
			local fade = ts:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
			ts:Create(stroke, TweenInfo.new(0.2), { Transparency = 1 }):Play()
			ts:Create(titlelabel, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
			ts:Create(desclabel, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
			ts:Create(progbar, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
			fade:Play()
			fade.Completed:Connect(function()
				if card then
					card:Destroy()
				end
			end)
		end
	end)
end

function crescent:createwindow(cfg)
	cfg = cfg or {}
	local wtitle = string.lower(tostring(cfg.title or "by dimhev"))
	local wfooter = string.lower(tostring(cfg.footer or "crescent | by dimhev"))
	local wsize = cfg.size or Vector2.new(780, 520)
	local minsize = Vector2.new(680, 440)
	local togglekey = cfg.togglekey or Enum.KeyCode.LeftAlt
	local connections = {}

	local old = cg:FindFirstChild("crescentgui")
	if old then
		old:Destroy()
	end

	local gui = create("ScreenGui", {
		Name = "crescentgui",
		Parent = cg,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	})

	local tooltipframe = create("Frame", {
		Name = "crescenttooltip",
		Size = UDim2.new(0, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(13, 13, 15),
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 300,
		Parent = gui
	})
	create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = tooltipframe })
	create("UIStroke", {
		Color = thm.crdstk,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = tooltipframe
	})
	create("UIPadding", {
		PaddingTop = UDim.new(0, 5),
		PaddingBottom = UDim.new(0, 5),
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		Parent = tooltipframe
	})

	local tooltiplabel = create("TextLabel", {
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		TextColor3 = thm.txtsec,
		TextSize = 11,
		AutomaticSize = Enum.AutomaticSize.XY,
		ZIndex = 301,
		Parent = tooltipframe
	})

	local function showtooltip(text)
		if text and text ~= "" then
			tooltiplabel.Text = string.lower(tostring(text))
			tooltipframe.Visible = true
		end
	end

	local function hidetooltip()
		tooltipframe.Visible = false
	end

	table.insert(connections, uis.InputChanged:Connect(function(input)
		if tooltipframe.Visible and input.UserInputType == Enum.UserInputType.MouseMovement then
			tooltipframe.Position = UDim2.new(0, input.Position.X + 14, 0, input.Position.Y + 14)
		end
	end))

	local watermark = create("Frame", {
		Position = UDim2.new(0, 16, 0, 16),
		Size = UDim2.new(0, 0, 0, 26),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = thm.tb,
		BorderSizePixel = 0,
		Visible = cfg.watermark ~= false,
		Parent = gui
	})
	create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = watermark })
	create("UIStroke", {
		Color = thm.crdstk,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = watermark
	})
	create("UIPadding", {
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
		Parent = watermark
	})

	local wmtext = create("TextLabel", {
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		Text = "crescent  |  60 fps  |  0 ms",
		TextColor3 = thm.txtsec,
		TextSize = 11,
		Parent = watermark
	})

	local main = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, wsize.X, 0, wsize.Y),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = thm.bg,
		BorderSizePixel = 0,
		Parent = gui
	})
	create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = main })
	create("UIStroke", {
		Color = thm.crdstk,
		Thickness = 1.2,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = main
	})

	local mainscale = create("UIScale", {
		Scale = 1,
		Parent = main
	})

	local topbar = create("Frame", {
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundColor3 = thm.tb,
		BorderSizePixel = 0,
		Parent = main
	})
	create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = topbar })

	create("Frame", {
		Size = UDim2.new(1, 0, 0, 8),
		Position = UDim2.new(0, 0, 1, -8),
		BackgroundColor3 = thm.tb,
		BorderSizePixel = 0,
		Parent = topbar
	})

	create("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = thm.crdstk,
		BorderSizePixel = 0,
		Parent = topbar
	})

	local iconimg = create("ImageLabel", {
		Position = UDim2.new(0, 14, 0.5, -9),
		Size = UDim2.new(0, 18, 0, 18),
		BackgroundTransparency = 1,
		Image = "rbxassetid://132049320741473",
		Rotation = 90,
		Parent = topbar
	})
	create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = iconimg })

	local titlelabel = create("TextLabel", {
		Position = UDim2.new(0, 40, 0, 0),
		Size = UDim2.new(0, 220, 1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = wtitle,
		TextSize = 13,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = topbar
	})

	local titlegradient = create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.0, Color3.fromRGB(135, 135, 142)),
			ColorSequenceKeypoint.new(0.25, Color3.fromRGB(205, 205, 212)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.75, Color3.fromRGB(205, 205, 212)),
			ColorSequenceKeypoint.new(1.0, Color3.fromRGB(135, 135, 142))
		}),
		Parent = titlelabel
	})

	local searchbg = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -92, 0.5, 0),
		Size = UDim2.new(0, 185, 0, 26),
		BackgroundColor3 = thm.tgloff,
		BorderSizePixel = 0,
		Parent = topbar
	})
	create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = searchbg })
	local searchstroke = create("UIStroke", {
		Color = thm.crdstk,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = searchbg
	})

	local searchbox = create("TextBox", {
		Position = UDim2.new(0, 9, 0, 0),
		Size = UDim2.new(1, -18, 1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		Text = "",
		PlaceholderText = "search module...",
		PlaceholderColor3 = thm.txtmut,
		TextColor3 = thm.txtpri,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		Parent = searchbg
	})

	local bindbadge = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.new(0, 72, 0, 26),
		BackgroundColor3 = thm.tgloff,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamMedium,
		Text = "[alt]",
		TextColor3 = thm.txtsec,
		TextSize = 11,
		Parent = topbar
	})
	create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = bindbadge })
	local bindstroke = create("UIStroke", {
		Color = thm.crdstk,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = bindbadge
	})

	local bindingui = false
	bindbadge.MouseButton1Click:Connect(function()
		bindingui = true
		bindbadge.Text = "[...]"
		ts:Create(bindstroke, TweenInfo.new(0.15), { Color = thm.accstk }):Play()
	end)

	local dragging = false
	local dragstart = nil
	local startpos = nil

	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragstart = input.Position
			startpos = main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	local sidebar = create("Frame", {
		Position = UDim2.new(0, 0, 0, 43),
		Size = UDim2.new(0, 142, 1, -69),
		BackgroundColor3 = thm.sb,
		BorderSizePixel = 0,
		Parent = main
	})

	create("Frame", {
		Position = UDim2.new(1, -1, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
		BackgroundColor3 = thm.crdstk,
		BorderSizePixel = 0,
		Parent = sidebar
	})

	local tabcontainer = create("ScrollingFrame", {
		Position = UDim2.new(0, 8, 0, 10),
		Size = UDim2.new(1, -17, 1, -56),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = sidebar
	})

	create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5),
		Parent = tabcontainer
	})

	local userpanel = create("Frame", {
		Position = UDim2.new(0, 8, 1, -40),
		Size = UDim2.new(1, -17, 0, 32),
		BackgroundColor3 = thm.crd,
		BorderSizePixel = 0,
		Parent = sidebar
	})
	create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = userpanel })
	create("UIStroke", {
		Color = thm.crdstk,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = userpanel
	})

	create("TextLabel", {
		Position = UDim2.new(0, 10, 0, 0),
		Size = UDim2.new(1, -20, 1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		Text = string.lower(lp and lp.Name or "guest"),
		TextColor3 = thm.txtsec,
		TextSize = 11,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = userpanel
	})

	local contentholder = create("Frame", {
		Position = UDim2.new(0, 142, 0, 43),
		Size = UDim2.new(1, -142, 1, -69),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = main
	})

	local footer = create("Frame", {
		Position = UDim2.new(0, 0, 1, -26),
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundColor3 = thm.ftr,
		BorderSizePixel = 0,
		Parent = main
	})
	create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = footer })

	create("Frame", {
		Size = UDim2.new(1, 0, 0, 8),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = thm.ftr,
		BorderSizePixel = 0,
		Parent = footer
	})

	create("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = thm.crdstk,
		BorderSizePixel = 0,
		Parent = footer
	})

	create("TextLabel", {
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(0.5, -12, 1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		Text = wfooter,
		TextColor3 = thm.txtmut,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = footer
	})

	local statslabel = create("TextLabel", {
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(0.5, -24, 1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		Text = "alt to toggle  |  60 fps",
		TextColor3 = thm.txtmut,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = footer
	})

	local resizegrip = create("TextButton", {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -3, 1, -3),
		Size = UDim2.new(0, 14, 0, 14),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = 20,
		Parent = main
	})

	local gripdot = create("Frame", {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -3, 1, -3),
		Size = UDim2.new(0, 5, 0, 5),
		BackgroundColor3 = thm.crdstk,
		BorderSizePixel = 0,
		Parent = resizegrip
	})
	create("UICorner", { CornerRadius = UDim.new(0, 2), Parent = gripdot })

	local resizing = false
	local resizestart = nil
	local startsize = nil

	resizegrip.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = true
			resizestart = input.Position
			startsize = main.Size
		end
	end)

	table.insert(connections, uis.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = false
		end
	end))

	table.insert(connections, uis.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragging then
				local delta = input.Position - dragstart
				main.Position = UDim2.new(
					startpos.X.Scale,
					startpos.X.Offset + delta.X,
					startpos.Y.Scale,
					startpos.Y.Offset + delta.Y
				)
			elseif resizing then
				local delta = input.Position - resizestart
				local nx = math.clamp(startsize.X.Offset + delta.X, minsize.X, 1200)
				local ny = math.clamp(startsize.Y.Offset + delta.Y, minsize.Y, 850)
				main.Size = UDim2.new(0, nx, 0, ny)
			end
		end
	end))

	local fpsframes = 0
	local fpstimer = tick()

	table.insert(connections, rs.RenderStepped:Connect(function()
		local offset = (tick() * 0.65) % 2 - 1
		titlegradient.Offset = Vector2.new(offset, 0)

		fpsframes = fpsframes + 1
		local now = tick()
		if now - fpstimer >= 0.5 then
			local fps = math.floor(fpsframes / (now - fpstimer))
			fpsframes = 0
			fpstimer = now
			local ping = 0
			pcall(function()
				ping = math.floor(stats.Network.ServerStatsItem["Data Ping"]:GetValue())
			end)
			wmtext.Text = "crescent  |  " .. tostring(fps) .. " fps  |  " .. tostring(ping) .. " ms"
			statslabel.Text = tostring(fps) .. " fps  |  " .. tostring(ping) .. " ms"
		end
	end))

	local isopen = true
	local isanimating = false

	local function toggleui()
		if isanimating then
			return
		end
		isanimating = true

		if isopen then
			hidetooltip()
			dragging = false
			resizing = false
			local tw = ts:Create(mainscale, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Scale = 0.92 })
			tw:Play()
			tw.Completed:Connect(function()
				main.Visible = false
				isopen = false
				isanimating = false
			end)
		else
			main.Visible = true
			mainscale.Scale = 0.92
			local tw = ts:Create(mainscale, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Scale = 1 })
			tw:Play()
			tw.Completed:Connect(function()
				isopen = true
				isanimating = false
			end)
		end
	end

	table.insert(connections, uis.InputBegan:Connect(function(input, gpe)
		if bindingui and input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode ~= Enum.KeyCode.Escape then
				togglekey = input.KeyCode
			end
			bindbadge.Text = "[" .. formatkey(togglekey) .. "]"
			ts:Create(bindstroke, TweenInfo.new(0.15), { Color = thm.crdstk }):Play()
			bindingui = false
			return
		end

		if uis:GetFocusedTextBox() then
			return
		end

		if input.UserInputType == Enum.UserInputType.Keyboard then
			local isaltdefault = (togglekey == Enum.KeyCode.LeftAlt or togglekey == Enum.KeyCode.RightAlt)
			if isaltdefault and (input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt) then
				toggleui()
			elseif input.KeyCode == togglekey then
				toggleui()
			end
		end
	end))

	local window = {
		gui = gui,
		main = main,
		watermark = watermark,
		tabs = {},
		activetab = nil,
		connections = connections
	}

	local function applysearch(query)
		local q = string.lower(query or "")
		if not window.activetab then
			return
		end
		for _, sec in ipairs(window.activetab.sections) do
			local visibleitems = 0
			for _, item in ipairs(sec.items) do
				local matched = (q == "") or (string.find(item.name, q, 1, true) ~= nil)
				item.frame.Visible = matched
				if matched then
					visibleitems = visibleitems + 1
				end
			end
			sec.card.Visible = (q == "") or (visibleitems > 0) or (string.find(sec.name, q, 1, true) ~= nil)
		end
	end

	searchbox.Focused:Connect(function()
		ts:Create(searchstroke, TweenInfo.new(0.15), { Color = thm.accstk }):Play()
	end)

	searchbox.FocusLost:Connect(function()
		ts:Create(searchstroke, TweenInfo.new(0.15), { Color = thm.crdstk }):Play()
	end)

	searchbox:GetPropertyChangedSignal("Text"):Connect(function()
		applysearch(searchbox.Text)
	end)

	function window:setwatermark(state)
		self.watermark.Visible = state
	end

	function window:toggle()
		toggleui()
	end

	function window:destroy()
		for _, conn in ipairs(self.connections) do
			if conn and conn.Connected then
				conn:Disconnect()
			end
		end
		self.connections = {}
		if self.gui then
			self.gui:Destroy()
		end
	end

	function window:createtab(tabname)
		local cleanname = string.lower(tostring(tabname))

		local tabbtn = create("TextButton", {
			Size = UDim2.new(1, 0, 0, 32),
			BackgroundTransparency = 1,
			BackgroundColor3 = thm.tabact,
			BorderSizePixel = 0,
			Font = Enum.Font.GothamBold,
			Text = cleanname,
			TextColor3 = thm.txtmut,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = tabcontainer
		})
		create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = tabbtn })
		create("UIPadding", {
			PaddingLeft = UDim.new(0, 12),
			Parent = tabbtn
		})

		local indicator = create("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, -8, 0.5, 0),
			Size = UDim2.new(0, 2, 0, 0),
			BackgroundColor3 = thm.acc,
			BorderSizePixel = 0,
			Parent = tabbtn
		})
		create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = indicator })

		local page = create("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = thm.crdstk,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false,
			Parent = contentholder
		})
		create("UIPadding", {
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 14),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
			Parent = page
		})

		local colleft = create("Frame", {
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(0.5, -5, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = page
		})
		create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 10),
			Parent = colleft
		})

		local colright = create("Frame", {
			Position = UDim2.new(0.5, 5, 0, 0),
			Size = UDim2.new(0.5, -5, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = page
		})
		create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 10),
			Parent = colright
		})

		local tab = {
			name = cleanname,
			btn = tabbtn,
			indicator = indicator,
			page = page,
			colleft = colleft,
			colright = colright,
			sections = {},
			sectionscount = 0
		}

		local function selecttab()
			for _, item in ipairs(window.tabs) do
				item.page.Visible = false
				ts:Create(item.btn, TweenInfo.new(0.16), { BackgroundTransparency = 1, TextColor3 = thm.txtmut }):Play()
				ts:Create(item.indicator, TweenInfo.new(0.16), { Size = UDim2.new(0, 2, 0, 0) }):Play()
			end
			tab.page.Visible = true
			ts:Create(tab.btn, TweenInfo.new(0.16), { BackgroundTransparency = 0, TextColor3 = thm.txtpri }):Play()
			ts:Create(tab.indicator, TweenInfo.new(0.16), { Size = UDim2.new(0, 2, 0, 14) }):Play()
			window.activetab = tab
			applysearch(searchbox.Text)
		end

		tabbtn.MouseButton1Click:Connect(selecttab)

		table.insert(window.tabs, tab)
		if #window.tabs == 1 then
			selecttab()
		end

		function tab:createsection(secname, side)
			self.sectionscount = self.sectionscount + 1
			local cleansec = string.lower(tostring(secname))
			local parentcol
			if side == "left" then
				parentcol = self.colleft
			elseif side == "right" then
				parentcol = self.colright
			else
				parentcol = (self.sectionscount % 2 == 1) and self.colleft or self.colright
			end

			local card = create("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = thm.crd,
				BorderSizePixel = 0,
				Parent = parentcol
			})
			create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = card })
			create("UIStroke", {
				Color = thm.crdstk,
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Parent = card
			})
			create("UIPadding", {
				PaddingTop = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
				Parent = card
			})

			local cardlayout = create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 7),
				Parent = card
			})

			create("TextLabel", {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 16),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamBold,
				Text = cleansec,
				TextColor3 = thm.txtpri,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = card
			})

			create("Frame", {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = thm.crddiv,
				BorderSizePixel = 0,
				Parent = card
			})

			local list = create("Frame", {
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Parent = card
			})
			create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 6),
				Parent = list
			})

			local section = {
				name = cleansec,
				card = card,
				list = list,
				items = {}
			}

			table.insert(self.sections, section)

			local function registeritem(itemname, frame)
				table.insert(section.items, {
					name = string.lower(tostring(itemname)),
					frame = frame
				})
			end

			function section:createlabel(text)
				local clean = string.lower(tostring(text))
				local lbl = create("TextLabel", {
					Size = UDim2.new(1, 0, 0, 20),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = clean,
					TextColor3 = thm.txtmut,
					TextSize = 11,
					TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = self.list
				})
				create("UIPadding", {
					PaddingLeft = UDim.new(0, 6),
					PaddingRight = UDim.new(0, 6),
					Parent = lbl
				})
				registeritem(clean, lbl)

				local ctrl = {}
				function ctrl:set(newtext)
					lbl.Text = string.lower(tostring(newtext))
				end
				return ctrl
			end

			function section:createdivider()
				local div = create("Frame", {
					Size = UDim2.new(1, 0, 0, 9),
					BackgroundTransparency = 1,
					Parent = self.list
				})
				create("Frame", {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 4, 0.5, 0),
					Size = UDim2.new(1, -8, 0, 1),
					BackgroundColor3 = thm.crddiv,
					BorderSizePixel = 0,
					Parent = div
				})
				return div
			end

			function section:createtoggle(name, defaultval, callback, desc)
				local clean = string.lower(tostring(name))
				local state = defaultval or false

				local row = create("Frame", {
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundColor3 = thm.rowhvr,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Parent = self.list
				})
				create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = row })
				create("UIPadding", {
					PaddingLeft = UDim.new(0, 6),
					PaddingRight = UDim.new(0, 6),
					Parent = row
				})

				local label = create("TextLabel", {
					Size = UDim2.new(1, -46, 1, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = clean,
					TextColor3 = state and thm.txtpri or thm.txtsec,
					TextSize = 12,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = row
				})

				local togglebg = create("Frame", {
					Size = UDim2.new(0, 36, 0, 18),
					Position = UDim2.new(1, -36, 0.5, -9),
					BackgroundColor3 = state and thm.accglw or thm.tgloff,
					BorderSizePixel = 0,
					Parent = row
				})
				create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = togglebg })
				local togglestroke = create("UIStroke", {
					Color = state and thm.accstk or thm.tgloffstk,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Parent = togglebg
				})

				local knob = create("Frame", {
					Size = UDim2.new(0, 12, 0, 12),
					Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
					BackgroundColor3 = state and thm.knbon or thm.knboff,
					BorderSizePixel = 0,
					Parent = togglebg
				})
				create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })

				local btn = create("TextButton", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = "",
					Parent = row
				})

				local function applystate(val, silent)
					state = val
					local targetcolor = state and thm.accglw or thm.tgloff
					local strokecolor = state and thm.accstk or thm.tgloffstk
					local knobcolor = state and thm.knbon or thm.knboff
					local knobpos = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
					local textcolor = state and thm.txtpri or thm.txtsec

					ts:Create(togglebg, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = targetcolor }):Play()
					ts:Create(togglestroke, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Color = strokecolor }):Play()
					ts:Create(knob, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = knobpos, BackgroundColor3 = knobcolor }):Play()
					ts:Create(label, TweenInfo.new(0.16), { TextColor3 = textcolor }):Play()

					if not silent and callback then
						callback(state)
					end
				end

				btn.MouseEnter:Connect(function()
					ts:Create(row, TweenInfo.new(0.14), { BackgroundTransparency = 0.45 }):Play()
					if desc then showtooltip(desc) end
				end)

				btn.MouseLeave:Connect(function()
					ts:Create(row, TweenInfo.new(0.14), { BackgroundTransparency = 1 }):Play()
					hidetooltip()
				end)

				btn.MouseButton1Click:Connect(function()
					applystate(not state, false)
				end)

				registeritem(clean, row)

				local ctrl = { frame = row }
				function ctrl:set(val, silent)
					applystate(val, silent)
				end
				function ctrl:get()
					return state
				end
				return ctrl
			end

			function section:createbutton(name, callback, desc)
				local clean = string.lower(tostring(name))

				local row = create("Frame", {
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundTransparency = 1,
					Parent = self.list
				})

				local btnframe = create("TextButton", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = thm.btnbg,
					BorderSizePixel = 0,
					Font = Enum.Font.GothamBold,
					Text = clean,
					TextColor3 = thm.txtsec,
					TextSize = 12,
					Parent = row
				})
				create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = btnframe })
				local btnstroke = create("UIStroke", {
					Color = thm.crdstk,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Parent = btnframe
				})

				btnframe.MouseEnter:Connect(function()
					ts:Create(btnframe, TweenInfo.new(0.14), { BackgroundColor3 = thm.rowhvr, TextColor3 = thm.txtpri }):Play()
					ts:Create(btnstroke, TweenInfo.new(0.14), { Color = thm.acc }):Play()
					if desc then showtooltip(desc) end
				end)

				btnframe.MouseLeave:Connect(function()
					ts:Create(btnframe, TweenInfo.new(0.14), { BackgroundColor3 = thm.btnbg, TextColor3 = thm.txtsec }):Play()
					ts:Create(btnstroke, TweenInfo.new(0.14), { Color = thm.crdstk }):Play()
					hidetooltip()
				end)

				btnframe.MouseButton1Click:Connect(function()
					if callback then
						callback()
					end
				end)

				registeritem(clean, row)
				return btnframe
			end

			function section:createslider(name, minval, maxval, defaultval, callback, desc)
				local clean = string.lower(tostring(name))
				minval = minval or 0
				maxval = maxval or 100
				local curval = math.clamp(defaultval or minval, minval, maxval)

				local box = create("Frame", {
					Size = UDim2.new(1, 0, 0, 44),
					BackgroundColor3 = thm.rowhvr,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Parent = self.list
				})
				create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = box })
				create("UIPadding", {
					PaddingTop = UDim.new(0, 5),
					PaddingBottom = UDim.new(0, 5),
					PaddingLeft = UDim.new(0, 6),
					PaddingRight = UDim.new(0, 6),
					Parent = box
				})

				create("TextLabel", {
					Size = UDim2.new(1, -56, 0, 15),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = clean,
					TextColor3 = thm.txtsec,
					TextSize = 12,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = box
				})

				local valbox = create("TextBox", {
					Position = UDim2.new(1, -54, 0, 0),
					Size = UDim2.new(0, 54, 0, 15),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamBold,
					Text = tostring(curval),
					TextColor3 = thm.acc,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Right,
					ClearTextOnFocus = false,
					Parent = box
				})

				local bar = create("Frame", {
					Position = UDim2.new(0, 0, 0, 24),
					Size = UDim2.new(1, 0, 0, 8),
					BackgroundColor3 = thm.tgloff,
					BorderSizePixel = 0,
					Parent = box
				})
				create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = bar })
				create("UIStroke", {
					Color = thm.tgloffstk,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Parent = bar
				})

				local initpct = (curval - minval) / math.max(1, (maxval - minval))
				local fill = create("Frame", {
					Size = UDim2.new(initpct, 0, 1, 0),
					BackgroundColor3 = thm.accglw,
					BorderSizePixel = 0,
					Parent = bar
				})
				create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })

				local hittrigger = create("TextButton", {
					Position = UDim2.new(0, 0, 0, 19),
					Size = UDim2.new(1, 0, 0, 18),
					BackgroundTransparency = 1,
					Text = "",
					Parent = box
				})

				local sliding = false

				local function setval(num, silent)
					curval = math.clamp(math.floor(num + 0.5), minval, maxval)
					local pct = (curval - minval) / math.max(1, (maxval - minval))
					valbox.Text = tostring(curval)
					ts:Create(fill, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(pct, 0, 1, 0) }):Play()
					if not silent and callback then
						callback(curval)
					end
				end

				local function updateslider(input)
					local abspos = bar.AbsolutePosition.X
					local abssize = bar.AbsoluteSize.X
					local pct = math.clamp((input.Position.X - abspos) / math.max(1, abssize), 0, 1)
					setval(minval + ((maxval - minval) * pct), false)
				end

				valbox.FocusLost:Connect(function()
					local n = tonumber(valbox.Text)
					if n then
						setval(n, false)
					else
						valbox.Text = tostring(curval)
					end
				end)

				hittrigger.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						sliding = true
						updateslider(input)
					end
				end)

				table.insert(window.connections, uis.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						sliding = false
					end
				end))

				table.insert(window.connections, uis.InputChanged:Connect(function(input)
					if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						updateslider(input)
					end
				end))

				box.MouseEnter:Connect(function()
					ts:Create(box, TweenInfo.new(0.14), { BackgroundTransparency = 0.45 }):Play()
					if desc then showtooltip(desc) end
				end)

				box.MouseLeave:Connect(function()
					ts:Create(box, TweenInfo.new(0.14), { BackgroundTransparency = 1 }):Play()
					hidetooltip()
				end)

				registeritem(clean, box)

				local ctrl = { frame = box }
				function ctrl:set(val, silent)
					setval(val, silent)
				end
				function ctrl:get()
					return curval
				end
				return ctrl
			end

			function section:createtextbox(name, placeholder, defaultval, callback, desc)
				local clean = string.lower(tostring(name))
				if type(defaultval) == "function" then
					desc = callback
					callback = defaultval
					defaultval = ""
				end

				local row = create("Frame", {
					Size = UDim2.new(1, 0, 0, 32),
					BackgroundColor3 = thm.rowhvr,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Parent = self.list
				})
				create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = row })
				create("UIPadding", {
					PaddingLeft = UDim.new(0, 6),
					PaddingRight = UDim.new(0, 6),
					Parent = row
				})

				local label = create("TextLabel", {
					Size = UDim2.new(1, -102, 1, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = clean,
					TextColor3 = thm.txtsec,
					TextSize = 12,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = row
				})

				local inputbg = create("Frame", {
					Size = UDim2.new(0, 94, 0, 22),
					Position = UDim2.new(1, -94, 0.5, -11),
					BackgroundColor3 = thm.tgloff,
					BorderSizePixel = 0,
					Parent = row
				})
				create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = inputbg })
				local inputstroke = create("UIStroke", {
					Color = thm.tgloffstk,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Parent = inputbg
				})

				local inputbox = create("TextBox", {
					Size = UDim2.new(1, -12, 1, 0),
					Position = UDim2.new(0, 6, 0, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = defaultval and tostring(defaultval) or "",
					PlaceholderText = string.lower(tostring(placeholder or "value...")),
					PlaceholderColor3 = thm.txtmut,
					TextColor3 = thm.txtpri,
					TextSize = 11,
					TextXAlignment = Enum.TextXAlignment.Left,
					ClearTextOnFocus = false,
					ClipsDescendants = true,
					Parent = inputbg
				})

				inputbox.Focused:Connect(function()
					ts:Create(inputstroke, TweenInfo.new(0.14), { Color = thm.accstk }):Play()
					ts:Create(label, TweenInfo.new(0.14), { TextColor3 = thm.txtpri }):Play()
				end)

				inputbox.FocusLost:Connect(function()
					ts:Create(inputstroke, TweenInfo.new(0.14), { Color = thm.tgloffstk }):Play()
					ts:Create(label, TweenInfo.new(0.14), { TextColor3 = thm.txtsec }):Play()
					if callback then
						local result = callback(inputbox.Text)
						if type(result) == "string" then
							inputbox.Text = result
						end
					end
				end)

				row.MouseEnter:Connect(function()
					ts:Create(row, TweenInfo.new(0.14), { BackgroundTransparency = 0.45 }):Play()
					if desc then showtooltip(desc) end
				end)

				row.MouseLeave:Connect(function()
					ts:Create(row, TweenInfo.new(0.14), { BackgroundTransparency = 1 }):Play()
					hidetooltip()
				end)

				registeritem(clean, row)

				local ctrl = { frame = row }
				function ctrl:set(val)
					inputbox.Text = tostring(val)
				end
				function ctrl:get()
					return inputbox.Text
				end
				return ctrl
			end

			function section:createkeybind(name, defaultkey, callback, desc)
				local clean = string.lower(tostring(name))
				local curkey = defaultkey or Enum.KeyCode.Unknown
				local listening = false

				local row = create("Frame", {
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundColor3 = thm.rowhvr,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Parent = self.list
				})
				create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = row })
				create("UIPadding", {
					PaddingLeft = UDim.new(0, 6),
					PaddingRight = UDim.new(0, 6),
					Parent = row
				})

				create("TextLabel", {
					Size = UDim2.new(1, -78, 1, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = clean,
					TextColor3 = thm.txtsec,
					TextSize = 12,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = row
				})

				local bindbtn = create("TextButton", {
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.new(0, 68, 0, 22),
					BackgroundColor3 = thm.tgloff,
					BorderSizePixel = 0,
					Font = Enum.Font.GothamMedium,
					Text = "[" .. formatkey(curkey) .. "]",
					TextColor3 = thm.txtpri,
					TextSize = 11,
					Parent = row
				})
				create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = bindbtn })
				local bstroke = create("UIStroke", {
					Color = thm.tgloffstk,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Parent = bindbtn
				})

				bindbtn.MouseButton1Click:Connect(function()
					listening = true
					bindbtn.Text = "[...]"
					ts:Create(bstroke, TweenInfo.new(0.14), { Color = thm.accstk }):Play()
				end)

				table.insert(window.connections, uis.InputBegan:Connect(function(input, gpe)
					if listening then
						if input.UserInputType == Enum.UserInputType.Keyboard then
							if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Backspace then
								curkey = Enum.KeyCode.Unknown
							else
								curkey = input.KeyCode
							end
							bindbtn.Text = "[" .. formatkey(curkey) .. "]"
							ts:Create(bstroke, TweenInfo.new(0.14), { Color = thm.tgloffstk }):Play()
							listening = false
						end
						return
					end

					if not gpe and not uis:GetFocusedTextBox() and curkey ~= Enum.KeyCode.Unknown and input.KeyCode == curkey then
						if callback then
							callback(curkey)
						end
					end
				end))

				row.MouseEnter:Connect(function()
					ts:Create(row, TweenInfo.new(0.14), { BackgroundTransparency = 0.45 }):Play()
					if desc then showtooltip(desc) end
				end)

				row.MouseLeave:Connect(function()
					ts:Create(row, TweenInfo.new(0.14), { BackgroundTransparency = 1 }):Play()
					hidetooltip()
				end)

				registeritem(clean, row)
				return row
			end

			function section:createdropdown(name, options, defaultopt, callback, desc)
				local clean = string.lower(tostring(name))
				options = options or {}
				local selected = defaultopt and string.lower(tostring(defaultopt)) or (options[1] and string.lower(tostring(options[1])) or "none")
				local opened = false

				local wrapper = create("Frame", {
					Size = UDim2.new(1, 0, 0, 32),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Parent = self.list
				})
				create("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4),
					Parent = wrapper
				})

				local header = create("TextButton", {
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 32),
					BackgroundColor3 = thm.tgloff,
					BorderSizePixel = 0,
					Text = "",
					Parent = wrapper
				})
				create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = header })
				local hstroke = create("UIStroke", {
					Color = thm.tgloffstk,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Parent = header
				})

				create("TextLabel", {
					Position = UDim2.new(0, 8, 0, 0),
					Size = UDim2.new(0.55, -8, 1, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = clean,
					TextColor3 = thm.txtsec,
					TextSize = 12,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = header
				})

				local seltext = create("TextLabel", {
					Position = UDim2.new(0.55, 0, 0, 0),
					Size = UDim2.new(0.45, -8, 1, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamBold,
					Text = selected,
					TextColor3 = thm.txtpri,
					TextSize = 11,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Right,
					Parent = header
				})

				local dropbox = create("Frame", {
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = thm.sb,
					BorderSizePixel = 0,
					Visible = false,
					Parent = wrapper
				})
				create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = dropbox })
				create("UIStroke", {
					Color = thm.crdstk,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Parent = dropbox
				})
				create("UIPadding", {
					PaddingTop = UDim.new(0, 4),
					PaddingBottom = UDim.new(0, 4),
					PaddingLeft = UDim.new(0, 4),
					PaddingRight = UDim.new(0, 4),
					Parent = dropbox
				})
				create("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 3),
					Parent = dropbox
				})

				local function rebuild(opts)
					for _, ch in ipairs(dropbox:GetChildren()) do
						if ch:IsA("TextButton") then
							ch:Destroy()
						end
					end
					for _, opt in ipairs(opts) do
						local optstr = string.lower(tostring(opt))
						local optbtn = create("TextButton", {
							Size = UDim2.new(1, 0, 0, 24),
							BackgroundColor3 = thm.rowhvr,
							BackgroundTransparency = (optstr == selected) and 0.3 or 1,
							BorderSizePixel = 0,
							Font = Enum.Font.GothamMedium,
							Text = optstr,
							TextColor3 = (optstr == selected) and thm.txtpri or thm.txtsec,
							TextSize = 11,
							TextXAlignment = Enum.TextXAlignment.Left,
							Parent = dropbox
						})
						create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = optbtn })
						create("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = optbtn })

						optbtn.MouseButton1Click:Connect(function()
							selected = optstr
							seltext.Text = selected
							opened = false
							dropbox.Visible = false
							ts:Create(hstroke, TweenInfo.new(0.14), { Color = thm.tgloffstk }):Play()
							rebuild(opts)
							if callback then
								callback(opt)
							end
						end)
					end
				end

				rebuild(options)

				header.MouseButton1Click:Connect(function()
					opened = not opened
					dropbox.Visible = opened
					ts:Create(hstroke, TweenInfo.new(0.14), { Color = opened and thm.accstk or thm.tgloffstk }):Play()
				end)

				header.MouseEnter:Connect(function()
					if desc then showtooltip(desc) end
				end)

				header.MouseLeave:Connect(function()
					hidetooltip()
				end)

				registeritem(clean, wrapper)

				local ctrl = { frame = wrapper }
				function ctrl:refresh(newopts, newdef)
					options = newopts or {}
					if newdef then
						selected = string.lower(tostring(newdef))
						seltext.Text = selected
					end
					rebuild(options)
				end
				function ctrl:get()
					return selected
				end
				return ctrl
			end

			return section
		end

		return tab
	end

	return window
end

return crescent
