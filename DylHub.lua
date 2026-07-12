-- ============================================================
-- YOUR ORIGINAL UI (preserved, plus new content area)
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Gui = Instance.new("ScreenGui")
Gui.Name = "ConceptUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

--// SHADOW FOR MAIN PANEL
local Shadow = Instance.new("Frame")
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.Position = UDim2.new(0.5, 0, 0.54, 8)
Shadow.Size = UDim2.fromScale(0.4, 0.75)
Shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
Shadow.BackgroundTransparency = 0.5
Shadow.BorderSizePixel = 0
Shadow.ZIndex = 0
Shadow.Parent = Gui

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 20)
ShadowCorner.Parent = Shadow

--// MAIN PANEL
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.fromScale(0.5, 0.54)
Main.Size = UDim2.fromScale(0.4, 0.75)
Main.BackgroundColor3 = Color3.fromRGB(255,255,255)
Main.BorderSizePixel = 0
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = Main

--// SNOW/FROST UIStroke for Main
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 255, 255)
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

--// MARBLE TEXTURE OVERLAY (Main Panel)
local MarbleTexture = Instance.new("ImageLabel")
MarbleTexture.Name = "MarbleTexture"
MarbleTexture.Size = UDim2.fromScale(1, 1)
MarbleTexture.BackgroundTransparency = 1
MarbleTexture.BorderSizePixel = 0
MarbleTexture.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=133709037992585&width=678&height=810&format=png"
MarbleTexture.ImageTransparency = 0.6
MarbleTexture.ScaleType = Enum.ScaleType.Stretch
MarbleTexture.Parent = Main

local MarbleCorner = Instance.new("UICorner")
MarbleCorner.CornerRadius = UDim.new(0, 20)
MarbleCorner.Parent = MarbleTexture

--// HEADER SHADOW
local HeaderShadow = Instance.new("Frame")
HeaderShadow.Name = "HeaderShadow"
HeaderShadow.AnchorPoint = Vector2.new(0.5, 0)
HeaderShadow.Position = UDim2.new(0.5, 2, -0.04, 4)
HeaderShadow.Size = UDim2.fromScale(0.5, 0.09)
HeaderShadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
HeaderShadow.BackgroundTransparency = 0.4
HeaderShadow.BorderSizePixel = 0
HeaderShadow.ZIndex = 0
HeaderShadow.Parent = Main

local HeaderShadowCorner = Instance.new("UICorner")
HeaderShadowCorner.CornerRadius = UDim.new(0, 18)
HeaderShadowCorner.Parent = HeaderShadow

--// TITLE TAB
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.AnchorPoint = Vector2.new(0.5,0)
Header.Position = UDim2.new(0.5,0,-0.04,0)
Header.Size = UDim2.fromScale(0.5,0.09)
Header.BackgroundColor3 = Color3.fromRGB(255,255,255)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0,18)
HeaderCorner.Parent = Header

local HeaderGradient = MainGradient:Clone()
HeaderGradient.Parent = Header

local HeaderMarbleTexture = Instance.new("ImageLabel")
HeaderMarbleTexture.Name = "HeaderMarbleTexture"
HeaderMarbleTexture.Size = UDim2.fromScale(1, 1)
HeaderMarbleTexture.BackgroundTransparency = 1
HeaderMarbleTexture.BorderSizePixel = 0
HeaderMarbleTexture.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=133709037992585&width=678&height=810&format=png"
HeaderMarbleTexture.ImageTransparency = 0.6
HeaderMarbleTexture.ScaleType = Enum.ScaleType.Stretch
HeaderMarbleTexture.Parent = Header

local HeaderMarbleCorner = Instance.new("UICorner")
HeaderMarbleCorner.CornerRadius = UDim.new(0, 18)
HeaderMarbleCorner.Parent = HeaderMarbleTexture

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.AnchorPoint = Vector2.new(0.5,0.5)
Title.Position = UDim2.fromScale(0.5,0.5)
Title.Size = UDim2.fromScale(0.9,0.8)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Bangers
Title.Text = "SELECT A TAB"
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Parent = Header

--// CLOSE/MINIMIZE BUTTON
local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "CloseButton"
CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
CloseButton.Position = UDim2.new(1, 0, 0, 0)
CloseButton.Size = UDim2.fromOffset(56, 56)
CloseButton.BackgroundTransparency = 1
CloseButton.BorderSizePixel = 0
CloseButton.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=114840795551292&width=678&height=810&format=png"
CloseButton.ScaleType = Enum.ScaleType.Fit
CloseButton.ZIndex = 10
CloseButton.Parent = Main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = CloseButton

