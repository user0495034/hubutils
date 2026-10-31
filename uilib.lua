-- ============================================================================
-- N.A.S - HUB (Fixed UI Library)
-- ============================================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- ---------------------------------------------------------------------------
-- Theme
-- ---------------------------------------------------------------------------
local Theme = {
	Window    = Color3.fromRGB(24, 24, 24),
	TopBar    = Color3.fromRGB(30, 30, 30),
	Element   = Color3.fromRGB(37, 37, 38),
	Border    = Color3.fromRGB(51, 51, 55),
	Accent    = Color3.fromRGB(0, 120, 212),
	TabActive = Color3.fromRGB(50, 54, 57),
	Text      = Color3.fromRGB(240, 240, 240),
	TextDim   = Color3.fromRGB(180, 180, 180),
	Off       = Color3.fromRGB(60, 60, 60),
	Font      = Enum.Font.SegoeUI,
}

-- ---------------------------------------------------------------------------
-- Predefined LocalPlayer variables (safe outside executors too)
-- ---------------------------------------------------------------------------
local env = (getgenv and getgenv()) or _G

local function updateCharacter(char)
	env.LocalCharacter = char
	env.LocalHumanoid = char:WaitForChild("Humanoid", 5)
	env.LocalRootPart = char:WaitForChild("HumanoidRootPart", 5)
end

if player.Character then
	task.spawn(updateCharacter, player.Character) -- WaitForChild can yield, don't block the UI
end
player.CharacterAdded:Connect(updateCharacter)

-- ---------------------------------------------------------------------------
-- GUI parent (gethui -> CoreGui -> PlayerGui fallback)
-- ---------------------------------------------------------------------------
local GUI_NAME = "ProLibraryGUI"

local function getGuiParent()
	if gethui then
		local ok, ui = pcall(gethui)
		if ok and ui then return ui end
	end
	local ok, core = pcall(function() return game:GetService("CoreGui") end)
	if ok and core then
		-- make sure we are actually allowed to parent there
		local testOk = pcall(function()
			local f = Instance.new("Folder")
			f.Parent = core
			f:Destroy()
		end)
		if testOk then return core end
	end
	return player:WaitForChild("PlayerGui")
end

local guiParent = getGuiParent()

local oldGui = guiParent:FindFirstChild(GUI_NAME)
if oldGui then oldGui:Destroy() end

-- every global connection goes here so closing the UI cleans everything up
local connections = {}
local function track(conn)
	table.insert(connections, conn)
	return conn
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = guiParent

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------
local function tween(obj, t, props)
	TweenService:Create(obj, TweenInfo.new(t), props):Play()
end

local function corner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

-- NOTE: UIStroke inside a TextButton/TextLabel defaults to outlining the TEXT.
-- ApplyStrokeMode must be Border to outline the frame instead.
local function stroke(parent, color)
	local s = Instance.new("UIStroke")
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Color = color or Theme.Border
	s.Thickness = 1
	s.Parent = parent
	return s
end

local function isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
end

local function isMove(input)
	return input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
end

-- ---------------------------------------------------------------------------
-- Main window
-- ---------------------------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 540, 0, 380)
mainFrame.Position = UDim2.new(0.5, -270, 0.5, -190)
mainFrame.BackgroundColor3 = Theme.Window
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
corner(mainFrame, 6)
stroke(mainFrame, Color3.fromRGB(45, 45, 48))

-- Titlebar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 32)
topBar.BackgroundColor3 = Theme.TopBar
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame
corner(topBar, 6)

local topFix = Instance.new("Frame") -- squares off the bottom corners of the titlebar
topFix.Size = UDim2.new(1, 0, 0, 6)
topFix.Position = UDim2.new(0, 0, 1, -6)
topFix.BackgroundColor3 = Theme.TopBar
topFix.BorderSizePixel = 0
topFix.Parent = topBar

