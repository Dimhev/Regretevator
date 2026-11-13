local cg = game:GetService("CoreGui")
local plrs = game:GetService("Players")
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

local lp = plrs.LocalPlayer

local crescent = {}
crescent.__index = crescent

local thm = {
	bg = Color3.fromRGB(9, 13, 19),
	sb = Color3.fromRGB(7, 10, 15),
	tb = Color3.fromRGB(8, 11, 17),
	ftr = Color3.fromRGB(7, 10, 15),
	crd = Color3.fromRGB(13, 19, 28),
	crdstk = Color3.fromRGB(25, 38, 56),
	crddiv = Color3.fromRGB(19, 29, 44),
	acc = Color3.fromRGB(90, 210, 255),
	accglw = Color3.fromRGB(55, 165, 225),
	accstk = Color3.fromRGB(115, 220, 255),
	tgloff = Color3.fromRGB(16, 24, 36),
	tgloffstk = Color3.fromRGB(28, 42, 62),
	knboff = Color3.fromRGB(120, 145, 170),
	knbon = Color3.fromRGB(255, 255, 255),
	rowhvr = Color3.fromRGB(20, 31, 46),
	txtpri = Color3.fromRGB(240, 248, 255),
	txtsec = Color3.fromRGB(190, 210, 228),
	txtmut = Color3.fromRGB(110, 132, 156),
	tabact = Color3.fromRGB(16, 25, 38)
}

local function mk(cls, props)
	local inst = Instance.new(cls)
	for p, v in pairs(props or {}) do
		inst[p] = v
	end
	return inst
end