CloseButton.MouseEnter:Connect(function()
	CloseButton:TweenSize(UDim2.fromOffset(62, 62), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
end)
CloseButton.MouseLeave:Connect(function()
	CloseButton:TweenSize(UDim2.fromOffset(56, 56), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
end)

--// MINIMIZED STATE
local MinimizedFrame = Instance.new("ImageButton")
MinimizedFrame.Name = "MinimizedFrame"
MinimizedFrame.AnchorPoint = Vector2.new(1, 0)
MinimizedFrame.Position = UDim2.new(1, -20, 0, 20)
MinimizedFrame.Size = UDim2.fromOffset(60, 60)
MinimizedFrame.BackgroundTransparency = 1
MinimizedFrame.BorderSizePixel = 0
MinimizedFrame.Visible = false
MinimizedFrame.ZIndex = 100
MinimizedFrame.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=103591022804634&width=678&height=810&format=png"
MinimizedFrame.ScaleType = Enum.ScaleType.Fit
MinimizedFrame.Parent = Gui

local MinimizedCorner = Instance.new("UICorner")
MinimizedCorner.CornerRadius = UDim.new(1, 0)
MinimizedCorner.Parent = MinimizedFrame

local MinimizedStroke = Instance.new("UIStroke")
MinimizedStroke.Color = Color3.fromRGB(255, 255, 255)
MinimizedStroke.Thickness = 2
MinimizedStroke.Transparency = 0.3
MinimizedStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MinimizedStroke.Parent = MinimizedFrame

MinimizedFrame.MouseButton1Click:Connect(function()
	MinimizedFrame.Visible = false
	Main.Size = UDim2.fromScale(0.4, 0.75)
	Main.Position = UDim2.fromScale(0.5, 0.54)
	Shadow.Size = UDim2.fromScale(0.4, 0.75)
	Shadow.Position = UDim2.fromScale(0.5, 0.54)
	Main.Visible = true
	Shadow.Visible = true
	Main.Size = UDim2.fromScale(0.05, 0.05)
	Main.Position = UDim2.new(1, -40, 0, 40)
	Shadow.Size = UDim2.fromScale(0.05, 0.05)
	Shadow.Position = UDim2.new(1, -40, 0, 40)
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0)
	local mainProps = {Size = UDim2.fromScale(0.4, 0.75), Position = UDim2.fromScale(0.5, 0.54)}
	local shadowProps = {Size = UDim2.fromScale(0.4, 0.75), Position = UDim2.fromScale(0.5, 0.54)}
	TweenService:Create(Main, tweenInfo, mainProps):Play()
	TweenService:Create(Shadow, tweenInfo, shadowProps):Play()
end)

CloseButton.MouseButton1Click:Connect(function()
	local targetPos = UDim2.new(1, -40, 0, 40)
	local targetSize = UDim2.fromScale(0.05, 0.05)
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	TweenService:Create(Main, tweenInfo, {Size = targetSize, Position = targetPos}):Play()
	TweenService:Create(Shadow, tweenInfo, {Size = targetSize, Position = targetPos}):Play()
	task.wait(0.3)
	Main.Visible = false
	Shadow.Visible = false
	MinimizedFrame.Visible = true
	MinimizedFrame.Size = UDim2.fromOffset(0, 0)
	MinimizedFrame:TweenSize(UDim2.fromOffset(60, 60), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
end)

--// SIDE SHADOW
local SideShadow = Instance.new("Frame")
SideShadow.Name = "SideShadow"
SideShadow.AnchorPoint = Vector2.new(1,0.5)
SideShadow.Position = UDim2.new(0,-12,0.5,8)
SideShadow.Size = UDim2.fromScale(0.3,0.90)
SideShadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
SideShadow.BackgroundTransparency = 0.45
SideShadow.BorderSizePixel = 0
SideShadow.ZIndex = 0
SideShadow.Parent = Main

Instance.new("UICorner", SideShadow).CornerRadius = UDim.new(0,16)

--// SIDE PANEL
local Side = Instance.new("Frame")
Side.Name = "Side"
Side.AnchorPoint = Vector2.new(1,0.5)
Side.Position = UDim2.new(0,-12,0.5,0)
Side.Size = UDim2.fromScale(0.3,0.90)
Side.BackgroundColor3 = Color3.fromRGB(255,255,255)
Side.BackgroundTransparency = 0.15
Side.BorderSizePixel = 0
Side.Parent = Main

Instance.new("UICorner", Side).CornerRadius = UDim.new(0,16)

--// SNOW/FROST UIStroke for Side
local SideStroke = Instance.new("UIStroke")
SideStroke.Color = Color3.fromRGB(255, 255, 255)
SideStroke.Thickness = 2
SideStroke.Transparency = 0.3
SideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SideStroke.Parent = Side

local SideGradient = MainGradient:Clone()
SideGradient.Parent = Side

local SideMarbleTexture = Instance.new("ImageLabel")
SideMarbleTexture.Name = "SideMarbleTexture"
SideMarbleTexture.Size = UDim2.fromScale(1, 1)
SideMarbleTexture.BackgroundTransparency = 1
SideMarbleTexture.BorderSizePixel = 0
SideMarbleTexture.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=133709037992585&width=678&height=810&format=png"
SideMarbleTexture.ImageTransparency = 0.6
SideMarbleTexture.ScaleType = Enum.ScaleType.Stretch
SideMarbleTexture.Parent = Side

local SideMarbleCorner = Instance.new("UICorner")
SideMarbleCorner.CornerRadius = UDim.new(0, 16)
SideMarbleCorner.Parent = SideMarbleTexture

--// SIDE SCROLL FRAME (holds tab buttons)
local SideScroll = Instance.new("ScrollingFrame")
SideScroll.Name = "SideScroll"
SideScroll.Size = UDim2.new(1,0,1,0)
SideScroll.BackgroundTransparency = 1
SideScroll.BorderSizePixel = 0
SideScroll.ScrollBarThickness = 4
SideScroll.ScrollBarImageColor3 = Color3.fromRGB(180,120,255)
SideScroll.CanvasSize = UDim2.new(0,0,0,0)
SideScroll.Parent = Side

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 12)
SidePadding.PaddingBottom = UDim.new(0, 12)
SidePadding.PaddingLeft = UDim.new(0, 8)
SidePadding.PaddingRight = UDim.new(0, 8)
SidePadding.Parent = SideScroll

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 4)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.VerticalAlignment = Enum.VerticalAlignment.Top
SideLayout.Parent = SideScroll

