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
Frame.Size = UDim2.new(0, 500, 0, 320)
Frame.Position = UDim2.new(0.5, -250, 0.5, -160)
Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Frame.BackgroundTransparency = 0.4
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,15)

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "Rynox Hub"
TitleLabel.Size = UDim2.new(0,200,0,40)
TitleLabel.Position = UDim2.new(0,10,0,0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 22
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Frame

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

local CloseBtn = MakeTopButton("X", Color3.fromRGB(50,0,0), -35)
local FullBtn = MakeTopButton("⛶", Color3.fromRGB(30,30,30), -70)

-- Tabs Panel
local TabScrollFrame = Instance.new("Frame")
TabScrollFrame.Size = UDim2.new(0,110,1,-60)
TabScrollFrame.Position = UDim2.new(0,0,0,40)
TabScrollFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
TabScrollFrame.BackgroundTransparency = 0.3
TabScrollFrame.Parent = Frame
Instance.new("UICorner", TabScrollFrame)

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Size = UDim2.new(1,0,1,0)
TabScroll.CanvasSize = UDim2.new(0,0,0,0)
TabScroll.ScrollBarThickness = 4
TabScroll.BackgroundTransparency = 1
TabScroll.Parent = TabScrollFrame

local UIListLayoutTabs = Instance.new("UIListLayout")
UIListLayoutTabs.Padding = UDim.new(0,5)
UIListLayoutTabs.Parent = TabScroll

-- Container for tab contents
local TabsContent = {}
local TabButtonsList = {}

local function CreateTabContent(tabName)
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1,-130,1,-60)
    contentFrame.Position = UDim2.new(0,130,0,40)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = false
    contentFrame.Parent = Frame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,10)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = contentFrame

    contentFrame.Sections = {} 
    TabsContent[tabName] = contentFrame
    return contentFrame
end

-- Default Tabs
local defaultTabs = {"Main","Info"}
local firstTabButton

for i, tabName in ipairs(defaultTabs) do
    local content = CreateTabContent(tabName)

    local TabButton = Instance.new("TextButton")
    TabButton.Text = tabName
    TabButton.Size = UDim2.new(1,-5,0,35)
    TabButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
    TabButton.TextColor3 = Color3.fromRGB(255,255,255)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 18
    TabButton.Parent = TabScroll
    Instance.new("UICorner", TabButton)

    TabButton.MouseButton1Click:Connect(function()
        for _, f in pairs(TabsContent) do
            f.Visible = false
        end
        for _, btn in ipairs(TabButtonsList) do
            btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        end

        content.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
    end)

    table.insert(TabButtonsList, TabButton)

    if i == 1 then
        firstTabButton = TabButton
    end
end

UIListLayoutTabs:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabScroll.CanvasSize = UDim2.new(0,0,0,UIListLayoutTabs.AbsoluteContentSize.Y+10)
end)

-- Show first tab by default
if firstTabButton then
    firstTabButton:Activate()
end

-- Bottom Section
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
task.spawn(function()
    local txt = "Welcome, "..player.DisplayName
    Welcome.Text = ""
    for i=1,#txt do
        Welcome.Text = string.sub(txt,1,i)
        task.wait(0.05)
    end
end)

-- Fullscreen & Close functionality
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

return {
    TabsContent = TabsContent,
    ScreenGui = ScreenGui
}
