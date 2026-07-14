local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

local XvPxOL = {
	Elements = {},
	ThemeObjects = {},
	Connections = {},
	Flags = {},
	Themes = {
		Default = {
			Main = Color3.fromRGB(245, 248, 255),
			Second = Color3.fromRGB(225, 235, 255),
			Stroke = Color3.fromRGB(100, 160, 230),
			Divider = Color3.fromRGB(100, 160, 230),
			Text = Color3.fromRGB(60, 130, 210),
			TextDark = Color3.fromRGB(120, 170, 230)
		}
	},
	SelectedTheme = "Default",
	Folder = nil,
	SaveCfg = false
}

local Icons = {}
pcall(function()
	Icons = HttpService:JSONDecode(game:HttpGetAsync("https://raw.githubusercontent.com/evoincorp/lucideblox/master/src/modules/util/icons.json")).icons
end)

local function GetIcon(IconName)
	if Icons[IconName] ~= nil then return Icons[IconName] else return nil end
end

XvPxOL.Themes.Default = {
	Main = Color3.fromRGB(245, 248, 255),
	Second = Color3.fromRGB(225, 235, 255),
	Stroke = Color3.fromRGB(100, 160, 230),
	Divider = Color3.fromRGB(100, 160, 230),
	Text = Color3.fromRGB(60, 130, 210),
	TextDark = Color3.fromRGB(120, 170, 230)
}

local XvPxOL_UI = Instance.new("ScreenGui")
XvPxOL_UI.Name = "XvPxOL"
XvPxOL_UI.ResetOnSpawn = false
XvPxOL_UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn then
	syn.protect_gui(XvPxOL_UI)
	XvPxOL_UI.Parent = game.CoreGui
else
	XvPxOL_UI.Parent = gethui() or game.CoreGui
end

if gethui then
	for _, Interface in ipairs(gethui():GetChildren()) do
		if Interface.Name == XvPxOL_UI.Name and Interface ~= XvPxOL_UI then
			Interface:Destroy()
		end
	end
else
	for _, Interface in ipairs(game.CoreGui:GetChildren()) do
		if Interface.Name == XvPxOL_UI.Name and Interface ~= XvPxOL_UI then
			Interface:Destroy()
		end
	end
end

function XvPxOL:IsRunning()
	if gethui then
		return XvPxOL_UI.Parent == gethui()
	else
		return XvPxOL_UI.Parent == game:GetService("CoreGui")
	end
end

local function AddConnection(Signal, Function)
	if (not XvPxOL:IsRunning()) then return end
	local SignalConnect = Signal:Connect(Function)
	table.insert(XvPxOL.Connections, SignalConnect)
	return SignalConnect
end

task.spawn(function()
	while (XvPxOL:IsRunning()) do task.wait() end
	for _, Connection in next, XvPxOL.Connections do Connection:Disconnect() end
end)

local function MakeDraggable(guiObject, mainFrame)
	local dragging = false
	local dragStart = nil
	local startPos = nil

	guiObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
		end
	end)

	guiObject.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

local function MakeSmoothDraggable(guiObject, mainFrame)
	local dragging = false
	local dragStart = nil
	local startPos = nil
	local lastUpdate = 0
	local lastMousePos = nil
	local velocity = Vector2.new(0, 0)

	guiObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
			lastUpdate = tick()
			lastMousePos = input.Position
			velocity = Vector2.new(0, 0)
		end
	end)

	guiObject.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			lastMousePos = nil
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local currentTime = tick()
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
			if lastMousePos then
				local dt = math.max(currentTime - lastUpdate, 0.001)
				velocity = (input.Position - lastMousePos) / dt
			end
			lastUpdate = currentTime
			lastMousePos = input.Position
		end
	end)
end

local function Create(Name, Properties, Children)
	local Object = Instance.new(Name)
	for i, v in next, Properties or {} do Object[i] = v end
	for i, v in next, Children or {} do v.Parent = Object end
	return Object
end

local function CreateElement(ElementName, ElementFunction)
	XvPxOL.Elements[ElementName] = function(...) return ElementFunction(...) end
end

local function MakeElement(ElementName, ...)
	return XvPxOL.Elements[ElementName](...)
end

local function SetProps(Element, Props)
	table.foreach(Props, function(Property, Value) Element[Property] = Value end)
	return Element
end

local function SetChildren(Element, Children)
	table.foreach(Children, function(_, Child) Child.Parent = Element end)
	return Element
end

local function Round(Number, Factor)
	local Result = math.floor(Number/Factor + (math.sign(Number) * 0.5)) * Factor
	if Result < 0 then Result = Result + Factor end
	return Result
end

local function ReturnProperty(Object)
	if Object:IsA("Frame") or Object:IsA("TextButton") then return "BackgroundColor3" end
	if Object:IsA("ScrollingFrame") then return "ScrollBarImageColor3" end
	if Object:IsA("UIStroke") then return "Color" end
	if Object:IsA("TextLabel") or Object:IsA("TextBox") then return "TextColor3" end
	if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then return "ImageColor3" end
end

local function AddThemeObject(Object, Type)
	if not XvPxOL.ThemeObjects[Type] then XvPxOL.ThemeObjects[Type] = {} end
	table.insert(XvPxOL.ThemeObjects[Type], Object)
	Object[ReturnProperty(Object)] = XvPxOL.Themes[XvPxOL.SelectedTheme][Type]
	return Object
end

local function SaveCfg(Name)
	local Data = {}
	for i, v in pairs(XvPxOL.Flags) do
		if v.Save then
			if v.Type == "Colorpicker" then
				Data[i] = {R = v.Value.R * 255, G = v.Value.G * 255, B = v.Value.B * 255}
			else
				Data[i] = v.Value
			end
		end
	end
	if XvPxOL.Folder then
		writefile(XvPxOL.Folder .. "/" .. Name .. ".txt", tostring(HttpService:JSONEncode(Data)))
	end
end

local WhitelistedMouse = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3}
local BlacklistedKeys = {Enum.KeyCode.Unknown, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Up, Enum.KeyCode.Left, Enum.KeyCode.Down, Enum.KeyCode.Right, Enum.KeyCode.Slash, Enum.KeyCode.Tab, Enum.KeyCode.Backspace, Enum.KeyCode.Escape}

local function CheckKey(Table, Key)
	for _, v in next, Table do if v == Key then return true end end
end