-- ============================================================
-- NEW: CONTENT AREA (right side, next to Side panel)
-- ============================================================
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.AnchorPoint = Vector2.new(0, 0.5)
ContentArea.Position = UDim2.new(0, Side.Size.X.Offset + 12, 0.5, 0)
ContentArea.Size = UDim2.new(1, -Side.Size.X.Offset - 24, 0.9, 0)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = false  -- allow scrolling
ContentArea.Parent = Main

local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Name = "ContentScroll"
ContentScroll.Size = UDim2.new(1, 0, 1, 0)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 4
ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(180,120,255)
ContentScroll.CanvasSize = UDim2.new(0,0,0,0)
ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentScroll.ScrollingDirection = Enum.ScrollingDirection.Y
ContentScroll.Parent = ContentArea

local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingTop = UDim.new(0, 5)
ContentPadding.PaddingBottom = UDim.new(0, 5)
ContentPadding.PaddingLeft = UDim.new(0, 5)
ContentPadding.PaddingRight = UDim.new(0, 5)
ContentPadding.Parent = ContentScroll

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 6)
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ContentLayout.VerticalAlignment = Enum.VerticalAlignment.Top
ContentLayout.Parent = ContentScroll

--// TAB BUTTONS (with content frames)
local TabNames = {"Main", "Combat", "Settings", "Info", "Misc", "Tab6", "Tab7", "Tab8", "Tab9", "Tab10"}
local TabButtons = {}
local TabContents = {}
local ButtonHeight = 38

local function UpdateHeader(text)
	Title.Text = text
end

local function ResetHighlights()
	for _, btn in pairs(TabButtons) do
		local mainText = btn:FindFirstChild("MainText")
		if mainText then
			mainText.TextColor3 = Color3.fromRGB(255, 255, 255)
		end
	end
end

-- Create content frames for each tab (they will be hidden/shown)
for i = 1, #TabNames do
	local content = Instance.new("Frame")
	content.Name = "TabContent_" .. i
	content.Size = UDim2.new(1, 0, 0, 0)  -- will be resized by UIListLayout
	content.BackgroundTransparency = 1
	content.AutomaticSize = Enum.AutomaticSize.Y
	content.Parent = ContentScroll
	content.Visible = (i == 1)  -- only first visible initially

	-- Each content holds its own UIListLayout for elements
	local contentLayout = Instance.new("UIListLayout")
	contentLayout.Padding = UDim.new(0, 4)
	contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	contentLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	contentLayout.Parent = content

	TabContents[i] = content
end

