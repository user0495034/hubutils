local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

if CoreGui:FindFirstChild("ProLibraryGUI") then
	CoreGui.ProLibraryGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ProLibraryGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

-- Główne okno (większa przezroczystość)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 360)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
mainFrame.BackgroundTransparency = 0.25 -- Zwiększona przezroczystość tła
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(180, 20, 20)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- Pasek górny (Titlebar)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 36)
topBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
topBar.BackgroundTransparency = 0.2
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 8)
topCorner.Parent = topBar

local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0, 8)
topFix.Position = UDim2.new(0, 0, 1, -8)
topFix.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
topFix.BackgroundTransparency = 0.2
topFix.BorderSizePixel = 0
topFix.Parent = topBar

-- Większa główna ikona w nagłówku (Asset ID: 98291748528451)
local iconImage = Instance.new("ImageLabel")
iconImage.Size = UDim2.new(0, 26, 0, 26) -- Zwiększony rozmiar
iconImage.Position = UDim2.new(0, 10, 0.5, -13)
iconImage.BackgroundTransparency = 1
iconImage.Image = "rbxassetid://98291748528451"
iconImage.Parent = topBar

-- Tytuł główny: "N.A.S - HUB"
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -70, 1, 0)
titleLabel.Position = UDim2.new(0, 42, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "N.A.S - HUB"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Przycisk zamykania z ikoną ❌
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -30, 0, 6)
closeButton.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
closeButton.BackgroundTransparency = 0.2
closeButton.TextColor3 = Color3.fromRGB(180, 180, 195)
closeButton.TextSize = 10
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "❌"
closeButton.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

closeButton.MouseEnter:Connect(function()
	TweenService:Create(closeButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 30, 30), BackgroundTransparency = 0}):Play()
end)

closeButton.MouseLeave:Connect(function()
	TweenService:Create(closeButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 32), BackgroundTransparency = 0.2}):Play()
end)

-- Panel boczny (Zakładki - Tabs)
local sidebar = Instance.new("ScrollingFrame")
sidebar.Size = UDim2.new(0, 130, 1, -46)
sidebar.Position = UDim2.new(0, 5, 0, 41)
sidebar.BackgroundTransparency = 1
sidebar.BorderSizePixel = 0
sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
sidebar.ScrollBarThickness = 0
sidebar.Parent = mainFrame

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Padding = UDim.new(0, 4)
sidebarLayout.Parent = sidebar

-- Kontener główny na zawartość zakładek
local pagesContainer = Instance.new("Frame")
pagesContainer.Size = UDim2.new(1, -145, 1, -46)
pagesContainer.Position = UDim2.new(0, 140, 0, 41)
pagesContainer.BackgroundTransparency = 1
pagesContainer.Parent = mainFrame

local Library = {
	TabsCount = 0,
	FirstTab = true
}

