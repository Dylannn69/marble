--[[
	UI LIBRARY
	Version 1.0.0
	Author: [Your Name]
	License: MIT

	-- Usage Example --
	local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/yourrepo/main/main.lua"))()
	local win = Library:CreateWindow({
		Title = "My Hub",
		Size = {0.4, 0.75},
		Theme = "Dark"
	})
	local home = win:CreateTab({Title = "Home"})
	local btn = home:CreateButton({
		Text = "Click Me",
		Callback = function() print("Clicked!") end
	})
]]

--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// LIBRARY TABLE
local Library = {}

--// THEME SYSTEM (locked colors, but user can choose from presets)
local THEMES = {
	Default = {
		Background = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.15,
		Accent = Color3.fromRGB(110, 45, 220),
		AccentDark = Color3.fromRGB(80, 30, 180),
		AccentLight = Color3.fromRGB(176, 96, 244),
		Text = Color3.fromRGB(255, 255, 255),
		TextDark = Color3.fromRGB(0, 0, 0),
		Button = Color3.fromRGB(255, 70, 160),
		ButtonHover = Color3.fromRGB(255, 100, 180),
		Shadow = Color3.fromRGB(0, 0, 0),
		ShadowTransparency = 0.5,
		Stroke = Color3.fromRGB(255, 255, 255),
		StrokeTransparency = 0.3,
		CornerRadius = 20,
		Font = Enum.Font.GothamBold,
	},
	Dark = {
		Background = Color3.fromRGB(30, 30, 40),
		BackgroundTransparency = 0.85,
		Accent = Color3.fromRGB(140, 80, 255),
		AccentDark = Color3.fromRGB(90, 40, 200),
		AccentLight = Color3.fromRGB(200, 160, 255),
		Text = Color3.fromRGB(255, 255, 255),
		TextDark = Color3.fromRGB(200, 200, 200),
		Button = Color3.fromRGB(255, 80, 180),
		ButtonHover = Color3.fromRGB(255, 110, 200),
		Shadow = Color3.fromRGB(0, 0, 0),
		ShadowTransparency = 0.6,
		Stroke = Color3.fromRGB(200, 200, 200),
		StrokeTransparency = 0.2,
		CornerRadius = 20,
		Font = Enum.Font.GothamBold,
	},
}
local CurrentTheme = THEMES.Default

--// UTILITY FUNCTIONS
local function CloneTable(t) local r={}; for k,v in pairs(t) do r[k]=v end return r end
local function MergeTables(a,b) local r=CloneTable(a); for k,v in pairs(b) do r[k]=v end return r end

local function Tween(obj, props, duration, style, direction)
	if not obj then return end
	local info = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
	local tween = TweenService:Create(obj, info, props)
	tween:Play()
	return tween
end

local function CreateShadow(parent, size, position, transparency, radius)
	local shadow = Instance.new("Frame")
	shadow.Size = size
	shadow.Position = position
	shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
	shadow.BackgroundTransparency = transparency or 0.5
	shadow.BorderSizePixel = 0
	shadow.ZIndex = 0
	shadow.Parent = parent
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 20)
	corner.Parent = shadow
	return shadow
end

local function ApplyCorner(obj, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or CurrentTheme.CornerRadius)
	c.Parent = obj
	return c
end

local function ApplyStroke(obj, color, transparency, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color or CurrentTheme.Stroke
	s.Transparency = transparency or CurrentTheme.StrokeTransparency
	s.Thickness = thickness or 2
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = obj
	return s
end

local function ApplyGradient(obj, rotation, colors)
	local g = Instance.new("UIGradient")
	g.Rotation = rotation or 90
	g.Color = colors or ColorSequence.new{
		ColorSequenceKeypoint.new(0.00, CurrentTheme.Accent),
		ColorSequenceKeypoint.new(0.45, CurrentTheme.AccentLight),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,255,255)),
	}
	g.Parent = obj
	return g
end

