--[[
   UI Library – LoadString Ready
   All components, clean API, preserve button text style.
--]]

--// ========== SERVICES ==========
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

--// ========== INTERNAL STORAGE ==========
local Windows = {}

--// ========== LIBRARY CORE ==========
local Library = {}
Library.__index = Library

--// ========== CONSTANTS (locked) ==========
local ASSETS = {
    MarbleTexture = "133709037992585",
    CloseButtonImage = "114840795551292",
    MinimizedImage = "103591022804634",
}

--// ========== THEME (adjustable, colors locked) ==========
Library.Theme = {
    Font = Enum.Font.Bangers,
    CornerRadius = 20,
    ButtonHeight = 38,
    ButtonTransparency = 0.3,
    ShadowTransparency = 0.5,
    AccentColor = Color3.fromRGB(110,45,220),
    TextColor = Color3.fromRGB(255,255,255),
    HighlightColor = Color3.fromRGB(255,215,0),
}

--// ========== UTILITY ==========
local function Clamp(v, min, max) return math.max(min, math.min(max, v)) end
local function Round(v) return math.floor(v + 0.5) end

--// ============================================================
--//                COMPONENT CREATORS
--// ============================================================

--// BUTTON
local function CreateButton(options, parent, theme, gradient, assets)
    options = options or {}
    local text = options.Text or "Button"
    local callback = options.Callback or function() end

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0, 0, 44)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = parent

    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1,0, 0,38)
    shadow.Position = UDim2.new(0,2, 0,4)
    shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    shadow.BackgroundTransparency = 0.3
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    shadow.Parent = container
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0,10)
    sc.Parent = shadow

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0, 0,38)
    btn.Position = UDim2.new(0,0, 0,0)
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.ZIndex = 1
    btn.Parent = container
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0,10)
    bc.Parent = btn
    local grad = gradient:Clone()
    grad.Parent = btn
    local img = Instance.new("ImageLabel")
    img.Size = UDim2.fromScale(1,1)
    img.BackgroundTransparency = 1
    img.BorderSizePixel = 0
    img.Image = "https://www.roblox.com/asset-thumbnail/image?assetId="..assets.MarbleTexture.."&width=678&height=810&format=png"
    img.ImageTransparency = 0.5
    img.ScaleType = Enum.ScaleType.Stretch
    img.ZIndex = 0
    img.Parent = btn
    local ic = Instance.new("UICorner")
    ic.CornerRadius = UDim.new(0,10)
    ic.Parent = img

    -- Text shadow
    local txtShad = Instance.new("TextLabel")
    txtShad.Size = UDim2.fromScale(1,1)
    txtShad.Position = UDim2.new(0,1, 0,1)
    txtShad.BackgroundTransparency = 1
    txtShad.Font = theme.Font
    txtShad.Text = text
    txtShad.TextScaled = true
    txtShad.TextColor3 = Color3.fromRGB(0,0,0)
    txtShad.TextTransparency = 0.5
    txtShad.ZIndex = 2
    txtShad.Parent = btn

    local mainTxt = Instance.new("TextLabel")
    mainTxt.Size = UDim2.fromScale(1,1)
    mainTxt.Position = UDim2.new(0,0, 0,0)
    mainTxt.BackgroundTransparency = 1
    mainTxt.Font = theme.Font
    mainTxt.Text = text
    mainTxt.TextScaled = true
    mainTxt.TextColor3 = Color3.fromRGB(255,255,255)
    mainTxt.TextTransparency = 0
    mainTxt.ZIndex = 3
    mainTxt.Parent = btn

    btn.MouseButton1Click:Connect(function()
        mainTxt.TextColor3 = theme.HighlightColor
        btn:TweenSize(UDim2.new(1,0, 0,34), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.08, true)
        btn.Position = UDim2.new(0,0, 0,2)
        shadow:TweenSize(UDim2.new(1,0, 0,34), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.08, true)
        shadow.Position = UDim2.new(0,2, 0,2)
        task.wait(0.08)
        btn:TweenSize(UDim2.new(1,0, 0,38), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.08, true)
        btn.Position = UDim2.new(0,0, 0,0)
        shadow:TweenSize(UDim2.new(1,0, 0,38), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.08, true)
        shadow.Position = UDim2.new(0,2, 0,4)
        callback()
    end)

    local obj = {
        SetText = function(newText)
            txtShad.Text = newText
            mainTxt.Text = newText
        end,
        SetCallback = function(newCallback)
            callback = newCallback
        end,
        Highlight = function()
            mainTxt.TextColor3 = theme.HighlightColor
        end,
        Unhighlight = function()
            mainTxt.TextColor3 = Color3.fromRGB(255,255,255)
        end,
        Destroy = function()
            container:Destroy()
        end
    }
    return obj
