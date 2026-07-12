-- // UI Library - ConceptUI
-- // LoadString: https://raw.githubusercontent.com/yourusername/ConceptUI/main.lua

local Library = {}
Library.__index = Library

-- // Default Theme (locked – but can be overridden if needed)
Library.DefaultTheme = {
    AccentColor = Color3.fromRGB(110, 45, 220),
    AccentLight = Color3.fromRGB(176, 96, 244),
    AccentDark = Color3.fromRGB(80, 65, 170),
    TextColor = Color3.fromRGB(255, 255, 255),
    BackgroundColor = Color3.fromRGB(255, 255, 255),
    ShadowTransparency = 0.5,
    Font = Enum.Font.Bangers,
    CornerRadius = 20,
    MarbleTexture = "133709037992585" -- asset ID
}

-- // Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- // UTILITY FUNCTIONS
local function tween(obj, props, time, style, direction)
    local info = TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function createShadow(parent, size, pos, transparency, corner)
    local shadow = Instance.new("Frame")
    shadow.Size = size
    shadow.Position = pos
    shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    shadow.BackgroundTransparency = transparency or 0.5
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    local cornerInst = Instance.new("UICorner")
    cornerInst.CornerRadius = corner or UDim.new(0, 20)
    cornerInst.Parent = shadow
    shadow.Parent = parent
    return shadow
end

local function createImageLabel(parent, size, pos, image, transparency, scaleType)
    local img = Instance.new("ImageLabel")
    img.Size = size
    img.Position = pos
    img.BackgroundTransparency = 1
    img.BorderSizePixel = 0
    img.Image = image
    img.ImageTransparency = transparency or 0
    img.ScaleType = scaleType or Enum.ScaleType.Fit
    img.Parent = parent
    return img
end

local function createGradient(parent, rotation, colorSequence)
    local grad = Instance.new("UIGradient")
    grad.Rotation = rotation or 90
    grad.Color = colorSequence or ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(110,45,220)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(176,96,244)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(236,198,255))
    }
    grad.Parent = parent
    return grad
end

local function createStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255,255,255)
    stroke.Thickness = thickness or 2
    stroke.Transparency = transparency or 0.3
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

-- // COMPONENT BASE CLASS
local Component = {}
Component.__index = Component

function Component.new(parent, options)
    local self = setmetatable({}, Component)
    self.Parent = parent
    self.Options = options or {}
    self.Container = nil -- will be set by subclass
    self.Callback = options.Callback or function() end
    return self
end

-- // BUTTON
local Button = setmetatable({}, {__index = Component})
Button.__index = Button

function Button.new(parent, options)
    local self = Component.new(parent, options)
    self.Text = options.Text or "Button"
    self.Height = options.Height or 38
    self.Width = options.Width or 1 -- full width of container
    self.Callback = options.Callback or function() end
    self:Create()
    return self
end

