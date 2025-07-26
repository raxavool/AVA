-- ʌVʌ UI Library for Roblox
-- Modern, customizable UI library with nested tabs and module system

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- UI Library Class
local AVA = {}
AVA.__index = AVA

-- Default Settings
local defaultSettings = {
    blur = true,
    detectable = false,
    smoothDragging = true,
    mobileSupport = true,
    themeColor = Color3.fromRGB(138, 43, 226), -- Purple theme
    arrayList = true
}

function AVA.new(title)
    local self = setmetatable({}, AVA)
    
    self.title = title or "ʌVʌ"
    self.settings = defaultSettings
    self.tabs = {}
    self.modules = {}
    self.activeModules = {}
    
    self:CreateMainGui()
    self:CreateArrayList()
    self:SetupDragging()
    
    return self
end

function AVA:CreateMainGui()
    -- Main ScreenGui
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "AVA_UI"
    self.screenGui.Parent = PlayerGui
    self.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Blur Effect
    self.blurEffect = Instance.new("BlurEffect")
    self.blurEffect.Size = 0
    self.blurEffect.Parent = game.Lighting
    
    -- Main Frame
    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Name = "MainFrame"
    self.mainFrame.Size = UDim2.new(0, 800, 0, 600)
    self.mainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
    self.mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    self.mainFrame.BackgroundTransparency = 0.05
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.ClipsDescendants = true
    self.mainFrame.Parent = self.screenGui
    
    -- UI Corner for main frame
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = self.mainFrame
    
    -- Border glow effect
    local borderFrame = Instance.new("Frame")
    borderFrame.Name = "Border"
    borderFrame.Size = UDim2.new(1, 2, 1, 2)
    borderFrame.Position = UDim2.new(0, -1, 0, -1)
    borderFrame.BackgroundTransparency = 1
    borderFrame.Parent = self.mainFrame
    
    local borderGradient = Instance.new("UIStroke")
    borderGradient.Color = self.settings.themeColor
    borderGradient.Thickness = 1
    borderGradient.Transparency = 0.7
    borderGradient.Parent = self.mainFrame
    
    -- Header
    self.header = Instance.new("Frame")
    self.header.Name = "Header"
    self.header.Size = UDim2.new(1, 0, 0, 50)
    self.header.Position = UDim2.new(0, 0, 0, 0)
    self.header.BackgroundColor3 = self.settings.themeColor
    self.header.BorderSizePixel = 0
    self.header.Parent = self.mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = self.header
    
    -- Header gradient
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, self.settings.themeColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(153, 50, 204))
    }
    headerGradient.Rotation = 90
    headerGradient.Parent = self.header
    
    -- Title Label
    self.titleLabel = Instance.new("TextLabel")
    self.titleLabel.Name = "Title"
    self.titleLabel.Size = UDim2.new(1, -100, 1, 0)
    self.titleLabel.Position = UDim2.new(0, 20, 0, 0)
    self.titleLabel.BackgroundTransparency = 1
    self.titleLabel.Text = self.title
    self.titleLabel.TextColor3 = Color3.new(1, 1, 1)
    self.titleLabel.TextSize = 24
    self.titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.titleLabel.Font = Enum.Font.GothamBold
    self.titleLabel.Parent = self.header
    
    -- Close Button
    self.closeButton = Instance.new("TextButton")
    self.closeButton.Name = "CloseButton"
    self.closeButton.Size = UDim2.new(0, 30, 0, 30)
    self.closeButton.Position = UDim2.new(1, -40, 0, 10)
    self.closeButton.BackgroundColor3 = Color3.fromRGB(255, 68, 68)
    self.closeButton.Text = "×"
    self.closeButton.TextColor3 = Color3.new(1, 1, 1)
    self.closeButton.TextSize = 18
    self.closeButton.Font = Enum.Font.GothamBold
    self.closeButton.BorderSizePixel = 0
    self.closeButton.Parent = self.header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = self.closeButton
    
    -- Minimize Button
    self.minimizeButton = Instance.new("TextButton")
    self.minimizeButton.Name = "MinimizeButton"
    self.minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    self.minimizeButton.Position = UDim2.new(1, -75, 0, 10)
    self.minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    self.minimizeButton.Text = "–"
    self.minimizeButton.TextColor3 = Color3.new(1, 1, 1)
    self.minimizeButton.TextSize = 18
    self.minimizeButton.Font = Enum.Font.GothamBold
    self.minimizeButton.BorderSizePixel = 0
    self.minimizeButton.Parent = self.header
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 6)
    minimizeCorner.Parent = self.minimizeButton
    
    -- Content Area
    self.contentFrame = Instance.new("Frame")
    self.contentFrame.Name = "Content"
    self.contentFrame.Size = UDim2.new(1, 0, 1, -50)
    self.contentFrame.Position = UDim2.new(0, 0, 0, 50)
    self.contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
    self.contentFrame.BackgroundTransparency = 0.2
    self.contentFrame.BorderSizePixel = 0
    self.contentFrame.Parent = self.mainFrame
    
    -- Tab Sidebar
    self.tabSidebar = Instance.new("Frame")
    self.tabSidebar.Name = "TabSidebar"
    self.tabSidebar.Size = UDim2.new(0, 200, 1, 0)
    self.tabSidebar.Position = UDim2.new(0, 0, 0, 0)
    self.tabSidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
    self.tabSidebar.BackgroundTransparency = 0.3
    self.tabSidebar.BorderSizePixel = 0
    self.tabSidebar.Parent = self.contentFrame
    
    -- Tab Container
    self.tabContainer = Instance.new("ScrollingFrame")
    self.tabContainer.Name = "TabContainer"
    self.tabContainer.Size = UDim2.new(1, 0, 1, 0)
    self.tabContainer.Position = UDim2.new(0, 0, 0, 0)
    self.tabContainer.BackgroundTransparency = 1
    self.tabContainer.BorderSizePixel = 0
    self.tabContainer.ScrollBarThickness = 6
    self.tabContainer.ScrollBarImageColor3 = self.settings.themeColor
    self.tabContainer.Parent = self.tabSidebar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 2)
    tabLayout.Parent = self.tabContainer
    
    -- Main Content Area
    self.mainContent = Instance.new("Frame")
    self.mainContent.Name = "MainContent"
    self.mainContent.Size = UDim2.new(1, -200, 1, 0)
    self.mainContent.Position = UDim2.new(0, 200, 0, 0)
    self.mainContent.BackgroundTransparency = 1
    self.mainContent.Parent = self.contentFrame
    
    -- Setup button events
    self:SetupButtonEvents()
    
    -- Hide initially
    self.mainFrame.Visible = false
