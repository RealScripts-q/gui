-- config.lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Fetch the GUI from GitHub
local guiModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/RealScripts-q/gui/refs/heads/main/gui.lua"))()
local TabsContent = guiModule.TabsContent
local TabButtons = guiModule.TabButtons -- for tab order if needed

--// ===== CONFIGURATION TABLES =====

-- Tabs order
local TabsOrder = {
	{ Name = "Main", Order = 1 },
	{ Name = "Info", Order = 2 },
}

-- Tabs & sections config
local Config = {
	["Main"] = {
		Sections = {
			["Main Section"] = {
				LayoutOrder = 1,
				Items = {
					{Type = "Button", Text = "TP Walk", Script = function() print("TP Walk toggled!") end},
					{Type = "Button", Text = "Fly", Script = function() print("Fly Script Loaded!") end},
					{Type = "Button", Text = "Infinite Jump", Script = function() print("Infinite Jump Activated!") end},
				}
			}
		}
	},
	["Info"] = {
		Sections = {
			["Info Section"] = {
				LayoutOrder = 1,
				Items = {
					{Type = "Text", Text = "Created by Rynox Team"},
				}
			}
		}
	}
}

-- Populate GUI in tab order
table.sort(TabsOrder, function(a,b) return a.Order < b.Order end)

for _, tabInfo in ipairs(TabsOrder) do
	local tabName = tabInfo.Name
	local tabData = Config[tabName]
	local tabFrame = TabsContent[tabName]
	if tabFrame and tabData then
		for sectionName, sectionData in pairs(tabData.Sections) do
			-- Create Section Frame
			local sectionFrame = Instance.new("Frame")
			sectionFrame.Size = UDim2.new(1, -20, 0, #sectionData.Items*50 + 10)
			sectionFrame.BackgroundTransparency = 1
			sectionFrame.LayoutOrder = sectionData.LayoutOrder
			sectionFrame.Parent = tabFrame
			tabFrame.Sections[sectionName] = sectionFrame

			local sectionLayout = Instance.new("UIListLayout")
			sectionLayout.Padding = UDim.new(0,5)
			sectionLayout.FillDirection = Enum.FillDirection.Vertical
			sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
			sectionLayout.Parent = sectionFrame

			-- Add items
			for idx, item in ipairs(sectionData.Items) do
				if item.Type == "Button" then
					local btn = Instance.new("TextButton")
					btn.Size = UDim2.new(1,0,0,45)
					btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
					btn.Text = item.Text
					btn.TextColor3 = Color3.fromRGB(255,255,255)
					btn.Font = Enum.Font.GothamBold
					btn.TextSize = 22
					btn.LayoutOrder = idx
					btn.Parent = sectionFrame
					Instance.new("UICorner", btn)

					btn.MouseButton1Click:Connect(function()
						if item.Script then
							item.Script()
						end
					end)

				elseif item.Type == "Text" then
					local lbl = Instance.new("TextLabel")
					lbl.Size = UDim2.new(1,0,0,45)
					lbl.BackgroundTransparency = 1
					lbl.Text = item.Text
					lbl.TextColor3 = Color3.fromRGB(255,255,255)
					lbl.Font = Enum.Font.GothamBold
					lbl.TextSize = 20
					lbl.TextXAlignment = Enum.TextXAlignment.Left
					lbl.LayoutOrder = idx
					lbl.Parent = sectionFrame
				end
			end
		end
	end
end
