local cg = game:GetService("CoreGui")
local plrs = game:GetService("Players")
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

local lp = plrs.LocalPlayer

local crescent = {}

local thm = {
	bg = Color3.fromRGB(8, 8, 8),
	sb = Color3.fromRGB(11, 11, 11),
	tb = Color3.fromRGB(11, 11, 11),
	ftr = Color3.fromRGB(11, 11, 11),
	crd = Color3.fromRGB(16, 16, 16),
	crdstk = Color3.fromRGB(34, 34, 34),
	crddiv = Color3.fromRGB(26, 26, 26),
	acc = Color3.fromRGB(255, 255, 255),
	accglw = Color3.fromRGB(240, 240, 240),
	accstk = Color3.fromRGB(255, 255, 255),
	tgloff = Color3.fromRGB(24, 24, 24),
	tgloffstk = Color3.fromRGB(42, 42, 42),
	knboff = Color3.fromRGB(130, 130, 130),
	knbon = Color3.fromRGB(10, 10, 10),
	rowhvr = Color3.fromRGB(24, 24, 24),
	btnbg = Color3.fromRGB(22, 22, 22),
	txtpri = Color3.fromRGB(250, 250, 250),
	txtsec = Color3.fromRGB(185, 185, 185),
	txtmut = Color3.fromRGB(115, 115, 115),
	tabact = Color3.fromRGB(22, 22, 22)
}

local function create(classname, properties)
	local inst = Instance.new(classname)
	for prop, val in pairs(properties or {}) do
		inst[prop] = val
	end
	return inst
end