-- Create tab buttons
for i = 1, #TabNames do
	local Container = Instance.new("Frame")
	Container.Name = "Container_" .. i
	Container.Size = UDim2.new(0.9, 0, 0, ButtonHeight + 6)
	Container.BackgroundTransparency = 1
	Container.BorderSizePixel = 0
	Container.Parent = SideScroll

	local ButtonShadow = Instance.new("Frame")
	ButtonShadow.Name = "ButtonShadow"
	ButtonShadow.Size = UDim2.new(1, 0, 0, ButtonHeight)
	ButtonShadow.Position = UDim2.new(0, 2, 0, 4)
	ButtonShadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
	ButtonShadow.BackgroundTransparency = 0.3
	ButtonShadow.BorderSizePixel = 0
	ButtonShadow.ZIndex = 0
	ButtonShadow.Parent = Container
	Instance.new("UICorner", ButtonShadow).CornerRadius = UDim.new(0, 10)

	local Button = Instance.new("TextButton")
	Button.Name = "TabButton_" .. i
	Button.Size = UDim2.new(1, 0, 0, ButtonHeight)
	Button.Position = UDim2.new(0, 0, 0, 0)
	Button.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Button.BackgroundTransparency = 0.3
	Button.BorderSizePixel = 0
	Button.Text = ""
	Button.ZIndex = 1
	Button.Parent = Container

	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.CornerRadius = UDim.new(0, 10)
	ButtonCorner.Parent = Button

	local ButtonGradient = MainGradient:Clone()
	ButtonGradient.Parent = Button

	local ButtonImage = Instance.new("ImageLabel")
	ButtonImage.Name = "ButtonImage"
	ButtonImage.Size = UDim2.fromScale(1, 1)
	ButtonImage.BackgroundTransparency = 1
	ButtonImage.BorderSizePixel = 0
	ButtonImage.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=133709037992585&width=678&height=810&format=png"
	ButtonImage.ImageTransparency = 0.5
	ButtonImage.ScaleType = Enum.ScaleType.Stretch
	ButtonImage.ZIndex = 0
	ButtonImage.Parent = Button
	Instance.new("UICorner", ButtonImage).CornerRadius = UDim.new(0, 10)

	local TextShadow = Instance.new("TextLabel")
	TextShadow.Name = "TextShadow"
	TextShadow.Size = UDim2.fromScale(1, 1)
	TextShadow.Position = UDim2.new(0, 1, 0, 1)
	TextShadow.BackgroundTransparency = 1
	TextShadow.Font = Enum.Font.Bangers
	TextShadow.Text = TabNames[i]
	TextShadow.TextScaled = true
	TextShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextShadow.TextTransparency = 0.5
	TextShadow.ZIndex = 2
	TextShadow.Parent = Button

	local MainText = Instance.new("TextLabel")
	MainText.Name = "MainText"
	MainText.Size = UDim2.fromScale(1, 1)
	MainText.Position = UDim2.new(0, 0, 0, 0)
	MainText.BackgroundTransparency = 1
	MainText.Font = Enum.Font.Bangers
	MainText.Text = TabNames[i]
	MainText.TextScaled = true
	MainText.TextColor3 = Color3.fromRGB(255, 255, 255)
	MainText.TextTransparency = 0
	MainText.ZIndex = 3
	MainText.Parent = Button

	TabButtons[i] = Button

	local function AnimateButton()
		ResetHighlights()
		MainText.TextColor3 = Color3.fromRGB(255, 215, 0)

		-- Hide all content frames, show the one for this tab
		for idx, content in pairs(TabContents) do
			content.Visible = (idx == i)
		end

		UpdateHeader(TabNames[i])

		-- Press animation
		Button:TweenSize(UDim2.new(1, 0, 0, ButtonHeight - 4), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.08, true)
		Button.Position = UDim2.new(0, 0, 0, 2)
		ButtonShadow:TweenSize(UDim2.new(1, 0, 0, ButtonHeight - 4), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.08, true)
		ButtonShadow.Position = UDim2.new(0, 2, 0, 2)
		task.wait(0.08)
		Button:TweenSize(UDim2.new(1, 0, 0, ButtonHeight), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.08, true)
		Button.Position = UDim2.new(0, 0, 0, 0)
		ButtonShadow:TweenSize(UDim2.new(1, 0, 0, ButtonHeight), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.08, true)
		ButtonShadow.Position = UDim2.new(0, 2, 0, 4)
	end

	Button.MouseButton1Click:Connect(AnimateButton)
end

-- Show first tab initially
UpdateHeader(TabNames[1])

-- ============================================================
-- COMPONENT FACTORIES (styled to match your UI)
-- ============================================================

-- Colors (using your theme)
local Theme = {
	Accent = Color3.fromRGB(176, 96, 244),   -- matching gradient
	Text = Color3.fromRGB(255, 255, 255),
	DarkText = Color3.fromRGB(200, 180, 220),
	Background = Color3.fromRGB(255, 255, 255),
	Stroke = Color3.fromRGB(255, 255, 255),
	Shadow = Color3.fromRGB(0,0,0),
}

-- Helper: create an element with rounded corners and optional stroke
local function CreateStyledElement(parent, size, backgroundTransparency, background)
	local frame = Instance.new("Frame")
	frame.Size = size
	frame.BackgroundColor3 = background or Color3.fromRGB(255,255,255)
	frame.BackgroundTransparency = backgroundTransparency or 0.15
	frame.BorderSizePixel = 0
	frame.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255,255,255)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.3
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = frame

	return frame
end

-- Flag system
local Flags = {}
local SaveFile = "ConceptUISettings.json"

local function LoadFlags()
	if readfile and isfile and isfile(SaveFile) then
		local success, data = pcall(readfile, SaveFile)
		if success and data and data ~= "" then
			local decoded = HttpService:JSONDecode(data)
			if type(decoded) == "table" then
				for k, v in pairs(decoded) do
					Flags[k] = v
				end
			end
		end
	end
end

local function SaveFlags()
	if writefile then
		local json = HttpService:JSONEncode(Flags)
		writefile(SaveFile, json)
	end
end

local saveDebounce
local function DebouncedSave()
	if saveDebounce then return end
	saveDebounce = true
	task.wait(0.1)
	saveDebounce = false
	SaveFlags()
end

function SetFlag(name, value)
	Flags[name] = value
	DebouncedSave()
end

function GetFlag(name)
	return Flags[name]
end

LoadFlags()