--// BASE COMPONENT CLASS
local Component = {}
Component.__index = Component

function Component:SetVisible(visible)
	if self._frame then
		self._frame.Visible = visible
	end
	return self
end

function Component:Destroy()
	if self._frame then self._frame:Destroy() end
	if self._container then self._container:Destroy() end
end

--// WINDOW CLASS
local Window = setmetatable({}, Component)
Window.__index = Window

function Window:__tostring()
	return "Window(" .. self._title .. ")"
end

function Window.new(config)
	local self = setmetatable({}, Window)
	self._title = config.Title or "Window"
	self._size = config.Size or {0.4, 0.75}
	self._theme = config.Theme and THEMES[config.Theme] or CurrentTheme
	self._visible = true
	self._tabs = {}
	self._currentTab = nil
	self._buttons = {}
	self._toggles = {}
	self._sliders = {}
	self._textboxes = {}
	self._labels = {}
	self._paragraphs = {}
	self._sections = {}

	-- Main GUI
	self._gui = Instance.new("ScreenGui")
	self._gui.Name = "LibraryUI"
	self._gui.ResetOnSpawn = false
	self._gui.IgnoreGuiInset = true
	self._gui.Parent = PlayerGui

	-- Shadow for main panel
	local shadowSize = UDim2.fromScale(self._size[1], self._size[2])
	local shadowPos = UDim2.new(0.5, 0, 0.54, 8)
	self._shadow = CreateShadow(self._gui, shadowSize, shadowPos, 0.5, 20)

	-- Main Frame
	self._frame = Instance.new("Frame")
	self._frame.Name = "MainFrame"
	self._frame.AnchorPoint = Vector2.new(0.5, 0.5)
	self._frame.Position = UDim2.fromScale(0.5, 0.54)
	self._frame.Size = UDim2.fromScale(self._size[1], self._size[2])
	self._frame.BackgroundColor3 = self._theme.Background
	self._frame.BackgroundTransparency = self._theme.BackgroundTransparency
	self._frame.BorderSizePixel = 0
	self._frame.Parent = self._gui
	ApplyCorner(self._frame, 20)
	ApplyStroke(self._frame)
	ApplyGradient(self._frame, 90)

	-- Marble texture overlay (locked)
	local marble = Instance.new("ImageLabel")
	marble.Size = UDim2.fromScale(1, 1)
	marble.BackgroundTransparency = 1
	marble.BorderSizePixel = 0
	marble.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=133709037992585&width=678&height=810&format=png"
	marble.ImageTransparency = 0.6
	marble.ScaleType = Enum.ScaleType.Stretch
	marble.Parent = self._frame
	ApplyCorner(marble, 20)

	-- Header Shadow
	local headerShadow = CreateShadow(self._frame, UDim2.fromScale(0.5, 0.09), UDim2.new(0.5, 2, -0.04, 4), 0.4, 18)

	-- Header
	self._header = Instance.new("Frame")
	self._header.AnchorPoint = Vector2.new(0.5, 0)
	self._header.Position = UDim2.new(0.5, 0, -0.04, 0)
	self._header.Size = UDim2.fromScale(0.5, 0.09)
	self._header.BackgroundColor3 = self._theme.Background
	self._header.BackgroundTransparency = self._theme.BackgroundTransparency
	self._header.BorderSizePixel = 0
	self._header.Parent = self._frame
	ApplyCorner(self._header, 18)
	ApplyGradient(self._header, 90)

	-- Header Marble
	local headerMarble = marble:Clone()
	headerMarble.Parent = self._header
	ApplyCorner(headerMarble, 18)

	-- Title
	self._titleLabel = Instance.new("TextLabel")
	self._titleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	self._titleLabel.Position = UDim2.fromScale(0.5, 0.5)
	self._titleLabel.Size = UDim2.fromScale(0.9, 0.8)
	self._titleLabel.BackgroundTransparency = 1
	self._titleLabel.Font = self._theme.Font
	self._titleLabel.Text = self._title
	self._titleLabel.TextScaled = true
	self._titleLabel.TextColor3 = self._theme.Text
	self._titleLabel.Parent = self._header

	-- Close/Minimize Button
	self._closeBtn = Instance.new("ImageButton")
	self._closeBtn.AnchorPoint = Vector2.new(0.5, 0.5)
	self._closeBtn.Position = UDim2.new(1, 0, 0, 0)
	self._closeBtn.Size = UDim2.fromOffset(56, 56)
	self._closeBtn.BackgroundTransparency = 1
	self._closeBtn.BorderSizePixel = 0
	self._closeBtn.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=114840795551292&width=678&height=810&format=png"
	self._closeBtn.ScaleType = Enum.ScaleType.Fit
	self._closeBtn.ZIndex = 10
	self._closeBtn.Parent = self._frame
	ApplyCorner(self._closeBtn, 100)

	self._closeBtn.MouseEnter:Connect(function()
		Tween(self._closeBtn, {Size = UDim2.fromOffset(62, 62)}, 0.15)
	end)
	self._closeBtn.MouseLeave:Connect(function()
		Tween(self._closeBtn, {Size = UDim2.fromOffset(56, 56)}, 0.15)
	end)

	-- Side Panel Shadow
	local sideShadow = CreateShadow(self._frame, UDim2.fromScale(0.3, 0.90), UDim2.new(0, -12, 0.5, 8), 0.45, 16)

	-- Side Panel (Tabs container)
	self._side = Instance.new("Frame")
	self._side.AnchorPoint = Vector2.new(1, 0.5)
	self._side.Position = UDim2.new(0, -12, 0.5, 0)
	self._side.Size = UDim2.fromScale(0.3, 0.90)
	self._side.BackgroundColor3 = self._theme.Background
	self._side.BackgroundTransparency = 0.15
	self._side.BorderSizePixel = 0
	self._side.Parent = self._frame
	ApplyCorner(self._side, 16)
	ApplyStroke(self._side)
	ApplyGradient(self._side, 90)

	-- Side marble
	local sideMarble = marble:Clone()
	sideMarble.Parent = self._side
	ApplyCorner(sideMarble, 16)

	-- Scrolling Frame for Tabs
	self._tabScroll = Instance.new("ScrollingFrame")
	self._tabScroll.Size = UDim2.new(1, 0, 1, 0)
	self._tabScroll.BackgroundTransparency = 1
	self._tabScroll.BorderSizePixel = 0
	self._tabScroll.ScrollBarThickness = 4
	self._tabScroll.ScrollBarImageColor3 = Color3.fromRGB(180, 120, 255)
	self._tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	self._tabScroll.Parent = self._side

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 12)
	pad.PaddingBottom = UDim.new(0, 12)
	pad.PaddingLeft = UDim.new(0, 8)
	pad.PaddingRight = UDim.new(0, 8)
	pad.Parent = self._tabScroll

	self._tabLayout = Instance.new("UIListLayout")
	self._tabLayout.Padding = UDim.new(0, 4)
	self._tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	self._tabLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	self._tabLayout.Parent = self._tabScroll

	-- Content Area (where components go)
	self._content = Instance.new("Frame")
	self._content.Name = "ContentArea"
	self._content.AnchorPoint = Vector2.new(0, 0.5)
	self._content.Position = UDim2.new(0.32, 10, 0.5, 0)
	self._content.Size = UDim2.new(0.66, -20, 0.86, 0)
	self._content.BackgroundTransparency = 1
	self._content.BorderSizePixel = 0
	self._content.Parent = self._frame

	-- Content Scrolling Frame
	self._contentScroll = Instance.new("ScrollingFrame")
	self._contentScroll.Size = UDim2.new(1, 0, 1, 0)
	self._contentScroll.BackgroundTransparency = 1
	self._contentScroll.BorderSizePixel = 0
	self._contentScroll.ScrollBarThickness = 6
	self._contentScroll.ScrollBarImageColor3 = Color3.fromRGB(200, 150, 255)
	self._contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	self._contentScroll.Parent = self._content

	local contentPad = Instance.new("UIPadding")
	contentPad.PaddingTop = UDim.new(0, 10)
	contentPad.PaddingBottom = UDim.new(0, 10)
	contentPad.PaddingLeft = UDim.new(0, 10)
	contentPad.PaddingRight = UDim.new(0, 10)
	contentPad.Parent = self._contentScroll

	self._contentLayout = Instance.new("UIListLayout")
	self._contentLayout.Padding = UDim.new(0, 10)
	self._contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	self._contentLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	self._contentLayout.Parent = self._contentScroll

	-- Minimized State (appears when window is minimized)
	self._minimized = Instance.new("ImageButton")
	self._minimized.AnchorPoint = Vector2.new(1, 0)
	self._minimized.Position = UDim2.new(1, -20, 0, 20)
	self._minimized.Size = UDim2.fromOffset(60, 60)
	self._minimized.BackgroundTransparency = 1
	self._minimized.BorderSizePixel = 0
	self._minimized.Visible = false
	self._minimized.ZIndex = 100
	self._minimized.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=103591022804634&width=678&height=810&format=png"
	self._minimized.ScaleType = Enum.ScaleType.Fit
	self._minimized.Parent = self._gui
	ApplyCorner(self._minimized, 100)
	ApplyStroke(self._minimized, Color3.fromRGB(255,255,255), 0.3, 2)

	-- Events
	self._closeBtn.MouseButton1Click:Connect(function() self:Minimize() end)
	self._minimized.MouseButton1Click:Connect(function() self:Restore() end)

	-- Tab selection highlight
	self._selectedTab = nil
	self._tabButtons = {}

	return self
