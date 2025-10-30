-- Rynox Hub GUI module (supports On/Off toggles next to element names)

--// Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Compatibility shims -------------------------------------------------------
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
-----------------------------------------------------------------------------

local GUI = {}

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
    Frame.Position = UDim2.new(0.5, -Frame.Size.X.Offset/2, 0.5, -Frame.Size.Y.Offset/2)
    Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    Frame.BackgroundTransparency = 0.4
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 15)

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
        Instance.new("UICorner",btn)
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

    -- Main Content Area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = MainFrameConfig.Size or UDim2.new(1,-130,1,-60)
    ContentFrame.Position = MainFrameConfig.Position or UDim2.new(0,130,0,40)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = Frame

    -- Helper to execute safely
    local function safeExecute(fn,...)
        local ok, err = pcall(fn,...)
        if not ok then warn("[RynoxHub] Element error: "..tostring(err)) end
    end

    -- Function to create sections
    local function CreateSection(tabFrame, sectionData)
        local sectionLabel = Instance.new("TextLabel")
        sectionLabel.Size = UDim2.new(1,-10,0,25)
        sectionLabel.Text = "-- "..(sectionData.Name or "Section").." --"
        sectionLabel.TextColor3 = Color3.fromRGB(255,255,255)
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Font = Enum.Font.GothamBold
        sectionLabel.TextSize = 20
        sectionLabel.Parent = tabFrame

        for _,element in ipairs(sectionData.Elements or {}) do
            if element.Type == "Button" then
                -- Container for label + toggle
                local container = Instance.new("Frame")
                container.Size = UDim2.new(1,0,0,45)
                container.BackgroundTransparency = 1
                container.Parent = tabFrame

                -- Name label
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(0.7,-5,1,0)
                nameLabel.Position = UDim2.new(0,0,0,0)
                nameLabel.Text = element.Name or "Button"
                nameLabel.BackgroundTransparency = 1
                nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextSize = 20
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.Parent = container

                if element.Mode == "On/Off" then
                    local toggleBtn = Instance.new("TextButton")
                    toggleBtn.Size = UDim2.new(0.3,-5,1,0)
                    toggleBtn.Position = UDim2.new(0.7,0,0,0)
                    toggleBtn.Text = "OFF"
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
                    toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
                    toggleBtn.Font = Enum.Font.GothamBold
                    toggleBtn.TextSize = 18
                    toggleBtn.Parent = container
                    Instance.new("UICorner", toggleBtn)

                    local state = false
                    local cleanupFunc = nil

                    toggleBtn.MouseButton1Click:Connect(function()
                        state = not state
                        toggleBtn.Text = state and "ON" or "OFF"
                        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0,180,0) or Color3.fromRGB(50,50,50)

                        if type(element.Function) == "function" then
                            if not state and cleanupFunc then
                                pcall(cleanupFunc)
                                cleanupFunc = nil
                            end
                            if state then
                                local ok,result = pcall(element.Function)
                                if ok and type(result) == "function" then
                                    cleanupFunc = result
                                end
                            end
                        end
                    end)
                else
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1,0,1,0)
                    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
                    btn.Text = element.Name or "Button"
                    btn.TextColor3 = Color3.fromRGB(255,255,255)
                    btn.Font = Enum.Font.GothamBold
                    btn.TextSize = 20
                    btn.Parent = container
                    Instance.new("UICorner", btn)

                    btn.MouseButton1Click:Connect(function()
                        task.spawn(function()
                            safeExecute(element.Function, btn)
                        end)
                    end)
                end
            elseif element.Type == "Text" then
                local txt = Instance.new("TextLabel")
                txt.Size = UDim2.new(1,-10,0,25)
                txt.Text = element.Name or ""
                txt.TextColor3 = Color3.fromRGB(255,255,255)
                txt.BackgroundTransparency = 1
                txt.Font = Enum.Font.GothamBold
                txt.TextSize = 18
                txt.Parent = tabFrame
            end
        end
    end

    -- Tabs
    local activeTab = nil
    for _,tabData in ipairs(Tabs or {}) do
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

        for _,section in ipairs(tabData.Sections or {}) do
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