local function FireCallback(cb, ...)
	if type(cb) == "function" then
		cb(...)
	elseif type(cb) == "table" and cb[1] and cb[2] then
		cb[1][cb[2]](...)
	end
end

-- ============================================================
-- COMPONENT: Section
-- ============================================================
function CreateSection(parent, title)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 20)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 1, 0)
	label.Position = UDim2.new(0, 5, 0, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Bangers
	label.Text = title
	label.TextScaled = true
	label.TextColor3 = Theme.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	return {
		Destroy = function() frame:Destroy() end,
		Set = function(_, newTitle) label.Text = newTitle end,
		Visible = function(_, bool) frame.Visible = bool end,
	}
end

-- ============================================================
-- COMPONENT: Paragraph
-- ============================================================
function CreateParagraph(parent, config)
	local title = config.Title or "Paragraph"
	local text = config.Text or ""
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 30)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -10, 0, 15)
	titleLabel.Position = UDim2.new(0, 5, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.Bangers
	titleLabel.Text = title
	titleLabel.TextScaled = true
	titleLabel.TextColor3 = Theme.Text
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = frame

	local descLabel = Instance.new("TextLabel")
	descLabel.Size = UDim2.new(1, -10, 0, 15)
	descLabel.Position = UDim2.new(0, 5, 0, 15)
	descLabel.BackgroundTransparency = 1
	descLabel.Font = Enum.Font.SourceSans
	descLabel.Text = text
	descLabel.TextSize = 12
	descLabel.TextColor3 = Theme.DarkText
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = frame

	return {
		Set = function(_, newTitle, newText)
			if newTitle then titleLabel.Text = newTitle end
			if newText then descLabel.Text = newText end
		end,
		Destroy = function() frame:Destroy() end,
		Visible = function(_, bool) frame.Visible = bool end,
	}
end

-- ============================================================
-- COMPONENT: Button
-- ============================================================
function CreateButton(parent, config)
	local title = config.Title or "Button"
	local desc = config.Description or ""
	local callback = config.Callback or function() end

	local frame = CreateStyledElement(parent, UDim2.new(1, 0, 0, 30), 0.2)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -20, 1, 0)
	button.Position = UDim2.new(0, 10, 0, 0)
	button.BackgroundTransparency = 1
	button.Text = ""
	button.AutoButtonColor = false
	button.Parent = frame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -30, 1, 0)
	titleLabel.Position = UDim2.new(0, 5, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.Bangers
	titleLabel.Text = title
	titleLabel.TextScaled = true
	titleLabel.TextColor3 = Theme.Text
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = button

	local arrow = Instance.new("ImageLabel")
	arrow.Size = UDim2.new(0, 14, 0, 14)
	arrow.Position = UDim2.new(1, -10, 0.5)
	arrow.AnchorPoint = Vector2.new(1, 0.5)
	arrow.BackgroundTransparency = 1
	arrow.Image = "rbxassetid://10709791437"
	arrow.Parent = button

	button.MouseButton1Click:Connect(function()
		FireCallback(callback)
	end)

	return {
		Set = function(_, newTitle) titleLabel.Text = newTitle end,
		Destroy = function() frame:Destroy() end,
		Visible = function(_, bool) frame.Visible = bool end,
		Callback = function(_, newCb) callback = newCb end,
	}
end

-- ============================================================
-- COMPONENT: Toggle
-- ============================================================
function CreateToggle(parent, config)
	local title = config.Title or "Toggle"
	local desc = config.Description or ""
	local flag = config.Flag
	local default = config.Default or false
	local callback = config.Callback or function() end

	if flag and Flags[flag] ~= nil then
		default = Flags[flag]
	end

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 30)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -50, 1, 0)
	titleLabel.Position = UDim2.new(0, 5, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.Bangers
	titleLabel.Text = title
	titleLabel.TextScaled = true
	titleLabel.TextColor3 = Theme.Text
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = frame

	local descLabel = Instance.new("TextLabel")
	descLabel.Size = UDim2.new(1, -50, 0, 15)
	descLabel.Position = UDim2.new(0, 5, 0, 15)
	descLabel.BackgroundTransparency = 1
	descLabel.Font = Enum.Font.SourceSans
	descLabel.Text = desc
	descLabel.TextSize = 12
	descLabel.TextColor3 = Theme.DarkText
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = frame
	descLabel.Visible = (desc ~= "")

	local switch = Instance.new("TextButton")
	switch.Size = UDim2.new(0, 35, 0, 18)
	switch.Position = UDim2.new(1, -10, 0.5)
	switch.AnchorPoint = Vector2.new(1, 0.5)
	switch.BackgroundColor3 = Color3.fromRGB(80,80,80)
	switch.AutoButtonColor = false
	switch.Parent = frame
	Instance.new("UICorner", switch).CornerRadius = UDim.new(0.5, 0)

	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 12, 0, 12)
	circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
	circle.Parent = switch
	Instance.new("UICorner", circle).CornerRadius = UDim.new(0.5, 0)

	local state = default

	local function updateUI()
		if state then
			circle.Position = UDim2.new(1, 0, 0.5)
			circle.AnchorPoint = Vector2.new(1, 0.5)
			switch.BackgroundColor3 = Theme.Accent
		else
			circle.Position = UDim2.new(0, 0, 0.5)
			circle.AnchorPoint = Vector2.new(0, 0.5)
			switch.BackgroundColor3 = Color3.fromRGB(80,80,80)
		end
	end
	updateUI()

	switch.MouseButton1Click:Connect(function()
		state = not state
		updateUI()
		FireCallback(callback, state)
		if flag then
			Flags[flag] = state
			DebouncedSave()
		end
	end)

	return {
		Set = function(_, newState)
			state = newState
			updateUI()
			FireCallback(callback, state)
			if flag then
				Flags[flag] = state
				DebouncedSave()
			end
		end,
		Get = function() return state end,
		Destroy = function() frame:Destroy() end,
		Visible = function(_, bool) frame.Visible = bool end,
		Callback = function(_, newCb) callback = newCb end,
	}
