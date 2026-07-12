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
		if Interface.Name == XvPxOL_UI.Name and Interface ~= XvPxOL_UI then Interface:Destroy() end
	end
else
	for _, Interface in ipairs(game.CoreGui:GetChildren()) do
		if Interface.Name == XvPxOL_UI.Name and Interface ~= XvPxOL_UI then Interface:Destroy() end
	end
end

function XvPxOL:IsRunning()
	if gethui then return XvPxOL_UI.Parent == gethui() else return XvPxOL_UI.Parent == game:GetService("CoreGui") end
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
			dragging = true; dragStart = input.Position; startPos = mainFrame.Position
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
			mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
	for i, v in pairs(XvPxOL.Flags) do if v.Save then Data[i] = v.Value end end
	if XvPxOL.Folder then writefile(XvPxOL.Folder .. "/" .. Name .. ".txt", HttpService:JSONEncode(Data)) end
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
FloatRainbow.Name = "FloatRainbow"
FloatRainbow.Active = false
FloatRainbow.Parent = FloatContainer

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
		NotificationConfig.Time = NotificationConfig.Time or 15

		local nParent = SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = NotificationHolder})
		local nFrame = SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(245, 248, 255), 0, 8), {
			Parent = nParent, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(1, -55, 0, 0), BackgroundTransparency = 0.2, AutomaticSize = Enum.AutomaticSize.Y
		}), {
			MakeElement("Stroke", Color3.fromRGB(100, 160, 230), 1), MakeElement("Padding", 10, 10, 10, 10),
			SetProps(MakeElement("Label", NotificationConfig.Name, 14), {Size = UDim2.new(1, 0, 0, 18), Font = Enum.Font.GothamBold, Name = "Title"}),
			SetProps(MakeElement("Label", NotificationConfig.Content, 13), {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 22), Font = Enum.Font.GothamSemibold, Name = "Content", AutomaticSize = Enum.AutomaticSize.Y, TextColor3 = Color3.fromRGB(120, 170, 230), TextWrapped = true})
		})

		TweenService:Create(nFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 0, 0, 0)}):Play()
		task.wait(NotificationConfig.Time - 0.88)
		TweenService:Create(nFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.8}):Play()
		task.wait(0.3)
		TweenService:Create(nFrame.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Transparency = 0.9}):Play()
		task.wait(0.05)
		nFrame:TweenPosition(UDim2.new(1, 20, 0, 0), 'In', 'Quint', 0.8, true)
		task.wait(1.35)
		nFrame:Destroy()
	end)
end

