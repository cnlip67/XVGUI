local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Teams = game:GetService("Teams")
local ContextActionService = game:GetService("ContextActionService")
local CollectionService = game:GetService("CollectionService")
local GroupService = game:GetService("GroupService")
local InsertService = game:GetService("InsertService")
local LogService = game:GetService("LogService")
local MarketplaceService = game:GetService("MarketplaceService")
local PathfindingService = game:GetService("PathfindingService")
local PhysicsService = game:GetService("PhysicsService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TeleportService = game:GetService("TeleportService")
local Chat = game:GetService("Chat")
local DataStoreService = game:GetService("DataStoreService")
local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")
local HapticService = game:GetService("HapticService")
local VRService = game:GetService("VRService")
local AnalyticsService = game:GetService("AnalyticsService")
local AssetService = game:GetService("AssetService")
local BrowserService = game:GetService("BrowserService")
local ContentProvider = game:GetService("ContentProvider")
local Debris = game:GetService("Debris")
local DraggerService = game:GetService("DraggerService")
local FriendService = game:GetService("FriendService")
local Geometry = game:GetService("Geometry")
local LocalizationService = game:GetService("LocalizationService")
local MaterialService = game:GetService("MaterialService")
local MeshPartService = game:GetService("MeshPartService")
local NotificationService = game:GetService("NotificationService")
local PermissionsService = game:GetService("PermissionsService")
local PluginService = game:GetService("PluginService")
local PointsService = game:GetService("PointsService")
local ProcessService = game:GetService("ProcessService")
local PublishService = game:GetService("PublishService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RuntimeScriptService = game:GetService("RuntimeScriptService")
local ScriptRegistrationService = game:GetService("ScriptRegistrationService")
local Selection = game:GetService("Selection")
local SessionService = game:GetService("SessionService")
local Stats = game:GetService("Stats")
local Studio = game:GetService("Studio")
local StudioCallout = game:GetService("StudioCallout")
local StudioData = game:GetService("StudioData")
local StudioService = game:GetService("StudioService")
local TestService = game:GetService("TestService")
local TimerService = game:GetService("TimerService")
local TouchInputService = game:GetService("TouchInputService")

local XvPxOL = {
	Elements = {},
	ThemeObjects = {},
	Connections = {},
	Flags = {},
	Registry = {},
	DPIRegistry = {},
	Signals = {},
	UnloadSignals = {},
	Tabs = {},
	DependencyBoxes = {},
	Notifications = {},
	KeybindToggles = {},
	Themes = {
		Default = {
			Main = Color3.fromRGB(245, 248, 255),
			Second = Color3.fromRGB(225, 235, 255),
			Stroke = Color3.fromRGB(100, 160, 230),
			Divider = Color3.fromRGB(100, 160, 230),
			Text = Color3.fromRGB(60, 130, 210),
			TextDark = Color3.fromRGB(120, 170, 230)
		},
		Dark = {
			Main = Color3.fromRGB(30, 30, 35),
			Second = Color3.fromRGB(40, 40, 48),
			Stroke = Color3.fromRGB(100, 160, 230),
			Divider = Color3.fromRGB(80, 140, 210),
			Text = Color3.fromRGB(180, 200, 240),
			TextDark = Color3.fromRGB(140, 160, 200)
		},
		Light = {
			Main = Color3.fromRGB(255, 255, 255),
			Second = Color3.fromRGB(240, 243, 250),
			Stroke = Color3.fromRGB(100, 160, 230),
			Divider = Color3.fromRGB(100, 160, 230),
			Text = Color3.fromRGB(50, 120, 200),
			TextDark = Color3.fromRGB(100, 150, 210)
		},
		Ocean = {
			Main = Color3.fromRGB(230, 245, 255),
			Second = Color3.fromRGB(210, 230, 250),
			Stroke = Color3.fromRGB(30, 140, 210),
			Divider = Color3.fromRGB(30, 140, 210),
			Text = Color3.fromRGB(20, 100, 180),
			TextDark = Color3.fromRGB(60, 140, 200)
		},
		Midnight = {
			Main = Color3.fromRGB(20, 22, 30),
			Second = Color3.fromRGB(30, 33, 42),
			Stroke = Color3.fromRGB(80, 100, 200),
			Divider = Color3.fromRGB(80, 100, 200),
			Text = Color3.fromRGB(160, 180, 240),
			TextDark = Color3.fromRGB(120, 140, 200)
		},
		Forest = {
			Main = Color3.fromRGB(235, 245, 235),
			Second = Color3.fromRGB(215, 235, 220),
			Stroke = Color3.fromRGB(40, 160, 80),
			Divider = Color3.fromRGB(40, 160, 80),
			Text = Color3.fromRGB(30, 120, 60),
			TextDark = Color3.fromRGB(80, 170, 120)
		},
		Sunset = {
			Main = Color3.fromRGB(255, 245, 235),
			Second = Color3.fromRGB(255, 235, 215),
			Stroke = Color3.fromRGB(230, 120, 40),
			Divider = Color3.fromRGB(230, 120, 40),
			Text = Color3.fromRGB(200, 80, 20),
			TextDark = Color3.fromRGB(220, 140, 80)
		},
		Purple = {
			Main = Color3.fromRGB(248, 240, 255),
			Second = Color3.fromRGB(235, 220, 250),
			Stroke = Color3.fromRGB(140, 60, 220),
			Divider = Color3.fromRGB(140, 60, 220),
			Text = Color3.fromRGB(100, 30, 180),
			TextDark = Color3.fromRGB(150, 100, 210)
		}
	},
	SelectedTheme = "Default",
	Folder = nil,
	SaveCfg = false,
	DPIScale = 1,
	MinSize = Vector2.new(480, 300),
	Unloaded = false,
	RainbowConnection = nil,
	Scheme = {
		BackgroundColor = Color3.fromRGB(240, 243, 250),
		MainColor = Color3.fromRGB(225, 235, 255),
		AccentColor = Color3.fromRGB(100, 160, 230),
		OutlineColor = Color3.fromRGB(100, 160, 230),
		FontColor = Color3.fromRGB(60, 130, 210),
		Red = Color3.fromRGB(255, 80, 80),
		Green = Color3.fromRGB(80, 255, 120),
		Dark = Color3.fromRGB(30, 30, 35),
		White = Color3.fromRGB(255, 255, 255),
		Gray = Color3.fromRGB(180, 190, 210)
	}
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
XvPxOL_UI.DisplayOrder = 999

if syn then
	syn.protect_gui(XvPxOL_UI)
	XvPxOL_UI.Parent = CoreGui
else
	XvPxOL_UI.Parent = gethui() or CoreGui
end

local function CleanupOldUI()
	local parent = gethui and gethui() or CoreGui
	for _, v in ipairs(parent:GetChildren()) do
		if v.Name == "XvPxOL" and v ~= XvPxOL_UI then v:Destroy() end
	end
end
CleanupOldUI()

function XvPxOL:IsRunning()
	if gethui then return XvPxOL_UI.Parent == gethui() else return XvPxOL_UI.Parent == CoreGui end
end

local function AddConnection(Signal, Function)
	if not XvPxOL:IsRunning() then return end
	local c = Signal:Connect(Function)
	table.insert(XvPxOL.Connections, c)
	return c
end

task.spawn(function()
	while XvPxOL:IsRunning() do task.wait() end
	for _, c in next, XvPxOL.Connections do pcall(function() c:Disconnect() end) end
end)

function XvPxOL:AddToRegistry(Instance, Properties)
	XvPxOL.Registry[Instance] = Properties
end

function XvPxOL:UpdateColorsUsingRegistry()
	for Instance, Properties in pairs(XvPxOL.Registry) do
		for Property, ColorIdx in pairs(Properties) do
			if typeof(ColorIdx) == "string" then
				if ColorIdx == "BackgroundColor" then Instance[Property] = Color3.fromHSV((tick() * 0.3) % 1, 0.8, 0.15)
				elseif ColorIdx == "MainColor" then Instance[Property] = Color3.fromHSV((tick() * 0.3) % 1, 0.8, 0.25)
				elseif ColorIdx == "AccentColor" then Instance[Property] = Color3.fromHSV((tick() * 0.5) % 1, 0.8, 1)
				elseif ColorIdx == "OutlineColor" then Instance[Property] = Color3.fromHSV((tick() * 0.3) % 1, 0.8, 0.4)
				elseif ColorIdx == "FontColor" then Instance[Property] = Color3.fromHSV((tick() * 0.5) % 1, 0.8, 1)
				else Instance[Property] = XvPxOL.Scheme[ColorIdx] end
			elseif typeof(ColorIdx) == "function" then Instance[Property] = ColorIdx() end
		end
	end
end

function XvPxOL:StartRainbowEffect()
	if self.RainbowConnection then self.RainbowConnection:Disconnect() end
	self.RainbowConnection = RunService.RenderStepped:Connect(function() self:UpdateColorsUsingRegistry() end)
end

function XvPxOL:StopRainbowEffect()
	if self.RainbowConnection then self.RainbowConnection:Disconnect(); self.RainbowConnection = nil end
end

function XvPxOL:GetTextBounds(Text, Font, Size, Width)
	local Params = Instance.new("GetTextBoundsParams")
	Params.Text = Text; Params.RichText = true
	Params.Font = Font or Enum.Font.Gotham; Params.Size = Size or 14
	Params.Width = Width or Workspace.CurrentCamera.ViewportSize.X - 32
	local Bounds = TextService:GetTextBoundsAsync(Params)
	return Bounds.X, Bounds.Y
end

function XvPxOL:MouseIsOverFrame(Frame, MousePos)
	local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
	return MousePos.X >= AbsPos.X and MousePos.X <= AbsPos.X + AbsSize.X and MousePos.Y >= AbsPos.Y and MousePos.Y <= AbsPos.Y + AbsSize.Y
end

function XvPxOL:SafeCallback(Func, ...)
	if not (Func and typeof(Func) == "function") then return end
	local Result = table.pack(xpcall(Func, function(Error) task.defer(error, debug.traceback(Error, 2)); return Error end, ...))
	if not Result[1] then return nil end
	return table.unpack(Result, 2, Result.n)
end

local function MakeDraggable(guiObject, mainFrame)
	local dragging, dragStart, startPos = false, nil, nil
	guiObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true; dragStart = input.Position; startPos = mainFrame.Position
		end
	end)
	guiObject.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

local function MakeResizable(UI, DragFrame, Callback)
	local StartPos, FrameSize, Dragging = nil, nil, false
	DragFrame.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then StartPos = Input.Position; FrameSize = UI.Size; Dragging = true end
	end)
	DragFrame.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
	end)
	UserInputService.InputChanged:Connect(function(Input)
		if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
			local Delta = Input.Position - StartPos
			UI.Size = UDim2.new(FrameSize.X.Scale, math.clamp(FrameSize.X.Offset + Delta.X, XvPxOL.MinSize.X, math.huge), FrameSize.Y.Scale, math.clamp(FrameSize.Y.Offset + Delta.Y, XvPxOL.MinSize.Y, math.huge))
			if Callback then XvPxOL:SafeCallback(Callback) end
		end
	end)