end

-- Window Methods
function Window:SetTitle(text)
	self._titleLabel.Text = text
	return self
end

function Window:Minimize()
	local targetPos = UDim2.new(1, -40, 0, 40)
	local targetSize = UDim2.fromScale(0.05, 0.05)
	local info = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	Tween(self._frame, {Size = targetSize, Position = targetPos}, 0.3)
	Tween(self._shadow, {Size = targetSize, Position = targetPos}, 0.3)
	task.wait(0.3)
	self._frame.Visible = false
	self._shadow.Visible = false
	self._minimized.Visible = true
	self._minimized.Size = UDim2.fromOffset(0, 0)
	Tween(self._minimized, {Size = UDim2.fromOffset(60, 60)}, 0.3, Enum.EasingStyle.Back)
end

function Window:Restore()
	self._minimized.Visible = false
	self._frame.Visible = true
	self._shadow.Visible = true
	self._frame.Size = UDim2.fromScale(0.05, 0.05)
	self._frame.Position = UDim2.new(1, -40, 0, 40)
	self._shadow.Size = UDim2.fromScale(0.05, 0.05)
	self._shadow.Position = UDim2.new(1, -40, 0, 40)
	local info = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	Tween(self._frame, {Size = UDim2.fromScale(self._size[1], self._size[2]), Position = UDim2.fromScale(0.5, 0.54)}, 0.5, Enum.EasingStyle.Back)
	Tween(self._shadow, {Size = UDim2.fromScale(self._size[1], self._size[2]), Position = UDim2.new(0.5, 0, 0.54, 8)}, 0.5, Enum.EasingStyle.Back)
