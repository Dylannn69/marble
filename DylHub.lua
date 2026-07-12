-- ConceptUI.lua

local ConceptUI = {}
ConceptUI.__index = ConceptUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Default Theme
local DefaultTheme = {
    Background = Color3.fromRGB(25, 25, 30),
    Surface = Color3.fromRGB(40, 40, 45),
    Surface2 = Color3.fromRGB(55, 55, 62),
    Text = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(180, 180, 190),
    Accent = Color3.fromRGB(255, 70, 100),
    AccentHover = Color3.fromRGB(255, 100, 130),
    Stroke = Color3.fromRGB(70, 70, 80),
    Success = Color3.fromRGB(80, 220, 160),
    Warning = Color3.fromRGB(255, 200, 60),
    Error = Color3.fromRGB(255, 70, 100),
}

--=============================================================================
-- 1. Core Design Functions
--=============================================================================

-- Create(className, props, children)
-- Builds a GUI hierarchy in one call
local function Create(className, props, children)
    local obj = Instance.new(className)
    if props then
        for prop, val in pairs(props) do
            obj[prop] = val
        end
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = obj
        end
    end
    return obj
end

-- CreateTween(Configs)
-- Animation wrapper using TweenService
local function CreateTween(Configs)
    local Instance = Configs[1] or Configs.Instance
    local Prop = Configs[2] or Configs.Prop
    local NewVal = Configs[3] or Configs.NewVal
    local Time = Configs[4] or Configs.Time or 0.5
    local Wait = Configs[5] or Configs.wait or false
    local Style = Configs[6] or Configs.Style or Enum.EasingStyle.Quint

    local Tween = TweenService:Create(
        Instance,
        TweenInfo.new(Time, Style),
        {[Prop] = NewVal}
    )
    Tween:Play()
    if Wait then Tween.Completed:Wait() end
    return Tween
end

-- MakeDrag(instance)
-- Makes any GUI element draggable
local function MakeDrag(Instance)
    Instance.Active = true
    Instance.AutoButtonColor = false

    local DragStart, StartPos
    
    Instance.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            StartPos = Instance.Position
            DragStart = Input.Position
            
            -- Create a drag connection
            local connection
            connection = RunService.RenderStepped:Connect(function()
                if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    if connection then connection:Disconnect() end
                    return
                end
                
                local mouse = Players.LocalPlayer:GetMouse()
                local delta = mouse.X - DragStart.X
                local newPos = UDim2.new(
                    StartPos.X.Scale,
                    StartPos.X.Offset + delta,
                    StartPos.Y.Scale,
                    StartPos.Y.Offset + 0
                )
                Instance.Position = newPos
            end)
        end
    end)
    
    return Instance
end