local function CreateRainbowBorder(parent, thickness, cornerRadius)
	local border = Instance.new("Frame")
	border.BackgroundTransparency = 1
	border.Size = UDim2.new(1, thickness*2, 1, thickness*2)
	border.Position = UDim2.new(0, -thickness, 0, -thickness)
	border.ZIndex = parent.ZIndex - 1
	border.Name = "RainbowBorder"
	border.Parent = parent
	border.Active = false
	
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 127, 0)),
		ColorSequenceKeypoint.new(0.20, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.30, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(0.60, Color3.fromRGB(139, 0, 255)),
		ColorSequenceKeypoint.new(0.70, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.80, Color3.fromRGB(255, 127, 0)),
		ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 255, 0))
	})
	gradient.Rotation = 0
	gradient.Parent = border
	
	local inner = Instance.new("Frame")
	inner.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	inner.BackgroundTransparency = 1
	inner.Size = UDim2.new(1, -thickness*2, 1, -thickness*2)
	inner.Position = UDim2.new(0, thickness, 0, thickness)
	inner.ZIndex = parent.ZIndex
	inner.Parent = border
	
	if cornerRadius then
		Instance.new("UICorner", border).CornerRadius = UDim.new(0, cornerRadius + thickness)
		Instance.new("UICorner", inner).CornerRadius = UDim.new(0, cornerRadius)
	end
	
	spawn(function()
		while border and border.Parent do
			gradient.Rotation = (gradient.Rotation + 1) % 360
			RunService.RenderStepped:Wait()
		end
	end)
	
	return border, gradient
end

local function Ripple(obj)
	spawn(function()
		if obj.ClipsDescendants ~= true then
			obj.ClipsDescendants = true
		end
		local RippleEffect = Instance.new("ImageLabel")
		RippleEffect.Name = "Ripple"
		RippleEffect.Parent = obj
		RippleEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		RippleEffect.BackgroundTransparency = 1.000
		RippleEffect.ZIndex = 8
		RippleEffect.Image = "rbxassetid://2708891598"
		RippleEffect.ImageTransparency = 0.800
		RippleEffect.ScaleType = Enum.ScaleType.Fit
		RippleEffect.ImageColor3 = Color3.fromRGB(255, 255, 255)
		RippleEffect.Position = UDim2.new(
			(Mouse.X - RippleEffect.AbsolutePosition.X) / obj.AbsoluteSize.X,
			0,
			(Mouse.Y - RippleEffect.AbsolutePosition.Y) / obj.AbsoluteSize.Y,
			0
		)
		TweenService:Create(RippleEffect, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
			Position = UDim2.new(-5.5, 0, -5.5, 0),
			Size = UDim2.new(12, 0, 12, 0)
		}):Play()
		task.wait(0.15)
		TweenService:Create(RippleEffect, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
			ImageTransparency = 1
		}):Play()
		task.wait(0.3)
		RippleEffect:Destroy()
	end)
end

local function addGradientStroke(parent)
	local layers = {
		{ color = Color3.fromRGB(100, 160, 230), thickness = 1.2, transparency = 0.0 },
		{ color = Color3.fromRGB(130, 180, 240), thickness = 2.0, transparency = 0.2 },
		{ color = Color3.fromRGB(160, 200, 250), thickness = 2.8, transparency = 0.4 },
	}
	local strokes = {}
	for i, layer in ipairs(layers) do
		local stroke = Instance.new("UIStroke")
		stroke.Name = "GradientStrokeLayer" .. i
		stroke.Parent = parent
		stroke.Color = layer.color
		stroke.Thickness = layer.thickness
		stroke.Transparency = layer.transparency
		stroke.LineJoinMode = Enum.LineJoinMode.Round
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		table.insert(strokes, stroke)
	end
	return strokes
end

CreateElement("Corner", function(Scale, Offset) return Create("UICorner", {CornerRadius = UDim.new(Scale or 0, Offset or 8)}) end)
CreateElement("Stroke", function(Color, Thickness) return Create("UIStroke", {Color = Color or Color3.fromRGB(100, 160, 230), Thickness = Thickness or 1.2}) end)
CreateElement("List", function(Scale, Offset) return Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(Scale or 0, Offset or 0)}) end)
CreateElement("Padding", function(Bottom, Left, Right, Top) return Create("UIPadding", {PaddingBottom = UDim.new(0, Bottom or 4), PaddingLeft = UDim.new(0, Left or 4), PaddingRight = UDim.new(0, Right or 4), PaddingTop = UDim.new(0, Top or 4)}) end)
CreateElement("TFrame", function() return Create("Frame", {BackgroundTransparency = 1}) end)
CreateElement("Frame", function(Color) return Create("Frame", {BackgroundColor3 = Color or Color3.fromRGB(255,255,255), BorderSizePixel = 0}) end)
CreateElement("RoundFrame", function(Color, Scale, Offset) return Create("Frame", {BackgroundColor3 = Color or Color3.fromRGB(255,255,255), BorderSizePixel = 0, BackgroundTransparency = 0.15}, {Create("UICorner", {CornerRadius = UDim.new(Scale, Offset)})}) end)
CreateElement("Button", function() return Create("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, BorderSizePixel = 0}) end)
CreateElement("ScrollFrame", function(Color, Width) return Create("ScrollingFrame", {BackgroundTransparency = 1, MidImage = "rbxassetid://7445543667", BottomImage = "rbxassetid://7445543667", TopImage = "rbxassetid://7445543667", ScrollBarImageColor3 = Color, BorderSizePixel = 0, ScrollBarThickness = Width, CanvasSize = UDim2.new(0,0,0,0)}) end)
CreateElement("Image", function(ImageID) local img = Create("ImageLabel", {Image = ImageID, BackgroundTransparency = 1}); if GetIcon(ImageID) ~= nil then img.Image = GetIcon(ImageID) end; return img end)
CreateElement("Label", function(Text, TextSize, Transparency) return Create("TextLabel", {Text = Text or "", TextColor3 = Color3.fromRGB(60,130,210), TextTransparency = Transparency or 0, TextSize = TextSize or 14, Font = Enum.Font.Gotham, RichText = true, BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left}) end)

local FloatContainer = Instance.new("Frame")
FloatContainer.Size = UDim2.new(0, 72, 0, 72)
FloatContainer.Position = UDim2.new(0, 20, 0.5, -36)
FloatContainer.BackgroundTransparency = 1
FloatContainer.Name = "FloatContainer"
FloatContainer.ZIndex = 100
FloatContainer.Parent = XvPxOL_UI

local FloatRainbow = Instance.new("Frame")
FloatRainbow.BackgroundTransparency = 1
FloatRainbow.Size = UDim2.new(1, 8, 1, 8)
FloatRainbow.Position = UDim2.new(0, -4, 0, -4)
FloatRainbow.ZIndex = 98
FloatRainbow.Active = false
FloatRainbow.Name = "FloatRainbow"
FloatRainbow.Parent = FloatContainer

local FloatGradient = Instance.new("UIGradient")
FloatGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
	ColorSequenceKeypoint.new(0.05, Color3.fromRGB(255, 50, 0)),
	ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 100, 0)),
	ColorSequenceKeypoint.new(0.15, Color3.fromRGB(255, 150, 0)),
	ColorSequenceKeypoint.new(0.20, Color3.fromRGB(255, 200, 0)),
	ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 255, 0)),
	ColorSequenceKeypoint.new(0.30, Color3.fromRGB(200, 255, 0)),
	ColorSequenceKeypoint.new(0.35, Color3.fromRGB(100, 255, 0)),
	ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 0)),
	ColorSequenceKeypoint.new(0.45, Color3.fromRGB(0, 255, 100)),
	ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 200)),
	ColorSequenceKeypoint.new(0.55, Color3.fromRGB(0, 200, 255)),
	ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 100, 255)),
	ColorSequenceKeypoint.new(0.65, Color3.fromRGB(0, 0, 255)),
	ColorSequenceKeypoint.new(0.70, Color3.fromRGB(75, 0, 200)),
	ColorSequenceKeypoint.new(0.75, Color3.fromRGB(139, 0, 255)),
	ColorSequenceKeypoint.new(0.80, Color3.fromRGB(200, 0, 200)),
	ColorSequenceKeypoint.new(0.85, Color3.fromRGB(255, 0, 150)),
	ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 50)),
	ColorSequenceKeypoint.new(0.95, Color3.fromRGB(255, 50, 0)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
})
FloatGradient.Rotation = 0
FloatGradient.Parent = FloatRainbow
Instance.new("UICorner", FloatRainbow).CornerRadius = UDim.new(1, 0)

