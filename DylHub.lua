-- =====================================================================
-- CONCEPT UI LIBRARY
-- A complete, modular UI library for Roblox.
-- Load with: 
--   local ConceptUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/ConceptUI/main/Main.lua"))()
--   local ui = ConceptUI.new(config)
--   ui:Create()
-- =====================================================================

local ConceptUI = {}
ConceptUI.__index = ConceptUI

-- ---------------------------------------------------------------------
-- 1. THEME
-- ---------------------------------------------------------------------
local Theme = {}

Theme.Colors = {
	Background = Color3.fromRGB(30, 30, 30),
	Primary = Color3.fromRGB(110, 45, 220),
	Secondary = Color3.fromRGB(176, 96, 244),
	Accent = Color3.fromRGB(255, 70, 160),
	Text = Color3.fromRGB(255, 255, 255),
	TextDim = Color3.fromRGB(150, 150, 150),
	Stroke = Color3.fromRGB(60, 60, 60),
	Surface = Color3.fromRGB(40, 40, 40),
	Success = Color3.fromRGB(0, 200, 100),
	Danger = Color3.fromRGB(255, 70, 160),
	Warning = Color3.fromRGB(255, 200, 0),
}

function Theme:GetColor(name)
	return self.Colors[name] or Color3.fromRGB(255, 255, 255)
end

function Theme:SetColor(name, color)
	self.Colors[name] = color
end

-- ---------------------------------------------------------------------
-- 2. UTILITY FUNCTIONS
-- ---------------------------------------------------------------------
local function Create(class, props)
	local obj = Instance.new(class)
	for k, v in pairs(props) do
		obj[k] = v
	end
	return obj
end

local function Tween(obj, props, time, style, direction)
	local ts = game:GetService("TweenService")
	local info = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
	local tween = ts:Create(obj, info, props)
	tween:Play()
	return tween
end

local function GetGradient()
	local g = Instance.new("UIGradient")
	g.Rotation = 90
	g.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(110,45,220)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(176,96,244)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(236,198,255)),
	}
	return g
end

local function AddMarble(obj, assetId, transparency)
	local img = Instance.new("ImageLabel")
	img.Size = UDim2.fromScale(1, 1)
	img.BackgroundTransparency = 1
	img.BorderSizePixel = 0
	img.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. assetId .. "&width=678&height=810&format=png"
	img.ImageTransparency = transparency or 0.6
	img.ScaleType = Enum.ScaleType.Stretch
	img.Parent = obj
	local corner = Instance.new("UICorner")
	corner.CornerRadius = obj:FindFirstChild("UICorner") and obj.UICorner.CornerRadius or UDim.new(0, 0)
	corner.Parent = img
	return img
end

-- ---------------------------------------------------------------------
-- 3. COMPONENTS
-- ---------------------------------------------------------------------

-- 3.1 ButtonFrame – Row Template (no description)
local ButtonFrame = {}
ButtonFrame.__index = ButtonFrame

function ButtonFrame.new(parent, title, holderSize)
	local self = setmetatable({}, ButtonFrame)
	
	self.Main = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 25),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BackgroundTransparency = 1,
		Parent = parent,
	})
	
	self.Title = Create("TextLabel", {
		Size = UDim2.new(0.5, 0, 0, 16),
		Position = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = title or "Title",
		TextSize = 13,
		TextColor3 = Theme:GetColor("Text"),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = self.Main,
	})
	
	self.Holder = Create("Frame", {
		Size = UDim2.new(0, holderSize or 150, 1, 0),
		Position = UDim2.new(1, -10, 0, 0),
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Parent = self.Main,
	})
	
	return self
end

function ButtonFrame:GetHolder()
	return self.Holder
end

function ButtonFrame:GetMain()
	return self.Main
end