-- ButtonFrame(title, description, holderSize)
-- Reusable row template for all controls
local function ButtonFrame(parent, Title, Description, HolderSize, theme)
    theme = theme or DefaultTheme
    
    local main = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 25),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = theme.Background,
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    -- Title Label
    local titleLabel = Create("TextLabel", {
        Text = Title or "Title",
        TextColor3 = theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 2),
        Size = UDim2.new(0.6, 0, 0, 16),
        Parent = main
    })
    
    -- Description Label
    local descLabel = nil
    if Description and Description ~= "" then
        descLabel = Create("TextLabel", {
            Text = Description,
            TextColor3 = theme.TextMuted,
            Font = Enum.Font.Gotham,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 18),
            Size = UDim2.new(0.6, 0, 0, 12),
            Parent = main
        })
    end
    
    -- Holder Frame (right side for control)
    local holder = Create("Frame", {
        Size = UDim2.new(0, HolderSize or 120, 1, 0),
        Position = UDim2.new(1, -10, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Parent = main
    })
    
    return {
        Main = main,
        Title = titleLabel,
        Description = descLabel,
        Holder = holder
    }
end

--=============================================================================
-- 2. Component: Toggle
--=============================================================================

function ConceptUI:Toggle(parent, title, description, default, callback)
    local theme = self.Theme
    local row = ButtonFrame(parent, title, description, 50, theme)
    local state = default or false
    
    -- Switch background
    local switch = Create("TextButton", {
        Size = UDim2.new(0, 35, 0, 18),
        BackgroundColor3 = theme.Stroke,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Parent = row.Holder
    })
    Create("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = switch })
    
    -- Knob
    local knob = Create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.new(0, 2, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BorderSizePixel = 0,
        Parent = switch
    })
    Create("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = knob })
    
    -- Update function
    local function UpdateToggle(newState)
        state = newState
        local targetPos = state and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
        local targetColor = state and theme.Accent or theme.Stroke
        
        CreateTween({knob, "Position", targetPos, 0.15})
        CreateTween({switch, "BackgroundColor3", targetColor, 0.15})
        
        if callback then callback(state) end
    end
    
    switch.MouseButton1Click:Connect(function()
        UpdateToggle(not state)
    end)
    
    UpdateToggle(state)
    
    return {
        Set = UpdateToggle,
        Get = function() return state end,
        Switch = switch,
        Knob = knob
    }
end

--=============================================================================
-- 3. Component: Slider
--=============================================================================

function ConceptUI:Slider(parent, title, description, min, max, default, callback)
    local theme = self.Theme
    min = min or 0
    max = max or 100
    default = default or 50
    
    local row = ButtonFrame(parent, title, description, 160, theme)
    local value = default
    local dragging = false
    
    -- Bar background
    local bar = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 4),
        BackgroundColor3 = theme.Stroke,
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BorderSizePixel = 0,
        Parent = row.Holder
    })
    Create("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = bar })
    
    -- Fill
    local fill = Create("Frame", {
        Size = UDim2.fromScale(0.5, 1),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        Parent = bar
    })
    Create("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = fill })
    
    -- Knob
    local knob = Create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        BackgroundColor3 = Color3.fromRGB(220, 220, 220),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        Parent = bar
    })
    Create("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = knob })
    Create("UIStroke", {
        Color = Color3.fromRGB(150, 150, 160),
        Thickness = 1,
        Transparency = 0.3,
        Parent = knob
    })
    
    -- Value Label
    local valueLabel = Create("TextLabel", {
        Text = tostring(math.floor(value)),
        TextColor3 = theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Center,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 0, 14),
        Position = UDim2.new(1, -5, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Parent = row.Holder
    })
    
    -- Update function
    local function UpdateSlider(newValue)
        value = math.clamp(newValue, min, max)
        local percent = (value - min) / (max - min)
        
        fill.Size = UDim2.fromScale(percent, 1)
        CreateTween({knob, "Position", UDim2.fromScale(percent, 0.5), 0.1})
        valueLabel.Text = tostring(math.floor(value))
        
        if callback then callback(value) end
    end
    
    -- Drag handling
    local function GetMousePosition()
        local mouse = Players.LocalPlayer:GetMouse()
        local barPos = bar.AbsolutePosition
        local barSize = bar.AbsoluteSize.X
        local mouseX = mouse.X - barPos.X
        return math.clamp(mouseX / barSize, 0, 1)
    end
    
    knob.MouseButton1Down:Connect(function()
        dragging = true
        local percent = GetMousePosition()
        UpdateSlider(min + (max - min) * percent)
        
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not dragging then
                connection:Disconnect()
                return
            end
            local percent = GetMousePosition()
            UpdateSlider(min + (max - min) * percent)
        end)
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UpdateSlider(default)
    
    return {
        Set = UpdateSlider,
        Get = function() return value end,
        Bar = bar,
        Fill = fill,
        Knob = knob
    }
end

--=============================================================================
-- 4. Component: Dropdown
--=============================================================================

function ConceptUI:Dropdown(parent, title, description, options, default, callback)
    local theme = self.Theme
    options = options or {}
    local row = ButtonFrame(parent, title, description, 160, theme)
    local selected = default or options[1]
    local open = false
    
    -- Display Box
    local display = Create("TextButton", {
        Text = selected or "Select...",
        TextColor3 = theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundColor3 = theme.Surface2,
        BackgroundTransparency = 0.8,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Parent = row.Holder
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = display })
    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = display
    })
    
    -- Arrow
    local arrow = Create("ImageLabel", {
        Image = "rbxassetid://10709791523",
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(1, -8, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Parent = display
    })
    
    -- Dropdown List
    local list = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 2),
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0.1,
        Visible = false,
        ClipsDescendants = true,
        Parent = row.Holder
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = list })
    Create("UIStroke", {
        Color = theme.Stroke,
        Thickness = 1,
        Transparency = 0.3,
        Parent = list
    })
    
    -- Scroll content
    local scroll = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = theme.Stroke,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = list
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = scroll
    })
    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        Parent = scroll
    })
    
    -- Populate options
    for _, option in ipairs(options) do
        local optBtn = Create("TextButton", {
            Text = option,
            TextColor3 = theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            Size = UDim2.new(1, 0, 0, 22),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.9,
            AutoButtonColor = false,
            BorderSizePixel = 0,
            Parent = scroll
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = optBtn })
        Create("UIPadding", {
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            Parent = optBtn
        })
        
        optBtn.MouseEnter:Connect(function()
            optBtn.BackgroundTransparency = 0.6
        end)
        optBtn.MouseLeave:Connect(function()
            optBtn.BackgroundTransparency = 0.9
        end)
        
        optBtn.MouseButton1Click:Connect(function()
            selected = option
            display.Text = option
            UpdateDropdown(false)
            if callback then callback(option) end
        end)
    end
    
    local function UpdateDropdown(state)
        open = state
        list.Visible = state
        if state then
            local count = #options
            local maxHeight = math.min(count * 26, 150)
            CreateTween({list, "Size", UDim2.new(1, 0, 0, maxHeight), 0.2})
            CreateTween({scroll, "Size", UDim2.new(1, 0, 0, maxHeight - 8), 0.2})
            arrow.Rotation = 180
        else
            CreateTween({list, "Size", UDim2.new(1, 0, 0, 0), 0.2})
            CreateTween({scroll, "Size", UDim2.new(1, 0, 0, 0), 0.2})
            arrow.Rotation = 0
        end
    end
    
    display.MouseButton1Click:Connect(function()
        UpdateDropdown(not open)
    end)
    
    return {
        Set = function(option)
            selected = option
            display.Text = option
            if callback then callback(option) end
        end,
        Get = function() return selected end,
        Open = function() UpdateDropdown(true) end,
        Close = function() UpdateDropdown(false) end
    }
