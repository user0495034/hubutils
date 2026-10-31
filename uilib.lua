-- ============================================================================
-- N.A.S - HUB (Fixed UI Library)
-- ============================================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- Predefined LocalPlayer Variables
local function updateCharacter(char)
	getgenv().LocalCharacter = char
	getgenv().LocalHumanoid = char:WaitForChild("Humanoid", 5)
	getgenv().LocalRootPart = char:WaitForChild("HumanoidRootPart", 5)
end

if player.Character then
	updateCharacter(player.Character)
end
player.CharacterAdded:Connect(updateCharacter)

if CoreGui:FindFirstChild("ProLibraryGUI") then
	CoreGui.ProLibraryGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ProLibraryGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

-- Main Win10 Window Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 540, 0, 380)
mainFrame.Position = UDim2.new(0.5, -270, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 6)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(45, 45, 48)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- Windows 10 Titlebar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 32)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topBar.BackgroundTransparency = 0
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 6)
topCorner.Parent = topBar

local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0, 6)
topFix.Position = UDim2.new(0, 0, 1, -6)
topFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topFix.BorderSizePixel = 0
topFix.Parent = topBar

-- Icon
local iconImage = Instance.new("ImageLabel")
iconImage.Size = UDim2.new(0, 16, 0, 16)
iconImage.Position = UDim2.new(0, 10, 0.5, -8)
iconImage.BackgroundTransparency = 1
iconImage.Image = "rbxassetid://98291748528451"
iconImage.Parent = topBar

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -90, 1, 0)
titleLabel.Position = UDim2.new(0, 34, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
titleLabel.TextSize = 12
titleLabel.Font = Enum.Font.SegoeUI
titleLabel.Text = "N.A.S - HUB"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Win10 Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 45, 0, 32)
closeButton.Position = UDim2.new(1, -45, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
closeButton.BackgroundTransparency = 1
closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
closeButton.TextSize = 12
closeButton.Font = Enum.Font.SegoeUI
closeButton.Text = "✕"
closeButton.Parent = topBar

closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

closeButton.MouseEnter:Connect(function()
	TweenService:Create(closeButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(232, 17, 35), BackgroundTransparency = 0}):Play()
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

closeButton.MouseLeave:Connect(function()
	TweenService:Create(closeButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 30), BackgroundTransparency = 1}):Play()
	closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

-- Sidebar (Tabs Navigation)
local sidebar = Instance.new("ScrollingFrame")
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

-- Pages Container
local pagesContainer = Instance.new("Frame")
pagesContainer.Size = UDim2.new(1, -148, 1, -42)
pagesContainer.Position = UDim2.new(0, 142, 0, 36)
pagesContainer.BackgroundTransparency = 1
pagesContainer.Parent = mainFrame

local Library = {
	TabsCount = 0,
	FirstTab = true
}

