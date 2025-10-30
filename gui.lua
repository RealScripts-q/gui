-- GUI.lua
-- This script is meant to be hosted on GitHub as raw content

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RynoxHub"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 500, 0, 320) -- default, will be updated by config
Frame.Position = UDim2.new(0.5, -250, 0.5, -160)
Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Frame.BackgroundTransparency = 0.4
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 15)

-- Title Label
local Title = Instance.new("TextLabel")
Title.Text = "Rynox Hub" -- default, will be updated
Title.Size = UDim2.new(0, 200, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Frame

-- Tabs Panel
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(0, 110, 1, -60)
TabFrame.Position = UDim2.new(0, 0, 0, 40)
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

-- Content Frames
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, -130, 1, -60)
MainFrame.Position = UDim2.new(0, 130, 0, 40)
MainFrame.BackgroundTransparency = 1
MainFrame.Parent = Frame

local MainListLayout = Instance.new("UIListLayout")
MainListLayout.Padding = UDim.new(0,10)
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
InfoLabel.TextColor3 = Color3.fromRGB(255,255,255)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.TextSize = 22
InfoLabel.Parent = InfoFrame

-- Bottom Section (Avatar + Welcome)
local BottomFrame = Instance.new("Frame")
BottomFrame.Size = UDim2.new(1,0,0,50)
BottomFrame.Position = UDim2.new(0,0,1,-50)
BottomFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
BottomFrame.BackgroundTransparency = 0.25
BottomFrame.Parent = Frame
Instance.new("UICorner", BottomFrame).CornerRadius = UDim.new(0,12)

local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0,40,0,40)
Avatar.Position = UDim2.new(0,10,0.5,-20)
Avatar.BackgroundTransparency = 1
local ok, thumb = pcall(function()
    return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)
if ok then Avatar.Image = thumb end
Avatar.Parent = BottomFrame
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1,0)

local Welcome = Instance.new("TextLabel")
Welcome.Size = UDim2.new(1,-60,1,0)
Welcome.Position = UDim2.new(0,60,0,0)
Welcome.BackgroundTransparency = 1
Welcome.TextColor3 = Color3.fromRGB(255,255,255)
Welcome.Font = Enum.Font.GothamBold
Welcome.TextSize = 20
Welcome.TextXAlignment = Enum.TextXAlignment.Left
Welcome.Parent = BottomFrame

-- Export GUI objects for config to use
return {
    ScreenGui = ScreenGui,
    Frame = Frame,
    MainFrame = MainFrame,
    InfoFrame = InfoFrame,
    InfoLabel = InfoLabel,
    TabScroll = TabScroll,
    Welcome = Welcome
}
