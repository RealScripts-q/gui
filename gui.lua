-- gui.lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer

--// ===== GUI CREATION =====
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
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "Rynox Hub"
TitleLabel.Size = UDim2.new(0, 200, 0, 40)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 22
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Frame

-- Top Buttons (fullscreen & close)
local function MakeTopButton(text, color, posX)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 30, 0, 30)
	btn.Position = UDim2.new(1, posX, 0, 5)
	btn.BackgroundColor3 = color
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 20
	btn.Parent = Frame
	Instance.new("UICorner", btn)
	return btn
end

local CloseBtn = MakeTopButton("X", Color3.fromRGB(50, 0, 0), -35)
local FullBtn = MakeTopButton("⛶", Color3.fromRGB(30, 30, 30), -70)

-- Tabs Panel
local TabScrollFrame = Instance.new("Frame")
TabScrollFrame.Size = UDim2.new(0, 110, 1, -60)
TabScrollFrame.Position = UDim2.new(0, 0, 0, 40)
TabScrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabScrollFrame.BackgroundTransparency = 0.3
TabScrollFrame.Parent = Frame
Instance.new("UICorner", TabScrollFrame)

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Size = UDim2.new(1, 0, 1, 0)
TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabScroll.ScrollBarThickness = 4
TabScroll.BackgroundTransparency = 1
TabScroll.Parent = TabScrollFrame

local UIListLayoutTabs = Instance.new("UIListLayout")
UIListLayoutTabs.Padding = UDim.new(0, 5)
UIListLayoutTabs.Parent = TabScroll

-- Content Frames
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, -130, 1, -60)
MainFrame.Position = UDim2.new(0, 130, 0, 40)
MainFrame.BackgroundTransparency = 1
MainFrame.Parent = Frame

local MainListLayout = Instance.new("UIListLayout")
MainListLayout.Padding = UDim.new(0, 10)
MainListLayout.FillDirection = Enum.FillDirection.Vertical
MainListLayout.SortOrder = Enum.SortOrder.LayoutOrder
MainListLayout.Parent = MainFrame

local InfoFrame = Instance.new("Frame")
InfoFrame.Size = MainFrame.Size
InfoFrame.Position = MainFrame.Position
InfoFrame.BackgroundTransparency = 1
InfoFrame.Visible = false
InfoFrame.Parent = Frame

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -20, 1, -20)
InfoLabel.Position = UDim2.new(0, 10, 0, 10)
InfoLabel.Text = "Created by Rynox Team"
InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.TextSize = 22
InfoLabel.Parent = InfoFrame

-- Bottom Section
local BottomFrame = Instance.new("Frame")
BottomFrame.Size = UDim2.new(1, 0, 0, 50)
BottomFrame.Position = UDim2.new(0, 0, 1, -50)
BottomFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BottomFrame.BackgroundTransparency = 0.25
BottomFrame.Parent = Frame
Instance.new("UICorner", BottomFrame).CornerRadius = UDim.new(0, 12)

local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 40, 0, 40)
Avatar.Position = UDim2.new(0, 10, 0.5, -20)
Avatar.BackgroundTransparency = 1
local ok, thumb = pcall(function()
	return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)
if ok then Avatar.Image = thumb end
Avatar.Parent = BottomFrame
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

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
	local txt = "Welcome, " .. player.DisplayName
	Welcome.Text = ""
	for i = 1, #txt do
		Welcome.Text = string.sub(txt, 1, i)
		task.wait(0.05)
	end
end)

-- Fullscreen / Close logic
local isFullscreen = false
local originalSize = Frame.Size
local originalPos = Frame.Position

FullBtn.MouseButton1Click:Connect(function()
	isFullscreen = not isFullscreen
	if isFullscreen then
		Frame:TweenSizeAndPosition(UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
	else
		Frame:TweenSizeAndPosition(originalSize, originalPos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
	end
end)

CloseBtn.MouseButton1Click:Connect(function()
	Frame:Destroy()
end)

-- Export objects for config script
return {
	ScreenGui = ScreenGui,
	Frame = Frame,
	MainFrame = MainFrame,
	InfoFrame = InfoFrame,
	InfoLabel = InfoLabel,
	TabScroll = TabScroll,
	CloseBtn = CloseBtn,
	FullBtn = FullBtn,
	TitleLabel = TitleLabel,
	Welcome = Welcome
}
