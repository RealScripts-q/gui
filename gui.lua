-- gui.lua
-- Rynox Hub GUI module with improved local config save/load system

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

if not isfolder("RynoxHubConfigs") then
    makefolder("RynoxHubConfigs")
end

local GUI = {}
GUI.ToggleButtons = {}
local UserConfig = {}

-- Save config helper
local function saveConfig(name)
    local path = "RynoxHubConfigs/"..name..".json"
    writefile(path, HttpService:JSONEncode(UserConfig))
end

-- Load config helper
local function loadConfig(name)
    local path = "RynoxHubConfigs/"..name..".json"
    if isfile(path) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(path))
        end)
        if success and type(data) == "table" then
            for k,v in pairs(data) do
                UserConfig[k] = v
                if GUI.ToggleButtons[k] then
                    local tb = GUI.ToggleButtons[k]
                    tb.State = v
                    tb.Button.Text = k..": "..(v and "ON" or "OFF")
                    tb.Button.BackgroundColor3 = v and Color3.fromRGB(0,150,0) or Color3.fromRGB(100,0,0)
                    if tb.Func then tb.Func(v) end
                end
            end
        end
    end
end

function GUI.Create(config)
    config = config or {}

    local GUIConfig = config.GUIConfig or { Size = UDim2.new(0,500,0,320) }
    local TitleConfig = config.TitleConfig or { { Name = "Rynox Hub", Color = Color3.fromRGB(255,255,255), Size = UDim2.new(0,200,0,40), Position = UDim2.new(0,10,0,0) } }
    local TabsConfig = config.TabsConfig or {}
    local TabButtonConfig = config.TabButtonConfig or {}
    local MainFrameConfig = config.MainFrameConfig or {}
    local Tabs = config.Tabs or {}

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = config.GuiName or "RynoxHub"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = player:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = GUIConfig.Size
    Frame.Position = UDim2.new(0.5,-Frame.Size.X.Offset/2,0.5,-Frame.Size.Y.Offset/2)
    Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    Frame.BackgroundTransparency = 0.4
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,15)

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

    -- Tabs panel
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

    -- Content
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = MainFrameConfig.Size or UDim2.new(1,-130,1,-60)
    ContentFrame.Position = MainFrameConfig.Position or UDim2.new(0,130,0,40)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = Frame

    -- Create section helper
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

                    GUI.ToggleButtons[element.Name] = { Button = toggle, State = false, Func = element.Function }

                    toggle.MouseButton1Click:Connect(function()
                        local state = not GUI.ToggleButtons[element.Name].State
                        GUI.ToggleButtons[element.Name].State = state
                        toggle.Text = state and "ON" or "OFF"
                        toggle.BackgroundColor3 = state and Color3.fromRGB(0,150,0) or Color3.fromRGB(100,0,0)
                        if element.Function then element.Function(state) end
                        UserConfig[element.Name] = state
                    end)
                else
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
                        if element.Function then element.Function() end
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

        -- Add sections
        for _, section in ipairs(tabData.Sections or {}) do
            CreateSection(tabContent, section)
        end

        -- Special: Settings tab save/load logic
        if tabData.Name == "Settings" then
            local function refreshLoadButtons()
                local existing = tabContent:FindFirstChild("LoadButtonsFrame")
                if existing then existing:Destroy() end

                local loadFrame = Instance.new("Frame")
                loadFrame.Name = "LoadButtonsFrame"
                loadFrame.Size = UDim2.new(1,0,0,50)
                loadFrame.BackgroundTransparency = 1
                loadFrame.Parent = tabContent
                loadFrame.Position = UDim2.new(0,0,0,200)

                if isfolder("RynoxHubConfigs") then
                    local files = listfiles("RynoxHubConfigs")
                    for i, file in ipairs(files) do
                        local filename = file:match("([^/\\]+)%.json$")
                        local btn = Instance.new("TextButton")
                        btn.Size = UDim2.new(1,0,0,25)
                        btn.Position = UDim2.new(0,0,0,(i-1)*30)
                        btn.Text = filename
                        btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
                        btn.TextColor3 = Color3.fromRGB(255,255,255)
                        btn.Font = Enum.Font.GothamBold
                        btn.TextSize = 16
                        btn.Parent = loadFrame
                        Instance.new("UICorner", btn)
                        btn.MouseButton1Click:Connect(function()
                            loadConfig(filename)
                        end)
                    end
                end
            end

            -- Create textbox & save button dynamically
            for _, elem in ipairs(tabData.Sections[1].Elements) do
                if elem.Name == "Save Config" then
                    local saveBtn = GUI.ToggleButtons[elem.Name] and GUI.ToggleButtons[elem.Name].Button or nil
                    if saveBtn then
                        saveBtn.MouseButton1Click:Connect(function()
                            local txtBox = Instance.new("TextBox")
                            txtBox.PlaceholderText = "Config Name"
                            txtBox.Size = UDim2.new(1,0,0,25)
                            txtBox.Position = UDim2.new(0,0,0,55)
                            txtBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
                            txtBox.TextColor3 = Color3.fromRGB(255,255,255)
                            txtBox.Font = Enum.Font.GothamBold
                            txtBox.TextSize = 16
                            txtBox.Parent = tabContent
                            Instance.new("UICorner", txtBox)

                            local confirmBtn = Instance.new("TextButton")
                            confirmBtn.Size = UDim2.new(0.3,0,0,25)
                            confirmBtn.Position = UDim2.new(0.35,0,0,85)
                            confirmBtn.Text = "Save"
                            confirmBtn.BackgroundColor3 = Color3.fromRGB(0,150,0)
                            confirmBtn.TextColor3 = Color3.fromRGB(255,255,255)
                            confirmBtn.Font = Enum.Font.GothamBold
                            confirmBtn.TextSize = 16
                            confirmBtn.Parent = tabContent
                            Instance.new("UICorner", confirmBtn)

                            confirmBtn.MouseButton1Click:Connect(function()
                                if txtBox.Text ~= "" then
                                    saveConfig(txtBox.Text)
                                    txtBox:Destroy()
                                    confirmBtn:Destroy()
                                    refreshLoadButtons()
                                end
                            end)
                        end)
                    end
                elseif elem.Name == "Load Config" then
                    refreshLoadButtons()
                end
            end
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

    return ScreenGui
end

return GUI