end

function AVA:CreateArrayList()
    -- Array List Frame
    self.arrayFrame = Instance.new("Frame")
    self.arrayFrame.Name = "ArrayList"
    self.arrayFrame.Size = UDim2.new(0, 250, 0, 400)
    self.arrayFrame.Position = UDim2.new(1, -260, 0, 10)
    self.arrayFrame.BackgroundTransparency = 1
    self.arrayFrame.Parent = self.screenGui
    
    -- Array List Title
    local arrayTitle = Instance.new("TextLabel")
    arrayTitle.Name = "ArrayTitle"
    arrayTitle.Size = UDim2.new(1, 0, 0, 30)
    arrayTitle.Position = UDim2.new(0, 0, 0, 0)
    arrayTitle.BackgroundColor3 = self.settings.themeColor
    arrayTitle.Text = "ʌVʌ"
    arrayTitle.TextColor3 = Color3.new(1, 1, 1)
    arrayTitle.TextSize = 18
    arrayTitle.Font = Enum.Font.GothamBold
    arrayTitle.BorderSizePixel = 0
    arrayTitle.Parent = self.arrayFrame
    
    local arrayTitleCorner = Instance.new("UICorner")
    arrayTitleCorner.CornerRadius = UDim.new(0, 6)
    arrayTitleCorner.Parent = arrayTitle
    
    -- Array List Container
    self.arrayContainer = Instance.new("ScrollingFrame")
    self.arrayContainer.Name = "ArrayContainer"
    self.arrayContainer.Size = UDim2.new(1, 0, 1, -35)
    self.arrayContainer.Position = UDim2.new(0, 0, 0, 35)
    self.arrayContainer.BackgroundTransparency = 1
    self.arrayContainer.BorderSizePixel = 0
    self.arrayContainer.ScrollBarThickness = 4
    self.arrayContainer.ScrollBarImageColor3 = self.settings.themeColor
    self.arrayContainer.Parent = self.arrayFrame
    
    local arrayLayout = Instance.new("UIListLayout")
    arrayLayout.SortOrder = Enum.SortOrder.LayoutOrder
    arrayLayout.Padding = UDim.new(0, 2)
    arrayLayout.Parent = self.arrayContainer
