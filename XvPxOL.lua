-- XvPxOL UI Library
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

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
	SaveCfg = false,
	Registry = {},
	DPIRegistry = {},
	DPIScale = 1,
	CornerRadius = 6,
	IsLightTheme = true,
	Scheme = {
		BackgroundColor = Color3.fromRGB(240, 243, 250),
		MainColor = Color3.fromRGB(225, 235, 255),
		AccentColor = Color3.fromRGB(100, 160, 230),
		OutlineColor = Color3.fromRGB(100, 160, 230),
		FontColor = Color3.fromRGB(60, 130, 210),
		Red = Color3.fromRGB(255, 80, 80),
		Dark = Color3.fromRGB(30, 30, 35),
		White = Color3.fromRGB(255, 255, 255),
	},
	SearchText = "",
	Searching = false,
	ActiveTab = nil,
	Tabs = {},
	DependencyBoxes = {},
	Signals = {},
	UnloadSignals = {},
	MinSize = Vector2.new(480, 300),
	Toggled = true,
	Unloaded = false,
}

-- Feather Icons
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

local Orion = Instance.new("ScreenGui")
Orion.Name = "XvPxOL"
Orion.ResetOnSpawn = false
Orion.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Orion.DisplayOrder = 999

if syn then syn.protect_gui(Orion); Orion.Parent = game.CoreGui
else Orion.Parent = gethui() or game.CoreGui end

if gethui then
	for _, v in ipairs(gethui():GetChildren()) do
		if v.Name == Orion.Name and v ~= Orion then v:Destroy() end
	end
else
	for _, v in ipairs(game.CoreGui:GetChildren()) do
		if v.Name == Orion.Name and v ~= Orion then v:Destroy() end
	end
end

function XvPxOL:IsRunning()
	if gethui then return Orion.Parent == gethui() else return Orion.Parent == game.CoreGui end
end

local function AddConnection(Signal, Func)
	if not XvPxOL:IsRunning() then return end
	local c = Signal:Connect(Func); table.insert(XvPxOL.Connections, c); return c
end

task.spawn(function()
	while XvPxOL:IsRunning() do task.wait() end
	for _, c in next, XvPxOL.Connections do c:Disconnect() end
end)

-- 工具函数
local function Create(Name, Properties, Children)
	local obj = Instance.new(Name)
	for i, v in next, Properties or {} do obj[i] = v end
	for i, v in next, Children or {} do v.Parent = obj end
	return obj
end

local function CreateElement(ElementName, ElementFunction)
	XvPxOL.Elements[ElementName] = function(...) return ElementFunction(...) end
end

local function MakeElement(ElementName, ...)
	return XvPxOL.Elements[ElementName](...)
end

local function SetProps(Element, Props)
	for k, v in pairs(Props) do pcall(function() Element[k] = v end) end
	return Element
end

local function SetChildren(Element, Children)
	for _, v in pairs(Children) do v.Parent = Element end
	return Element
end

local function Round(Number, Factor)
	local r = math.floor(Number/Factor + (math.sign(Number) * 0.5)) * Factor
	if r < 0 then r = r + Factor end
	return r
end

local function ReturnProperty(Object)
	if Object:IsA("Frame") or Object:IsA("TextButton") then return "BackgroundColor3"
	elseif Object:IsA("ScrollingFrame") then return "ScrollBarImageColor3"
	elseif Object:IsA("UIStroke") then return "Color"
	elseif Object:IsA("TextLabel") or Object:IsA("TextBox") then return "TextColor3"
	elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then return "ImageColor3" end
end

local function AddThemeObject(Object, Type)
	if not XvPxOL.ThemeObjects[Type] then XvPxOL.ThemeObjects[Type] = {} end
	table.insert(XvPxOL.ThemeObjects[Type], Object)
	pcall(function() Object[ReturnProperty(Object)] = XvPxOL.Themes[XvPxOL.SelectedTheme][Type] end)
	return Object
end

-- 彩虹颜色注册系统(从Obsidian搬)
function XvPxOL:AddToRegistry(Instance, Properties)
	XvPxOL.Registry[Instance] = Properties
end

function XvPxOL:UpdateColorsUsingRegistry()
	for Instance, Properties in pairs(XvPxOL.Registry) do
		for Property, ColorIdx in pairs(Properties) do
			if typeof(ColorIdx) == "string" then
				if ColorIdx == "BackgroundColor" then
					Instance[Property] = Color3.fromHSV((tick() * 0.3) % 1, 0.8, 0.15)
				elseif ColorIdx == "MainColor" then
					Instance[Property] = Color3.fromHSV((tick() * 0.3) % 1, 0.8, 0.25)
				elseif ColorIdx == "AccentColor" then
					Instance[Property] = Color3.fromHSV((tick() * 0.5) % 1, 0.8, 1)
				elseif ColorIdx == "OutlineColor" then
					Instance[Property] = Color3.fromHSV((tick() * 0.3) % 1, 0.8, 0.4)
				elseif ColorIdx == "FontColor" then
					Instance[Property] = Color3.fromHSV((tick() * 0.5) % 1, 0.8, 1)
				else
					Instance[Property] = XvPxOL.Scheme[ColorIdx]
				end
			elseif typeof(ColorIdx) == "function" then
				Instance[Property] = ColorIdx()
			end
		end
	end
