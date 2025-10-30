--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

--// GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RynoxHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 500, 0, 320)
Frame.Position = UDim2.new(0.5, -250, 0.5, -160)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.4
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 15)

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "Rynox Hub"
Title.Size = UDim2.new(0, 180, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Frame

-- Top buttons
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = Frame
Instance.new("UICorner", CloseBtn)

local FullBtn = Instance.new("TextButton")
FullBtn.Size = UDim2.new(0, 30, 0, 30)
FullBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FullBtn.Text = "⛶"
FullBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FullBtn.Font = Enum.Font.GothamBold
FullBtn.TextSize = 18
FullBtn.Parent = Frame
Instance.new("UICorner", FullBtn)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.Parent = Frame
Instance.new("UICorner", MinBtn)

CloseBtn.Position = UDim2.new(1, -35, 0, 5)
FullBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.Position = UDim2.new(1, -105, 0, 5)

-- Tabs
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(0, 100, 1, -60)
TabFrame.Position = UDim2.new(0, 0, 0, 40)
TabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabFrame.BackgroundTransparency = 0.3
TabFrame.Parent = Frame
Instance.new("UICorner", TabFrame)

local MainTab = Instance.new("TextButton")
MainTab.Text = "Main"
MainTab.Size = UDim2.new(1, 0, 0, 40)
MainTab.Position = UDim2.new(0, 0, 0, 0)
MainTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainTab.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTab.Font = Enum.Font.GothamBold
MainTab.TextSize = 18
MainTab.Parent = TabFrame
Instance.new("UICorner", MainTab)

local InfoTab = Instance.new("TextButton")
InfoTab.Text = "Info"
InfoTab.Size = UDim2.new(1, 0, 0, 40)
InfoTab.Position = UDim2.new(0, 0, 0, 45)
InfoTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
InfoTab.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoTab.Font = Enum.Font.GothamBold
InfoTab.TextSize = 18
InfoTab.Parent = TabFrame
Instance.new("UICorner", InfoTab)

-- Content Frames
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, -120, 1, -60)
MainFrame.Position = UDim2.new(0, 120, 0, 40)
MainFrame.BackgroundTransparency = 1
MainFrame.Parent = Frame

local InfoFrame = Instance.new("Frame")
InfoFrame.Size = MainFrame.Size
InfoFrame.Position = MainFrame.Position
InfoFrame.BackgroundTransparency = 1
InfoFrame.Visible = false
InfoFrame.Parent = Frame

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -20, 1, -20)
InfoLabel.Position = UDim2.new(0, 10, 0, 10)
InfoLabel.Text = "Created by Rynox"
InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.TextSize = 22
InfoLabel.Parent = InfoFrame

--// FIXED: TPWalk Button at TOP LEFT
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 180, 0, 45)
ToggleButton.Position = UDim2.new(0, 10, 0, 10) -- top-left corner of MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Text = "TP Walk: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 22
ToggleButton.Parent = MainFrame
Instance.new("UICorner", ToggleButton)

-- Bottom Profile
local BottomFrame = Instance.new("Frame")
BottomFrame.Size = UDim2.new(1, 0, 0, 50)
BottomFrame.Position = UDim2.new(0, 0, 1, -50)
BottomFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BottomFrame.BackgroundTransparency = 0.25
BottomFrame.Parent = Frame
Instance.new("UICorner", BottomFrame).CornerRadius = UDim.new(0, 12)

-- Avatar
local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 40, 0, 40)
Avatar.Position = UDim2.new(0, 10, 0.5, -20)
Avatar.BackgroundTransparency = 1
Avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
Avatar.Parent = BottomFrame
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

-- Welcome Typing + Fade/Un-type
local Welcome = Instance.new("TextLabel")
Welcome.Size = UDim2.new(1, -60, 1, 0)
Welcome.Position = UDim2.new(0, 60, 0, 0)
Welcome.BackgroundTransparency = 1
Welcome.TextColor3 = Color3.fromRGB(255, 255, 255)
Welcome.Font = Enum.Font.GothamBold
Welcome.TextSize = 20
Welcome.TextXAlignment = Enum.TextXAlignment.Left
Welcome.Parent = BottomFrame

task.spawn(function()
	local fullText = "Welcome, " .. player.DisplayName
	Welcome.Text = ""
	for i = 1, #fullText do
		Welcome.Text = string.sub(fullText, 1, i)
		task.wait(0.1)
	end
	task.wait(2)
	for i = #fullText, 1, -1 do
		Welcome.Text = string.sub(fullText, 1, i - 1)
		task.wait(0.05)
	end
end)

-- TPWalk Logic
local tpSpeed = 4
local tpWalkEnabled = false
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

RunService.RenderStepped:Connect(function(dt)
	if tpWalkEnabled and humanoid and root and humanoid.MoveDirection.Magnitude > 0 then
		root.CFrame = root.CFrame + (humanoid.MoveDirection * tpSpeed * dt * 30)
	end
end)

ToggleButton.MouseButton1Click:Connect(function()
	tpWalkEnabled = not tpWalkEnabled
	ToggleButton.Text = "TP Walk: " .. (tpWalkEnabled and "ON" or "OFF")
end)

player.CharacterAdded:Connect(function(newChar)
	char = newChar
	root = char:WaitForChild("HumanoidRootPart")
	humanoid = char:WaitForChild("Humanoid")
	task.wait(1)
	ToggleButton.Text = "TP Walk: " .. (tpWalkEnabled and "ON" or "OFF")
end)

-- Tabs
local activeTab = "Main"
MainTab.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	InfoFrame.Visible = false
	activeTab = "Main"
	MainTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	InfoTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
end)

InfoTab.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	InfoFrame.Visible = true
	activeTab = "Info"
	InfoTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	MainTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
end)

-- Fullscreen & Minimize
local isFullscreen = false
local isMinimized = false
local originalSize = Frame.Size
local originalPos = Frame.Position

FullBtn.MouseButton1Click:Connect(function()
	isFullscreen = not isFullscreen
	if isFullscreen then
		Frame:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
	else
		Frame:TweenSizeAndPosition(originalSize, originalPos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
	end
end)

MinBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		for _, obj in ipairs(Frame:GetDescendants()) do
			if not table.find({Title, MinBtn, CloseBtn, FullBtn}, obj) and obj:IsA("GuiObject") then
				obj.Visible = false
			end
		end
		Frame.Size = UDim2.new(0, 250, 0, 40)
	else
		for _, obj in ipairs(Frame:GetDescendants()) do
			if obj:IsA("GuiObject") then
				obj.Visible = true
			end
		end
		Frame.Size = originalSize
		if activeTab == "Main" then
			MainFrame.Visible = true
			InfoFrame.Visible = false
		else
			MainFrame.Visible = false
			InfoFrame.Visible = true
		end
	end
end)

CloseBtn.MouseButton1Click:Connect(function()
	Frame.Visible = false
end)
