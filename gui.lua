-- gui.lua
local GUIBuilder = {}

function GUIBuilder.CreateGUI(Config)
	local player = game:GetService("Players").LocalPlayer
	local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	ScreenGui.Name = "RynoxHub"

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
	Title.Size = UDim2.new(1, 0, 0, 40)
	Title.BackgroundTransparency = 1
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 22
	Title.Parent = Frame

	-- Build Tabs
	local TabFrame = Instance.new("Frame")
	TabFrame.Size = UDim2.new(0, 120, 1, -40)
	TabFrame.Position = UDim2.new(0, 0, 0, 40)
	TabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	TabFrame.Parent = Frame
	Instance.new("UICorner", TabFrame)

	local TabScroll = Instance.new("ScrollingFrame")
	TabScroll.Size = UDim2.new(1, 0, 1, 0)
	TabScroll.BackgroundTransparency = 1
	TabScroll.ScrollBarThickness = 4
	TabScroll.Parent = TabFrame
	local UIList = Instance.new("UIListLayout", TabScroll)
	UIList.Padding = UDim.new(0, 5)

	local ContentFrame = Instance.new("Frame")
	ContentFrame.Size = UDim2.new(1, -130, 1, -40)
	ContentFrame.Position = UDim2.new(0, 130, 0, 40)
	ContentFrame.BackgroundTransparency = 1
	ContentFrame.Parent = Frame

	-- Build tabs from config
	local activeTab
	for _, tab in ipairs(Config.Tabs) do
		local TabButton = Instance.new("TextButton")
		TabButton.Text = tab.Name
		TabButton.Size = UDim2.new(1, -5, 0, 30)
		TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabButton.Font = Enum.Font.GothamBold
		TabButton.TextSize = 18
		TabButton.Parent = TabScroll
		Instance.new("UICorner", TabButton)

		local TabContent = Instance.new("ScrollingFrame")
		TabContent.Size = UDim2.new(1, 0, 1, 0)
		TabContent.BackgroundTransparency = 1
		TabContent.Visible = false
		TabContent.Parent = ContentFrame
		local layout = Instance.new("UIListLayout", TabContent)
		layout.Padding = UDim.new(0, 8)

		for _, section in ipairs(tab.Sections) do
			local Label = Instance.new("TextLabel")
			Label.Text = "-- " .. section.Name .. " --"
			Label.Size = UDim2.new(1, -10, 0, 25)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.Font = Enum.Font.GothamBold
			Label.TextSize = 20
			Label.Parent = TabContent

			for _, element in ipairs(section.Elements) do
				if element.Type == "Button" then
					local Btn = Instance.new("TextButton")
					Btn.Text = element.Name
					Btn.Size = UDim2.new(0, 180, 0, 40)
					Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
					Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
					Btn.Font = Enum.Font.GothamBold
					Btn.TextSize = 18
					Btn.Parent = TabContent
					Instance.new("UICorner", Btn)
					Btn.MouseButton1Click:Connect(function()
						if element.Function then
							element.Function(Btn)
						end
					end)
				elseif element.Type == "Text" then
					local Txt = Instance.new("TextLabel")
					Txt.Text = element.Name
					Txt.Size = UDim2.new(1, -10, 0, 25)
					Txt.BackgroundTransparency = 1
					Txt.TextColor3 = Color3.fromRGB(200, 200, 200)
					Txt.Font = Enum.Font.Gotham
					Txt.TextSize = 18
					Txt.Parent = TabContent
				end
			end
		end

		TabButton.MouseButton1Click:Connect(function()
			if activeTab then activeTab.Visible = false end
			activeTab = TabContent
			TabContent.Visible = true
		end)
	end
end

return GUIBuilder
