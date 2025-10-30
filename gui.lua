-- gui.lua
-- Rynox Hub GUI module with local config save/load

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- Executor helpers
if not isfolder("RynoxHubConfigs") then
    makefolder("RynoxHubConfigs")
end

local GUI = {}
GUI.ToggleButtons = {}
local UserConfig = {}

-- Utility: Save config
local function saveConfig(name)
    local filepath = "RynoxHubConfigs/"..name..".json"
    writefile(filepath, HttpService:JSONEncode(UserConfig))
end

-- Utility: Load config
local function loadConfig(name)
    local filepath = "RynoxHubConfigs/"..name..".json"
    if isfile(filepath) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(filepath))
        end)
        if success and type(data) == "table" then
            for k,v in pairs(data) do
                UserConfig[k] = v
                if GUI.ToggleButtons[k] then
                    local tb = GUI.ToggleButtons[k]
                    tb.State = v
                    tb.Button.Text = k..": "..(v and "ON" or "OFF")
                    if tb.Func then
                        tb.Func(v)
                    end
                end
            end
        end
    end
end

-- GUI Creation
function GUI.Create(config)
    config = config or {}

    local GUIConfig = config.GUIConfig or { Size = UDim2.new(0, 500, 0, 320) }
    local TitleConfig = config.TitleConfig or { { Name = "Rynox Hub", Color = Color3.fromRGB(255,255,255), Size = UDim2.new(0,200,0,40), Position = UDim2.new(0,10,0,0) } }
    local TabsConfig = config.TabsConfig or {}
    local TabButtonConfig = config.TabButtonConfig or {}
    local MainFrameConfig = config.MainFrameConfig or {}
    local Tabs = config.Tabs or {}

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = config.GuiName or "RynoxHub"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = player:WaitForChild("PlayerGui")

    -- Main Frame
    local Frame = Instance.new("Frame")
    Frame.Size = GUIConfig.Size
    Frame.Position = UDim2.new(0.5, -Frame.Size.X.Offset / 2, 0.5, -Frame.Size.Y.Offset / 2)
    Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    Frame.BackgroundTransparency = 0.4
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,15)

    -- Title
    local TitleData = TitleConfig[1]
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

    -- Top buttons
    local function MakeTopButton(text, color, posX)
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

    -- Main Content
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = MainFrameConfig.Size or UDim2.new(1,-130,1,-60)
    ContentFrame.Position = MainFrameConfig.Position or UDim2.new(0,130,0,40)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = Frame

    -- Section creator
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
            if element.Type == "Button" then
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1,0,0,50)
                frame.BackgroundTransparency = 1
                frame.Parent = tabFrame

                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(0.7,-5,1,0)
                lbl.Position = UDim2.new(0,0,0,0)
                lbl.Text = element.Name
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.fromRGB(255,255,255)
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = 18
                lbl.Parent = frame

                if element.Mode == "On/Off" then
                    local toggle = Instance.new("TextButton")
                    toggle.Size = UDim2.new(0.3,-5,1,0)
                    toggle.Position = UDim2.new(0.7,5,0,0)
                    toggle.Text = "OFF"
                    toggle.BackgroundColor3 = Color3.fromRGB(100,0,0)
                    toggle.TextColor3 = Color3.fromRGB(255,255,255)
                    toggle.Font = Enum.Font.GothamBold
                    toggle.TextSize = 18
                    toggle.Parent = frame
                    Instance.new("UICorner", toggle)

                    -- track state
                    GUI.ToggleButtons[element.Name] = { Button = toggle, State = false, Func = element.Function }

                    toggle.MouseButton1Click:Connect(function()
                        local state = not GUI.ToggleButtons[element.Name].State
                        GUI.ToggleButtons[element.Name].State = state
                        toggle.Text = state and "ON" or "OFF"
                        toggle.BackgroundColor3 = state and Color3.fromRGB(0,150,0) or Color3.fromRGB(100,0,0)
                        -- call function with current state
                        if element.Function then
                            element.Function(state)
                        end
                        -- update user config
                        UserConfig[element.Name] = state
                    end)
                else
                    -- normal button
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1,0,1,0)
                    btn.Text = element.Name
                    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
                    btn.TextColor3 = Color3.fromRGB(255,255,255)
                    btn.Font = Enum.Font.GothamBold
                    btn.TextSize = 18
                    btn.Parent = frame
                    Instance.new("UICorner", btn)
                    btn.MouseButton1Click:Connect(function()
                        if element.Function then
                            element.Function()
                        end
                    end)
                end
            elseif element.Type == "Text" then
                local txt = Instance.new("TextLabel")
                txt.Size = UDim2.new(1,-10,0,25)
                txt.Text = element.Name
                txt.BackgroundTransparency = 1
                txt.TextColor3 = Color3.fromRGB(255,255,255)
                txt.Font = Enum.Font.GothamBold
                txt.TextSize = 18
                txt.Parent = tabFrame
            end
        end
    end

    -- Tabs
    local activeTab = nil
    for _, tabData in ipairs(Tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Text = tabData.Name
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
            if activeTab then
                activeTab.Visible = false
            end
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