-- 3.2 Toggle
local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(parent, title, defaultValue, callback)
	local self = setmetatable({}, Toggle)
	
	local row = ButtonFrame.new(parent, title, 50)
	self.Row = row
	self.Holder = row:GetHolder()
	self.Value = defaultValue or false
	self.Callback = callback or function() end
	
	self.Switch = Create("TextButton", {
		Size = UDim2.new(0, 35, 0, 18),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		BackgroundColor3 = Theme:GetColor("Stroke"),
		BackgroundTransparency = 0,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Parent = self.Holder,
	})
	local switchCorner = Instance.new("UICorner")
	switchCorner.CornerRadius = UDim.new(0.5, 0)
	switchCorner.Parent = self.Switch
	
	self.Knob = Create("Frame", {
		Size = UDim2.new(0, 12, 0, 12),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = self.Switch,
	})
	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(0.5, 0)
	knobCorner.Parent = self.Knob
	
	self:SetValue(self.Value)
	
	self.Switch.MouseButton1Click:Connect(function()
		self:Toggle()
	end)
	
	return self
end

function Toggle:GetKnobPosition()
	if self.Value then
		return UDim2.new(0.8, 0, 0.5, 0)
	else
		return UDim2.new(0.2, 0, 0.5, 0)
	end
end

function Toggle:Toggle()
	self.Value = not self.Value
	self:SetValue(self.Value)
	self.Callback(self.Value)
end

function Toggle:SetValue(value)
	self.Value = value
	self.Switch.BackgroundColor3 = self.Value and Theme:GetColor("Accent") or Theme:GetColor("Stroke")
	local targetPos = self:GetKnobPosition()
	Tween(self.Knob, {Position = targetPos}, 0.15)
end

function Toggle:GetValue()
	return self.Value
end

-- 3.3 Slider
local Slider = {}
Slider.__index = Slider

function Slider.new(parent, title, min, max, defaultValue, callback)
	local self = setmetatable({}, Slider)
	
	local row = ButtonFrame.new(parent, title, 150)
	self.Row = row
	self.Holder = row:GetHolder()
	self.Min = min or 0
	self.Max = max or 100
	self.Value = defaultValue or 50
	self.Callback = callback or function() end
	self.Active = false
	
	self.Bar = Create("Frame", {
		Size = UDim2.new(1, -20, 0, 6),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		BackgroundColor3 = Theme:GetColor("Stroke"),
		BorderSizePixel = 0,
		Parent = self.Holder,
	})
	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(0.5, 0)
	barCorner.Parent = self.Bar
	
	self.Fill = Create("Frame", {
		Size = UDim2.fromScale(0.5, 1),
		BackgroundColor3 = Theme:GetColor("Accent"),
		BorderSizePixel = 0,
		Parent = self.Bar,
	})
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0.5, 0)
	fillCorner.Parent = self.Fill
	
	self.Knob = Create("Frame", {
		Size = UDim2.new(0, 14, 0, 14),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(220, 220, 220),
		BorderSizePixel = 0,
		Parent = self.Bar,
	})
	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(0.5, 0)
	knobCorner.Parent = self.Knob
	
	self.ValueLabel = Create("TextLabel", {
		Size = UDim2.new(0, 30, 1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = tostring(self.Value),
		TextSize = 11,
		TextColor3 = Theme:GetColor("Text"),
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = self.Holder,
	})
	
	self:SetValue(self.Value)
	self:SetupDragging()
	
	return self
end

function Slider:SetupDragging()
	local uis = game:GetService("UserInputService")
	
	self.Knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Active = true
		end
	end)
	
	self.Knob.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.Active = false
		end
	end)
	
	self.Bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:UpdateFromMouse(input.Position.X)
		end
	end)
	
	uis.InputChanged:Connect(function(input)
		if self.Active and input.UserInputType == Enum.UserInputType.MouseMovement then
			self:UpdateFromMouse(input.Position.X)
		end
	end)
end

function Slider:UpdateFromMouse(mouseX)
	local barPos = self.Bar.AbsolutePosition.X
	local barWidth = self.Bar.AbsoluteSize.X
	local clamped = math.clamp((mouseX - barPos) / barWidth, 0, 1)
	self:SetValue(self.Min + (self.Max - self.Min) * clamped)
end

function Slider:SetValue(value)
	self.Value = math.clamp(value, self.Min, self.Max)
	local normalized = (self.Value - self.Min) / (self.Max - self.Min)
	self.Fill.Size = UDim2.fromScale(normalized, 1)
	self.Knob.Position = UDim2.fromScale(normalized, 0.5)
	self.ValueLabel.Text = tostring(math.floor(self.Value))
	self.Callback(self.Value)