end

function Window:CreateTab(config)
	local tab = {}
	tab._parent = self
	tab._title = config.Title or "Tab"
	tab._callback = config.Callback or function() end
	tab._visible = true
	tab._contentFrame = nil  -- will be created when selected

	-- Button on side panel
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 38)
	btn.BackgroundColor3 = self._theme.Background
	btn.BackgroundTransparency = 0.3
	btn.BorderSizePixel = 0
	btn.Text = tab._title
	btn.Font = self._theme.Font
	btn.TextScaled = true
	btn.TextColor3 = self._theme.Text
	btn.ZIndex = 1
	btn.Parent = self._tabScroll

	-- Tab shadow
	local btnShadow = CreateShadow(btn, UDim2.new(1, 0, 0, 38), UDim2.new(0, 2, 0, 4), 0.3, 10)
	btnShadow.Parent = self._tabScroll

	ApplyCorner(btn, 10)
	local grad = ApplyGradient(btn, 90)
	-- Also marble overlay for tab buttons
	local tabMarble = Instance.new("ImageLabel")
	tabMarble.Size = UDim2.fromScale(1, 1)
	tabMarble.BackgroundTransparency = 1
	tabMarble.BorderSizePixel = 0
	tabMarble.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=133709037992585&width=678&height=810&format=png"
	tabMarble.ImageTransparency = 0.5
	tabMarble.ScaleType = Enum.ScaleType.Stretch
	tabMarble.ZIndex = 0
	tabMarble.Parent = btn
	ApplyCorner(tabMarble, 10)

	-- Create content frame (hidden initially)
	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, 0, 1, 0)
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.Visible = false
	content.Parent = self._contentScroll

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.Padding = UDim.new(0, 8)
	contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	contentLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	contentLayout.Parent = content

	tab._contentFrame = content
	tab._layout = contentLayout

	-- Click event
	btn.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)

	-- Store references
	table.insert(self._tabButtons, btn)
	table.insert(self._tabs, tab)

	-- Update canvas size
	local function updateCanvas()
		local children = self._tabScroll:GetChildren()
		local total = 0
		for _, child in pairs(children) do
			if child:IsA("TextButton") then
				total = total + 38 + 4
			end
		end
		self._tabScroll.CanvasSize = UDim2.new(0, 0, 0, total + 24)
	end
	task.wait(0.1)
	updateCanvas()
	self._tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0) -- reset, will be updated by layout

	return tab