function Library:AddTab(name)
	self.TabsCount = self.TabsCount + 1
	local currentTabIsFirst = self.FirstTab
	
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1, 0, 0, 32)
	tabBtn.BackgroundColor3 = currentTabIsFirst and Color3.fromRGB(50, 54, 57) or Color3.fromRGB(30, 30, 30)
	tabBtn.BackgroundTransparency = currentTabIsFirst and 0.4 or 1
	tabBtn.TextColor3 = currentTabIsFirst and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
	tabBtn.TextSize = 12
	tabBtn.Font = Enum.Font.SegoeUI
	tabBtn.Text = "   " .. name
	tabBtn.TextXAlignment = Enum.TextXAlignment.Left
	tabBtn.AutoButtonColor = false
	tabBtn.Parent = sidebar
	
	local tabCorner = Instance.new("UICorner")
	tabCorner.CornerRadius = UDim.new(0, 4)
	tabCorner.Parent = tabBtn
	
	local tabContent = Instance.new("ScrollingFrame")
	tabContent.Size = UDim2.new(1, -10, 1, 0)
	tabContent.Position = UDim2.new(0, 0, 0, 0)
	tabContent.BackgroundTransparency = 1
	tabContent.BorderSizePixel = 0
	tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tabContent.ScrollBarThickness = 3
	tabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
	tabContent.Visible = currentTabIsFirst
	tabContent.Parent = pagesContainer
	
	local contentLayout = Instance.new("UIListLayout")
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Padding = UDim.new(0, 6)
	contentLayout.Parent = tabContent
	
	if self.FirstTab then
		self.FirstTab = false
	end
	
	tabBtn.MouseButton1Click:Connect(function()
		for _, child in ipairs(pagesContainer:GetChildren()) do
			if child:IsA("ScrollingFrame") then
				child.Visible = false
			end
		end
		for _, child in ipairs(sidebar:GetChildren()) do
			if child:IsA("TextButton") then
				TweenService:Create(child, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(30, 30, 30), TextColor3 = Color3.fromRGB(180, 180, 180), BackgroundTransparency = 1}):Play()
			end
		end
		tabContent.Visible = true
		TweenService:Create(tabBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(50, 54, 57), TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.4}):Play()
	end)
	
	local TabElements = {}
	
	function TabElements:AddButton(text, callback)
		callback = callback or function() end
		
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -6, 0, 32)
		btn.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
		btn.BackgroundTransparency = 0.2
		btn.TextColor3 = Color3.fromRGB(240, 240, 240)
		btn.TextSize = 12
		btn.Font = Enum.Font.SegoeUI
		btn.Text = text
		btn.AutoButtonColor = false
		btn.Parent = tabContent
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = btn
		
		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(51, 51, 55)
		stroke.Thickness = 1
		stroke.Parent = btn
		
		btn.MouseButton1Click:Connect(function()
			task.spawn(callback)
			TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 120, 212), BackgroundTransparency = 0}):Play()
			task.wait(0.12)
			TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(37, 37, 38), BackgroundTransparency = 0.2}):Play()
		end)
		
		btn.MouseEnter:Connect(function()
			TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(0, 120, 212)}):Play()
		end)
		
		btn.MouseLeave:Connect(function()
			TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(51, 51, 55)}):Play()
		end)
	end
	
	function TabElements:AddToggle(text, default, callback)
		default = default or false
		callback = callback or function() end
		local state = default
		
		local frame = Instance.new("TextButton")
		frame.Size = UDim2.new(1, -6, 0, 32)
		frame.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
		frame.BackgroundTransparency = 0.2
		frame.AutoButtonColor = false
		frame.Text = ""
		frame.Parent = tabContent
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = frame
		
		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(51, 51, 55)
		stroke.Thickness = 1
		stroke.Parent = frame
		
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -50, 1, 0)
		label.Position = UDim2.new(0, 10, 0, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(240, 240, 240)
		label.TextSize = 12
		label.Font = Enum.Font.SegoeUI
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = text
		label.Parent = frame
		
		local switchBg = Instance.new("Frame")
		switchBg.Size = UDim2.new(0, 32, 0, 16)
		switchBg.Position = UDim2.new(1, -40, 0.5, -8)
		switchBg.BackgroundColor3 = state and Color3.fromRGB(0, 120, 212) or Color3.fromRGB(60, 60, 60)
		switchBg.BackgroundTransparency = 0
		switchBg.BorderSizePixel = 0
		switchBg.Parent = frame
		
		local switchCorner = Instance.new("UICorner")
		switchCorner.CornerRadius = UDim.new(1, 0)
		switchCorner.Parent = switchBg
		
		local switchCircle = Instance.new("Frame")
		switchCircle.Size = UDim2.new(0, 10, 0, 10)
		switchCircle.Position = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)
		switchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		switchCircle.BorderSizePixel = 0
		switchCircle.Parent = switchBg
		
		local circleCorner = Instance.new("UICorner")
		circleCorner.CornerRadius = UDim.new(1, 0)
		circleCorner.Parent = switchCircle
		
		frame.MouseButton1Click:Connect(function()
			state = not state
			local tColor = state and Color3.fromRGB(0, 120, 212) or Color3.fromRGB(60, 60, 60)
			local tPos = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)
			
			TweenService:Create(switchBg, TweenInfo.new(0.12), {BackgroundColor3 = tColor}):Play()
			TweenService:Create(switchCircle, TweenInfo.new(0.12), {Position = tPos}):Play()
			
			task.spawn(function()
				callback(state)
			end)
		end)
	end
	
	function TabElements:AddSlider(text, min, max, default, callback)
		min = min or 0
		max = max or 100
		default = default or min
		callback = callback or function() end
		local value = default
		
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, -6, 0, 50)
		frame.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
		frame.BackgroundTransparency = 0.2
		frame.Parent = tabContent
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = frame
		
		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(51, 51, 55)
		stroke.Thickness = 1
		stroke.Parent = frame
		
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -50, 0, 20)
		label.Position = UDim2.new(0, 10, 0, 6)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(240, 240, 240)
		label.TextSize = 12
		label.Font = Enum.Font.SegoeUI
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = text
		label.Parent = frame
		
		local valueLabel = Instance.new("TextLabel")
		valueLabel.Size = UDim2.new(0, 40, 0, 20)
		valueLabel.Position = UDim2.new(1, -48, 0, 6)
		valueLabel.BackgroundTransparency = 1
		valueLabel.TextColor3 = Color3.fromRGB(0, 120, 212)
		valueLabel.TextSize = 12
		valueLabel.Font = Enum.Font.LegacyFont
		valueLabel.TextXAlignment = Enum.TextXAlignment.Right
		valueLabel.Text = tostring(value)
		valueLabel.Parent = frame
		
		local sliderBar = Instance.new("TextButton")
		sliderBar.Size = UDim2.new(1, -20, 0, 4)
		sliderBar.Position = UDim2.new(0, 10, 0, 32)
		sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		sliderBar.BackgroundTransparency = 0.2
		sliderBar.AutoButtonColor = false
		sliderBar.Text = ""
		sliderBar.Parent = frame
		
		local barCorner = Instance.new("UICorner")
		barCorner.CornerRadius = UDim.new(1, 0)
		barCorner.Parent = sliderBar
		
		local fill = Instance.new("Frame")
		fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
		fill.BackgroundColor3 = Color3.fromRGB(0, 120, 212)
		fill.BorderSizePixel = 0
		fill.Parent = sliderBar
		
		local fillCorner = Instance.new("UICorner")
		fillCorner.CornerRadius = UDim.new(1, 0)
		fillCorner.Parent = fill
		
		local dragging = false
		
		local function update(input)
			local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
			value = math.floor(min + ((max - min) * pos))
			fill.Size = UDim2.new(pos, 0, 1, 0)
			valueLabel.Text = tostring(value)
			task.spawn(function()
				callback(value)
			end)
		end
		
		sliderBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				update(input)
			end
		end)
		
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)
		
		UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				update(input)
			end
		end)
	end
	
	return TabElements
end

return Library
