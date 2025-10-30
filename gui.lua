-- gui.lua
-- Rynox Hub GUI module with user preferences (On/Off buttons, auto-load/save)

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- Compatibility shims
if not loadstring and load then
	_G.loadstring = load
end
if not game.HttpGet then
	pcall(function()
		game.HttpGet = function(self, url, ...)
			return HttpService:GetAsync(url, ...)
		end
	end)
end

local GUI = {}

--// ===== GUI CREATION FUNCTION =====
function GUI.Create(config)
	config = config or {}

	local GUIConfig = config.GUIConfig or { Size = UDim2.new(0,500,0,320) }
	local TitleConfig = config.TitleConfig or { { Name = "Rynox Hub", Color = Color3.fromRGB(255,255,255), Size = UDim2.new(0,200,0,40), Position = UDim2.new(0,10,0,0) } }
	local TabsConfig = config.TabsConfig or {}
	local TabButtonConfig = config.TabButtonConfig or {}
	local MainFrameConfig = config.MainFrameConfig or {}
	local Tabs = config.Tabs or {}

	--// Create ScreenGui
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = config.GuiName or "RynoxHub"
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = player:WaitForChild("PlayerGui")

	-- Main Frame
	local Frame = Instance.new("Frame")
	Frame.Size = GUIConfig.Size
	Frame.Position = UDim2.new(0.5,-Frame.Size.X.Offset/2,0.5,-Frame.Size.Y.Offset/2)
	Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
	Frame.BackgroundTransparency = 0.4
	Frame.Active = true
	Frame.Draggable = true
	Frame.Parent = ScreenGui
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,15)

	-- Title
	local TitleData = TitleConfig[1] or { Name = "Rynox Hub", Color = Color3.fromRGB(255,255,255) }
	local Title = Instance.new("TextLabel")
	Title.Text = TitleData.Name
	Title.Size = TitleData.Size or UDim2.new(0,200,0,40)
	Title.Position = TitleData.Position or UDim2.new(0,10,0,0)
	Title.BackgroundTransparency = 1
	Title.TextColor3 = TitleData.Color or Color3.fromRGB(255,255,255)
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 22
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Frame

	-- Top Buttons
	local function MakeTopButton(text,color,posX)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0,30,0,30)
		btn.Position = UDim2.new(1,posX,0,5)
		btn.BackgroundColor3 = color
		btn.Text = text
		btn.TextColor3 = Color3.fromRGB(255,255,255)
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 20
		btn.Parent = Frame
		Instance.new("UICorner", btn)
		return btn
	end

	local CloseBtn = MakeTopButton("X",Color3.fromRGB(50,0,0),-35)
	local FullBtn = MakeTopButton("⛶",Color3.fromRGB(30,30,30),-70)

	-- Tabs Panel
	local TabFrame = Instance.new("Frame")
	TabFrame.Size = TabsConfig.Size or UDim2.new(0,110,1,-60)
	TabFrame.Position = TabsConfig.Position or UDim2.new(0,0,0,40)
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

	-- Main Content Area
	local ContentFrame = Instance.new("Frame")
	ContentFrame.Size = MainFrameConfig.Size or UDim2.new(1,-130,1,-60)
	ContentFrame.Position = MainFrameConfig.Position or UDim2.new(0,130,0,40)
	ContentFrame.BackgroundTransparency = 1
	ContentFrame.Parent = Frame

	-- User Preferences Table
	local UserPrefs = {}

	-- Load prefs from player (StringValue)
	local function LoadPrefs()
		local saved = player:FindFirstChild("RynoxPrefs")
		if saved and saved:IsA("StringValue") then
			local success, data = pcall(function()
				return HttpService:JSONDecode(saved.Value)
			end)
			if success and type(data)=="table" then
				UserPrefs = data
			end
		end
	end

	local function SavePrefs()
		local json = HttpService:JSONEncode(UserPrefs)
		local saved = player:FindFirstChild("RynoxPrefs")
		if not saved then
			saved = Instance.new("StringValue")
			saved.Name = "RynoxPrefs"
			saved.Parent = player
		end
		saved.Value = json
	end

	LoadPrefs()

	-- Helper to safely execute element function
	local function safeExecute(fn,state)
		local ok, err = pcall(function()
			fn(state)
		end)
		if not ok then
			warn("[RynoxHub] Element error: "..tostring(err))
		end
	end

	-- Create Sections and Elements
	local function CreateSection(tabFrame, sectionData)
		local sectionLabel = Instance.new("TextLabel")
		sectionLabel.Size = UDim2.new(1,-10,0,25)
		sectionLabel.Text = "-- "..(sectionData.Name or "Section").." --"
		sectionLabel.TextColor3 = Color3.fromRGB(255,255,255)
		sectionLabel.BackgroundTransparency = 1
		sectionLabel.Font = Enum.Font.GothamBold
		sectionLabel.TextSize = 20
		sectionLabel.Parent = tabFrame

		for _, element in ipairs(sectionData.Elements or {}) do
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(0,180,0,45)
			btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
			btn.Text = element.Name or "Button"
			btn.TextColor3 = Color3.fromRGB(255,255,255)
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 20
			btn.Parent = tabFrame
			Instance.new("UICorner", btn)

			if element.Mode == "On/Off" then
				-- Create toggle button
				local toggle = Instance.new("TextButton")
				toggle.Size = UDim2.new(0,60,0,30)
				toggle.Position = UDim2.new(0,190,0,7)
				toggle.Text = UserPrefs[element.Name] and "ON" or "OFF"
				toggle.BackgroundColor3 = UserPrefs[element.Name] and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
				toggle.TextColor3 = Color3.fromRGB(255,255,255)
				toggle.Font = Enum.Font.GothamBold
				toggle.TextSize = 16
				toggle.Parent = tabFrame
				Instance.new("UICorner", toggle)

				local function update(state)
					toggle.Text = state and "ON" or "OFF"
					toggle.BackgroundColor3 = state and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
					UserPrefs[element.Name] = state
					SavePrefs()
					if type(element.Function)=="function" then
						safeExecute(element.Function,state)
					end
				end

				toggle.MouseButton1Click:Connect(function()
					update(not (UserPrefs[element.Name] or false))
				end)

				-- Run initial
				update(UserPrefs[element.Name] or false)
			else
				btn.MouseButton1Click:Connect(function()
					if type(element.Function)=="function" then
						safeExecute(element.Function)
					end
				end)
			end
		end
	end

	-- Tabs
	local activeTab
	for _, tabData in ipairs(Tabs or {}) do
		local tabButton = Instance.new("TextButton")
		tabButton.Text = tabData.Name or "Tab"
		tabButton.Size = TabButtonConfig.DefaultSize or UDim2.new(1,-5,0,35)
		tabButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
		tabButton.TextColor3 = Color3.fromRGB(255,255,255)
		tabButton.Font = Enum.Font.GothamBold
		tabButton.TextSize = 18
		tabButton.Parent = TabScroll
		Instance.new("UICorner", tabButton)

		local tabContent = Instance.new("ScrollingFrame")
		tabContent.Size = UDim2.new(1,0,1,0)
		tabContent.Position = UDim2.new(0,0,0,0)
		tabContent.CanvasSize = UDim2.new(0,0,0,0)
		tabContent.ScrollBarThickness = 6
		tabContent.BackgroundTransparency = 1
		tabContent.Visible = false
		tabContent.Parent = ContentFrame

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0,8)
		layout.Parent = tabContent

		for _, section in ipairs(tabData.Sections or {}) do
			CreateSection(tabContent, section)
		end

		tabButton.MouseButton1Click:Connect(function()
			if activeTab then activeTab.Visible = false end
			tabContent.Visible = true
			activeTab = tabContent
		end)
	end

	UIListLayoutTabs:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabScroll.CanvasSize = UDim2.new(0,0,0,UIListLayoutTabs.AbsoluteContentSize.Y+10)
	end)

	-- Fullscreen / Close
	local isFullscreen = false
	local originalSize = Frame.Size
	local originalPos = Frame.Position

	FullBtn.MouseButton1Click:Connect(function()
		isFullscreen = not isFullscreen
		if isFullscreen then
			Frame:TweenSizeAndPosition(UDim2.new(1,0,1,0),UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.3)
		else
			Frame:TweenSizeAndPosition(originalSize,originalPos,Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.3)
		end
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		Frame.Visible = false
	end)

	return ScreenGui
end

return GUI