end

function Slider:GetValue()
	return self.Value
end

-- 3.4 Dropdown (with floating panel)
local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(parent, title, options, defaultIndex, callback)
	local self = setmetatable({}, Dropdown)
	
	local row = ButtonFrame.new(parent, title, 160)
	self.Row = row
	self.Holder = row:GetHolder()
	self.Options = options or {"Option 1", "Option 2", "Option 3"}
	self.SelectedIndex = defaultIndex or 1
	self.Callback = callback or function() end
	self.Open = false
	self.Panel = nil  -- floating panel
	
	self.Display = Create("TextButton", {
		Size = UDim2.new(1, 0, 0, 22),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		BackgroundColor3 = Theme:GetColor("Surface"),
		BackgroundTransparency = 0.3,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Text = self.Options[self.SelectedIndex],
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = Theme:GetColor("Text"),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = self.Holder,
	})
	local displayPadding = Instance.new("UIPadding")
	displayPadding.PaddingLeft = UDim.new(0, 8)
	displayPadding.Parent = self.Display
	local displayCorner = Instance.new("UICorner")
	displayCorner.CornerRadius = UDim.new(0, 4)
	displayCorner.Parent = self.Display
	
	self.Arrow = Create("ImageLabel", {
		Image = "rbxassetid://10709791523",
		Size = UDim2.new(0, 12, 0, 12),
		Position = UDim2.new(1, -8, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Parent = self.Display,
	})
	
	self.Display.MouseButton1Click:Connect(function()
		self:Toggle()
	end)
	
	return self
end

function Dropdown:Toggle()
	self.Open = not self.Open
	if self.Open then
		self:CreatePanel()
	else
		self:DestroyPanel()
	end
	self.Arrow.Rotation = self.Open and 180 or 0
end

function Dropdown:CreatePanel()
	if self.Panel then return end
	
	-- Get the main GUI (parent of the dropdown's row)
	local gui = self.Row.Main.Parent
	while gui and not gui:IsA("ScreenGui") do
		gui = gui.Parent
	end
	if not gui then return end
	
	-- Position the panel to the right of the dropdown display
	local displayPos = self.Display.AbsolutePosition
	local displaySize = self.Display.AbsoluteSize
	local panelWidth = 180
	local panelHeight = math.min(#self.Options * 26 + 10, 150)
	
	-- Create floating panel
	local panel = Create("Frame", {
		Size = UDim2.new(0, panelWidth, 0, panelHeight),
		Position = UDim2.new(0, displayPos.X + displaySize.X + 10, 0, displayPos.Y - 5),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ZIndex = 100,
		Parent = gui,
	})
	local panelCorner = Instance.new("UICorner")
	panelCorner.CornerRadius = UDim.new(0, 8)
	panelCorner.Parent = panel
	
	-- Gradient
	local grad = GetGradient()
	grad.Parent = panel
	
	-- Marble texture
	AddMarble(panel, "133709037992585", 0.5)
	
	-- White stroke
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255,255,255)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.4
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = panel
	
	-- Shadow behind panel (subtle)
	local shadow = Create("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 4, 0, 4),
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		ZIndex = -1,
		Parent = panel,
	})
	local shadowCorner = Instance.new("UICorner")
	shadowCorner.CornerRadius = UDim.new(0, 8)
	shadowCorner.Parent = shadow
	
	-- ScrollingFrame for options
	local scroll = Create("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 3,
		ZIndex = 2,
		Parent = panel,
	})
	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 4)
	pad.PaddingBottom = UDim.new(0, 4)
	pad.PaddingLeft = UDim.new(0, 4)
	pad.PaddingRight = UDim.new(0, 4)
	pad.Parent = scroll
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 2)
	layout.Parent = scroll
	
	-- Populate options
	local totalHeight = 0
	for i, option in ipairs(self.Options) do
		local btn = Create("TextButton", {
			Size = UDim2.new(1, 0, 0, 22),
			BackgroundColor3 = Color3.fromRGB(255,255,255),
			BackgroundTransparency = 0.95,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Text = option,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = Theme:GetColor("Text"),
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 3,
			Parent = scroll,
		})
		local pad2 = Instance.new("UIPadding")
		pad2.PaddingLeft = UDim.new(0, 8)
		pad2.Parent = btn
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = btn
		
		if i == self.SelectedIndex then
			btn.BackgroundColor3 = Theme:GetColor("Accent")
			btn.BackgroundTransparency = 0.3
		end
		
		btn.MouseEnter:Connect(function()
			if i ~= self.SelectedIndex then
				btn.BackgroundTransparency = 0.9
			end
		end)
		btn.MouseLeave:Connect(function()
			if i ~= self.SelectedIndex then
				btn.BackgroundTransparency = 0.95
			end
		end)
		
		btn.MouseButton1Click:Connect(function()
			self:Select(i)
		end)
		
		totalHeight = totalHeight + 22 + 2
	end
	scroll.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
	
	self.Panel = panel
