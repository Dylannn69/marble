--[[
	MarbleUI – A beautiful, modern UI library for Roblox with marble textures,
	gradients, smooth animations, and a complete set of controls.

	Features:
	- Tabs with custom labels, buttons, toggles, sliders, textboxes, dropdowns,
	  keybinds, and color pickers.
	- Minimize/restore with animation.
	- Keyboard toggle (default: RightShift).
	- Fully customizable colors and sizes.

	Usage:
		local MarbleUI = require(path.to.MarbleUI)
		local ui = MarbleUI:CreateWindow({
			title = "My UI",
			tabs = {"Home", "Settings"},
		})
		local home = ui:GetTab("Home")
		home:AddButton("Click me", function() print("Clicked!") end)

	Documentation: See README.md or the inline comments below.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local MarbleUI = {}
local defaultConfig = {
	main_color = Color3.fromRGB(110, 45, 220),
	min_size = Vector2.new(400, 450),
	toggle_key = Enum.KeyCode.RightShift,
	can_resize = true,
}

--// Internal helpers

local function createShadow(parent, size, position, transparency, cornerRadius, offset)
	offset = offset or UDim2.new(0, 0, 0, 8)
	local shadow = Instance.new("Frame")
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Size = size
	shadow.Position = position + offset
	shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	shadow.BackgroundTransparency = transparency or 0.5
	shadow.BorderSizePixel = 0
	shadow.ZIndex = 0
	shadow.Parent = parent
	local corner = Instance.new("UICorner")
	corner.CornerRadius = cornerRadius or UDim.new(0, 20)
	corner.Parent = shadow
	return shadow
end

local function createMarble(parent, cornerRadius, transparency)
	transparency = transparency or 0.6
	local img = Instance.new("ImageLabel")
	img.Size = UDim2.fromScale(1, 1)
	img.BackgroundTransparency = 1
	img.BorderSizePixel = 0
	img.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=133709037992585&width=678&height=810&format=png"
	img.ImageTransparency = transparency
	img.ScaleType = Enum.ScaleType.Stretch
	img.Parent = parent
	local cr = Instance.new("UICorner")
	cr.CornerRadius = cornerRadius or UDim.new(0, 20)
	cr.Parent = img
	return img
end

local function getMouse()
	return Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y - 35)
end

--// Main window creation

function MarbleUI:CreateWindow(config)
	config = config or {}
	local title = config.title or "Marble UI"
	local tabs = config.tabs or {"Tab 1", "Tab 2"}
	local onTabSelected = config.onTabSelected or function() end
	local parent = config.parent or Players.LocalPlayer:WaitForChild("PlayerGui")
	local mainColor = config.main_color or defaultConfig.main_color
	local minSize = config.min_size or defaultConfig.min_size
	local toggleKey = config.toggle_key or defaultConfig.toggle_key
	local canResize = config.can_resize ~= false

	local mainSize = UDim2.fromScale(0.4, 0.75)
	local mainPosition = UDim2.fromScale(0.5, 0.54)

	--// Create GUI
	local gui = Instance.new("ScreenGui")
	gui.Name = "MarbleUI"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = parent

	--// Main shadow
	local shadow = createShadow(gui, mainSize, mainPosition, 0.5, UDim.new(0, 20), UDim2.new(0, 0, 0, 8))

	--// Main panel
	local main = Instance.new("Frame")
	main.Name = "Main"
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.Position = mainPosition
	main.Size = mainSize
	main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	main.BorderSizePixel = 0
	main.Parent = gui

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 20)
	mainCorner.Parent = main

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = Color3.fromRGB(255, 255, 255)
	mainStroke.Thickness = 2
	mainStroke.Transparency = 0.3
	mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	mainStroke.Parent = main

	local mainGradient = Instance.new("UIGradient")
	mainGradient.Rotation = 90
	mainGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(110, 45, 220)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(176, 96, 244)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(236, 198, 255)),
	}
	mainGradient.Parent = main

	createMarble(main, UDim.new(0, 20))

	--// Close / minimize button
	local closeBtn = Instance.new("ImageButton")
	closeBtn.Name = "CloseButton"
	closeBtn.AnchorPoint = Vector2.new(0.5, 0.5)
	closeBtn.Position = UDim2.new(1, 0, 0, 0)
	closeBtn.Size = UDim2.fromOffset(56, 56)
	closeBtn.BackgroundTransparency = 1
	closeBtn.BorderSizePixel = 0
	closeBtn.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=114840795551292&width=678&height=810&format=png"
	closeBtn.ScaleType = Enum.ScaleType.Fit
	closeBtn.ZIndex = 10
	closeBtn.Parent = main

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(1, 0)
	closeCorner.Parent = closeBtn

	closeBtn.MouseEnter:Connect(function()
		closeBtn:TweenSize(UDim2.fromOffset(62, 62), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
	end)
	closeBtn.MouseLeave:Connect(function()
		closeBtn:TweenSize(UDim2.fromOffset(56, 56), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
	end)

	--// Header
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.AnchorPoint = Vector2.new(0.5, 0)
	header.Position = UDim2.new(0.5, 0, -0.04, 0)
	header.Size = UDim2.fromScale(0.5, 0.09)
	header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	header.BorderSizePixel = 0
	header.Parent = main

	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 18)
	headerCorner.Parent = header

	local headerShadow = createShadow(main, UDim2.fromScale(0.5, 0.09), UDim2.new(0.5, 0, -0.04, 0), 0.4, UDim.new(0, 18), UDim2.new(0, 0, 0, 4))
	headerShadow.Parent = main

	local headerGradient = mainGradient:Clone()
	headerGradient.Parent = header
	createMarble(header, UDim.new(0, 18))

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	titleLabel.Position = UDim2.fromScale(0.5, 0.5)
	titleLabel.Size = UDim2.fromScale(0.9, 0.8)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.Bangers
	titleLabel.Text = title
	titleLabel.TextScaled = true
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.Parent = header

	--// Side panel
	local sideShadow = Instance.new("Frame")
	sideShadow.AnchorPoint = Vector2.new(1, 0.5)
	sideShadow.Position = UDim2.new(0, -12, 0.5, 8)
	sideShadow.Size = UDim2.fromScale(0.3, 0.90)
	sideShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	sideShadow.BackgroundTransparency = 0.45
	sideShadow.BorderSizePixel = 0
	sideShadow.ZIndex = 0
	sideShadow.Parent = main
	Instance.new("UICorner", sideShadow).CornerRadius = UDim.new(0, 16)

	local side = Instance.new("Frame")
	side.Name = "Side"
	side.AnchorPoint = Vector2.new(1, 0.5)
	side.Position = UDim2.new(0, -12, 0.5, 0)
	side.Size = UDim2.fromScale(0.3, 0.90)
	side.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	side.BackgroundTransparency = 0.15
	side.BorderSizePixel = 0
	side.Parent = main
	Instance.new("UICorner", side).CornerRadius = UDim.new(0, 16)

	local sideStroke = Instance.new("UIStroke")
	sideStroke.Color = Color3.fromRGB(255, 255, 255)
	sideStroke.Thickness = 2
	sideStroke.Transparency = 0.3
	sideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	sideStroke.Parent = side

	local sideGradient = mainGradient:Clone()
	sideGradient.Parent = side
	createMarble(side, UDim.new(0, 16))

	--// Scroll frame (for tab buttons)
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ScrollFrame"
	scrollFrame.Size = UDim2.new(1, 0, 1, 0)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 4
	scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(180, 120, 255)
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollFrame.Parent = side

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 12)
	padding.PaddingBottom = UDim.new(0, 12)
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	padding.Parent = scrollFrame

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 4)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.Parent = scrollFrame

	--// Tab data
	local tabData = {}
	local currentTab = nil

	local function switchTab(tabName)
		if currentTab == tabName then return end
		currentTab = tabName

		-- Update button colors
		for name, data in pairs(tabData) do
			if data.button then
				data.button.TextColor3 = (name == tabName) and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 255, 255)
			end
			if data.container then
				data.container.Visible = (name == tabName)
			end
		end
		onTabSelected(tabName)
	end

	--// Create tabs
	for i, tabName in ipairs(tabs) do
		-- Tab button
		local btn = Instance.new("TextButton")
		btn.Name = "TabButton_" .. i
		btn.Size = UDim2.new(0.9, 0, 0, 32)
		btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		btn.BackgroundTransparency = 0.2
		btn.BorderSizePixel = 0
		btn.Text = tabName
		btn.Font = Enum.Font.Bangers
		btn.TextScaled = true
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.ZIndex = 2
		btn.Parent = scrollFrame

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 10)
		btnCorner.Parent = btn

		local btnGrad = mainGradient:Clone()
		btnGrad.Parent = btn

		-- Tab container (for elements)
		local container = Instance.new("Frame")
		container.Name = "TabContainer_" .. i
		container.Size = UDim2.new(1, 0, 0, 0)
		container.BackgroundTransparency = 1
		container.BorderSizePixel = 0
		container.Visible = false
		container.Parent = main

		local containerLayout = Instance.new("UIListLayout")
		containerLayout.Padding = UDim.new(0, 6)
		containerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		containerLayout.VerticalAlignment = Enum.VerticalAlignment.Top
		containerLayout.Parent = container

		local containerPadding = Instance.new("UIPadding")
		containerPadding.PaddingTop = UDim.new(0, 10)
		containerPadding.PaddingBottom = UDim.new(0, 10)
		containerPadding.PaddingLeft = UDim.new(0, 10)
		containerPadding.PaddingRight = UDim.new(0, 10)
		containerPadding.Parent = container

		tabData[tabName] = {
			button = btn,
			container = container,
		}

		btn.MouseButton1Click:Connect(function()
			switchTab(tabName)
		end)
	end

	-- Select first tab
	if #tabs > 0 then
		switchTab(tabs[1])
	end

	--// Tab API
	local TabAPI = {}

	function TabAPI:GetTab(tabName)
		local data = tabData[tabName]
		if not data then return nil end
		local elements = {}

		--// Add Label
		function elements:AddLabel(text)
			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, 0, 0, 22)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Bangers
			label.Text = text or "Label"
			label.TextScaled = true
			label.TextColor3 = Color3.fromRGB(255, 255, 255)
			label.TextXAlignment = Enum.TextXAlignment.Center
			label.Parent = data.container
			return label
		end

		--// Add Button
		function elements:AddButton(text, callback)
			callback = callback or function() end

			local container = Instance.new("Frame")
			container.Size = UDim2.new(0.9, 0, 0, 40)
			container.BackgroundTransparency = 1
			container.Parent = data.container

			local shadow = Instance.new("Frame")
			shadow.Size = UDim2.new(1, 0, 0, 36)
			shadow.Position = UDim2.new(0, 2, 0, 3)
			shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			shadow.BackgroundTransparency = 0.35
			shadow.BorderSizePixel = 0
			shadow.ZIndex = 0
			shadow.Parent = container
			Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 10)

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 36)
			btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			btn.BackgroundTransparency = 0.2
			btn.BorderSizePixel = 0
			btn.Text = text or "Button"
			btn.Font = Enum.Font.Bangers
			btn.TextScaled = true
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.ZIndex = 1
			btn.Parent = container
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

			local grad = mainGradient:Clone()
			grad.Parent = btn

			btn.MouseButton1Click:Connect(function()
				btn:TweenSize(UDim2.new(1, 0, 0, 32), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.08, true)
				btn.Position = UDim2.new(0, 0, 0, 2)
				shadow:TweenSize(UDim2.new(1, 0, 0, 32), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.08, true)
				shadow.Position = UDim2.new(0, 2, 0, 1)
				task.wait(0.08)
				btn:TweenSize(UDim2.new(1, 0, 0, 36), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.08, true)
				btn.Position = UDim2.new(0, 0, 0, 0)
				shadow:TweenSize(UDim2.new(1, 0, 0, 36), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.08, true)
				shadow.Position = UDim2.new(0, 2, 0, 3)
				pcall(callback)
			end)
			return btn
		end

		--// Add Toggle
		function elements:AddToggle(text, callback)
			callback = callback or function() end
			local state = false

			local container = Instance.new("Frame")
			container.Size = UDim2.new(0.9, 0, 0, 30)
			container.BackgroundTransparency = 1
			container.Parent = data.container

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(0.7, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Bangers
			label.Text = text or "Toggle"
			label.TextScaled = true
			label.TextColor3 = Color3.fromRGB(255, 255, 255)
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = container

			local toggleBtn = Instance.new("TextButton")
			toggleBtn.Size = UDim2.new(0, 40, 0, 24)
			toggleBtn.Position = UDim2.new(1, -44, 0.5, -12)
			toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			toggleBtn.BorderSizePixel = 0
			toggleBtn.Text = ""
			toggleBtn.ZIndex = 2
			toggleBtn.Parent = container
			Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

			local indicator = Instance.new("Frame")
			indicator.Size = UDim2.fromOffset(18, 18)
			indicator.Position = UDim2.new(0, 2, 0.5, -9)
			indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			indicator.BorderSizePixel = 0
			indicator.Parent = toggleBtn
			Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

			local function updateToggle()
				if state then
					toggleBtn.BackgroundColor3 = mainColor
					indicator.Position = UDim2.new(0, 20, 0.5, -9)
				else
					toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
					indicator.Position = UDim2.new(0, 2, 0.5, -9)
				end
			end

			toggleBtn.MouseButton1Click:Connect(function()
				state = not state
				updateToggle()
				pcall(callback, state)
			end)

			return {
				Set = function(self, newState)
					state = newState
					updateToggle()
					pcall(callback, state)
				end,
				Get = function(self)
					return state
				end,
			}
		end

		--// Add Slider
		function elements:AddSlider(text, callback, options)
			options = options or {}
			local min = options.min or 0
			local max = options.max or 100
			local default = options.default or min
			callback = callback or function() end

			local value = default
			local container = Instance.new("Frame")
			container.Size = UDim2.new(0.9, 0, 0, 40)
			container.BackgroundTransparency = 1
			container.Parent = data.container

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, 0, 0, 18)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Bangers
			label.Text = text or "Slider"
			label.TextScaled = true
			label.TextColor3 = Color3.fromRGB(255, 255, 255)
			label.TextXAlignment = Enum.TextXAlignment.Center
			label.Parent = container

			local valueLabel = Instance.new("TextLabel")
			valueLabel.Size = UDim2.new(1, 0, 0, 18)
			valueLabel.Position = UDim2.new(0, 0, 1, -18)
			valueLabel.BackgroundTransparency = 1
			valueLabel.Font = Enum.Font.Bangers
			valueLabel.Text = tostring(default)
			valueLabel.TextScaled = true
			valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
			valueLabel.TextXAlignment = Enum.TextXAlignment.Center
			valueLabel.Parent = container

			local track = Instance.new("Frame")
			track.Size = UDim2.new(1, 0, 0, 4)
			track.Position = UDim2.new(0, 0, 0.5, -2)
			track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			track.BorderSizePixel = 0
			track.Parent = container
			Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new(0.5, 0, 1, 0)
			fill.BackgroundColor3 = mainColor
			fill.BorderSizePixel = 0
			fill.Parent = track
			Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

			local handle = Instance.new("Frame")
			handle.Size = UDim2.fromOffset(16, 16)
			handle.Position = UDim2.new(0.5, -8, 0.5, -8)
			handle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
			handle.BorderSizePixel = 0
			handle.ZIndex = 2
			handle.Parent = track
			Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)

			local function updateSlider(newValue)
				value = math.clamp(newValue, min, max)
				local percent = (value - min) / (max - min)
				fill.Size = UDim2.new(percent, 0, 1, 0)
				handle.Position = UDim2.new(percent, -8, 0.5, -8)
				valueLabel.Text = tostring(math.floor(value))
				pcall(callback, math.floor(value))
			end
			updateSlider(default)

			local dragging = false
			UserInputService.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)
			UserInputService.MouseMoved:Connect(function()
				if dragging then
					local mousePos = getMouse()
					local trackPos = track.AbsolutePosition
					local trackSize = track.AbsoluteSize
					local percent = (mousePos.X - trackPos.X) / trackSize.X
					percent = math.clamp(percent, 0, 1)
					local newValue = min + (max - min) * percent
					updateSlider(newValue)
				end
			end)

			return {
				Set = function(self, newValue)
					updateSlider(newValue)
				end,
				Get = function(self)
					return math.floor(value)
				end,
			}
		end

		--// Add TextBox
		function elements:AddTextBox(text, callback, options)
			options = options or {}
			local clearOnSubmit = options.clear ~= false
			callback = callback or function() end

			local container = Instance.new("Frame")
			container.Size = UDim2.new(0.9, 0, 0, 32)
			container.BackgroundTransparency = 1
			container.Parent = data.container

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(0.35, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Bangers
			label.Text = text or "Input"
			label.TextScaled = true
			label.TextColor3 = Color3.fromRGB(255, 255, 255)
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = container

			local box = Instance.new("TextBox")
			box.Size = UDim2.new(0.6, 0, 1, 0)
			box.Position = UDim2.new(0.4, 0, 0, 0)
			box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			box.BorderSizePixel = 0
			box.Font = Enum.Font.GothamSemibold
			box.PlaceholderText = "Enter text..."
			box.Text = ""
			box.TextColor3 = Color3.fromRGB(255, 255, 255)
			box.TextSize = 14
			box.Parent = container
			Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

			box.FocusLost:Connect(function(enterPressed)
				if enterPressed and #box.Text > 0 then
					pcall(callback, box.Text)
					if clearOnSubmit then
						box.Text = ""
					end
				end
			end)
			return box
		end

		--// Add Dropdown
		function elements:AddDropdown(text, callback)
			callback = callback or function() end
			local options = {}
			local selected = nil
			local open = false

			local container = Instance.new("Frame")
			container.Size = UDim2.new(0.9, 0, 0, 32)
			container.BackgroundTransparency = 1
			container.Parent = data.container

			local dropdownBtn = Instance.new("TextButton")
			dropdownBtn.Size = UDim2.new(1, 0, 0, 32)
			dropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			dropdownBtn.BorderSizePixel = 0
			dropdownBtn.Font = Enum.Font.Bangers
			dropdownBtn.Text = text or "Dropdown"
			dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			dropdownBtn.TextScaled = true
			dropdownBtn.Parent = container
			Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0, 6)

			local dropdownBox = Instance.new("Frame")
			dropdownBox.Size = UDim2.new(1, 0, 0, 0)
			dropdownBox.Position = UDim2.new(0, 0, 1, 2)
			dropdownBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			dropdownBox.BorderSizePixel = 0
			dropdownBox.ClipsDescendants = true
			dropdownBox.Parent = container
			Instance.new("UICorner", dropdownBox).CornerRadius = UDim.new(0, 6)

			local optionLayout = Instance.new("UIListLayout")
			optionLayout.Padding = UDim.new(0, 2)
			optionLayout.Parent = dropdownBox

			local function updateHeight()
				local count = #dropdownBox:GetChildren() - 1
				dropdownBox.Size = UDim2.new(1, 0, 0, math.min(count * 28, 150))
			end

			dropdownBtn.MouseButton1Click:Connect(function()
				open = not open
				if open then
					dropdownBox:TweenSize(UDim2.new(1, 0, 0, math.min(#options * 28, 150)), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
				else
					dropdownBox:TweenSize(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
				end
			end)

			local api = {
				AddOption = function(self, optionText)
					local opt = Instance.new("TextButton")
					opt.Size = UDim2.new(1, 0, 0, 28)
					opt.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
					opt.BorderSizePixel = 0
					opt.Font = Enum.Font.GothamSemibold
					opt.Text = optionText
					opt.TextColor3 = Color3.fromRGB(255, 255, 255)
					opt.TextSize = 14
					opt.Parent = dropdownBox

					opt.MouseEnter:Connect(function()
						opt.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
					end)
					opt.MouseLeave:Connect(function()
						opt.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
					end)

					opt.MouseButton1Click:Connect(function()
						selected = optionText
						dropdownBtn.Text = optionText
						open = false
						dropdownBox:TweenSize(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
						pcall(callback, optionText)
					end)

					table.insert(options, optionText)
					updateHeight()
				end,
				GetSelected = function(self)
					return selected
				end,
			}
			return api
		end

		--// Add Keybind
		function elements:AddKeybind(text, callback, defaultKey)
			defaultKey = defaultKey or Enum.KeyCode.RightShift
			callback = callback or function() end
			local key = defaultKey
			local binding = false

			local container = Instance.new("Frame")
			container.Size = UDim2.new(0.9, 0, 0, 32)
			container.BackgroundTransparency = 1
			container.Parent = data.container

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(0.5, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Bangers
			label.Text = text or "Keybind"
			label.TextScaled = true
			label.TextColor3 = Color3.fromRGB(255, 255, 255)
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = container

			local keyBtn = Instance.new("TextButton")
			keyBtn.Size = UDim2.new(0.4, 0, 1, 0)
			keyBtn.Position = UDim2.new(0.6, 0, 0, 0)
			keyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			keyBtn.BorderSizePixel = 0
			keyBtn.Font = Enum.Font.GothamSemibold
			keyBtn.Text = tostring(key):gsub("Enum.KeyCode.", "")
			keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			keyBtn.TextSize = 14
			keyBtn.Parent = container
			Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)

			local shortkeys = {
				RightControl = "RightCtrl",
				LeftControl = "LeftCtrl",
				LeftShift = "LShift",
				RightShift = "RShift",
				MouseButton1 = "Mouse1",
				MouseButton2 = "Mouse2",
			}

			keyBtn.MouseButton1Click:Connect(function()
				binding = true
				keyBtn.Text = "..."
				local input = UserInputService.InputBegan:Wait()
				binding = false
				if input.KeyCode then
					key = input.KeyCode
					local display = shortkeys[key.Name] or key.Name
					keyBtn.Text = display
					pcall(callback, key)
				end
			end)

			UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if binding then return end
				if input.KeyCode == key and not gameProcessed then
					pcall(callback, key)
				end
			end)

			return {
				SetKey = function(self, newKey)
					key = newKey
					local display = shortkeys[key.Name] or key.Name
					keyBtn.Text = display
				end,
				GetKey = function(self)
					return key
				end,
			}
		end

		--// Add Color Picker
		function elements:AddColorPicker(callback)
			callback = callback or function() end
			local hue = 0
			local sat = 1
			local val = 1

			local container = Instance.new("Frame")
			container.Size = UDim2.new(0.9, 0, 0, 120)
			container.BackgroundTransparency = 1
			container.Parent = data.container

			local picker = Instance.new("ImageLabel")
			picker.Size = UDim2.new(0.5, 0, 1, 0)
			picker.BackgroundTransparency = 1
			picker.Image = "rbxassetid://698052001"
			picker.ScaleType = Enum.ScaleType.Slice
			picker.SliceCenter = Rect.new(4, 4, 4, 4)
			picker.Parent = container

			local indicator = Instance.new("ImageLabel")
			indicator.Size = UDim2.fromOffset(6, 6)
			indicator.BackgroundTransparency = 1
			indicator.Image = "rbxassetid://2851926732"
			indicator.ImageColor3 = Color3.fromRGB(0, 0, 0)
			indicator.ScaleType = Enum.ScaleType.Slice
			indicator.SliceCenter = Rect.new(12, 12, 12, 12)
			indicator.Parent = picker

			local saturation = Instance.new("ImageLabel")
			saturation.Size = UDim2.new(0.15, 0, 1, 0)
			saturation.Position = UDim2.new(0.55, 0, 0, 0)
			saturation.BackgroundTransparency = 1
			saturation.ImageColor3 = Color3.fromHSV(0, 1, 1)
			saturation.Parent = container

			local satIndicator = Instance.new("Frame")
			satIndicator.Size = UDim2.new(1.2, 0, 0, 2)
			satIndicator.Position = UDim2.new(0, -2, 0.5, -1)
			satIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			satIndicator.BorderSizePixel = 0
			satIndicator.Parent = saturation

			local sample = Instance.new("ImageLabel")
			sample.Size = UDim2.new(0.2, 0, 0.4, 0)
			sample.Position = UDim2.new(0.78, 0, 0.3, 0)
			sample.BackgroundTransparency = 1
			sample.Image = "rbxassetid://2851929490"
			sample.ScaleType = Enum.ScaleType.Slice
			sample.SliceCenter = Rect.new(4, 4, 4, 4)
			sample.Parent = container

			local function updateColor()
				local color = Color3.fromHSV(hue, sat, val)
				sample.ImageColor3 = color
				saturation.ImageColor3 = Color3.fromHSV(hue, 1, 1)
				pcall(callback, color)
			end

			local dragging1 = false
			local dragging2 = false

			picker.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging1 = true
				end
			end)
			picker.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging1 = false
				end
			end)

			saturation.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging2 = true
				end
			end)
			saturation.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging2 = false
				end
			end)

			UserInputService.MouseMoved:Connect(function()
				if dragging1 then
					local mousePos = getMouse()
					local pos = picker.AbsolutePosition
					local size = picker.AbsoluteSize
					local x = (mousePos.X - pos.X) / size.X
					local y = (mousePos.Y - pos.Y) / size.Y
					x = math.clamp(x, 0, 1)
					y = math.clamp(y, 0, 1)
					hue = x
					sat = 1 - y
					indicator.Position = UDim2.new(x, -3, y, -3)
					updateColor()
				end
				if dragging2 then
					local mousePos = getMouse()
					local pos = saturation.AbsolutePosition
					local size = saturation.AbsoluteSize
					local y = (mousePos.Y - pos.Y) / size.Y
					y = math.clamp(y, 0, 1)
					val = 1 - y
					satIndicator.Position = UDim2.new(0, -2, y, -1)
					updateColor()
				end
			end)

			updateColor()

			return {
				Set = function(self, color)
					local r, g, b = color.r, color.g, color.b
					local max, min = math.max(r, g, b), math.min(r, g, b)
					local d = max - min
					if max == 0 then sat = 0 else sat = d / max end
					if max == min then hue = 0
					elseif max == r then hue = (g - b) / d + (g < b and 6 or 0)
					elseif max == g then hue = (b - r) / d + 2
					else hue = (r - g) / d + 4 end
					hue = hue / 6
					val = max
					updateColor()
				end,
			}
		end

		return elements
	end

	--// Minimized frame
	local minimizedFrame = Instance.new("ImageButton")
	minimizedFrame.Name = "MinimizedFrame"
	minimizedFrame.AnchorPoint = Vector2.new(1, 0)
	minimizedFrame.Position = UDim2.new(1, -20, 0, 20)
	minimizedFrame.Size = UDim2.fromOffset(60, 60)
	minimizedFrame.BackgroundTransparency = 1
	minimizedFrame.BorderSizePixel = 0
	minimizedFrame.Visible = false
	minimizedFrame.ZIndex = 100
	minimizedFrame.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=103591022804634&width=678&height=810&format=png"
	minimizedFrame.ScaleType = Enum.ScaleType.Fit
	minimizedFrame.Parent = gui
	Instance.new("UICorner", minimizedFrame).CornerRadius = UDim.new(1, 0)

	local minStroke = Instance.new("UIStroke")
	minStroke.Color = Color3.fromRGB(255, 255, 255)
	minStroke.Thickness = 2
	minStroke.Transparency = 0.3
	minStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	minStroke.Parent = minimizedFrame

	--// Minimize / Restore
	local function minimize()
		local targetPos = UDim2.new(1, -40, 0, 40)
		local targetSize = UDim2.fromScale(0.05, 0.05)
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
		TweenService:Create(main, tweenInfo, {Size = targetSize, Position = targetPos}):Play()
		TweenService:Create(shadow, tweenInfo, {Size = targetSize, Position = targetPos}):Play()
		task.wait(0.3)
		main.Visible = false
		shadow.Visible = false
		minimizedFrame.Visible = true
		minimizedFrame.Size = UDim2.fromOffset(0, 0)
		minimizedFrame:TweenSize(UDim2.fromOffset(60, 60), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
	end

	local function restore()
		minimizedFrame.Visible = false
		main.Size = mainSize
		main.Position = mainPosition
		shadow.Size = mainSize
		shadow.Position = mainPosition
		main.Visible = true
		shadow.Visible = true
		main.Size = UDim2.fromScale(0.05, 0.05)
		main.Position = UDim2.new(1, -40, 0, 40)
		shadow.Size = UDim2.fromScale(0.05, 0.05)
		shadow.Position = UDim2.new(1, -40, 0, 40)
		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		TweenService:Create(main, tweenInfo, {Size = mainSize, Position = mainPosition}):Play()
		TweenService:Create(shadow, tweenInfo, {Size = mainSize, Position = mainPosition}):Play()
	end

	minimizedFrame.MouseButton1Click:Connect(restore)
	closeBtn.MouseButton1Click:Connect(minimize)

	--// Keyboard toggle
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == toggleKey then
			if main.Visible then
				minimize()
			else
				restore()
			end
		end
	end)

	--// Return API
	return {
		gui = gui,
		main = main,
		shadow = shadow,
		header = header,
		titleLabel = titleLabel,
		minimize = minimize,
		restore = restore,
		destroy = function()
			gui:Destroy()
		end,
		GetTab = function(self, tabName)
			return TabAPI:GetTab(tabName)
		end,
	}
end

return MarbleUI