end

function Window:SelectTab(tab)
	-- Deselect previous
	if self._selectedTab then
		for _, btn in pairs(self._tabButtons) do
			if btn.Text == self._selectedTab._title then
				btn.TextColor3 = self._theme.Text
			end
		end
		self._selectedTab._contentFrame.Visible = false
	end
	-- Select new
	self._selectedTab = tab
	tab._contentFrame.Visible = true
	-- Highlight button
	for _, btn in pairs(self._tabButtons) do
		if btn.Text == tab._title then
			btn.TextColor3 = Color3.fromRGB(255, 215, 0) -- gold
		end
	end
	tab._callback()
	-- Update content canvas
	self:UpdateContentCanvas()
end

function Window:UpdateContentCanvas()
	local totalHeight = 0
	local content = self._selectedTab and self._selectedTab._contentFrame
	if content then
		for _, child in pairs(content:GetChildren()) do
			if child:IsA("Frame") then
				totalHeight = totalHeight + child.Size.Y.Offset + 8
			end
		end
	end
	self._contentScroll.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
end

-- Component creation helpers
local function AddComponentToTab(tab, component, size)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.9, 0, 0, size or 30)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Parent = tab._contentFrame
	component._frame = frame
	component._container = tab._contentFrame
	tab._window._contentScroll.CanvasSize = UDim2.new(0, 0, 0, tab._contentFrame.Size.Y.Offset + 50)
	return frame
end