function XvPxOL:MakeWindow(WindowConfig)
	local FirstTab = true
	local UIHidden = true

	WindowConfig = WindowConfig or {}
	WindowConfig.Name = WindowConfig.Name or "XvPxOL"
	WindowConfig.ConfigFolder = WindowConfig.ConfigFolder or WindowConfig.Name
	WindowConfig.SaveConfig = WindowConfig.SaveConfig or false
	WindowConfig.IntroEnabled = WindowConfig.IntroEnabled ~= false
	WindowConfig.IntroText = WindowConfig.IntroText or "XvPxOL"
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
		Parent = XvPxOL_UI, Position = UDim2.new(0.5, -270, 0.5, -150), Size = UDim2.new(0, 540, 0, 300),
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
		MainWindow.Visible = false
		UIHidden = true
	end)

	if WindowConfig.IntroEnabled then
		MainWindow.Visible = false
		local logo = SetProps(MakeElement("Image", "rbxassetid://8834748103"), {
			Parent = XvPxOL_UI, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 24, 0, 24), ImageColor3 = Color3.fromRGB(100, 160, 230), ImageTransparency = 1
		})
		local text = SetProps(MakeElement("Label", WindowConfig.IntroText, 13), {
			Parent = XvPxOL_UI, Size = UDim2.new(1, 0, 1, 0), AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 16, 0.5, 0), TextXAlignment = Enum.TextXAlignment.Center,
			Font = Enum.Font.GothamBold, TextTransparency = 1
		})
		TweenService:Create(logo, TweenInfo.new(.3, Enum.EasingStyle.Quad), {ImageTransparency = 0}):Play()
		task.wait(0.8)
		TweenService:Create(logo, TweenInfo.new(.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, -(text.TextBounds.X / 2), 0.5, 0)}):Play()
		task.wait(0.3)
		TweenService:Create(text, TweenInfo.new(.3, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
		task.wait(2)
		TweenService:Create(text, TweenInfo.new(.3, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
		logo:Destroy(); text:Destroy()
	end

	local TabFunction = {}
	function TabFunction:MakeTab(TabConfig)
		TabConfig = TabConfig or {}
		TabConfig.Name = TabConfig.Name or "Tab"

		local TabFrame = SetChildren(SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 0, 28), Parent = TabHolder}), {
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
			TabFrame.Title.TextTransparency = 0; TabFrame.Title.Font = Enum.Font.GothamBlack
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
			TabFrame.Title.Font = Enum.Font.GothamBlack; Container.Visible = true
		end)

		local function GetElements(ItemParent)
			local EF = {}

			function EF:AddLabel(Text)
				local f = SetChildren(SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, 24), Parent = ItemParent}), {
					AddThemeObject(SetProps(MakeElement("Label", Text, 14), {Size = UDim2.new(1, -8, 1, 0), Position = UDim2.new(0, 8, 0, 0), Font = Enum.Font.GothamBold, Name = "Content"}), "Text")
				})
				return {Set = function(v) f.Content.Text = v end}
			end

			function EF:AddParagraph(Text, Content)
				Text = Text or "Text"; Content = Content or "Content"
				local f = SetChildren(SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, 30), Parent = ItemParent}), {
					AddThemeObject(SetProps(MakeElement("Label", Text, 13), {Size = UDim2.new(1, -8, 0, 13), Position = UDim2.new(0, 8, 0, 6), Font = Enum.Font.GothamBold, Name = "Title"}), "Text"),
					AddThemeObject(SetProps(MakeElement("Label", "", 12), {Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 22), Font = Enum.Font.GothamSemibold, Name = "Content", TextWrapped = true}), "TextDark")
				})
				AddConnection(f.Content:GetPropertyChangedSignal("Text"), function()
					f.Content.Size = UDim2.new(1, -16, 0, f.Content.TextBounds.Y); f.Size = UDim2.new(1, 0, 0, f.Content.TextBounds.Y + 30)
				end)
				f.Content.Text = Content
				return {Set = function(v) f.Content.Text = v end}
			end

			function EF:AddButton(ButtonConfig)
				ButtonConfig = ButtonConfig or {}
				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})
				local bf = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 30), Parent = ItemParent, BackgroundTransparency = 0.3
				}), {
					AddThemeObject(SetProps(MakeElement("Label", ButtonConfig.Name or "Button", 13), {
						Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.GothamBold, Name = "Content"
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"), Click
				}), "Second")
				AddConnection(Click.MouseButton1Up, function() spawn(function() (ButtonConfig.Callback or function() end)() end) end)
				return {Set = function(v) bf.Content.Text = v end}
			end

			function EF:AddToggle(ToggleConfig)
				ToggleConfig = ToggleConfig or {}
				local Toggle = {Value = ToggleConfig.Default or false, Save = ToggleConfig.Save or false}
				local color = ToggleConfig.Color or Color3.fromRGB(100, 160, 230)
				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})

				local bg = Create("Frame", {
					BackgroundColor3 = Toggle.Value and color or Color3.fromRGB(180, 190, 210),
					BorderSizePixel = 0, Size = UDim2.new(0, 36, 0, 22),
					Position = UDim2.new(1, -40, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = Toggle.Value and 0.25 or 0.45
				}, {MakeElement("Corner", 0, 7)})

				local ball = Create("Frame", {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Size = UDim2.new(0, 16, 0, 16),
					Position = Toggle.Value and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5)
				}, {MakeElement("Corner", 0, 6)})
				ball.Parent = bg
				MakeElement("Stroke", color, 1.2).Parent = bg

				local holder = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 34), Parent = ItemParent, BackgroundTransparency = 0.3
				}), {
					AddThemeObject(SetProps(MakeElement("Label", ToggleConfig.Name or "Toggle", 13), {
						Size = UDim2.new(1, -52, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.GothamBold
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"), bg, Click
				}), "Second")

				function Toggle:Set(Value)
					Toggle.Value = Value
					TweenService:Create(bg, TweenInfo.new(0.2), {
						BackgroundColor3 = Value and color or Color3.fromRGB(180, 190, 210),
						BackgroundTransparency = Value and 0.25 or 0.45
					}):Play()
					TweenService:Create(ball, TweenInfo.new(0.2), {
						Position = Value and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
					}):Play()
					(ToggleConfig.Callback or function() end)(Value)
				end

				Toggle:Set(Toggle.Value)
				AddConnection(Click.MouseButton1Up, function() SaveCfg(game.GameId); Toggle:Set(not Toggle.Value) end)
				if ToggleConfig.Flag then XvPxOL.Flags[ToggleConfig.Flag] = Toggle end
				return Toggle
			end

			function EF:AddSlider(SliderConfig)
				SliderConfig = SliderConfig or {}
				local min = SliderConfig.Min or 0; local max = SliderConfig.Max or 100
				local def = SliderConfig.Default or 50; local inc = SliderConfig.Increment or 1
				local color = SliderConfig.Color or Color3.fromRGB(100, 160, 230)
				local sld = {Value = def, Save = SliderConfig.Save or false}
				local dragging = false

				local holder = SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, 42), Parent = ItemParent})

				if SliderConfig.Name then
					AddThemeObject(SetProps(MakeElement("Label", SliderConfig.Name, 13), {
						Size = UDim2.new(1, -8, 0, 14), Position = UDim2.new(0, 4, 0, 2), Font = Enum.Font.GothamBold
					}), "Text").Parent = holder
				end

				local valLabel = AddThemeObject(SetProps(MakeElement("Label", tostring(def) .. (SliderConfig.ValueName or ""), 12), {
					Size = UDim2.new(1, -8, 0, 14), Position = UDim2.new(0, 4, 0, 18), Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Right
				}), "TextDark")
				valLabel.Parent = holder

				local bar = Create("Frame", {
					BackgroundColor3 = Color3.fromRGB(210, 220, 235), BorderSizePixel = 0,
					Size = UDim2.new(1, -8, 0, 10), Position = UDim2.new(0, 4, 0, 32), Parent = holder
				}, {MakeElement("Corner", 0, 4)})

				local fill = Create("Frame", {
					BackgroundColor3 = color, BorderSizePixel = 0,
					Size = UDim2.fromScale((def - min) / (max - min), 1), Parent = bar
				}, {MakeElement("Corner", 0, 4)})

				local function updateFromMouse()
					if not bar or not bar.Parent then return end
					local scale = math.clamp((Mouse.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
					local value = min + (max - min) * scale
					if inc > 1 then value = Round(value, inc) else value = math.floor(value) end
					sld:Set(value)
				end

				AddConnection(bar.InputBegan, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; updateFromMouse() end
				end)
				AddConnection(UserInputService.InputEnded, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then dragging = false; SaveCfg(game.GameId) end
				end)
				AddConnection(UserInputService.InputChanged, function(Input)
					if dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then updateFromMouse() end
				end)

				function sld:Set(Value)
					self.Value = math.clamp(Value, min, max)
					local scale = (self.Value - min) / (max - min)
					TweenService:Create(fill, TweenInfo.new(.1), {Size = UDim2.fromScale(scale, 1)}):Play()
					valLabel.Text = tostring(self.Value) .. (SliderConfig.ValueName or "")
					(SliderConfig.Callback or function() end)(self.Value)
				end

				sld:Set(sld.Value)
				if SliderConfig.Flag then XvPxOL.Flags[SliderConfig.Flag] = sld end
				return sld
			end

			function EF:AddDropdown(DropdownConfig)
				DropdownConfig = DropdownConfig or {}
				local opts = DropdownConfig.Options or {}
				local dd = {Value = DropdownConfig.Default or "", Options = opts, Buttons = {}, Toggled = false, Save = DropdownConfig.Save or false}
				local MaxElements = 4
				if not table.find(opts, dd.Value) then dd.Value = "..." end

				local holder = SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, 32), Parent = ItemParent, ClipsDescendants = true})
				local dl = MakeElement("List")
				local dc = AddThemeObject(SetProps(SetChildren(MakeElement("ScrollFrame", Color3.fromRGB(100, 160, 230), 3), {dl}), {
					Parent = holder, Position = UDim2.new(0, 0, 0, 32), Size = UDim2.new(1, 0, 1, -32), ClipsDescendants = true
				}), "Divider")
				local click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})
				local df = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 32), Parent = holder, BackgroundTransparency = 0.3
				}), {
					dc,
					SetProps(SetChildren(MakeElement("TFrame"), {
						AddThemeObject(SetProps(MakeElement("Label", DropdownConfig.Name or "Dropdown", 13), {
							Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.GothamBold, Name = "Content"
						}), "Text"),
						AddThemeObject(SetProps(MakeElement("Label", "...", 12), {
							Size = UDim2.new(1, -35, 1, 0), Font = Enum.Font.Gotham, Name = "Selected", TextXAlignment = Enum.TextXAlignment.Right
						}), "TextDark"),
						AddThemeObject(SetProps(MakeElement("Frame"), {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), Name = "Line", Visible = false}), "Stroke"),
						click
					}), {Size = UDim2.new(1, 0, 0, 32), ClipsDescendants = true, Name = "F"}),
					AddThemeObject(MakeElement("Stroke"), "Stroke"), MakeElement("Corner")
				}), "Second")

				AddConnection(dl:GetPropertyChangedSignal("AbsoluteContentSize"), function() dc.CanvasSize = UDim2.new(0, 0, 0, dl.AbsoluteContentSize.Y) end)

				local function AddOptions(Options)
					for _, Option in pairs(Options) do
						local b = AddThemeObject(SetProps(SetChildren(MakeElement("Button"), {
							MakeElement("Corner", 0, 5),
							AddThemeObject(SetProps(MakeElement("Label", Option, 12, 0.35), {Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(1, -8, 1, 0), Name = "Title"}), "Text")
						}), {Parent = dc, Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, ClipsDescendants = true}), "Divider")
						AddConnection(b.MouseButton1Click, function() dd:Set(Option); SaveCfg(game.GameId) end)
						dd.Buttons[Option] = b
					end
				end

				function dd:Refresh(Options, Delete)
					if Delete then for _, v in pairs(dd.Buttons) do v:Destroy() end; table.clear(dd.Options); table.clear(dd.Buttons) end
					dd.Options = Options; AddOptions(dd.Options)
				end

				function dd:Set(Value)
					if not table.find(dd.Options, Value) then
						dd.Value = "..."; df.F.Selected.Text = dd.Value
						for _, v in pairs(dd.Buttons) do
							TweenService:Create(v, TweenInfo.new(.15), {BackgroundTransparency = 1}):Play()
							TweenService:Create(v.Title, TweenInfo.new(.15), {TextTransparency = 0.35}):Play()
						end
						return
					end
					dd.Value = Value; df.F.Selected.Text = Value
					for _, v in pairs(dd.Buttons) do
						TweenService:Create(v, TweenInfo.new(.15), {BackgroundTransparency = 1}):Play()
						TweenService:Create(v.Title, TweenInfo.new(.15), {TextTransparency = 0.35}):Play()
					end
					TweenService:Create(dd.Buttons[Value], TweenInfo.new(.15), {BackgroundTransparency = 0.15}):Play()
					TweenService:Create(dd.Buttons[Value].Title, TweenInfo.new(.15), {TextTransparency = 0}):Play()
					(DropdownConfig.Callback or function() end)(Value)
				end

				AddConnection(click.MouseButton1Click, function()
					dd.Toggled = not dd.Toggled; df.F.Line.Visible = dd.Toggled
					local h = #dd.Options > MaxElements and 32 + (MaxElements * 24) or dl.AbsoluteContentSize.Y + 32
					TweenService:Create(df, TweenInfo.new(.15), {Size = dd.Toggled and UDim2.new(1, 0, 0, h) or UDim2.new(1, 0, 0, 32)}):Play()
					holder.Size = UDim2.new(1, 0, 0, dd.Toggled and h or 32)
				end)

				dd:Refresh(opts, false); dd:Set(dd.Value)
				if DropdownConfig.Flag then XvPxOL.Flags[DropdownConfig.Flag] = dd end
				return dd
			end

			function EF:AddTextbox(TextboxConfig)
				TextboxConfig = TextboxConfig or {}
				local click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})
				local tb = AddThemeObject(Create("TextBox", {
					Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(60, 130, 210),
					PlaceholderColor3 = Color3.fromRGB(120, 170, 230), PlaceholderText = "输入...",
					Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Center, TextSize = 12, ClearTextOnFocus = false
				}), "Text")
				local tc = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 4), {
					Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -10, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 0.35
				}), {AddThemeObject(MakeElement("Stroke"), "Stroke"), tb}), "Main")
				local holder = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 34), Parent = ItemParent, BackgroundTransparency = 0.3
				}), {
					AddThemeObject(SetProps(MakeElement("Label", TextboxConfig.Name or "Textbox", 13), {
						Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.GothamBold
					}), "Text"),
					AddThemeObject(MakeElement("Stroke"), "Stroke"), tc, click
				}), "Second")
				AddConnection(tb.FocusLost, function() (TextboxConfig.Callback or function() end)(tb.Text); if TextboxConfig.TextDisappear then tb.Text = "" end end)
				tb.Text = TextboxConfig.Default or ""
				AddConnection(click.MouseButton1Up, function() tb:CaptureFocus() end)
			end

			function EF:AddColorpicker(ColorpickerConfig)
				ColorpickerConfig = ColorpickerConfig or {}
				local ColorH, ColorS, ColorV = (ColorpickerConfig.Default or Color3.fromRGB(100, 160, 230)):ToHSV()
				local cp = {Value = ColorpickerConfig.Default or Color3.fromRGB(100, 160, 230), Toggled = false, Save = ColorpickerConfig.Save or false}

				local colorBox = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", cp.Value, 0, 4), {
					Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -28, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 0.25
				}), {MakeElement("Stroke", cp.Value, 1.2)}), "Main")

				local colorContainer = Create("Frame", {
					Position = UDim2.new(0, 0, 0, 36), Size = UDim2.new(1, 0, 1, -36),
					BackgroundTransparency = 1, ClipsDescendants = true
				})

				local ColorMap = Create("ImageLabel", {
					Size = UDim2.new(1, -30, 1, 0), BackgroundTransparency = 1,
					Image = "rbxassetid://4155801252"
				}, {Create("UICorner", {CornerRadius = UDim.new(0, 4)})})

				local ColorCursor = Create("ImageLabel", {
					Size = UDim2.new(0, 16, 0, 16), ScaleType = Enum.ScaleType.Fit,
					AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1,
					Image = "http://www.roblox.com/asset/?id=4805639000",
					Position = UDim2.new(ColorS, 0, 1 - ColorV, 0), ZIndex = 5, Parent = ColorMap
				})

				local HueMap = Create("Frame", {
					Size = UDim2.new(0, 24, 1, 0), Position = UDim2.new(1, -24, 0, 0), BackgroundTransparency = 1
				}, {
					Create("UIGradient", {
						Rotation = 270,
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
							ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
							ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
							ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
							ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
							ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
							ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
						})
					}), Create("UICorner", {CornerRadius = UDim.new(0, 4)})
				})

				local HueCursor = Create("ImageLabel", {
					Size = UDim2.new(0, 16, 0, 16), ScaleType = Enum.ScaleType.Fit,
					AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1,
					Image = "http://www.roblox.com/asset/?id=4805639000",
					Position = UDim2.new(0.5, 0, ColorH, 0), ZIndex = 5, Parent = HueMap
				})

				Create("UIPadding", {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), PaddingBottom = UDim.new(0, 8), PaddingTop = UDim.new(0, 8), Parent = colorContainer})
				ColorMap.Parent = colorContainer
				HueMap.Parent = colorContainer

				local Click = SetProps(MakeElement("Button"), {Size = UDim2.new(1, 0, 1, 0)})
				local cpf = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(225, 235, 255), 0, 5), {
					Size = UDim2.new(1, 0, 0, 36), Parent = ItemParent, BackgroundTransparency = 0.3, ClipsDescendants = true
				}), {
					SetProps(SetChildren(MakeElement("TFrame"), {
						AddThemeObject(SetProps(MakeElement("Label", ColorpickerConfig.Name or "Colorpicker", 13), {
							Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = Enum.Font.GothamBold
						}), "Text"),
						colorBox, Click,
						AddThemeObject(SetProps(MakeElement("Frame"), {
							Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), Name = "Line", Visible = false
						}), "Stroke"),
					}), {Size = UDim2.new(1, 0, 0, 36), ClipsDescendants = true, Name = "F"}),
					colorContainer, AddThemeObject(MakeElement("Stroke"), "Stroke"),
				}), "Second")

				local ColorMapDragging = false
				local HueMapDragging = false

				local function UpdateColorPicker()
					cp.Value = Color3.fromHSV(ColorH, ColorS, ColorV)
					colorBox.BackgroundColor3 = cp.Value
					colorBox.UIStroke.Color = cp.Value
					ColorMap.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
					(ColorpickerConfig.Callback or function() end)(cp.Value)
					SaveCfg(game.GameId)
				end

				AddConnection(ColorMap.InputBegan, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						ColorMapDragging = true
						ColorS = math.clamp((Mouse.X - ColorMap.AbsolutePosition.X) / ColorMap.AbsoluteSize.X, 0, 1)
						ColorV = 1 - math.clamp((Mouse.Y - ColorMap.AbsolutePosition.Y) / ColorMap.AbsoluteSize.Y, 0, 1)
						ColorCursor.Position = UDim2.new(ColorS, 0, 1 - ColorV, 0)
						UpdateColorPicker()
					end
				end)
				AddConnection(ColorMap.InputEnded, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then ColorMapDragging = false end
				end)
				AddConnection(HueMap.InputBegan, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						HueMapDragging = true
						ColorH = math.clamp((Mouse.Y - HueMap.AbsolutePosition.Y) / HueMap.AbsoluteSize.Y, 0, 1)
						HueCursor.Position = UDim2.new(0.5, 0, ColorH, 0)
						UpdateColorPicker()
					end
				end)
				AddConnection(HueMap.InputEnded, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then HueMapDragging = false end
				end)
				AddConnection(UserInputService.InputChanged, function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						if ColorMapDragging then
							ColorS = math.clamp((Mouse.X - ColorMap.AbsolutePosition.X) / ColorMap.AbsoluteSize.X, 0, 1)
							ColorV = 1 - math.clamp((Mouse.Y - ColorMap.AbsolutePosition.Y) / ColorMap.AbsoluteSize.Y, 0, 1)
							ColorCursor.Position = UDim2.new(ColorS, 0, 1 - ColorV, 0)
							UpdateColorPicker()
						end
						if HueMapDragging then
							ColorH = math.clamp((Mouse.Y - HueMap.AbsolutePosition.Y) / HueMap.AbsoluteSize.Y, 0, 1)
							HueCursor.Position = UDim2.new(0.5, 0, ColorH, 0)
							UpdateColorPicker()
						end
					end
				end)

				AddConnection(Click.MouseButton1Click, function()
					cp.Toggled = not cp.Toggled
					TweenService:Create(cpf, TweenInfo.new(.15, Enum.EasingStyle.Quad), {
						Size = cp.Toggled and UDim2.new(1, 0, 0, 170) or UDim2.new(1, 0, 0, 36)
					}):Play()
					cpf.F.Line.Visible = cp.Toggled
				end)

				function cp:Set(Value)
					cp.Value = Value; ColorH, ColorS, ColorV = Value:ToHSV()
					colorBox.BackgroundColor3 = Value; colorBox.UIStroke.Color = Value
					ColorMap.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
					ColorCursor.Position = UDim2.new(ColorS, 0, 1 - ColorV, 0)
					HueCursor.Position = UDim2.new(0.5, 0, ColorH, 0)
					(ColorpickerConfig.Callback or function() end)(Value)
				end

				UpdateColorPicker()
				if ColorpickerConfig.Flag then XvPxOL.Flags[ColorpickerConfig.Flag] = cp end
				return cp
			end

			return EF
		end

		local EF = {}
		function EF:AddSection(SectionConfig)
			local sf = SetChildren(SetProps(MakeElement("TFrame"), {Size = UDim2.new(1, 0, 0, 22), Parent = Container}), {
				AddThemeObject(SetProps(MakeElement("Label", SectionConfig.Name or "Section", 12), {
					Size = UDim2.new(1, -8, 0, 14), Position = UDim2.new(0, 0, 0, 2), Font = Enum.Font.GothamSemibold
				}), "TextDark"),
				SetChildren(SetProps(MakeElement("TFrame"), {
					AnchorPoint = Vector2.new(0, 0), Size = UDim2.new(1, 0, 1, -20), Position = UDim2.new(0, 0, 0, 20), Name = "Holder"
				}), {MakeElement("List", 0, 5)}),
			})
			AddConnection(sf.Holder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
				sf.Size = UDim2.new(1, 0, 0, sf.Holder.UIListLayout.AbsoluteContentSize.Y + 26)
				sf.Holder.Size = UDim2.new(1, 0, 0, sf.Holder.UIListLayout.AbsoluteContentSize.Y)
			end)
			local sf2 = {}
			for i, v in next, GetElements(sf.Holder) do sf2[i] = v end
			return sf2
		end
		for i, v in next, GetElements(Container) do EF[i] = v end
		return EF
	end
	return TabFunction
end

function XvPxOL:Destroy()
	XvPxOL_UI:Destroy()
end

return XvPxOL