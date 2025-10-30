-- gui.lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI containers
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RynoxHub"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
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
Title.Size = UDim2.new(0, 200, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Frame

-- Top buttons
local function MakeTopButton(text, color, posX)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 30, 0, 30)
	btn.Position = UDim2.new(1, posX, 0, 5)
	btn.BackgroundColor3 = color
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 20
	btn.Parent = Frame
	Instance.new("UICorner", btn)
	return btn
end

local CloseBtn = MakeTopButton("X", Color3.fromRGB(50,0,0), -35)
local FullBtn = MakeTopButton("⛶", Color3.fromRGB(30,30,30), -70)

-- Tabs frame
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(0, 110, 1, -60)
TabFrame.Position = UDim2.new(0,0,0,40)
TabFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
TabFrame.BackgroundTransparency = 0.3
TabFrame.Parent = Frame
Instance.new("UICorner", TabFrame)

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Size = UDim2.new(1,0,1,0)
TabScroll.CanvasSize = UDim2.new(0,0,0,0)
TabScroll.ScrollBarThickness = 4
TabScroll.BackgroundTransparency = 1
TabScroll.Parent = TabFrame

local UIListLayoutTabs = Instance.new("UIListLayout")
UIListLayoutTabs.Padding = UDim.new(0,5)
UIListLayoutTabs.Parent = TabScroll

-- Container for tab content
local TabsContent = {}

-- Function to create tabs
local TabButtons = {}
local activeTab = nil
local TabsConfig = {
	{ Name = "Main", Order = 1 },
	{ Name = "Info", Order = 2 },
}

for _, tabInfo in ipairs(TabsConfig) do
	local tabName = tabInfo.Name

	-- Create tab button
	local TabButton = Instance.new("TextButton")
	TabButton.Text = tabName
	TabButton.Size = UDim2.new(1, -5, 0, 35)
	TabButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
	TabButton.TextColor3 = Color3.fromRGB(255,255,255)
	TabButton.Font = Enum.Font.GothamBold
	TabButton.TextSize = 18
	TabButton.Parent = TabScroll
	Instance.new("UICorner", TabButton)
	TabButtons[tabName] = TabButton

	-- Create tab content frame
	local ContentFrame = Instance.new("Frame")
	ContentFrame.Size = UDim2.new(1, -130, 1, -60)
	ContentFrame.Position = UDim2.new(0,130,0,40)
	ContentFrame.BackgroundTransparency = 1
	ContentFrame.Visible = false
	ContentFrame.Parent = Frame
	TabsContent[tabName] = ContentFrame

	local Layout = Instance.new("UIListLayout")
	Layout.Padding = UDim.new(0,10)
	Layout.FillDirection = Enum.FillDirection.Vertical
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Parent = ContentFrame

	-- Tab button click logic
	TabButton.MouseButton1Click:Connect(function()
		for _, f in pairs(TabsContent) do
			f.Visible = false
		end
		ContentFrame.Visible = true
		activeTab = tabName
	end)
end

-- Default open tab
activeTab = "Main"
TabsContent[activeTab].Visible = true

-- Fullscreen / close
local originalSize = Frame.Size
local originalPos = Frame.Position
local isFullscreen = false

FullBtn.MouseButton1Click:Connect(function()
	isFullscreen = not isFullscreen
	if isFullscreen then
		Frame:TweenSizeAndPosition(UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
	else
		Frame:TweenSizeAndPosition(originalSize, originalPos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
	end
end)

CloseBtn.MouseButton1Click:Connect(function()
	Frame.Visible = false
end)

-- Export tables for config
return {
	TabsContent = TabsContent,
	TabButtons = TabButtons
}