-- Button (on main panel)
function Window:CreateButton(config)
	local btn = setmetatable({}, Component)
	btn._parent = self
	btn._text = config.Text or "Button"
	btn._callback = config.Callback or function() end

	local frame = AddComponentToTab(self._selectedTab or self._tabs[1], btn, 40)
	btn._frame = frame

	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = self._theme.Background
	bg.BackgroundTransparency = 0.3
	bg.BorderSizePixel = 0
	bg.Parent = frame
	ApplyCorner(bg, 10)
	ApplyGradient(bg, 90)

	local btnShadow = CreateShadow(bg, UDim2.new(1, 0, 1, 0), UDim2.new(0, 2, 0, 4), 0.3, 10)
	btnShadow.Parent = frame

	local text = Instance.new("TextLabel")
	text.Size = UDim2.fromScale(1, 1)
	text.BackgroundTransparency = 1
	text.Font = self._theme.Font
	text.Text = btn._text
	text.TextScaled = true
	text.TextColor3 = self._theme.Text
	text.Parent = bg

	local btnBtn = Instance.new("TextButton")
	btnBtn.Size = UDim2.fromScale(1, 1)
	btnBtn.BackgroundTransparency = 1
	btnBtn.BorderSizePixel = 0
	btnBtn.Text = ""
	btnBtn.Parent = bg

	btnBtn.MouseButton1Click:Connect(function()
		btn._callback()
		-- Press animation
		Tween(bg, {Size = UDim2.new(1, 0, 0.9, 0)}, 0.08)
		Tween(btnShadow, {Size = UDim2.new(1, 0, 0.9, 0)}, 0.08)
		task.wait(0.08)
		Tween(bg, {Size = UDim2.new(1, 0, 1, 0)}, 0.08)
		Tween(btnShadow, {Size = UDim2.new(1, 0, 1, 0)}, 0.08)
	end)

	btn._bg = bg
	btn._btn = btnBtn
	btn._textLabel = text

	self:UpdateContentCanvas()
	return btn
end