end

--// TOGGLE (FIXED: switchBg is now a TextButton)
local function CreateToggle(options, parent, theme, gradient, assets)
    options = options or {}
    local text = options.Text or "Toggle"
    local default = options.Default or false
    local callback = options.Callback or function() end

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0, 0, 44)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = theme.Font
    label.Text = text
    label.TextScaled = true
    label.TextColor3 = theme.TextColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local switchBg = Instance.new("TextButton")
    switchBg.Size = UDim2.new(0, 50, 0, 26)
    switchBg.Position = UDim2.new(1, -60, 0.5, -13)
    switchBg.BackgroundColor3 = default and Color3.fromRGB(110,45,220) or Color3.fromRGB(80,80,90)
    switchBg.BorderSizePixel = 0
    switchBg.Text = ""
    switchBg.AutoButtonColor = false
    switchBg.Parent = container
    local sbc = Instance.new("UICorner")
    sbc.CornerRadius = UDim.new(1,0)
    sbc.Parent = switchBg

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = default and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    knob.Parent = switchBg
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1,0)
    kc.Parent = knob

    local state = default

    local function setState(newState, animate)
        state = newState
        if state then
            switchBg.BackgroundColor3 = Color3.fromRGB(110,45,220)
            if animate then
                knob:TweenPosition(UDim2.new(1, -24, 0.5, -10), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
            else
                knob.Position = UDim2.new(1, -24, 0.5, -10)
            end
        else
            switchBg.BackgroundColor3 = Color3.fromRGB(80,80,90)
            if animate then
                knob:TweenPosition(UDim2.new(0, 4, 0.5, -10), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
            else
                knob.Position = UDim2.new(0, 4, 0.5, -10)
            end
        end
        callback(state)
    end

    switchBg.MouseButton1Click:Connect(function()
        setState(not state, true)
    end)

    setState(default, false)

    local obj = {
        SetState = function(newState)
            setState(newState, true)
        end,
        GetState = function()
            return state
        end,
        Destroy = function()
            container:Destroy()
        end
    }
    return obj
end

--// SLIDER (FULLY FIXED: track and knob are now TextButtons)
local function CreateSlider(options, parent, theme)
    options = options or {}
    local text = options.Text or "Slider"
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or 50
    local callback = options.Callback or function() end

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0, 0, 60)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.8, 0, 0.4, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = theme.Font
    label.Text = text
    label.TextScaled = true
    label.TextColor3 = theme.TextColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.2, 0, 0.4, 0)
    valueLabel.Position = UDim2.new(0.8, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = theme.Font
    valueLabel.Text = tostring(default)
    valueLabel.TextScaled = true
    valueLabel.TextColor3 = theme.TextColor
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container

    -- FIX: track is now a TextButton so MouseButton1Click works
    local track = Instance.new("TextButton")
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 0.7, 0)
    track.BackgroundColor3 = Color3.fromRGB(60,60,70)
    track.BorderSizePixel = 0
    track.Text = ""
    track.AutoButtonColor = false
    track.Parent = container
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(1,0)
    tc.Parent = track

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(110,45,220)
    fill.BorderSizePixel = 0
    fill.Parent = track
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1,0)
    fc.Parent = fill

    -- FIX: knob is now a TextButton so MouseButton1Down works
    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new((default-min)/(max-min), -8, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    knob.Text = ""
    knob.AutoButtonColor = false
    knob.Parent = track
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1,0)
    kc.Parent = knob

    local dragging = false
    local value = default

    local function setValue(newVal)
        value = Clamp(newVal, min, max)
        local percent = (value - min) / (max - min)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        knob.Position = UDim2.new(percent, -8, 0.5, -8)
        valueLabel.Text = tostring(Round(value))
        callback(value)
    end

    local function updateFromMouse(input)
        local pos = input.Position.X
        local trackPos = track.AbsolutePosition.X
        local trackSize = track.AbsoluteSize.X
        local percent = Clamp((pos - trackPos) / trackSize, 0, 1)
        local newVal = min + percent * (max - min)
        setValue(newVal)
    end

    knob.MouseButton1Down:Connect(function()
        dragging = true
        local con1, con2
        con1 = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                updateFromMouse(input)
            end
        end)
        con2 = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                con1:Disconnect()
                con2:Disconnect()
            end
        end)
    end)

    track.MouseButton1Click:Connect(function(input)
        if not dragging then
            updateFromMouse(input)
        end
    end)

    setValue(default)

    local obj = {
        SetValue = setValue,
        GetValue = function() return value end,
        Destroy = function() container:Destroy() end
    }
    return obj