function Button:Create()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(self.Width, 0, 0, self.Height + 6)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = self.Parent.Content

    -- Shadow
    local shadow = createShadow(container, UDim2.new(1, 0, 0, self.Height), UDim2.new(0, 2, 0, 4), 0.3, UDim.new(0, 10))

    -- Button frame
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, self.Height)
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.ZIndex = 1
    btn.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    -- Gradient
    local grad = createGradient(btn)

    -- Marble overlay
    local marble = createImageLabel(btn, UDim2.fromScale(1, 1), UDim2.new(0,0,0,0), "https://www.roblox.com/asset-thumbnail/image?assetId="..Library.DefaultTheme.MarbleTexture.."&width=678&height=810&format=png", 0.5, Enum.ScaleType.Stretch)
    local marbleCorner = Instance.new("UICorner")
    marbleCorner.CornerRadius = UDim.new(0, 10)
    marbleCorner.Parent = marble

    -- Text shadow (offset)
    local txtShadow = Instance.new("TextLabel")
    txtShadow.Size = UDim2.fromScale(1, 1)
    txtShadow.Position = UDim2.new(0, 1, 0, 1)
    txtShadow.BackgroundTransparency = 1
    txtShadow.Font = Library.DefaultTheme.Font
    txtShadow.Text = self.Text
    txtShadow.TextScaled = true
    txtShadow.TextColor3 = Color3.fromRGB(0,0,0)
    txtShadow.TextTransparency = 0.5
    txtShadow.ZIndex = 2
    txtShadow.Parent = btn

    -- Main text
    local mainTxt = Instance.new("TextLabel")
    mainTxt.Size = UDim2.fromScale(1, 1)
    mainTxt.Position = UDim2.new(0, 0, 0, 0)
    mainTxt.BackgroundTransparency = 1
    mainTxt.Font = Library.DefaultTheme.Font
    mainTxt.Text = self.Text
    mainTxt.TextScaled = true
    mainTxt.TextColor3 = Library.DefaultTheme.TextColor
    mainTxt.ZIndex = 3
    mainTxt.Parent = btn

    -- Click animation
    local function click()
        -- shrink
        tween(btn, {Size = UDim2.new(1, 0, 0, self.Height - 4)}, 0.08)
        btn.Position = UDim2.new(0, 0, 0, 2)
        tween(shadow, {Size = UDim2.new(1, 0, 0, self.Height - 4)}, 0.08)
        shadow.Position = UDim2.new(0, 2, 0, 2)
        task.wait(0.08)
        tween(btn, {Size = UDim2.new(1, 0, 0, self.Height)}, 0.08)
        btn.Position = UDim2.new(0, 0, 0, 0)
        tween(shadow, {Size = UDim2.new(1, 0, 0, self.Height)}, 0.08)
        shadow.Position = UDim2.new(0, 2, 0, 4)
        self.Callback()
    end

    btn.MouseButton1Click:Connect(click)

    self.Container = container
    self.Button = btn
    self.TextLabel = mainTxt
    self.Shadow = shadow
end

function Button:SetText(newText)
    self.Text = newText
    self.TextLabel.Text = newText
    self.Button:FindFirstChild("TextShadow").Text = newText
end

-- // TOGGLE
local Toggle = setmetatable({}, {__index = Component})
Toggle.__index = Toggle

function Toggle.new(parent, options)
    local self = Component.new(parent, options)
    self.Text = options.Text or "Toggle"
    self.Default = options.Default or false
    self.Height = options.Height or 38
    self.Width = options.Width or 1
    self.Callback = options.Callback or function() end
    self.State = self.Default
    self:Create()
    return self
end

function Toggle:Create()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(self.Width, 0, 0, self.Height + 6)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = self.Parent.Content

    -- Shadow
    local shadow = createShadow(container, UDim2.new(1, 0, 0, self.Height), UDim2.new(0, 2, 0, 4), 0.3, UDim.new(0, 10))

    -- Button frame (clickable area)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, self.Height)
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.ZIndex = 1
    btn.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    local grad = createGradient(btn)
    local marble = createImageLabel(btn, UDim2.fromScale(1, 1), UDim2.new(0,0,0,0), "https://www.roblox.com/asset-thumbnail/image?assetId="..Library.DefaultTheme.MarbleTexture.."&width=678&height=810&format=png", 0.5, Enum.ScaleType.Stretch)
    local marbleCorner = Instance.new("UICorner")
    marbleCorner.CornerRadius = UDim.new(0, 10)
    marbleCorner.Parent = marble

    -- Text label (left aligned)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Library.DefaultTheme.Font
    label.Text = self.Text
    label.TextScaled = true
    label.TextColor3 = Library.DefaultTheme.TextColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 2
    label.Parent = btn

    -- Switch frame (right aligned)
    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 50, 0, 28)
    switch.Position = UDim2.new(1, -60, 0.5, -14)
    switch.BackgroundColor3 = Color3.fromRGB(200,200,200)
    switch.BackgroundTransparency = 0
    switch.BorderSizePixel = 0
    switch.ZIndex = 2
    switch.Parent = btn

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch

    -- Switch knob
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 22, 0, 22)
    knob.Position = UDim2.new(0, 3, 0.5, -11)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 3
    knob.Parent = switch

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    -- Set initial state
    local function updateState(state)
        self.State = state
        if state then
            switch.BackgroundColor3 = Library.DefaultTheme.AccentColor
            tween(knob, {Position = UDim2.new(1, -25, 0.5, -11)}, 0.15)
        else
            switch.BackgroundColor3 = Color3.fromRGB(200,200,200)
            tween(knob, {Position = UDim2.new(0, 3, 0.5, -11)}, 0.15)
        end
        self.Callback(state)
    end

    updateState(self.Default)

    btn.MouseButton1Click:Connect(function()
        updateState(not self.State)
    end)

    self.Container = container
    self.Switch = switch
    self.Knob = knob
