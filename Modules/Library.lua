local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {}
Library.Instances = {}

local Root = script.Parent

local Fade = loadstring(game:HttpGet("https://raw.githubusercontent.com/tntmaster1385/ServerLib/refs/heads/main/Library/Fade.lua"))()
local SnapDragon = loadstring(game:HttpGet("https://raw.githubusercontent.com/tntmaster1385/ServerLib/refs/heads/main/Library/SnapDragon/init.lua"))()
local FitToSize = loadstring(game:HttpGet("https://raw.githubusercontent.com/tntmaster1385/ServerLib/refs/heads/main/Library/FitToSize.lua"))()
local CircleClick = loadstring(game:HttpGet("https://raw.githubusercontent.com/tntmaster1385/ServerLib/refs/heads/main/Library/CircleClick.lua"))()
local States = loadstring(game:HttpGet("https://raw.githubusercontent.com/tntmaster1385/ServerLib/refs/heads/main/Library/States.lua"))()

function Library:Tween(Object, Info, Goal)
	local Tween = TweenService:Create(Object, Info, Goal)
	Tween:Play()
	return Tween
end

function Library:SetDraggable(Frame1, Frame2, Snap: Boolean?)
	SnapDragon.createDragController(Frame1, {SnapEnabled = Snap, DragGui = Frame2}):Connect()
end

function Library:Center(Frame)
	if Frame then
		Frame.Position = UDim2.new(0.5, -Frame.Size.X.Offset/2, 0.5, -Frame.Size.Y.Offset/2);
	end
end

function Library:ValidateOptions(Default, Options)
	for Index, Value in pairs(Default) do
		if Options[Index] == nil then
			Options[Index] = Value
		end
	end
	return Options
end

function Library:DeltaRuntime(Function)
	if type(Function) == "function" then else return end
	task.spawn(function()
		local Delta = 1/30
		while task.wait(Delta) do
			Function()
		end
	end)
end

function Library:CircularButton(Options, Size, IconSize)
	local Hovering = false

	if not Size then
		Size = UDim2.new(0,30,0,30)
	end
	if not IconSize then
		IconSize = UDim2.new(0,20,0,20)
	end

	local Button = Instance.new("ImageButton");
	Button["BorderSizePixel"] = 0;
	Button["AutoButtonColor"] = false;
	Button["ImageTransparency"] = 1;
	Button["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
	Button["AnchorPoint"] = Vector2.new(1, 0.5);
	Button["Image"] = [[rbxasset://textures/ui/GuiImagePlaceholder.png]];
	Button["Size"] = Size;
	Button["BackgroundTransparency"] = 1;
	Button["Name"] = [[CircleButton]];
	Button["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	Button["Position"] = UDim2.new(1, -10, 0.5, 0);

	local Padding = Instance.new("UIPadding", Button);
	Padding["PaddingRight"] = UDim.new(0, 10);
	Padding["PaddingLeft"] = UDim.new(0, 10);

	local Icon = Instance.new("ImageLabel", Button);
	Icon["ZIndex"] = 3;
	Icon["ImageColor3"] = Color3.fromRGB(201, 201, 201);
	Icon["AnchorPoint"] = Vector2.new(0.5, 0.5);
	Icon["Image"] = [[rbxassetid://0]];
	Icon["Size"] = IconSize;
	Icon["BackgroundTransparency"] = 1;
	Icon["Name"] = [[Icon]];
	Icon["Position"] = UDim2.new(0.5, 0, 0.5, 0);

	local Ripple = Instance.new("Frame", Button);
	Ripple["BorderSizePixel"] = 0;
	Ripple["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	Ripple["AnchorPoint"] = Vector2.new(0.5, 0.5);
	Ripple["Size"] = UDim2.new(1, 20, 1, 0);
	Ripple["Position"] = UDim2.new(0.5, 0, 0.5, 0);
	Ripple["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	Ripple["Name"] = [[Ripple]];
	Ripple["BackgroundTransparency"] = 1;

	local Corner = Instance.new("UICorner", Ripple);
	Corner["CornerRadius"] = UDim.new(1, 0);

	local Scale = Instance.new("UIScale", Ripple);
	Scale["Name"] = [[Scale]];
	Scale["Scale"] = 0;

	Button.MouseEnter:Connect(function()
		Hovering = true
		self:Tween(Ripple.Scale, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Scale = 1})
		self:Tween(Ripple, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = .95})
	end)

	Button.MouseLeave:Connect(function()
		Hovering = false
		self:Tween(Ripple.Scale, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Scale = 0})
		self:Tween(Ripple, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = 1})
	end)

	UserInputService.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch or Input.KeyCode == Enum.KeyCode.ButtonR2 then
			if not Hovering then return end
			self:Tween(Ripple, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = .9})
		end
	end)

	UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch or Input.KeyCode == Enum.KeyCode.ButtonR2 then
			if not Hovering then
				self:Tween(Ripple, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = 1})
			else
				self:Tween(Ripple, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = .95})
			end
		end
	end)

	self:DeltaRuntime(function()
		Icon.ImageColor3 = Options.Theme[Options.CurrentTheme].RegularTextColor
		Ripple.BackgroundColor3 = Options.Theme[Options.CurrentTheme].CircularButtonRippleColor
	end)

	return Button
end