end

function XvPxOL:StartRainbowEffect()
	if self.RainbowConnection then self.RainbowConnection:Disconnect() end
	self.RainbowConnection = RunService.RenderStepped:Connect(function()
		self:UpdateColorsUsingRegistry()
	end)
end

function XvPxOL:StopRainbowEffect()
	if self.RainbowConnection then
		self.RainbowConnection:Disconnect()
		self.RainbowConnection = nil
	end
end

-- 文本大小计算(从Obsidian搬)
function XvPxOL:GetTextBounds(Text, Font, Size, Width)
	local Params = Instance.new("GetTextBoundsParams")
	Params.Text = Text
	Params.RichText = true
	Params.Font = Font or Enum.Font.Gotham
	Params.Size = Size or 14
	Params.Width = Width or workspace.CurrentCamera.ViewportSize.X - 32
	local Bounds = TextService:GetTextBoundsAsync(Params)
	return Bounds.X, Bounds.Y
end

-- 鼠标悬停检测(从Obsidian搬)
function XvPxOL:MouseIsOverFrame(Frame, MousePos)
	local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
	return MousePos.X >= AbsPos.X and MousePos.X <= AbsPos.X + AbsSize.X
		and MousePos.Y >= AbsPos.Y and MousePos.Y <= AbsPos.Y + AbsSize.Y
end

-- 安全回调(从Obsidian搬)
function XvPxOL:SafeCallback(Func, ...)
	if not (Func and typeof(Func) == "function") then return end
	local Result = table.pack(xpcall(Func, function(Error)
		task.defer(error, debug.traceback(Error, 2))
		return Error
	end, ...))
	if not Result[1] then return nil end
	return table.unpack(Result, 2, Result.n)
end

local function SaveCfg(Name)
	local Data = {}
	for i, v in pairs(XvPxOL.Flags) do
		if v.Save then Data[i] = v.Value end
	end
	if XvPxOL.Folder then writefile(XvPxOL.Folder .. "/" .. Name .. ".txt", HttpService:JSONEncode(Data)) end
end

local WhitelistedMouse = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3}
local BlacklistedKeys = {Enum.KeyCode.Unknown, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Up, Enum.KeyCode.Left, Enum.KeyCode.Down, Enum.KeyCode.Right, Enum.KeyCode.Slash, Enum.KeyCode.Tab, Enum.KeyCode.Backspace, Enum.KeyCode.Escape}

local function CheckKey(Table, Key)
	for _, v in next, Table do if v == Key then return true end end
end

-- 元素创建函数
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

-- 彩虹边框函数(从Rainmiao库搬来)
local function CreateRainbowBorder(parent, thickness, cornerRadius)
	local border = Instance.new("Frame")
	border.BackgroundTransparency = 1
	border.Size = UDim2.new(1, thickness*2, 1, thickness*2)
	border.Position = UDim2.new(0, -thickness, 0, -thickness)
	border.ZIndex = parent.ZIndex - 1
	border.Name = "RainbowBorder"
	border.Parent = parent
	
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
			gradient.Rotation = (gradient.Rotation + 0.5) % 360
			RunService.RenderStepped:Wait()
		end
	end)
	
	return border
end

-- 拖拽函数(从Obsidian搬)
local function MakeDraggable(UI, DragFrame)
	local StartPos, FramePos, Dragging = nil, nil, false
	local Changed
	
	DragFrame.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			StartPos = Input.Position
			FramePos = UI.Position
			Dragging = true
			
			Changed = Input.Changed:Connect(function()
				if Input.UserInputState ~= Enum.UserInputState.End then return end
				Dragging = false
				if Changed and Changed.Connected then Changed:Disconnect(); Changed = nil end
			end)
		end
	end)
	
	AddConnection(UserInputService.InputChanged, function(Input)
		if not (Orion and Orion.Parent) then Dragging = false; return end
		if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
			local Delta = Input.Position - StartPos
			UI.Position = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
		end
	end)
end

-- ============ 悬浮窗 ============
local FloatContainer = Instance.new("Frame")
FloatContainer.Size = UDim2.new(0, 68, 0, 68)
FloatContainer.Position = UDim2.new(0, 20, 0.5, -34)
FloatContainer.BackgroundTransparency = 1
FloatContainer.Name = "FloatContainer"
FloatContainer.Parent = Orion

local FloatBorder = Instance.new("Frame")
FloatBorder.BackgroundTransparency = 1
FloatBorder.Size = UDim2.new(1, 0, 1, 0)
FloatBorder.Parent = FloatContainer