end

function Dropdown:DestroyPanel()
	if self.Panel then
		self.Panel:Destroy()
		self.Panel = nil
	end
end

function Dropdown:Select(index)
	self.SelectedIndex = index
	self.Display.Text = self.Options[index]
	self.Callback(self.Options[index], index)
	if self.Open then
		self:Toggle() -- closes panel
	end
end

function Dropdown:GetValue()
	return self.Options[self.SelectedIndex]
end

-- 3.5 Button
local Button = {}
Button.__index = Button

function Button.new(parent, title, callback, icon)
	local self = setmetatable({}, Button)
	
	self.Main = Create("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = Theme:GetColor("Background"),
		BackgroundTransparency = 0.8,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Text = "",
		Parent = parent,
	})
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = self.Main
	
	self.Title = Create("TextLabel", {
		Size = UDim2.new(1, -10, 0, 0),
		Position = UDim2.new(0, 10, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = title or "Button",
		TextSize = 12,
		TextColor3 = Theme:GetColor("Text"),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = self.Main,
	})
	
	if icon then
		self.Icon = Create("ImageLabel", {
			Image = icon,
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			Parent = self.Main,
		})
	end
	
	self.Main.MouseEnter:Connect(function()
		self.Main.BackgroundTransparency = 0.4
	end)
	self.Main.MouseLeave:Connect(function()
		self.Main.BackgroundTransparency = 0.8
	end)
	
	self.Main.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)
	
	return self
end

function Button:SetTitle(newTitle)
	self.Title.Text = newTitle
end

function Button:GetMain()
	return self.Main
end

-- 3.6 TextBox
local TextBox = {}
TextBox.__index = TextBox

function TextBox.new(parent, title, placeholder, callback)
	local self = setmetatable({}, TextBox)
	
	local row = ButtonFrame.new(parent, title, 150)
	self.Row = row
	self.Holder = row:GetHolder()
	self.Callback = callback or function() end
	
	self.Input = Create("TextBox", {
		Size = UDim2.new(1, 0, 0, 22),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		BackgroundColor3 = Theme:GetColor("Surface"),
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = Theme:GetColor("Text"),
		PlaceholderColor3 = Theme:GetColor("TextDim"),
		PlaceholderText = placeholder or "Enter text...",
		Text = "",
		Parent = self.Holder,
	})
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = self.Input
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 8)
	padding.Parent = self.Input
	
	self.Input.FocusLost:Connect(function(enterPressed)
		self.Callback(self.Input.Text, enterPressed)
	end)
	
	return self
end

function TextBox:SetText(text)
	self.Input.Text = text
end

function TextBox:GetText()
	return self.Input.Text
end

-- ---------------------------------------------------------------------
-- 4. MAIN CONCEPT UI CLASS
-- ---------------------------------------------------------------------