end

function AVA:CreateTab(name, icon)
    local tab = {
        name = name,
        icon = icon or "🔹",
        subTabs = {},
        active = false,
        frame = nil,
        button = nil
    }
    
    -- Create tab button
    tab.button = Instance.new("TextButton")
    tab.button.Name = name .. "Tab"
    tab.button.Size = UDim2.new(1, -10, 0, 40)
    tab.button.Position = UDim2.new(0, 5, 0, 0)
    tab.button.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    tab.button.BackgroundTransparency = 0.3
    tab.button.Text = tab.icon .. " " .. name
    tab.button.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    tab.button.TextSize = 14
    tab.button.Font = Enum.Font.Gotham
    tab.button.BorderSizePixel = 0
    tab.button.TextXAlignment = Enum.TextXAlignment.Left
    tab.button.Parent = self.tabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tab.button
    
    -- Create tab content frame
    tab.frame = Instance.new("Frame")
    tab.frame.Name = name .. "Content"
    tab.frame.Size = UDim2.new(1, 0, 1, 0)
    tab.frame.Position = UDim2.new(0, 0, 0, 0)
    tab.frame.BackgroundTransparency = 1
    tab.frame.Visible = false
    tab.frame.Parent = self.mainContent
    
    -- Tab click event
    tab.button.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)
    
    table.insert(self.tabs, tab)
    self:UpdateTabLayout()
    
    return self:CreateTabInterface(tab)
end

function AVA:CreateTabInterface(tab)
    local interface = {}
    
    function interface:CreateSubTab(name, icon)
        local subTab = {
            name = name,
            icon = icon or "▶",
            modules = {},
            frame = nil,
            button = nil
        }
        
        -- Create subtab header if first subtab
        if #tab.subTabs == 0 then
            local subTabContainer = Instance.new("Frame")
            subTabContainer.Name = "SubTabContainer"
            subTabContainer.Size = UDim2.new(1, 0, 0, 50)
            subTabContainer.Position = UDim2.new(0, 0, 0, 0)
            subTabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
            subTabContainer.BorderSizePixel = 0
            subTabContainer.Parent = tab.frame
            
            local subTabLayout = Instance.new("UIListLayout")
            subTabLayout.FillDirection = Enum.FillDirection.Horizontal
            subTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
            subTabLayout.Padding = UDim.new(0, 5)
            subTabLayout.Parent = subTabContainer
        end
        
        -- Create subtab button
        subTab.button = Instance.new("TextButton")
        subTab.button.Name = name .. "SubTab"
        subTab.button.Size = UDim2.new(0, 120, 1, -10)
        subTab.button.Position = UDim2.new(0, 5, 0, 5)
        subTab.button.BackgroundColor3 = self.settings.themeColor
        subTab.button.BackgroundTransparency = 0.7
        subTab.button.Text = subTab.icon .. " " .. name
        subTab.button.TextColor3 = Color3.new(1, 1, 1)
        subTab.button.TextSize = 12
        subTab.button.Font = Enum.Font.Gotham
        subTab.button.BorderSizePixel = 0
        subTab.button.Parent = tab.frame:FindFirstChild("SubTabContainer")
        
        local subTabCorner = Instance.new("UICorner")
        subTabCorner.CornerRadius = UDim.new(0, 6)
        subTabCorner.Parent = subTab.button
        
        -- Create subtab content
        subTab.frame = Instance.new("ScrollingFrame")
        subTab.frame.Name = name .. "SubContent"
        subTab.frame.Size = UDim2.new(1, -20, 1, -60)
        subTab.frame.Position = UDim2.new(0, 10, 0, 55)
        subTab.frame.BackgroundTransparency = 1
        subTab.frame.BorderSizePixel = 0
        subTab.frame.ScrollBarThickness = 6
        subTab.frame.ScrollBarImageColor3 = self.settings.themeColor
        subTab.frame.Visible = false
        subTab.frame.Parent = tab.frame
        
        local moduleLayout = Instance.new("UIListLayout")
        moduleLayout.SortOrder = Enum.SortOrder.LayoutOrder
        moduleLayout.Padding = UDim.new(0, 5)
        moduleLayout.Parent = subTab.frame
        
        -- SubTab click event
        subTab.button.MouseButton1Click:Connect(function()
            self:SelectSubTab(tab.name, name)
        end)
        
        table.insert(tab.subTabs, subTab)
        
        return self:CreateSubTabInterface(tab, subTab)
    end
    
    return interface