local FloatGradient = Instance.new("UIGradient")
FloatGradient.Color = ColorSequence.new({
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
FloatGradient.Rotation = 45
FloatGradient.Parent = FloatBorder

local FloatInner = Instance.new("Frame")
FloatInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FloatInner.BackgroundTransparency = 0.15
FloatInner.Size = UDim2.new(1, -6, 1, -6)
FloatInner.Position = UDim2.new(0, 3, 0, 3)
FloatInner.Parent = FloatBorder

Instance.new("UICorner", FloatBorder).CornerRadius = UDim.new(1, 0)
Instance.new("UICorner", FloatInner).CornerRadius = UDim.new(1, 0)

local FloatCircle = Instance.new("ImageButton")
FloatCircle.Name = "FloatCircle"
FloatCircle.Size = UDim2.new(1, -12, 1, -12)
FloatCircle.Position = UDim2.new(0, 6, 0, 6)
FloatCircle.BackgroundTransparency = 1
FloatCircle.Image = "rbxassetid://139415924216817"
FloatCircle.Parent = FloatBorder
Instance.new("UICorner", FloatCircle).CornerRadius = UDim.new(1, 0)

spawn(function()
	while FloatBorder and FloatBorder.Parent do
		FloatGradient.Rotation = (FloatGradient.Rotation + 1) % 360
		RunService.RenderStepped:Wait()
	end
end)

-- 悬浮窗拖拽
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

-- ============ 通知系统 ============
local NotificationHolder = SetProps(SetChildren(MakeElement("TFrame"), {
	SetProps(MakeElement("List"), {HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 5)})
}), {Position = UDim2.new(1, -25, 1, -25), Size = UDim2.new(0, 280, 1, -25), AnchorPoint = Vector2.new(1, 1), Parent = Orion})

function XvPxOL:MakeNotification(NotificationConfig)
	spawn(function()
		NotificationConfig.Name = NotificationConfig.Name or "通知"
		NotificationConfig.Content = NotificationConfig.Content or "内容"
		NotificationConfig.Time = NotificationConfig.Time or 15

		local NotificationParent = SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = NotificationHolder})
		local NotificationFrame = SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(245, 248, 255), 0, 8), {
			Parent = NotificationParent, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(1, -55, 0, 0), BackgroundTransparency = 0.2, AutomaticSize = Enum.AutomaticSize.Y
		}), {
			MakeElement("Stroke", Color3.fromRGB(100, 160, 230), 1), MakeElement("Padding", 10, 10, 10, 10),
			SetProps(MakeElement("Label", NotificationConfig.Name, 14), {Size = UDim2.new(1, 0, 0, 18), Font = Enum.Font.GothamBold, Name = "Title"}),
			SetProps(MakeElement("Label", NotificationConfig.Content, 13), {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 22), Font = Enum.Font.GothamSemibold, Name = "Content", AutomaticSize = Enum.AutomaticSize.Y, TextColor3 = Color3.fromRGB(120, 170, 230), TextWrapped = true})
		})

		TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 0, 0, 0)}):Play()
		task.wait(NotificationConfig.Time - 0.88)
		TweenService:Create(NotificationFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.8}):Play()
		task.wait(0.3)
		TweenService:Create(NotificationFrame.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Transparency = 0.9}):Play()
		task.wait(0.05)
		NotificationFrame:TweenPosition(UDim2.new(1, 20, 0, 0), 'In', 'Quint', 0.8, true)
		task.wait(1.35)
		NotificationFrame:Destroy()
	end)
end