end

--// TEXTBOX
local function CreateTextbox(options, parent, theme, gradient, assets)
    options = options or {}
    local text = options.Text or ""
    local placeholder = options.Placeholder or "Type here..."
    local callback = options.Callback or function() end

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0, 0, 42)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.25, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = theme.Font
    label.Text = text
    label.TextScaled = true
    label.TextColor3 = theme.TextColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.7, 0, 1, 0)
    box.Position = UDim2.new(0.3, 0, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(255,255,255)
    box.BackgroundTransparency = 0.2
    box.BorderSizePixel = 0
    box.Font = theme.Font
    box.Text = placeholder
    box.TextScaled = true
    box.TextColor3 = Color3.fromRGB(180,180,190)
    box.PlaceholderText = placeholder
    box.Parent = container
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0,8)
    bc.Parent = box

    box.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(box.Text)
        end
    end)

    local obj = {
        GetText = function() return box.Text end,
        SetText = function(newText) box.Text = newText end,
        Destroy = function() container:Destroy() end
    }
    return obj
end

--// LABEL / PARAGRAPH
local function CreateLabel(options, parent, theme)
    options = options or {}
    local text = options.Text or "Label"
    local isParagraph = options.Paragraph or false

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.9, 0, 0, isParagraph and 60 or 30)
    label.BackgroundTransparency = 1
    label.BorderSizePixel = 0
    label.Font = theme.Font
    label.Text = text
    label.TextScaled = not isParagraph
    label.TextColor3 = theme.TextColor
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = isParagraph and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
    label.TextWrapped = isParagraph
    label.Parent = parent

    local obj = {
        SetText = function(newText) label.Text = newText end,
        Destroy = function() label:Destroy() end
    }
    return obj
end

--// SECTION / DIVIDER
local function CreateSection(options, parent, theme)
    options = options or {}
    local text = options.Text or ""

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0, 0, 30)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = parent

    if text and text ~= "" then
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.3, 0, 1, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Font = theme.Font
        label.Text = text
        label.TextScaled = true
        label.TextColor3 = theme.TextColor
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container

        local line = Instance.new("Frame")
        line.Size = UDim2.new(0.65, 0, 0, 2)
        line.Position = UDim2.new(0.35, 0, 0.5, -1)
        line.BackgroundColor3 = theme.TextColor
        line.BackgroundTransparency = 0.5
        line.BorderSizePixel = 0
        line.Parent = container
    else
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 2)
        line.Position = UDim2.new(0, 0, 0.5, -1)
        line.BackgroundColor3 = theme.TextColor
        line.BackgroundTransparency = 0.5
        line.BorderSizePixel = 0
        line.Parent = container
    end

    local obj = {
        Destroy = function() container:Destroy() end
    }
    return obj
end

--// ============================================================
--//                    WINDOW CREATOR
--// ============================================================