local iconImage = Instance.new("ImageLabel")
iconImage.Size = UDim2.new(0, 16, 0, 16)
iconImage.Position = UDim2.new(0, 10, 0.5, -8)
iconImage.BackgroundTransparency = 1
iconImage.Image = "rbxassetid://98291748528451"
iconImage.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -90, 1, 0)
titleLabel.Position = UDim2.new(0, 34, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Theme.Text
titleLabel.TextSize = 12
titleLabel.Font = Theme.Font
titleLabel.Text = "N.A.S - HUB"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Dragging: only from the titlebar (the old Draggable = true moved the whole
-- window while you were dragging a slider, and is deprecated anyway)
do
	local dragging, dragStart, startPos = false, nil, nil

	topBar.InputBegan:Connect(function(input)
		if isPress(input) then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
		end
	end)

	track(UserInputService.InputChanged:Connect(function(input)
		if dragging and isMove(input) then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end))

	track(UserInputService.InputEnded:Connect(function(input)
		if isPress(input) then dragging = false end
	end))
end

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 45, 0, 32)
closeButton.Position = UDim2.new(1, -45, 0, 0)
closeButton.BackgroundColor3 = Theme.TopBar
closeButton.BackgroundTransparency = 1
closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
closeButton.TextSize = 12
closeButton.Font = Theme.Font
closeButton.Text = "✕"
closeButton.AutoButtonColor = false
closeButton.Parent = topBar

local Library = {
	Gui = screenGui,
	Theme = Theme,
}

function Library:Destroy()
	for _, c in ipairs(connections) do
		pcall(function() c:Disconnect() end)
	end
	table.clear(connections)
	screenGui:Destroy()
end

closeButton.MouseButton1Click:Connect(function()
	Library:Destroy()
end)