function ConceptUI.new(config)
	local self = setmetatable({}, ConceptUI)
	self.Config = config or {}
	self.Config.Tabs = self.Config.Tabs or {"Home", "Settings", "Profile", "Controls"}
	self.Config.Position = self.Config.Position or UDim2.fromScale(0.5, 0.54)
	self.Config.Size = self.Config.Size or UDim2.fromScale(0.4, 0.75)
	self.Config.MarbleTexture = self.Config.MarbleTexture or "133709037992585"
	self.Config.CloseImage = self.Config.CloseImage or "114840795551292"
	self.Config.MinimizeImage = self.Config.MinimizeImage or "103591022804634"
	
	self.Tabs = {}
	self.TabButtons = {}
	self.CurrentTab = nil
	self.Main = nil
	self.SidePanel = nil
	self.TabContainer = nil
	self.TitleLabel = nil
	self.Callbacks = {
		TabSelected = function() end,
		Minimize = function() end,
		Restore = function() end,
	}
	self.Components = {
		Toggle = Toggle,
		Slider = Slider,
		Dropdown = Dropdown,
		Button = Button,
		TextBox = TextBox,
	}
	return self
end

function ConceptUI:OnTabSelected(callback)
	self.Callbacks.TabSelected = callback
end

function ConceptUI:OnMinimize(callback)
	self.Callbacks.Minimize = callback
end

function ConceptUI:OnRestore(callback)
	self.Callbacks.Restore = callback
end