end

-- ============================================================
-- COMPONENT: Slider
-- ============================================================
function CreateSlider(parent, config)
	local title = config.Title or "Slider"
	local desc = config.Description or ""
	local flag = config.Flag
	local min = config.Min or 0
	local max = config.Max or 100
	local inc = config.Increase or 1
	local default = config.Default or 50
	local callback = config.Callback or function() end

	if flag and Flags[flag] ~= nil then
		default = Flags[flag]
	end

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 40)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -60, 0, 15)
	titleLabel.Position = UDim2.new(0, 5, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.Bangers
	titleLabel.Text = title
	titleLabel.TextScaled = true
	titleLabel.TextColor3 = Theme.Text
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = frame

	local descLabel = Instance.new("TextLabel")
	descLabel.Size = UDim2.new(1, -60, 0, 15)
	descLabel.Position = UDim2.new(0, 5, 0, 15)
	descLabel.BackgroundTransparency = 1
	descLabel.Font = Enum.Font.SourceSans
	descLabel.Text = desc
	descLabel.TextSize = 12
	descLabel.TextColor3 = Theme.DarkText
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = frame
	descLabel.Visible = (desc ~= "")

	local holder = Instance.new("TextButton")
	holder.Size = UDim2.new(0, 150, 0, 20)
	holder.Position = UDim2.new(1, -10, 0.5)
	holder.AnchorPoint = Vector2.new(1, 0.5)
	holder.BackgroundTransparency = 1
	holder.AutoButtonColor = false
	holder.Parent = frame

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, -20, 0, 6)
	bar.Position = UDim2.new(0.5, 0, 0.5, 0)
	bar.AnchorPoint = Vector2.new(0.5, 0.5)
	bar.BackgroundColor3 = Color3.fromRGB(80,80,80)
	bar.Parent = holder
	Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.fromScale(0.3, 1)
	fill.BackgroundColor3 = Theme.Accent
	fill.Parent = bar
	Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 6, 0, 12)
	knob.Position = UDim2.fromScale(0.3, 0.5)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.BackgroundColor3 = Color3.fromRGB(220,220,220)
	knob.Parent = bar
	Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 3)

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(0, 30, 1, 0)
	valueLabel.Position = UDim2.new(0, 0, 0.5)
	valueLabel.AnchorPoint = Vector2.new(1, 0.5)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Font = Enum.Font.Bangers
	valueLabel.Text = tostring(default)
	valueLabel.TextScaled = true
	valueLabel.TextColor3 = Theme.Text
	valueLabel.Parent = holder

	local state = default
	local mouse = Player:GetMouse()

	local function updateUI()
		local fraction = (state - min) / (max - min)
		fraction = math.clamp(fraction, 0, 1)
		knob.Position = UDim2.fromScale(fraction, 0.5)
		fill.Size = UDim2.fromScale(fraction, 1)
		valueLabel.Text = tostring(math.floor(state * 100) / 100)
	end
	updateUI()

	holder.MouseButton1Down:Connect(function()
		while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
			local barPos = bar.AbsolutePosition.X
			local barWidth = bar.AbsoluteSize.X
			local mouseX = mouse.X
			local fraction = (mouseX - barPos) / barWidth
			fraction = math.clamp(fraction, 0, 1)
			local newVal = min + fraction * (max - min)
			newVal = math.floor(newVal / inc) * inc
			newVal = math.clamp(newVal, min, max)
			if newVal ~= state then
				state = newVal
				updateUI()
				FireCallback(callback, state)
				if flag then
					Flags[flag] = state
					DebouncedSave()
				end
			end
			task.wait()
		end
	end)

	return {
		Set = function(_, newVal)
			state = math.clamp(newVal, min, max)
			updateUI()
			FireCallback(callback, state)
			if flag then
				Flags[flag] = state
				DebouncedSave()
			end
		end,
		Get = function() return state end,
		Destroy = function() frame:Destroy() end,
		Visible = function(_, bool) frame.Visible = bool end,
		Callback = function(_, newCb) callback = newCb end,
	}
end