closeButton.MouseEnter:Connect(function()
	tween(closeButton, 0.1, {BackgroundColor3 = Color3.fromRGB(232, 17, 35), BackgroundTransparency = 0})
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

closeButton.MouseLeave:Connect(function()
	tween(closeButton, 0.1, {BackgroundColor3 = Theme.TopBar, BackgroundTransparency = 1})
	closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

-- Sidebar (tab buttons)
local sidebar = Instance.new("ScrollingFrame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 130, 1, -42)
sidebar.Position = UDim2.new(0, 6, 0, 36)
sidebar.BackgroundTransparency = 1
sidebar.BorderSizePixel = 0
sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
sidebar.ScrollBarThickness = 0
sidebar.Parent = mainFrame

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Padding = UDim.new(0, 3)
sidebarLayout.Parent = sidebar

-- Pages container
local pagesContainer = Instance.new("Frame")
pagesContainer.Name = "Pages"
pagesContainer.Size = UDim2.new(1, -148, 1, -42)
pagesContainer.Position = UDim2.new(0, 142, 0, 36)
pagesContainer.BackgroundTransparency = 1
pagesContainer.Parent = mainFrame

-- ---------------------------------------------------------------------------
-- Tabs
-- ---------------------------------------------------------------------------
local tabs = {} -- { button = TextButton, content = ScrollingFrame }

local function selectTab(selected)
	for _, tab in ipairs(tabs) do
		local active = (tab == selected)
		tab.content.Visible = active
		tween(tab.button, 0.12, {
			BackgroundColor3 = active and Theme.TabActive or Theme.TopBar,
			BackgroundTransparency = active and 0.4 or 1,
			TextColor3 = active and Color3.fromRGB(255, 255, 255) or Theme.TextDim,
		})
	end
end

function Library:AddTab(name)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1, 0, 0, 32)
	tabBtn.BackgroundColor3 = Theme.TopBar
	tabBtn.BackgroundTransparency = 1
	tabBtn.TextColor3 = Theme.TextDim
	tabBtn.TextSize = 12
	tabBtn.Font = Theme.Font
	tabBtn.Text = "   " .. name
	tabBtn.TextXAlignment = Enum.TextXAlignment.Left
	tabBtn.AutoButtonColor = false
	tabBtn.LayoutOrder = #tabs + 1
	tabBtn.Parent = sidebar
	corner(tabBtn, 4)

	local tabContent = Instance.new("ScrollingFrame")
	tabContent.Name = name
	tabContent.Size = UDim2.new(1, 0, 1, 0)
	tabContent.BackgroundTransparency = 1
	tabContent.BorderSizePixel = 0
	tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tabContent.ScrollBarThickness = 3
	tabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
	tabContent.Visible = false
	tabContent.Parent = pagesContainer

	local contentPadding = Instance.new("UIPadding")
	contentPadding.PaddingRight = UDim.new(0, 8) -- room for the scrollbar
	contentPadding.PaddingTop = UDim.new(0, 1)
	contentPadding.PaddingBottom = UDim.new(0, 4)
	contentPadding.Parent = tabContent

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Padding = UDim.new(0, 6)
	contentLayout.Parent = tabContent

	local tab = {button = tabBtn, content = tabContent}
	table.insert(tabs, tab)

	tabBtn.MouseButton1Click:Connect(function()
		selectTab(tab)
	end)

	-- first tab selected by default
	if #tabs == 1 then
		selectTab(tab)
	end

	-- -----------------------------------------------------------------------
	-- Elements
	-- -----------------------------------------------------------------------
	local TabElements = {}

	local function newElement(className, height)
		local e = Instance.new(className)
		e.Size = UDim2.new(1, 0, 0, height)
		e.BackgroundColor3 = Theme.Element
		e.BackgroundTransparency = 0.2
		e.BorderSizePixel = 0
		e.Parent = tabContent
		if className == "TextButton" then
			e.AutoButtonColor = false
			e.Text = ""
		end
		corner(e, 4)
		return e, stroke(e)
	end

	local function makeLabel(parent, text, size, pos)
		local l = Instance.new("TextLabel")
		l.Size = size
		l.Position = pos
		l.BackgroundTransparency = 1
		l.TextColor3 = Theme.Text
		l.TextSize = 12
		l.Font = Theme.Font
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.Text = text
		l.Parent = parent
		return l
	end

	-- Button ---------------------------------------------------------------
	function TabElements:AddButton(text, callback)
		callback = callback or function() end

		local btn, btnStroke = newElement("TextButton", 32)
		btn.Text = text
		btn.TextColor3 = Theme.Text
		btn.TextSize = 12
		btn.Font = Theme.Font

		btn.MouseButton1Click:Connect(function()
			task.spawn(callback)
			tween(btn, 0.1, {BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0})
			task.delay(0.12, function()
				if btn.Parent then
					tween(btn, 0.15, {BackgroundColor3 = Theme.Element, BackgroundTransparency = 0.2})
				end
			end)
		end)

		btn.MouseEnter:Connect(function()
			tween(btnStroke, 0.15, {Color = Theme.Accent})
		end)
		btn.MouseLeave:Connect(function()
			tween(btnStroke, 0.15, {Color = Theme.Border})
		end)

		return {
			SetText = function(_, t) btn.Text = t end,
		}
	end

	-- Toggle ---------------------------------------------------------------
	function TabElements:AddToggle(text, default, callback)
		callback = callback or function() end
		local state = default and true or false

		local frame, frameStroke = newElement("TextButton", 32)
		makeLabel(frame, text, UDim2.new(1, -56, 1, 0), UDim2.new(0, 10, 0, 0))

		local switchBg = Instance.new("Frame")
		switchBg.Size = UDim2.new(0, 32, 0, 16)
		switchBg.Position = UDim2.new(1, -40, 0.5, -8)
		switchBg.BackgroundColor3 = state and Theme.Accent or Theme.Off
		switchBg.BorderSizePixel = 0
		switchBg.Parent = frame
		corner(switchBg, 8)

		local switchCircle = Instance.new("Frame")
		switchCircle.Size = UDim2.new(0, 10, 0, 10)
		switchCircle.Position = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)
		switchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		switchCircle.BorderSizePixel = 0
		switchCircle.Parent = switchBg
		corner(switchCircle, 5)

		local function setState(newState, silent)
			state = newState
			tween(switchBg, 0.12, {BackgroundColor3 = state and Theme.Accent or Theme.Off})
			tween(switchCircle, 0.12, {
				Position = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5),
			})
			if not silent then
				task.spawn(callback, state)
			end
		end

		frame.MouseButton1Click:Connect(function()
			setState(not state)
		end)

		frame.MouseEnter:Connect(function()
			tween(frameStroke, 0.15, {Color = Theme.Accent})
		end)
		frame.MouseLeave:Connect(function()
			tween(frameStroke, 0.15, {Color = Theme.Border})
		end)

		return {
			Set = function(_, v, silent) setState(v and true or false, silent) end,
			Get = function() return state end,
		}
	end

	-- Slider ---------------------------------------------------------------
	function TabElements:AddSlider(text, min, max, default, callback, step)
		min = min or 0
		max = max or 100
		if max <= min then max = min + 1 end -- avoid divide-by-zero
		step = step or 1
		callback = callback or function() end
		local value = math.clamp(default or min, min, max)

		local frame = newElement("Frame", 50)
		makeLabel(frame, text, UDim2.new(1, -60, 0, 20), UDim2.new(0, 10, 0, 6))

		local valueLabel = makeLabel(frame, tostring(value), UDim2.new(0, 44, 0, 20), UDim2.new(1, -52, 0, 6))
		valueLabel.TextColor3 = Theme.Accent
		valueLabel.TextXAlignment = Enum.TextXAlignment.Right

		-- bigger invisible hitbox so the 4px bar is easy to grab
		local hitbox = Instance.new("TextButton")
		hitbox.Size = UDim2.new(1, -20, 0, 18)
		hitbox.Position = UDim2.new(0, 10, 0, 26)
		hitbox.BackgroundTransparency = 1
		hitbox.AutoButtonColor = false
		hitbox.Text = ""
		hitbox.Parent = frame

		local track_ = Instance.new("Frame")
		track_.Size = UDim2.new(1, 0, 0, 4)
		track_.Position = UDim2.new(0, 0, 0.5, -2)
		track_.BackgroundColor3 = Theme.Off
		track_.BorderSizePixel = 0
		track_.Parent = hitbox
		corner(track_, 2)

		local fill = Instance.new("Frame")
		fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
		fill.BackgroundColor3 = Theme.Accent
		fill.BorderSizePixel = 0
		fill.Parent = track_
		corner(fill, 2)

		local function setValue(v, silent)
			v = math.clamp(math.floor(v / step + 0.5) * step, min, max)
			if v == value and not silent then return end
			value = v
			fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
			valueLabel.Text = tostring(value)
			if not silent then
				task.spawn(callback, value)
			end
		end

		local function fromInput(input)
			local pos = math.clamp((input.Position.X - hitbox.AbsolutePosition.X) / hitbox.AbsoluteSize.X, 0, 1)
			setValue(min + (max - min) * pos)
		end

		local dragging = false

		hitbox.InputBegan:Connect(function(input)
			if isPress(input) then
				dragging = true
				fromInput(input)
			end
		end)

		track(UserInputService.InputEnded:Connect(function(input)
			if isPress(input) then dragging = false end
		end))

		track(UserInputService.InputChanged:Connect(function(input)
			if dragging and isMove(input) then
				fromInput(input)
			end
		end))

		return {
			Set = function(_, v, silent) setValue(v, silent) end,
			Get = function() return value end,
		}
	end

	-- Label (bonus) --------------------------------------------------------
	function TabElements:AddLabel(text)
		local frame = newElement("Frame", 28)
		local l = makeLabel(frame, text, UDim2.new(1, -20, 1, 0), UDim2.new(0, 10, 0, 0))
		l.TextColor3 = Theme.TextDim
		return {
			SetText = function(_, t) l.Text = t end,
		}
	end

	return TabElements
end

return Library