function crescent:Notify(dt)
	local nttl = dt.Title or "notification"
	local ncnt = dt.Content or ""
	local dur = dt.Duration or 4

	local gui = cg:FindFirstChild("crescentntfgui")
	if not gui then
		gui = mk("ScreenGui", {
			Name = "crescentntfgui",
			Parent = cg,
			ResetOnSpawn = false
		})
	end

	local cnt = gui:FindFirstChild("cnt")
	if not cnt then
		cnt = mk("Frame", {
			Name = "cnt",
			BackgroundTransparency = 1,
			Position = UDim2.new(1, -280, 1, -25),
			AnchorPoint = Vector2.new(0, 1),
			Size = UDim2.new(0, 260, 1, -40),
			Parent = gui
		})
		mk("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, 8),
			Parent = cnt
		})
	end

	local crd = mk("Frame", {
		Size = UDim2.new(1, 0, 0, 62),
		BackgroundColor3 = thm.crd,
		BackgroundTransparency = 1,
		Parent = cnt
	})
	mk("UICorner", { CornerRadius = UDim.new(0, 6), Parent = crd })
	mk("UIStroke", {
		Color = thm.crdstk,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = crd
	})

	local ttllbl = mk("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 8),
		Size = UDim2.new(1, -24, 0, 18),
		Font = Enum.Font.RobotoMono,
		Text = nttl,
		TextColor3 = thm.acc,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTransparency = 1,
		Parent = crd
	})

	local dsclbl = mk("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 28),
		Size = UDim2.new(1, -24, 0, 26),
		Font = Enum.Font.RobotoMono,
		Text = ncnt,
		TextColor3 = thm.txtmut,
		TextSize = 11,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextTransparency = 1,
		Parent = crd
	})

	ts:Create(crd, TweenInfo.new(0.25), { BackgroundTransparency = 0 }):Play()
	ts:Create(ttllbl, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
	ts:Create(dsclbl, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()

	task.delay(dur, function()
		if crd and crd.Parent then
			local fd = ts:Create(crd, TweenInfo.new(0.25), { BackgroundTransparency = 1 })
			ts:Create(ttllbl, TweenInfo.new(0.25), { TextTransparency = 1 }):Play()
			ts:Create(dsclbl, TweenInfo.new(0.25), { TextTransparency = 1 }):Play()
			fd:Play()
			fd.Completed:Connect(function()
				crd:Destroy()
			end)
		end
	end)
end

function crescent:CreateWindow(cfg)
	cfg = cfg or {}

	local gui = mk("ScreenGui", {
		Name = "crescentgui",
		Parent = cg,
		ResetOnSpawn = false
	})

	local ttfrm = mk("Frame", {
		Name = "crescenttt",
		Size = UDim2.new(0, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(9, 14, 22),
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 200,
		Parent = gui
	})
	mk("UICorner", { CornerRadius = UDim.new(0, 5), Parent = ttfrm })
	mk("UIStroke", {
		Color = thm.crdstk,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = ttfrm
	})
	mk("UIPadding", {
		PaddingTop = UDim.new(0, 5),
		PaddingBottom = UDim.new(0, 5),
		PaddingLeft = UDim.new(0, 9),
		PaddingRight = UDim.new(0, 9),
		Parent = ttfrm
	})

	local ttlbl = mk("TextLabel", {
		BackgroundTransparency = 1,
		Font = Enum.Font.RobotoMono,
		TextColor3 = thm.txtsec,
		TextSize = 11,
		AutomaticSize = Enum.AutomaticSize.XY,
		ZIndex = 201,
		Parent = ttfrm
	})

	local function shwtt(txt)
		if txt and txt ~= "" then
			ttlbl.Text = txt
			ttfrm.Visible = true
		end
	end

	local function hdtt()
		ttfrm.Visible = false
	end

	uis.InputChanged:Connect(function(inp)
		if ttfrm.Visible and inp.UserInputType == Enum.UserInputType.MouseMovement then
			ttfrm.Position = UDim2.new(0, inp.Position.X + 14, 0, inp.Position.Y + 14)
		end
	end)

	local mn = mk("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 750, 0, 500),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = thm.bg,
		BorderSizePixel = 0,
		Parent = gui
	})
	mk("UICorner", { CornerRadius = UDim.new(0, 7), Parent = mn })
	mk("UIStroke", {
		Color = thm.crdstk,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = mn
	})

	local mnscl = mk("UIScale", {
		Scale = 1,
		Parent = mn
	})

	local tb = mk("Frame", {
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundColor3 = thm.tb,
		BorderSizePixel = 0,
		Parent = mn
	})
	mk("UICorner", { CornerRadius = UDim.new(0, 7), Parent = tb })

	local tbfx = mk("Frame", {
		Size = UDim2.new(1, 0, 0, 10),
		Position = UDim2.new(0, 0, 1, -10),
		BackgroundColor3 = thm.tb,
		BorderSizePixel = 0,
		Parent = tb
	})

	local tbdiv = mk("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = thm.crdstk,
		BorderSizePixel = 0,
		Parent = tb
	})

	local ico = mk("ImageLabel", {
		Position = UDim2.new(0, 14, 0.5, -11),
		Size = UDim2.new(0, 22, 0, 22),
		BackgroundTransparency = 1,
		Image = "rbxassetid://132049320741473",
		Rotation = 90,
		Parent = tb
	})
	mk("UICorner", { CornerRadius = UDim.new(0, 4), Parent = ico })

	local ttllbl = mk("TextLabel", {
		Position = UDim2.new(0, 44, 0, 0),
		Size = UDim2.new(0, 220, 1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.RobotoMono,
		Text = "by dimhev",
		TextSize = 15,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = tb
	})

	local ttlgrad = mk("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.0, Color3.fromRGB(55, 165, 225)),
			ColorSequenceKeypoint.new(0.25, Color3.fromRGB(110, 215, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 248, 255)),
			ColorSequenceKeypoint.new(0.75, Color3.fromRGB(90, 200, 250)),
			ColorSequenceKeypoint.new(1.0, Color3.fromRGB(55, 165, 225))
		}),
		Parent = ttllbl
	})

	local shmcon = rs.RenderStepped:Connect(function()
		local ofs = (tick() * 0.75) % 2 - 1
		ttlgrad.Offset = Vector2.new(ofs, 0)
	end)

	local drg = false
	local drgst = nil
	local stpos = nil

	tb.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			drg = true
			drgst = inp.Position
			stpos = mn.Position
			inp.Changed:Connect(function()
				if inp.UserInputState == Enum.UserInputState.End then
					drg = false
				end
			end)
		end
	end)

	uis.InputChanged:Connect(function(inp)
		if drg and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
			local dlt = inp.Position - drgst
			mn.Position = UDim2.new(
				stpos.X.Scale,
				stpos.X.Offset + dlt.X,
				stpos.Y.Scale,
				stpos.Y.Offset + dlt.Y
			)
		end
	end)

	local sb = mk("Frame", {
		Position = UDim2.new(0, 0, 0, 45),
		Size = UDim2.new(0, 150, 1, -71),
		BackgroundColor3 = thm.sb,
		BorderSizePixel = 0,
		Parent = mn
	})

	local sbdiv = mk("Frame", {
		Position = UDim2.new(1, -1, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
		BackgroundColor3 = thm.crdstk,
		BorderSizePixel = 0,
		Parent = sb
	})

	local tbcnt = mk("ScrollingFrame", {
		Position = UDim2.new(0, 0, 0, 8),
		Size = UDim2.new(1, -1, 1, -16),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = sb
	})

	local tblyt = mk("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 3),
		Parent = tbcnt
	})

	local cnthld = mk("Frame", {
		Position = UDim2.new(0, 150, 0, 45),
		Size = UDim2.new(1, -150, 1, -71),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = mn
	})

	local ftr = mk("Frame", {
		Position = UDim2.new(0, 0, 1, -26),
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundColor3 = thm.ftr,
		BorderSizePixel = 0,
		Parent = mn
	})
	mk("UICorner", { CornerRadius = UDim.new(0, 7), Parent = ftr })

	local ftrfx = mk("Frame", {
		Size = UDim2.new(1, 0, 0, 10),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = thm.ftr,
		BorderSizePixel = 0,
		Parent = ftr
	})

	local ftrdiv = mk("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = thm.crdstk,
		BorderSizePixel = 0,
		Parent = ftr
	})

	local ftrlbl = mk("TextLabel", {
		Position = UDim2.new(0, 16, 0, 0),
		Size = UDim2.new(1, -32, 1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.RobotoMono,
		Text = "crescent | by dimhev",
		TextColor3 = thm.txtmut,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = ftr
	})

	local isopn = true
	local isanim = false

	local function tglui()
		if isanim then return end
		isanim = true

		if isopn then
			hdtt()
			drg = false
			local tw = ts:Create(mnscl, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.82 })
			tw:Play()
			tw.Completed:Connect(function()
				mn.Visible = false
				isopn = false
				isanim = false
			end)
		else
			mn.Visible = true
			mnscl.Scale = 0.82
			local tw = ts:Create(mnscl, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
			tw:Play()
			tw.Completed:Connect(function()
				isopn = true
				isanim = false
			end)
		end
	end

	local kcon = uis.InputBegan:Connect(function(inp, gpe)
		if not gpe and inp.KeyCode == Enum.KeyCode.RightShift then
			tglui()
		end
	end)

	local win = {
		gui = gui,
		main = mn,
		tabs = {},
		acttb = nil,
		shmcon = shmcon,
		kcon = kcon
	}

	function win:Toggle()
		tglui()
	end

	function win:Destroy()
		if self.shmcon then
			self.shmcon:Disconnect()
			self.shmcon = nil
		end
		if self.kcon then
			self.kcon:Disconnect()
			self.kcon = nil
		end
		if self.gui then
			self.gui:Destroy()
		end
	end

	function win:CreateTab(tbnm)
		local tbbtn = mk("TextButton", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundTransparency = 1,
			BackgroundColor3 = thm.tabact,
			BorderSizePixel = 0,
			Font = Enum.Font.RobotoMono,
			Text = tbnm,
			TextColor3 = thm.txtmut,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = tbcnt
		})
		mk("UIPadding", {
			PaddingLeft = UDim.new(0, 16),
			Parent = tbbtn
		})

		local pg = mk("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = thm.crdstk,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false,
			Parent = cnthld
		})
		mk("UIPadding", {
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 14),
			PaddingLeft = UDim.new(0, 14),
			PaddingRight = UDim.new(0, 14),
			Parent = pg
		})

		local coll = mk("Frame", {
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(0.5, -7, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = pg
		})
		mk("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12),
			Parent = coll
		})

		local colr = mk("Frame", {
			Position = UDim2.new(0.5, 7, 0, 0),
			Size = UDim2.new(0.5, -7, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Parent = pg
		})
		mk("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12),
			Parent = colr
		})

		local tbobj = {
			name = tbnm,
			btn = tbbtn,
			page = pg,
			coll = coll,
			colr = colr,
			seccnt = 0
		}

		local function sel()
			for i, t in ipairs(win.tabs) do
				t.page.Visible = false
				t.btn.BackgroundTransparency = 1
				t.btn.TextColor3 = thm.txtmut
			end
			tbobj.page.Visible = true
			tbobj.btn.BackgroundTransparency = 0
			tbobj.btn.TextColor3 = thm.txtpri
			win.acttb = tbobj
		end

		tbbtn.MouseButton1Click:Connect(sel)

		table.insert(win.tabs, tbobj)
		if #win.tabs == 1 then
			sel()
		end

		function tbobj:CreateSection(secnm)
			self.seccnt = self.seccnt + 1
			local pcol = (self.seccnt % 2 == 1) and self.coll or self.colr

			local crd = mk("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = thm.crd,
				BorderSizePixel = 0,
				Parent = pcol
			})
			mk("UICorner", { CornerRadius = UDim.new(0, 6), Parent = crd })
			mk("UIStroke", {
				Color = thm.crdstk,
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Parent = crd
			})
			mk("UIPadding", {
				PaddingTop = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12),
				Parent = crd
			})

			local hdr = mk("TextLabel", {
				Size = UDim2.new(1, 0, 0, 20),
				BackgroundTransparency = 1,
				Font = Enum.Font.RobotoMono,
				Text = secnm,
				TextColor3 = thm.txtpri,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = crd
			})

			local div = mk("Frame", {
				Position = UDim2.new(0, 0, 0, 24),
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = thm.crddiv,
				BorderSizePixel = 0,
				Parent = crd
			})

			local lst = mk("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 31),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Parent = crd
			})
			mk("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4),
				Parent = lst
			})

			local sec = {
				card = crd,
				list = lst
			}

			function sec:CreateToggle(nm, def, cb, dsc)
				local st = def or false

				local rw = mk("Frame", {
					Size = UDim2.new(1, 0, 0, 28),
					BackgroundColor3 = thm.rowhvr,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Parent = self.list
				})
				mk("UICorner", { CornerRadius = UDim.new(0, 4), Parent = rw })
				mk("UIPadding", {
					PaddingLeft = UDim.new(0, 6),
					PaddingRight = UDim.new(0, 6),
					Parent = rw
				})

				local lbl = mk("TextLabel", {
					Size = UDim2.new(1, -48, 1, 0),
					BackgroundTransparency = 1,
					Font = Enum.Font.RobotoMono,
					Text = nm,
					TextColor3 = st and thm.txtpri or thm.txtsec,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = rw
				})

				local tglbg = mk("Frame", {
					Size = UDim2.new(0, 38, 0, 20),
					Position = UDim2.new(1, -38, 0.5, -10),
					BackgroundColor3 = st and thm.accglw or thm.tgloff,
					BorderSizePixel = 0,
					Parent = rw
				})
				mk("UICorner", { CornerRadius = UDim.new(1, 0), Parent = tglbg })
				local tglstk = mk("UIStroke", {
					Color = st and thm.accstk or thm.tgloffstk,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Parent = tglbg
				})

				local knb = mk("Frame", {
					Size = UDim2.new(0, 14, 0, 14),
					Position = st and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
					BackgroundColor3 = st and thm.knbon or thm.knboff,
					BorderSizePixel = 0,
					Parent = tglbg
				})
				mk("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knb })

				local btn = mk("TextButton", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = "",
					Parent = rw
				})

				btn.MouseEnter:Connect(function()
					ts:Create(rw, TweenInfo.new(0.15), { BackgroundTransparency = 0.9 }):Play()
					if dsc then shwtt(dsc) end
				end)

				btn.MouseLeave:Connect(function()
					ts:Create(rw, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
					hdtt()
				end)

				btn.MouseButton1Click:Connect(function()
					st = not st
					local tcol = st and thm.accglw or thm.tgloff
					local scol = st and thm.accstk or thm.tgloffstk
					local kcol = st and thm.knbon or thm.knboff
					local kpos = st and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
					local txtcol = st and thm.txtpri or thm.txtsec

					ts:Create(tglbg, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = tcol }):Play()
					ts:Create(tglstk, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Color = scol }):Play()
					ts:Create(knb, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = kpos, BackgroundColor3 = kcol }):Play()
					ts:Create(lbl, TweenInfo.new(0.2), { TextColor3 = txtcol }):Play()

					if cb then
						cb(st)
					end
				end)

				return rw
			end

			function sec:CreateButton(nm, cb, dsc)
				local rw = mk("Frame", {
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundTransparency = 1,
					Parent = self.list
				})

				local btnfrm = mk("TextButton", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = thm.sb,
					BorderSizePixel = 0,
					Font = Enum.Font.RobotoMono,
					Text = nm,
					TextColor3 = thm.txtsec,
					TextSize = 13,
					Parent = rw
				})
				mk("UICorner", { CornerRadius = UDim.new(0, 4), Parent = btnfrm })
				local btnstk = mk("UIStroke", {
					Color = thm.crdstk,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Parent = btnfrm
				})

				btnfrm.MouseEnter:Connect(function()
					ts:Create(btnfrm, TweenInfo.new(0.15), { BackgroundColor3 = thm.rowhvr, TextColor3 = thm.txtpri }):Play()
					ts:Create(btnstk, TweenInfo.new(0.15), { Color = thm.acc }):Play()
					if dsc then shwtt(dsc) end
				end)

				btnfrm.MouseLeave:Connect(function()
					ts:Create(btnfrm, TweenInfo.new(0.15), { BackgroundColor3 = thm.sb, TextColor3 = thm.txtsec }):Play()
					ts:Create(btnstk, TweenInfo.new(0.15), { Color = thm.crdstk }):Play()
					hdtt()
				end)

				btnfrm.MouseButton1Click:Connect(function()
					if cb then
						cb()
					end
				end)

				return btnfrm
			end

			function sec:CreateSlider(nm, mnval, mxval, def, cb, dsc)
				mnval = mnval or 0
				mxval = mxval or 100
				local cval = math.clamp(def or mnval, mnval, mxval)

				local bx = mk("Frame", {
					Size = UDim2.new(1, 0, 0, 44),
					BackgroundColor3 = thm.rowhvr,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Parent = self.list
				})
				mk("UICorner", { CornerRadius = UDim.new(0, 4), Parent = bx })
				mk("UIPadding", {
					PaddingTop = UDim.new(0, 4),
					PaddingLeft = UDim.new(0, 6),
					PaddingRight = UDim.new(0, 6),
					Parent = bx
				})

				local lbl = mk("TextLabel", {
					Size = UDim2.new(1, -60, 0, 16),
					BackgroundTransparency = 1,
					Font = Enum.Font.RobotoMono,
					Text = nm,
					TextColor3 = thm.txtsec,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = bx
				})

				local vlbl = mk("TextLabel", {
					Position = UDim2.new(1, -60, 0, 0),
					Size = UDim2.new(0, 60, 0, 16),
					BackgroundTransparency = 1,
					Font = Enum.Font.RobotoMono,
					Text = tostring(cval),
					TextColor3 = thm.acc,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Right,
					Parent = bx
				})

				local br = mk("Frame", {
					Position = UDim2.new(0, 0, 0, 26),
					Size = UDim2.new(1, 0, 0, 6),
					BackgroundColor3 = thm.tgloff,
					BorderSizePixel = 0,
					Parent = bx
				})
				mk("UICorner", { CornerRadius = UDim.new(1, 0), Parent = br })
				mk("UIStroke", {
					Color = thm.tgloffstk,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Parent = br
				})

				local ipct = (cval - mnval) / math.max(1, (mxval - mnval))
				local fl = mk("Frame", {
					Size = UDim2.new(ipct, 0, 1, 0),
					BackgroundColor3 = thm.accglw,
					BorderSizePixel = 0,
					Parent = br
				})
				mk("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fl })

				local htrg = mk("TextButton", {
					Position = UDim2.new(0, 0, 0, 20),
					Size = UDim2.new(1, 0, 0, 18),
					BackgroundTransparency = 1,
					Text = "",
					Parent = bx
				})

				local sld = false

				local function upd(inp)
					local apos = br.AbsolutePosition.X
					local asz = br.AbsoluteSize.X
					local mpos = inp.Position.X
					local pct = math.clamp((mpos - apos) / asz, 0, 1)

					cval = math.floor(mnval + ((mxval - mnval) * pct))
					vlbl.Text = tostring(cval)
					fl.Size = UDim2.new(pct, 0, 1, 0)

					if cb then
						cb(cval)
					end
				end

				htrg.InputBegan:Connect(function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
						sld = true
						upd(inp)
					end
				end)

				uis.InputEnded:Connect(function(inp)
					if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
						sld = false
					end
				end)

				uis.InputChanged:Connect(function(inp)
					if sld and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
						upd(inp)
					end
				end)

				bx.MouseEnter:Connect(function()
					ts:Create(bx, TweenInfo.new(0.15), { BackgroundTransparency = 0.9 }):Play()
					if dsc then shwtt(dsc) end
				end)

				bx.MouseLeave:Connect(function()
					ts:Create(bx, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
					hdtt()
				end)

				return bx
			end

			return sec
		end

		return tbobj
	end

	return win
end

return crescent