-- Toggle
function Window:CreateToggle(config)
	local tog = setmetatable({}, Component)
	tog._parent = self
	tog._text = config.Text or "Toggle"
	tog._default = config.Default or false
	tog._state = tog._default
	tog._callback = config.Callback or function() end

	local frame = AddComponentToTab(self._selectedTab or self._tabs[1], tog, 35)
	tog._frame = frame

	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = self._theme.Background
	bg.BackgroundTransparency = 0.2
	bg.BorderSizePixel = 0
	bg.Parent = frame
	ApplyCorner(bg, 8)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.Position = UDim2.new(0, 5, 0, 0)
	label.BackgroundTransparency = 1
	label.Font = self._theme.Font
	label.Text = tog._text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextScaled = true
	label.TextColor3 = self._theme.Text
	label.Parent = bg

	local switch = Instance.new("Frame")
	switch.Size = UDim2.new(0, 40, 0, 22)
	switch.Position = UDim2.new(1, -45, 0.5, -11)
	switch.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	switch.BackgroundTransparency = 0
	switch.BorderSizePixel = 0
	switch.Parent = bg
	ApplyCorner(switch, 11)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.Position = UDim2.new(0, 2, 0.5, -9)
	knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
	knob.BackgroundTransparency = 0
	knob.BorderSizePixel = 0
	knob.Parent = switch
	ApplyCorner(knob, 9)

	local click = Instance.new("TextButton")
	click.Size = UDim2.fromScale(1, 1)
	click.BackgroundTransparency = 1
	click.BorderSizePixel = 0
	click.Text = ""
	click.Parent = switch

	local function updateToggle(state)
		tog._state = state
		local color = state and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(100, 100, 100)
		Tween(switch, {BackgroundColor3 = color}, 0.2)
		local pos = state and UDim2.new(0, 20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
		Tween(knob, {Position = pos}, 0.2)
		tog._callback(state)
	end

	click.MouseButton1Click:Connect(function()
		updateToggle(not tog._state)
	end)

	-- Set initial state
	updateToggle(tog._default)

	tog._switch = switch
	tog._knob = knob
	tog._label = label

	self:UpdateContentCanvas()
	return tog
end

-- Slider
function Window:CreateSlider(config)
	local sld = setmetatable({}, Component)
	sld._parent = self
	sld._text = config.Text or "Slider"
	sld._min = config.Min or 0
	sld._max = config.Max or 100
	sld._default = config.Default or 50
	sld._value = sld._default
	sld._callback = config.Callback or function() end

	local frame = AddComponentToTab(self._selectedTab or self._tabs[1], sld, 45)
	sld._frame = frame

	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = self._theme.Background
	bg.BackgroundTransparency = 0.2
	bg.BorderSizePixel = 0
	bg.Parent = frame
	ApplyCorner(bg, 8)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.5, 0, 0.5, 0)
	label.Position = UDim2.new(0, 5, 0, 2)
	label.BackgroundTransparency = 1
	label.Font = self._theme.Font
	label.Text = sld._text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextScaled = true
	label.TextColor3 = self._theme.Text
	label.Parent = bg

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(0.3, 0, 0.5, 0)
	valueLabel.Position = UDim2.new(0.7, -5, 0, 2)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Font = self._theme.Font
	valueLabel.Text = tostring(sld._default)
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.TextScaled = true
	valueLabel.TextColor3 = self._theme.Text
	valueLabel.Parent = bg

	local track = Instance.new("Frame")
	track.Size = UDim2.new(0.9, 0, 0, 8)
	track.Position = UDim2.new(0.05, 0, 0.7, 0)
	track.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	track.BackgroundTransparency = 0
	track.BorderSizePixel = 0
	track.Parent = bg
	ApplyCorner(track, 4)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0.5, 0, 1, 0) -- will be updated
	fill.BackgroundColor3 = self._theme.Accent
	fill.BackgroundTransparency = 0
	fill.BorderSizePixel = 0
	fill.Parent = track
	ApplyCorner(fill, 4)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 16, 0, 16)
	knob.Position = UDim2.new(0.5, -8, 0.5, -8)
	knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
	knob.BackgroundTransparency = 0
	knob.BorderSizePixel = 0
	knob.Parent = track
	ApplyCorner(knob, 8)

	local drag = Instance.new("TextButton")
	drag.Size = UDim2.fromScale(1, 1)
	drag.BackgroundTransparency = 1
	drag.BorderSizePixel = 0
	drag.Text = ""
	drag.Parent = knob

	local function updateSlider(value)
		value = math.clamp(value, sld._min, sld._max)
		sld._value = value
		local percent = (value - sld._min) / (sld._max - sld._min)
		fill.Size = UDim2.new(percent, 0, 1, 0)
		knob.Position = UDim2.new(percent, -8, 0.5, -8)
		valueLabel.Text = tostring(math.floor(value))
		sld._callback(value)
	end

	local dragging = false
	local connection
	drag.MouseButton1Down:Connect(function()
		dragging = true
		connection = RunService.RenderStepped:Connect(function()
			local mouse = Player:GetMouse()
			local absPos = track.AbsolutePosition
			local size = track.AbsoluteSize.X
			local x = mouse.X - absPos.X
			local percent = math.clamp(x / size, 0, 1)
			local value = sld._min + percent * (sld._max - sld._min)
			updateSlider(value)
		end)
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
			if connection then connection:Disconnect() connection = nil end
		end
	end)

	-- Set initial
	updateSlider(sld._default)

	sld._track = track
	sld._fill = fill
	sld._knob = knob
	sld._valueLabel = valueLabel

	self:UpdateContentCanvas()
	return sld
end