function crescent:notify(data)
	local notifytitle = data.title or "notification"
	local notifycontent = data.content or ""
	local duration = data.duration or 4

	local gui = cg:FindFirstChild("crescentnotifygui")
	if not gui then
		gui = create("ScreenGui", {
			Name = "crescentnotifygui",
			Parent = cg,
			ResetOnSpawn = false
		})
	end

	local container = gui:FindFirstChild("container")
	if not container then
		container = create("Frame", {
			Name = "container",
			BackgroundTransparency = 1,
			Position = UDim2.new(1, -250, 1, -20),
			AnchorPoint = Vector2.new(0, 1),
			Size = UDim2.new(0, 235, 1, -40),
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
		Size = UDim2.new(1, 0, 0, 56),
		BackgroundColor3 = thm.crd,
		BackgroundTransparency = 1,
		Parent = container
	})
	create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = card })
	create("UIStroke", {
		Color = thm.crdstk,
		Thickness = 1.2,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = card
	})

	local titlelabel = create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 7),
		Size = UDim2.new(1, -24, 0, 16),
		Font = Enum.Font.GothamBold,
		Text = notifytitle,
		TextColor3 = thm.acc,
		TextSize = 13,
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
		TextSize = 12,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextTransparency = 1,
		Parent = card
	})

	ts:Create(card, TweenInfo.new(0.2), { BackgroundTransparency = 0 }):Play()
	ts:Create(titlelabel, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()
	ts:Create(desclabel, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()

	task.delay(duration, function()
		if card and card.Parent then
			local fade = ts:Create(card, TweenInfo.new(0.2), { BackgroundTransparency = 1 })
			ts:Create(titlelabel, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
			ts:Create(desclabel, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
			fade:Play()
			fade.Completed:Connect(function()
				card:Destroy()
			end)
		end
	end)
end

function crescent:createwindow(cfg)
	cfg = cfg or {}

	local gui = create("ScreenGui", {
		Name = "crescentgui",
		Parent = cg,
		ResetOnSpawn = false
	})

	local tooltipframe = create("Frame", {
		Name = "crescenttooltip",
		Size = UDim2.new(0, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(14, 14, 14),
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 200,
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
		ZIndex = 201,
		Parent = tooltipframe
	})

	local function showtooltip(text)
		if text and text ~= "" then
			tooltiplabel.Text = text
			tooltipframe.Visible = true
		end
	end

	local function hidetooltip()
		tooltipframe.Visible = false
	end

	uis.InputChanged:Connect(function(input)
		if tooltipframe.Visible and input.UserInputType == Enum.UserInputType.MouseMovement then
			tooltipframe.Position = UDim2.new(0, input.Position.X + 14, 0, input.Position.Y + 14)
		end
	end)

	local main = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 640, 0, 460),
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
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = thm.tb,
		BorderSizePixel = 0,
		Parent = main
	})
	create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = topbar })

	local topfix = create("Frame", {
		Size = UDim2.new(1, 0, 0, 8),
		Position = UDim2.new(0, 0, 1, -8),
		BackgroundColor3 = thm.tb,
		BorderSizePixel = 0,
		Parent = topbar
	})

	local topdivider = create("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = thm.crdstk,
		BorderSizePixel = 0,
		Parent = topbar
	})

	local iconimg = create("ImageLabel", {
		Position = UDim2.new(0, 12, 0.5, -10),
		Size = UDim2.new(0, 20, 0, 20),
		BackgroundTransparency = 1,
		Image = "rbxassetid://132049320741473",
		Rotation = 90,
		Parent = topbar
	})
	create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = iconimg })

	local titlelabel = create("TextLabel", {
		Position = UDim2.new(0, 38, 0, 0),
		Size = UDim2.new(0, 200, 1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = "by dimhev",
		TextSize = 14,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = topbar
	})

	local titlegradient = create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.0, Color3.fromRGB(130, 130, 130)),
			ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 200, 200)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.75, Color3.fromRGB(200, 200, 200)),
			ColorSequenceKeypoint.new(1.0, Color3.fromRGB(130, 130, 130))
		}),
		Parent = titlelabel
	})

	local shimmerconn = rs.RenderStepped:Connect(function()
		local offset = (tick() * 0.75) % 2 - 1
		titlegradient.Offset = Vector2.new(offset, 0)
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

	uis.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragstart
			main.Position = UDim2.new(
				startpos.X.Scale,
				startpos.X.Offset + delta.X,
				startpos.Y.Scale,
				startpos.Y.Offset + delta.Y
			)
		end
	end)

	local sidebar = create("Frame", {
		Position = UDim2.new(0, 0, 0, 41),
		Size = UDim2.new(0, 135, 1, -67),
		BackgroundColor3 = thm.sb,
		BorderSizePixel = 0,
		Parent = main
	})

	local sidebardivider = create("Frame", {
		Position = UDim2.new(1, -1, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
		BackgroundColor3 = thm.crdstk,
		BorderSizePixel = 0,
		Parent = sidebar
	})

	local tabcontainer = create("ScrollingFrame", {
		Position = UDim2.new(0, 8, 0, 8),
		Size = UDim2.new(1, -17, 1, -16),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = sidebar
	})

	create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 6),
		Parent = tabcontainer
	})

	local contentholder = create("Frame", {
		Position = UDim2.new(0, 135, 0, 41),
		Size = UDim2.new(1, -135, 1, -67),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
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
		Size = UDim2.new(1, -24, 1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		Text = "crescent | by dimhev",
		TextColor3 = thm.txtmut,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = footer
	})

	local isopen = true
	local isanimating = false

	local function toggleui()
		if isanimating then return end
		isanimating = true

		if isopen then
			hidetooltip()
			dragging = false
			local tw = ts:Create(mainscale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.85 })
			tw:Play()
			tw.Completed:Connect(function()
				main.Visible = false
				isopen = false
				isanimating = false
			end)
		else
			main.Visible = true
			mainscale.Scale = 0.85
			local tw = ts:Create(mainscale, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
			tw:Play()
			tw.Completed:Connect(function()
				isopen = true
				isanimating = false
			end)
		end
	end

	local keyconn = uis.InputBegan:Connect(function(input, gpe)
		if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
			toggleui()
		end
	end)

	local window = {
		gui = gui,
		main = main,
		tabs = {},
		activetab = nil,
		shimmerconn = shimmerconn,
		keyconn = keyconn
	}

	function window:toggle()
		toggleui()
	end

	function window:destroy()
		if self.shimmerconn then
			self.shimmerconn:Disconnect()
			self.shimmerconn = nil
		end
		if self.keyconn then
			self.keyconn:Disconnect()
			self.keyconn = nil
		end
		if self.gui then
			self.gui:Destroy()
		end
	end

	function window:createtab(tabname)
		local tabbtn = create("TextButton", {
			Size = UDim2.new(1, 0, 0, 32),
			BackgroundTransparency = 1,
			BackgroundColor3 = thm.tabact,
			BorderSizePixel = 0,
			Font = Enum.Font.GothamBold,
			Text = tabname,
			TextColor3 = thm.txtmut,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = tabcontainer
		})
		create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = tabbtn })
		create("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			Parent = tabbtn
		})

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
			PaddingTop = UDim.new(0, 14),
			PaddingBottom = UDim.new(0, 14),
			PaddingLeft = UDim.new(0, 14),
			PaddingRight = UDim.new(0, 14),
			Parent = page
		})

		local colleft = create("Frame", {
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(0.5, -7, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = page
		})
		create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12),
			Parent = colleft
		})

		local colright = create("Frame", {
			Position = UDim2.new(0.5, 7, 0, 0),
			Size = UDim2.new(0.5, -7, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = page
		})
		create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12),
			Parent = colright
		})

		local tab = {
			name = tabname,
			btn = tabbtn,
			page = page,
			colleft = colleft,
			colright = colright,
			sectionscount = 0
		}

		local function selecttab()
			for idx, item in ipairs(window.tabs) do
				item.page.Visible = false
				item.btn.BackgroundTransparency = 1
				item.btn.TextColor3 = thm.txtmut
			end
			tab.page.Visible = true
			tab.btn.BackgroundTransparency = 0
			tab.btn.TextColor3 = thm.txtpri
			window.activetab = tab
		end

		tabbtn.MouseButton1Click:Connect(selecttab)

		table.insert(window.tabs, tab)
		if #window.tabs == 1 then
			selecttab()
		end

		function tab:createsection(secname)
			self.sectionscount = self.sectionscount + 1
			local parentcol = (self.sectionscount % 2 == 1) and self.colleft or self.colright

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
				Thickness = 1.2,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Parent = card
			})
			create("UIPadding", {
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12),
				Parent = card
			})

			create("TextLabel", {
				Size = UDim2.new(1, 0, 0, 18),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamBold,
				Text = secname,
				TextColor3 = thm.txtpri,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = card
			})

			create("Frame", {
				Position = UDim2.new(0, 0, 0, 24),
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = thm.crddiv,
				BorderSizePixel = 0,
				Parent = card
			})

			local list = create("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 32),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Parent = card
			})
			create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10),
				Parent = list
			})

			local section = {
				card = card,
				list = list
			}

			function section:createtoggle(name, defaultval, callback, desc)
				local state = defaultval or false

				local row = create("Frame", {
					Size = UDim2.new(1, 0, 0, 34),
					BackgroundColor3 = thm.rowhvr,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Parent = self.list
				})
				create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = row })
				create("UIPadding", {
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					Parent = row
				})

				local label = create("TextLabel", {
					Size = UDim2.new(1, -48, 1, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = name,
					TextColor3 = state and thm.txtpri or thm.txtsec,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = row
				})

				local togglebg = create("Frame", {
					Size = UDim2.new(0, 40, 0, 20),
					Position = UDim2.new(1, -40, 0.5, -10),
					BackgroundColor3 = state and thm.accglw or thm.tgloff,
					BorderSizePixel = 0,
					Parent = row
				})
				create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = togglebg })
				local togglestroke = create("UIStroke", {
					Color = state and thm.accstk or thm.tgloffstk,
					Thickness = 1.2,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Parent = togglebg
				})

				local knob = create("Frame", {
					Size = UDim2.new(0, 14, 0, 14),
					Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
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

				btn.MouseEnter:Connect(function()
					ts:Create(row, TweenInfo.new(0.15), { BackgroundTransparency = 0.4 }):Play()
					if desc then showtooltip(desc) end
				end)

				btn.MouseLeave:Connect(function()
					ts:Create(row, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
					hidetooltip()
				end)

				btn.MouseButton1Click:Connect(function()
					state = not state
					local targetcolor = state and thm.accglw or thm.tgloff
					local strokecolor = state and thm.accstk or thm.tgloffstk
					local knobcolor = state and thm.knbon or thm.knboff
					local knobpos = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
					local textcolor = state and thm.txtpri or thm.txtsec

					ts:Create(togglebg, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = targetcolor }):Play()
					ts:Create(togglestroke, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Color = strokecolor }):Play()
					ts:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = knobpos, BackgroundColor3 = knobcolor }):Play()
					ts:Create(label, TweenInfo.new(0.18), { TextColor3 = textcolor }):Play()

					if callback then
						callback(state)
					end
				end)

				return row
			end

			function section:createbutton(name, callback, desc)
				local row = create("Frame", {
					Size = UDim2.new(1, 0, 0, 34),
					BackgroundTransparency = 1,
					Parent = self.list
				})

				local btnframe = create("TextButton", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = thm.btnbg,
					BorderSizePixel = 0,
					Font = Enum.Font.GothamBold,
					Text = name,
					TextColor3 = thm.txtsec,
					TextSize = 12,
					Parent = row
				})
				create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = btnframe })
				local btnstroke = create("UIStroke", {
					Color = thm.crdstk,
					Thickness = 1.2,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Parent = btnframe
				})

				btnframe.MouseEnter:Connect(function()
					ts:Create(btnframe, TweenInfo.new(0.15), { BackgroundColor3 = thm.rowhvr, TextColor3 = thm.txtpri }):Play()
					ts:Create(btnstroke, TweenInfo.new(0.15), { Color = thm.acc }):Play()
					if desc then showtooltip(desc) end
				end)

				btnframe.MouseLeave:Connect(function()
					ts:Create(btnframe, TweenInfo.new(0.15), { BackgroundColor3 = thm.btnbg, TextColor3 = thm.txtsec }):Play()
					ts:Create(btnstroke, TweenInfo.new(0.15), { Color = thm.crdstk }):Play()
					hidetooltip()
				end)

				btnframe.MouseButton1Click:Connect(function()
					if callback then
						callback()
					end
				end)

				return btnframe
			end

			function section:createslider(name, minval, maxval, defaultval, callback, desc)
				minval = minval or 0
				maxval = maxval or 100
				local curval = math.clamp(defaultval or minval, minval, maxval)

				local box = create("Frame", {
					Size = UDim2.new(1, 0, 0, 50),
					BackgroundColor3 = thm.rowhvr,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Parent = self.list
				})
				create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = box })
				create("UIPadding", {
					PaddingTop = UDim.new(0, 6),
					PaddingBottom = UDim.new(0, 6),
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					Parent = box
				})

				create("TextLabel", {
					Size = UDim2.new(1, -50, 0, 16),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = name,
					TextColor3 = thm.txtsec,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = box
				})

				local vallabel = create("TextLabel", {
					Position = UDim2.new(1, -50, 0, 0),
					Size = UDim2.new(0, 50, 0, 16),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamBold,
					Text = tostring(curval),
					TextColor3 = thm.acc,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Right,
					Parent = box
				})

				local bar = create("Frame", {
					Position = UDim2.new(0, 0, 0, 26),
					Size = UDim2.new(1, 0, 0, 10),
					BackgroundColor3 = thm.tgloff,
					BorderSizePixel = 0,
					Parent = box
				})
				create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = bar })
				create("UIStroke", {
					Color = thm.tgloffstk,
					Thickness = 1.2,
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
					Position = UDim2.new(0, 0, 0, 22),
					Size = UDim2.new(1, 0, 0, 18),
					BackgroundTransparency = 1,
					Text = "",
					Parent = box
				})

				local sliding = false

				local function updateslider(input)
					local abspos = bar.AbsolutePosition.X
					local abssize = bar.AbsoluteSize.X
					local mousepos = input.Position.X
					local pct = math.clamp((mousepos - abspos) / abssize, 0, 1)

					curval = math.floor(minval + ((maxval - minval) * pct))
					vallabel.Text = tostring(curval)
					fill.Size = UDim2.new(pct, 0, 1, 0)

					if callback then
						callback(curval)
					end
				end

				hittrigger.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						sliding = true
						updateslider(input)
					end
				end)

				uis.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						sliding = false
					end
				end)

				uis.InputChanged:Connect(function(input)
					if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						updateslider(input)
					end
				end)

				box.MouseEnter:Connect(function()
					ts:Create(box, TweenInfo.new(0.15), { BackgroundTransparency = 0.4 }):Play()
					if desc then showtooltip(desc) end
				end)

				box.MouseLeave:Connect(function()
					ts:Create(box, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
					hidetooltip()
				end)

				return box
			end

			function section:createtextbox(name, placeholder, defaultval, callback, desc)
				if type(defaultval) == "function" then
					desc = callback
					callback = defaultval
					defaultval = ""
				end

				local row = create("Frame", {
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundColor3 = thm.rowhvr,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Parent = self.list
				})
				create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = row })
				create("UIPadding", {
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					Parent = row
				})

				local label = create("TextLabel", {
					Size = UDim2.new(1, -110, 1, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = name,
					TextColor3 = thm.txtsec,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = row
				})

				local inputbg = create("Frame", {
					Size = UDim2.new(0, 100, 0, 24),
					Position = UDim2.new(1, -100, 0.5, -12),
					BackgroundColor3 = thm.tgloff,
					BorderSizePixel = 0,
					Parent = row
				})
				create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = inputbg })
				local inputstroke = create("UIStroke", {
					Color = thm.tgloffstk,
					Thickness = 1.2,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Parent = inputbg
				})

				local inputbox = create("TextBox", {
					Size = UDim2.new(1, -12, 1, 0),
					Position = UDim2.new(0, 6, 0, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					Text = defaultval and tostring(defaultval) or "",
					PlaceholderText = placeholder or "value...",
					PlaceholderColor3 = thm.txtmut,
					TextColor3 = thm.txtpri,
					TextSize = 11,
					TextXAlignment = Enum.TextXAlignment.Left,
					ClearTextOnFocus = false,
					ClipsDescendants = true,
					Parent = inputbg
				})

				inputbox.Focused:Connect(function()
					ts:Create(inputstroke, TweenInfo.new(0.15), { Color = thm.accstk }):Play()
					ts:Create(label, TweenInfo.new(0.15), { TextColor3 = thm.txtpri }):Play()
				end)

				inputbox.FocusLost:Connect(function()
					ts:Create(inputstroke, TweenInfo.new(0.15), { Color = thm.tgloffstk }):Play()
					ts:Create(label, TweenInfo.new(0.15), { TextColor3 = thm.txtsec }):Play()
					if callback then
						local result = callback(inputbox.Text)
						if type(result) == "string" then
							inputbox.Text = result
						end
					end
				end)

				row.MouseEnter:Connect(function()
					ts:Create(row, TweenInfo.new(0.15), { BackgroundTransparency = 0.4 }):Play()
					if desc then showtooltip(desc) end
				end)

				row.MouseLeave:Connect(function()
					ts:Create(row, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
					hidetooltip()
				end)

				return row
			end

			return section
		end

		return tab
	end

	return window
end

return crescent