end

-- // SLIDER
local Slider = setmetatable({}, {__index = Component})
Slider.__index = Slider

function Slider.new(parent, options)
    local self = Component.new(parent, options)
    self.Text = options.Text or "Slider"
    self.Min = options.Min or 0
    self.Max = options.Max or 100
    self.Default = options.Default or 50
    self.Height = options.Height or 48
    self.Width = options.Width or 1
    self.Callback = options.Callback or function() end
    self.Value = self.Default
    self:Create()
    return self
end

function Slider:Create()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(self.Width, 0, 0, self.Height + 6)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = self.Parent.Content

    -- Shadow
    local shadow = createShadow(container, UDim2.new(1, 0, 0, self.Height), UDim2.new(0, 2, 0, 4), 0.3, UDim.new(0, 10))

    -- Background
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 0, self.Height)
    bg.Position = UDim2.new(0, 0, 0, 0)
    bg.BackgroundColor3 = Color3.fromRGB(255,255,255)
    bg.BackgroundTransparency = 0.3
    bg.BorderSizePixel = 0
    bg.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = bg

    local grad = createGradient(bg)
    local marble = createImageLabel(bg, UDim2.fromScale(1, 1), UDim2.new(0,0,0,0), "https://www.roblox.com/asset-thumbnail/image?assetId="..Library.DefaultTheme.MarbleTexture.."&width=678&height=810&format=png", 0.5, Enum.ScaleType.Stretch)
    local marbleCorner = Instance.new("UICorner")
    marbleCorner.CornerRadius = UDim.new(0, 10)
    marbleCorner.Parent = marble

    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Library.DefaultTheme.Font
    label.Text = self.Text
    label.TextScaled = true
    label.TextColor3 = Library.DefaultTheme.TextColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 2
    label.Parent = bg

    -- Value label
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.2, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.8, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Library.DefaultTheme.Font
    valueLabel.Text = tostring(self.Value)
    valueLabel.TextScaled = true
    valueLabel.TextColor3 = Library.DefaultTheme.TextColor
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 2
    valueLabel.Parent = bg

    -- Slider track
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0.6, 0, 0, 6)
    track.Position = UDim2.new(0.2, 0, 0.5, -3)
    track.BackgroundColor3 = Color3.fromRGB(100,100,100)
    track.BorderSizePixel = 0
    track.ZIndex = 2
    track.Parent = bg

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    -- Fill
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Library.DefaultTheme.AccentColor
    fill.BorderSizePixel = 0
    fill.ZIndex = 3
    fill.Parent = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    -- Knob
    local knob = Instance.new("ImageButton")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, -10, 0.5, -10)
    knob.BackgroundTransparency = 1
    knob.Image = "rbxassetid://6031090997" -- simple circle
    knob.ZIndex = 4
    knob.Parent = track

    local function updateValue(value)
        local clamped = math.clamp(value, self.Min, self.Max)
        self.Value = clamped
        local percent = (clamped - self.Min) / (self.Max - self.Min)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        knob.Position = UDim2.new(percent, -10, 0.5, -10)
        valueLabel.Text = tostring(math.floor(clamped))
        self.Callback(clamped)
    end

    updateValue(self.Default)

    -- Dragging
    local dragging = false
    local function startDrag()
        dragging = true
    end
    local function endDrag()
        dragging = false
    end
    local function drag(input)
        if dragging then
            local pos = input.Position.X - track.AbsolutePosition.X
            local width = track.AbsoluteSize.X
            local percent = math.clamp(pos / width, 0, 1)
            local val = self.Min + (self.Max - self.Min) * percent
            updateValue(val)
        end
    end

    knob.MouseButton1Down:Connect(startDrag)
    UserInputService.InputEnded:Connect(function(input, processed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            endDrag()
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            drag(input)
        end
    end)

    self.Container = container
    self.Fill = fill
    self.Knob = knob
    self.ValueLabel = valueLabel
end

-- // TEXTBOX
local Textbox = setmetatable({}, {__index = Component})
Textbox.__index = Textbox

function Textbox.new(parent, options)
    local self = Component.new(parent, options)
    self.Text = options.Text or "Enter text..."
    self.Placeholder = options.Placeholder or "Type here..."
    self.Height = options.Height or 38
    self.Width = options.Width or 1
    self.Callback = options.Callback or function() end
    self:Create()
    return self
end

function Textbox:Create()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(self.Width, 0, 0, self.Height + 6)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = self.Parent.Content

    local shadow = createShadow(container, UDim2.new(1, 0, 0, self.Height), UDim2.new(0, 2, 0, 4), 0.3, UDim.new(0, 10))

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 0, self.Height)
    bg.Position = UDim2.new(0, 0, 0, 0)
    bg.BackgroundColor3 = Color3.fromRGB(255,255,255)
    bg.BackgroundTransparency = 0.3
    bg.BorderSizePixel = 0
    bg.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = bg

    local grad = createGradient(bg)
    local marble = createImageLabel(bg, UDim2.fromScale(1, 1), UDim2.new(0,0,0,0), "https://www.roblox.com/asset-thumbnail/image?assetId="..Library.DefaultTheme.MarbleTexture.."&width=678&height=810&format=png", 0.5, Enum.ScaleType.Stretch)
    local marbleCorner = Instance.new("UICorner")
    marbleCorner.CornerRadius = UDim.new(0, 10)
    marbleCorner.Parent = marble

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.25, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Library.DefaultTheme.Font
    label.Text = self.Text
    label.TextScaled = true
    label.TextColor3 = Library.DefaultTheme.TextColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 2
    label.Parent = bg

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.6, 0, 0.8, 0)
    box.Position = UDim2.new(0.35, 0, 0.1, 0)
    box.BackgroundColor3 = Color3.fromRGB(255,255,255)
    box.BackgroundTransparency = 0.8
    box.BorderSizePixel = 1
    box.BorderColor3 = Color3.fromRGB(200,200,200)
    box.Font = Library.DefaultTheme.Font
    box.Text = ""
    box.PlaceholderText = self.Placeholder
    box.TextScaled = true
    box.TextColor3 = Library.DefaultTheme.TextColor
    box.PlaceholderColor3 = Color3.fromRGB(180,180,180)
    box.ZIndex = 2
    box.Parent = bg

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 8)
    boxCorner.Parent = box

    box.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            self.Callback(box.Text)
        end
    end)

    self.Container = container
    self.Box = box