function Library:AddTab(name)
	self.TabsCount = self.TabsCount + 1
	
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1, 0, 0, 32)
	tabBtn.BackgroundColor3 = self.FirstTab and Color3.fromRGB(40, 15, 15) or Color3.fromRGB(15, 15, 20)
	tabBtn.BackgroundTransparency = 0.3
	tabBtn.TextColor3 = self.FirstTab and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(130, 130, 150)
	tabBtn.TextSize = 12
	tabBtn.Font = Enum.Font.GothamMedium
	tabBtn.Text = "  " .. name
	tabBtn.TextXAlignment = Enum.TextXAlignment.Left
	tabBtn.AutoButtonColor = false
	tabBtn.Parent = sidebar
	
	local tabCorner = Instance.new("UICorner")
	tabCorner.CornerRadius = UDim.new(0, 6)
	tabCorner.Parent = tabBtn
	
	local tabContent = Instance.new("ScrollingFrame")
	tabContent.Size = UDim2.new(1, -6, 1, 0)
	tabContent.Position = UDim2.new(0, 0, 0, 0)
	tabContent.BackgroundTransparency = 1
	tabContent.BorderSizePixel = 0
	tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tabContent.ScrollBarThickness = 3
	tabContent.ScrollBarImageColor3 = Color3.fromRGB(120, 30, 30)
	tabContent.Visible = self.FirstTab
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
				TweenService:Create(child, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(15, 15, 20), TextColor3 = Color3.fromRGB(130, 130, 150), BackgroundTransparency = 0.3}):Play()
			end
		end
		tabContent.Visible = true
		TweenService:Create(tabBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 15, 15), TextColor3 = Color3.fromRGB(255, 100, 100), BackgroundTransparency = 0.3}):Play()
	end)
	
	local TabElements = {}
	
	function TabElements:AddButton(text, callback)
		callback = callback or function() end
		
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -6, 0, 32)
		btn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
		btn.BackgroundTransparency = 0.35
		btn.TextColor3 = Color3.fromRGB(200, 200, 215)
		btn.TextSize = 12
		btn.Font = Enum.Font.GothamMedium
		btn.Text = text
		btn.AutoButtonColor = false
		btn.Parent = tabContent
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = btn
		
		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(40, 40, 50)
		stroke.Thickness = 1
		stroke.Parent = btn
		
		btn.MouseButton1Click:Connect(function()
			task.spawn(callback)
			TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 20, 20), BackgroundTransparency = 0.1}):Play()
			task.wait(0.1)
			TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 20, 26), BackgroundTransparency = 0.35}):Play()
		end)
		
		btn.MouseEnter:Connect(function()
			TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(180, 30, 30)}):Play()
		end)
		
		btn.MouseLeave:Connect(function()
			TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(40, 40, 50)}):Play()
		end)
	end
	
	function TabElements:AddToggle(text, default, callback)
		default = default or false
		callback = callback or function() end
		local state = default
		
		local frame = Instance.new("TextButton")
		frame.Size = UDim2.new(1, -6, 0, 32)
		frame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
		frame.BackgroundTransparency = 0.35
		frame.AutoButtonColor = false
		frame.Text = ""
		frame.Parent = tabContent
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = frame
		
		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(40, 40, 50)
		stroke.Thickness = 1
		stroke.Parent = frame
		
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -50, 1, 0)
		label.Position = UDim2.new(0, 10, 0, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(200, 200, 215)
		label.TextSize = 12
		label.Font = Enum.Font.GothamMedium
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = text
		label.Parent = frame
		
		local switchBg = Instance.new("Frame")
		switchBg.Size = UDim2.new(0, 30, 0, 16)
		switchBg.Position = UDim2.new(1, -38, 0.5, -8)
		switchBg.BackgroundColor3 = state and Color3.fromRGB(180, 20, 20) or Color3.fromRGB(40, 40, 50)
		switchBg.BackgroundTransparency = 0.2
		switchBg.BorderSizePixel = 0
		switchBg.Parent = frame
		
		local switchCorner = Instance.new("UICorner")
		switchCorner.CornerRadius = UDim.new(1, 0)
		switchCorner.Parent = switchBg
		
		local switchCircle = Instance.new("Frame")
		switchCircle.Size = UDim2.new(0, 12, 0, 12)
		switchCircle.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
		switchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		switchCircle.BorderSizePixel = 0
		switchCircle.Parent = switchBg
		
		local circleCorner = Instance.new("UICorner")
		circleCorner.CornerRadius = UDim.new(1, 0)
		circleCorner.Parent = switchCircle
		
		frame.MouseButton1Click:Connect(function()
			state = not state
			local tColor = state and Color3.fromRGB(180, 20, 20) or Color3.fromRGB(40, 40, 50)
			local tPos = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
			
			TweenService:Create(switchBg, TweenInfo.new(0.15), {BackgroundColor3 = tColor}):Play()
			TweenService:Create(switchCircle, TweenInfo.new(0.15), {Position = tPos}):Play()
			
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
		frame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
		frame.BackgroundTransparency = 0.35
		frame.Parent = tabContent
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = frame
		
		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(40, 40, 50)
		stroke.Thickness = 1
		stroke.Parent = frame
		
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -50, 0, 20)
		label.Position = UDim2.new(0, 10, 0, 6)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(200, 200, 215)
		label.TextSize = 12
		label.Font = Enum.Font.GothamMedium
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = text
		label.Parent = frame
		
		local valueLabel = Instance.new("TextLabel")
		valueLabel.Size = UDim2.new(0, 40, 0, 20)
		valueLabel.Position = UDim2.new(1, -48, 0, 6)
		valueLabel.BackgroundTransparency = 1
		valueLabel.TextColor3 = Color3.fromRGB(180, 80, 80)
		valueLabel.TextSize = 12
		valueLabel.Font = Enum.Font.GothamBold
		valueLabel.TextXAlignment = Enum.TextXAlignment.Right
		valueLabel.Text = tostring(value)
		valueLabel.Parent = frame
		
		local sliderBar = Instance.new("TextButton")
		sliderBar.Size = UDim2.new(1, -20, 0, 5)
		sliderBar.Position = UDim2.new(0, 10, 0, 32)
		sliderBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
		sliderBar.BackgroundTransparency = 0.2
		sliderBar.AutoButtonColor = false
		sliderBar.Text = ""
		sliderBar.Parent = frame
		
		local barCorner = Instance.new("UICorner")
		barCorner.CornerRadius = UDim.new(1, 0)
		barCorner.Parent = sliderBar
		
		local fill = Instance.new("Frame")
		fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
		fill.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
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