-- ============================================================
-- COMPONENT: Dropdown (single/multi)
-- ============================================================
function CreateDropdown(parent, config)
	local title = config.Title or "Dropdown"
	local desc = config.Description or ""
	local options = config.Options or {}
	local default = config.Default or (config.MultiSelect and {} or options[1])
	local flag = config.Flag
	local multi = config.MultiSelect or false
	local callback = config.Callback or function() end

	if flag and Flags[flag] ~= nil then
		default = Flags[flag]
	end

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 30)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -60, 1, 0)
	titleLabel.Position = UDim2.new(0, 5, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.Bangers
	titleLabel.Text = title
	titleLabel.TextScaled = true
	titleLabel.TextColor3 = Theme.Text
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = frame

	local descLabel = Instance.new("TextLabel")
	descLabel.Size = UDim2.new(1, -60, 0, 15)
	descLabel.Position = UDim2.new(0, 5, 0, 15)
	descLabel.BackgroundTransparency = 1
	descLabel.Font = Enum.Font.SourceSans
	descLabel.Text = desc
	descLabel.TextSize = 12
	descLabel.TextColor3 = Theme.DarkText
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = frame
	descLabel.Visible = (desc ~= "")

	local display = Instance.new("TextButton")
	display.Size = UDim2.new(0, 150, 0, 18)
	display.Position = UDim2.new(1, -10, 0.5)
	display.AnchorPoint = Vector2.new(1, 0.5)
	display.BackgroundColor3 = Color3.fromRGB(80,80,80)
	display.AutoButtonColor = false
	display.Text = ""
	display.Parent = frame
	Instance.new("UICorner", display).CornerRadius = UDim.new(0, 4)

	local displayText = Instance.new("TextLabel")
	displayText.Size = UDim2.new(0.85, 0, 1, 0)
	displayText.Position = UDim2.new(0.5, 0, 0.5, 0)
	displayText.AnchorPoint = Vector2.new(0.5, 0.5)
	displayText.BackgroundTransparency = 1
	displayText.Font = Enum.Font.Bangers
	displayText.Text = "..."
	displayText.TextScaled = true
	displayText.TextColor3 = Theme.Text
	displayText.Parent = display

	local arrow = Instance.new("ImageLabel")
	arrow.Size = UDim2.new(0, 12, 0, 12)
	arrow.Position = UDim2.new(1, -5, 0.5)
	arrow.AnchorPoint = Vector2.new(1, 0.5)
	arrow.BackgroundTransparency = 1
	arrow.Image = "rbxassetid://10709791523"
	arrow.Parent = display

	-- Dropdown list (hidden initially)
	local dropFrame = Instance.new("Frame")
	dropFrame.Size = UDim2.new(0, 152, 0, 0)
	dropFrame.Position = UDim2.new(1, -10, 0, 22)
	dropFrame.AnchorPoint = Vector2.new(1, 0)
	dropFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
	dropFrame.BackgroundTransparency = 0.2
	dropFrame.ClipsDescendants = true
	dropFrame.Parent = frame
	Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 6)
	Instance.new("UIStroke", dropFrame).Color = Color3.fromRGB(255,255,255)

	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.BackgroundTransparency = 1
	scroll.CanvasSize = UDim2.new()
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.ScrollingDirection = Enum.ScrollingDirection.Y
	scroll.Parent = dropFrame
	Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 2)

	local selected = default
	local optionObjects = {}
	local isOpen = false

	local function updateDisplay()
		if multi then
			local list = {}
			for opt, val in pairs(selected) do
				if val then table.insert(list, opt) end
			end
			displayText.Text = #list > 0 and table.concat(list, ", ") or "..."
		else
			displayText.Text = tostring(selected or "...")
		end
	end

	local function closeDropdown()
		isOpen = false
		arrow.Image = "rbxassetid://10709791523"
		TweenService:Create(dropFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 152, 0, 0)}):Play()
	end

	local function openDropdown()
		isOpen = true
		arrow.Image = "rbxassetid://10709790948"
		local height = math.min(#options * 25 + 10, 150)
		TweenService:Create(dropFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 152, 0, height)}):Play()
	end

	local function buildOptions()
		for _, opt in ipairs(options) do
			local optFrame = Instance.new("TextButton")
			optFrame.Size = UDim2.new(1, 0, 0, 21)
			optFrame.BackgroundColor3 = Color3.fromRGB(60,60,60)
			optFrame.BackgroundTransparency = 0.5
			optFrame.AutoButtonColor = false
			optFrame.Text = ""
			optFrame.Parent = scroll
			Instance.new("UICorner", optFrame).CornerRadius = UDim.new(0, 4)

			local optLabel = Instance.new("TextLabel")
			optLabel.Size = UDim2.new(1, -10, 1, 0)
			optLabel.Position = UDim2.new(0, 5, 0, 0)
			optLabel.BackgroundTransparency = 1
			optLabel.Font = Enum.Font.Bangers
			optLabel.Text = opt
			optLabel.TextScaled = true
			optLabel.TextColor3 = Theme.Text
			optLabel.TextXAlignment = Enum.TextXAlignment.Left
			optLabel.Parent = optFrame

			local check = Instance.new("Frame")
			check.Size = UDim2.new(0, 4, 0, 4)
			check.Position = UDim2.new(1, -10, 0.5)
			check.AnchorPoint = Vector2.new(1, 0.5)
			check.BackgroundColor3 = Theme.Accent
			check.BackgroundTransparency = 1
			check.Parent = optFrame
			Instance.new("UICorner", check).CornerRadius = UDim.new(0.5, 0)

			local function updateCheck()
				local isSelected = multi and selected[opt] or (selected == opt)
				check.BackgroundTransparency = isSelected and 0 or 1
				check.Size = isSelected and UDim2.new(0, 4, 0, 14) or UDim2.new(0, 4, 0, 4)
			end

			optFrame.MouseButton1Click:Connect(function()
				if multi then
					selected[opt] = not selected[opt]
				else
					selected = opt
				end
				updateCheck()
				updateDisplay()
				FireCallback(callback, selected)
				if flag then
					Flags[flag] = selected
					DebouncedSave()
				end
				if not multi then closeDropdown() end
			end)

			optionObjects[opt] = {frame = optFrame, check = check, update = updateCheck}
			updateCheck()
		end
	end

	buildOptions()
	updateDisplay()

	display.MouseButton1Click:Connect(function()
		if isOpen then closeDropdown() else openDropdown() end
	end)

	-- Click outside to close (optional: use a global click listener)
	-- For simplicity, we'll close when switching tabs (handled by parent)

	return {
		Set = function(_, newVal)
			if multi then
				for opt in pairs(selected) do selected[opt] = false end
				if type(newVal) == "table" then
					for _, opt in ipairs(newVal) do selected[opt] = true end
				end
			else
				selected = newVal
			end
			for _, obj in pairs(optionObjects) do obj.update() end
			updateDisplay()
			FireCallback(callback, selected)
			if flag then
				Flags[flag] = selected
				DebouncedSave()
			end
		end,
		Get = function() return selected end,
		Destroy = function() frame:Destroy() end,
		Visible = function(_, bool) frame.Visible = bool end,
		Callback = function(_, newCb) callback = newCb end,
		AddOption = function(_, opt)
			table.insert(options, opt)
			for _, obj in pairs(optionObjects) do obj.frame:Destroy() end
			optionObjects = {}
			buildOptions()
			closeDropdown()
		end,
		RemoveOption = function(_, opt)
			for i, o in ipairs(options) do
				if o == opt then
					table.remove(options, i)
					if optionObjects[opt] then
						optionObjects[opt].frame:Destroy()
						optionObjects[opt] = nil
					end
					break
				end
			end
			closeDropdown()
		end,
	}