end

local function ApplyDPIScale(value)
	if XvPxOL.DPIScale == 1 then return value end
	if typeof(value) == "UDim2" then return UDim2.new(value.X.Scale, value.X.Offset * XvPxOL.DPIScale, value.Y.Scale, value.Y.Offset * XvPxOL.DPIScale) end
	if typeof(value) == "UDim" then return UDim.new(value.Scale, value.Offset * XvPxOL.DPIScale) end
	if typeof(value) == "number" then return value * XvPxOL.DPIScale end
	return value
end

local function Create(Name, Properties, Children)
	local Object = Instance.new(Name)
	for i, v in next, Properties or {} do
		if i == "Size" or i == "Position" or string.match(i, "Padding") then Object[i] = ApplyDPIScale(v)
		elseif i == "TextSize" then Object[i] = ApplyDPIScale(v)
		else Object[i] = v end
	end
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

local function SetTheme(ThemeName)
	if not XvPxOL.Themes[ThemeName] then return end
	XvPxOL.SelectedTheme = ThemeName
	for Type, Objects in pairs(XvPxOL.ThemeObjects) do
		for _, Object in pairs(Objects) do Object[ReturnProperty(Object)] = XvPxOL.Themes[ThemeName][Type] end
	end
end
XvPxOL.SetTheme = SetTheme

local function SaveCfg(Name)
	local Data = {}
	for i, v in pairs(XvPxOL.Flags) do if v.Save then Data[i] = v.Value end end
	if XvPxOL.Folder then writefile(XvPxOL.Folder .. "/" .. Name .. ".txt", HttpService:JSONEncode(Data)) end
end

local function LoadCfg(Config)
	local Data = HttpService:JSONDecode(Config)
	table.foreach(Data, function(a, b)
		if XvPxOL.Flags[a] then spawn(function() XvPxOL.Flags[a]:Set(b) end) end
	end)
end
XvPxOL.LoadCfg = LoadCfg

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
	gradient.Rotation = 0
	gradient.Parent = border

	local inner = Instance.new("Frame")
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

	return border, gradient