-- Textbox
function Window:CreateTextbox(config)
	local tb = setmetatable({}, Component)
	tb._parent = self
	tb._text = config.Text or "Input"
	tb._placeholder = config.Placeholder or "Type here..."
	tb._callback = config.Callback or function() end

	local frame = AddComponentToTab(self._selectedTab or self._tabs[1], tb, 35)
	tb._frame = frame

	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = self._theme.Background
	bg.BackgroundTransparency = 0.2
	bg.BorderSizePixel = 0
	bg.Parent = frame
	ApplyCorner(bg, 8)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.25, 0, 1, 0)
	label.Position = UDim2.new(0, 5, 0, 0)
	label.BackgroundTransparency = 1
	label.Font = self._theme.Font
	label.Text = tb._text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextScaled = true
	label.TextColor3 = self._theme.Text
	label.Parent = bg

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.7, -10, 0.9, 0)
	box.Position = UDim2.new(0.28, 0, 0.05, 0)
	box.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	box.BackgroundTransparency = 0
	box.BorderSizePixel = 0
	box.Font = self._theme.Font
	box.PlaceholderText = tb._placeholder
	box.Text = ""
	box.TextColor3 = self._theme.Text
	box.TextScaled = true
	box.Parent = bg
	ApplyCorner(box, 6)

	box.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			tb._callback(box.Text)
		end
	end)

	tb._box = box

	self:UpdateContentCanvas()
	return tb
end

-- Label
function Window:CreateLabel(config)
	local lbl = setmetatable({}, Component)
	lbl._parent = self
	lbl._text = config.Text or "Label"
	lbl._size = config.Size or 30

	local frame = AddComponentToTab(self._selectedTab or self._tabs[1], lbl, lbl._size)
	lbl._frame = frame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = self._theme.Font
	label.Text = lbl._text
	label.TextScaled = true
	label.TextColor3 = self._theme.Text
	label.Parent = frame

	lbl._label = label

	self:UpdateContentCanvas()
	return lbl
end

-- Paragraph
function Window:CreateParagraph(config)
	local para = setmetatable({}, Component)
	para._parent = self
	para._text = config.Text or "Paragraph text here..."
	para._size = config.Size or 60

	local frame = AddComponentToTab(self._selectedTab or self._tabs[1], para, para._size)
	para._frame = frame

	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = self._theme.Background
	bg.BackgroundTransparency = 0.1
	bg.BorderSizePixel = 0
	bg.Parent = frame
	ApplyCorner(bg, 8)

	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1, -10, 1, -10)
	text.Position = UDim2.new(0, 5, 0, 5)
	text.BackgroundTransparency = 1
	text.Font = self._theme.Font
	text.Text = para._text
	text.TextScaled = true
	text.TextColor3 = self._theme.Text
	text.TextWrapped = true
	text.TextXAlignment = Enum.TextXAlignment.Left
	text.TextYAlignment = Enum.TextYAlignment.Top
	text.Parent = bg

	para._textLabel = text

	self:UpdateContentCanvas()
	return para
end

-- Section (with divider)
function Window:CreateSection(config)
	local sect = setmetatable({}, Component)
	sect._parent = self
	sect._title = config.Title or "Section"
	sect._size = config.Size or 40

	local frame = AddComponentToTab(self._selectedTab or self._tabs[1], sect, sect._size)
	sect._frame = frame

	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundTransparency = 1
	bg.BorderSizePixel = 0
	bg.Parent = frame

	local divider = Instance.new("Frame")
	divider.Size = UDim2.new(1, -10, 0, 2)
	divider.Position = UDim2.new(0, 5, 0.7, 0)
	divider.BackgroundColor3 = self._theme.Accent
	divider.BackgroundTransparency = 0.5
	divider.BorderSizePixel = 0
	divider.Parent = bg
	ApplyCorner(divider, 1)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.6, 0, 0.6, 0)
	label.Position = UDim2.new(0, 5, 0, 0)
	label.BackgroundTransparency = 1
	label.Font = self._theme.Font
	label.Text = sect._title
	label.TextScaled = true
	label.TextColor3 = self._theme.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = bg

	sect._divider = divider
	sect._label = label

	self:UpdateContentCanvas()
	return sect
end

-- Public API: Create Window
function Library:CreateWindow(config)
	return Window.new(config)
end

-- Theme setter
function Library:SetTheme(themeName)
	if THEMES[themeName] then
		CurrentTheme = THEMES[themeName]
	else
		warn("Theme '" .. tostring(themeName) .. "' not found. Using default.")
	end
end

function Library:GetTheme()
	return CurrentTheme
end

-- Return library
return Library