end

function AVA:CreateSubTabInterface(tab, subTab)
    local interface = {}
    
    function interface:CreateModule(name, description, defaultState)
        local module = {
            name = name,
            description = description or "No description provided",
            enabled = defaultState or false,
            settings = {},
            frame = nil,
            toggle = nil,
            dropdown = nil,
            expanded = false
        }
        
        -- Create module frame
        module.frame = Instance.new("Frame")
        module.frame.Name = name .. "Module"
        module.frame.Size = UDim2.new(1, 0, 0, 50)
        module.frame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        module.frame.BackgroundTransparency = 0.3
        module.frame.BorderSizePixel = 0
        module.frame.Parent = subTab.frame
        
        local moduleCorner = Instance.new("UICorner")
        moduleCorner.CornerRadius = UDim.new(0, 8)
        moduleCorner.Parent = module.frame
        
        -- Module header
        local moduleHeader = Instance.new("Frame")
        moduleHeader.Name = "Header"
        moduleHeader.Size = UDim2.new(1, 0, 0, 50)
        moduleHeader.BackgroundTransparency = 1
        moduleHeader.Parent = module.frame
        
        -- Module name label
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Size = UDim2.new(1, -120, 1, 0)
        nameLabel.Position = UDim2.new(0, 15, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextSize = 16
        nameLabel.Font = Enum.Font.GothamSemibold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = moduleHeader
        
        -- Toggle switch
        module.toggle = Instance.new("TextButton")
        module.toggle.Name = "Toggle"
        module.toggle.Size = UDim2.new(0, 50, 0, 25)
        module.toggle.Position = UDim2.new(1, -90, 0.5, -12.5)
        module.toggle.BackgroundColor3 = module.enabled and self.settings.themeColor or Color3.fromRGB(60, 60, 80)
        module.toggle.Text = ""
        module.toggle.BorderSizePixel = 0
        module.toggle.Parent = moduleHeader
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 12)
        toggleCorner.Parent = module.toggle
        
        -- Toggle indicator
        local toggleIndicator = Instance.new("Frame")
        toggleIndicator.Name = "Indicator"
        toggleIndicator.Size = UDim2.new(0, 21, 0, 21)
        toggleIndicator.Position = module.enabled and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
        toggleIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
        toggleIndicator.BorderSizePixel = 0
        toggleIndicator.Parent = module.toggle
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(0, 10)
        indicatorCorner.Parent = toggleIndicator
        
        -- Settings button
        local settingsButton = Instance.new("TextButton")
        settingsButton.Name = "Settings"
        settingsButton.Size = UDim2.new(0, 30, 0, 30)
        settingsButton.Position = UDim2.new(1, -35, 0.5, -15)
        settingsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        settingsButton.Text = "⚙"
        settingsButton.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        settingsButton.TextSize = 14
        settingsButton.BorderSizePixel = 0
        settingsButton.Parent = moduleHeader
        
        local settingsCorner = Instance.new("UICorner")
        settingsCorner.CornerRadius = UDim.new(0, 6)
        settingsCorner.Parent = settingsButton
        
        -- Create tooltip
        self:CreateTooltip(moduleHeader, module.description)
        
        -- Toggle functionality
        module.toggle.MouseButton1Click:Connect(function()
            module.enabled = not module.enabled
            self:UpdateModuleToggle(module)
            
            if module.enabled then
                self:AddToArrayList(name)
            else
                self:RemoveFromArrayList(name)
            end
        end)
        
        -- Settings dropdown functionality
        settingsButton.MouseButton1Click:Connect(function()
            self:ToggleModuleSettings(module)
        end)
        
        table.insert(subTab.modules, module)
        table.insert(self.modules, module)
        
        return self:CreateModuleInterface(module)
    end
    
    return interface