function Library:CreateWindow(options)
    options = options or {}
    local title = options.Title or "Window"
    local size = options.Size or {0.4, 0.75}
    local pos = options.Position or {0.5, 0.54}
    local theme = options.Theme or Library.Theme

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "LibraryUI"
    Gui.ResetOnSpawn = false
    Gui.IgnoreGuiInset = true
    Gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    --// Shadow
    local Shadow = Instance.new("Frame")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(pos[1], 0, pos[2], 8)
    Shadow.Size = UDim2.fromScale(size[1], size[2])
    Shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    Shadow.BackgroundTransparency = 0.5
    Shadow.BorderSizePixel = 0
    Shadow.ZIndex = 0
    Shadow.Parent = Gui
    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(0, theme.CornerRadius)
    ShadowCorner.Parent = Shadow

    --// Main Panel
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(pos[1], 0, pos[2], 0)
    Main.Size = UDim2.fromScale(size[1], size[2])
    Main.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Main.BorderSizePixel = 0
    Main.Parent = Gui
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, theme.CornerRadius)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(255,255,255)
    MainStroke.Thickness = 2
    MainStroke.Transparency = 0.3
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = Main

    local MainGradient = Instance.new("UIGradient")
    MainGradient.Rotation = 90
    MainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(110,45,220)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(176,96,244)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(236,198,255))
    }
    MainGradient.Parent = Main

    local MarbleTexture = Instance.new("ImageLabel")
    MarbleTexture.Size = UDim2.fromScale(1,1)
    MarbleTexture.BackgroundTransparency = 1
    MarbleTexture.BorderSizePixel = 0
    MarbleTexture.Image = "https://www.roblox.com/asset-thumbnail/image?assetId="..ASSETS.MarbleTexture.."&width=678&height=810&format=png"
    MarbleTexture.ImageTransparency = 0.6
    MarbleTexture.ScaleType = Enum.ScaleType.Stretch
    MarbleTexture.Parent = Main
    local MarbleCorner = Instance.new("UICorner")
    MarbleCorner.CornerRadius = UDim.new(0, theme.CornerRadius)
    MarbleCorner.Parent = MarbleTexture

    --// ===== HEADER =====
    local HeaderShadow = Instance.new("Frame")
    HeaderShadow.Name = "HeaderShadow"
    HeaderShadow.AnchorPoint = Vector2.new(0.5,0)
    HeaderShadow.Position = UDim2.new(0.5,2, -0.04,4)
    HeaderShadow.Size = UDim2.fromScale(0.5, 0.09)
    HeaderShadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    HeaderShadow.BackgroundTransparency = 0.4
    HeaderShadow.BorderSizePixel = 0
    HeaderShadow.ZIndex = 0
    HeaderShadow.Parent = Main
    local HS_corner = Instance.new("UICorner")
    HS_corner.CornerRadius = UDim.new(0, 18)
    HS_corner.Parent = HeaderShadow

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.AnchorPoint = Vector2.new(0.5,0)
    Header.Position = UDim2.new(0.5,0, -0.04,0)
    Header.Size = UDim2.fromScale(0.5, 0.09)
    Header.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Header.BorderSizePixel = 0
    Header.Parent = Main
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 18)
    HeaderCorner.Parent = Header
    local HeaderGrad = MainGradient:Clone()
    HeaderGrad.Parent = Header

    local HeaderMarble = Instance.new("ImageLabel")
    HeaderMarble.Size = UDim2.fromScale(1,1)
    HeaderMarble.BackgroundTransparency = 1
    HeaderMarble.BorderSizePixel = 0
    HeaderMarble.Image = "https://www.roblox.com/asset-thumbnail/image?assetId="..ASSETS.MarbleTexture.."&width=678&height=810&format=png"
    HeaderMarble.ImageTransparency = 0.6
    HeaderMarble.ScaleType = Enum.ScaleType.Stretch
    HeaderMarble.Parent = Header
    local HM_corner = Instance.new("UICorner")
    HM_corner.CornerRadius = UDim.new(0, 18)
    HM_corner.Parent = HeaderMarble

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.AnchorPoint = Vector2.new(0.5,0.5)
    TitleLabel.Position = UDim2.fromScale(0.5,0.5)
    TitleLabel.Size = UDim2.fromScale(0.9,0.8)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = theme.Font
    TitleLabel.Text = title
    TitleLabel.TextScaled = true
    TitleLabel.TextColor3 = theme.TextColor
    TitleLabel.Parent = Header

    --// ===== CLOSE/MINIMIZE BUTTON =====
    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.AnchorPoint = Vector2.new(0.5,0.5)
    CloseBtn.Position = UDim2.new(1,0, 0,0)
    CloseBtn.Size = UDim2.fromOffset(56,56)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Image = "https://www.roblox.com/asset-thumbnail/image?assetId="..ASSETS.CloseButtonImage.."&width=678&height=810&format=png"
    CloseBtn.ScaleType = Enum.ScaleType.Fit
    CloseBtn.ZIndex = 10
    CloseBtn.Parent = Main
    local CB_corner = Instance.new("UICorner")
    CB_corner.CornerRadius = UDim.new(1,0)
    CB_corner.Parent = CloseBtn
    CloseBtn.MouseEnter:Connect(function() CloseBtn:TweenSize(UDim2.fromOffset(62,62), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true) end)
    CloseBtn.MouseLeave:Connect(function() CloseBtn:TweenSize(UDim2.fromOffset(56,56), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true) end)

    --// ===== MINIMIZED FRAME =====
    local Minimized = Instance.new("ImageButton")
    Minimized.Name = "Minimized"
    Minimized.AnchorPoint = Vector2.new(1,0)
    Minimized.Position = UDim2.new(1,-20, 0,20)
    Minimized.Size = UDim2.fromOffset(60,60)
    Minimized.BackgroundTransparency = 1
    Minimized.BorderSizePixel = 0
    Minimized.Visible = false
    Minimized.ZIndex = 100
    Minimized.Image = "https://www.roblox.com/asset-thumbnail/image?assetId="..ASSETS.MinimizedImage.."&width=678&height=810&format=png"
    Minimized.ScaleType = Enum.ScaleType.Fit
    Minimized.Parent = Gui
    local M_corner = Instance.new("UICorner")
    M_corner.CornerRadius = UDim.new(1,0)
    M_corner.Parent = Minimized
    local M_stroke = Instance.new("UIStroke")
    M_stroke.Color = Color3.fromRGB(255,255,255)
    M_stroke.Thickness = 2
    M_stroke.Transparency = 0.3
    M_stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    M_stroke.Parent = Minimized

    --// ===== SIDE PANEL (Tabs) =====
    local SideShadow = Instance.new("Frame")
    SideShadow.Name = "SideShadow"
    SideShadow.AnchorPoint = Vector2.new(1,0.5)
    SideShadow.Position = UDim2.new(0,-12, 0.5,8)
    SideShadow.Size = UDim2.fromScale(0.3, 0.90)
    SideShadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    SideShadow.BackgroundTransparency = 0.45
    SideShadow.BorderSizePixel = 0
    SideShadow.ZIndex = 0
    SideShadow.Parent = Main
    local SS_corner = Instance.new("UICorner")
    SS_corner.CornerRadius = UDim.new(0,16)
    SS_corner.Parent = SideShadow

    local Side = Instance.new("Frame")
    Side.Name = "Side"
    Side.AnchorPoint = Vector2.new(1,0.5)
    Side.Position = UDim2.new(0,-12, 0.5,0)
    Side.Size = UDim2.fromScale(0.3, 0.90)
    Side.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Side.BackgroundTransparency = 0.15
    Side.BorderSizePixel = 0
    Side.Parent = Main
    local SideCorner = Instance.new("UICorner")
    SideCorner.CornerRadius = UDim.new(0,16)
    SideCorner.Parent = Side
    local SideStroke = Instance.new("UIStroke")
    SideStroke.Color = Color3.fromRGB(255,255,255)
    SideStroke.Thickness = 2
    SideStroke.Transparency = 0.3
    SideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SideStroke.Parent = Side
    local SideGrad = MainGradient:Clone()
    SideGrad.Parent = Side
    local SideMarble = Instance.new("ImageLabel")
    SideMarble.Size = UDim2.fromScale(1,1)
    SideMarble.BackgroundTransparency = 1
    SideMarble.BorderSizePixel = 0
    SideMarble.Image = "https://www.roblox.com/asset-thumbnail/image?assetId="..ASSETS.MarbleTexture.."&width=678&height=810&format=png"
    SideMarble.ImageTransparency = 0.6
    SideMarble.ScaleType = Enum.ScaleType.Stretch
    SideMarble.Parent = Side
    local SM_corner = Instance.new("UICorner")
    SM_corner.CornerRadius = UDim.new(0,16)
    SM_corner.Parent = SideMarble

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Name = "TabScroll"
    Scroll.Size = UDim2.new(1,0, 1,0)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 4
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(180,120,255)
    Scroll.CanvasSize = UDim2.new(0,0,0,0)
    Scroll.Parent = Side
    local Pad = Instance.new("UIPadding")
    Pad.PaddingTop = UDim.new(0,12)
    Pad.PaddingBottom = UDim.new(0,12)
    Pad.PaddingLeft = UDim.new(0,8)
    Pad.PaddingRight = UDim.new(0,8)
    Pad.Parent = Scroll
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0,4)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.VerticalAlignment = Enum.VerticalAlignment.Top
    Layout.Parent = Scroll

    --// ===== CONTENT AREA =====
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.AnchorPoint = Vector2.new(0,0)
    ContentArea.Position = UDim2.new(0,0, 0,0)
    ContentArea.Size = UDim2.new(0.65,0, 1,0)
    ContentArea.BackgroundTransparency = 1
    ContentArea.BorderSizePixel = 0
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = Main

    local ContentPad = Instance.new("UIPadding")
    ContentPad.PaddingTop = UDim.new(0,20)
    ContentPad.PaddingBottom = UDim.new(0,20)
    ContentPad.PaddingLeft = UDim.new(0,20)
    ContentPad.PaddingRight = UDim.new(0,20)
    ContentPad.Parent = ContentArea

    local ContentScroll = Instance.new("ScrollingFrame")
    ContentScroll.Name = "ContentScroll"
    ContentScroll.Size = UDim2.new(1,0, 1,0)
    ContentScroll.BackgroundTransparency = 1
    ContentScroll.BorderSizePixel = 0
    ContentScroll.ScrollBarThickness = 4
    ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(180,120,255)
    ContentScroll.CanvasSize = UDim2.new(0,0,0,0)
    ContentScroll.Parent = ContentArea
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0,12)
    ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ContentLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    ContentLayout.Parent = ContentScroll

    --// ===== WINDOW OBJECT =====
    local self = {
        Gui = Gui,
        Main = Main,
        Shadow = Shadow,
        Header = Header,
        TitleLabel = TitleLabel,
        CloseBtn = CloseBtn,
        Minimized = Minimized,
        Side = Side,
        Scroll = Scroll,
        ContentScroll = ContentScroll,
        ContentLayout = ContentLayout,
        Tabs = {},
        ActiveTab = nil,
        Theme = theme,
        Size = size,
        Position = pos,
        SetHeader = function(text) TitleLabel.Text = text end,
    }

    --// ===== MINIMIZE / RESTORE =====
    CloseBtn.MouseButton1Click:Connect(function()
        local targetPos = UDim2.new(1, -40, 0, 40)
        local targetSize = UDim2.fromScale(0.05, 0.05)
        local info = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        TweenService:Create(Main, info, {Size = targetSize, Position = targetPos}):Play()
        TweenService:Create(Shadow, info, {Size = targetSize, Position = targetPos}):Play()
        task.wait(0.3)
        Main.Visible = false
        Shadow.Visible = false
        Minimized.Visible = true
        Minimized.Size = UDim2.fromOffset(0,0)
        Minimized:TweenSize(UDim2.fromOffset(60,60), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
    end)

    Minimized.MouseButton1Click:Connect(function()
        Minimized.Visible = false
        Main.Size = UDim2.fromScale(self.Size[1], self.Size[2])
        Main.Position = UDim2.new(self.Position[1], 0, self.Position[2], 0)
        Shadow.Size = UDim2.fromScale(self.Size[1], self.Size[2])
        Shadow.Position = UDim2.new(self.Position[1], 0, self.Position[2], 8)
        Main.Visible = true
        Shadow.Visible = true
        Main.Size = UDim2.fromScale(0.05,0.05)
        Main.Position = UDim2.new(1, -40, 0, 40)
        Shadow.Size = UDim2.fromScale(0.05,0.05)
        Shadow.Position = UDim2.new(1, -40, 0, 40)
        local info = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0)
        TweenService:Create(Main, info, {Size = UDim2.fromScale(self.Size[1], self.Size[2]), Position = UDim2.new(self.Position[1], 0, self.Position[2], 0)}):Play()
        TweenService:Create(Shadow, info, {Size = UDim2.fromScale(self.Size[1], self.Size[2]), Position = UDim2.new(self.Position[1], 0, self.Position[2], 8)}):Play()
    end)

    --// ===== TAB SYSTEM =====
    function self:CreateTab(options)
        options = options or {}
        local tabTitle = options.Title or "Tab"
        local tabId = #self.Tabs + 1

        local windowTheme = self.Theme
        local windowGradient = MainGradient
        local windowAssets = ASSETS

        local Container = Instance.new("Frame")
        Container.Name = "TabContainer_"..tabId
        Container.Size = UDim2.new(0.9, 0, 0, 42)
        Container.BackgroundTransparency = 1
        Container.BorderSizePixel = 0
        Container.Parent = self.Scroll

        local btnShadow = Instance.new("Frame")
        btnShadow.Name = "TabShadow"
        btnShadow.Size = UDim2.new(1,0, 0,38)
        btnShadow.Position = UDim2.new(0,2, 0,4)
        btnShadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
        btnShadow.BackgroundTransparency = 0.3
        btnShadow.BorderSizePixel = 0
        btnShadow.ZIndex = 0
        btnShadow.Parent = Container
        local bsc = Instance.new("UICorner")
        bsc.CornerRadius = UDim.new(0,10)
        bsc.Parent = btnShadow

        local btn = Instance.new("TextButton")
        btn.Name = "TabButton"
        btn.Size = UDim2.new(1,0, 0,38)
        btn.Position = UDim2.new(0,0, 0,0)
        btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.ZIndex = 1
        btn.Parent = Container
        local btnc = Instance.new("UICorner")
        btnc.CornerRadius = UDim.new(0,10)
        btnc.Parent = btn
        local btnGrad = windowGradient:Clone()
        btnGrad.Parent = btn
        local btnImg = Instance.new("ImageLabel")
        btnImg.Size = UDim2.fromScale(1,1)
        btnImg.BackgroundTransparency = 1
        btnImg.BorderSizePixel = 0
        btnImg.Image = "https://www.roblox.com/asset-thumbnail/image?assetId="..windowAssets.MarbleTexture.."&width=678&height=810&format=png"
        btnImg.ImageTransparency = 0.5
        btnImg.ScaleType = Enum.ScaleType.Stretch
        btnImg.ZIndex = 0
        btnImg.Parent = btn
        local bic = Instance.new("UICorner")
        bic.CornerRadius = UDim.new(0,10)
        bic.Parent = btnImg

        local txtShadow = Instance.new("TextLabel")
        txtShadow.Size = UDim2.fromScale(1,1)
        txtShadow.Position = UDim2.new(0,1, 0,1)
        txtShadow.BackgroundTransparency = 1
        txtShadow.Font = windowTheme.Font
        txtShadow.Text = tabTitle
        txtShadow.TextScaled = true
        txtShadow.TextColor3 = Color3.fromRGB(0,0,0)
        txtShadow.TextTransparency = 0.5
        txtShadow.ZIndex = 2
        txtShadow.Parent = btn

        local mainTxt = Instance.new("TextLabel")
        mainTxt.Size = UDim2.fromScale(1,1)
        mainTxt.Position = UDim2.new(0,0, 0,0)
        mainTxt.BackgroundTransparency = 1
        mainTxt.Font = windowTheme.Font
        mainTxt.Text = tabTitle
        mainTxt.TextScaled = true
        mainTxt.TextColor3 = Color3.fromRGB(255,255,255)
        mainTxt.TextTransparency = 0
        mainTxt.ZIndex = 3
        mainTxt.Parent = btn

        local contentFrame = Instance.new("Frame")
        contentFrame.Name = "TabContent_"..tabId
        contentFrame.Size = UDim2.new(1,0, 1,0)
        contentFrame.BackgroundTransparency = 1
        contentFrame.BorderSizePixel = 0
        contentFrame.Visible = false
        contentFrame.Parent = self.ContentScroll
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.Padding = UDim.new(0,8)
        tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        tabLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        tabLayout.Parent = contentFrame
        local tabPad = Instance.new("UIPadding")
        tabPad.PaddingTop = UDim.new(0,4)
        tabPad.PaddingBottom = UDim.new(0,4)
        tabPad.PaddingLeft = UDim.new(0,8)
        tabPad.PaddingRight = UDim.new(0,8)
        tabPad.Parent = contentFrame

        local tabObj = {
            Id = tabId,
            Title = tabTitle,
            Button = btn,
            MainText = mainTxt,
            Content = contentFrame,
            Layout = tabLayout,
            Components = {},
            Active = false,
        }

        btn.MouseButton1Click:Connect(function()
            self:SwitchTab(tabId)
        end)

        table.insert(self.Tabs, tabObj)
        self:UpdateCanvas()

        local api = {}

        function api:CreateButton(options)
            return CreateButton(options, contentFrame, windowTheme, windowGradient, windowAssets)
        end

        function api:CreateToggle(options)
            return CreateToggle(options, contentFrame, windowTheme, windowGradient, windowAssets)
        end

        function api:CreateSlider(options)
            return CreateSlider(options, contentFrame, windowTheme)
        end

        function api:CreateTextbox(options)
            return CreateTextbox(options, contentFrame, windowTheme, windowGradient, windowAssets)
        end

        function api:CreateLabel(options)
            return CreateLabel(options, contentFrame, windowTheme)
        end

        function api:CreateSection(options)
            return CreateSection(options, contentFrame, windowTheme)
        end

        if #self.Tabs == 1 then
            self:SwitchTab(1)
        end

        return api
    end

    function self:SwitchTab(id)
        for _, tab in ipairs(self.Tabs) do
            tab.Content.Visible = false
            tab.MainText.TextColor3 = Color3.fromRGB(255,255,255)
            tab.Active = false
        end
        local tab = self.Tabs[id]
        if tab then
            tab.Content.Visible = true
            tab.MainText.TextColor3 = self.Theme.HighlightColor
            tab.Active = true
            self.ActiveTab = id
            self.TitleLabel.Text = tab.Title
            self:UpdateContentCanvas()
        end
    end

    function self:UpdateCanvas()
        local total = 0
        for _, child in pairs(self.Scroll:GetChildren()) do
            if child:IsA("Frame") and child.Name:find("TabContainer") then
                total = total + child.Size.Y.Offset + 4
            end
        end
        self.Scroll.CanvasSize = UDim2.new(0,0,0,total + 24)
    end

    function self:UpdateContentCanvas()
        local total = 0
        for _, child in pairs(self.ContentScroll:GetChildren()) do
            if child:IsA("Frame") and child.Name:find("TabContent") and child.Visible then
                local subTotal = 0
                for _, sub in pairs(child:GetChildren()) do
                    if sub:IsA("Frame") or sub:IsA("TextButton") or sub:IsA("TextLabel") or sub:IsA("TextBox") then
                        subTotal = subTotal + sub.Size.Y.Offset + 8
                    end
                end
                total = total + subTotal
            end
        end
        self.ContentScroll.CanvasSize = UDim2.new(0,0,0,total + 40)
    end

    function self:Destroy()
        self.Gui:Destroy()
    end

    table.insert(Windows, self)
    return self
end

--// ========== RETURN LIBRARY ==========
return Library