function ConceptUI:Create()
	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local Player = Players.LocalPlayer
	local PlayerGui = Player:WaitForChild("PlayerGui")
	
	local Gui = Instance.new("ScreenGui")
	Gui.Name = "ConceptUI"
	Gui.ResetOnSpawn = false
	Gui.IgnoreGuiInset = true
	Gui.Parent = PlayerGui
	
	-- Shadow for main panel
	local Shadow = Create("Frame", {
		Name = "Shadow",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = self.Config.Position + UDim2.new(0, 0, 0, 8),
		Size = self.Config.Size,
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		ZIndex = 0,
		Parent = Gui,
	})
	local shadowCorner = Instance.new("UICorner")
	shadowCorner.CornerRadius = UDim.new(0, 20)
	shadowCorner.Parent = Shadow
	
	-- Main panel
	local Main = Create("Frame", {
		Name = "Main",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = self.Config.Position,
		Size = self.Config.Size,
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		BorderSizePixel = 0,
		Parent = Gui,
	})
	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 20)
	mainCorner.Parent = Main
	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = Color3.fromRGB(255,255,255)
	mainStroke.Thickness = 2
	mainStroke.Transparency = 0.3
	mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	mainStroke.Parent = Main
	
	-- Gradient
	local mainGradient = GetGradient()
	mainGradient.Parent = Main
	
	-- Marble texture
	AddMarble(Main, self.Config.MarbleTexture, 0.6)
	
	-- Header shadow
	local headerShadow = Create("Frame", {
		Name = "HeaderShadow",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 2, -0.04, 4),
		Size = UDim2.fromScale(0.5, 0.09),
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		ZIndex = 0,
		Parent = Main,
	})
	local headerShadowCorner = Instance.new("UICorner")
	headerShadowCorner.CornerRadius = UDim.new(0, 18)
	headerShadowCorner.Parent = headerShadow
	
	-- Header
	local Header = Create("Frame", {
		Name = "Header",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, -0.04, 0),
		Size = UDim2.fromScale(0.5, 0.09),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		BorderSizePixel = 0,
		Parent = Main,
	})
	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 18)
	headerCorner.Parent = Header
	local headerGradient = GetGradient()
	headerGradient.Parent = Header
	AddMarble(Header, self.Config.MarbleTexture, 0.6)
	
	self.TitleLabel = Create("TextLabel", {
		Name = "Title",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.9, 0.8),
		BackgroundTransparency = 1,
		Font = Enum.Font.Bangers,
		Text = "SELECT A TAB",
		TextScaled = true,
		TextColor3 = Color3.fromRGB(255,255,255),
		Parent = Header,
	})
	
	-- Close button
	local closeBtn = Create("ImageButton", {
		Name = "CloseButton",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.fromOffset(56, 56),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. self.Config.CloseImage .. "&width=678&height=810&format=png",
		ScaleType = Enum.ScaleType.Fit,
		ZIndex = 10,
		Parent = Main,
	})
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(1, 0)
	closeCorner.Parent = closeBtn
	
	-- Minimized frame
	local minimizeFrame = Create("ImageButton", {
		Name = "MinimizedFrame",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -20, 0, 20),
		Size = UDim2.fromOffset(60, 60),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 100,
		Image = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. self.Config.MinimizeImage .. "&width=678&height=810&format=png",
		ScaleType = Enum.ScaleType.Fit,
		Parent = Gui,
	})
	local minCorner = Instance.new("UICorner")
	minCorner.CornerRadius = UDim.new(1, 0)
	minCorner.Parent = minimizeFrame
	local minStroke = Instance.new("UIStroke")
	minStroke.Color = Color3.fromRGB(255,255,255)
	minStroke.Thickness = 2
	minStroke.Transparency = 0.3
	minStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	minStroke.Parent = minimizeFrame
	
	-- Side panel shadow
	local sideShadow = Create("Frame", {
		Name = "SideShadow",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(0, -12, 0.5, 8),
		Size = UDim2.fromScale(0.3, 0.90),
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		BackgroundTransparency = 0.45,
		BorderSizePixel = 0,
		ZIndex = 0,
		Parent = Main,
	})
	local sideShadowCorner = Instance.new("UICorner")
	sideShadowCorner.CornerRadius = UDim.new(0, 16)
	sideShadowCorner.Parent = sideShadow
	
	-- Side panel
	local Side = Create("Frame", {
		Name = "Side",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(0, -12, 0.5, 0),
		Size = UDim2.fromScale(0.3, 0.90),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		BackgroundTransparency = 0.15,
		BorderSizePixel = 0,
		Parent = Main,
	})
	local sideCorner = Instance.new("UICorner")
	sideCorner.CornerRadius = UDim.new(0, 16)
	sideCorner.Parent = Side
	local sideStroke = Instance.new("UIStroke")
	sideStroke.Color = Color3.fromRGB(255,255,255)
	sideStroke.Thickness = 2
	sideStroke.Transparency = 0.3
	sideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	sideStroke.Parent = Side
	local sideGradient = GetGradient()
	sideGradient.Parent = Side
	AddMarble(Side, self.Config.MarbleTexture, 0.6)
	
	-- ScrollingFrame for tabs
	local scroll = Create("ScrollingFrame", {
		Name = "TabScroll",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = Color3.fromRGB(180,120,255),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Parent = Side,
	})
	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 12)
	pad.PaddingBottom = UDim.new(0, 12)
	pad.PaddingLeft = UDim.new(0, 8)
	pad.PaddingRight = UDim.new(0, 8)
	pad.Parent = scroll
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 4)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.Parent = scroll
	
	self.SidePanel = scroll
	self.Main = Main
	self.Shadow = Shadow
	self.Gui = Gui
	self.CloseButton = closeBtn
	self.MinimizeFrame = minimizeFrame
	self.Header = Header
	self.SidePanelFrame = Side
	
	-- Store references for minimize/restore
	local selfRef = self
	
	-- Minimize/restore functions
	local function Minimize()
		local targetPos = UDim2.new(1, -40, 0, 40)
		local targetSize = UDim2.fromScale(0.05, 0.05)
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
		TweenService:Create(Main, tweenInfo, {Size = targetSize, Position = targetPos}):Play()
		TweenService:Create(Shadow, tweenInfo, {Size = targetSize, Position = targetPos}):Play()
		task.wait(0.3)
		Main.Visible = false
		Shadow.Visible = false
		minimizeFrame.Visible = true
		minimizeFrame.Size = UDim2.fromOffset(0, 0)
		Tween(minimizeFrame, {Size = UDim2.fromOffset(60, 60)}, 0.3, Enum.EasingStyle.Back)
		if selfRef.Callbacks.Minimize then selfRef.Callbacks.Minimize() end
	end
	
	local function Restore()
		minimizeFrame.Visible = false
		Main.Size = UDim2.fromScale(0.4, 0.75)
		Main.Position = self.Config.Position
		Shadow.Size = UDim2.fromScale(0.4, 0.75)
		Shadow.Position = self.Config.Position + UDim2.new(0, 0, 0, 8)
		Main.Visible = true
		Shadow.Visible = true
		Main.Size = UDim2.fromScale(0.05, 0.05)
		Main.Position = UDim2.new(1, -40, 0, 40)
		Shadow.Size = UDim2.fromScale(0.05, 0.05)
		Shadow.Position = UDim2.new(1, -40, 0, 40)
		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		TweenService:Create(Main, tweenInfo, {Size = self.Config.Size, Position = self.Config.Position}):Play()
		TweenService:Create(Shadow, tweenInfo, {Size = self.Config.Size, Position = self.Config.Position + UDim2.new(0, 0, 0, 8)}):Play()
		if selfRef.Callbacks.Restore then selfRef.Callbacks.Restore() end
	end
	
	closeBtn.MouseButton1Click:Connect(Minimize)
	minimizeFrame.MouseButton1Click:Connect(Restore)
	
	-- Populate tabs
	self:PopulateTabs()
	
	return self