end

function AVA:CreateModuleInterface(module)
    local interface = {}
    
    function interface:AddSlider(name, min, max, default, callback)
        local slider = self:CreateSlider(module, name, min, max, default, callback)
        module.settings[name] = slider
        return slider
    end
    
    function interface:AddToggle(name, default, callback)
        local toggle = self:CreateToggle(module, name, default, callback)
        module.settings[name] = toggle
        return toggle
    end
    
    function interface:AddButton(name, callback)
        local button = self:CreateButton(module, name, callback)
        module.settings[name] = button
        return button
    end
    
    function interface:AddList(name, items, callback)
        local list = self:CreateList(module, name, items, callback)
        module.settings[name] = list
        return list
    end
    
    return interface
end

function AVA:CreateSlider(module, name, min, max, default, callback)
    local slider = {
        name = name,
        min = min,
        max = max,
        value = default,
        callback = callback
    }
    
    -- Create slider in dropdown when implemented
    return slider
end

function AVA:CreateToggle(module, name, default, callback)
    local toggle = {
        name = name,
        enabled = default,
        callback = callback
    }
    
    return toggle
end

function AVA:CreateButton(module, name, callback)
    local button = {
        name = name,
        callback = callback
    }
    
    return button
end

function AVA:CreateList(module, name, items, callback)
    local list = {
        name = name,
        items = items,
        selected = nil,
        callback = callback
    }
    
    return list
end

function AVA:CreateTooltip(parent, text)
    local tooltip = Instance.new("TextLabel")
    tooltip.Name = "Tooltip"
    tooltip.Size = UDim2.new(0, 200, 0, 60)
    tooltip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    tooltip.BackgroundTransparency = 0.2
    tooltip.Text = text
    tooltip.TextColor3 = Color3.new(1, 1, 1)
    tooltip.TextSize = 12
    tooltip.Font = Enum.Font.Gotham
    tooltip.TextWrapped = true
    tooltip.BorderSizePixel = 0
    tooltip.Visible = false
    tooltip.ZIndex = 10
    tooltip.Parent = self.screenGui
    
    local tooltipCorner = Instance.new("UICorner")
    tooltipCorner.CornerRadius = UDim.new(0, 6)
    tooltipCorner.Parent = tooltip
    
    parent.MouseEnter:Connect(function()
        tooltip.Position = UDim2.new(0, parent.AbsolutePosition.X + parent.AbsoluteSize.X + 10, 0, parent.AbsolutePosition.Y)
        tooltip.Visible = true
    end)
    
    parent.MouseLeave:Connect(function()
        tooltip.Visible = false
    end)
end

function AVA:UpdateModuleToggle(module)
    local toggle = module.toggle
    local indicator = toggle:FindFirstChild("Indicator")
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    if module.enabled then
        local bgTween = TweenService:Create(toggle, tweenInfo, {BackgroundColor3 = self.settings.themeColor})
        local posTween = TweenService:Create(indicator, tweenInfo, {Position = UDim2.new(1, -23, 0.5, -10.5)})
        bgTween:Play()
        posTween:Play()
    else
        local bgTween = TweenService:Create(toggle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 80)})
        local posTween = TweenService:Create(indicator, tweenInfo, {Position = UDim2.new(0, 2, 0.5, -10.5)})
        bgTween:Play()
        posTween:Play()
    end
end

function AVA:ToggleModuleSettings(module)
    -- Implementation for module settings dropdown
    module.expanded = not module.expanded
    -- This would expand/collapse the module settings
end

function AVA:AddToArrayList(moduleName)
    if not self.settings.arrayList or self.activeModules[moduleName] then
        return
    end
    
    local moduleFrame = Instance.new("Frame")
    moduleFrame.Name = moduleName
    moduleFrame.Size = UDim2.new(1, 0, 0, 25)
    moduleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    moduleFrame.BackgroundTransparency = 0.3
    moduleFrame.BorderSizePixel = 0
    moduleFrame.Parent = self.arrayContainer
    
    local moduleCorner = Instance.new("UICorner")
    moduleCorner.CornerRadius = UDim.new(0, 4)
    moduleCorner.Parent = moduleFrame
    
    local moduleLabel = Instance.new("TextLabel")
    moduleLabel.Size = UDim2.new(1, -10, 1, 0)
    moduleLabel.Position = UDim2.new(0, 5, 0, 0)
    moduleLabel.BackgroundTransparency = 1
    moduleLabel.Text = moduleName
    moduleLabel.TextColor3 = Color3.new(1, 1, 1)
    moduleLabel.TextSize = 12
    moduleLabel.Font = Enum.Font.Gotham
    moduleLabel.TextXAlignment = Enum.TextXAlignment.Left
    moduleLabel.Parent = moduleFrame
    
    self.activeModules[moduleName] = moduleFrame
    self:UpdateArrayListSize()