end

-- // LABEL
local Label = setmetatable({}, {__index = Component})
Label.__index = Label

function Label.new(parent, options)
    local self = Component.new(parent, options)
    self.Text = options.Text or "Label"
    self.Height = options.Height or 30
    self.Width = options.Width or 1
    self.FontSize = options.FontSize or 0.5
    self:Create()
    return self
end

function Label:Create()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(self.Width, 0, 0, self.Height + 6)
    container.BackgroundTransparency = 1
    container.Parent = self.Parent.Content

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Library.DefaultTheme.Font
    label.Text = self.Text
    label.TextScaled = true
    label.TextColor3 = Library.DefaultTheme.TextColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    self.Container = container
end

-- // DROPDOWN
local Dropdown = setmetatable({}, {__index = Component})
Dropdown.__index = Dropdown

function Dropdown.new(parent, options)
    local self = Component.new(parent, options)
    self.Text = options.Text or "Dropdown"
    self.Options = options.Options or {"Option 1", "Option 2", "Option 3"}
    self.Default = options.Default or self.Options[1]
    self.Height = options.Height or 38
    self.Width = options.Width or 1
    self.Callback = options.Callback or function() end
    self.Selected = self.Default
    self.Open = false
    self:Create()
    return self
end

function Dropdown:Create()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(self.Width, 0, 0, self.Height + 6)
    container.BackgroundTransparency = 1
    container.Parent = self.Parent.Content

    local shadow = createShadow(container, UDim2.new(1, 0, 0, self.Height), UDim2.new(0, 2, 0, 4), 0.3, UDim.new(0, 10))

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, self.Height)
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.ZIndex = 1
    btn.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    local grad = createGradient(btn)
    local marble = createImageLabel(btn, UDim2.fromScale(1, 1), UDim2.new(0,0,0,0), "https://www.roblox.com/asset-thumbnail/image?assetId="..Library.DefaultTheme.MarbleTexture.."&width=678&height=810&format=png", 0.5, Enum.ScaleType.Stretch)
    local marbleCorner = Instance.new("UICorner")
    marbleCorner.CornerRadius = UDim.new(0, 10)
    marbleCorner.Parent = marble

    -- Main text (selected)
    local mainText = Instance.new("TextLabel")
    mainText.Size = UDim2.new(0.8, 0, 1, 0)
    mainText.Position = UDim2.new(0, 10, 0, 0)
    mainText.BackgroundTransparency = 1
    mainText.Font = Library.DefaultTheme.Font
    mainText.Text = self.Selected
    mainText.TextScaled = true
    mainText.TextColor3 = Library.DefaultTheme.TextColor
    mainText.TextXAlignment = Enum.TextXAlignment.Left
    mainText.ZIndex = 2
    mainText.Parent = btn

    -- Arrow
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0.1, 0, 1, 0)
    arrow.Position = UDim2.new(0.9, 0, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Font = Library.DefaultTheme.Font
    arrow.Text = "▼"
    arrow.TextScaled = true
    arrow.TextColor3 = Library.DefaultTheme.TextColor
    arrow.ZIndex = 2
    arrow.Parent = btn

    -- Dropdown list (hidden)
    local list = Instance.new("Frame")
    list.Size = UDim2.new(1, 0, 0, #self.Options * (self.Height + 4))
    list.Position = UDim2.new(0, 0, 1, 4)
    list.BackgroundColor3 = Color3.fromRGB(255,255,255)
    list.BackgroundTransparency = 0.95
    list.BorderSizePixel = 0
    list.Visible = false
    list.ZIndex = 5
    list.Parent = container

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 10)
    listCorner.Parent = list

    local listStroke = createStroke(list, Color3.fromRGB(200,200,200), 1, 0.5)

    -- Create option buttons
    local optionBtns = {}
    for i, opt in ipairs(self.Options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, self.Height)
        optBtn.Position = UDim2.new(0, 0, 0, (i-1)*(self.Height + 4))
        optBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
        optBtn.BackgroundTransparency = 0.5
        optBtn.BorderSizePixel = 0
        optBtn.Text = opt
        optBtn.Font = Library.DefaultTheme.Font
        optBtn.TextScaled = true
        optBtn.TextColor3 = Library.DefaultTheme.TextColor
        optBtn.ZIndex = 6
        optBtn.Parent = list

        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 8)
        optCorner.Parent = optBtn

        optBtn.MouseButton1Click:Connect(function()
            self.Selected = opt
            mainText.Text = opt
            list.Visible = false
            self.Open = false
            self.Callback(opt)
        end)

        table.insert(optionBtns, optBtn)
    end

    -- Toggle dropdown
    btn.MouseButton1Click:Connect(function()
        self.Open = not self.Open
        list.Visible = self.Open
        arrow.Text = self.Open and "▲" or "▼"
        if self.Open then
            -- Adjust list height to fit
            list.Size = UDim2.new(1, 0, 0, #self.Options * (self.Height + 4))
        end
    end)

    self.Container = container
    self.List = list
    self.MainText = mainText
    self.Arrow = arrow
end

-- // SECTION
local Section = setmetatable({}, {__index = Component})
Section.__index = Section

function Section.new(parent, options)
    local self = Component.new(parent, options)
    self.Text = options.Text or "Section"
    self.Height = options.Height or 30
    self.Width = options.Width or 1
    self:Create()
    return self
end

function Section:Create()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(self.Width, 0, 0, self.Height + 6)
    container.BackgroundTransparency = 1
    container.Parent = self.Parent.Content

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Library.DefaultTheme.Font
    label.Text = self.Text
    label.TextScaled = true
    label.TextColor3 = Library.DefaultTheme.TextColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTransparency = 0.3
    label.Parent = container

    self.Container = container
end

-- // DIVIDER
local Divider = setmetatable({}, {__index = Component})
Divider.__index = Divider

function Divider.new(parent, options)
    local self = Component.new(parent, options)
    self.Height = options.Height or 20
    self.Width = options.Width or 1
    self:Create()
    return self
end

function Divider:Create()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(self.Width, 0, 0, self.Height + 6)
    container.BackgroundTransparency = 1
    container.Parent = self.Parent.Content

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 2)
    line.Position = UDim2.new(0, 0, 0.5, -1)
    line.BackgroundColor3 = Color3.fromRGB(255,255,255)
    line.BackgroundTransparency = 0.5
    line.BorderSizePixel = 0
    line.Parent = container

    self.Container = container
