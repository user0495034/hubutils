local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("AdvancedLibraryGUI") then
	playerGui.AdvancedLibraryGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedLibraryGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 420)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "GitHub GUI Library"
titleLabel.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -34, 0, 6)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "X"
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -55)
container.Position = UDim2.new(0, 10, 0, 45)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.CanvasSize = UDim2.new(0, 0, 0, 0)
container.AutomaticCanvasSize = Enum.AutomaticSize.Y
container.ScrollBarThickness = 4
container.Parent = mainFrame

local uiLayout = Instance.new("UIListLayout")
uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiLayout.Padding = UDim.new(0, 8)
uiLayout.Parent = container

local Library = {}

function Library:AddButton(text, callback)
	callback = callback or function() end
	
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
	btn.TextColor3 = Color3.fromRGB(230, 230, 230)
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamMedium
	btn.Text = text
	btn.Parent = container
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	
	btn.MouseButton1Click:Connect(function()
		callback()
	end)
end

function Library:AddToggle(text, default, callback)
	default = default or false
	callback = callback or function() end
	
	local state = default
	
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
	btn.TextColor3 = Color3.fromRGB(230, 230, 230)
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamMedium
	btn.Text = text .. ": " .. (state and "ON" or "OFF")
	btn.Parent = container
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = text .. ": " .. (state and "ON" or "OFF")
		callback(state)
	end)
end

function Library:AddSlider(text, min, max, default, callback)
	min = min or 0
	max = max or 100
	default = default or min
	callback = callback or function() end
	
	local value = default
	
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 56)
	frame.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
	frame.Parent = container
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = frame
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -16, 0, 24)
	label.Position = UDim2.new(0, 8, 0, 4)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(230, 230, 230)
	label.TextSize = 13
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = text .. ": " .. tostring(value)
	label.Parent = frame
	
	local sliderBar = Instance.new("TextButton")
	sliderBar.Size = UDim2.new(1, -16, 0, 14)
	sliderBar.Position = UDim2.new(0, 8, 0, 32)
	sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	sliderBar.Text = ""
	sliderBar.Parent = frame
	
	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0, 4)
	barCorner.Parent = sliderBar
	
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	fill.BorderSizePixel = 0
	fill.Parent = sliderBar
	
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 4)
	fillCorner.Parent = fill
	
	local uis = game:GetService("UserInputService")
	local dragging = false
	
	local function update(input)
		local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
		value = math.floor(min + ((max - min) * pos))
		fill.Size = UDim2.new(pos, 0, 1, 0)
		label.Text = text .. ": " .. tostring(value)
		callback(value)
	end
	
	sliderBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			update(input)
		end
	end)
	
	uis.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	uis.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			update(input)
		end
	end)
end

return Library