end

function AVA:RemoveFromArrayList(moduleName)
    if self.activeModules[moduleName] then
        self.activeModules[moduleName]:Destroy()
        self.activeModules[moduleName] = nil
        self:UpdateArrayListSize()
    end
end

function AVA:UpdateArrayListSize()
    local count = 0
    for _ in pairs(self.activeModules) do
        count = count + 1
    end
    
    self.arrayContainer.CanvasSize = UDim2.new(0, 0, 0, count * 27)
end

function AVA:SelectTab(tabName)
    for _, tab in pairs(self.tabs) do
        if tab.name == tabName then
            tab.active = true
            tab.frame.Visible = true
            tab.button.BackgroundColor3 = self.settings.themeColor
            tab.button.TextColor3 = Color3.new(1, 1, 1)
            
            -- Select first subtab if available
            if #tab.subTabs > 0 then
                self:SelectSubTab(tabName, tab.subTabs[1].name)
            end
        else
            tab.active = false
            tab.frame.Visible = false
            tab.button.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
            tab.button.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        end
    end
end

function AVA:SelectSubTab(tabName, subTabName)
    for _, tab in pairs(self.tabs) do
        if tab.name == tabName then
            for _, subTab in pairs(tab.subTabs) do
                if subTab.name == subTabName then
                    subTab.frame.Visible = true
                    subTab.button.BackgroundTransparency = 0.3
                else
                    subTab.frame.Visible = false
                    subTab.button.BackgroundTransparency = 0.7
                end
            end
        end
    end
end

function AVA:UpdateTabLayout()
    local totalHeight = 0
    for i, tab in ipairs(self.tabs) do
        totalHeight = totalHeight + 42
    end
    self.tabContainer.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

function AVA:SetupDragging()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            if self.settings.smoothDragging then
                local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tween = TweenService:Create(self.mainFrame, tweenInfo, {
                    Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                })
                tween:Play()
            else
                self.mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function AVA:SetupButtonEvents()
    self.closeButton.MouseButton1Click:Connect(function()
        self:Hide()
    end)
    
    self.minimizeButton.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Add hover effects
    local buttons = {self.closeButton, self.minimizeButton}
    for _, button in pairs(buttons) do
        button.MouseEnter:Connect(function()
            local tween = TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0, 32, 0, 32)})
            tween:Play()
        end)
        
        button.MouseLeave:Connect(function()
            local tween = TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0, 30, 0, 30)})
            tween:Play()
        end)
    end
end

function AVA:Show()
    self.mainFrame.Visible = true
    if self.settings.blur then
        local tween = TweenService:Create(self.blurEffect, TweenInfo.new(0.3), {Size = 8})
        tween:Play()
    end
    
    -- Slide in animation
    self.mainFrame.Position = UDim2.new(0.5, -400, 0, -600)
    local tween = TweenService:Create(self.mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -400, 0.5, -300)
    })
    tween:Play()
end

function AVA:Hide()
    if self.settings.blur then
        local tween = TweenService:Create(self.blurEffect, TweenInfo.new(0.3), {Size = 0})
        tween:Play()
    end
    
    -- Slide out animation
    local tween = TweenService:Create(self.mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -400, 1, 100)
    })
    tween:Play()
    
    tween.Completed:Connect(function()
        self.mainFrame.Visible = false
    end)
end

function AVA:Toggle()
    if self.mainFrame.Visible then
        self:Hide()
    else
        self:Show()
    end
end