end

-- // WINDOW
local Window = {}
Window.__index = Window

function Window.new(options)
    local self = setmetatable({}, Window)
    self.Options = options or {}
    self.Title = self.Options.Title or "Window"
    self.Size = self.Options.Size or {0.4, 0.75}
    self.Position = self.Options.Position or {0.5, 0.54}
    self.Theme = self.Options.Theme or Library.DefaultTheme
    self.Tabs = {}
    self.CurrentTab = nil

    -- Create GUI
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "ConceptUI"
    self.Gui.ResetOnSpawn = false
    self.Gui.IgnoreGuiInset = true
    self.Gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Shadow
    self.Shadow = createShadow(self.Gui, UDim2.fromScale(self.Size[1], self.Size[2]), UDim2.new(self.Position[1], 0, self.Position[2], 8), 0.5, UDim.new(0,20))

    -- Main frame
    self.Main = Instance.new("Frame")
    self.Main.Name = "Main"
    self.Main.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Main.Position = UDim2.new(self.Position[1], 0, self.Position[2], 0)
    self.Main.Size = UDim2.fromScale(self.Size[1], self.Size[2])
    self.Main.BackgroundColor3 = Color3.fromRGB(255,255,255)
    self.Main.BorderSizePixel = 0
    self.Main.Parent = self.Gui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0,20)
    mainCorner.Parent = self.Main

    -- Main stroke
    self.MainStroke = createStroke(self.Main, Color3.fromRGB(255,255,255), 2, 0.3)

    -- Gradient
    self.MainGradient = createGradient(self.Main)

    -- Marble
    self.Marble = createImageLabel(self.Main, UDim2.fromScale(1,1), UDim2.new(0,0,0,0), "https://www.roblox.com/asset-thumbnail/image?assetId="..self.Theme.MarbleTexture.."&width=678&height=810&format=png", 0.6, Enum.ScaleType.Stretch)
    local marbleCorner = Instance.new("UICorner")
    marbleCorner.CornerRadius = UDim.new(0,20)
    marbleCorner.Parent = self.Marble

    -- Header
    self.Header = self:CreateHeader()

    -- Side panel
    self.Side = self:CreateSidePanel()

    -- Content area (for tabs)
    self.Content = Instance.new("Frame")
    self.Content.Name = "Content"
    self.Content.AnchorPoint = Vector2.new(0,0.5)
    self.Content.Position = UDim2.new(0.35, 0, 0.5, 0) -- adjusted for side panel width
    self.Content.Size = UDim2.new(0.6, -10, 0.85, 0) -- fit beside side panel
    self.Content.BackgroundTransparency = 1
    self.Content.Parent = self.Main

    -- Close button (minimize)
    self.CloseButton = self:CreateCloseButton()

    -- Minimized state
    self.MinimizedFrame = self:CreateMinimizedFrame()

    -- Initially visible
    self.Visible = true

    return self
