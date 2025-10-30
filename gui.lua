-- gui.lua
-- Rynox Hub GUI module (updated to improve loadstring/http compatibility and error diagnostics)

--// Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- Compatibility shims -------------------------------------------------------
-- Ensure `loadstring` exists (use `load` if available)
if not loadstring and load then
	_G.loadstring = load -- expose globally so user config calling `loadstring` will work
end

-- Ensure game:HttpGet exists (if not, provide a wrapper using HttpService:GetAsync)
if not game.HttpGet then
	-- note: in some environments this may be prohibited; wrap in pcall
	pcall(function()
		game.HttpGet = function(self, url, ...)
			return HttpService:GetAsync(url, ...)
		end
	end)
end
-----------------------------------------------------------------------------

local GUI = {}

--// ===== GUI CREATION FUNCTION =====
function GUI.Create(config)
	-- allow nil config defaults
	config = config or {}

	local GUIConfig = config.GUIConfig or { Size = UDim2.new(0, 500, 0, 320) }
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
	Frame.Position = UDim2.new(0.5, -Frame.Size.X.Offset / 2, 0.5, -Frame.Size.Y.Offset / 2)
	Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BackgroundTransparency = 0.4
	Frame.Active = true
	Frame.Draggable = true
	Frame.Parent = ScreenGui
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 15)

	-- Title
	local TitleData = TitleConfig[1] or { Name = "Rynox Hub", Color = Color3.fromRGB(255,255,255) }
	local Title = Instance.new("TextLabel")
	Title.Text = TitleData.Name
	Title.Size = TitleData.Size or UDim2.new(0, 200, 0, 40)
	Title.Position = TitleData.Position or UDim2.new(0, 10, 0, 0)
	Title.BackgroundTransparency = 1
	Title.TextColor3 = TitleData.Color or Color3.fromRGB(255,255,255)
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 22
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Frame

	-- Top Buttons
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

	-- Main Content Area
	local ContentFrame = Instance.new("Frame")
	ContentFrame.Size = MainFrameConfig.Size or UDim2.new(1, -130, 1, -60)
	ContentFrame.Position = MainFrameConfig.Position or UDim2.new(0, 130, 0, 40)
	ContentFrame.BackgroundTransparency = 1
	ContentFrame.Parent = Frame

	-- Helper: safe execute element function and report errors
	local function safeExecuteElementFunc(fn, btn)
		local ok, err = pcall(function()
			-- call element function; many element funcs expect btn argument
			fn(btn)
		end)
		if not ok then
			-- print clear diagnostic so user can debug loadstring/http errors
			warn(("[RynoxHub] Element function error: %s"):format(tostring(err)))
			-- if error mentions loadstring missing, log helpful hint
			local errStr = tostring(err):lower()
			if string.find(errStr, "loadstring") or string.find(errStr, "attempt to call") then
				warn("[RynoxHub] Hint: loadstring may be unavailable in this environment. The module provided a fallback to `load` if present, but your executor may still block it.")
			end
		end
	end

	-- Function to create sections and elements
	local function CreateSection(tabFrame, sectionData)
		local sectionLabel = Instance.new("TextLabel")
		sectionLabel.Size = UDim2.new(1, -10, 0, 25)
		sectionLabel.Text = "-- " .. (sectionData.Name or "Section") .. " --"
		sectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		sectionLabel.BackgroundTransparency = 1
		sectionLabel.Font = Enum.Font.GothamBold
		sectionLabel.TextSize = 20
		sectionLabel.Parent = tabFrame

		for _, element in ipairs(sectionData.Elements or {}) do
			if element.Type == "Button" then
				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(0, 180, 0, 45)
				btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				btn.Text = element.Name or "Button"
				btn.TextColor3 = Color3.fromRGB(255, 255, 255)
				btn.Font = Enum.Font.GothamBold
				btn.TextSize = 20
				btn.Parent = tabFrame
				Instance.new("UICorner", btn)

				btn.MouseButton1Click:Connect(function()
					-- run element function safely (pcall) and async to avoid UI freeze
					task.spawn(function()
						if type(element.Function) == "function" then
							safeExecuteElementFunc(element.Function, btn)
						end
					end)
				end)
			elseif element.Type == "Text" then
				local txt = Instance.new("TextLabel")
				txt.Size = UDim2.new(1, -10, 0, 25)
				txt.Text = element.Name or ""
				txt.TextColor3 = Color3.fromRGB(255, 255, 255)
				txt.BackgroundTransparency = 1
				txt.Font = Enum.Font.GothamBold
				txt.TextSize = 18
				txt.Parent = tabFrame
			end
		end
	end

	-- Tabs logic (build tab buttons and their content containers)
	local activeTab = nil
	for _, tabData in ipairs(Tabs or {}) do
		local tabButton = Instance.new("TextButton")
		tabButton.Text = tabData.Name or "Tab"
		tabButton.Size = TabButtonConfig.DefaultSize or UDim2.new(1, -5, 0, 35)
		tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabButton.Font = Enum.Font.GothamBold
		tabButton.TextSize = 18
		tabButton.Parent = TabScroll
		Instance.new("UICorner", tabButton)

		local tabContent = Instance.new("ScrollingFrame")
		tabContent.Size = UDim2.new(1, 0, 1, 0)
		tabContent.Position = UDim2.new(0, 0, 0, 0)
		tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
		tabContent.ScrollBarThickness = 6
		tabContent.BackgroundTransparency = 1
		tabContent.Visible = false
		tabContent.Parent = ContentFrame

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 8)
		layout.Parent = tabContent

		for _, section in ipairs(tabData.Sections or {}) do
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

	-- Fullscreen / Close
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

-- Return callable module
return GUI
