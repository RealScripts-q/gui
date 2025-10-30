--// gui.lua - Universal GUI Builder by RealScripts-q

local GUI = {}

-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Title Bar
local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.Text = "RealScripts-q GUI"
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 16
TitleBar.Parent = MainFrame

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 120, 1, -30)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 4)
TabList.FillDirection = Enum.FillDirection.Vertical
TabList.Parent = TabContainer

-- Content Area
local ContentArea = Instance.new("ScrollingFrame")
ContentArea.Size = UDim2.new(1, -120, 1, -30)
ContentArea.Position = UDim2.new(0, 120, 0, 30)
ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentArea.ScrollBarThickness = 6
ContentArea.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

local ContentList = Instance.new("UIListLayout")
ContentList.Padding = UDim.new(0, 6)
ContentList.FillDirection = Enum.FillDirection.Vertical
ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Left
ContentList.Parent = ContentArea

-- Function to clear the content area
local function ClearContent()
	for _, obj in ipairs(ContentArea:GetChildren()) do
		if not obj:IsA("UIListLayout") then
			obj:Destroy()
		end
	end
end

-- Function to create a section label
local function CreateSection(name)
	local SectionLabel = Instance.new("TextLabel")
	SectionLabel.Size = UDim2.new(1, -10, 0, 25)
	SectionLabel.BackgroundTransparency = 1
	SectionLabel.Text = "Section: " .. tostring(name)
	SectionLabel.TextColor3 = Color3.new(1, 1, 1)
	SectionLabel.Font = Enum.Font.GothamBold
	SectionLabel.TextSize = 14
	SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
	SectionLabel.Parent = ContentArea
end

-- Function to create a button element
local function CreateButton(element)
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1, -20, 0, 30)
	Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Button.TextColor3 = Color3.new(1, 1, 1)
	Button.Font = Enum.Font.Gotham
	Button.TextSize = 14
	Button.Text = element.Name or "Unnamed Button"
	Button.Parent = ContentArea
	Button.MouseButton1Click:Connect(function()
		if element.Function then
			pcall(element.Function)
		end
	end)
end

-- Function to create a text label
local function CreateText(element)
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -20, 0, 25)
	Label.BackgroundTransparency = 1
	Label.Text = "Text: " .. tostring(element.Name)
	Label.TextColor3 = Color3.fromRGB(200, 200, 200)
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = ContentArea
end

-- Core builder
function GUI:Load(Config)
	for _, tab in ipairs(Config.Tabs or {}) do
		local TabButton = Instance.new("TextButton")
		TabButton.Size = UDim2.new(1, 0, 0, 30)
		TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		TabButton.TextColor3 = Color3.new(1, 1, 1)
		TabButton.Font = Enum.Font.Gotham
		TabButton.TextSize = 14
		TabButton.Text = tab.Name or "Tab"
		TabButton.Parent = TabContainer

		-- When a tab is clicked, build its sections and elements
		TabButton.MouseButton1Click:Connect(function()
			ClearContent()
			for _, section in ipairs(tab.Sections or {}) do
				CreateSection(section.Name or "Unnamed Section")
				for _, element in ipairs(section.Elements or {}) do
					if element.Type == "Button" then
						CreateButton(element)
					elseif element.Type == "Text" then
						CreateText(element)
					end
				end
			end
		end)
	end
end

return GUI