end

--=============================================================================
-- 5. Component: Button
--=============================================================================

function ConceptUI:Button(parent, title, description, callback)
    local theme = self.Theme
    local row = ButtonFrame(parent, title, description, 0, theme)
    
    local btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.9,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Text = "",
        Parent = row.Main
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    
    -- Bring title/disc to front
    row.Title.ZIndex = 2
    if row.Description then row.Description.ZIndex = 2 end
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0.5
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundTransparency = 0.9
    end)
    
    btn.MouseButton1Click:Connect(function()
        local originalSize = btn.Size
        CreateTween({btn, "Size", UDim2.new(1, 0, 1, -2), 0.08})
        task.wait(0.08)
        CreateTween({btn, "Size", originalSize, 0.08})
        if callback then callback() end
    end)
    
    return btn
end

--=============================================================================
-- 6. Component: TextBox
--=============================================================================

function ConceptUI:TextBox(parent, title, description, placeholder, callback)
    local theme = self.Theme
    local row = ButtonFrame(parent, title, description, 160, theme)
    local text = ""
    
    local input = Create("TextBox", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundColor3 = theme.Surface2,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        Text = "",
        TextColor3 = theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        PlaceholderText = placeholder or "Enter text...",
        PlaceholderColor3 = theme.TextMuted,
        Parent = row.Holder
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = input })
    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = input
    })
    
    input.FocusLost:Connect(function()
        text = input.Text
        if callback then callback(text) end
    end)
    
    return {
        Set = function(newText)
            text = newText
            input.Text = newText
        end,
        Get = function() return text end,
        Input = input
    }
end

--=============================================================================
-- 7. Main UI Builder
--=============================================================================

function ConceptUI:BuildUI()
    local gui = self.Gui
    local theme = self.Theme
    
    -- Main Window
    local Main = Create("Frame", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = self.Config.Position or UDim2.fromScale(0.5, 0.5),
        Size = self.Config.Size or UDim2.fromScale(0.35, 0.6),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        Parent = gui
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 16), Parent = Main })
    Create("UIGradient", {
        Rotation = 90,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(25, 25, 30)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 40, 48)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(30, 30, 38))
        },
        Parent = Main
    })
    Create("UIStroke", {
        Color = Color3.fromRGB(60, 60, 70),
        Thickness = 1,
        Transparency = 0.5,
        Parent = Main
    })
    
    -- Make draggable
    MakeDrag(Main)
    
    -- Header
    local Header = Create("Frame", {
        Name = "Header",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        Parent = Main
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 16), Parent = Header })
    
    -- Title
    local titleLabel = Create("TextLabel", {
        Text = self.Config.Title or "Concept UI",
        TextColor3 = theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0.6, 0, 0, 20),
        Parent = Header
    })
    
    -- Close Button
    local closeBtn = Create("ImageButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(28, 28),
        BackgroundTransparency = 1,
        Image = "rbxassetid://10709791523",
        ImageColor3 = theme.TextMuted,
        BorderSizePixel = 0,
        Parent = Header
    })
    Create("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = closeBtn })
    
    closeBtn.MouseEnter:Connect(function()
        closeBtn.ImageColor3 = theme.Text
        CreateTween({closeBtn, "Size", UDim2.fromOffset(32, 32), 0.15})
    end)
    closeBtn.MouseLeave:Connect(function()
        closeBtn.ImageColor3 = theme.TextMuted
        CreateTween({closeBtn, "Size", UDim2.fromOffset(28, 28), 0.15})
    end)
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    -- Content Area
    local Content = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -16, 1, -56),
        Position = UDim2.new(0, 8, 0, 48),
        BackgroundTransparency = 1,
        Parent = Main
    })
    
    -- Scrollable Content
    local scrollContent = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = theme.Stroke,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = Content
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = scrollContent
    })
    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 0),
        PaddingRight = UDim.new(0, 0),
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        Parent = scrollContent
    })
    
    self.Main = Main
    self.Header = Header
    self.Content = scrollContent
    
    return self
end

--=============================================================================
-- 8. Constructor
--=============================================================================

function ConceptUI.new(config)
    local self = setmetatable({}, ConceptUI)
    self.Config = config or {}
    self.Theme = config.Theme or DefaultTheme
    
    -- Create GUI
    local player = Players.LocalPlayer
    local gui = Create("ScreenGui", {
        Name = "ConceptUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        Parent = player:WaitForChild("PlayerGui")
    })
    self.Gui = gui
    
    self:BuildUI()
    
    return self
end

return ConceptUI