end

function Window:CreateHeader()
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.AnchorPoint = Vector2.new(0.5,0)
    header.Position = UDim2.new(0.5,0,-0.04,0)
    header.Size = UDim2.fromScale(0.5,0.09)
    header.BackgroundColor3 = Color3.fromRGB(255,255,255)
    header.BorderSizePixel = 0
    header.Parent = self.Main

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,18)
    corner.Parent = header

    -- Header shadow
    local headerShadow = createShadow(header, UDim2.fromScale(0.5,0.09), UDim2.new(0.5, 2, -0.04, 4), 0.4, UDim.new(0,18))
    headerShadow.Parent = self.Main

    local grad = createGradient(header)

    local marble = createImageLabel(header, UDim2.fromScale(1,1), UDim2.new(0,0,0,0), "https://www.roblox.com/asset-thumbnail/image?assetId="..self.Theme.MarbleTexture.."&width=678&height=810&format=png", 0.6, Enum.ScaleType.Stretch)
    local marbleCorner = Instance.new("UICorner")
    marbleCorner.CornerRadius = UDim.new(0,18)
    marbleCorner.Parent = marble

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.AnchorPoint = Vector2.new(0.5,0.5)
    title.Position = UDim2.fromScale(0.5,0.5)
    title.Size = UDim2.fromScale(0.9,0.8)
    title.BackgroundTransparency = 1
    title.Font = self.Theme.Font
    title.Text = self.Title
    title.TextScaled = true
    title.TextColor3 = self.Theme.TextColor
    title.Parent = header

    self.HeaderTitle = title
    return header