end

local function CreateGradientBorder(parent, colors, thickness)
	local border = Instance.new("Frame")
	border.BackgroundTransparency = 1
	border.Size = UDim2.new(1, thickness*2, 1, thickness*2)
	border.Position = UDim2.new(0, -thickness, 0, -thickness)
	border.ZIndex = parent.ZIndex - 1
	border.Name = "GradientBorder"
	border.Parent = parent

	local gradient = Instance.new("UIGradient")
	local colorSequence = {}
	for i, colorData in ipairs(colors) do table.insert(colorSequence, ColorSequenceKeypoint.new(colorData.Time, colorData.Color)) end
	gradient.Color = ColorSequence.new(colorSequence)
	gradient.Rotation = 0
	gradient.Parent = border

	local inner = Instance.new("Frame")
	inner.BackgroundTransparency = 1
	inner.Size = UDim2.new(1, -thickness*2, 1, -thickness*2)
	inner.Position = UDim2.new(0, thickness, 0, thickness)
	inner.ZIndex = parent.ZIndex
	inner.Parent = border

	spawn(function()
		while border and border.Parent do
			gradient.Rotation = (gradient.Rotation + 0.5) % 360
			RunService.RenderStepped:Wait()
		end
	end)

	return border, gradient
end

local function RippleEffect(obj)
	spawn(function()
		if obj.ClipsDescendants ~= true then obj.ClipsDescendants = true end
		local Ripple = Instance.new("ImageLabel")
		Ripple.Name = "Ripple"; Ripple.Parent = obj
		Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Ripple.BackgroundTransparency = 1.000
		Ripple.ZIndex = 8; Ripple.Image = "rbxassetid://2708891598"
		Ripple.ImageTransparency = 0.800; Ripple.ScaleType = Enum.ScaleType.Fit
		Ripple.ImageColor3 = Color3.fromRGB(255, 255, 255)
		Ripple.Position = UDim2.new((Mouse.X - Ripple.AbsolutePosition.X) / obj.AbsoluteSize.X, 0, (Mouse.Y - Ripple.AbsolutePosition.Y) / obj.AbsoluteSize.Y, 0)
		TweenService:Create(Ripple, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Position = UDim2.new(-5.5, 0, -5.5, 0), Size = UDim2.new(12, 0, 12, 0)}):Play()
		task.wait(0.15)
		TweenService:Create(Ripple, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {ImageTransparency = 1}):Play()
		task.wait(0.3); Ripple:Destroy()
	end)
end

local function AddGradientStroke(parent, colorBase)
	local colorBase = colorBase or Color3.fromRGB(100, 160, 230)
	local layers = {
		{ color = colorBase, thickness = 1.2, transparency = 0.0 },
		{ color = colorBase:Lerp(Color3.fromRGB(255, 255, 255), 0.3), thickness = 2.0, transparency = 0.2 },
		{ color = colorBase:Lerp(Color3.fromRGB(255, 255, 255), 0.5), thickness = 2.8, transparency = 0.4 },
	}
	local strokes = {}
	for i, layer in ipairs(layers) do
		local stroke = Instance.new("UIStroke")
		stroke.Name = "GradientStrokeLayer" .. i; stroke.Parent = parent
		stroke.Color = layer.color; stroke.Thickness = layer.thickness
		stroke.Transparency = layer.transparency; stroke.LineJoinMode = Enum.LineJoinMode.Round
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		table.insert(strokes, stroke)
	end
	return strokes
end

CreateElement("Corner", function(Scale, Offset) return Create("UICorner", {CornerRadius = UDim.new(Scale or 0, Offset or 8)}) end)
CreateElement("Stroke", function(Color, Thickness) return Create("UIStroke", {Color = Color or Color3.fromRGB(100, 160, 230), Thickness = Thickness or 1.2, LineJoinMode = Enum.LineJoinMode.Round, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}) end)
CreateElement("List", function(Scale, Offset) return Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(Scale or 0, Offset or 0)}) end)
CreateElement("GridList", function(Scale, Offset) return Create("UIGridLayout", {SortOrder = Enum.SortOrder.LayoutOrder, CellPadding = UDim2.new(Scale or 0, Offset or 0, Scale or 0, Offset or 0), CellSize = UDim2.new(0, 100, 0, 30), FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Left, VerticalAlignment = Enum.VerticalAlignment.Top, StartCorner = Enum.StartCorner.TopLeft}) end)
CreateElement("Padding", function(Bottom, Left, Right, Top) return Create("UIPadding", {PaddingBottom = UDim.new(0, Bottom or 4), PaddingLeft = UDim.new(0, Left or 4), PaddingRight = UDim.new(0, Right or 4), PaddingTop = UDim.new(0, Top or 4)}) end)
CreateElement("TFrame", function() return Create("Frame", {BackgroundTransparency = 1}) end)
CreateElement("Frame", function(Color) return Create("Frame", {BackgroundColor3 = Color or Color3.fromRGB(255,255,255), BorderSizePixel = 0}) end)
CreateElement("RoundFrame", function(Color, Scale, Offset) return Create("Frame", {BackgroundColor3 = Color or Color3.fromRGB(255,255,255), BorderSizePixel = 0, BackgroundTransparency = 0.15}, {Create("UICorner", {CornerRadius = UDim.new(Scale, Offset)})}) end)
CreateElement("Button", function() return Create("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, BorderSizePixel = 0}) end)
CreateElement("ScrollFrame", function(Color, Width) return Create("ScrollingFrame", {BackgroundTransparency = 1, MidImage = "rbxassetid://7445543667", BottomImage = "rbxassetid://7445543667", TopImage = "rbxassetid://7445543667", ScrollBarImageColor3 = Color, BorderSizePixel = 0, ScrollBarThickness = Width, CanvasSize = UDim2.new(0,0,0,0)}) end)
CreateElement("Image", function(ImageID) local img = Create("ImageLabel", {Image = ImageID, BackgroundTransparency = 1}); if GetIcon(ImageID) ~= nil then img.Image = GetIcon(ImageID) end; return img end)
CreateElement("ImageButton", function(ImageID) local img = Create("ImageButton", {Image = ImageID, BackgroundTransparency = 1}); if GetIcon(ImageID) ~= nil then img.Image = GetIcon(ImageID) end; return img end)
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
	SetProps(MakeElement("List"), {
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		Padding = UDim.new(0, 5)
	})
}), {
	Position = UDim2.new(1, -25, 1, -25),
	Size = UDim2.new(0, 280, 1, -25),
	AnchorPoint = Vector2.new(1, 1),
	Parent = XvPxOL_UI
})