end

-- ============================================================
-- COMPONENT: TextBox
-- ============================================================
function CreateTextBox(parent, config)
	local title = config.Title or "Text Box"
	local desc = config.Description or ""
	local flag = config.Flag
	local default = config.Default or ""
	local placeholder = config.PlaceholderText or "Type here..."
	local clear = config.ClearText or false
	local callback = config.Callback or function() end

	if flag and Flags[flag] ~= nil then
		default = Flags[flag]
	end

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 30)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -60, 1, 0)
	titleLabel.Position = UDim2.new(0, 5, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.Bangers
	titleLabel.Text = title
	titleLabel.TextScaled = true
	titleLabel.TextColor3 = Theme.Text
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = frame

	local descLabel = Instance.new("TextLabel")
	descLabel.Size = UDim2.new(1, -60, 0, 15)
	descLabel.Position = UDim2.new(0, 5, 0, 15)
	descLabel.BackgroundTransparency = 1
	descLabel.Font = Enum.Font.SourceSans
	descLabel.Text = desc
	descLabel.TextSize = 12
	descLabel.TextColor3 = Theme.DarkText
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = frame
	descLabel.Visible = (desc ~= "")

	local input = Instance.new("TextBox")
	input.Size = UDim2.new(0, 150, 0, 18)
	input.Position = UDim2.new(1, -10, 0.5)
	input.AnchorPoint = Vector2.new(1, 0.5)
	input.BackgroundColor3 = Color3.fromRGB(80,80,80)
	input.Text = default
	input.PlaceholderText = placeholder
	input.ClearTextOnFocus = clear
	input.TextColor3 = Theme.Text
	input.Font = Enum.Font.Bangers
	input.TextScaled = true
	input.Parent = frame
	Instance.new("UICorner", input).CornerRadius = UDim.new(0, 4)

	input.FocusLost:Connect(function()
		local text = input.Text
		FireCallback(callback, text)
		if flag then
			Flags[flag] = text
			DebouncedSave()
		end
	end)

	return {
		Set = function(_, newText)
			input.Text = newText
			if flag then
				Flags[flag] = newText
				DebouncedSave()
			end
		end,
		Get = function() return input.Text end,
		Destroy = function() frame:Destroy() end,
		Visible = function(_, bool) frame.Visible = bool end,
		Callback = function(_, newCb) callback = newCb end,
	}
end