end

function Window:CreateSidePanel()
    local side = Instance.new("Frame")
    side.Name = "Side"
    side.AnchorPoint = Vector2.new(1,0.5)
    side.Position = UDim2.new(0,-12,0.5,0)
    side.Size = UDim2.fromScale(0.3,0.90)
    side.BackgroundColor3 = Color3.fromRGB(255,255,255)
    side.BackgroundTransparency = 0.15
    side.BorderSizePixel = 0
    side.Parent = self.Main

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,16)
    corner.Parent = side

    local sideShadow = createShadow(side, UDim2.fromScale(0.3,0.90), UDim2.new(0,-12,0.5,8), 0.45, UDim.new(0,16))
    sideShadow.Parent = self.Main

    local grad = createGradient(side)

    local marble = createImageLabel(side, UDim2.fromScale(1,1), UDim2.new(0,0,0,0), "https://www.roblox.com/asset-thumbnail/image?assetId="..self.Theme.MarbleTexture.."&width=678&height=810&format=png", 0.6, Enum.ScaleType.Stretch)
    local marbleCorner = Instance.new("UICorner")
    marbleCorner.CornerRadius = UDim.new(0,16)
    marbleCorner.Parent = marble

    local stroke = createStroke(side, Color3.fromRGB(255,255,255), 2, 0.3)

    -- Scroll frame for tabs
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "TabScroll"
    scroll.Size = UDim2.new(1,0,1,0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(180,120,255)
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.Parent = side

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 12)
    padding.PaddingBottom = UDim.new(0, 12)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = scroll

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = scroll

    self.TabScroll = scroll
    self.TabLayout = layout
    return side
end

function Window:CreateCloseButton()
    local btn = Instance.new("ImageButton")
    btn.Name = "CloseButton"
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.Position = UDim2.new(1, 0, 0, 0)
    btn.Size = UDim2.fromOffset(56, 56)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=114840795551292&width=678&height=810&format=png"
    btn.ScaleType = Enum.ScaleType.Fit
    btn.ZIndex = 10
    btn.Parent = self.Main

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn

    btn.MouseEnter:Connect(function()
        tween(btn, {Size = UDim2.fromOffset(62, 62)}, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {Size = UDim2.fromOffset(56, 56)}, 0.15)
    end)

    -- Minimize logic
    local selfRef = self
    btn.MouseButton1Click:Connect(function()
        selfRef:Minimize()
    end)

    return btn
end

function Window:CreateMinimizedFrame()
    local mf = Instance.new("ImageButton")
    mf.Name = "MinimizedFrame"
    mf.AnchorPoint = Vector2.new(1, 0)
    mf.Position = UDim2.new(1, -20, 0, 20)
    mf.Size = UDim2.fromOffset(60, 60)
    mf.BackgroundTransparency = 1
    mf.BorderSizePixel = 0
    mf.Visible = false
    mf.ZIndex = 100
    mf.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=103591022804634&width=678&height=810&format=png"
    mf.ScaleType = Enum.ScaleType.Fit
    mf.Parent = self.Gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = mf

    local stroke = createStroke(mf, Color3.fromRGB(255,255,255), 2, 0.3)

    local selfRef = self
    mf.MouseButton1Click:Connect(function()
        selfRef:Restore()
    end)

    return mf
end