local FloatInner = Instance.new("Frame")
FloatInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FloatInner.BackgroundTransparency = 0.1
FloatInner.Size = UDim2.new(1, -8, 1, -8)
FloatInner.Position = UDim2.new(0, 4, 0, 4)
FloatInner.ZIndex = 99
FloatInner.Parent = FloatRainbow
Instance.new("UICorner", FloatInner).CornerRadius = UDim.new(1, 0)

local FloatCircle = Instance.new("ImageButton")
FloatCircle.Name = "FloatCircle"
FloatCircle.Size = UDim2.new(1, -16, 1, -16)
FloatCircle.Position = UDim2.new(0, 8, 0, 8)
FloatCircle.BackgroundTransparency = 1
FloatCircle.Image = "rbxassetid://139415924216817"
FloatCircle.ZIndex = 101
FloatCircle.AutoButtonColor = false
FloatCircle.Parent = FloatRainbow
Instance.new("UICorner", FloatCircle).CornerRadius = UDim.new(1, 0)

spawn(function()
	while FloatRainbow and FloatRainbow.Parent do
		FloatGradient.Rotation = (FloatGradient.Rotation + 1) % 360
		RunService.RenderStepped:Wait()
	end
end)

do
	local dragging, dragStart, startPos = false, nil, nil
	FloatCircle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true; dragStart = input.Position; startPos = FloatContainer.Position
		end
	end)
	FloatCircle.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			FloatContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

local NotificationHolder = SetProps(SetChildren(MakeElement("TFrame"), {
	SetProps(MakeElement("List"), {HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 5)})
}), {Position = UDim2.new(1, -25, 1, -25), Size = UDim2.new(0, 280, 1, -25), AnchorPoint = Vector2.new(1, 1), Parent = XvPxOL_UI})

function XvPxOL:MakeNotification(NotificationConfig)
	spawn(function()
		NotificationConfig.Name = NotificationConfig.Name or "通知"
		NotificationConfig.Content = NotificationConfig.Content or "内容"
		NotificationConfig.Image = NotificationConfig.Image or "rbxassetid://4384403532"
		NotificationConfig.Time = NotificationConfig.Time or 15

		local NotificationParent = SetProps(MakeElement("TFrame"), {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = NotificationHolder
		})

		local NotificationFrame = SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(245, 248, 255), 0, 8), {
			Parent = NotificationParent,
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(1, -55, 0, 0),
			BackgroundTransparency = 0.2,
			AutomaticSize = Enum.AutomaticSize.Y
		}), {
			MakeElement("Stroke", Color3.fromRGB(100, 160, 230), 1),
			MakeElement("Padding", 10, 10, 10, 10),
			SetProps(MakeElement("Image", NotificationConfig.Image), {
				Size = UDim2.new(0, 18, 0, 18),
				ImageColor3 = Color3.fromRGB(60, 130, 210),
				Name = "Icon"
			}),
			SetProps(MakeElement("Label", NotificationConfig.Name, 14), {
				Size = UDim2.new(1, -28, 0, 18),
				Position = UDim2.new(0, 28, 0, 0),
				Font = Enum.Font.GothamBold,
				Name = "Title"
			}),
			SetProps(MakeElement("Label", NotificationConfig.Content, 13), {
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 22),
				Font = Enum.Font.GothamSemibold,
				Name = "Content",
				AutomaticSize = Enum.AutomaticSize.Y,
				TextColor3 = Color3.fromRGB(120, 170, 230),
				TextWrapped = true
			})
		})

		TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 0, 0, 0)}):Play()
		task.wait(NotificationConfig.Time - 0.88)
		TweenService:Create(NotificationFrame.Icon, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {ImageTransparency = 1}):Play()
		TweenService:Create(NotificationFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.8}):Play()
		task.wait(0.3)
		TweenService:Create(NotificationFrame.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Transparency = 0.9}):Play()
		TweenService:Create(NotificationFrame.Title, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {TextTransparency = 0.4}):Play()
		TweenService:Create(NotificationFrame.Content, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {TextTransparency = 0.5}):Play()
		task.wait(0.05)
		NotificationFrame:TweenPosition(UDim2.new(1, 20, 0, 0), 'In', 'Quint', 0.8, true)
		task.wait(1.35)
		NotificationFrame:Destroy()
	end)
end