function Library:Window(Options)
	local Window = {}

	local NavigationOpened = false
	local NavigationClosing = false

	local Parent = nil
	local Pages = nil
	local Navigation = nil
	local NavScroll = nil
	local NavScale = nil
	Window.CurrentTab = nil

	Options = self:ValidateOptions({
		Name = "Server's Library",
		CurrentTheme = "Dark",
		Theme = {
			Dark = {
				BrandColor = Color3.fromRGB(255, 0, 0),

				TabItemBackgroundColor = Color3.fromRGB(35, 35, 35),
				TabItemHoverColor = Color3.fromRGB(50,50,50),
				Outline = Color3.fromRGB(50, 50, 50),
				Background = Color3.fromRGB(25, 25, 25),
				DropShadow = Color3.fromRGB(20, 20, 20),
				RegularTextColor = Color3.fromRGB(200, 200, 200),
				ShadedTextColor = Color3.fromRGB(150, 150, 150),
				CircularButtonRippleColor = Color3.fromRGB(255, 255, 255),
				NavigationBackgroundColor = Color3.fromRGB(36,36,36),
				SliderFillOutlineColor = Color3.fromRGB(71, 71, 71),
				ToggleBoxColor = Color3.fromRGB(50,50,50),
				CheckmarkColor = Color3.fromRGB(0, 0, 0),
				TopGradientColor = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(41, 41, 41)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(26, 26, 26))},
			},

			Light = {
				BrandColor = Color3.fromRGB(114, 135, 253),

				TabItemBackgroundColor = Color3.fromRGB(230, 230, 230),
				TabItemHoverColor = Color3.fromRGB(150,150,150),
				Outline = Color3.fromRGB(150,150,150),
				Background = Color3.fromRGB(255, 255, 255),
				DropShadow = Color3.fromRGB(20, 20, 20),
				RegularTextColor = Color3.fromRGB(50, 50, 50),
				ShadedTextColor = Color3.fromRGB(100,100,100),
				CircularButtonRippleColor = Color3.fromRGB(0, 0, 0),
				NavigationBackgroundColor = Color3.fromRGB(255, 255, 255),
				SliderFillOutlineColor = Color3.fromRGB(100,100,100),
				ToggleBoxColor = Color3.fromRGB(255,255,255),
				CheckmarkColor = Color3.fromRGB(255, 255, 255),
				TopGradientColor = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(216, 216, 216))},
			},
		},

		DragSnapping = false,
		TopMost = true,
	}, Options or {})

	local WindowGui = Instance.new("GuiMain")
	WindowGui.Name = Options.Name
	WindowGui.ResetOnSpawn = false

	Window.Gui = WindowGui

	if not RunService:IsStudio() then
		if syn then
			syn.protect_gui(WindowGui)
		elseif protect_gui then
			protect_gui(WindowGui)
		else
			Parent = CoreGui
		end
	else
		Parent = LocalPlayer.PlayerGui
	end

	if Parent then
		WindowGui.Parent = Parent
	end

	local function OpenNav()
		if NavigationClosing then return end
		NavigationOpened = true
		Navigation.Visible = true
		Fade:FadeOpen(Navigation, .3)
		self:Tween(NavScale, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Scale = 1})
	end

	local function CloseNav()
		NavigationOpened = false
		NavigationClosing = true
		Fade:FadeClose(Navigation, .3)
		self:Tween(NavScale, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Scale = .95})
		task.spawn(function()
			task.wait(.3)
			Navigation.Visible = false
			NavigationClosing = false
		end)
	end

	do 
		local Main = Instance.new("Frame", WindowGui);
		Main["BorderSizePixel"] = 0;
		Main["BackgroundColor3"] = Color3.fromRGB(26, 26, 26);
		Main["AnchorPoint"] = Vector2.new(0,0);
		Main["Size"] = UDim2.new(0, 550, 0, 400);
		Main["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Main["Name"] = [[Main]];
		Main["BackgroundTransparency"] = 1;

		self:Center(Main)
		FitToSize:Set(WindowGui)
		if Options.TopMost then
			WindowGui.DisplayOrder = 2147483647
		end

		local _Fullscreen = Instance.new("ScreenGui", Main)
		_Fullscreen.ZIndexBehavior = Enum.ZIndexBehavior.Global
		_Fullscreen.Enabled = false
		_Fullscreen.IgnoreGuiInset = true
		_Fullscreen.Name = "_fullscreen"
		local FullscreenBackground = Instance.new("Frame", _Fullscreen)
		FullscreenBackground.Size = UDim2.new(1,0,1,0)

		local Background = Instance.new("Frame", Main);
		Background["ZIndex"] = -1;
		Background["BorderSizePixel"] = 0;
		Background["BackgroundColor3"] = Color3.fromRGB(26, 26, 26);
		Background["Size"] = UDim2.new(1, 0, 1, 0);
		Background["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Background["Name"] = [[Background]];
		Background["BackgroundTransparency"] = 0.05;

		local Corner = Instance.new("UICorner", Background);
		Corner["CornerRadius"] = UDim.new(0, 5);

		local Stroke = Instance.new("UIStroke", Background);
		Stroke["Transparency"] = 0.5;
		Stroke["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
		Stroke["Color"] = Color3.fromRGB(51, 51, 51);

		local DropShadow = Instance.new("Frame", Background);
		DropShadow["ZIndex"] = 0;
		DropShadow["BorderSizePixel"] = 0;
		DropShadow["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		DropShadow["AnchorPoint"] = Vector2.new(0.5, 0.5);
		DropShadow["Size"] = UDim2.new(1, 35, 1, 35);
		DropShadow["Position"] = UDim2.new(0.5, 0, 0.5, 0);
		DropShadow["Name"] = [[DropShadow]];
		DropShadow["BackgroundTransparency"] = 1;

		local Shadow = Instance.new("ImageLabel", DropShadow);
		Shadow["ZIndex"] = -2;
		Shadow["BorderSizePixel"] = 0;
		Shadow["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		Shadow["ImageTransparency"] = 0.4;
		Shadow["ImageColor3"] = Color3.fromRGB(21, 21, 21);
		Shadow["AnchorPoint"] = Vector2.new(0.5, 0.5);
		Shadow["Image"] = [[rbxassetid://5587865193]];
		Shadow["Size"] = UDim2.new(1.6, 0, 1.3, 0);
		Shadow["BackgroundTransparency"] = 1;
		Shadow["Name"] = [[Shadow1]];
		Shadow["Position"] = UDim2.new(0.50748, 0, 0.5098, 0);

		local Top = Instance.new("Frame", Main);
		Top["BorderSizePixel"] = 0;
		Top["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		Top["ClipsDescendants"] = true;
		Top["Size"] = UDim2.new(1, 0, 0, 45);
		Top["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Top["Name"] = [[Top]];
		Top["BackgroundTransparency"] = 1;

		local TopBackground = Instance.new("Frame", Top);
		TopBackground["ZIndex"] = 0;
		TopBackground["BorderSizePixel"] = 0;
		TopBackground["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		TopBackground["Size"] = UDim2.new(1, 0, 1, 10);
		TopBackground["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		TopBackground["Name"] = [[Background]];

		local Corner = Instance.new("UICorner", TopBackground);
		Corner["CornerRadius"] = UDim.new(0, 5);

		local TopGradient = Instance.new("UIGradient", TopBackground);
		TopGradient["Rotation"] = 90;
		TopGradient["Name"] = [[TopGradient]];
		TopGradient["Color"] = Options.Theme[Options.CurrentTheme].TopGradientColor;

		local Title = Instance.new("TextLabel", Top);
		Title["BorderSizePixel"] = 0;
		Title["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		Title["TextSize"] = 14;
		Title["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
		Title["TextColor3"] = Color3.fromRGB(151, 151, 151);
		Title["BackgroundTransparency"] = 1;
		Title["AnchorPoint"] = Vector2.new(0.5, 0.5);
		Title["Size"] = UDim2.new(0, 0, 1, 0);
		Title["AutomaticSize"] = Enum.AutomaticSize.X
		Title["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Title["Text"] = Options.Name;
		Title["Name"] = [[Title]];
		Title["Position"] = UDim2.new(0.5, 0, 0.5, 0);

		local Underline = Instance.new("Frame", Top);
		Underline["BorderSizePixel"] = 0;
		Underline["BackgroundColor3"] = Color3.fromRGB(51, 51, 51);
		Underline["AnchorPoint"] = Vector2.new(0, 1);
		Underline["Size"] = UDim2.new(1, 0, 0, 1);
		Underline["Position"] = UDim2.new(0, 0, 1, 0);
		Underline["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Underline["Name"] = [[Underline]];

		Pages = Instance.new("Frame", Main);
		Pages["BorderSizePixel"] = 0;
		Pages["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		Pages["AnchorPoint"] = Vector2.new(0, 1);
		Pages["Size"] = UDim2.new(1, 0, 1, -45);
		Pages["Position"] = UDim2.new(0, 0, 1, 0);
		Pages["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Pages["Name"] = [[Pages]];
		Pages["BackgroundTransparency"] = 1;
		Pages["Visible"] = false

		local Padding = Instance.new("UIPadding", Pages);
		Padding["PaddingTop"] = UDim.new(0, 10);
		Padding["PaddingRight"] = UDim.new(0, 10);
		Padding["PaddingLeft"] = UDim.new(0, 10);
		Padding["PaddingBottom"] = UDim.new(0, 10);

		Navigation = Instance.new("Frame", Main);
		Navigation["Visible"] = false;
		Navigation["ZIndex"] = 6;
		Navigation["BorderSizePixel"] = 0;
		Navigation["BackgroundColor3"] = Options.Theme[Options.CurrentTheme].NavigationBackgroundColor;
		Navigation["AnchorPoint"] = Vector2.new(0, 1);
		Navigation["Size"] = UDim2.new(0, 175, 1, -65);
		Navigation["Position"] = UDim2.new(0, 10, 1, -10);
		Navigation["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Navigation["Name"] = [[Navigation]];
		Navigation.Selectable = true

		local Stroke = Instance.new("UIStroke", Navigation);
		Stroke["Transparency"] = 0.5;
		Stroke["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
		Stroke["Color"] = Color3.fromRGB(51, 51, 51);

		local Corner = Instance.new("UICorner", Navigation);
		Corner["CornerRadius"] = UDim.new(0, 5);

		NavScroll = Instance.new("ScrollingFrame", Navigation);
		NavScroll["Active"] = true;
		NavScroll["ZIndex"] = 6;
		NavScroll["BorderSizePixel"] = 0;
		NavScroll["CanvasSize"] = UDim2.new(0, 0, 0, 0);
		NavScroll["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		NavScroll["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
		NavScroll["Size"] = UDim2.new(1, 0, 1, 0);
		NavScroll["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		NavScroll["ScrollBarThickness"] = 0;
		NavScroll["BackgroundTransparency"] = 1;

		local Layout = Instance.new("UIListLayout", NavScroll);
		Layout["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
		Layout["Padding"] = UDim.new(0, 5);
		Layout["SortOrder"] = Enum.SortOrder.LayoutOrder;

		local Padding = Instance.new("UIPadding", NavScroll);
		Padding["PaddingTop"] = UDim.new(0, 5);
		Padding["PaddingRight"] = UDim.new(0, 5);
		Padding["PaddingLeft"] = UDim.new(0, 5);
		Padding["PaddingBottom"] = UDim.new(0, 5);

		local MainScale = Instance.new("UIScale", Main)
		MainScale.Name = "Scale"

		local CloseButton = self:CircularButton(Options)
		CloseButton.Icon.Image = [[rbxassetid://2777727756]]
		CloseButton.Parent = Top
		CloseButton.Activated:Connect(function()
			Fade:FadeClose(Main, .3)
			Pages.Visible = false
			_Fullscreen.Enabled = false
			self:Tween(MainScale, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Scale = .95})
			task.spawn(function()
				task.wait(.3)
				WindowGui.Enabled = false
				WindowGui:Destroy()
			end)
		end)

		local MaximizeButton = self:CircularButton(Options)
		MaximizeButton.Icon.Image = [[rbxassetid://11036884234]]
		MaximizeButton.Parent = Top
		MaximizeButton.Position = UDim2.new(1, -40, 0.5, 0)

		local MinimizeButton = self:CircularButton(Options)
		MinimizeButton.Icon.Image = [[rbxassetid://17601421663]]
		MinimizeButton.Parent = Top
		MinimizeButton.Position = UDim2.new(1, -70, 0.5, 0)
		MinimizeButton.Icon.Size = UDim2.new(0,15,0,15)

		NavScale = Instance.new("UIScale", Navigation)
		NavScale.Name = "Scale"
		NavScale.Scale = .95

		local MenuButton = self:CircularButton(Options)
		MenuButton.Icon.Image = [[rbxassetid://2777728378]]
		MenuButton.Parent = Top
		MenuButton.Position = UDim2.new(0, 10, 0.5, 0)
		MenuButton.AnchorPoint = Vector2.new(0,0.5)
		MenuButton.Activated:Connect(function()
			if not NavigationOpened then
				OpenNav()
			else
				CloseNav()
			end
		end)

		self:DeltaRuntime(function()
			Background.BackgroundColor3 = Options.Theme[Options.CurrentTheme].Background
			Stroke.Color = Options.Theme[Options.CurrentTheme].Outline
			Underline.BackgroundColor3 = Options.Theme[Options.CurrentTheme].Outline
			Title.TextColor3 = Options.Theme[Options.CurrentTheme].ShadedTextColor
			TopGradient.Color = Options.Theme[Options.CurrentTheme].TopGradientColor;
			Navigation.BackgroundColor3 = Options.Theme[Options.CurrentTheme].NavigationBackgroundColor;
			FullscreenBackground.BackgroundColor3 = Options.Theme[Options.CurrentTheme].Background
		end)

		function Window:Rename(Name)
			Title.Text = Name
			WindowGui.Name = Name
		end

		local NewStates = States.new(Main)

		local Maximized = false
		local Minimized = false

		MaximizeButton.Activated:Connect(function()
			if not Maximized then
				NewStates:setState("Maximize", function()
					Maximized = true
					Minimized = false
					MaximizeButton.Icon.Image = "rbxassetid://10137941941"
					MinimizeButton.Icon.Image = "rbxassetid://17601421663"
					Underline.Visible = true
					Fade:FadeOpen(Background, .3)
					SnapDragon.setDragState(false)
				end)
			else
				NewStates:setState("None", function()
					Maximized = false
					Minimized = false
					MaximizeButton.Icon.Image = "rbxassetid://11036884234"
					MinimizeButton.Icon.Image = "rbxassetid://17601421663"
					Underline.Visible = true
					Fade:FadeOpen(Background, .3)
					SnapDragon.setDragState(true)
				end)
			end
		end)

		MinimizeButton.Activated:Connect(function()
			if not Minimized then
				NewStates:setState("Minimize", function()
					Minimized = true
					Maximized = false
					MaximizeButton.Icon.Image = "rbxassetid://11036884234"
					MinimizeButton.Icon.Image = "rbxassetid://17612085260"
					Underline.Visible = false
					_Fullscreen.Enabled = false
					Fade:FadeClose(Background, .4)
					SnapDragon.setDragState(true)
				end)
			else
				NewStates:setState("None", function()
					Minimized = false
					Maximized = false
					MaximizeButton.Icon.Image = "rbxassetid://11036884234"
					MinimizeButton.Icon.Image = "rbxassetid://17601421663"
					Underline.Visible = true
					Fade:FadeOpen(Background, .3)
					SnapDragon.setDragState(true)
				end)
			end
		end)

		Fade:FadeClose(Main, 0)
		ContentProvider:PreloadAsync({WindowGui, Main})
		Fade:FadeOpen(Main, .3)
		MainScale.Scale = .95
		self:Tween(MainScale, TweenInfo.new(.3), {Scale = 1})
		task.spawn(function()
			wait(.3)
			Pages["Visible"] = true
			self:SetDraggable(Main, Main, Options.DragSnapping)
			Fade:FadeClose(Navigation, .3)
		end)
	end

	function Window:SwitchTheme(Theme)
		Options.CurrentTheme = Theme
	end

	function Window:Tab(TabOptions)
		local Tab = {}

		local ItemIndex = 0

		local Selected = false

		TabOptions = Library:ValidateOptions({
			Name = "Tab Example",
			Icon = 12988752403,
		}, TabOptions or {})

		local Page = Instance.new("ImageLabel", Pages);
		Page["BorderSizePixel"] = 0;
		Page["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		Page["ImageTransparency"] = 1;
		Page["Image"] = [[rbxasset://textures/ui/GuiImagePlaceholder.png]];
		Page["Size"] = UDim2.new(1, 0, 1, 0);
		Page["ClipsDescendants"] = true;
		Page["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Page["BackgroundTransparency"] = 1;
		Page["Name"] = TabOptions.Name;

		local Scroll = Instance.new("ScrollingFrame", Page);
		Scroll["Active"] = true;
		Scroll["BorderSizePixel"] = 0;
		Scroll["CanvasSize"] = UDim2.new(0, 0, 0, 0);
		Scroll["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		Scroll["AnchorPoint"] = Vector2.new(0, 1);
		Scroll["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
		Scroll["Size"] = UDim2.new(1, 0, 1, -25);
		Scroll["Position"] = UDim2.new(0, 0, 1, 0);
		Scroll["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Scroll["ScrollBarThickness"] = 0;
		Scroll["BackgroundTransparency"] = 1;

		local Layout = Instance.new("UIListLayout", Scroll);
		Layout["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
		Layout["Padding"] = UDim.new(0, 10);
		Layout["SortOrder"] = Enum.SortOrder.Name;

		local Padding = Instance.new("UIPadding", Scroll);
		Padding["PaddingTop"] = UDim.new(0, 1);
		Padding["PaddingRight"] = UDim.new(0, 1);
		Padding["PaddingLeft"] = UDim.new(0, 1);
		Padding["PaddingBottom"] = UDim.new(0, 1);

		local TabButton = Instance.new("TextButton", NavScroll);
		TabButton["TextTruncate"] = Enum.TextTruncate.AtEnd;
		TabButton["BorderSizePixel"] = 0;
		TabButton["TextXAlignment"] = Enum.TextXAlignment.Left;
		TabButton["AutoButtonColor"] = false;
		TabButton["TextSize"] = 14;
		TabButton["TextColor3"] = Color3.fromRGB(151, 151, 151);
		TabButton["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
		TabButton["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
		TabButton["ZIndex"] = 7;
		TabButton["Size"] = UDim2.new(1, 0, 0, 25);
		TabButton["BackgroundTransparency"] = 1;
		TabButton["Name"] = TabOptions.Name;
		TabButton["ClipsDescendants"] = true;
		TabButton["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		TabButton["Text"] = TabOptions.Name;

		local TabIcon = Instance.new("ImageLabel", TabButton);
		TabIcon["ZIndex"] = 9;
		TabIcon["ImageColor3"] = Color3.fromRGB(201, 201, 201);
		TabIcon["AnchorPoint"] = Vector2.new(0, 0.5);
		TabIcon["Image"] = [[rbxassetid://]]..TabOptions.Icon;
		TabIcon["Size"] = UDim2.new(0, 15, 0, 15);
		TabIcon["BackgroundTransparency"] = 1;
		TabIcon["Name"] = [[Icon]];
		TabIcon["Position"] = UDim2.new(0, -22, 0.5, 0);

		local Padding = Instance.new("UIPadding", TabButton);
		Padding["PaddingTop"] = UDim.new(0, 5);
		Padding["PaddingRight"] = UDim.new(0, 5);
		Padding["PaddingLeft"] = UDim.new(0, 25);
		Padding["PaddingBottom"] = UDim.new(0, 5);

		local PageName = Instance.new("TextLabel", Page);
		PageName["TextTruncate"] = Enum.TextTruncate.AtEnd;
		PageName["BorderSizePixel"] = 0;
		PageName["TextXAlignment"] = Enum.TextXAlignment.Left;
		PageName["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		PageName["TextSize"] = 16;
		PageName["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
		PageName["TextColor3"] = Color3.fromRGB(226, 226, 226);
		PageName["BackgroundTransparency"] = 1;
		PageName["Size"] = UDim2.new(1, 0, 0, 20);
		PageName["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		PageName["Text"] = TabOptions.Name;
		PageName["Name"] = [[PageName]];

		local PageIcon = Instance.new("ImageLabel", PageName);
		PageIcon["ZIndex"] = 9;
		PageIcon["ImageColor3"] = Color3.fromRGB(201, 201, 201);
		PageIcon["AnchorPoint"] = Vector2.new(1, 0.5);
		PageIcon["Image"] = [[rbxassetid://]]..TabOptions.Icon;
		PageIcon["Size"] = UDim2.new(0, 20, 0, 20);
		PageIcon["BackgroundTransparency"] = 1;
		PageIcon["Name"] = [[Icon]];
		PageIcon["Position"] = UDim2.new(1, 0, 0.5, 0);

		local Padding = Instance.new("UIPadding", PageName);
		Padding["PaddingRight"] = UDim.new(0, 5);

		local Underline = Instance.new("Frame", PageName);
		Underline["BorderSizePixel"] = 0;
		Underline["BackgroundColor3"] = Color3.fromRGB(70, 175, 255);
		Underline["AnchorPoint"] = Vector2.new(0, 1);
		Underline["Size"] = UDim2.new(0, 15, 0, 1);
		Underline["Position"] = UDim2.new(0, 0, 1, 0);
		Underline["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		Underline["Name"] = [[Underline]];

		Library:DeltaRuntime(function()
			Underline.BackgroundColor3 = Options.Theme[Options.CurrentTheme].BrandColor
			TabIcon.ImageColor3 = Options.Theme[Options.CurrentTheme].BrandColor
			PageIcon.ImageColor3 = Options.Theme[Options.CurrentTheme].BrandColor
		end)

		function Tab:Section(SectionOptions)
			local Section = {}

			ItemIndex += 1
			local CurrentIndex = ItemIndex

			SectionOptions = Library:ValidateOptions({
				Name = "Example Section",
			}, SectionOptions or {})

			local Label = Instance.new("TextLabel", Scroll);
			Label["TextTruncate"] = Enum.TextTruncate.AtEnd;
			Label["BorderSizePixel"] = 0;
			Label["TextXAlignment"] = Enum.TextXAlignment.Left;
			Label["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Label["TextSize"] = 13;
			Label["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
			Label["TextColor3"] = Color3.fromRGB(151, 151, 151);
			Label["BackgroundTransparency"] = 1;
			Label["Size"] = UDim2.new(1, 0, 0, 20);
			Label["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Label["Text"] = SectionOptions.Name;
			Label["Name"] = ItemIndex.." ".. [[Section]];
			Label["RichText"] = true

			local Padding = Instance.new("UIPadding", Label);
			Padding["PaddingRight"] = UDim.new(0, 5);
			Padding["PaddingLeft"] = UDim.new(0, 5);

			Library:DeltaRuntime(function()
				Label.TextColor3 = Options.Theme[Options.CurrentTheme].ShadedTextColor
				PageName.TextColor3 = Options.Theme[Options.CurrentTheme].RegularTextColor
			end)

			function Section:Rename(Name)
				Label.Text = Name
			end

			return Section
		end

		function Tab:Button(ButtonOptions)
			local ButtonTable = {}
			local Hovering = false

			ItemIndex += 1
			local CurrentIndex = ItemIndex

			ButtonOptions = Library:ValidateOptions({
				Name = "Example Button",
				Description = "Example Description",
				CanDebug = true,
				Action = function()
					print("Example Button Clicked")
				end,
			}, ButtonOptions or {})

			local Button = Instance.new("TextButton", Scroll);
			Button["BorderSizePixel"] = 0;
			Button["TextXAlignment"] = Enum.TextXAlignment.Left;
			Button["AutoButtonColor"] = false;
			Button["TextSize"] = 14;
			Button["TextColor3"] = Color3.fromRGB(226, 226, 226);
			Button["TextYAlignment"] = Enum.TextYAlignment.Top;
			Button["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
			Button["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
			Button["Size"] = UDim2.new(1, 0, 0, 35);
			Button["BackgroundTransparency"] = 0.5;
			Button["Name"] = ItemIndex.. " ".. ButtonOptions.Name;
			Button["ClipsDescendants"] = true;
			Button["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Button["Text"] = ButtonOptions.Name;

			local Padding = Instance.new("UIPadding", Button);
			Padding["PaddingTop"] = UDim.new(0, 10);
			Padding["PaddingRight"] = UDim.new(0, 10);
			Padding["PaddingLeft"] = UDim.new(0, 35);

			local Corner = Instance.new("UICorner", Button);
			Corner["CornerRadius"] = UDim.new(0, 5);

			local Stroke = Instance.new("UIStroke", Button);
			Stroke["Transparency"] = 0.5;
			Stroke["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
			Stroke["Color"] = Color3.fromRGB(51, 51, 51);

			local Icon = Instance.new("ImageLabel", Button);
			Icon["ZIndex"] = 3;
			Icon["ImageColor3"] = Color3.fromRGB(201, 201, 201);
			Icon["AnchorPoint"] = Vector2.new(1, 0);
			Icon["Image"] = [[rbxassetid://18113572167]];
			Icon["Size"] = UDim2.new(0, 15, 0, 15);
			Icon["BackgroundTransparency"] = 1;
			Icon["Name"] = [[Icon]];
			Icon["Position"] = UDim2.new(0, -10, 0, 0);

			local Description = Instance.new("TextLabel", Button);
			Description["TextWrapped"] = true;
			Description["ZIndex"] = 4;
			Description["BorderSizePixel"] = 0;
			Description["TextXAlignment"] = Enum.TextXAlignment.Left;
			Description["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Description["TextSize"] = 14;
			Description["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Description["TextColor3"] = Color3.fromRGB(133, 133, 133);
			Description["BackgroundTransparency"] = 1;
			Description["RichText"] = true;
			Description["Size"] = UDim2.new(1, 20, 0, 14);
			Description["Text"] = ButtonOptions.Description;
			Description["AutomaticSize"] = Enum.AutomaticSize.Y;
			Description["Name"] = [[Description]];
			Description["Position"] = UDim2.new(0, -20, 0, 35);

			local DescButton = Library:CircularButton(Options, UDim2.new(0,20,0,20), UDim2.new(0,15,0,15))
			DescButton.AnchorPoint = Vector2.new(1,0)
			DescButton.Position = UDim2.new(1,0,0,-2)
			DescButton.Icon.Image = [[rbxassetid://2717396089]]
			DescButton.Parent = Button

			local DescActive = false
			local ActualSize = Button.Size

			DescButton.Activated:Connect(function()
				if not DescActive then
					DescActive = true
					Library:Tween(Button, TweenInfo.new(.2), {Size = ActualSize + UDim2.new(0,0,0,Description.AbsoluteSize.Y+20)})
				else
					DescActive = false
					Library:Tween(Button, TweenInfo.new(.2), {Size = ActualSize})
				end
			end)

			local LastBackgroundColor = Button.BackgroundColor3
			local LastTextColor = Button.TextColor3
			local LastText = Button.Text

			Button.Activated:Connect(function()
				CircleClick(Button, Mouse.X, Mouse.Y, Options.Theme[Options.CurrentTheme].BrandColor)
				Library:Tween(Stroke, TweenInfo.new(.3), {Thickness = 0})
				task.spawn(function()
					task.wait(.3)
					Library:Tween(Stroke, TweenInfo.new(.3), {Thickness = 1})
				end)
				local Success, Error = pcall(ButtonOptions.Action)

				if Error and ButtonOptions.CanDebug then
					Library:Tween(Button, TweenInfo.new(.3), {TextColor3 = Color3.fromRGB(255, 0, 0)})
					Library:Tween(Icon, TweenInfo.new(.3), {ImageColor3 = Color3.fromRGB(255, 0, 0)})
					Library:Tween(Button, TweenInfo.new(.3), {BackgroundColor3 = Color3.fromRGB(150, 0, 0)})
					Button.Text = "Callback Error!"
					task.spawn(function()
						task.wait(.5)
						Library:Tween(Button, TweenInfo.new(.3), {TextColor3 = LastTextColor})
						Library:Tween(Button, TweenInfo.new(.3), {BackgroundColor3 = LastBackgroundColor})
						Library:Tween(Icon, TweenInfo.new(.3), {ImageColor3 = LastTextColor})
						Button.Text = LastText
						error(Error)
					end)
				end
			end)

			Button.MouseEnter:Connect(function()
				Hovering = true
				Library:Tween(Button, TweenInfo.new(.3), {BackgroundColor3 = Options.Theme[Options.CurrentTheme].TabItemHoverColor})
			end)

			Button.MouseLeave:Connect(function()
				Hovering = false
				Library:Tween(Button, TweenInfo.new(.3), {BackgroundColor3 = Options.Theme[Options.CurrentTheme].TabItemBackgroundColor})
			end)

			UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch or Input.KeyCode == Enum.KeyCode.ButtonR2 then
					if not Hovering then return end
					Library:Tween(Button, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = .2})
				end
			end)

			UserInputService.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch or Input.KeyCode == Enum.KeyCode.ButtonR2 then
					if not Hovering then
						Library:Tween(Button, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = .5})
					else
						Library:Tween(Button, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = .5})
					end
				end
			end)

			Library:DeltaRuntime(function()
				if not Hovering then
					Button.BackgroundColor3 = Options.Theme[Options.CurrentTheme].TabItemBackgroundColor
					Button.TextColor3 = Options.Theme[Options.CurrentTheme].RegularTextColor
					Icon.ImageColor3 = Options.Theme[Options.CurrentTheme].BrandColor
					Stroke.Color = Options.Theme[Options.CurrentTheme].Outline
				end
			end)

			function ButtonTable:Rename(Name)
				Button.Name = CurrentIndex.. " "..Name
				Button.Text = Name
				LastText = Button.Text
			end

			return ButtonTable
		end

		function Tab:Slider(SliderOptions)
			local SliderTable = {}

			local Hovering = false
			local Sliding = false

			ItemIndex += 1

			SliderOptions = Library:ValidateOptions({
				Name = "Slider Example",
				Description = "Description Example",
				Range = {0, 500},
				CurrentValue = 100,
				Increment = 1,
				Action = function(Value)
					print(Value)
				end,
			}, SliderOptions or {})

			local SliderFrame = Instance.new("Frame", Scroll);
			SliderFrame["BorderSizePixel"] = 0;
			SliderFrame["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
			SliderFrame["ClipsDescendants"] = true;
			SliderFrame["Size"] = UDim2.new(1, 0, 0, 50);
			SliderFrame["Name"] = ItemIndex.. " ".. SliderOptions.Name;
			SliderFrame["LayoutOrder"] = 1;
			SliderFrame["BackgroundTransparency"] = 0.5;

			local Title = Instance.new("TextLabel", SliderFrame);
			Title["TextWrapped"] = true;
			Title["ZIndex"] = 4;
			Title["BorderSizePixel"] = 0;
			Title["TextXAlignment"] = Enum.TextXAlignment.Left;
			Title["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Title["TextSize"] = 14;
			Title["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
			Title["TextColor3"] = Color3.fromRGB(226, 226, 226);
			Title["BackgroundTransparency"] = 1;
			Title["Size"] = UDim2.new(1, 0, 0, 14);
			Title["Text"] = SliderOptions.Name;
			Title["Name"] = [[Title]];
			Title["Position"] = UDim2.new(0, 0, 0, 11);

			local Padding = Instance.new("UIPadding", Title);
			Padding["PaddingLeft"] = UDim.new(0, 35);

			local Icon = Instance.new("ImageLabel", Title);
			Icon["ZIndex"] = 3;
			Icon["ImageColor3"] = Color3.fromRGB(201, 201, 201);
			Icon["AnchorPoint"] = Vector2.new(1, 0);
			Icon["Image"] = [[rbxassetid://18114414471]];
			Icon["Size"] = UDim2.new(0, 15, 0, 15);
			Icon["BackgroundTransparency"] = 1;
			Icon["Name"] = [[Icon]];
			Icon["Position"] = UDim2.new(0, -10, 0, 0);

			local Corner = Instance.new("UICorner", SliderFrame);
			Corner["CornerRadius"] = UDim.new(0, 5);

			local Description = Instance.new("TextLabel", SliderFrame);
			Description["TextWrapped"] = true;
			Description["ZIndex"] = 4;
			Description["BorderSizePixel"] = 0;
			Description["TextXAlignment"] = Enum.TextXAlignment.Left;
			Description["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Description["TextSize"] = 14;
			Description["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Description["TextColor3"] = Color3.fromRGB(133, 133, 133);
			Description["BackgroundTransparency"] = 1;
			Description["Size"] = UDim2.new(1, -24, 0, 14);
			Description["Text"] = SliderOptions.Description;
			Description["AutomaticSize"] = Enum.AutomaticSize.Y;
			Description["Name"] = [[Description]];
			Description["Position"] = UDim2.new(0, 12, 0, 50);

			local Padding = Instance.new("UIPadding", SliderFrame);
			Padding["PaddingBottom"] = UDim.new(0, 10);

			local Stroke = Instance.new("UIStroke", SliderFrame);
			Stroke["Transparency"] = 0.5;
			Stroke["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
			Stroke["Color"] = Color3.fromRGB(51, 51, 51);

			local Slider = Instance.new("Frame", SliderFrame);
			Slider["ZIndex"] = 4;
			Slider["BorderSizePixel"] = 0;
			Slider["BackgroundColor3"] = Color3.fromRGB(71, 71, 71);
			Slider["AnchorPoint"] = Vector2.new(0, 0.5);
			Slider["ClipsDescendants"] = true;
			Slider["Size"] = UDim2.new(0.95, 0, 0, 5);
			Slider["Position"] = UDim2.new(0, 15, 0, 35);
			Slider["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Slider["Name"] = [[Slider]];
			Slider["BackgroundTransparency"] = 0.5;

			local Corner = Instance.new("UICorner", Slider);
			Corner["CornerRadius"] = UDim.new(0, 5);

			local Fill = Instance.new("Frame", Slider);
			Fill["ZIndex"] = 5;
			Fill["BorderSizePixel"] = 0;
			Fill["BackgroundColor3"] = Color3.fromRGB(75, 156, 255);
			Fill["Size"] = UDim2.new(0, 20, 1, 0);
			Fill["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Fill["Name"] = [[Fill]];

			local Corner = Instance.new("UICorner", Fill);
			Corner["CornerRadius"] = UDim.new(0, 5);

			local SliderButton = Instance.new("TextButton", Slider);
			SliderButton["BorderSizePixel"] = 0;
			SliderButton["TextTransparency"] = 1;
			SliderButton["TextSize"] = 1;
			SliderButton["TextColor3"] = Color3.fromRGB(0, 0, 0);
			SliderButton["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			SliderButton["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			SliderButton["ZIndex"] = 5;
			SliderButton["Size"] = UDim2.new(1, 0, 1, 0);
			SliderButton["BackgroundTransparency"] = 1;
			SliderButton["Name"] = [[Button]];
			SliderButton["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			SliderButton["Text"] = [[]];

			local Values = Instance.new("Frame", SliderFrame);
			Values["ZIndex"] = 4;
			Values["BorderSizePixel"] = 0;
			Values["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Values["AnchorPoint"] = Vector2.new(1, 0);
			Values["AutomaticSize"] = Enum.AutomaticSize.X;
			Values["Size"] = UDim2.new(0, 0, 0, 25);
			Values["Position"] = UDim2.new(1, -40, 0, 4);
			Values["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Values["Name"] = [[Values]];
			Values["BackgroundTransparency"] = 1;

			local Layout = Instance.new("UIListLayout", Values);
			Layout["HorizontalAlignment"] = Enum.HorizontalAlignment.Right;
			Layout["Padding"] = UDim.new(0, 5);
			Layout["VerticalAlignment"] = Enum.VerticalAlignment.Center;
			Layout["SortOrder"] = Enum.SortOrder.LayoutOrder;
			Layout["FillDirection"] = Enum.FillDirection.Horizontal;

			local SliderValue = Instance.new("TextBox", Values);
			SliderValue["CursorPosition"] = -1;
			SliderValue["TextColor3"] = Color3.fromRGB(181, 181, 181);
			SliderValue["PlaceholderColor3"] = Color3.fromRGB(181, 181, 181);
			SliderValue["ZIndex"] = 4;
			SliderValue["BorderSizePixel"] = 0;
			SliderValue["TextSize"] = 14;
			SliderValue["Name"] = [[SliderValue]];
			SliderValue["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
			SliderValue["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			SliderValue["AutomaticSize"] = Enum.AutomaticSize.X;
			SliderValue["AnchorPoint"] = Vector2.new(1, 0);
			SliderValue["Size"] = UDim2.new(0, 25, 0, 25);
			SliderValue["Position"] = UDim2.new(1, 0, 0, 5);
			SliderValue["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			SliderValue["Text"] = [[100]];
			SliderValue["BackgroundTransparency"] = 1;

			local Padding = Instance.new("UIPadding", SliderValue);
			Padding["PaddingRight"] = UDim.new(0, 10);
			Padding["PaddingLeft"] = UDim.new(0, 10);

			local Corner = Instance.new("UICorner", SliderValue);
			Corner["CornerRadius"] = UDim.new(0, 5);

			local ValueStroke = Instance.new("UIStroke", SliderValue);
			ValueStroke["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
			ValueStroke["Color"] = Color3.fromRGB(46, 46, 46);

			local SliderMax = Instance.new("TextLabel", Values);
			SliderMax["TextWrapped"] = true;
			SliderMax["ZIndex"] = 4;
			SliderMax["BorderSizePixel"] = 0;
			SliderMax["TextXAlignment"] = Enum.TextXAlignment.Left;
			SliderMax["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			SliderMax["TextSize"] = 14;
			SliderMax["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			SliderMax["TextColor3"] = Color3.fromRGB(181, 181, 181);
			SliderMax["BackgroundTransparency"] = 1;
			SliderMax["AnchorPoint"] = Vector2.new(1, 0);
			SliderMax["Size"] = UDim2.new(0, 0, 0, 14);
			SliderMax["Text"] = [[/ 500]];
			SliderMax["AutomaticSize"] = Enum.AutomaticSize.X;
			SliderMax["Name"] = [[SliderMax]];
			SliderMax["Position"] = UDim2.new(1, 0, 0, 11);

			local Padding = Instance.new("UIPadding", SliderMax);
			Padding["PaddingRight"] = UDim.new(0, 10);

			local DescButton = Library:CircularButton(Options, UDim2.new(0,20,0,20), UDim2.new(0,15,0,15))
			DescButton.AnchorPoint = Vector2.new(1,0)
			DescButton.Position = UDim2.new(1,-10,0,7)
			DescButton.Icon.Image = [[rbxassetid://2717396089]]
			DescButton.Parent = SliderFrame

			local DescActive = false
			local ActualSize = SliderFrame.Size

			DescButton.Activated:Connect(function()
				if not DescActive then
					DescActive = true
					Library:Tween(SliderFrame, TweenInfo.new(.2), {Size = ActualSize + UDim2.new(0,0,0,Description.AbsoluteSize.Y+10)})
				else
					DescActive = false
					Library:Tween(SliderFrame, TweenInfo.new(.2), {Size = ActualSize})
				end
			end)

			SliderButton.MouseEnter:Connect(function()
				Hovering = true
			end)

			SliderButton.MouseLeave:Connect(function()
				Hovering = false
			end)

			UserInputService.InputBegan:Connect(function(Input, ProcessedEvent)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch or Enum.KeyCode.ButtonR2 and not (ProcessedEvent) and (Hovering) then
					if Hovering then
						Sliding = true
					end
				end
			end)

			UserInputService.InputEnded:Connect(function(Input, ProcessedEvent)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch or Enum.KeyCode.ButtonR2 and not (ProcessedEvent) and not (Hovering) then
					Sliding = false
				end
			end)

			function SliderTable:Set(NewValue)
				NewValue = tonumber(NewValue)
				if not NewValue then
					NewValue = 100
				end
				if NewValue < SliderOptions.Range[1] then
					NewValue = SliderOptions.Range[1]
				elseif NewValue > SliderOptions.Range[2] then
					NewValue = SliderOptions.Range[2]
				end
				local FillRatio = (NewValue - SliderOptions.Range[1]) / (SliderOptions.Range[2] - SliderOptions.Range[1])
				Library:Tween(Fill, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(FillRatio, 0, 1, 0)})
				SliderValue.Text = NewValue
				local Success, Error = pcall(function()
					SliderOptions.Action(NewValue)
				end)
				if not Success then

				end
				SliderOptions.CurrentValue = NewValue
			end

			SliderTable:Set(SliderOptions.CurrentValue)

			SliderValue.FocusLost:Connect(function()
				SliderTable:Set(SliderValue.Text)
			end)

			Library:DeltaRuntime(function()
				Fill.BackgroundColor3 = Options.Theme[Options.CurrentTheme].BrandColor
				SliderFrame.BackgroundColor3 = Options.Theme[Options.CurrentTheme].TabItemBackgroundColor
				Title.TextColor3 = Options.Theme[Options.CurrentTheme].RegularTextColor
				Icon.ImageColor3 = Options.Theme[Options.CurrentTheme].BrandColor
				Stroke.Color = Options.Theme[Options.CurrentTheme].Outline
				Slider.BackgroundColor3 = Options.Theme[Options.CurrentTheme].SliderFillOutlineColor

				SliderValue.TextColor3 = Options.Theme[Options.CurrentTheme].ShadedTextColor
				SliderMax.TextColor3 = Options.Theme[Options.CurrentTheme].RegularTextColor
				ValueStroke.Color = Options.Theme[Options.CurrentTheme].Outline

				if Sliding then
					local Current = Fill.AbsolutePosition.X + Fill.AbsoluteSize.X
					local Start = Current
					local Location = UserInputService:GetMouseLocation().X
					Current = Current + 0.025 * (Location - Start)

					if Location < Slider.AbsolutePosition.X then
						Location = Slider.AbsolutePosition.X
					elseif Location > Slider.AbsolutePosition.X + Slider.AbsoluteSize.X then
						Location = Slider.AbsolutePosition.X + Slider.AbsoluteSize.X
					end

					if Current < Slider.AbsolutePosition.X + 5 then
						Current = Slider.AbsolutePosition.X + 5
					elseif Current > Slider.AbsolutePosition.X + Slider.AbsoluteSize.X then
						Current = Slider.AbsolutePosition.X + Slider.AbsoluteSize.X
					end

					if Current <= Location and (Location - Start) < 0 then
						Start = Location
					elseif Current >= Location and (Location - Start) > 0 then
						Start = Location
					end

					local NewValue = SliderOptions.Range[1] + (Location - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X * (SliderOptions.Range[2] - SliderOptions.Range[1])

					NewValue = math.floor(NewValue / SliderOptions.Increment + 0.5) * (SliderOptions.Increment * 10000000) / 10000000
					SliderTable:Set(NewValue)
				end
			end)

			return SliderTable
		end

		function Tab:Paragraph(ParagraphOptions)
			local ParagraphTable = {}

			ItemIndex += 1

			ParagraphOptions = Library:ValidateOptions({
				Name = "Paragraph Example",
				Description = "Description Example",
			}, ParagraphOptions or {})

			local ParagraphFrame = Instance.new("Frame", Scroll);
			ParagraphFrame["BorderSizePixel"] = 0;
			ParagraphFrame["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
			ParagraphFrame["ClipsDescendants"] = true;
			ParagraphFrame["AutomaticSize"] = Enum.AutomaticSize.Y;
			ParagraphFrame["Size"] = UDim2.new(1, 0, 0, 35);
			ParagraphFrame["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			ParagraphFrame["Name"] = ItemIndex.. " ".. ParagraphOptions.Name;
			ParagraphFrame["LayoutOrder"] = 1;
			ParagraphFrame["BackgroundTransparency"] = 0.5;

			local Title = Instance.new("TextLabel", ParagraphFrame);
			Title["TextWrapped"] = true;
			Title["ZIndex"] = 4;
			Title["BorderSizePixel"] = 0;
			Title["TextXAlignment"] = Enum.TextXAlignment.Left;
			Title["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Title["TextSize"] = 14;
			Title["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
			Title["TextColor3"] = Color3.fromRGB(226, 226, 226);
			Title["BackgroundTransparency"] = 1;
			Title["Size"] = UDim2.new(1, 0, 0, 14);
			Title["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			Title["Text"] = [[Paragraph]];
			Title["Name"] = [[Title]];
			Title["Position"] = UDim2.new(0, 0, 0, 11);

			local Padding = Instance.new("UIPadding", Title);
			Padding["PaddingLeft"] = UDim.new(0, 35);

			local Icon = Instance.new("ImageLabel", Title);
			Icon["ZIndex"] = 3;
			Icon["ImageColor3"] = Color3.fromRGB(201, 201, 201);
			Icon["AnchorPoint"] = Vector2.new(1, 0);
			Icon["Image"] = [[rbxassetid://18123093533]];
			Icon["Size"] = UDim2.new(0, 15, 0, 15);
			Icon["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			Icon["BackgroundTransparency"] = 1;
			Icon["Name"] = [[Icon]];
			Icon["Position"] = UDim2.new(0, -10, 0, 0);

			local Corner = Instance.new("UICorner", ParagraphFrame);
			Corner["CornerRadius"] = UDim.new(0, 5);

			local Padding = Instance.new("UIPadding", ParagraphFrame);
			Padding["PaddingBottom"] = UDim.new(0, 10);

			local Stroke = Instance.new("UIStroke", ParagraphFrame);
			Stroke["Transparency"] = 0.5;
			Stroke["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
			Stroke["Color"] = Color3.fromRGB(51, 51, 51);

			local Description = Instance.new("TextLabel", ParagraphFrame);
			Description["TextWrapped"] = true;
			Description["ZIndex"] = 4;
			Description["BorderSizePixel"] = 0;
			Description["TextXAlignment"] = Enum.TextXAlignment.Left;
			Description["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Description["TextSize"] = 14;
			Description["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Description["TextColor3"] = Color3.fromRGB(133, 133, 133);
			Description["BackgroundTransparency"] = 1;
			Description["RichText"] = true;
			Description["Size"] = UDim2.new(1, 0, 0, 14);
			Description["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			Description["Text"] = [[This paragraph explains what a error is right?]];
			Description["AutomaticSize"] = Enum.AutomaticSize.Y;
			Description["Name"] = [[Description]];
			Description["Position"] = UDim2.new(0, 0, 0, 35);

			local Padding = Instance.new("UIPadding", Description);
			Padding["PaddingRight"] = UDim.new(0, 10);
			Padding["PaddingLeft"] = UDim.new(0, 10);

			Description.Text = ParagraphOptions.Description
			Title.Text = ParagraphOptions.Name

			Library:DeltaRuntime(function()
				ParagraphFrame.BackgroundColor3 = Options.Theme[Options.CurrentTheme].TabItemBackgroundColor
				Title.TextColor3 = Options.Theme[Options.CurrentTheme].RegularTextColor
				Icon.ImageColor3 = Options.Theme[Options.CurrentTheme].BrandColor
				Stroke.Color = Options.Theme[Options.CurrentTheme].Outline
			end)

			function ParagraphTable:Set(Text)
				Description.Text = Text
			end

			return ParagraphTable
		end

		function Tab:Toggle(ToggleOptions)
			local ToggleTable = {}
			local Hovering = false

			ItemIndex += 1
			local CurrentIndex = ItemIndex

			ToggleOptions = Library:ValidateOptions({
				Name = "Toggle Example",
				Description = "Description Example",
				Toggled = false,
				CanDebug = true,
				Action = function(Value)
					print(Value)
				end,
			}, ToggleOptions or {})

			local Button = Instance.new("TextButton", Scroll);
			Button["BorderSizePixel"] = 0;
			Button["TextXAlignment"] = Enum.TextXAlignment.Left;
			Button["AutoButtonColor"] = false;
			Button["TextSize"] = 14;
			Button["TextColor3"] = Color3.fromRGB(226, 226, 226);
			Button["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
			Button["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
			Button["Size"] = UDim2.new(1, 0, 0, 35);
			Button["BackgroundTransparency"] = 0.5;
			Button["Name"] = ItemIndex.. " ".. ToggleOptions.Name;
			Button["ClipsDescendants"] = true;
			Button["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Button["Text"] = ToggleOptions.Name;
			Button["TextYAlignment"] = Enum.TextYAlignment.Top

			local Stroke = Instance.new("UIStroke", Button);
			Stroke["Transparency"] = 0.5;
			Stroke["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
			Stroke["Color"] = Color3.fromRGB(51, 51, 51);

			local Icon = Instance.new("ImageLabel", Button);
			Icon["ZIndex"] = 3;
			Icon["ImageColor3"] = Color3.fromRGB(201, 201, 201);
			Icon["AnchorPoint"] = Vector2.new(1, 0);
			Icon["Image"] = [[rbxassetid://3944680095]];
			Icon["Size"] = UDim2.new(0, 15, 0, 15);
			Icon["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			Icon["BackgroundTransparency"] = 1;
			Icon["Name"] = [[Icon]];
			Icon["Position"] = UDim2.new(0, -10, 0, 0);

			local Corner = Instance.new("UICorner", Button);
			Corner["CornerRadius"] = UDim.new(0, 5);

			local Box = Instance.new("Frame", Button);
			Box["Interactable"] = false;
			Box["BorderSizePixel"] = 0;
			Box["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
			Box["AnchorPoint"] = Vector2.new(0.5, 0);
			Box["Size"] = UDim2.new(0, 24, 0, 24);
			Box["Position"] = UDim2.new(1, -40, 0, -5);
			Box["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			Box["Name"] = [[Box]];

			local Corner = Instance.new("UICorner", Box);
			Corner["CornerRadius"] = UDim.new(0, 4);

			local BoxStroke = Instance.new("UIStroke", Box);
			BoxStroke["Transparency"] = 0.5;
			BoxStroke["Name"] = [[Stroke]];
			BoxStroke["Color"] = Color3.fromRGB(51, 51, 51);

			local Checkmark = Instance.new("ImageLabel", Box);
			Checkmark["Interactable"] = false;
			Checkmark["ZIndex"] = 3;
			Checkmark["ImageTransparency"] = 1;
			Checkmark["AnchorPoint"] = Vector2.new(0.5, 0.5);
			Checkmark["Image"] = [[rbxassetid://3944680095]];
			Checkmark["Size"] = UDim2.new(0, 8, 0, 8);
			Checkmark["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			Checkmark["BackgroundTransparency"] = 1;
			Checkmark["Name"] = [[Checkmark]];
			Checkmark["Position"] = UDim2.new(0.5, 0, 0.5, 0);

			local BoxFill = Instance.new("Frame", Box);
			BoxFill["ZIndex"] = 2;
			BoxFill["BorderSizePixel"] = 0;
			BoxFill["BackgroundColor3"] = Color3.fromRGB(75, 156, 255);
			BoxFill["AnchorPoint"] = Vector2.new(.5,.5)
			BoxFill["Position"] = UDim2.new(.5,0,.5,0)
			BoxFill["Size"] = UDim2.new(1, 0, 1, 0);
			BoxFill["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			BoxFill["Name"] = [[Fill]];
			BoxFill["BackgroundTransparency"] = 1;

			local Corner = Instance.new("UICorner", BoxFill);
			Corner["CornerRadius"] = UDim.new(0, 4);

			local Padding = Instance.new("UIPadding", Button);
			Padding["PaddingRight"] = UDim.new(0, 10);
			Padding["PaddingLeft"] = UDim.new(0, 35);
			Padding["PaddingTop"] = UDim.new(0, 10)

			local Description = Instance.new("TextLabel", Button);
			Description["TextWrapped"] = true;
			Description["ZIndex"] = 4;
			Description["BorderSizePixel"] = 0;
			Description["TextXAlignment"] = Enum.TextXAlignment.Left;
			Description["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Description["TextSize"] = 14;
			Description["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Description["TextColor3"] = Color3.fromRGB(133, 133, 133);
			Description["BackgroundTransparency"] = 1;
			Description["RichText"] = true;
			Description["Size"] = UDim2.new(1, 20, 0, 14);
			Description["Text"] = [[Example Description]];
			Description["AutomaticSize"] = Enum.AutomaticSize.Y;
			Description["Name"] = [[Description]];
			Description["Position"] = UDim2.new(0, -20, 0, 35);

			local DescButton = Library:CircularButton(Options, UDim2.new(0,20,0,20), UDim2.new(0,15,0,15))
			DescButton.AnchorPoint = Vector2.new(1,0)
			DescButton.Position = UDim2.new(1,0,0,-2)
			DescButton.Icon.Image = [[rbxassetid://2717396089]]
			DescButton.Parent = Button

			Description.Text = ToggleOptions.Description

			local DescActive = false
			local ActualSize = Button.Size

			DescButton.Activated:Connect(function()
				if not DescActive then
					DescActive = true
					Library:Tween(Button, TweenInfo.new(.2), {Size = ActualSize + UDim2.new(0,0,0,Description.AbsoluteSize.Y+20)})
				else
					DescActive = false
					Library:Tween(Button, TweenInfo.new(.2), {Size = ActualSize})
				end
			end)

			local LastBackgroundColor = Button.BackgroundColor3
			local LastTextColor = Button.TextColor3
			local LastText = Button.Text

			if ToggleOptions.Toggled then
				ToggleOptions.Toggled = false
			else
				ToggleOptions.Toggled = true
			end

			local function CheckedToggled()
				if ToggleOptions.Toggled then
					ToggleOptions.Toggled = false
					Library:Tween(BoxFill, TweenInfo.new(.3), {Size = UDim2.new(1,0,0,0)})
					Library:Tween(BoxFill, TweenInfo.new(.2), {BackgroundTransparency = 1})
					Library:Tween(Checkmark, TweenInfo.new(.3), {Size = UDim2.new(0,8,0,8)})
					Library:Tween(Checkmark, TweenInfo.new(.2), {ImageTransparency = 1})
				else
					ToggleOptions.Toggled = true
					Library:Tween(BoxFill, TweenInfo.new(.3), {Size = UDim2.new(1,0,1,0)})
					Library:Tween(BoxFill, TweenInfo.new(.5), {BackgroundTransparency = 0})
					Library:Tween(Checkmark, TweenInfo.new(.3), {Size = UDim2.new(0,15,0,15)})
					Library:Tween(Checkmark, TweenInfo.new(.2), {ImageTransparency = 0})
				end

				local Success, Error = pcall(function()
					ToggleOptions.Action(ToggleOptions.Toggled)
				end)

				if Error and ToggleOptions.CanDebug then
					Library:Tween(Button, TweenInfo.new(.3), {TextColor3 = Color3.fromRGB(255, 0, 0)})
					Library:Tween(Icon, TweenInfo.new(.3), {ImageColor3 = Color3.fromRGB(255, 0, 0)})
					Library:Tween(Button, TweenInfo.new(.3), {BackgroundColor3 = Color3.fromRGB(150, 0, 0)})
					Button.Text = "Callback Error!"
					task.spawn(function()
						task.wait(.5)
						Library:Tween(Button, TweenInfo.new(.3), {TextColor3 = LastTextColor})
						Library:Tween(Button, TweenInfo.new(.3), {BackgroundColor3 = LastBackgroundColor})
						Library:Tween(Icon, TweenInfo.new(.3), {ImageColor3 = LastTextColor})
						Button.Text = LastText
						error(Error)
					end)
				end
			end

			CheckedToggled()

			Button.Activated:Connect(function()
				CircleClick(Button, Mouse.X, Mouse.Y, Options.Theme[Options.CurrentTheme].BrandColor)
				Library:Tween(Stroke, TweenInfo.new(.3), {Thickness = 0})
				task.spawn(function()
					task.wait(.3)
					Library:Tween(Stroke, TweenInfo.new(.3), {Thickness = 1})
				end)
				CheckedToggled()
			end)

			Button.MouseEnter:Connect(function()
				Hovering = true
				Library:Tween(Button, TweenInfo.new(.3), {BackgroundColor3 = Options.Theme[Options.CurrentTheme].TabItemHoverColor})
			end)

			Button.MouseLeave:Connect(function()
				Hovering = false
				Library:Tween(Button, TweenInfo.new(.3), {BackgroundColor3 = Options.Theme[Options.CurrentTheme].TabItemBackgroundColor})
			end)

			UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch or Input.KeyCode == Enum.KeyCode.ButtonR2 then
					if not Hovering then return end
					Library:Tween(Button, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = .2})
				end
			end)

			UserInputService.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch or Input.KeyCode == Enum.KeyCode.ButtonR2 then
					if not Hovering then
						Library:Tween(Button, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = .5})
					else
						Library:Tween(Button, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = .5})
					end
				end
			end)

			Library:DeltaRuntime(function()
				if not Hovering then
					Button.BackgroundColor3 = Options.Theme[Options.CurrentTheme].TabItemBackgroundColor
					Button.TextColor3 = Options.Theme[Options.CurrentTheme].RegularTextColor
					Icon.ImageColor3 = Options.Theme[Options.CurrentTheme].BrandColor
					Stroke.Color = Options.Theme[Options.CurrentTheme].Outline
					BoxStroke.Color = Options.Theme[Options.CurrentTheme].Outline
					Box.BackgroundColor3 = Options.Theme[Options.CurrentTheme].ToggleBoxColor
					BoxFill.BackgroundColor3 = Options.Theme[Options.CurrentTheme].BrandColor
					Checkmark.ImageColor3 = Options.Theme[Options.CurrentTheme].CheckmarkColor
				end
			end)

			function ToggleTable:Rename(Name)
				Button.Name = CurrentIndex.. " ".. Name
				Button.Text = Name
				LastText = Button.Text
			end

			return ToggleTable
		end

		function Tab:Dropdown(DropdownOptions)
			local DropdownTable = {}

			local Opened = false
			local Hovering = false

			local OptionIndex = 0
			
			ItemIndex += 1
			local CurrentIndex = ItemIndex

			local CurrentOption = nil

			DropdownOptions = Library:ValidateOptions({
				Name = "Dropdown Example",
				Options = {
					{"Option 1", "Option 1 selected"},
				},
				Action = function(Value)
					print(Value)
				end,
			}, DropdownOptions or {})

			local Button = Instance.new("TextButton", Scroll);
			Button["BorderSizePixel"] = 0;
			Button["TextXAlignment"] = Enum.TextXAlignment.Left;
			Button["AutoButtonColor"] = false;
			Button["TextSize"] = 14;
			Button["TextColor3"] = Color3.fromRGB(226, 226, 226);
			Button["TextYAlignment"] = Enum.TextYAlignment.Top;
			Button["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
			Button["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
			Button["Size"] = UDim2.new(1, 0, 0, 35);
			Button["BackgroundTransparency"] = 0.5;
			Button["Name"] = ItemIndex.." "..DropdownOptions.Name;
			Button["ClipsDescendants"] = true;
			Button["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Button["Text"] = DropdownOptions.Name.." - None";

			local Padding = Instance.new("UIPadding", Button);
			Padding["PaddingTop"] = UDim.new(0, 10);
			Padding["PaddingRight"] = UDim.new(0, 10);
			Padding["PaddingLeft"] = UDim.new(0, 35);

			local Corner = Instance.new("UICorner", Button);
			Corner["CornerRadius"] = UDim.new(0, 5);

			local Stroke = Instance.new("UIStroke", Button);
			Stroke["Transparency"] = 0.5;
			Stroke["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
			Stroke["Color"] = Color3.fromRGB(51, 51, 51);

			local Icon = Instance.new("ImageLabel", Button);
			Icon["ZIndex"] = 3;
			Icon["ImageColor3"] = Color3.fromRGB(201, 201, 201);
			Icon["AnchorPoint"] = Vector2.new(1, 0);
			Icon["Image"] = [[rbxassetid://18123996184]];
			Icon["Size"] = UDim2.new(0, 15, 0, 15);
			Icon["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			Icon["BackgroundTransparency"] = 1;
			Icon["Name"] = [[Icon]];
			Icon["Position"] = UDim2.new(0, -10, 0, 0);

			local OptionsFrame = Instance.new("Frame", Button);
			OptionsFrame["BorderSizePixel"] = 0;
			OptionsFrame["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			OptionsFrame["ClipsDescendants"] = true;
			OptionsFrame["AutomaticSize"] = Enum.AutomaticSize.Y;
			OptionsFrame["Size"] = UDim2.new(1, -30, 0, 0);
			OptionsFrame["Position"] = UDim2.new(0, 0, 0, 35);
			OptionsFrame["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			OptionsFrame["Name"] = [[Options]];
			OptionsFrame["BackgroundTransparency"] = 1;

			local OptionsLayout = Instance.new("UIListLayout", OptionsFrame);

			local function CreateOption(Name, Function)
				OptionIndex += 1

				local Temp = Instance.new("TextButton", OptionsFrame);
				Temp["BorderSizePixel"] = 0;
				Temp["TextXAlignment"] = Enum.TextXAlignment.Left;
				Temp["TextSize"] = 14;
				Temp["TextColor3"] = Options.Theme[Options.CurrentTheme].ShadedTextColor;
				Temp["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Temp["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
				Temp["Size"] = UDim2.new(1, 0, 0, 25);
				Temp["BackgroundTransparency"] = 1;
				Temp["Name"] = [[Option ]]..OptionIndex;
				Temp["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				Temp["Text"] = Name;

				Temp.Activated:Connect(function()
					Function(Temp)
				end)
			end

			local LastSize = Button.Size

			local function OpenDropdown()
				Opened = true
				Library:Tween(Button, TweenInfo.new(.2), {Size = LastSize + UDim2.new(0,0,0,OptionsFrame.AbsoluteSize.Y + 15)})
				Library:Tween(Icon, TweenInfo.new(.2), {Rotation = 180})
			end

			local function CloseDropdown()
				Opened = false
				Library:Tween(Button, TweenInfo.new(.2), {Size = LastSize})
				Library:Tween(Icon, TweenInfo.new(.2), {Rotation = 0})
			end

			local function SelectOption(Option)
				task.spawn(function()
					CurrentOption = Option
					for _, Value in ipairs(OptionsFrame:GetChildren()) do
						if Value:IsA("TextButton") then
							Value.TextColor3 = Options.Theme[Options.CurrentTheme].ShadedTextColor
						end
					end
					if Option then
						Option.TextColor3 = Options.Theme[Options.CurrentTheme].RegularTextColor
					end
				end)
			end

			Button.Activated:Connect(function()
				CircleClick(Button, Mouse.X, Mouse.Y, Options.Theme[Options.CurrentTheme].BrandColor)
				if not Opened then
					OpenDropdown()
				else
					CloseDropdown()
				end
			end)

			Button.MouseEnter:Connect(function()
				Hovering = true
				Library:Tween(Button, TweenInfo.new(.3), {BackgroundColor3 = Options.Theme[Options.CurrentTheme].TabItemHoverColor})
			end)

			Button.MouseLeave:Connect(function()
				Hovering = false
				Library:Tween(Button, TweenInfo.new(.3), {BackgroundColor3 = Options.Theme[Options.CurrentTheme].TabItemBackgroundColor})
			end)

			UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch or Input.KeyCode == Enum.KeyCode.ButtonR2 then
					if not Hovering then return end
					Library:Tween(Button, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = .2})
				end
			end)

			UserInputService.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch or Input.KeyCode == Enum.KeyCode.ButtonR2 then
					if not Hovering then
						Library:Tween(Button, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = .5})
					else
						Library:Tween(Button, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = .5})
					end
				end
			end)

			Library:DeltaRuntime(function()
				if not Hovering then
					Button.BackgroundColor3 = Options.Theme[Options.CurrentTheme].TabItemBackgroundColor
					Button.TextColor3 = Options.Theme[Options.CurrentTheme].RegularTextColor
					Icon.ImageColor3 = Options.Theme[Options.CurrentTheme].BrandColor
					Stroke.Color = Options.Theme[Options.CurrentTheme].Outline
				end
			end)

			task.spawn(function()
				while task.wait(1) do
					SelectOption(CurrentOption)
				end
			end)

			for _, Option in ipairs(DropdownOptions.Options) do
				CreateOption(Option[1], function(Temp)
					DropdownOptions.Action(Option[2])
					SelectOption(Temp)
					Button.Text = DropdownOptions.Name.." - "..Option[1]
					CloseDropdown()
				end)
			end

			function DropdownTable:Add(Name, Value)
				CreateOption(Name, function(Temp)
					DropdownOptions.Action(Value)
					SelectOption(Temp)
					Button.Text = DropdownOptions.Name.." - "..Name
					CloseDropdown()
				end)
			end

			function DropdownTable:Select(Name)
				local Option = OptionsFrame:FindFirstChild(Name)
				if Option then
					SelectOption(Option)
					Button.Text = DropdownOptions.Name.." - "..Name
					CloseDropdown()
				end
			end

			function DropdownTable:Remove(Name)
				local Option = OptionsFrame:FindFirstChild(Name)
				if Option then
					Option:Destroy()
				end
			end

			return DropdownTable
		end

		function Tab:Textbox(TextboxOptions)
			local TextboxTable = {}

			TextboxOptions = Library:ValidateOptions({
				Name = "Textbox Example",
				Action = function(Value)
					print(Value)
				end,
			}, TextboxOptions or {})
			
			ItemIndex += 1
			local CurrentIndex = ItemIndex
			
			local Focused = false

			local TextboxFrame = Instance.new("Frame", Scroll);
			TextboxFrame["ZIndex"] = 3;
			TextboxFrame["BorderSizePixel"] = 0;
			TextboxFrame["BackgroundColor3"] = Color3.fromRGB(35, 35, 35);
			TextboxFrame["Size"] = UDim2.new(1, 0, 0, 35);
			TextboxFrame["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			TextboxFrame["Name"] = ItemIndex.." "..TextboxOptions.Name;
			TextboxFrame["LayoutOrder"] = 1;
			TextboxFrame["BackgroundTransparency"] = 1;

			local Corner = Instance.new("UICorner", TextboxFrame);
			Corner["CornerRadius"] = UDim.new(0, 5);

			local Padding = Instance.new("UIPadding", TextboxFrame);
			Padding["PaddingBottom"] = UDim.new(0, 10);

			local Title = Instance.new("TextLabel", TextboxFrame);
			Title["TextWrapped"] = true;
			Title["ZIndex"] = 6;
			Title["BorderSizePixel"] = 0;
			Title["TextXAlignment"] = Enum.TextXAlignment.Left;
			Title["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Title["TextSize"] = 14;
			Title["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
			Title["TextColor3"] = Color3.fromRGB(212, 212, 212);
			Title["BackgroundTransparency"] = 1;
			Title["Size"] = UDim2.new(1, -24, 0, 14);
			Title["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			Title["Text"] = TextboxOptions.Name;
			Title["Name"] = [[Title]];
			Title["Position"] = UDim2.new(0, 12, 0, 11);

			local ClipFrame = Instance.new("Frame", TextboxFrame);
			ClipFrame["ZIndex"] = 3;
			ClipFrame["BorderSizePixel"] = 0;
			ClipFrame["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			ClipFrame["ClipsDescendants"] = true;
			ClipFrame["Size"] = UDim2.new(1, 0, 1, 10);
			ClipFrame["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			ClipFrame["Name"] = [[ClipDescendanted]];
			ClipFrame["BackgroundTransparency"] = 1;

			local Button = Instance.new("TextButton", ClipFrame);
			Button["ZIndex"] = 3;
			Button["Size"] = UDim2.new(1, 0, 1, 15);
			Button["BackgroundTransparency"] = 1;
			Button["Name"] = [[Button]];
			Button["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			Button["Text"] = [[]];

			local Corner = Instance.new("UICorner", Button);
			Corner["CornerRadius"] = UDim.new(0, 5);

			local Underline = Instance.new("Frame", TextboxFrame);
			Underline["ZIndex"] = 3;
			Underline["BorderSizePixel"] = 0;
			Underline["BackgroundColor3"] = Color3.fromRGB(46, 46, 46);
			Underline["AnchorPoint"] = Vector2.new(0.5, 1);
			Underline["Size"] = UDim2.new(1, 0, 0, 1);
			Underline["Position"] = UDim2.new(0.5, 0, 1, 10);
			Underline["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			Underline["Name"] = [[Underline]];

			local UnderlineFill = Instance.new("Frame", Underline);
			UnderlineFill["ZIndex"] = 4;
			UnderlineFill["BorderSizePixel"] = 0;
			UnderlineFill["BackgroundColor3"] = Color3.fromRGB(75, 156, 255);
			UnderlineFill["AnchorPoint"] = Vector2.new(0.5, 0.5);
			UnderlineFill["Size"] = UDim2.new(0, 0, 0, 1);
			UnderlineFill["Position"] = UDim2.new(0.5, 0, 0.5, 0);
			UnderlineFill["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			UnderlineFill["Name"] = [[Fill]];

			local TextboxScroll = Instance.new("ScrollingFrame", TextboxFrame);
			TextboxScroll["Active"] = true;
			TextboxScroll["ZIndex"] = 4;
			TextboxScroll["BorderSizePixel"] = 0;
			TextboxScroll["CanvasSize"] = UDim2.new(0, 0, 0, 0);
			TextboxScroll["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			TextboxScroll["Name"] = [[Scroll]];
			TextboxScroll["HorizontalScrollBarInset"] = Enum.ScrollBarInset.Always;
			TextboxScroll["AutomaticCanvasSize"] = Enum.AutomaticSize.X;
			TextboxScroll["Size"] = UDim2.new(1, -40, 0, 14);
			TextboxScroll["Position"] = UDim2.new(0, 12, 0, 11);
			TextboxScroll["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			TextboxScroll["ScrollBarThickness"] = 1;
			TextboxScroll["BackgroundTransparency"] = 1;

			local Input = Instance.new("TextBox", TextboxScroll);
			Input["TextColor3"] = Color3.fromRGB(194, 194, 194);
			Input["PlaceholderColor3"] = Color3.fromRGB(255, 255, 255);
			Input["ZIndex"] = 6;
			Input["BorderSizePixel"] = 0;
			Input["TextXAlignment"] = Enum.TextXAlignment.Left;
			Input["TextSize"] = 14;
			Input["Name"] = [[Input]];
			Input["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Input["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Input["AutomaticSize"] = Enum.AutomaticSize.X;
			Input["ClearTextOnFocus"] = false;
			Input["ClipsDescendants"] = true;
			Input["Size"] = UDim2.new(1, 0, 0, 14);
			Input["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			Input["Text"] = [[]];
			Input["BackgroundTransparency"] = 1;
			
			local LastTextSize = Title.TextSize
			
			Input:GetPropertyChangedSignal("Text"):Connect(function()
				TextboxOptions.Action(Input.Text)
			end)
			
			Input.Focused:Connect(function()
				Focused = true
				Title:TweenPosition(UDim2.new(Title.Position.X.Scale, Title.Position.X.Offset, Title.Position.Y.Scale, -5), "Out", "Linear", .2, true,nil)
				UnderlineFill:TweenSize(UDim2.new(1,0,UnderlineFill.Size.Y.Scale, UnderlineFill.Size.Y.Offset), "Out", "Quad", 1, true,nil)
				Library:Tween(Title, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextSize = LastTextSize - 1})
			end)

			Input.FocusLost:Connect(function()
				Focused = false
				if not (Input.Text == "") then
					return
				else
					Title:TweenPosition(UDim2.new(Title.Position.X.Scale, Title.Position.X.Offset, Title.Position.Y.Scale, 11), "Out", "Linear", .2, true,nil)
					UnderlineFill:TweenSize(UDim2.new(0,0,UnderlineFill.Size.Y.Scale, UnderlineFill.Size.Y.Offset), "Out", "Quad", 1, true,nil)
					Library:Tween(Button, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
					Library:Tween(Title, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextSize = LastTextSize})
				end
			end)
			
			Button.MouseEnter:Connect(function()
				if not Focused then
					Library:Tween(Button, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = .5})
				end
			end)
			Button.MouseLeave:Connect(function()
				if not Focused and (Input.Text == "") then
					Library:Tween(Button, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
				end
			end)
			Button.ZIndex = TextboxFrame.ZIndex + 1
			
			Library:DeltaRuntime(function()
				Button.BackgroundColor3 = Options.Theme[Options.CurrentTheme].TabItemHoverColor
				Button.TextColor3 = Options.Theme[Options.CurrentTheme].RegularTextColor
				UnderlineFill.BackgroundColor3 = Options.Theme[Options.CurrentTheme].BrandColor
				Underline.BackgroundColor3 = Options.Theme[Options.CurrentTheme].Outline
				Title.TextColor3 = Options.Theme[Options.CurrentTheme].RegularTextColor
				Input.TextColor3 = Options.Theme[Options.CurrentTheme].ShadedTextColor
				Input.PlaceholderColor3 = Options.Theme[Options.CurrentTheme].ShadedTextColor
			end)

			return TextboxTable
		end
		
		function Tab:ColorPicker(ColorpickerOptions)
			local ColorpickerTable = {}
			
			local Hovering = false
			local Opened = false
			local Dragging = false
			
			ColorpickerOptions = Library:ValidateOptions({
				Name = "ColorPicker Example",
				Action = function(Value)
					print(Value)
				end,
			}, ColorpickerOptions or {})
			
			ColorpickerTable.Value = nil
			
			local Button = Instance.new("TextButton", Scroll);
			Button["BorderSizePixel"] = 0;
			Button["TextXAlignment"] = Enum.TextXAlignment.Left;
			Button["AutoButtonColor"] = false;
			Button["TextSize"] = 14;
			Button["TextColor3"] = Color3.fromRGB(226, 226, 226);
			Button["TextYAlignment"] = Enum.TextYAlignment.Top;
			Button["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
			Button["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
			Button["Size"] = UDim2.new(1, 0, 0, 35);
			Button["BackgroundTransparency"] = 0.5;
			Button["Name"] = [[Colorpicker]];
			Button["ClipsDescendants"] = true;
			Button["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			Button["Text"] = [[Colorpicker]];

			-- StarterGui.Library.Main.Pages.Page.ScrollingFrame.Colorpicker.UIStroke
			local Stroke = Instance.new("UIStroke", Button);
			Stroke["Transparency"] = 0.5;
			Stroke["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
			Stroke["Color"] = Color3.fromRGB(51, 51, 51);

			-- StarterGui.Library.Main.Pages.Page.ScrollingFrame.Colorpicker.Icon
			local Icon = Instance.new("ImageLabel", Button);
			Icon["ZIndex"] = 3;
			Icon["ImageColor3"] = Color3.fromRGB(201, 201, 201);
			Icon["AnchorPoint"] = Vector2.new(1, 0);
			Icon["Image"] = [[rbxassetid://18124008983]];
			Icon["Size"] = UDim2.new(0, 15, 0, 15);
			Icon["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			Icon["BackgroundTransparency"] = 1;
			Icon["Name"] = [[Icon]];
			Icon["Position"] = UDim2.new(0, -10, 0, 0);

			-- StarterGui.Library.Main.Pages.Page.ScrollingFrame.Colorpicker.UICorner
			local Corner = Instance.new("UICorner", Button);
			Corner["CornerRadius"] = UDim.new(0, 5);

			-- StarterGui.Library.Main.Pages.Page.ScrollingFrame.Colorpicker.Box
			local Box = Instance.new("Frame", Button);
			Box["Interactable"] = false;
			Box["BorderSizePixel"] = 0;
			Box["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Box["AnchorPoint"] = Vector2.new(0.5, 0);
			Box["Size"] = UDim2.new(0, 24, 0, 24);
			Box["Position"] = UDim2.new(1, -10, 0, -5);
			Box["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			Box["Name"] = [[Box]];

			-- StarterGui.Library.Main.Pages.Page.ScrollingFrame.Colorpicker.Box.UICorner
			local Corner = Instance.new("UICorner", Box);
			Corner["CornerRadius"] = UDim.new(0, 4);

			-- StarterGui.Library.Main.Pages.Page.ScrollingFrame.Colorpicker.Box.Stroke
			local BoxStroke = Instance.new("UIStroke", Box);
			BoxStroke["Transparency"] = 0.5;
			BoxStroke["Name"] = [[Stroke]];
			BoxStroke["Color"] = Color3.fromRGB(51, 51, 51);

			-- StarterGui.Library.Main.Pages.Page.ScrollingFrame.Colorpicker.UIPadding
			local Padding = Instance.new("UIPadding", Button);
			Padding["PaddingTop"] = UDim.new(0, 10);
			Padding["PaddingRight"] = UDim.new(0, 10);
			Padding["PaddingLeft"] = UDim.new(0, 35);

			-- StarterGui.Library.Main.Pages.Page.ScrollingFrame.Colorpicker.Picker
			local Picker = Instance.new("Frame", Button);
			Picker["ClipsDescendants"] = true;
			Picker["Size"] = UDim2.new(1, 0, 0, 100);
			Picker["Position"] = UDim2.new(0, -15, 0, 25);
			Picker["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			Picker["Name"] = [[Picker]];
			Picker["BackgroundTransparency"] = 1;

			-- StarterGui.Library.Main.Pages.Page.ScrollingFrame.Colorpicker.Picker.RGB
			local PickerRGB = Instance.new("Frame", Picker);
			PickerRGB["Size"] = UDim2.new(0, 20, 1, 0);
			PickerRGB["Position"] = UDim2.new(1, -20, 0, 0);
			PickerRGB["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			PickerRGB["Name"] = [[RGB]];

			-- StarterGui.Library.Main.Pages.Page.ScrollingFrame.Colorpicker.Picker.RGB.UIGradient
			local PickerGradient = Instance.new("UIGradient", PickerRGB);
			PickerGradient["Rotation"] = 270;
			PickerGradient["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(255, 0, 5)),ColorSequenceKeypoint.new(0.200, Color3.fromRGB(235, 255, 0)),ColorSequenceKeypoint.new(0.400, Color3.fromRGB(22, 255, 0)),ColorSequenceKeypoint.new(0.600, Color3.fromRGB(0, 255, 255)),ColorSequenceKeypoint.new(0.800, Color3.fromRGB(0, 18, 255)),ColorSequenceKeypoint.new(0.900, Color3.fromRGB(255, 0, 252)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(255, 0, 5))};

			-- StarterGui.Library.Main.Pages.Page.ScrollingFrame.Colorpicker.Picker.RGB.UICorner
			local Corner = Instance.new("UICorner", PickerRGB);
			Corner["CornerRadius"] = UDim.new(0, 5);

			-- StarterGui.Library.Main.Pages.Page.ScrollingFrame.Colorpicker.Picker.RGB.Selector
			local RGBSelector = Instance.new("ImageLabel", PickerRGB);
			RGBSelector["ScaleType"] = Enum.ScaleType.Fit;
			RGBSelector["AnchorPoint"] = Vector2.new(0.5, 0.5);
			RGBSelector["Image"] = [[http://www.roblox.com/asset/?id=4805639000]];
			RGBSelector["Size"] = UDim2.new(0, 18, 0, 18);
			RGBSelector["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			RGBSelector["BackgroundTransparency"] = 1;
			RGBSelector["Name"] = [[Selector]];
			RGBSelector["Position"] = UDim2.new(0.5, 0, 0, 0);

			-- StarterGui.Library.Main.Pages.Page.ScrollingFrame.Colorpicker.Picker.Color
			local PickerColor = Instance.new("ImageLabel", Picker);
			PickerColor["BackgroundColor3"] = Color3.fromRGB(255, 0, 0);
			PickerColor["Image"] = [[rbxassetid://4155801252]];
			PickerColor["Size"] = UDim2.new(1, -25, 1, 0);
			PickerColor["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			PickerColor["Name"] = [[Color]];

			-- StarterGui.Library.Main.Pages.Page.ScrollingFrame.Colorpicker.Picker.Color.UICorner
			local Corner = Instance.new("UICorner", PickerColor);
			Corner["CornerRadius"] = UDim.new(0, 5);

			-- StarterGui.Library.Main.Pages.Page.ScrollingFrame.Colorpicker.Picker.Color.Selector
			local ColorSelector = Instance.new("ImageLabel", PickerColor);
			ColorSelector["ScaleType"] = Enum.ScaleType.Fit;
			ColorSelector["AnchorPoint"] = Vector2.new(0.5, 0.5);
			ColorSelector["Image"] = [[http://www.roblox.com/asset/?id=4805639000]];
			ColorSelector["Size"] = UDim2.new(0, 18, 0, 18);
			ColorSelector["BorderColor3"] = Color3.fromRGB(28, 43, 54);
			ColorSelector["BackgroundTransparency"] = 1;
			ColorSelector["Name"] = [[Selector]];

			-- StarterGui.Library.Main.Pages.Page.ScrollingFrame.Colorpicker.Picker.UIPadding
			local Padding = Instance.new("UIPadding", Picker);
			Padding["PaddingTop"] = UDim.new(0, 17);
			Padding["PaddingRight"] = UDim.new(0, 35);
			Padding["PaddingLeft"] = UDim.new(0, 35);
			Padding["PaddingBottom"] = UDim.new(0, 10);
			
			local ColorH = 1 - (math.clamp(RGBSelector.AbsolutePosition.Y - PickerRGB.AbsolutePosition.Y, 0, PickerRGB.AbsoluteSize.Y) / PickerRGB.AbsoluteSize.Y)
			local ColorS = (math.clamp(ColorSelector.AbsolutePosition.X - PickerColor.AbsolutePosition.X, 0, PickerColor.AbsoluteSize.X) / PickerColor.AbsoluteSize.X)
			local ColorV = 1 - (math.clamp(ColorSelector.AbsolutePosition.Y - PickerColor.AbsolutePosition.Y, 0, PickerColor.AbsoluteSize.Y) / PickerColor.AbsoluteSize.Y)
			
			local ColorInput = nil
			local RGBInput = nil
			
			local function UpdateColorPicker()
				Box.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
				PickerColor.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
				ColorpickerTable:Set(Box.BackgroundColor3)
			end
			
			PickerColor.InputBegan:Connect(function(input)
				if not Opened then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					if ColorInput then
						ColorInput:Disconnect()
					end
					ColorInput = RunService.RenderStepped:Connect(function()
						local ColorX = (math.clamp(Mouse.X - PickerColor.AbsolutePosition.X, 0, PickerColor.AbsoluteSize.X) / PickerColor.AbsoluteSize.X)
						local ColorY = (math.clamp(Mouse.Y - PickerColor.AbsolutePosition.Y, 0, PickerColor.AbsoluteSize.Y) / PickerColor.AbsoluteSize.Y)
						ColorSelector.Position = UDim2.new(ColorX, 0, ColorY, 0)
						ColorS = ColorX
						ColorV = 1 - ColorY
						UpdateColorPicker()
					end)
				end
			end)
			
			PickerRGB.InputBegan:Connect(function(input)
				if not Opened then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					if RGBInput then
						RGBInput:Disconnect()
					end;

					RGBInput = RunService.RenderStepped:Connect(function()
						local HueY = (math.clamp(Mouse.Y - PickerRGB.AbsolutePosition.Y, 0, PickerRGB.AbsoluteSize.Y) / PickerRGB.AbsoluteSize.Y)

						RGBSelector.Position = UDim2.new(0.5, 0, HueY, 0)
						ColorH = 1 - HueY

						UpdateColorPicker()
					end)
				end
			end)
			
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					if ColorInput then
						ColorInput:Disconnect()
						ColorInput = nil
					end
					if RGBInput then
						RGBInput:Disconnect()
						RGBInput = nil
					end
				end
			end)
			
			local LastSize = Button.Size
			
			Button.Activated:Connect(function()
				if not ColorInput and not RGBInput then
					CircleClick(Button, Mouse.X, Mouse.Y, Options.Theme[Options.CurrentTheme].BrandColor)
					if not Opened then
						Opened = true
						Library:Tween(Button, TweenInfo.new(.3), {Size = LastSize + UDim2.new(0,0,0,100)})
					else
						Opened = false
						Library:Tween(Button, TweenInfo.new(.3), {Size = LastSize})
					end
				end
			end)
			
			Button.MouseEnter:Connect(function()
				Hovering = true
				Library:Tween(Button, TweenInfo.new(.3), {BackgroundColor3 = Options.Theme[Options.CurrentTheme].TabItemHoverColor})
			end)

			Button.MouseLeave:Connect(function()
				Hovering = false
				Library:Tween(Button, TweenInfo.new(.3), {BackgroundColor3 = Options.Theme[Options.CurrentTheme].TabItemBackgroundColor})
			end)

			UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch or Input.KeyCode == Enum.KeyCode.ButtonR2 then
					if not Hovering then return end
					Library:Tween(Button, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = .2})
				end
			end)

			UserInputService.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch or Input.KeyCode == Enum.KeyCode.ButtonR2 then
					if not Hovering then
						Library:Tween(Button, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = .5})
					else
						Library:Tween(Button, TweenInfo.new(.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {BackgroundTransparency = .5})
					end
				end
			end)
			
			Library:DeltaRuntime(function()
				if not Hovering then
					Button.BackgroundColor3 = Options.Theme[Options.CurrentTheme].TabItemBackgroundColor
					Button.TextColor3 = Options.Theme[Options.CurrentTheme].RegularTextColor
					Icon.ImageColor3 = Options.Theme[Options.CurrentTheme].BrandColor
					Stroke.Color = Options.Theme[Options.CurrentTheme].Outline
					BoxStroke.Color = Options.Theme[Options.CurrentTheme].Outline
				end
			end)
			
			function ColorpickerTable:Set(Value)
				ColorpickerTable.Value = Value
				Box.BackgroundColor3 = ColorpickerTable.Value
				if ColorpickerTable.Value then
					ColorpickerOptions.Action(Box.BackgroundColor3)
				end
			end
			
			return ColorpickerTable
		end

		TabButton.Activated:Connect(function()
			if not Selected then
				Tab:Select()
				CloseNav()
			end
		end)

		function Tab:Select()
			if not Selected then
				if Window.CurrentTab ~= nil then
					Window.CurrentTab:Deselect()
				end
				Selected = true
				Window.CurrentTab = Tab
				TabButton.TextColor3 = Options.Theme[Options.CurrentTheme].RegularTextColor
			end
		end

		function Tab:Deselect()
			if Selected then
				Selected = false
				TabButton.TextColor3 = Options.Theme[Options.CurrentTheme].ShadedTextColor
			end
		end
		
		Library:DeltaRuntime(function()
			if Selected then
				TabButton.TextColor3 = Options.Theme[Options.CurrentTheme].RegularTextColor
			else
				TabButton.TextColor3 = Options.Theme[Options.CurrentTheme].ShadedTextColor
			end
		end)

		if not Window.CurrentTab then
			Tab:Select()
		end

		Library:DeltaRuntime(function()
			if Selected then
				Page.Visible = true
			else
				Page.Visible = false
			end
		end)

		function Tab:Rename(Name)
			TabButton.Text = Name
			TabButton.Name = Name
			Page.Name = Name
			PageName.Text = Name
		end

		return Tab
	end

	return Window
end

return Library