function Window:Minimize()
    local targetPos = UDim2.new(1, -40, 0, 40)
    local targetSize = UDim2.fromScale(0.05, 0.05)
    tween(self.Main, {Size = targetSize, Position = targetPos}, 0.3)
    tween(self.Shadow, {Size = targetSize, Position = targetPos}, 0.3)
    task.wait(0.3)
    self.Main.Visible = false
    self.Shadow.Visible = false
    self.MinimizedFrame.Visible = true
    self.MinimizedFrame.Size = UDim2.fromOffset(0, 0)
    tween(self.MinimizedFrame, {Size = UDim2.fromOffset(60, 60)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

function Window:Restore()
    self.MinimizedFrame.Visible = false
    self.Main.Size = UDim2.fromScale(self.Size[1], self.Size[2])
    self.Main.Position = UDim2.new(self.Position[1], 0, self.Position[2], 0)
    self.Shadow.Size = UDim2.fromScale(self.Size[1], self.Size[2])
    self.Shadow.Position = UDim2.new(self.Position[1], 0, self.Position[2], 8)
    self.Main.Visible = true
    self.Shadow.Visible = true
    self.Main.Size = UDim2.fromScale(0.05, 0.05)
    self.Main.Position = UDim2.new(1, -40, 0, 40)
    self.Shadow.Size = UDim2.fromScale(0.05, 0.05)
    self.Shadow.Position = UDim2.new(1, -40, 0, 40)
    tween(self.Main, {Size = UDim2.fromScale(self.Size[1], self.Size[2]), Position = UDim2.new(self.Position[1], 0, self.Position[2], 0)}, 0.5, Enum.EasingStyle.Back)
    tween(self.Shadow, {Size = UDim2.fromScale(self.Size[1], self.Size[2]), Position = UDim2.new(self.Position[1], 0, self.Position[2], 8)}, 0.5, Enum.EasingStyle.Back)
end

function Window:CreateTab(options)
    local tab = {}
    tab.Title = options.Title or "Tab"
    tab.Window = self
    tab.Content = self.Content
    tab.Components = {}

    -- Create button on side panel
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = tab.Title
    btn.Font = self.Theme.Font
    btn.TextScaled = true
    btn.TextColor3 = self.Theme.TextColor
    btn.Parent = self.TabScroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    local grad = createGradient(btn)
    local marble = createImageLabel(btn, UDim2.fromScale(1,1), UDim2.new(0,0,0,0), "https://www.roblox.com/asset-thumbnail/image?assetId="..self.Theme.MarbleTexture.."&width=678&height=810&format=png", 0.5, Enum.ScaleType.Stretch)
    local marbleCorner = Instance.new("UICorner")
    marbleCorner.CornerRadius = UDim.new(0, 10)
    marbleCorner.Parent = marble

    -- Store
    tab.Button = btn

    -- Click to switch
    btn.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)

    -- Create a container for this tab's content (hidden initially)
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, 0, 1, 0)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Visible = false
    contentContainer.Parent = self.Content

    tab.ContentContainer = contentContainer

    -- Store in list
    table.insert(self.Tabs, tab)

    -- If first tab, select it
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end

    return tab
end

function Window:SelectTab(tab)
    -- Hide all tab content
    for _, t in ipairs(self.Tabs) do
        t.ContentContainer.Visible = false
    end
    tab.ContentContainer.Visible = true
    self.CurrentTab = tab
end

-- Component creators for Tab
function Window:CreateButton(options)
    if not self.CurrentTab then return end
    local btn = Button.new(self.CurrentTab, options)
    return btn
end

function Window:CreateToggle(options)
    if not self.CurrentTab then return end
    local tog = Toggle.new(self.CurrentTab, options)
    return tog
end

function Window:CreateSlider(options)
    if not self.CurrentTab then return end
    local sl = Slider.new(self.CurrentTab, options)
    return sl
end

function Window:CreateTextbox(options)
    if not self.CurrentTab then return end
    local tb = Textbox.new(self.CurrentTab, options)
    return tb
end

function Window:CreateLabel(options)
    if not self.CurrentTab then return end
    local lb = Label.new(self.CurrentTab, options)
    return lb
end

function Window:CreateDropdown(options)
    if not self.CurrentTab then return end
    local dd = Dropdown.new(self.CurrentTab, options)
    return dd
end

function Window:CreateSection(options)
    if not self.CurrentTab then return end
    local sec = Section.new(self.CurrentTab, options)
    return sec
end

function Window:CreateDivider(options)
    if not self.CurrentTab then return end
    local div = Divider.new(self.CurrentTab, options)
    return div
end

-- Expose component constructors on Window
Window.CreateButton = Window.CreateButton
Window.CreateToggle = Window.CreateToggle
Window.CreateSlider = Window.CreateSlider
Window.CreateTextbox = Window.CreateTextbox
Window.CreateLabel = Window.CreateLabel
Window.CreateDropdown = Window.CreateDropdown
Window.CreateSection = Window.CreateSection
Window.CreateDivider = Window.CreateDivider

-- // LIBRARY API
function Library:NewWindow(options)
    return Window.new(options)
end

function Library:SetTheme(theme)
    for k, v in pairs(theme) do
        Library.DefaultTheme[k] = v
    end
end

-- // Return library
return Library
