local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Usunięcie starego GUI
if CoreGui:FindFirstChild("ModernLibraryGUI") then
	CoreGui.ModernLibraryGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernLibraryGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

-- Główne okno
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 480)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(45, 45, 55)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- Górny pasek (Nagłówek)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 10)
topCorner.Parent = topBar

-- Korekta dolnych rogów paska, żeby były proste
local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0, 10)
topFix.Position = UDim2.new(0, 0, 1, -10)
topFix.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
topFix.BorderSizePixel = 0
topFix.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 16, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "SYSTEM // UI LIB"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Przycisk zamykania
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -36, 0, 8)
closeButton.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
closeButton.TextColor3 = Color3.fromRGB(180, 180, 190)
closeButton.TextSize = 12
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "✕"
closeButton.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

closeButton.MouseEnter:Connect(function()
	TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 50, 50), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)

closeButton.MouseLeave:Connect(function()
	TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 40), TextColor3 = Color3.fromRGB(180, 180, 190)}):Play()
end)

-- Kontener elementów (ScrollingFrame)
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -24, 1, -65)
container.Position = UDim2.new(0, 12, 0, 55)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.CanvasSize = UDim2.new(0, 0, 0, 0)
container.AutomaticCanvasSize = Enum.AutomaticSize.Y
container.ScrollBarThickness = 3
container.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 75)
container.Parent = mainFrame

local uiLayout = Instance.new("UIListLayout")
uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiLayout.Padding = UDim.new(0, 8)
uiLayout.Parent = container

local Library = {}

function Library:AddButton(text, callback)
	callback = callback or function() end
	
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 38)
	btn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
	btn.TextColor3 = Color3.fromRGB(210, 210, 220)
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamMedium
	btn.Text = text
	btn.AutoButtonColor = false
	btn.Parent = container
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(40, 40, 52)
	stroke.Thickness = 1
	stroke.Parent = btn
	
	btn.MouseButton1Click:Connect(function()
		task.spawn(callback)
		-- Efekt kliknięcia (mignięcie)
		TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 65)}):Play()
		task.wait(0.1)
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(24, 24, 32)}):Play()
	end)
	
	btn.MouseEnter:Connect(function()
		TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 80, 110)}):Play()
	end)
	
	btn.MouseLeave:Connect(function()
		TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40, 40, 52)}):Play()
	end)
end

function Library:AddToggle(text, default, callback)
	default = default or false
	callback = callback or function() end
	local state = default
	
	local frame = Instance.new("TextButton")
	frame.Size = UDim2.new(1, 0, 0, 38)
	frame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
	frame.AutoButtonColor = false
	frame.Text = ""
	frame.Parent = container
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = frame
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(40, 40, 52)
	stroke.Thickness = 1
	stroke.Parent = frame
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(210, 210, 220)
	label.TextSize = 13
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = text
	label.Parent = frame
	
	-- Przełącznik (Switch Box)
	local switchBg = Instance.new("Frame")
	switchBg.Size = UDim2.new(0, 36, 0, 20)
	switchBg.Position = UDim2.new(1, -44, 0.5, -10)
	switchBg.BackgroundColor3 = state and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(40, 40, 50)
	switchBg.BorderSizePixel = 0
	switchBg.Parent = frame
	
	local switchCorner = Instance.new("UICorner")
	switchCorner.CornerRadius = UDim.new(1, 0)
	switchCorner.Parent = switchBg
	
	local switchCircle = Instance.new("Frame")
	switchCircle.Size = UDim2.new(0, 14, 0, 14)
	switchCircle.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
	switchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	switchCircle.BorderSizePixel = 0
	switchCircle.Parent = switchBg
	
	local circleCorner = Instance.new("UICorner")
	circleCorner.CornerRadius = UDim.new(1, 0)
	circleCorner.Parent = switchCircle
	
	local function updateToggle()
		state = not state
		local targetColor = state and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(40, 40, 50)
		local targetPos = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
		
		TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
		TweenService:Create(switchCircle, TweenInfo.new(0.2), {Position = targetPos}):Play()
		
		task.spawn(function()
			callback(state)
		end)
	end
	
	frame.MouseButton1Click:Connect(updateToggle)
end

function Library:AddSlider(text, min, max, default, callback)
	min = min or 0
	max = max or 100
	default = default or min
	callback = callback or function() end
	local value = default
	
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 60)
	frame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
	frame.Parent = container
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = frame
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(40, 40, 52)
	stroke.Thickness = 1
	stroke.Parent = frame
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 0, 24)
	label.Position = UDim2.new(0, 12, 0, 6)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(210, 210, 220)
	label.TextSize = 13
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = text
	label.Parent = frame
	
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(0, 50, 0, 24)
	valueLabel.Position = UDim2.new(1, -62, 0, 6)
	valueLabel.BackgroundTransparency = 1
	valueLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
	valueLabel.TextSize = 13
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Text = tostring(value)
	valueLabel.Parent = frame
	
	-- Suwak
	local sliderBar = Instance.new("TextButton")
	sliderBar.Size = UDim2.new(1, -24, 0, 6)
	sliderBar.Position = UDim2.new(0, 12, 0, 38)
	sliderBar.BackgroundColor3 = Color3.fromRGB(38, 38, 50)
	sliderBar.AutoButtonColor = false
	sliderBar.Text = ""
	sliderBar.Parent = frame
	
	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(1, 0)
	barCorner.Parent = sliderBar
	
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
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

return Library