function AVA:SetThemeColor(color)
    self.settings.themeColor = color
    
    -- Update all UI elements with theme color
    self.header.BackgroundColor3 = color
    for _, tab in pairs(self.tabs) do
        if tab.active then
            tab.button.BackgroundColor3 = color
        end
    end
    
    -- Update array list
    local arrayTitle = self.arrayFrame:FindFirstChild("ArrayTitle")
    if arrayTitle then
        arrayTitle.BackgroundColor3 = color
    end
    
    -- Update all module toggles
    for _, module in pairs(self.modules) do
        if module.enabled then
            module.toggle.BackgroundColor3 = color
        end
    end
end

function AVA:SetSetting(setting, value)
    if self.settings[setting] ~= nil then
        self.settings[setting] = value
        
        if setting == "themeColor" then
            self:SetThemeColor(value)
        elseif setting == "arrayList" then
            self.arrayFrame.Visible = value
        elseif setting == "blur" then
            if not value then
                self.blurEffect.Size = 0
            end
        end
    end
end

function AVA:CreateSettingsTab()
    local settingsTab = self:CreateTab("Settings", "⚙")
    local generalSubTab = settingsTab:CreateSubTab("General", "🔧")
    
    -- Blur setting
    local blurModule = generalSubTab:CreateModule("Blur", "Toggles background blur when UI is open", self.settings.blur)
    blurModule.toggle.MouseButton1Click:Connect(function()
        self:SetSetting("blur", not self.settings.blur)
    end)
    
    -- Detectable setting
    local detectableModule = generalSubTab:CreateModule("Anti-Detection", "Protects the GUI from detection", self.settings.detectable)
    
    -- Smooth dragging setting
    local draggingModule = generalSubTab:CreateModule("Smooth Dragging", "Enables smooth dragging animations", self.settings.smoothDragging)
    
    -- Mobile support setting
    local mobileModule = generalSubTab:CreateModule("Mobile Support", "Optimizes UI for mobile devices", self.settings.mobileSupport)
    
    -- Array list setting
    local arrayModule = generalSubTab:CreateModule("Array List", "Shows active modules list", self.settings.arrayList)
    arrayModule.toggle.MouseButton1Click:Connect(function()
        self:SetSetting("arrayList", not self.settings.arrayList)
    end)
    
    -- Theme color slider would go here (simplified for now)
    local themeModule = generalSubTab:CreateModule("Theme Color", "Changes the UI theme color (Default: Purple)", false)
end

-- Example usage and initialization
function AVA:Initialize()
    -- Create default settings tab
    self:CreateSettingsTab()
    
    -- Create main tabs
    local mainTab = self:CreateTab("Main", "🏠")
    local blatantSubTab = mainTab:CreateSubTab("Blatant", "⚡")
    local utilitySubTab = mainTab:CreateSubTab("Utility", "🔧")
    
    -- Add some example modules to Blatant
    local killAllModule = blatantSubTab:CreateModule("Kill All", "Kills everyone in the server", false)
    local speedModule = blatantSubTab:CreateModule("Speed", "Increases player movement speed", false)
    local flyModule = blatantSubTab:CreateModule("Fly", "Allows player to fly around", false)
    local noclipModule = blatantSubTab:CreateModule("Noclip", "Walk through walls and objects", false)
    
    -- Add some example modules to Utility
    local fullbrightModule = utilitySubTab:CreateModule("Fullbright", "Removes darkness from the game", false)
    local espModule = utilitySubTab:CreateModule("ESP", "Shows player locations through walls", false)
    local autoJumpModule = utilitySubTab:CreateModule("Auto Jump", "Automatically jumps for you", false)
    local infiniteJumpModule = utilitySubTab:CreateModule("Infinite Jump", "Jump as many times as you want", false)
    
    -- Create credits tab
    local creditsTab = self:CreateTab("Credits", "👥")
    local contributorsSubTab = creditsTab:CreateSubTab("Contributors", "👨‍💻")
    local creditsSubTab = creditsTab:CreateSubTab("Credits", "📝")
    
    -- Select first tab by default
    if #self.tabs > 0 then
        self:SelectTab(self.tabs[1].name)
    end
    
    -- Show the UI
    self:Show()
end

-- Create and initialize the UI
local ui = AVA.new("ʌVʌ")
ui:Initialize()

-- Key binding to toggle UI (V key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.V then
        ui:Toggle()
    end
end)

return AVA