end

function ConceptUI:PopulateTabs()
	-- Clear existing tab buttons
	for _, child in pairs(self.SidePanel:GetChildren()) do
		if child:IsA("Frame") and child.Name:find("Container") then
			child:Destroy()
		end
	end
	
	local ButtonHeight = 38
	local ButtonCount = #self.Config.Tabs
	
	local function ResetHighlights()
		for _, child in pairs(self.SidePanel:GetChildren()) do
			if child:IsA("Frame") and child.Name:find("Container") then
				local btn = child:FindFirstChildWhichIsA("TextButton")
				if btn then
					local mainText = btn:FindFirstChild("MainText")
					if mainText then
						mainText.TextColor3 = Color3.fromRGB(255, 255, 255)
					end
				end
			end
		end
	end
	
	local function SelectTab(index)
		ResetHighlights()
		local container = self.SidePanel:FindFirstChild("Container_" .. index)
		if container then
			local btn = container:FindFirstChildWhichIsA("TextButton")
			if btn then
				local mainText = btn:FindFirstChild("MainText")
				if mainText then
					mainText.TextColor3 = Color3.fromRGB(255, 215, 0)
				end
				self.TitleLabel.Text = self.Config.Tabs[index]
				self.Callbacks.TabSelected(self.Config.Tabs[index], index)
			end
		end
	end
	
	for i, tabName in ipairs(self.Config.Tabs) do
		local Container = Create("Frame", {
			Name = "Container_" .. i,
			Size = UDim2.new(0.9, 0, 0, ButtonHeight + 6),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = self.SidePanel,
		})
		
		local ButtonShadow = Create("Frame", {
			Name = "ButtonShadow",
			Size = UDim2.new(1, 0, 0, ButtonHeight),
			Position = UDim2.new(0, 2, 0, 4),
			BackgroundColor3 = Color3.fromRGB(0,0,0),
			BackgroundTransparency = 0.3,
			BorderSizePixel = 0,
			ZIndex = 0,
			Parent = Container,
		})
		local shadowCorner = Instance.new("UICorner")
		shadowCorner.CornerRadius = UDim.new(0, 10)
		shadowCorner.Parent = ButtonShadow
		
		local Button = Create("TextButton", {
			Name = "TabButton_" .. i,
			Size = UDim2.new(1, 0, 0, ButtonHeight),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = Color3.fromRGB(255,255,255),
			BackgroundTransparency = 0.3,
			BorderSizePixel = 0,
			Text = "",
			ZIndex = 1,
			Parent = Container,
		})
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 10)
		btnCorner.Parent = Button
		
		local btnGrad = GetGradient()
		btnGrad.Parent = Button
		AddMarble(Button, self.Config.MarbleTexture, 0.5)
		
		local textShadow = Create("TextLabel", {
			Name = "TextShadow",
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.new(0, 1, 0, 1),
			BackgroundTransparency = 1,
			Font = Enum.Font.Bangers,
			Text = tabName,
			TextScaled = true,
			TextColor3 = Color3.fromRGB(0,0,0),
			TextTransparency = 0.5,
			ZIndex = 2,
			Parent = Button,
		})
		
		local mainText = Create("TextLabel", {
			Name = "MainText",
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			Font = Enum.Font.Bangers,
			Text = tabName,
			TextScaled = true,
			TextColor3 = Color3.fromRGB(255,255,255),
			TextTransparency = 0,
			ZIndex = 3,
			Parent = Button,
		})
		
		local function AnimateButton()
			ResetHighlights()
			mainText.TextColor3 = Color3.fromRGB(255, 215, 0)
			Tween(Button, {Size = UDim2.new(1, 0, 0, ButtonHeight - 4)}, 0.08)
			Button.Position = UDim2.new(0, 0, 0, 2)
			Tween(ButtonShadow, {Size = UDim2.new(1, 0, 0, ButtonHeight - 4)}, 0.08)
			ButtonShadow.Position = UDim2.new(0, 2, 0, 2)
			task.wait(0.08)
			Tween(Button, {Size = UDim2.new(1, 0, 0, ButtonHeight)}, 0.08)
			Button.Position = UDim2.new(0, 0, 0, 0)
			Tween(ButtonShadow, {Size = UDim2.new(1, 0, 0, ButtonHeight)}, 0.08)
			ButtonShadow.Position = UDim2.new(0, 2, 0, 4)
			SelectTab(i)
		end
		
		Button.MouseButton1Click:Connect(AnimateButton)
	end
	
	if #self.Config.Tabs > 0 then
		SelectTab(1)
	end
	
	task.wait(0.1)
	local children = self.SidePanel:GetChildren()
	local totalHeight = 0
	for _, child in pairs(children) do
		if child:IsA("Frame") and child.Name:find("Container") then
			totalHeight = totalHeight + child.Size.Y.Offset + 4
		end
	end
	self.SidePanel.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 24)