function XvPxOL:MakeWindow(WindowConfig)
	local FirstTab = true
	local Minimized = false
	local UIHidden = true

	WindowConfig = WindowConfig or {}
	WindowConfig.Name = WindowConfig.Name or "XvPxOL Library"
	WindowConfig.ConfigFolder = WindowConfig.ConfigFolder or WindowConfig.Name
	WindowConfig.SaveConfig = WindowConfig.SaveConfig or false
	WindowConfig.HidePremium = WindowConfig.HidePremium or false
	if WindowConfig.IntroEnabled == nil then WindowConfig.IntroEnabled = true end
	WindowConfig.IntroText = WindowConfig.IntroText or "XvPxOL Library"
	WindowConfig.CloseCallback = WindowConfig.CloseCallback or function() end
	WindowConfig.ShowIcon = WindowConfig.ShowIcon or false
	WindowConfig.Icon = WindowConfig.Icon or "rbxassetid://8834748103"
	WindowConfig.IntroIcon = WindowConfig.IntroIcon or "rbxassetid://8834748103"
	XvPxOL.Folder = WindowConfig.ConfigFolder
	XvPxOL.SaveCfg = WindowConfig.SaveConfig

	if WindowConfig.SaveConfig then
		if not isfolder(WindowConfig.ConfigFolder) then makefolder(WindowConfig.ConfigFolder) end
	end

	local TabHolder = AddThemeObject(SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(100, 160, 230), 3), {
		Size = UDim2.new(1, 0, 1, -45)
	}), {
		MakeElement("List"),
		MakeElement("Padding", 6, 0, 0, 6)
	}), "Divider")

	AddConnection(TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		TabHolder.CanvasSize = UDim2.new(0, 0, 0, TabHolder.UIListLayout.AbsoluteContentSize.Y + 16)
	end)

	local CloseBtn = SetChildren(SetProps(MakeElement("Button"), {
		Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), BackgroundTransparency = 1
	}), {
		AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072725342"), {
			Position = UDim2.new(0, 7, 0, 5), Size = UDim2.new(0, 16, 0, 16)
		}), "Text")
	})

	local MinimizeBtn = SetChildren(SetProps(MakeElement("Button"), {
		Size = UDim2.new(0.5, 0, 1, 0), BackgroundTransparency = 1
	}), {
		AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072719338"), {
			Position = UDim2.new(0, 7, 0, 5), Size = UDim2.new(0, 16, 0, 16), Name = "Ico"
		}), "Text")
	})

	local DragPoint = SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, 40)})

	local WindowStuff = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(245, 248, 255), 0, 8), {
		Size = UDim2.new(0, 135, 1, -45), Position = UDim2.new(0, 0, 0, 45), BackgroundTransparency = 0.15
	}), {
		AddThemeObject(SetProps(MakeElement("Frame"), {Size = UDim2.new(1, 0, 0, 8), Position = UDim2.new(0, 0, 0, 0)}), "Second"),
		AddThemeObject(SetProps(MakeElement("Frame"), {Size = UDim2.new(0, 8, 1, 0), Position = UDim2.new(1, -8, 0, 0)}), "Second"),
		AddThemeObject(SetProps(MakeElement("Frame"), {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0)}), "Stroke"),
		TabHolder,
		SetChildren(SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, 45), Position = UDim2.new(0, 0, 1, -45)}), {
			AddThemeObject(SetProps(MakeElement("Frame"), {Size = UDim2.new(1, 0, 0, 1)}), "Stroke"),
			AddThemeObject(SetChildren(SetProps(MakeElement("Frame"), {AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 8, 0.5, 0)}), {
				SetProps(MakeElement("Image", "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"), {Size = UDim2.new(1, 0, 1, 0)}),
				AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://4031889928"), {Size = UDim2.new(1, 0, 1, 0)}), "Second"),
				MakeElement("Corner", 1)
			}), "Divider"),
			SetChildren(SetProps(MakeElement("TFrame"), {AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 8, 0.5, 0)}), {
				AddThemeObject(MakeElement("Stroke"), "Stroke"), MakeElement("Corner", 1)
			}),
			AddThemeObject(SetProps(MakeElement("Label", LocalPlayer.DisplayName, WindowConfig.HidePremium and 13 or 12), {
				Size = UDim2.new(1, -50, 0, 12), Position = WindowConfig.HidePremium and UDim2.new(0, 42, 0, 17) or UDim2.new(0, 42, 0, 11),
				Font = Enum.Font.GothamBold, ClipsDescendants = true
			}), "Text"),
			AddThemeObject(SetProps(MakeElement("Label", "", 11), {
				Size = UDim2.new(1, -50, 0, 11), Position = UDim2.new(0, 42, 1, -22), Visible = not WindowConfig.HidePremium
			}), "TextDark")
		}),
	}), "Second")

	local WindowName = AddThemeObject(SetProps(MakeElement("Label", WindowConfig.Name, 13), {
		Size = UDim2.new(1, -25, 2, 0), Position = UDim2.new(0, 20, 0, -20), Font = Enum.Font.GothamBlack, TextSize = 18
	}), "Text")

	local WindowTopBarLine = AddThemeObject(SetProps(MakeElement("Frame"), {
		Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1)
	}), "Stroke")

	local MainWindow = SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(245, 248, 255), 0, 8), {
		Parent = XvPxOL_UI,
		Position = UDim2.new(0.5, -270, 0.5, -150),
		Size = UDim2.new(0, 540, 0, 300),
		ClipsDescendants = true,
		Active = true,
		Visible = false,
		BackgroundTransparency = 0.12
	}), {
		MakeElement("Stroke", Color3.fromRGB(100, 160, 230), 1.2),
		SetChildren(SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, 40), Name = "TopBar"}), {
			WindowName, WindowTopBarLine,
			AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 6), {
				Size = UDim2.new(0, 60, 0, 26), Position = UDim2.new(1, -75, 0, 7), BackgroundTransparency = 0.25
			}), {
				AddThemeObject(MakeElement("Stroke"), "Stroke"),
				AddThemeObject(SetProps(MakeElement("Frame"), {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(0.5, 0, 0, 0)}), "Stroke"),
				CloseBtn, MinimizeBtn
			}), "Second"),
		}),
		DragPoint, WindowStuff
	})

	CreateRainbowBorder(MainWindow, 3, 8)

	if WindowConfig.ShowIcon then
		WindowName.Position = UDim2.new(0, 42, 0, -20)
		SetProps(MakeElement("Image", WindowConfig.Icon), {
			Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 20, 0, 11), Parent = MainWindow.TopBar
		})
	end

	MakeDraggable(DragPoint, MainWindow)

	FloatCircle.MouseButton1Click:Connect(function()
		UIHidden = not UIHidden
		MainWindow.Visible = not UIHidden
	end)

	CloseBtn.MouseButton1Up:Connect(function()
		MainWindow.Visible = false
		UIHidden = true
		WindowConfig.CloseCallback()
	end)

	MinimizeBtn.MouseButton1Up:Connect(function()
		if Minimized then
			TweenService:Create(MainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 540, 0, 300)}):Play()
			MinimizeBtn.Ico.Image = "rbxassetid://7072719338"
			task.wait(.02)
			MainWindow.ClipsDescendants = false
			WindowStuff.Visible = true
			WindowTopBarLine.Visible = true
		else
			MainWindow.ClipsDescendants = true
			WindowTopBarLine.Visible = false
			MinimizeBtn.Ico.Image = "rbxassetid://7072720870"
			TweenService:Create(MainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, WindowName.TextBounds.X + 120, 0, 40)}):Play()
			task.wait(0.1)
			WindowStuff.Visible = false
		end
		Minimized = not Minimized
	end)

	local function LoadSequence()
		MainWindow.Visible = false
		local LoadSequenceLogo = SetProps(MakeElement("Image", WindowConfig.IntroIcon), {
			Parent = XvPxOL_UI, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.4, 0),
			Size = UDim2.new(0, 24, 0, 24), ImageColor3 = Color3.fromRGB(100, 160, 230), ImageTransparency = 1
		})
		local LoadSequenceText = SetProps(MakeElement("Label", WindowConfig.IntroText, 13), {
			Parent = XvPxOL_UI, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 16, 0.5, 0), TextXAlignment = Enum.TextXAlignment.Center,
			Font = Enum.Font.GothamBold, TextTransparency = 1
		})
		TweenService:Create(LoadSequenceLogo, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
		task.wait(0.8)
		TweenService:Create(LoadSequenceLogo, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -(LoadSequenceText.TextBounds.X / 2), 0.5, 0)}):Play()
		task.wait(0.3)
		TweenService:Create(LoadSequenceText, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
		task.wait(2)
		TweenService:Create(LoadSequenceText, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
		LoadSequenceLogo:Destroy()
		LoadSequenceText:Destroy()
	end

	if WindowConfig.IntroEnabled then
		LoadSequence()
	end

	local TabFunction = {}
	function TabFunction:MakeTab(TabConfig)
		TabConfig = TabConfig or {}
		TabConfig.Name = TabConfig.Name or "Tab"
		TabConfig.Icon = TabConfig.Icon or ""
		TabConfig.PremiumOnly = TabConfig.PremiumOnly or false

		local TabFrame = SetChildren(SetProps(MakeElement("Button"), {
			Size = UDim2.new(1, 0, 0, 26), Parent = TabHolder
		}), {
			AddThemeObject(SetProps(MakeElement("Image"), TabConfig.Icon), {
				AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.new(0, 16, 0, 16),
				Position = UDim2.new(0, 8, 0.5, 0), ImageTransparency = 0.3, Name = "Ico"
			}), "Text"),
			AddThemeObject(SetProps(MakeElement("Label", TabConfig.Name, 13), {
				Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 30, 0, 0),
				Font = Enum.Font.GothamSemibold, TextTransparency = 0.3, Name = "Title"
			}), "Text")
		})

		if GetIcon(TabConfig.Icon) ~= nil then TabFrame.Ico.Image = GetIcon(TabConfig.Icon) end

		local Container = AddThemeObject(SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(100, 160, 230), 4), {
			Size = UDim2.new(1, -135, 1, -45), Position = UDim2.new(0, 135, 0, 45),
			Parent = MainWindow, Visible = false, Name = "ItemContainer"
		}), {
			MakeElement("List", 0, 5), MakeElement("Padding", 12, 8, 8, 12)
		}), "Divider")

		AddConnection(Container.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			Container.CanvasSize = UDim2.new(0, 0, 0, Container.UIListLayout.AbsoluteContentSize.Y + 24)
		end)

		if FirstTab then
			FirstTab = false
			TabFrame.Ico.ImageTransparency = 0
			TabFrame.Title.TextTransparency = 0
			TabFrame.Title.Font = Enum.Font.GothamBlack
			Container.Visible = true
		end

		AddConnection(TabFrame.MouseButton1Click, function()
			for _, Tab in next, TabHolder:GetChildren() do
				if Tab:IsA("TextButton") then
					Tab.Title.Font = Enum.Font.GothamSemibold
					TweenService:Create(Tab.Ico, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0.3}):Play()
					TweenService:Create(Tab.Title, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0.3}):Play()
				end
			end
			for _, ic in next, MainWindow:GetChildren() do
				if ic.Name == "ItemContainer" then ic.Visible = false end
			end
			TweenService:Create(TabFrame.Ico, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
			TweenService:Create(TabFrame.Title, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
			TabFrame.Title.Font = Enum.Font.GothamBlack
			Container.Visible = true
		end)

		local function GetElements(ItemParent)
			local ElementFunction = {}

			function ElementFunction:AddLabel(Text)
				local LabelFrame = SetChildren(SetProps(MakeElement("TFrame"), {
					Size = UDim2.new(1, 0, 0, 24), Parent = ItemParent
				}), {
					AddThemeObject(SetProps(MakeElement("Label", Text, 14), {
						Size = UDim2.new(1, -8, 1, 0), Position = UDim2.new(0, 8, 0, 0),
						Font = Enum.Font.GothamBold, Name = "Content"
					}), "Text")
				})
				return {Set = function(ToChange) LabelFrame.Content.Text = ToChange end}
			end

			function ElementFunction:AddParagraph(Text, Content)
				Text = Text or "Text"
				Content = Content or "Content"
				local ParagraphFrame = SetChildren(SetProps(MakeElement("TFrame"), {
					Size = UDim2.new(1, 0, 0, 30), Parent = ItemParent
				}), {
					AddThemeObject(SetProps(MakeElement("Label", Text, 13), {
						Size = UDim2.new(1, -8, 0, 13), Position = UDim2.new(0, 8, 0, 6), Font = Enum.Font.GothamBold, Name = "Title"
					}), "Text"),
					AddThemeObject(SetProps(MakeElement("Label", "", 12), {
						Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 22),
						Font = Enum.Font.GothamSemibold, Name = "Content", TextWrapped = true
					}), "TextDark")
				})
				AddConnection(ParagraphFrame.Content:GetPropertyChangedSignal("Text"), function()
					ParagraphFrame.Content.Size = UDim2.new(1, -16, 0, ParagraphFrame.Content.TextBounds.Y)
					ParagraphFrame.Size = UDim2.new(1, 0, 0, ParagraphFrame.Content.TextBounds.Y + 30)
				end)
				ParagraphFrame.Content.Text = Content
				return {Set = function(ToChange) ParagraphFrame.Content.Text = ToChange end}
			end

			function ElementFunction:AddButton(ButtonConfig)
				ButtonConfig = ButtonConfig or {}
				ButtonConfig.Name = ButtonConfig.Name or "Button"
				ButtonConfig.Callback = ButtonConfig.Callback or function() end
				local Button = {}
				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})
				local ButtonFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 30), Parent = ItemParent, BackgroundTransparency = 0.3
				}), {
					AddThemeObject(SetProps(MakeElement("Label", ButtonConfig.Name, 13), {
						Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.GothamBold, Name = "Content"
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"), Click
				}), "Second")

				AddConnection(Click.MouseEnter, function()
					TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						BackgroundColor3 = Color3.fromRGB(100, 160, 230),
						BackgroundTransparency = 0.5
					}):Play()
				end)

				AddConnection(Click.MouseLeave, function()
					TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						BackgroundColor3 = XvPxOL.Themes[XvPxOL.SelectedTheme].Second,
						BackgroundTransparency = 0.3
					}):Play()
				end)

				AddConnection(Click.MouseButton1Up, function()
					spawn(function()
						Ripple(ButtonFrame)
						ButtonConfig.Callback()
					end)
				end)

				function Button:Set(ButtonText) ButtonFrame.Content.Text = ButtonText end
				return Button
			end

			function ElementFunction:AddToggle(ToggleConfig)
				ToggleConfig = ToggleConfig or {}
				ToggleConfig.Name = ToggleConfig.Name or "Toggle"
				ToggleConfig.Default = ToggleConfig.Default or false
				ToggleConfig.Callback = ToggleConfig.Callback or function() end
				ToggleConfig.Color = ToggleConfig.Color or Color3.fromRGB(100, 160, 230)
				ToggleConfig.Flag = ToggleConfig.Flag or nil
				ToggleConfig.Save = ToggleConfig.Save or false

				local Toggle = {Value = ToggleConfig.Default, Save = ToggleConfig.Save}
				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})

				local ToggleDisable = Create("Frame", {
					BackgroundColor3 = ToggleConfig.Default and ToggleConfig.Color or Color3.fromRGB(180, 190, 210),
					BorderSizePixel = 0,
					Size = UDim2.new(0, 36, 0, 22),
					Position = UDim2.new(1, -38, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = ToggleConfig.Default and 0.25 or 0.45
				}, {MakeElement("Corner", 0, 6)})

				local ToggleSwitch = Create("Frame", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Size = UDim2.new(0, 16, 0, 16),
					Position = ToggleConfig.Default and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5)
				}, {MakeElement("Corner", 0, 5)})
				ToggleSwitch.Parent = ToggleDisable

				MakeElement("Stroke", ToggleConfig.Color, 1.2).Parent = ToggleDisable

				local ToggleFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 34), Parent = ItemParent, BackgroundTransparency = 0.3
				}), {
					AddThemeObject(SetProps(MakeElement("Label", ToggleConfig.Name, 13), {
						Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.GothamBold, Name = "Content"
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"), ToggleDisable, Click
				}), "Second")

				function Toggle:Set(Value)
					Toggle.Value = Value
					TweenService:Create(ToggleDisable, TweenInfo.new(0.2), {
						BackgroundColor3 = Toggle.Value and ToggleConfig.Color or Color3.fromRGB(180, 190, 210),
						BackgroundTransparency = Toggle.Value and 0.25 or 0.45
					}):Play()
					TweenService:Create(ToggleSwitch, TweenInfo.new(0.2), {
						Position = Toggle.Value and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
					}):Play()
					ToggleConfig.Callback(Toggle.Value)
				end

				Toggle:Set(Toggle.Value)

				AddConnection(Click.MouseButton1Up, function()
					SaveCfg(game.GameId)
					Toggle:Set(not Toggle.Value)
				end)

				if ToggleConfig.Flag then XvPxOL.Flags[ToggleConfig.Flag] = Toggle end
				return Toggle
			end

			function ElementFunction:AddSlider(SliderConfig)
				SliderConfig = SliderConfig or {}
				SliderConfig.Name = SliderConfig.Name or "Slider"
				SliderConfig.Min = SliderConfig.Min or 0
				SliderConfig.Max = SliderConfig.Max or 100
				SliderConfig.Increment = SliderConfig.Increment or 1
				SliderConfig.Default = SliderConfig.Default or 50
				SliderConfig.Callback = SliderConfig.Callback or function() end
				SliderConfig.ValueName = SliderConfig.ValueName or ""
				SliderConfig.Color = SliderConfig.Color or Color3.fromRGB(100, 160, 230)
				SliderConfig.Flag = SliderConfig.Flag or nil
				SliderConfig.Save = SliderConfig.Save or false

				local Slider = {Value = SliderConfig.Default, Save = SliderConfig.Save}
				local SliderDragging = false

				local SliderModule = SetProps(MakeElement("TFrame"), {
					Size = UDim2.new(1, 0, 0, 38), Parent = ItemParent
				})

				local SliderBack = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 38), Parent = SliderModule, BackgroundTransparency = 0.3
				}), {
					AddThemeObject(SetProps(MakeElement("Label", SliderConfig.Name, 13), {
						Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.GothamBold, Name = "Content"
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke")
				}), "Second")

				local MinSlider = Create("TextButton", {
					Parent = SliderBack,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 178, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(0, 16, 0, 16),
					Font = Enum.Font.Gotham,
					Text = "-",
					TextColor3 = Color3.fromRGB(60, 130, 210),
					TextSize = 18,
					TextWrapped = true
				})

				local SliderBar = Create("Frame", {
					BackgroundColor3 = Color3.fromRGB(210, 220, 235),
					BorderSizePixel = 0,
					Size = UDim2.new(0, 100, 0, 10),
					Position = UDim2.new(0, 198, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Parent = SliderBack
				}, {MakeElement("Corner", 0, 4)})

				local SliderPart = Create("Frame", {
					BackgroundColor3 = SliderConfig.Color,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 50, 0, 10),
					Parent = SliderBar
				}, {MakeElement("Corner", 0, 4)})

				local AddSlider = Create("TextButton", {
					Parent = SliderBack,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 302, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(0, 16, 0, 16),
					Font = Enum.Font.Gotham,
					Text = "+",
					TextColor3 = Color3.fromRGB(60, 130, 210),
					TextSize = 18,
					TextWrapped = true
				})

				local SliderValBG = Create("Frame", {
					BackgroundColor3 = Color3.fromRGB(210, 220, 235),
					BorderSizePixel = 0,
					Size = UDim2.new(0, 40, 0, 20),
					Position = UDim2.new(1, -44, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5),
					Parent = SliderBack
				}, {MakeElement("Corner", 0, 5)})

				local SliderValue = Create("TextBox", {
					Parent = SliderValBG,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					Font = Enum.Font.Gotham,
					Text = tostring(SliderConfig.Default),
					TextColor3 = Color3.fromRGB(60, 130, 210),
					TextSize = 11,
					ClearTextOnFocus = false
				})

				local function updateFromMouse()
					if not SliderBar or not SliderBar.Parent then return end
					local barPos = SliderBar.AbsolutePosition.X
					local barSize = SliderBar.AbsoluteSize.X
					local mouseX = Mouse.X
					local SizeScale = math.clamp((mouseX - barPos) / barSize, 0, 1)
					local value = SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale)
					if SliderConfig.Increment > 1 then value = Round(value, SliderConfig.Increment) end
					Slider:Set(value)
				end

				SliderBar.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						SliderDragging = true
						updateFromMouse()
					end
				end)

				SliderBar.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						SliderDragging = false
						SaveCfg(game.GameId)
					end
				end)

				UserInputService.InputChanged:Connect(function(Input)
					if SliderDragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
						updateFromMouse()
					end
				end)

				MinSlider.MouseButton1Click:Connect(function()
					local currentValue = Slider.Value
					currentValue = math.clamp(currentValue - 1, SliderConfig.Min, SliderConfig.Max)
					Slider:Set(currentValue)
				end)

				AddSlider.MouseButton1Click:Connect(function()
					local currentValue = Slider.Value
					currentValue = math.clamp(currentValue + 1, SliderConfig.Min, SliderConfig.Max)
					Slider:Set(currentValue)
				end)

				AddConnection(SliderValue:GetPropertyChangedSignal("Text"), function()
					TweenService:Create(SliderValBG, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						Size = UDim2.new(0, math.max(SliderValue.TextBounds.X + 16, 36), 0, 20)
					}):Play()
				end)

				function Slider:Set(Value)
					self.Value = math.clamp(Value, SliderConfig.Min, SliderConfig.Max)
					local scale = (self.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
					TweenService:Create(SliderPart, TweenInfo.new(.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(scale, 0, 1, 0)
					}):Play()
					SliderValue.Text = tostring(self.Value) .. SliderConfig.ValueName
					SliderConfig.Callback(self.Value)
				end

				Slider:Set(Slider.Value)
				if SliderConfig.Flag then XvPxOL.Flags[SliderConfig.Flag] = Slider end
				return Slider
			end

			function ElementFunction:AddDropdown(DropdownConfig)
				DropdownConfig = DropdownConfig or {}
				DropdownConfig.Name = DropdownConfig.Name or "Dropdown"
				DropdownConfig.Options = DropdownConfig.Options or {}
				DropdownConfig.Default = DropdownConfig.Default or ""
				DropdownConfig.Callback = DropdownConfig.Callback or function() end
				DropdownConfig.Flag = DropdownConfig.Flag or nil
				DropdownConfig.Save = DropdownConfig.Save or false

				local Dropdown = {Value = DropdownConfig.Default, Options = DropdownConfig.Options, Buttons = {}, Toggled = false, Type = "Dropdown", Save = DropdownConfig.Save}
				local MaxElements = 4
				if not table.find(Dropdown.Options, Dropdown.Value) then Dropdown.Value = "..." end

				local DropdownList = MakeElement("List")
				local DropdownContainer = AddThemeObject(SetProps(SetChildren(MakeElement("ScrollFrame", Color3.fromRGB(100, 160, 230), 3), {DropdownList}), {
					Parent = ItemParent, Position = UDim2.new(0, 0, 0, 32), Size = UDim2.new(1, 0, 1, -32), ClipsDescendants = true
				}), "Divider")

				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})

				local DropdownFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 32), Parent = ItemParent, ClipsDescendants = true, BackgroundTransparency = 0.3
				}), {
					DropdownContainer,
					SetProps(SetChildren(MakeElement("TFrame"), {
						AddThemeObject(SetProps(MakeElement("Label", DropdownConfig.Name, 13), {
							Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.GothamBold, Name = "Content"
						}), "Text"),
						AddThemeObject(SetProps(MakeElement("Label", "...", 12), {
							Size = UDim2.new(1, -35, 1, 0), Font = Enum.Font.Gotham, Name = "Selected", TextXAlignment = Enum.TextXAlignment.Right
						}), "TextDark"),
						AddThemeObject(SetProps(MakeElement("Frame"), {
							Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), Name = "Line", Visible = false
						}), "Stroke"),
						Click
					}), {Size = UDim2.new(1, 0, 0, 32), ClipsDescendants = true, Name = "F"}),
					AddThemeObject(MakeElement("Stroke"), "Stroke"), MakeElement("Corner")
				}), "Second")

				AddConnection(DropdownList:GetPropertyChangedSignal("AbsoluteContentSize"), function()
					DropdownContainer.CanvasSize = UDim2.new(0, 0, 0, DropdownList.AbsoluteContentSize.Y)
				end)

				local function AddOptions(Options)
					for _, Option in pairs(Options) do
						local OptionBtn = AddThemeObject(SetProps(SetChildren(MakeElement("Button"), {
							MakeElement("Corner", 0, 5),
							AddThemeObject(SetProps(MakeElement("Label", Option, 12, 0.35), {
								Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(1, -8, 1, 0), Name = "Title"
							}), "Text")
						}), {
							Parent = DropdownContainer, Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, ClipsDescendants = true
						}), "Divider")

						AddConnection(OptionBtn.MouseButton1Click, function()
							Dropdown:Set(Option)
							SaveCfg(game.GameId)
						end)
						Dropdown.Buttons[Option] = OptionBtn
					end
				end

				function Dropdown:Refresh(Options, Delete)
					if Delete then
						for _, v in pairs(Dropdown.Buttons) do v:Destroy() end
						table.clear(Dropdown.Options)
						table.clear(Dropdown.Buttons)
					end
					Dropdown.Options = Options
					AddOptions(Dropdown.Options)
				end

				function Dropdown:Set(Value)
					if not table.find(Dropdown.Options, Value) then
						Dropdown.Value = "..."
						DropdownFrame.F.Selected.Text = Dropdown.Value
						for _, v in pairs(Dropdown.Buttons) do
							TweenService:Create(v, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
							TweenService:Create(v.Title, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0.35}):Play()
						end
						return
					end
					Dropdown.Value = Value
					DropdownFrame.F.Selected.Text = Dropdown.Value
					for _, v in pairs(Dropdown.Buttons) do
						TweenService:Create(v, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
						TweenService:Create(v.Title, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0.35}):Play()
					end
					TweenService:Create(Dropdown.Buttons[Value], TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.15}):Play()
					TweenService:Create(Dropdown.Buttons[Value].Title, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
					return DropdownConfig.Callback(Dropdown.Value)
				end

				AddConnection(Click.MouseButton1Click, function()
					Dropdown.Toggled = not Dropdown.Toggled
					DropdownFrame.F.Line.Visible = Dropdown.Toggled
					if #Dropdown.Options > MaxElements then
						TweenService:Create(DropdownFrame, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Dropdown.Toggled and UDim2.new(1, 0, 0, 32 + (MaxElements * 24)) or UDim2.new(1, 0, 0, 32)}):Play()
					else
						TweenService:Create(DropdownFrame, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Dropdown.Toggled and UDim2.new(1, 0, 0, DropdownList.AbsoluteContentSize.Y + 32) or UDim2.new(1, 0, 0, 32)}):Play()
					end
				end)

				Dropdown:Refresh(Dropdown.Options, false)
				Dropdown:Set(Dropdown.Value)
				if DropdownConfig.Flag then XvPxOL.Flags[DropdownConfig.Flag] = Dropdown end
				return Dropdown
			end

			function ElementFunction:AddBind(BindConfig)
				BindConfig = BindConfig or {}
				BindConfig.Name = BindConfig.Name or "Bind"
				BindConfig.Default = BindConfig.Default or Enum.KeyCode.Unknown
				BindConfig.Hold = BindConfig.Hold or false
				BindConfig.Callback = BindConfig.Callback or function() end
				BindConfig.Flag = BindConfig.Flag or nil
				BindConfig.Save = BindConfig.Save or false

				local Bind = {Value = BindConfig.Default, Binding = false, Type = "Bind", Save = BindConfig.Save}
				local Holding = false
				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})

				local BindBox = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 4), {
					Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -10, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 0.35
				}), {
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					AddThemeObject(SetProps(MakeElement("Label", "...", 12), {
						Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.GothamBold,
						TextXAlignment = Enum.TextXAlignment.Center, Name = "Value"
					}), "Text")
				}), "Main")

				local BindFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 34), Parent = ItemParent, BackgroundTransparency = 0.3
				}), {
					AddThemeObject(SetProps(MakeElement("Label", BindConfig.Name, 13), {
						Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.GothamBold, Name = "Content"
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"), BindBox, Click
				}), "Second")

				AddConnection(BindBox.Value:GetPropertyChangedSignal("Text"), function()
					TweenService:Create(BindBox, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, BindBox.Value.TextBounds.X + 14, 0, 20)}):Play()
				end)

				AddConnection(Click.InputEnded, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						if Bind.Binding then return end
						Bind.Binding = true
						BindBox.Value.Text = "..."
					end
				end)

				AddConnection(UserInputService.InputBegan, function(Input)
					if UserInputService:GetFocusedTextBox() then return end
					if (Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value) and not Bind.Binding then
						if BindConfig.Hold then Holding = true; BindConfig.Callback(Holding) else BindConfig.Callback() end
					elseif Bind.Binding then
						local Key
						pcall(function() if not CheckKey(BlacklistedKeys, Input.KeyCode) then Key = Input.KeyCode end end)
						pcall(function() if CheckKey(WhitelistedMouse, Input.UserInputType) and not Key then Key = Input.UserInputType end end)
						Key = Key or Bind.Value
						Bind:Set(Key)
						SaveCfg(game.GameId)
					end
				end)

				AddConnection(UserInputService.InputEnded, function(Input)
					if Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value then
						if BindConfig.Hold and Holding then Holding = false; BindConfig.Callback(Holding) end
					end
				end)

				function Bind:Set(Key)
					Bind.Binding = false
					Bind.Value = Key or Bind.Value
					Bind.Value = Bind.Value.Name or Bind.Value
					BindBox.Value.Text = Bind.Value
				end

				Bind:Set(BindConfig.Default)
				if BindConfig.Flag then XvPxOL.Flags[BindConfig.Flag] = Bind end
				return Bind
			end

			function ElementFunction:AddTextbox(TextboxConfig)
				TextboxConfig = TextboxConfig or {}
				TextboxConfig.Name = TextboxConfig.Name or "Textbox"
				TextboxConfig.Default = TextboxConfig.Default or ""
				TextboxConfig.TextDisappear = TextboxConfig.TextDisappear or false
				TextboxConfig.Callback = TextboxConfig.Callback or function() end

				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})
				local TextboxActual = AddThemeObject(Create("TextBox", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
					TextColor3 = Color3.fromRGB(60, 130, 210), PlaceholderColor3 = Color3.fromRGB(120, 170, 230),
					PlaceholderText = "输入...", Font = Enum.Font.GothamSemibold,
					TextXAlignment = Enum.TextXAlignment.Center, TextSize = 12, ClearTextOnFocus = false
				}), "Text")

				local TextContainer = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 4), {
					Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -10, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 0.35
				}), {
					AddThemeObject(MakeElement("Stroke"), "Stroke"), TextboxActual
				}), "Main")

				local TextboxFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 34), Parent = ItemParent, BackgroundTransparency = 0.3
				}), {
					AddThemeObject(SetProps(MakeElement("Label", TextboxConfig.Name, 13), {
						Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.GothamBold, Name = "Content"
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"), TextContainer, Click
				}), "Second")

				AddConnection(TextboxActual:GetPropertyChangedSignal("Text"), function()
					TweenService:Create(TextContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, TextboxActual.TextBounds.X + 14, 0, 20)}):Play()
				end)

				AddConnection(TextboxActual.FocusLost, function()
					TextboxConfig.Callback(TextboxActual.Text)
					if TextboxConfig.TextDisappear then TextboxActual.Text = "" end
				end)

				TextboxActual.Text = TextboxConfig.Default

				AddConnection(Click.MouseButton1Up, function() TextboxActual:CaptureFocus() end)
			end

			return ElementFunction
		end

		local ElementFunction = {}

		function ElementFunction:AddSection(SectionConfig)
			SectionConfig.Name = SectionConfig.Name or "Section"
			local SectionFrame = SetChildren(SetProps(MakeElement("TFrame"), {
				Size = UDim2.new(1, 0, 0, 22), Parent = Container
			}), {
				AddThemeObject(SetProps(MakeElement("Label", SectionConfig.Name, 12), {
					Size = UDim2.new(1, -8, 0, 14), Position = UDim2.new(0, 0, 0, 2), Font = Enum.Font.GothamSemibold
				}), "TextDark"),
				SetChildren(SetProps(MakeElement("TFrame"), {
					AnchorPoint = Vector2.new(0, 0), Size = UDim2.new(1, 0, 1, -20),
					Position = UDim2.new(0, 0, 0, 20), Name = "Holder"
				}), {MakeElement("List", 0, 5)}),
			})
			AddConnection(SectionFrame.Holder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
				SectionFrame.Size = UDim2.new(1, 0, 0, SectionFrame.Holder.UIListLayout.AbsoluteContentSize.Y + 26)
				SectionFrame.Holder.Size = UDim2.new(1, 0, 0, SectionFrame.Holder.UIListLayout.AbsoluteContentSize.Y)
			end)
			local SectionFunction = {}
			for i, v in next, GetElements(SectionFrame.Holder) do SectionFunction[i] = v end
			return SectionFunction
		end

		for i, v in next, GetElements(Container) do ElementFunction[i] = v end

		if TabConfig.PremiumOnly then
			for i, v in next, ElementFunction do ElementFunction[i] = function() end end
		end
		return ElementFunction
	end

	return TabFunction
end

function XvPxOL:Destroy()
	XvPxOL_UI:Destroy()
end

return XvPxOL