function XvPxOL:MakeNotification(NotificationConfig)
	spawn(function()
		NotificationConfig.Name = NotificationConfig.Name or "通知"
		NotificationConfig.Content = NotificationConfig.Content or "内容"
		NotificationConfig.Image = NotificationConfig.Image or "rbxassetid://4384403532"
		NotificationConfig.Time = NotificationConfig.Time or 15
		NotificationConfig.Color = NotificationConfig.Color or Color3.fromRGB(100, 160, 230)

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
			MakeElement("Stroke", NotificationConfig.Color, 1),
			MakeElement("Padding", 10, 10, 10, 10),
			SetProps(MakeElement("Image", NotificationConfig.Image), {
				Size = UDim2.new(0, 18, 0, 18),
				ImageColor3 = NotificationConfig.Color,
				Name = "Icon"
			}),
			SetProps(MakeElement("Label", NotificationConfig.Name, 14), {
				Size = UDim2.new(1, -28, 0, 18),
				Position = UDim2.new(0, 28, 0, 0),
				Font = Enum.Font.GothamBold,
				Name = "Title",
				TextColor3 = NotificationConfig.Color
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
	local CurrentTabCount = 0

	WindowConfig = WindowConfig or {}
	WindowConfig.Name = WindowConfig.Name or "XvPxOL Library"
	WindowConfig.ConfigFolder = WindowConfig.ConfigFolder or WindowConfig.Name
	WindowConfig.SaveConfig = WindowConfig.SaveConfig or false
	WindowConfig.HidePremium = WindowConfig.HidePremium or false
	WindowConfig.Theme = WindowConfig.Theme or "Default"
	if WindowConfig.IntroEnabled == nil then WindowConfig.IntroEnabled = true end
	WindowConfig.IntroText = WindowConfig.IntroText or "XvPxOL Library"
	WindowConfig.CloseCallback = WindowConfig.CloseCallback or function() end
	WindowConfig.ShowIcon = WindowConfig.ShowIcon or false
	WindowConfig.Icon = WindowConfig.Icon or "rbxassetid://8834748103"
	WindowConfig.IntroIcon = WindowConfig.IntroIcon or "rbxassetid://8834748103"
	WindowConfig.WindowSize = WindowConfig.WindowSize or UDim2.new(0, 540, 0, 320)
	WindowConfig.WindowPosition = WindowConfig.WindowPosition or UDim2.new(0.5, -270, 0.5, -160)
	XvPxOL.Folder = WindowConfig.ConfigFolder
	XvPxOL.SaveCfg = WindowConfig.SaveConfig

	if WindowConfig.Theme and XvPxOL.Themes[WindowConfig.Theme] then
		XvPxOL.SelectedTheme = WindowConfig.Theme
	end

	if WindowConfig.SaveConfig then
		if not isfolder(WindowConfig.ConfigFolder) then makefolder(WindowConfig.ConfigFolder) end
	end

	local MainCornerRadius = 8
	local SidebarWidth = 135

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

	local MaximizeBtn = SetChildren(SetProps(MakeElement("Button"), {
		Size = UDim2.new(0.33, 0, 1, 0), Position = UDim2.new(0.33, 0, 0, 0), BackgroundTransparency = 1
	}), {
		AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072720870"), {
			Position = UDim2.new(0, 7, 0, 5), Size = UDim2.new(0, 16, 0, 16), Name = "MaxIco"
		}), "Text")
	})

	local MinimizeBtn = SetChildren(SetProps(MakeElement("Button"), {
		Size = UDim2.new(0.33, 0, 1, 0), BackgroundTransparency = 1
	}), {
		AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072719338"), {
			Position = UDim2.new(0, 7, 0, 5), Size = UDim2.new(0, 16, 0, 16), Name = "Ico"
		}), "Text")
	})

	local DragPoint = SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, 40)})

	local ResizeHandle = SetProps(MakeElement("ImageButton"), {
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
		Image = "rbxassetid://7072720870",
		ImageColor3 = Color3.fromRGB(100, 160, 230),
		ImageTransparency = 0.7,
		Position = UDim2.new(1, 0, 1, 0),
		Size = UDim2.new(0, 18, 0, 18),
		ZIndex = 10,
		Parent = DragPoint
	})

	local WindowStuff = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(245, 248, 255), 0, MainCornerRadius - 1), {
		Size = UDim2.new(0, SidebarWidth, 1, -45), Position = UDim2.new(0, 0, 0, 45), BackgroundTransparency = 0.15
	}), {
		AddThemeObject(SetProps(MakeElement("Frame"), {Size = UDim2.new(1, 0, 0, MainCornerRadius), Position = UDim2.new(0, 0, 0, 0)}), "Second"),
		AddThemeObject(SetProps(MakeElement("Frame"), {Size = UDim2.new(0, MainCornerRadius, 1, 0), Position = UDim2.new(1, -MainCornerRadius, 0, 0)}), "Second"),
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

	local MainWindow = SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(245, 248, 255), 0, MainCornerRadius), {
		Parent = XvPxOL_UI,
		Position = WindowConfig.WindowPosition,
		Size = WindowConfig.WindowSize,
		ClipsDescendants = true,
		Active = true,
		Visible = false,
		BackgroundTransparency = 0.12
	}), {
		SetChildren(SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, 40), Name = "TopBar"}), {
			WindowName, WindowTopBarLine,
			AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 6), {
				Size = UDim2.new(0, 80, 0, 26), Position = UDim2.new(1, -95, 0, 7), BackgroundTransparency = 0.25
			}), {
				AddThemeObject(MakeElement("Stroke"), "Stroke"),
				AddThemeObject(SetProps(MakeElement("Frame"), {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(0.33, 0, 0, 0)}), "Stroke"),
				AddThemeObject(SetProps(MakeElement("Frame"), {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(0.66, 0, 0, 0)}), "Stroke"),
				MinimizeBtn, MaximizeBtn, CloseBtn
			}), "Second"),
		}),
		DragPoint, ResizeHandle, WindowStuff
	})

	CreateRainbowBorder(MainWindow, 3, MainCornerRadius)

	if WindowConfig.ShowIcon then
		WindowName.Position = UDim2.new(0, 42, 0, -20)
		SetProps(MakeElement("Image", WindowConfig.Icon), {
			Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 20, 0, 11), Parent = MainWindow.TopBar
		})
	end

	MakeDraggable(DragPoint, MainWindow)
	MakeResizable(MainWindow, ResizeHandle)

	FloatCircle.MouseButton1Click:Connect(function()
		UIHidden = not UIHidden
		MainWindow.Visible = not UIHidden
	end)

	CloseBtn.MouseButton1Up:Connect(function()
		MainWindow.Visible = false
		UIHidden = true
		XvPxOL:MakeNotification({Name = "窗口已关闭", Content = "点击悬浮球重新打开", Time = 2})
		WindowConfig.CloseCallback()
	end)

	MinimizeBtn.MouseButton1Up:Connect(function()
		MainWindow.Visible = false
		UIHidden = true
		XvPxOL:MakeNotification({Name = "窗口已隐藏", Content = "点击悬浮球重新打开", Time = 2})
	end)

	MaximizeBtn.MouseButton1Up:Connect(function()
		if Minimized then
			TweenService:Create(MainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = WindowConfig.WindowSize}):Play()
			task.wait(.02)
			MainWindow.ClipsDescendants = false
			WindowStuff.Visible = true
			WindowTopBarLine.Visible = true
		else
			MainWindow.ClipsDescendants = true
			WindowTopBarLine.Visible = false
			TweenService:Create(MainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, WindowName.TextBounds.X + 150, 0, 40)}):Play()
			task.wait(0.1)
			WindowStuff.Visible = false
		end
		Minimized = not Minimized
	end)

	AddConnection(UserInputService.InputBegan, function(Input)
		if Input.KeyCode == Enum.KeyCode.RightShift and UIHidden then
			UIHidden = false
			MainWindow.Visible = true
		end
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

		CurrentTabCount = CurrentTabCount + 1

		local TabFrame = SetChildren(SetProps(MakeElement("Button"), {
			Size = UDim2.new(1, 0, 0, 28), Parent = TabHolder
		}), {
			AddThemeObject(SetProps(MakeElement("Image", TabConfig.Icon), {
				AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.new(0, 18, 0, 18),
				Position = UDim2.new(0, 10, 0.5, 0), ImageTransparency = 0.3, Name = "Ico"
			}), "Text"),
			AddThemeObject(SetProps(MakeElement("Label", TabConfig.Name, 13), {
				Size = UDim2.new(1, -35, 1, 0), Position = UDim2.new(0, 35, 0, 0),
				Font = Enum.Font.GothamSemibold, TextTransparency = 0.3, Name = "Title"
			}), "Text")
		})

		if GetIcon(TabConfig.Icon) ~= nil then TabFrame.Ico.Image = GetIcon(TabConfig.Icon) end

		local Container = AddThemeObject(SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(100, 160, 230), 4), {
			Size = UDim2.new(1, -SidebarWidth, 1, -45), Position = UDim2.new(0, SidebarWidth, 0, 45),
			Parent = MainWindow, Visible = false, Name = "ItemContainer"
		}), {
			MakeElement("List", 0, 6), MakeElement("Padding", 12, 10, 10, 12)
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

			function ElementFunction:AddLabel(Text, Options)
				Options = Options or {}
				local LabelFrame = SetChildren(SetProps(MakeElement("TFrame"), {
					Size = UDim2.new(1, 0, 0, Options.Height or 24), Parent = ItemParent
				}), {
					AddThemeObject(SetProps(MakeElement("Label", Text, Options.TextSize or 14), {
						Size = UDim2.new(1, -8, 1, 0), Position = UDim2.new(0, 8, 0, 0),
						Font = Options.Bold and Enum.Font.GothamBlack or Enum.Font.GothamBold, Name = "Content"
					}), "Text")
				})
				local LabelFunctions = {
					Set = function(ToChange) LabelFrame.Content.Text = ToChange end,
					SetVisible = function(Visible) LabelFrame.Visible = Visible end,
					SetColor = function(Color) LabelFrame.Content.TextColor3 = Color end,
					Frame = LabelFrame
				}
				return LabelFunctions
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
				local ParagraphFunctions = {
					Set = function(ToChange) ParagraphFrame.Content.Text = ToChange end,
					SetTitle = function(Title) ParagraphFrame.Title.Text = Title end,
					SetVisible = function(Visible) ParagraphFrame.Visible = Visible end,
					Frame = ParagraphFrame
				}
				return ParagraphFunctions
			end

			function ElementFunction:AddButton(ButtonConfig)
				ButtonConfig = ButtonConfig or {}
				ButtonConfig.Name = ButtonConfig.Name or "Button"
				ButtonConfig.Callback = ButtonConfig.Callback or function() end
				ButtonConfig.Icon = ButtonConfig.Icon or nil
				ButtonConfig.DoubleClick = ButtonConfig.DoubleClick or false
				ButtonConfig.Risky = ButtonConfig.Risky or false
				ButtonConfig.Disabled = ButtonConfig.Disabled or false

				local Button = {
					Text = ButtonConfig.Name,
					Disabled = ButtonConfig.Disabled,
					Visible = true,
					Type = "Button"
				}
				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})
				local ButtonFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 32), Parent = ItemParent, BackgroundTransparency = 0.3
				}), {
					AddThemeObject(SetProps(MakeElement("Label", ButtonConfig.Name, 13), {
						Size = UDim2.new(1, -12, 1, 0), Position = UDim2.new(0, 12, 0, 0), Font = Enum.Font.GothamBold, Name = "Content"
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"), Click
				}), "Second")

				if ButtonConfig.Icon then
					local IconImage = MakeElement("Image", ButtonConfig.Icon)
					IconImage.Size = UDim2.new(0, 18, 0, 18)
					IconImage.Position = UDim2.new(0, 8, 0, 7)
					IconImage.Parent = ButtonFrame
					ButtonFrame.Content.Position = UDim2.new(0, 30, 0, 0)
					ButtonFrame.Content.Size = UDim2.new(1, -38, 1, 0)
				end

				if ButtonConfig.Risky then
					ButtonFrame.Content.TextColor3 = Color3.fromRGB(255, 80, 80)
				end

				AddConnection(Click.MouseEnter, function()
					if Button.Disabled then return end
					TweenService:Create(ButtonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						BackgroundColor3 = Color3.fromRGB(100, 160, 230),
						BackgroundTransparency = 0.5
					}):Play()
				end)

				AddConnection(Click.MouseLeave, function()
					if Button.Disabled then return end
					TweenService:Create(ButtonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						BackgroundColor3 = XvPxOL.Themes[XvPxOL.SelectedTheme].Second,
						BackgroundTransparency = 0.3
					}):Play()
				end)

				AddConnection(Click.MouseButton1Up, function()
					if Button.Disabled then return end
					spawn(function()
						RippleEffect(ButtonFrame)
						ButtonConfig.Callback()
					end)
				end)

				function Button:Set(ButtonText)
					ButtonConfig.Name = ButtonText
					ButtonFrame.Content.Text = ButtonText
				end

				function Button:SetDisabled(Disabled)
					Button.Disabled = Disabled
					Click.Active = not Disabled
				end

				function Button:SetVisible(Visible)
					Button.Visible = Visible
					ButtonFrame.Visible = Visible
				end

				function Button:SetCallback(Callback)
					ButtonConfig.Callback = Callback
				end

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
				ToggleConfig.Disabled = ToggleConfig.Disabled or false

				local Toggle = {
					Value = ToggleConfig.Default,
					Save = ToggleConfig.Save,
					Disabled = ToggleConfig.Disabled,
					Type = "Toggle"
				}
				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})

				local ToggleBg = Create("Frame", {
					BackgroundColor3 = Toggle.Value and ToggleConfig.Color or Color3.fromRGB(180, 190, 210),
					BorderSizePixel = 0,
					Size = UDim2.new(0, 36, 0, 22),
					Position = UDim2.new(1, -40, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = Toggle.Value and 0.25 or 0.45
				}, {MakeElement("Corner", 0, 7)})

				local ToggleSwitch = Create("Frame", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Size = UDim2.new(0, 16, 0, 16),
					Position = Toggle.Value and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5)
				}, {MakeElement("Corner", 0, 6)})
				ToggleSwitch.Parent = ToggleBg

				MakeElement("Stroke", ToggleConfig.Color, 1.2).Parent = ToggleBg

				local ToggleFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 34), Parent = ItemParent, BackgroundTransparency = 0.3
				}), {
					AddThemeObject(SetProps(MakeElement("Label", ToggleConfig.Name, 13), {
						Size = UDim2.new(1, -52, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.GothamBold, Name = "Content"
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"), ToggleBg, Click
				}), "Second")

				function Toggle:Set(Value)
					if Toggle.Disabled then return end
					Toggle.Value = Value
					TweenService:Create(ToggleBg, TweenInfo.new(0.2), {
						BackgroundColor3 = Value and ToggleConfig.Color or Color3.fromRGB(180, 190, 210),
						BackgroundTransparency = Value and 0.25 or 0.45
					}):Play()
					TweenService:Create(ToggleSwitch, TweenInfo.new(0.2), {
						Position = Value and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
					}):Play()
					ToggleConfig.Callback(Value)
				end

				function Toggle:OnChanged(Func)
					ToggleConfig.Callback = Func
				end

				function Toggle:SetDisabled(Disabled)
					Toggle.Disabled = Disabled
					Click.Active = not Disabled
				end

				function Toggle:SetVisible(Visible)
					ToggleFrame.Visible = Visible
				end

				Toggle:Set(Toggle.Value)

				AddConnection(Click.MouseButton1Up, function()
					if Toggle.Disabled then return end
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
				SliderConfig.Disabled = SliderConfig.Disabled or false

				local Slider = {
					Value = SliderConfig.Default,
					Save = SliderConfig.Save,
					Disabled = SliderConfig.Disabled,
					Type = "Slider"
				}
				local SliderDragging = false

				local SliderHolder = SetProps(MakeElement("TFrame"), {
					Size = UDim2.new(1, 0, 0, 42), Parent = ItemParent
				})

				local NameLabel = AddThemeObject(SetProps(MakeElement("Label", SliderConfig.Name, 13), {
					Size = UDim2.new(1, -8, 0, 14), Position = UDim2.new(0, 4, 0, 2), Font = Enum.Font.GothamBold
				}), "Text")
				NameLabel.Parent = SliderHolder

				local ValueLabel = AddThemeObject(SetProps(MakeElement("Label", tostring(SliderConfig.Default) .. SliderConfig.ValueName, 12), {
					Size = UDim2.new(1, -8, 0, 14), Position = UDim2.new(0, 4, 0, 18),
					Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Right
				}), "TextDark")
				ValueLabel.Parent = SliderHolder

				local SliderBar = Create("Frame", {
					BackgroundColor3 = Color3.fromRGB(210, 220, 235),
					BorderSizePixel = 0,
					Size = UDim2.new(1, -8, 0, 10),
					Position = UDim2.new(0, 4, 0, 32),
					Parent = SliderHolder
				}, {MakeElement("Corner", 0, 4)})

				local SliderFill = Create("Frame", {
					BackgroundColor3 = SliderConfig.Color,
					BorderSizePixel = 0,
					Size = UDim2.fromScale((SliderConfig.Default - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 1),
					Parent = SliderBar
				}, {MakeElement("Corner", 0, 4)})

				local function updateFromMouse()
					if not SliderBar or not SliderBar.Parent then return end
					local barPos = SliderBar.AbsolutePosition.X
					local barSize = SliderBar.AbsoluteSize.X
					local mouseX = Mouse.X
					local SizeScale = math.clamp((mouseX - barPos) / barSize, 0, 1)
					local value = SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale)
					if SliderConfig.Increment > 1 then value = Round(value, SliderConfig.Increment) else value = math.floor(value) end
					Slider:Set(value)
				end

				AddConnection(SliderBar.InputBegan, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Slider.Disabled then
						SliderDragging = true
						updateFromMouse()
					end
				end)

				AddConnection(UserInputService.InputEnded, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 and SliderDragging then
						SliderDragging = false
						SaveCfg(game.GameId)
					end
				end)

				AddConnection(UserInputService.InputChanged, function(Input)
					if SliderDragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
						updateFromMouse()
					end
				end)

				function Slider:Set(Value)
					if Slider.Disabled then return end
					self.Value = math.clamp(Value, SliderConfig.Min, SliderConfig.Max)
					local scale = (self.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
					TweenService:Create(SliderFill, TweenInfo.new(.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.fromScale(scale, 1)
					}):Play()
					ValueLabel.Text = tostring(self.Value) .. SliderConfig.ValueName
					SliderConfig.Callback(self.Value)
				end

				function Slider:OnChanged(Func)
					SliderConfig.Callback = Func
				end

				function Slider:SetDisabled(Disabled)
					Slider.Disabled = Disabled
				end

				function Slider:SetVisible(Visible)
					SliderHolder.Visible = Visible
				end

				function Slider:SetMax(Max)
					SliderConfig.Max = Max
					Slider:Set(math.clamp(Slider.Value, SliderConfig.Min, Max))
				end

				function Slider:SetMin(Min)
					SliderConfig.Min = Min
					Slider:Set(math.clamp(Slider.Value, Min, SliderConfig.Max))
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
				DropdownConfig.Multi = DropdownConfig.Multi or false
				DropdownConfig.Disabled = DropdownConfig.Disabled or false

				local Dropdown = {
					Value = DropdownConfig.Default,
					Options = DropdownConfig.Options,
					Buttons = {},
					Toggled = false,
					Type = "Dropdown",
					Save = DropdownConfig.Save,
					Multi = DropdownConfig.Multi,
					Disabled = DropdownConfig.Disabled
				}
				local MaxElements = 5

				if not Dropdown.Multi and not table.find(Dropdown.Options, Dropdown.Value) then
					Dropdown.Value = "..."
				end

				if Dropdown.Multi and type(Dropdown.Value) ~= "table" then
					Dropdown.Value = {}
				end

				local DropdownList = MakeElement("List")
				local DropdownContainer = AddThemeObject(SetProps(SetChildren(MakeElement("ScrollFrame", Color3.fromRGB(100, 160, 230), 3), {DropdownList}), {
					Parent = ItemParent, Position = UDim2.new(0, 0, 0, 34), Size = UDim2.new(1, 0, 1, -34), ClipsDescendants = true
				}), "Divider")

				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})

				local DropdownFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 34), Parent = ItemParent, ClipsDescendants = true, BackgroundTransparency = 0.3
				}), {
					DropdownContainer,
					SetProps(SetChildren(MakeElement("TFrame"), {
						AddThemeObject(SetProps(MakeElement("Label", DropdownConfig.Name, 13), {
							Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.GothamBold, Name = "Content"
						}), "Text"),
						AddThemeObject(SetProps(MakeElement("Label", "...", 12), {
							Size = UDim2.new(1, -40, 1, 0), Font = Enum.Font.Gotham, Name = "Selected", TextXAlignment = Enum.TextXAlignment.Right
						}), "TextDark"),
						SetProps(MakeElement("Image", "rbxassetid://7072706796"), {
							Size = UDim2.new(0, 14, 0, 14),
							Position = UDim2.new(1, -28, 0.5, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							ImageColor3 = Color3.fromRGB(60, 130, 210),
							Name = "Arrow",
							Parent = DropdownFrame
						}),
						AddThemeObject(SetProps(MakeElement("Frame"), {
							Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), Name = "Line", Visible = false
						}), "Stroke"),
						Click
					}), {Size = UDim2.new(1, 0, 0, 34), ClipsDescendants = true, Name = "F"}),
					AddThemeObject(MakeElement("Stroke"), "Stroke"), MakeElement("Corner")
				}), "Second")

				AddConnection(DropdownList:GetPropertyChangedSignal("AbsoluteContentSize"), function()
					DropdownContainer.CanvasSize = UDim2.new(0, 0, 0, DropdownList.AbsoluteContentSize.Y)
				end)

				local function AddOptions(Options)
					for _, Option in pairs(Options) do
						local IsSelected = false
						if Dropdown.Multi then
							IsSelected = Dropdown.Value[Option] == true
						else
							IsSelected = Dropdown.Value == Option
						end

						local OptionBtn = AddThemeObject(SetProps(SetChildren(MakeElement("Button"), {
							MakeElement("Corner", 0, 5),
							AddThemeObject(SetProps(MakeElement("Label", Option, 12, IsSelected and 0 or 0.35), {
								Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(1, -8, 1, 0), Name = "Title"
							}), "Text")
						}), {
							Parent = DropdownContainer, Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = IsSelected and 0.15 or 1, ClipsDescendants = true
						}), "Divider")

						AddConnection(OptionBtn.MouseButton1Click, function()
							if Dropdown.Disabled then return end
							if Dropdown.Multi then
								if Dropdown.Value[Option] then
									Dropdown.Value[Option] = nil
								else
									Dropdown.Value[Option] = true
								end
							else
								Dropdown.Value = Option
								DropdownFrame.F.Selected.Text = Option
								Dropdown.Toggled = false
								DropdownFrame.Size = UDim2.new(1, 0, 0, 34)
								DropdownFrame.F.Line.Visible = false
								DropdownFrame.Arrow.Rotation = 0
							end
							SaveCfg(game.GameId)
							DropdownConfig.Callback(Dropdown.Value)
							Dropdown:Refresh(Dropdown.Options, true)
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
					DropdownContainer.CanvasSize = UDim2.new(0, 0, 0, DropdownList.AbsoluteContentSize.Y)
				end

				function Dropdown:Set(Value)
					if Dropdown.Multi then return end
					if not table.find(Dropdown.Options, Value) then
						Dropdown.Value = "..."
						DropdownFrame.F.Selected.Text = Dropdown.Value
						return
					end
					Dropdown.Value = Value
					DropdownFrame.F.Selected.Text = Value
					DropdownConfig.Callback(Value)
				end

				function Dropdown:SetDisabled(Disabled)
					Dropdown.Disabled = Disabled
				end

				function Dropdown:SetVisible(Visible)
					DropdownFrame.Visible = Visible
				end

				AddConnection(Click.MouseButton1Click, function()
					if Dropdown.Disabled then return end
					Dropdown.Toggled = not Dropdown.Toggled
					DropdownFrame.F.Line.Visible = Dropdown.Toggled
					DropdownFrame.Arrow.Rotation = Dropdown.Toggled and 180 or 0
					if #Dropdown.Options > MaxElements then
						TweenService:Create(DropdownFrame, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Size = Dropdown.Toggled and UDim2.new(1, 0, 0, 34 + (MaxElements * 26)) or UDim2.new(1, 0, 0, 34)
						}):Play()
					else
						TweenService:Create(DropdownFrame, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Size = Dropdown.Toggled and UDim2.new(1, 0, 0, DropdownList.AbsoluteContentSize.Y + 34) or UDim2.new(1, 0, 0, 34)
						}):Play()
					end
				end)

				Dropdown:Refresh(Dropdown.Options, false)
				if not Dropdown.Multi then Dropdown:Set(Dropdown.Value) end
				if DropdownConfig.Flag then XvPxOL.Flags[DropdownConfig.Flag] = Dropdown end
				return Dropdown
			end

			function ElementFunction:AddTextbox(TextboxConfig)
				TextboxConfig = TextboxConfig or {}
				TextboxConfig.Name = TextboxConfig.Name or "Textbox"
				TextboxConfig.Default = TextboxConfig.Default or ""
				TextboxConfig.TextDisappear = TextboxConfig.TextDisappear or false
				TextboxConfig.Callback = TextboxConfig.Callback or function() end
				TextboxConfig.Placeholder = TextboxConfig.Placeholder or "输入..."
				TextboxConfig.Numeric = TextboxConfig.Numeric or false
				TextboxConfig.Disabled = TextboxConfig.Disabled or false

				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})
				local TextboxActual = AddThemeObject(Create("TextBox", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
					TextColor3 = Color3.fromRGB(60, 130, 210),
					PlaceholderColor3 = Color3.fromRGB(120, 170, 230),
					PlaceholderText = TextboxConfig.Placeholder,
					Font = Enum.Font.GothamSemibold,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextSize = 13,
					ClearTextOnFocus = false,
					TextEditable = not TextboxConfig.Disabled
				}), "Text")

				local TextContainer = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 4), {
					Size = UDim2.new(0, 20, 0, 22), Position = UDim2.new(1, -12, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 0.35
				}), {
					AddThemeObject(MakeElement("Stroke"), "Stroke"), TextboxActual
				}), "Main")

				New("UIPadding", {
					PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6),
					Parent = TextContainer
				})

				local TextboxFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 36), Parent = ItemParent, BackgroundTransparency = 0.3
				}), {
					AddThemeObject(SetProps(MakeElement("Label", TextboxConfig.Name, 13), {
						Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.GothamBold, Name = "Content"
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"), TextContainer, Click
				}), "Second")

				AddConnection(TextboxActual:GetPropertyChangedSignal("Text"), function()
					TweenService:Create(TextContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						Size = UDim2.new(0, math.max(TextboxActual.TextBounds.X + 20, 40), 0, 22)
					}):Play()
				end)

				AddConnection(TextboxActual.FocusLost, function()
					TextboxConfig.Callback(TextboxActual.Text)
					if TextboxConfig.TextDisappear then TextboxActual.Text = "" end
				end)

				TextboxActual.Text = TextboxConfig.Default

				AddConnection(Click.MouseButton1Up, function()
					if not TextboxConfig.Disabled then TextboxActual:CaptureFocus() end
				end)
			end

			function ElementFunction:AddViewport(ViewportConfig)
				ViewportConfig = ViewportConfig or {}
				local ViewportObj = ViewportConfig.Object
				local ViewportCamera = ViewportConfig.Camera or Instance.new("Camera")
				local Interactive = ViewportConfig.Interactive or false
				local Height = ViewportConfig.Height or 200
				local AutoFocus = ViewportConfig.AutoFocus ~= false

				local Holder = Create("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, Height),
					Parent = ItemParent
				})

				local Box = Create("Frame", {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundColor3 = Color3.fromRGB(225, 235, 255),
					BorderColor3 = Color3.fromRGB(100, 160, 230),
					BorderSizePixel = 1,
					Position = UDim2.fromScale(0, 1),
					Size = UDim2.fromScale(1, 1),
					Parent = Holder
				})

				local ViewportFrame = Create("ViewportFrame", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					CurrentCamera = ViewportCamera,
					Active = Interactive,
					Parent = Box
				})

				if ViewportObj then
					ViewportObj.Parent = ViewportFrame
					if AutoFocus then
						local cf = ViewportObj:GetPivot()
						ViewportCamera.CFrame = cf * CFrame.new(0, 0, 10)
					end
				end

				return {
					Holder = Holder,
					ViewportFrame = ViewportFrame,
					SetObject = function(obj) ViewportObj = obj; obj.Parent = ViewportFrame end,
					SetCamera = function(cam) ViewportCamera = cam; ViewportFrame.CurrentCamera = cam end,
					SetHeight = function(h) Holder.Size = UDim2.new(1, 0, 0, h) end
				}
			end

			return ElementFunction
		end

		local ElementFunction = {}

		function ElementFunction:AddSection(SectionConfig)
			SectionConfig = SectionConfig or {}
			SectionConfig.Name = SectionConfig.Name or "Section"
			SectionConfig.Collapsible = SectionConfig.Collapsible or false
			SectionConfig.DefaultOpen = SectionConfig.DefaultOpen or true

			local SectionFrame = SetChildren(SetProps(MakeElement("TFrame"), {
				Size = UDim2.new(1, 0, 0, 24), Parent = Container
			}), {
				AddThemeObject(SetProps(MakeElement("Label", SectionConfig.Name, 12), {
					Size = UDim2.new(1, -8, 0, 16), Position = UDim2.new(0, 4, 0, 2), Font = Enum.Font.GothamSemibold
				}), "TextDark"),
				SetChildren(SetProps(MakeElement("TFrame"), {
					AnchorPoint = Vector2.new(0, 0), Size = UDim2.new(1, 0, 1, -22),
					Position = UDim2.new(0, 0, 0, 22), Name = "Holder"
				}), {MakeElement("List", 0, 5)}),
			})

			AddConnection(SectionFrame.Holder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
				SectionFrame.Size = UDim2.new(1, 0, 0, SectionFrame.Holder.UIListLayout.AbsoluteContentSize.Y + 28)
				SectionFrame.Holder.Size = UDim2.new(1, 0, 0, SectionFrame.Holder.UIListLayout.AbsoluteContentSize.Y)
			end)

			local SectionFunction = {}
			for i, v in next, GetElements(SectionFrame.Holder) do SectionFunction[i] = v end

			SectionFunction.SectionFrame = SectionFrame

			return SectionFunction
		end

		for i, v in next, GetElements(Container) do ElementFunction[i] = v end

		if TabConfig.PremiumOnly then
			for i, v in next, ElementFunction do ElementFunction[i] = function() end end
			local LockFrame = SetChildren(SetProps(MakeElement("TFrame"), {
				Size = UDim2.new(1, 0, 1, 0), Parent = Container
			}), {
				AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://3926305904"), {
					Size = UDim2.new(0, 64, 0, 64), Position = UDim2.new(0.5, -32, 0.4, -32)
				}), "Text"),
				AddThemeObject(SetProps(MakeElement("Label", "高级功能", 16), {
					Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0.55, 0),
					TextXAlignment = Enum.TextXAlignment.Center, Font = Enum.Font.GothamBold
				}), "Text"),
				AddThemeObject(SetProps(MakeElement("Label", "此功能需要高级版", 12), {
					Size = UDim2.new(1, 0, 0, 16), Position = UDim2.new(0, 0, 0.65, 0),
					TextXAlignment = Enum.TextXAlignment.Center, TextTransparency = 0.4
				}), "TextDark")
			})
		end

		return ElementFunction
	end

	table.insert(XvPxOL.Tabs, TabFunction)
	return TabFunction
end

function XvPxOL:Destroy()
	XvPxOL:StopRainbowEffect()
	XvPxOL.Unloaded = true
	for _, c in ipairs(XvPxOL.Signals) do pcall(function() c:Disconnect() end) end
	XvPxOL.Signals = {}
	for _, Callback in ipairs(XvPxOL.UnloadSignals) do XvPxOL:SafeCallback(Callback) end
	XvPxOL_UI:Destroy()
end

function XvPxOL:OnUnload(Callback)
	table.insert(XvPxOL.UnloadSignals, Callback)
end

return XvPxOL