-- ============ 主窗口 ============
function XvPxOL:MakeWindow(WindowConfig)
	local FirstTab = true
	local Minimized = false
	local UIHidden = true

	WindowConfig = WindowConfig or {}
	WindowConfig.Name = WindowConfig.Name or "XvPxOL Library"
	WindowConfig.ConfigFolder = WindowConfig.ConfigFolder or WindowConfig.Name
	WindowConfig.SaveConfig = WindowConfig.SaveConfig or false
	if WindowConfig.IntroEnabled == nil then WindowConfig.IntroEnabled = true end
	WindowConfig.IntroText = WindowConfig.IntroText or "XvPxOL Library"
	WindowConfig.CloseCallback = WindowConfig.CloseCallback or function() end
	XvPxOL.Folder = WindowConfig.ConfigFolder
	XvPxOL.SaveCfg = WindowConfig.SaveConfig

	if WindowConfig.SaveConfig then
		if not isfolder(WindowConfig.ConfigFolder) then makefolder(WindowConfig.ConfigFolder) end
	end

	local TabHolder = AddThemeObject(SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(100, 160, 230), 3), {
		Size = UDim2.new(1, 0, 1, -45)
	}), {MakeElement("List"), MakeElement("Padding", 6, 0, 0, 6)}), "Divider")

	AddConnection(TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		TabHolder.CanvasSize = UDim2.new(0, 0, 0, TabHolder.UIListLayout.AbsoluteContentSize.Y + 16)
	end)

	local CloseBtn = SetChildren(SetProps(MakeElement("Button"), {Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), BackgroundTransparency = 1}), {
		AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072725342"), {Position = UDim2.new(0, 7, 0, 5), Size = UDim2.new(0, 16, 0, 16)}), "Text")
	})

	local MinimizeBtn = SetChildren(SetProps(MakeElement("Button"), {Size = UDim2.new(0.5, 0, 1, 0), BackgroundTransparency = 1}), {
		AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072719338"), {Position = UDim2.new(0, 7, 0, 5), Size = UDim2.new(0, 16, 0, 16), Name = "Ico"}), "Text")
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
			AddThemeObject(SetProps(MakeElement("Label", LocalPlayer.DisplayName, 12), {
				Size = UDim2.new(1, -50, 0, 12), Position = UDim2.new(0, 42, 0, 17), Font = Enum.Font.GothamBold, ClipsDescendants = true
			}), "Text"),
		}),
	}), "Second")

	local WindowName = AddThemeObject(SetProps(MakeElement("Label", WindowConfig.Name, 13), {
		Size = UDim2.new(1, -25, 2, 0), Position = UDim2.new(0, 20, 0, -20), Font = Enum.Font.GothamBlack, TextSize = 18
	}), "Text")

	local WindowTopBarLine = AddThemeObject(SetProps(MakeElement("Frame"), {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1)}), "Stroke")

	local MainWindow = SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(245, 248, 255), 0, 8), {
		Parent = Orion, Position = UDim2.new(0.5, -270, 0.5, -150), Size = UDim2.new(0, 540, 0, 300),
		ClipsDescendants = true, Active = true, Visible = false, BackgroundTransparency = 0.12
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

	-- 主窗口彩虹边框
	CreateRainbowBorder(MainWindow, 3, 8)

	-- 主窗口拖拽
	MakeDraggable(MainWindow, DragPoint)

	-- 悬浮窗点击打开菜单
	FloatCircle.MouseButton1Click:Connect(function()
		UIHidden = not UIHidden
		MainWindow.Visible = not UIHidden
	end)

	-- 关闭按钮
	CloseBtn.MouseButton1Up:Connect(function()
		XvPxOL:MakeNotification({Name = "已关闭", Content = "点击悬浮球可重新打开", Time = 3})
		MainWindow.Visible = false
		UIHidden = true
		WindowConfig.CloseCallback()
	end)

	-- 缩小按钮
	MinimizeBtn.MouseButton1Up:Connect(function()
		MainWindow.Visible = false
		UIHidden = true
		XvPxOL:MakeNotification({Name = "已缩小", Content = "点击悬浮球重新打开", Time = 2})
	end)

	if WindowConfig.IntroEnabled then
		MainWindow.Visible = false
		local LoadSequenceLogo = SetProps(MakeElement("Image", "rbxassetid://8834748103"), {
			Parent = Orion, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 24, 0, 24), ImageColor3 = Color3.fromRGB(100, 160, 230), ImageTransparency = 1
		})
		local LoadSequenceText = SetProps(MakeElement("Label", WindowConfig.IntroText, 13), {
			Parent = Orion, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 16, 0.5, 0), TextXAlignment = Enum.TextXAlignment.Center,
			Font = Enum.Font.GothamBold, TextTransparency = 1
		})
		TweenService:Create(LoadSequenceLogo, TweenInfo.new(.3, Enum.EasingStyle.Quad), {ImageTransparency = 0}):Play()
		task.wait(0.8)
		TweenService:Create(LoadSequenceLogo, TweenInfo.new(.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, -(LoadSequenceText.TextBounds.X / 2), 0.5, 0)}):Play()
		task.wait(0.3)
		TweenService:Create(LoadSequenceText, TweenInfo.new(.3, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
		task.wait(2)
		TweenService:Create(LoadSequenceText, TweenInfo.new(.3, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
		LoadSequenceLogo:Destroy(); LoadSequenceText:Destroy()
	end
```

这是第二部分（Tab系统+所有元素）：

```lua
	-- ============ Tab系统 ============
	local TabFunction = {}
	function TabFunction:MakeTab(TabConfig)
		TabConfig = TabConfig or {}
		TabConfig.Name = TabConfig.Name or "Tab"

		local TabFrame = SetChildren(SetProps(MakeElement("Button"), {
			Size = UDim2.new(1, 0, 0, 28), Parent = TabHolder
		}), {
			AddThemeObject(SetProps(MakeElement("Label", TabConfig.Name, 13), {
				Size = UDim2.new(1, -16, 1, 0), Position = UDim2.new(0, 8, 0, 0),
				Font = Enum.Font.GothamSemibold, TextTransparency = 0.3, Name = "Title"
			}), "Text")
		})

		local Container = AddThemeObject(SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(100, 160, 230), 4), {
			Size = UDim2.new(1, -135, 1, -45), Position = UDim2.new(0, 135, 0, 45),
			Parent = MainWindow, Visible = false, Name = "ItemContainer"
		}), {MakeElement("List", 0, 5), MakeElement("Padding", 12, 8, 8, 12)}), "Divider")

		AddConnection(Container.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			Container.CanvasSize = UDim2.new(0, 0, 0, Container.UIListLayout.AbsoluteContentSize.Y + 24)
		end)

		if FirstTab then
			FirstTab = false
			TabFrame.Title.TextTransparency = 0
			TabFrame.Title.Font = Enum.Font.GothamBlack
			Container.Visible = true
		end

		AddConnection(TabFrame.MouseButton1Click, function()
			for _, Tab in next, TabHolder:GetChildren() do
				if Tab:IsA("TextButton") and Tab.Title then
					Tab.Title.Font = Enum.Font.GothamSemibold
					TweenService:Create(Tab.Title, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {TextTransparency = 0.3}):Play()
				end
			end
			for _, ic in next, MainWindow:GetChildren() do
				if ic.Name == "ItemContainer" then ic.Visible = false end
			end
			TweenService:Create(TabFrame.Title, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
			TabFrame.Title.Font = Enum.Font.GothamBlack
			Container.Visible = true
		end)

		local function GetElements(ItemParent)
			local ElementFunction = {}

			-- Label
			function ElementFunction:AddLabel(Text)
				local LabelFrame = SetChildren(SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, 24), Parent = ItemParent}), {
					AddThemeObject(SetProps(MakeElement("Label", Text, 14), {
						Size = UDim2.new(1, -8, 1, 0), Position = UDim2.new(0, 8, 0, 0), Font = Enum.Font.GothamBold, Name = "Content"
					}), "Text")
				})
				return {Set = function(v) LabelFrame.Content.Text = v end}
			end

			-- Paragraph
			function ElementFunction:AddParagraph(Text, Content)
				Text = Text or "Text"; Content = Content or "Content"
				local ParagraphFrame = SetChildren(SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, 30), Parent = ItemParent}), {
					AddThemeObject(SetProps(MakeElement("Label", Text, 13), {Size = UDim2.new(1, -8, 0, 13), Position = UDim2.new(0, 8, 0, 6), Font = Enum.Font.GothamBold, Name = "Title"}), "Text"),
					AddThemeObject(SetProps(MakeElement("Label", "", 12), {Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 22), Font = Enum.Font.GothamSemibold, Name = "Content", TextWrapped = true}), "TextDark")
				})
				AddConnection(ParagraphFrame.Content:GetPropertyChangedSignal("Text"), function()
					ParagraphFrame.Content.Size = UDim2.new(1, -16, 0, ParagraphFrame.Content.TextBounds.Y)
					ParagraphFrame.Size = UDim2.new(1, 0, 0, ParagraphFrame.Content.TextBounds.Y + 30)
				end)
				ParagraphFrame.Content.Text = Content
				return {Set = function(v) ParagraphFrame.Content.Text = v end}
			end

			-- Button(Obsidian风格)
			function ElementFunction:AddButton(ButtonConfig)
				ButtonConfig = ButtonConfig or {}
				local Button = {Text = ButtonConfig.Name or "Button", Func = ButtonConfig.Callback or function() end, Disabled = false, Visible = true, Type = "Button"}
				local Holder = SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, 30), Parent = ItemParent})
				local Base = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})
				
				local ButtonFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 30), Parent = Holder, BackgroundTransparency = 0.3
				}), {
					AddThemeObject(SetProps(MakeElement("Label", Button.Text, 13), {
						Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.GothamBold, Name = "Content", TextTransparency = 0.4
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"), Base
				}), "Second")

				AddConnection(Base.MouseEnter, function()
					if Button.Disabled then return end
					TweenService:Create(ButtonFrame.Content, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
				end)
				AddConnection(Base.MouseLeave, function()
					if Button.Disabled then return end
					TweenService:Create(ButtonFrame.Content, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {TextTransparency = 0.4}):Play()
				end)
				AddConnection(Base.MouseButton1Click, function()
					if not Button.Disabled then XvPxOL:SafeCallback(Button.Func) end
				end)

				function Button:SetDisabled(Disabled) Button.Disabled = Disabled; Base.Active = not Disabled end
				function Button:SetText(Text) Button.Text = Text; ButtonFrame.Content.Text = Text end
				function Button:SetVisible(Visible) Button.Visible = Visible; Holder.Visible = Visible end
				function Button:SetCallback(Callback) Button.Func = Callback end

				Button.Holder = Holder
				table.insert(XvPxOL.Tabs[#XvPxOL.Tabs] and XvPxOL.Tabs[#XvPxOL.Tabs].Elements or {}, Button)
				return Button
			end

			-- Toggle(Obsidian风格开关)
			function ElementFunction:AddToggle(ToggleConfig)
				ToggleConfig = ToggleConfig or {}
				local Toggle = {Text = ToggleConfig.Name or "Toggle", Value = ToggleConfig.Default or false, Disabled = false, Visible = true, Save = ToggleConfig.Save or false, Type = "Toggle"}
				local color = ToggleConfig.Color or Color3.fromRGB(100, 160, 230)
				local Base = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})

				-- 开关背景
				local Switch = SetChildren(SetProps(MakeElement("Frame"), {
					AnchorPoint = Vector2.new(1, 0),
					BackgroundColor3 = Toggle.Value and color or Color3.fromRGB(180, 190, 210),
					Position = UDim2.fromScale(1, 0),
					Size = UDim2.fromOffset(32, 18),
					BackgroundTransparency = Toggle.Value and 0.25 or 0.45
				}), {MakeElement("Corner", 1, 0)})
				
				New("UIPadding", {PaddingBottom = UDim.new(0, 2), PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 2), PaddingTop = UDim.new(0, 2), Parent = Switch})
				
				local Ball = SetChildren(SetProps(MakeElement("Frame"), {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Size = UDim2.fromScale(1, 1),
					SizeConstraint = Enum.SizeConstraint.RelativeYY
				}), {MakeElement("Corner", 1, 0)})
				Ball.Parent = Switch
				
				local SwitchStroke = SetProps(MakeElement("Stroke", color, 1.2), {Parent = Switch})

				local Holder = SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, 34), Parent = ItemParent})
				
				local Label = AddThemeObject(SetProps(MakeElement("Label", Toggle.Text, 13), {
					Size = UDim2.new(1, -44, 1, 0), Position = UDim2.new(0, 0, 0, 0), Font = Enum.Font.GothamBold, Name = "Content", TextTransparency = Toggle.Value and 0 or 0.4
				}), "Text")
				Label.Parent = Holder
				Switch.Parent = Holder
				Base.Parent = Holder

				-- 设置Ball初始位置
				Ball.AnchorPoint = Vector2.new(Toggle.Value and 1 or 0, 0)
				Ball.Position = UDim2.fromScale(Toggle.Value and 1 or 0, 0)

				local function Display()
					local offset = Toggle.Value and 1 or 0
					TweenService:Create(Ball, TweenInfo.new(0.2), {AnchorPoint = Vector2.new(offset, 0), Position = UDim2.fromScale(offset, 0)}):Play()
					TweenService:Create(Switch, TweenInfo.new(0.2), {
						BackgroundColor3 = Toggle.Value and color or Color3.fromRGB(180, 190, 210),
						BackgroundTransparency = Toggle.Value and 0.25 or 0.45
					}):Play()
					TweenService:Create(Label, TweenInfo.new(0.2), {TextTransparency = Toggle.Value and 0 or 0.4}):Play()
				end

				function Toggle:SetValue(Value)
					if Toggle.Disabled then return end
					Toggle.Value = Value
					Display()
					XvPxOL:SafeCallback(ToggleConfig.Callback, Toggle.Value)
					SaveCfg(game.GameId)
				end

				AddConnection(Base.MouseButton1Click, function() Toggle:SetValue(not Toggle.Value) end)

				function Toggle:SetDisabled(Disabled) Toggle.Disabled = Disabled; Base.Active = not Disabled end
				function Toggle:SetText(Text) Toggle.Text = Text; Label.Text = Text end
				function Toggle:SetVisible(Visible) Toggle.Visible = Visible; Holder.Visible = Visible end
				function Toggle:OnChanged(Func) ToggleConfig.Callback = Func end

				Toggle.Holder = Holder
				if ToggleConfig.Flag then XvPxOL.Flags[ToggleConfig.Flag] = Toggle end
				return Toggle
			end

			-- Slider(Obsidian风格)
			function ElementFunction:AddSlider(SliderConfig)
				SliderConfig = SliderConfig or {}
				local min = SliderConfig.Min or 0; local max = SliderConfig.Max or 100
				local def = SliderConfig.Default or 50; local inc = SliderConfig.Increment or 1
				local color = SliderConfig.Color or Color3.fromRGB(100, 160, 230)
				local Slider = {Value = def, Min = min, Max = max, Rounding = inc > 1 and 0 or 0, Save = SliderConfig.Save or false, Type = "Slider"}

				local Holder = SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, SliderConfig.Name and 52 or 38), Parent = ItemParent})

				if SliderConfig.Name then
					AddThemeObject(SetProps(MakeElement("Label", SliderConfig.Name, 13), {
						Size = UDim2.new(1, -8, 0, 14), Position = UDim2.new(0, 4, 0, 4), Font = Enum.Font.GothamBold, Name = "Content"
					}), "Text").Parent = Holder
				end

				local Bar = SetChildren(SetProps(MakeElement("TextButton"), {
					Active = true,
					BackgroundColor3 = Color3.fromRGB(210, 220, 235),
					BorderColor3 = color,
					BorderSizePixel = 1,
					Position = UDim2.new(0, 4, 0, SliderConfig.Name and 26 or 10),
					Size = UDim2.new(1, -8, 0, 18),
					Text = ""
				}), {MakeElement("Corner", 0, 4)})
				Bar.Parent = Holder

				local Fill = SetChildren(SetProps(MakeElement("Frame"), {
					BackgroundColor3 = color,
					Size = UDim2.fromScale((def - min) / (max - min), 1)
				}), {MakeElement("Corner", 0, 4)})
				Fill.Parent = Bar

				-- 数值标签
				local DisplayLabel = AddThemeObject(SetProps(MakeElement("Label", tostring(def) .. (SliderConfig.ValueName or ""), 12), {
					Size = UDim2.new(1, -8, 0, 14), Position = UDim2.new(0, 4, 0, 0),
					Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Right, Name = "Value"
				}), "TextDark")
				DisplayLabel.Parent = Bar

				local dragging = false
				local function updateFromMouse()
					if not Bar or not Bar.Parent then return end
					local barPos = Bar.AbsolutePosition.X
					local barSize = Bar.AbsoluteSize.X
					local scale = math.clamp((Mouse.X - barPos) / barSize, 0, 1)
					local value = math.floor(min + (max - min) * scale)
					if inc > 1 then value = Round(value, inc) end
					Slider:SetValue(value)
				end

				Bar.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true; updateFromMouse()
					end
				end)
				AddConnection(UserInputService.InputEnded, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
						dragging = false; SaveCfg(game.GameId)
					end
				end)
				AddConnection(UserInputService.InputChanged, function(Input)
					if dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then updateFromMouse() end
				end)

				function Slider:SetValue(Value)
					self.Value = math.clamp(Value, min, max)
					local scale = (self.Value - min) / (max - min)
					TweenService:Create(Fill, TweenInfo.new(.1), {Size = UDim2.fromScale(scale, 1)}):Play()
					DisplayLabel.Text = tostring(self.Value) .. (SliderConfig.ValueName or "")
					XvPxOL:SafeCallback(SliderConfig.Callback, self.Value)
				end

				function Slider:SetMax(Value) self.Max = Value; self:SetValue(math.clamp(self.Value, min, Value)) end
				function Slider:SetMin(Value) self.Min = Value; self:SetValue(math.clamp(self.Value, Value, max)) end
				function Slider:SetVisible(Visible) Holder.Visible = Visible end
				function Slider:OnChanged(Func) SliderConfig.Callback = Func end

				Slider:SetValue(Slider.Value)
				Slider.Holder = Holder
				if SliderConfig.Flag then XvPxOL.Flags[SliderConfig.Flag] = Slider end
				return Slider
			end

			-- Dropdown(Obsidian风格)
			function ElementFunction:AddDropdown(DropdownConfig)
				DropdownConfig = DropdownConfig or {}
				local opts = DropdownConfig.Options or {}
				local Dropdown = {Value = DropdownConfig.Default or "", Options = opts, Buttons = {}, Toggled = false, Type = "Dropdown", Save = DropdownConfig.Save or false}
				local MaxElements = 4
				if not table.find(opts, Dropdown.Value) then Dropdown.Value = "..." end

				local Holder = SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, 32), Parent = ItemParent, ClipsDescendants = true})

				local DropdownList = MakeElement("List")
				local DropdownContainer = AddThemeObject(SetProps(SetChildren(MakeElement("ScrollFrame", Color3.fromRGB(100, 160, 230), 3), {DropdownList}), {
					Parent = Holder, Position = UDim2.new(0, 0, 0, 32), Size = UDim2.new(1, 0, 1, -32), ClipsDescendants = true
				}), "Divider")

				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})
				local DropdownFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 32), Parent = Holder, BackgroundTransparency = 0.3
				}), {
					DropdownContainer,
					SetProps(SetChildren(MakeElement("TFrame"), {
						AddThemeObject(SetProps(MakeElement("Label", DropdownConfig.Name or "Dropdown", 13), {
							Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.GothamBold, Name = "Content"
						}), "Text"),
						AddThemeObject(SetProps(MakeElement("Label", "...", 12), {
							Size = UDim2.new(1, -35, 1, 0), Font = Enum.Font.Gotham, Name = "Selected", TextXAlignment = Enum.TextXAlignment.Right
						}), "TextDark"),
						AddThemeObject(SetProps(MakeElement("Frame"), {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), Name = "Line", Visible = false}), "Stroke"),
						Click
					}), {Size = UDim2.new(1, 0, 0, 32), ClipsDescendants = true, Name = "F"}),
					AddThemeObject(MakeElement("Stroke"), "Stroke"), MakeElement("Corner")
				}), "Second")

				AddConnection(DropdownList:GetPropertyChangedSignal("AbsoluteContentSize"), function()
					DropdownContainer.CanvasSize = UDim2.new(0, 0, 0, DropdownList.AbsoluteContentSize.Y)
				end)

				local function AddOptions(Options)
					for _, Option in pairs(Options) do
						local btn = AddThemeObject(SetProps(SetChildren(MakeElement("Button"), {
							MakeElement("Corner", 0, 5),
							AddThemeObject(SetProps(MakeElement("Label", Option, 12, 0.35), {
								Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(1, -8, 1, 0), Name = "Title"
							}), "Text")
						}), {Parent = DropdownContainer, Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, ClipsDescendants = true}), "Divider")
						AddConnection(btn.MouseButton1Click, function() Dropdown:Set(Option); SaveCfg(game.GameId) end)
						Dropdown.Buttons[Option] = btn
					end
				end

				function Dropdown:Refresh(Options, Delete)
					if Delete then for _, v in pairs(Dropdown.Buttons) do v:Destroy() end; table.clear(Dropdown.Options); table.clear(Dropdown.Buttons) end
					Dropdown.Options = Options; AddOptions(Dropdown.Options)
				end

				function Dropdown:Set(Value)
					if not table.find(Dropdown.Options, Value) then
						Dropdown.Value = "..."; DropdownFrame.F.Selected.Text = Dropdown.Value
						for _, v in pairs(Dropdown.Buttons) do
							TweenService:Create(v, TweenInfo.new(.15), {BackgroundTransparency = 1}):Play()
							TweenService:Create(v.Title, TweenInfo.new(.15), {TextTransparency = 0.35}):Play()
						end
						return
					end
					Dropdown.Value = Value; DropdownFrame.F.Selected.Text = Value
					for _, v in pairs(Dropdown.Buttons) do
						TweenService:Create(v, TweenInfo.new(.15), {BackgroundTransparency = 1}):Play()
						TweenService:Create(v.Title, TweenInfo.new(.15), {TextTransparency = 0.35}):Play()
					end
					TweenService:Create(Dropdown.Buttons[Value], TweenInfo.new(.15), {BackgroundTransparency = 0.15}):Play()
					TweenService:Create(Dropdown.Buttons[Value].Title, TweenInfo.new(.15), {TextTransparency = 0}):Play()
					XvPxOL:SafeCallback(DropdownConfig.Callback, Value)
				end

				AddConnection(Click.MouseButton1Click, function()
					Dropdown.Toggled = not Dropdown.Toggled
					DropdownFrame.F.Line.Visible = Dropdown.Toggled
					local h = #Dropdown.Options > MaxElements and 32 + (MaxElements * 24) or DropdownList.AbsoluteContentSize.Y + 32
					TweenService:Create(DropdownFrame, TweenInfo.new(.15), {Size = Dropdown.Toggled and UDim2.new(1, 0, 0, h) or UDim2.new(1, 0, 0, 32)}):Play()
					Holder.Size = UDim2.new(1, 0, 0, Dropdown.Toggled and h or 32)
				end)

				Dropdown:Refresh(opts, false); Dropdown:Set(Dropdown.Value)
				if DropdownConfig.Flag then XvPxOL.Flags[DropdownConfig.Flag] = Dropdown end
				Dropdown.Holder = Holder
				return Dropdown
			end

			-- Bind
			function ElementFunction:AddBind(BindConfig)
				BindConfig = BindConfig or {}
				local Bind = {Value = BindConfig.Default or Enum.KeyCode.Unknown, Binding = false, Type = "Bind", Save = BindConfig.Save or false}
				local Holding = false
				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})

				local BindBox = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 4), {
					Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -10, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 0.35
				}), {
					AddThemeObject(MakeElement("Stroke"), "Stroke"),
					AddThemeObject(SetProps(MakeElement("Label", "...", 12), {Size = UDim2.new(1, 0, 1, 0), Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Center, Name = "Value"}), "Text")
				}), "Main")

				local Holder = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 34), Parent = ItemParent, BackgroundTransparency = 0.3
				}), {
					AddThemeObject(SetProps(MakeElement("Label", BindConfig.Name or "Bind", 13), {
						Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.GothamBold, Name = "Content"
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"), BindBox, Click
				}), "Second")

				AddConnection(Click.InputEnded, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						if Bind.Binding then return end; Bind.Binding = true; BindBox.Value.Text = "..."
					end
				end)

				AddConnection(UserInputService.InputBegan, function(Input)
					if UserInputService:GetFocusedTextBox() then return end
					if (Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value) and not Bind.Binding then
						if BindConfig.Hold then Holding = true; XvPxOL:SafeCallback(BindConfig.Callback, Holding)
						else XvPxOL:SafeCallback(BindConfig.Callback) end
					elseif Bind.Binding then
						local Key
						pcall(function() if not CheckKey(BlacklistedKeys, Input.KeyCode) then Key = Input.KeyCode end end)
						pcall(function() if CheckKey(WhitelistedMouse, Input.UserInputType) and not Key then Key = Input.UserInputType end end)
						Key = Key or Bind.Value; Bind.Binding = false; Bind.Value = Key; Bind.Value = Bind.Value.Name or Bind.Value
						BindBox.Value.Text = Bind.Value; SaveCfg(game.GameId)
					end
				end)

				AddConnection(UserInputService.InputEnded, function(Input)
					if Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value then
						if BindConfig.Hold and Holding then Holding = false; XvPxOL:SafeCallback(BindConfig.Callback, Holding) end
					end
				end)

				BindBox.Value.Text = Bind.Value.Name or Bind.Value
				if BindConfig.Flag then XvPxOL.Flags[BindConfig.Flag] = Bind end
				Bind.Holder = Holder
				return Bind
			end

			-- Textbox
			function ElementFunction:AddTextbox(TextboxConfig)
				TextboxConfig = TextboxConfig or {}
				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})
				local TextboxActual = AddThemeObject(Create("TextBox", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(60, 130, 210),
					PlaceholderColor3 = Color3.fromRGB(120, 170, 230), PlaceholderText = "输入...",
					Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Center, TextSize = 12, ClearTextOnFocus = false
				}), "Text")

				local TextContainer = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 4), {
					Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -10, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 0.35
				}), {AddThemeObject(MakeElement("Stroke"), "Stroke"), TextboxActual}), "Main")

				local Holder = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 34), Parent = ItemParent, BackgroundTransparency = 0.3
				}), {
					AddThemeObject(SetProps(MakeElement("Label", TextboxConfig.Name or "Textbox", 13), {
						Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.GothamBold, Name = "Content"
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"), TextContainer, Click
				}), "Second")

				AddConnection(TextboxActual.FocusLost, function()
					XvPxOL:SafeCallback(TextboxConfig.Callback, TextboxActual.Text)
					if TextboxConfig.TextDisappear then TextboxActual.Text = "" end
				end)
				TextboxActual.Text = TextboxConfig.Default or ""
				AddConnection(Click.MouseButton1Up, function() TextboxActual:CaptureFocus() end)
			end

			return ElementFunction
		end

		local ElementFunction = {}
		function ElementFunction:AddSection(SectionConfig)
			local SectionFrame = SetChildren(SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, 22), Parent = Container}), {
				AddThemeObject(SetProps(MakeElement("Label", SectionConfig.Name or "Section", 12), {
					Size = UDim2.new(1, -8, 0, 14), Position = UDim2.new(0, 0, 0, 2), Font = Enum.Font.GothamSemibold
				}), "TextDark"),
				SetChildren(SetProps(MakeElement("TFrame"), {
					AnchorPoint = Vector2.new(0, 0), Size = UDim2.new(1, 0, 1, -20), Position = UDim2.new(0, 0, 0, 20), Name = "Holder"
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
		return ElementFunction
	end

	table.insert(XvPxOL.Tabs, TabFunction)
	return TabFunction
end

function XvPxOL:Destroy()
	self:StopRainbowEffect()
	Orion:Destroy()
end

function XvPxOL:Unload()
	self:StopRainbowEffect()
	for _, c in ipairs(self.Signals) do c:Disconnect() end
	self.Signals = {}
	self.Unloaded = true
	Orion:Destroy()
end

return XvPxOL