end

function ConceptUI:GetTabPanel(tabName)
	if not self.TabPanels then
		self.TabPanels = {}
	end
	if not self.TabPanels[tabName] then
		local panel = Create("Frame", {
			Name = "TabPanel_" .. tabName,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Visible = false,
			Parent = self.Main,
		})
		local list = Instance.new("UIListLayout")
		list.Padding = UDim.new(0, 5)
		list.HorizontalAlignment = Enum.HorizontalAlignment.Center
		list.VerticalAlignment = Enum.VerticalAlignment.Top
		list.Parent = panel
		local pad = Instance.new("UIPadding")
		pad.PaddingTop = UDim.new(0, 10)
		pad.PaddingLeft = UDim.new(0, 10)
		pad.PaddingRight = UDim.new(0, 10)
		pad.Parent = panel
		self.TabPanels[tabName] = panel
	end
	return self.TabPanels[tabName]
end

function ConceptUI:AddToggle(config)
	local tab = self:GetTabPanel(config.Tab)
	if tab then
		return Toggle.new(tab, config.Title, config.Default, config.Callback)
	end
end

function ConceptUI:AddSlider(config)
	local tab = self:GetTabPanel(config.Tab)
	if tab then
		return Slider.new(tab, config.Title, config.Min, config.Max, config.Default, config.Callback)
	end
end

function ConceptUI:AddDropdown(config)
	local tab = self:GetTabPanel(config.Tab)
	if tab then
		return Dropdown.new(tab, config.Title, config.Options, config.Default, config.Callback)
	end
end

function ConceptUI:AddButton(config)
	local tab = self:GetTabPanel(config.Tab)
	if tab then
		return Button.new(tab, config.Title, config.Callback, config.Icon)
	end
end

function ConceptUI:AddTextBox(config)
	local tab = self:GetTabPanel(config.Tab)
	if tab then
		return TextBox.new(tab, config.Title, config.Placeholder, config.Callback)
	end
end

function ConceptUI:ShowTab(tabName)
	for name, panel in pairs(self.TabPanels) do
		panel.Visible = (name == tabName)
	end
end

function ConceptUI:Destroy()
	if self.Gui then
		self.Gui:Destroy()
	end
end

-- ---------------------------------------------------------------------
-- 5. RETURN THE LIBRARY
-- ---------------------------------------------------------------------
return ConceptUI
