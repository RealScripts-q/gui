--// gui.lua
-- Handles GUI creation for Rynox Hub
-- Called by config.lua (do not include config tables here)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local GUI = {}

--// Create GUI Function
function GUI.Create(config)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = config.GuiName or "RynoxHub"
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = player:WaitForChild("PlayerGui")

	-- Main Frame
	local Frame = Instance.new("Frame")
	Frame.Size = config.GUIConfig.Size or UDim2.new(0, 500, 0, 320)
	Frame.Position = UDim2.new(0.5, -250, 0.5, -160)
	Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BackgroundTransparency = 0.4
	Frame.Active = true
	Frame.Draggable = true
	Frame.Parent = ScreenGui
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 15)

	-- Title
	if config.TitleConfig and #config.TitleConfig > 0 then
		local TitleData = config.TitleConfig[1]
		local Title = Instance.new("TextLabel")
		Title.Text = TitleData.Name
		Title.Size = TitleData.Size
		Title.Position = TitleData.Position
		Title.BackgroundTransparency = 1
		Title.TextColor3 = TitleData.Color
		Title.Font = Enum.Font.GothamBold
		Title.TextSize = 22
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.Parent = Frame
	end

	-- Buttons (Close / Fullscreen)
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
	local TabsConfig = config.TabsConfig or {}
	local TabFrame = Instance.new("Frame")
	TabFrame.Size = TabsConfig.Size or UDim2.new(0, 110, 1, -60)
	TabFrame.Position = TabsConfig.Position or UDim2.new(0, 0, 0, 40)
	TabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	TabFrame.BackgroundTransparency = 0.3
	TabFrame.Parent = Frame
	Instance.new("UICorner", TabFrame)

	local TabScroll = Instance.new("ScrollingFrame")
	TabScroll.Size = UDim2.new(1, 0, 1, 0)
	TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabScroll.ScrollBarThickness = 4
	TabScroll.BackgroundTransparency = 1
	TabScroll.Parent = TabFrame

	local UIListLayoutTabs = Instance.new("UIListLayout")
	UIListLayoutTabs.Padding = UDim.new(0, 5)
	UIListLayoutTabs.Parent = TabScroll

	-- Main Content
	local MainFrameConfig = config.MainFrameConfig or {}
	local ContentFrame = Instance.new("Frame")
	ContentFrame.Size = MainFrameConfig.Size or UDim2.new(1, -130, 1, -60)
	ContentFrame.Position = MainFrameConfig.Position or UDim2.new(0, 130, 0, 40)
	ContentFrame.BackgroundTransparency = 1
	ContentFrame.Parent = Frame

	-- Section Creation
	local function CreateSection(tabFrame, sectionData)
		local sectionLabel = Instance.new("TextLabel")
		sectionLabel.Size = UDim2.new(1, -10, 0, 25)
		sectionLabel.Text = "-- " .. sectionData.Name .. " --"
		sectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		sectionLabel.BackgroundTransparency = 1
		sectionLabel.Font = Enum.Font.GothamBold
		sectionLabel.TextSize = 20
		sectionLabel.Parent = tabFrame

		for _, element in ipairs(sectionData.Elements) do
			if element.Type == "Button" then
				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(0, 180, 0, 45)
				btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				btn.Text = element.Name
				btn.TextColor3 = Color3.fromRGB(255, 255, 255)
				btn.Font = Enum.Font.GothamBold
				btn.TextSize = 20
				btn.Parent = tabFrame
				Instance.new("UICorner", btn)
				btn.MouseButton1Click:Connect(function()
					if element.Function then
						element.Function(btn)
					end
				end)
			elseif element.Type == "Text" then
				local txt = Instance.new("TextLabel")
				txt.Size = UDim2.new(1, -10, 0, 25)
				txt.Text = element.Name
				txt.TextColor3 = Color3.fromRGB(255, 255, 255)
				txt.BackgroundTransparency = 1
				txt.Font = Enum.Font.GothamBold
				txt.TextSize = 18
				txt.Parent = tabFrame
			end
		end
	end

	-- Tabs
	local activeTab = nil
	for _, tabData in ipairs(config.Tabs or {}) do
		local tabButton = Instance.new("TextButton")
		tabButton.Text = tabData.Name
		tabButton.Size = config.TabButtonConfig.DefaultSize or UDim2.new(1, -5, 0, 35)
		tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabButton.Font = Enum.Font.GothamBold
		tabButton.TextSize = 18
		tabButton.Parent = TabScroll
		Instance.new("UICorner", tabButton)

		local tabContent = Instance.new("ScrollingFrame")
		tabContent.Size = UDim2.new(1, 0, 1, 0)
		tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
		tabContent.ScrollBarThickness = 6
		tabContent.BackgroundTransparency = 1
		tabContent.Visible = false
		tabContent.Parent = ContentFrame

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 8)
		layout.Parent = tabContent

		for _, section in ipairs(tabData.Sections) do
			CreateSection(tabContent, section)
		end

		tabButton.MouseButton1Click:Connect(function()
			if activeTab then
				activeTab.Visible = false
			end
			tabContent.Visible = true
			activeTab = tabContent
		end)
	end

	UIListLayoutTabs:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayoutTabs.AbsoluteContentSize.Y + 10)
	end)

	-- Fullscreen & Close
	local isFullscreen = false
	local originalSize = Frame.Size
	local originalPos = Frame.Position

	FullBtn.MouseButton1Click:Connect(function()
		isFullscreen = not isFullscreen
		if isFullscreen then
			Frame:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
		else
			Frame:TweenSizeAndPosition(originalSize, originalPos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)
		end
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		Frame.Visible = false
	end)

	return ScreenGui
end

return GUI
