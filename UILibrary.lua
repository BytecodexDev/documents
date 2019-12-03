--[[
	// -- Make Sure to add Credits when using this UI Library! -- \\
					    BytecodexDev Creations 2019
					Created on: December 12, 2019;
	Project Name: Bytecodex's UI Library
	Project Description: Modified Wally's UI Library.
	Project Credits:
		+ Aztup: For the scrolling bar function and Color Picker,
		+ Inori/Ririchi: For dragging,
		+ Wally: For the original concept,
		+ Bytecodex: Modifications.
	Modifications:
		Buttons: Ripple Effects.
]]
-- Main Library
local library = {count = 0, queue = {}, callbacks = {}, rainbowtable = {}, toggled = true, binds = {}, flags = {}, closed = false};
local defaults = {
        topcolor       = Color3.fromRGB(30, 30, 30);
        titlecolor     = Color3.fromRGB(255, 255, 255);
        
        markercolor    = Color3.fromRGB(255, 255, 255);
        underline      = "rainbow";
        bgcolor        = Color3.fromRGB(35, 35, 35);
        boxcolor       = Color3.fromRGB(35, 35, 35);
        btncolor       = Color3.fromRGB(25, 25, 25);
        dropcolor      = Color3.fromRGB(25, 25, 25);
        sectncolor     = Color3.fromRGB(25, 25, 25);
        bordercolor    = Color3.fromRGB(60, 60, 60);

        font           = Enum.Font.SourceSans;
        titlefont      = Enum.Font.Code;

        fontsize       = 17;
        titlesize      = 18;

        textstroke     = 1;
        titlestroke    = 1;

        strokecolor    = Color3.fromRGB(0, 0, 0);

        textcolor      = Color3.fromRGB(255, 255, 255);
        titletextcolor = Color3.fromRGB(255, 255, 255);

        placeholdercolor = Color3.fromRGB(255, 255, 255);
        titlestrokecolor = Color3.fromRGB(0, 0, 0);
}
local Enabled = {};
local Callbacks = {};
local frames = {}
library.options = setmetatable({}, {__index = defaults});
-- Rainbow function
    spawn(function()
        while true do
            for i=0, 1, 1 / 300 do              
                for _, obj in next, library.rainbowtable do
              obj.BackgroundColor3 = Color3.fromHSV(i, 1, 1);
            end
         wait()
       end;
    end
end)    
local function isreallypressed(bind, inp)
        local key = bind
        if typeof(key) == "Instance" then
            if key.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == key.KeyCode then
                return true;
            elseif tostring(key.UserInputType):find('MouseButton') and inp.UserInputType == key.UserInputType then
                return true
            end
        end
        if tostring(key):find'MouseButton1' then
            return key == inp.UserInputType
        else
            return key == inp.KeyCode
        end
    end

    game:GetService("UserInputService").InputBegan:connect(function(input)
        if (not library.binding) then
            for idx, binds in next, library.binds do
                local real_binding = binds.location[idx];
                if real_binding and isreallypressed(real_binding, input) then
                    binds.callback()
                end
            end
        end
    end)
-- Dragging Function:
 local dragger = {}; do
        local mouse        = game:GetService("Players").LocalPlayer:GetMouse();
        local inputService = game:GetService('UserInputService');
        local heartbeat    = game:GetService("RunService").Heartbeat;
        function dragger.new(frame)
            local s, event = pcall(function()
                return frame.MouseEnter
            end)
    
            if s then
                frame.Active = true;
                
                event:connect(function()
                    local input = frame.InputBegan:connect(function(key)
                        if key.UserInputType == Enum.UserInputType.MouseButton1 then
                            local objectPosition = Vector2.new(mouse.X - frame.AbsolutePosition.X, mouse.Y - frame.AbsolutePosition.Y);
                            while heartbeat:wait() and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                pcall(function()
                                    frame:TweenPosition(UDim2.new(0, mouse.X - objectPosition.X + (frame.Size.X.Offset * frame.AnchorPoint.X), 0, mouse.Y - objectPosition.Y + (frame.Size.Y.Offset * frame.AnchorPoint.Y)), 'Out', 'Linear', 0.05, true);
                                end)
                            end
                        end
                    end)
    
                    local leave;
                    leave = frame.MouseLeave:connect(function()
                        input:disconnect();
                        leave:disconnect();
                    end)
                end)
            end
	end
end
local resizer = {}
	function resizer.new(p, s)
		p:GetPropertyChangedSignal('AbsoluteSize'):connect(function()
			s.Size = UDim2.new(s.Size.X.Scale, s.Size.X.Offset, s.Size.Y.Scale, p.AbsoluteSize.Y);
		end)
	end
function library:Create(class, props)
	local object = Instance.new(class);
	
	for i, prop in next, props do
		if i ~= "Parent" then
			object[i] = prop;
		end
	end

	object.Parent = props.Parent;
	return object;
end
-- Main;
function library:CreateWindow(text)
	library.count = library.count + 1
	library.gui = self:Create('ScreenGui', {Name = 'Bytecodex UI Lib', Parent = game.CoreGui})
	library.frame = self:Create("Frame", {
		Name = text;
		Parent = self.gui,
		Visible = false,
		Active = true,
		BackgroundTransparency = 0,
		Size = UDim2.new(0, 178, 0, 30),
		Position = UDim2.new(0, (5 + ((178 * self.windowcount) - 178)), 0, 5),
		BackgroundColor3 = defaults.bgcolor,
		BorderSizePixel = 0
	});
	library.background = self:Create('Frame', {
		Name = 'Background';
		Parent = library.frame,
		BorderSizePixel = 0;
		BackgroundColor3 = library.bgcolor,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 25),
		BackgroundTransparency = 0.4,
		ClipsDescendants = true;
	})

	library.container = self:Create('ScrollingFrame', {
		Name = 'Container';
		Parent = library.frame,
		BorderSizePixel = 0,
		BorderSizePixel = 0,
		BackgroundColor3 = library.bgcolor,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
		TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 25),
		BackgroundTransparency = 0.4,
		ClipsDescendants = true,
		ScrollBarThickness = 10
	})

	library.organizer = self:Create('UIListLayout', {
		Name = 'Sorter';
		SortOrder = Enum.SortOrder.LayoutOrder;
		Parent = library.container;
	})

	library.padder = self:Create('UIPadding', {
		Name = 'Padding';
		PaddingLeft = UDim.new(0, 10);
		PaddingTop = UDim.new(0, 5);
		Parent = library.container;
	})

	local underline = self:Create("Frame", {
		Name = 'Underline';
		Size = UDim2.new(1, 0, 0, 3),
		Position = UDim2.new(0, 0, 1, -1),
		BorderSizePixel = 0;
		BackgroundColor3 = library.underline;
		Parent = library.frame
	})

	local togglebutton = self:Create("TextButton", {
		Name = 'Toggle';
		ZIndex = 2,
		BackgroundTransparency = 1;
		Position = UDim2.new(1, -25, 0, 0),
		Size = UDim2.new(0, 25, 1, 0),
		Text = "+",
		TextSize = 17,
		TextColor3 = library.txtcolor,
		Font = Enum.Font.SourceSans,
		Parent = library.frame,
	});

	togglebutton.MouseButton1Click:connect(function()
		library.closed = not library.closed;
		togglebutton.Text = (library.closed and "+" or "-");
		if library.closed then
			library:Resize(true, UDim2.new(1, 0, 0, 0));
			wait(0.4)
			library.container.Visible = false
		else
			library.container.Visible = true
			library:Resize(true);
		end;
	end);

	self:Create("TextLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		TextColor3 =  Color3.fromRGB(255, 255, 255),
		TextSize = 17,
		Font = Enum.Font.Code,
		Text = text or "window",
		Name = "Window",
		Parent = library.frame,
	})

	local open = {}

	do
		dragger.new(library.frame)
		resizer.new(library.background, library.container);
	end

	local function getSize()
		local ySize = 0;
		for i, object in next, library.container:GetChildren() do
			if (not object:IsA('UIListLayout')) and (not object:IsA('UIPadding')) then
				ySize = ySize + object.AbsoluteSize.Y
			end
		end
		
		if ySize > 400 then
			ySize = 400;
			library.container.CanvasSize = UDim2.new(0, 0, 0, (#library.container:GetChildren() - 1) * 20)
		end;
		
		return UDim2.new(1, 0, 0, ySize + 10)
	end

	function library:Resize(tween, change)
		local size = change or getSize()
		self.container.ClipsDescendants = true;

		if tween then
			self.background:TweenSize(size, "Out", "Sine", 0.5, true)
		else
			self.background.Size = size
		end
	end

	function library:AddSlidingBar(text, minval, maxval, callback)
		self.count = self.count + 1;
		callback = callback or function() end;
		minval = minval or 0;
		maxval = maxval or 100;

		maxval = maxval / 8;
		
		local newContainer = library:Create("Frame", {
			Parent = self.container,
			Size = UDim2.new(1, -10, 0, 20),
			BackgroundColor3 = nil,
			BackgroundTransparency = 1,
		})

		local slidingbar = library:Create("ScrollingFrame", {
			Parent = newContainer,
			Size = UDim2.new(1, -10, 0, 20),
			CanvasSize = UDim2.new(8, 0, 0, 0),
			BackgroundColor3 = nil,
			BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			ScrollBarThickness = 20,
			ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
			ScrollBarImageTransparency = 0.3,
		});

		local label = library:Create("TextLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BackgroundColor3 = nil,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextSize = 16,
			Text = text .. ": " .. minval,
			Font = Enum.Font.SourceSans,
			LayoutOrder = self.Count,
			BorderSizePixel = 0,
			Parent = newContainer,
		})

		slidingbar.Changed:Connect(function(p)
			if p ~= "CanvasPosition" then return end

			local Val = minval - math.floor((slidingbar.CanvasPosition.X / (slidingbar.CanvasSize.X.Offset - slidingbar.AbsoluteWindowSize.X)) * maxval) 
			label.Text = text .. ": " .. tostring(Val);
			callback(Val);
		end)

		self:Resize();

	end;

	
end

function library:AddToggle(text, callback)
		self.count = self.count + 1;

		callback = callback or function() end;

		local label = library:Create("TextLabel", {
			Text =  text,
			Size = UDim2.new(1, -10, 0, 20),
			BackgroundTransparency = 1,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = self.Count,
			TextSize = 16,
			Font = Enum.Font.SourceSans,
			Parent = self.container,
		})

		local button = library:Create("TextButton", {
			Text = "OFF",
			TextColor3 = Color3.fromRGB(255, 25, 25),
			BackgroundTransparency = 1,
			Position = UDim2.new(1, -25, 0, 0),
			Size = UDim2.new(0, 25, 1, 0),
			TextSize = 17,
			Font = Enum.Font.SourceSansSemibold,
			Parent = label,
		})

		Callbacks[text] = function(toggle)
			if not toggle then
				toggle = not self.toggles[text];
			end;

			self.toggles[text] = toggle;
			Enabled[text] = toggle;
			button.TextColor3 = (self.toggles[text] and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(255, 25, 25));
			button.Text = (self.toggles[text] and "ON" or "OFF");

			callback(self.toggles[text]);
        end;

        button.MouseButton1Click:connect(Callbacks[text]);

		self:Resize();
		return button;
end


	function library:AddBox(text, callback)
		self.count = self.count + 1
		callback = callback or function() end

		local box = library:Create("TextBox", {
			PlaceholderText = text,
			Size = UDim2.new(1, -10, 0, 20),
			BackgroundTransparency = 0.75,
			BackgroundColor3 = defaults.boxcolor,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextSize = 16,
			Text = "",
			Font = Enum.Font.SourceSans,
			LayoutOrder = self.Count,
			BorderSizePixel = 0,
			Parent = self.container,
		})

		box.FocusLost:connect(function(...)
			callback(box, ...)
		end)

		self:Resize()
		return box
	end

local Circle = Instance.new('ImageLabel')
Circle.Name = 'Circle'
Circle.Parent = library.container
Circle.BackgroundColor3 = Color3.new(1, 1, 1)
Circle.BackgroundTransparency = 1
Circle.BorderSizePixel = 0
Circle.ZIndex = 10
Circle.Image = "rbxassetid://266543268"
Circle.ImageColor3 = Color3.new(255, 255, 255)
Circle.ImageTransparency = 0.9
function CircleClick(Button, X, Y)
	coroutine.resume(coroutine.create(function()
		
		Button.ClipsDescendants = true
		
		local Circle = library.container.Circle
			Circle.Parent = Button
			local NewX = X - Circle.AbsolutePosition.X
			local NewY = Y - Circle.AbsolutePosition.Y
			Circle.Position = UDim2.new(0, NewX, 0, NewY)
		
		local Size = 0
			if Button.AbsoluteSize.X > Button.AbsoluteSize.Y then
				 Size = Button.AbsoluteSize.X*1.5
			elseif Button.AbsoluteSize.X < Button.AbsoluteSize.Y then
				 Size = Button.AbsoluteSize.Y*1.5
			elseif Button.AbsoluteSize.X == Button.AbsoluteSize.Y then																																																																														print("This place uses a model by Come0n.") --please do not remove!
				Size = Button.AbsoluteSize.X*1.5
			end
		
		local Time = 0.5
			Circle:TweenSizeAndPosition(UDim2.new(0, Size, 0, Size), UDim2.new(0.5, -Size/2, 0.5, -Size/2), "Out", "Quad", Time, false, nil)
			for i=1,10 do
				Circle.ImageTransparency = Circle.ImageTransparency + 0.01
				wait(Time/10)
			end
			Circle:Destroy()
			
	end))
	end
	
		function library:AddButton(text, callback)
		self.count = self.count + 1

		callback = callback or function() end
		
		local button = library:Create("TextButton", {
			Text = text,
			Size = UDim2.new(1, -10, 0, 20),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextSize = 20,
			Font = Enum.Font.SourceSans,
			LayoutOrder = self.Count,
			Parent = self.container,
		})
		local mouse = game.Players.LocalPlayer:GetMouse()
		button.MouseButton1Click:connect(callback)
		self:Resize()
		CircleClick(library:FindFirstChild(text), mouse.X, mouse.Y)
		return button;
		end
		
	function library:AddLabel(text)
		self.count = self.count + 1;
		local tSize = game:GetService('TextService'):GetTextSize(text, 16, Enum.Font.SourceSans, Vector2.new(math.huge, math.huge))

		local button = library:Create("TextLabel", {
			Text =  text,
			Size = UDim2.new(1, -10, 0, tSize.Y + 5),
			TextScaled = false,
			BackgroundTransparency = 1,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = 16,
			Font = Enum.Font.SourceSans,
			LayoutOrder = self.Count,
			Parent = self.container,
		});

		self:Resize();
		return button;
	end;
  function library:Bind(name, options, callback)
            local location     = options.location or library.flags;
            local keyboardOnly = options.kbonly or false
            local flag         = options.flag or name;
            local callback     = callback or function() end;
            local default      = options.default;

            if keyboardOnly and (not tostring(default):find('MouseButton')) then
                location[flag] = default
            end
            
            local banned = {
                Return = true;
                Space = true;
                Tab = true;
                Unknown = true;
            }
            
            local shortNames = {
                RightControl = 'RightCtrl';
                LeftControl = 'LeftCtrl';
                LeftShift = 'LShift';
                RightShift = 'RShift';
                MouseButton1 = "Mouse1";
                MouseButton2 = "Mouse2";
            }
            
            local allowed = {
                MouseButton1 = true;
                MouseButton2 = true;
            }      

            local nm = (default and (shortNames[default.Name] or default.Name) or "None");
            local check = library:Create('Frame', {
                BackgroundTransparency = 1;
                Size = UDim2.new(1, 0, 0, 30);
                LayoutOrder = self:GetOrder();
                library:Create('TextLabel', {
                    Name = name;
                    Text = "\r" .. name;
                    BackgroundTransparency = 1;
                    TextColor3 = library.options.textcolor;
                    Position = UDim2.new(0, 5, 0, 0);
                    Size     = UDim2.new(1, -5, 1, 0);
                    TextXAlignment = Enum.TextXAlignment.Left;
                    Font = library.options.font;
                    TextSize = library.options.fontsize;
                    TextStrokeTransparency = library.options.textstroke;
                    TextStrokeColor3 = library.options.strokecolor;
                    BorderColor3     = library.options.bordercolor;
                    BorderSizePixel  = 1;
                    library:Create('TextButton', {
                        Name = 'Keybind';
                        Text = nm;
                        TextStrokeTransparency = library.options.textstroke;
                        TextStrokeColor3 = library.options.strokecolor;
                        Font = library.options.font;
                        TextSize = library.options.fontsize;
                        Size = UDim2.new(0, 60, 0, 20);
                        Position = UDim2.new(1, -65, 0, 5);
                        TextColor3 = library.options.textcolor;
                        BackgroundColor3 = library.options.bgcolor;
                        BorderColor3     = library.options.bordercolor;
                        BorderSizePixel  = 1;
                    })
                });
                Parent = self.container;
            });
             
            local button = check:FindFirstChild(name).Keybind;
            button.MouseButton1Click:connect(function()
                library.binding = true

                button.Text = "..."
                local a, b = game:GetService('UserInputService').InputBegan:wait();
                local name = tostring(a.KeyCode.Name);
                local typeName = tostring(a.UserInputType.Name);

                if (a.UserInputType ~= Enum.UserInputType.Keyboard and (allowed[a.UserInputType.Name]) and (not keyboardOnly)) or (a.KeyCode and (not banned[a.KeyCode.Name])) then
                    local name = (a.UserInputType ~= Enum.UserInputType.Keyboard and a.UserInputType.Name or a.KeyCode.Name);
                    location[flag] = (a.KeyCode);
                    button.Text = shortNames[name] or name;
                    
                else
                    if (location[flag]) then
                        if (not pcall(function()
                            return location[flag].UserInputType
                        end)) then
                            local name = tostring(location[flag])
                            button.Text = shortNames[name] or name
                        else
                            local name = (location[flag].UserInputType ~= Enum.UserInputType.Keyboard and location[flag].UserInputType.Name or location[flag].KeyCode.Name);
                            button.Text = shortNames[name] or name;
                        end
                    end
                end

                wait(0.1)  
                library.binding = false;
            end)
            
            if location[flag] then
                button.Text = shortNames[tostring(location[flag].Name)] or tostring(location[flag].Name)
            end

            library.binds[flag] = {
                location = location;
                callback = callback;
            };

            self:Resize();
        end
    
        function library:Section(name)
            local order = self:GetOrder();
            local determinedSize = UDim2.new(1, 0, 0, 25)
            local determinedPos = UDim2.new(0, 0, 0, 4);
            local secondarySize = UDim2.new(1, 0, 0, 20);
                        
            if order == 0 then
                determinedSize = UDim2.new(1, 0, 0, 21)
                determinedPos = UDim2.new(0, 0, 0, -1);
                secondarySize = nil
            end
            
            local check = library:Create('Frame', {
                Name = 'Section';
                BackgroundTransparency = 1;
                Size = determinedSize;
                BackgroundColor3 = library.options.sectncolor;
                BorderSizePixel = 0;
                LayoutOrder = order;
                library:Create('TextLabel', {
                    Name = 'section_lbl';
                    Text = name;
                    BackgroundTransparency = 0;
                    BorderSizePixel = 0;
                    BackgroundColor3 = library.options.sectncolor;
                    TextColor3 = library.options.textcolor;
                    Position = determinedPos;
                    Size     = (secondarySize or UDim2.new(1, 0, 1, 0));
                    Font = library.options.font;
                    TextSize = library.options.fontsize;
                    TextStrokeTransparency = library.options.textstroke;
                    TextStrokeColor3 = library.options.strokecolor;
                });
                Parent = self.container;
            });
        
            self:Resize();
        end

        function library:Slider(name, options, callback)
            local default = options.default or options.min;
            local min     = options.min or 0;
            local max      = options.max or 1;
            local location = options.location or library.flags;
            local precise  = options.precise  or false -- e.g 0, 1 vs 0, 0.1, 0.2, ...
            local flag     = options.flag or name;
            local callback = callback or function() end

            location[flag] = default;

            local check = library:Create('Frame', {
                BackgroundTransparency = 1;
                Size = UDim2.new(1, 0, 0, 25);
                LayoutOrder = self:GetOrder();
                library:Create('TextLabel', {
                    Name = name;
                    TextStrokeTransparency = library.options.textstroke;
                    TextStrokeColor3 = library.options.strokecolor;
                    Text = "\r" .. name;
                    BackgroundTransparency = 1;
                    TextColor3 = library.options.textcolor;
                    Position = UDim2.new(0, 5, 0, 2);
                    Size     = UDim2.new(1, -5, 1, 0);
                    TextXAlignment = Enum.TextXAlignment.Left;
                    Font = library.options.font;
                    TextSize = library.options.fontsize;
                    library:Create('Frame', {
                        Name = 'Container';
                        Size = UDim2.new(0, 60, 0, 20);
                        Position = UDim2.new(1, -65, 0, 3);
                        BackgroundTransparency = 1;
                        --BorderColor3 = library.options.bordercolor;
                        BorderSizePixel = 0;
                        library:Create('TextLabel', {
                            Name = 'ValueLabel';
                            Text = default;
                            BackgroundTransparency = 1;
                            TextColor3 = library.options.textcolor;
                            Position = UDim2.new(0, -10, 0, 0);
                            Size     = UDim2.new(0, 1, 1, 0);
                            TextXAlignment = Enum.TextXAlignment.Right;
                            Font = library.options.font;
                            TextSize = library.options.fontsize;
                            TextStrokeTransparency = library.options.textstroke;
                            TextStrokeColor3 = library.options.strokecolor;
                        });
                        library:Create('TextButton', {
                            Name = 'Button';
                            Size = UDim2.new(0, 5, 1, -2);
                            Position = UDim2.new(0, 0, 0, 1);
                            AutoButtonColor = false;
                            Text = "";
                            BackgroundColor3 = Color3.fromRGB(20, 20, 20);
                            BorderSizePixel = 0;
                            ZIndex = 2;
                            TextStrokeTransparency = library.options.textstroke;
                            TextStrokeColor3 = library.options.strokecolor;
                        });
                        library:Create('Frame', {
                            Name = 'Line';
                            BackgroundTransparency = 0;
                            Position = UDim2.new(0, 0, 0.5, 0);
                            Size     = UDim2.new(1, 0, 0, 1);
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                            BorderSizePixel = 0;
                        });
                    })
                });
                Parent = self.container;
            });

            local overlay = check:FindFirstChild(name);

            local renderSteppedConnection;
            local inputBeganConnection;
            local inputEndedConnection;
            local mouseLeaveConnection;
            local mouseDownConnection;
            local mouseUpConnection;

            check:FindFirstChild(name).Container.MouseEnter:connect(function()
                local function update()
                    if renderSteppedConnection then renderSteppedConnection:disconnect() end 
                    

                    renderSteppedConnection = game:GetService('RunService').RenderStepped:connect(function()
                        local mouse = game:GetService("UserInputService"):GetMouseLocation()
                        local percent = (mouse.X - overlay.Container.AbsolutePosition.X) / (overlay.Container.AbsoluteSize.X)
                        percent = math.clamp(percent, 0, 1)
                        percent = tonumber(string.format("%.2f", percent))

                        overlay.Container.Button.Position = UDim2.new(math.clamp(percent, 0, 0.99), 0, 0, 1)
                        
                        local num = min + (max - min) * percent
                        local value = (precise and num or math.floor(num))

                        overlay.Container.ValueLabel.Text = value;
                        callback(tonumber(value))
                        location[flag] = tonumber(value)
                    end)
                end

                local function disconnect()
                    if renderSteppedConnection then renderSteppedConnection:disconnect() end
                    if inputBeganConnection then inputBeganConnection:disconnect() end
                    if inputEndedConnection then inputEndedConnection:disconnect() end
                    if mouseLeaveConnection then mouseLeaveConnection:disconnect() end
                    if mouseUpConnection then mouseUpConnection:disconnect() end
                end

                inputBeganConnection = check:FindFirstChild(name).Container.InputBegan:connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        update()
                    end
                end)

                inputEndedConnection = check:FindFirstChild(name).Container.InputEnded:connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        disconnect()
                    end
                end)

                mouseDownConnection = check:FindFirstChild(name).Container.Button.MouseButton1Down:connect(update)
                mouseUpConnection   = game:GetService("UserInputService").InputEnded:connect(function(a, b)
                    if a.UserInputType == Enum.UserInputType.MouseButton1 and (mouseDownConnection.Connected) then
                        disconnect()
                    end
                end)
            end)    

            if default ~= min then
                local percent = 1 - ((max - default) / (max - min))
                local number  = default 

                number = tonumber(string.format("%.2f", number))
                if (not precise) then
                    number = math.floor(number)
                end

                overlay.Container.Button.Position  = UDim2.new(math.clamp(percent, 0, 0.99), 0,  0, 1) 
                overlay.Container.ValueLabel.Text  = number
            end

            self:Resize();
            return {
                Set = function(self, value)
                    local percent = 1 - ((max - value) / (max - min))
                    local number  = value 

                    number = tonumber(string.format("%.2f", number))
                    if (not precise) then
                        number = math.floor(number)
                    end

                    overlay.Container.Button.Position  = UDim2.new(math.clamp(percent, 0, 0.99), 0,  0, 1) 
                    overlay.Container.ValueLabel.Text  = number
                    location[flag] = number
                    callback(number)
                end
            }
        end 

        function library:SearchBox(text, options, callback)
            local list = options.list or {};
            local flag = options.flag or "";
            local location = options.location or self.flags;
            local callback = callback or function() end;

            local function transformTable(t)
                for i, v in pairs(t) do
                    t[i] = tostring(v);
                end;
                return t;
            end;
            transformTable(list);

            local busy = false;
            local box = library:Create('Frame', {
                BackgroundTransparency = 1;
                Size = UDim2.new(1, 0, 0, 25);
                LayoutOrder = self:GetOrder();
                library:Create('TextBox', {
                    Text = "";
                    PlaceholderText = text;
                    PlaceholderColor3 = Color3.fromRGB(60, 60, 60);
                    Font = library.options.font;
                    TextSize = library.options.fontsize;
                    Name = 'Box';
                    Size = UDim2.new(1, -10, 0, 20);
                    Position = UDim2.new(0, 5, 0, 4);
                    TextColor3 = library.options.textcolor;
                    BackgroundColor3 = library.options.dropcolor;
                    BorderColor3 = library.options.bordercolor;
                    TextStrokeTransparency = library.options.textstroke;
                    TextStrokeColor3 = library.options.strokecolor;
                    library:Create('ScrollingFrame', {
                        Position = UDim2.new(0, 0, 1, 1);
                        Name = 'Container';
                        BackgroundColor3 = library.options.btncolor;
                        ScrollBarThickness = 0;
                        BorderSizePixel = 0;
                        BorderColor3 = library.options.bordercolor;
                        Size = UDim2.new(1, 0, 0, 0);
                        library:Create('UIListLayout', {
                            Name = 'ListLayout';
                            SortOrder = Enum.SortOrder.LayoutOrder;
                        });
                        ZIndex = 2;
                    });
                });
                Parent = self.container;
            })

            local function rebuild(text)
                box:FindFirstChild('Box').Container.ScrollBarThickness = 0
                for i, child in next, box:FindFirstChild('Box').Container:GetChildren() do
                    if (not child:IsA('UIListLayout')) then
                        child:Destroy();
                    end
                end
                
                if #text > 0 then
                    for i, v in next, list do
                        if string.sub(string.lower(v), 1, string.len(text)) == string.lower(text) then
                            local button = library:Create('TextButton', {
                                Text = v;
                                Font = library.options.font;
                                TextSize = library.options.fontsize;
                                TextColor3 = library.options.textcolor;
                                BorderColor3 = library.options.bordercolor;
                                TextStrokeTransparency = library.options.textstroke;
                                TextStrokeColor3 = library.options.strokecolor;
                                Parent = box:FindFirstChild('Box').Container;
                                Size = UDim2.new(1, 0, 0, 20);
                                LayoutOrder = i;
                                BackgroundColor3 = library.options.btncolor;
                                ZIndex = 2;
                            })

                            button.MouseButton1Click:connect(function()
                                busy = true;
                                box:FindFirstChild('Box').Text = button.Text;
                                wait();
                                busy = false;

                                location[flag] = button.Text;
                                callback(location[flag])

                                box:FindFirstChild('Box').Container.ScrollBarThickness = 0
                                for i, child in next, box:FindFirstChild('Box').Container:GetChildren() do
                                    if (not child:IsA('UIListLayout')) then
                                        child:Destroy();
                                    end
                                end
                                box:FindFirstChild('Box').Container:TweenSize(UDim2.new(1, 0, 0, 0), 'Out', 'Quad', 0.25, true)
                            end)
                        end
                    end
                end

                local c = box:FindFirstChild('Box').Container:GetChildren()
                local ry = (20 * (#c)) - 20

                local y = math.clamp((20 * (#c)) - 20, 0, 100)
                if ry > 100 then
                    box:FindFirstChild('Box').Container.ScrollBarThickness = 5;
                end

                box:FindFirstChild('Box').Container:TweenSize(UDim2.new(1, 0, 0, y), 'Out', 'Quad', 0.25, true)
                box:FindFirstChild('Box').Container.CanvasSize = UDim2.new(1, 0, 0, (20 * (#c)) - 20)
            end

            box:FindFirstChild('Box'):GetPropertyChangedSignal('Text'):connect(function()
                if options.refresh then
                    list = transformTable(options.refresh());
                end;
                if (not busy) then
                    rebuild(box:FindFirstChild('Box').Text)
                end
            end);

            local function reload(new_list)
                list = new_list;
                rebuild("")
            end
            self:Resize();
            return reload, box:FindFirstChild('Box');
        end
        
        function library:ColorPicker(name, callback, default)
            local callback = callback or function() end;
            local default_Color = default or Color3.fromRGB(255, 255, 255);

            callback(default_Color);
            local check = library:Create('Frame', {
                BackgroundTransparency = 1;
                Size = UDim2.new(1, 0, 0, 25);
                LayoutOrder = self:GetOrder();
                library:Create('TextLabel', {
                    Name = name;
                    Text = "\r" .. name;
                    BackgroundTransparency = 1;
                    TextColor3 = library.options.textcolor;
                    Position = UDim2.new(0, 5, 0, 0);
                    Size     = UDim2.new(1, -5, 1, 0);
                    TextXAlignment = Enum.TextXAlignment.Left;
                    Font = library.options.font;
                    TextSize = library.options.fontsize;
                    TextStrokeTransparency = library.options.textstroke;
                    TextStrokeColor3 = library.options.strokecolor;
                    library:Create('TextButton', {
                        Text = "";
                        Font = library.options.font;
                        TextSize = library.options.fontsize;
                        Name = 'RGB_Value';
                        Size = UDim2.new(0, 20, 0, 20);
                        Position = UDim2.new(1, -25, 0, 4);
                        TextColor3 = library.options.textcolor;
                        BackgroundColor3 = default_Color;
                        BorderColor3 = library.options.bordercolor;
                        TextStrokeTransparency = library.options.textstroke;
                        TextStrokeColor3 = library.options.strokecolor;
						library:Create("Frame", {
	                        Visible = false;
	                        Name = "ColorPicker";
                            BackgroundColor3 = library.options.bgcolor;
                            BorderSizePixel = 0;
	                        Size = UDim2.new(0, 300, 0, 225);
							Position = UDim2.new(0, 50, 0, 0);
	                        library:Create("UIPadding", {
	                            PaddingBottom = UDim.new(0, 5);
	                            PaddingLeft = UDim.new(0, 5);
	                            PaddingRight = UDim.new(0, 5);
	                            PaddingTop = UDim.new(0, 5);
	                            Name = "Padding";
	                        });
							library:Create("ImageLabel", {
                                Size = UDim2.new(0, 200, 1, 0);
                                Image = "rbxassetid://1433361550";
                                Name = "RGB";
                                BorderSizePixel = 0;
                                library:Create("Frame", {
                                    BorderSizePixel = 2;
                                    Position = UDim2.new();
                                    Size = UDim2.new(0, 5, 0, 5);
                                    Name = "Marker";
                                    BackgroundColor3 = library.options.markercolor;
                                });
                                library:Create("Frame", {
                                    Position = UDim2.new(1, 10, 0, 0);
                                    Size = UDim2.new(0, 80, 0, 75);
                                    Name = "Value";
                                    BorderSizePixel = 0;
                                    BackgroundColor3 = Color3.fromRGB(255, 0, 0);
                                    library:Create("TextLabel", {
                                        Name = "R";
                                        Text = "R: 255";
                                        BorderSizePixel = 0;
                                        TextSize = 15;
                                        BackgroundColor3 = library.options.sectncolor;
                                        TextColor3 = library.options.textcolor;
                                        Size = UDim2.new(0, 80, 0, 25);
                                        Position = UDim2.new(0, 0,1, 10);
                                    });
                                    library:Create("TextLabel", {
                                        Name = "G";
                                        Text = "G: 255";
                                        BorderSizePixel = 0;
                                        TextSize = 15;
                                        BackgroundColor3 = library.options.sectncolor;
                                        TextColor3 = library.options.textcolor;
                                        Size = UDim2.new(0, 80, 0, 25);
                                        Position = UDim2.new(0, 0,1, 40);
                                    });
                                    library:Create("TextLabel", {
                                        Name = "B";
                                        Text = "B: 255";
                                        BorderSizePixel = 0;
                                        TextSize = 15;
                                        BackgroundColor3 = library.options.sectncolor;
                                        TextColor3 = library.options.textcolor;
                                        Size = UDim2.new(0, 80, 0, 25);
                                        Position = UDim2.new(0, 0,1, 70);
                                    });
                                    library:Create("TextButton", {
                                        Name = "SetColor";
                                        Text = "Set Color";
                                        BorderSizePixel = 0;
                                        TextSize = 12;
                                        BackgroundColor3 = library.options.sectncolor;
                                        TextColor3 = library.options.textcolor;
                                        Size = UDim2.new(0, 80, 0, 25);
                                        Position = UDim2.new(0, 0,0, 190);
                                    });
                                });
                            });
	                    });
                    });
                });
                Parent = self.container;
            });

            local RGB_Value = check:FindFirstChild(name).RGB_Value;
            local RGB_Frame = RGB_Value.ColorPicker.RGB;
            local Current_Color = Color3.fromRGB();
            local Mouse = game:GetService("Players").LocalPlayer:GetMouse();
            local Show = false;
            local MouseDown = false;

            local function GetHSV(frame)
                local x,y = Mouse.X - frame.AbsolutePosition.X, Mouse.Y - frame.AbsolutePosition.Y
                local maxX,maxY = frame.AbsoluteSize.X,frame.AbsoluteSize.Y
                if x >= 0 and y >= 0 and x <= maxX and y <= maxY then
                    return x/maxX,y/maxY,1
                end
            end

            Mouse.Button1Down:Connect(function() MouseDown = true end);
            Mouse.Button1Up:Connect(function() MouseDown = false end);

            Mouse.Move:Connect(function()
                if RGB_Value and RGB_Value:FindFirstChild("ColorPicker") then
                    local H, S, V = GetHSV(RGB_Value.ColorPicker.RGB);
                    if H and S and V and MouseDown then
                        local Color = Color3.fromHSV(1 - H, 1 - S, V);
                        RGB_Frame.Marker.Position = UDim2.new(H, 0, S, 0);
                        RGB_Frame.Value.BackgroundColor3 = Color;
                        RGB_Frame.Value.R.Text = "R:" .. tostring(math.floor(Color.R * 255));
                        RGB_Frame.Value.G.Text = "G:" .. tostring(math.floor(Color.G * 255));
                        RGB_Frame.Value.B.Text = "B:" .. tostring(math.floor(Color.B * 255));
                        Current_Color = Color;
                    end;
                end;
            end);

            RGB_Value.MouseButton1Click:Connect(function()
                Show = not Show;
                RGB_Value.ColorPicker.Visible = Show;
            end);
            RGB_Frame.Value.SetColor.MouseButton1Click:Connect(function()
                RGB_Value.BackgroundColor3 = Current_Color;
                callback(Current_Color);
            end);
			self:Resize();
        end;


       function library:AddDropdown(options, callback)
		self.count = self.count + 1
		local default = options[1] or "";

		callback = callback or function() end
		local dropdown = library:Create("TextLabel", {
			Size = UDim2.new(1, -10, 0, 20),
			BackgroundTransparency = 0.75,
			BackgroundColor3 = options.boxcolor,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextSize = 16,
			Text = default,
			Font = Enum.Font.SourceSans,
			BorderSizePixel = 0;
			LayoutOrder = self.Count,
			Parent = self.container,
		})

		local button = library:Create("ImageButton",{
			BackgroundTransparency = 1,
			Image = 'rbxassetid://3234893186',
			Size = UDim2.new(0, 18, 1, 0),
			Position = UDim2.new(1, -20, 0, 0),
			Parent = dropdown,
		})

		local frame;

		local function isInGui(frame)
			local mloc = game:GetService('UserInputService'):GetMouseLocation();
			local mouse = Vector2.new(mloc.X, mloc.Y - 36);

			local x1, x2 = frame.AbsolutePosition.X, frame.AbsolutePosition.X + frame.AbsoluteSize.X;
			local y1, y2 = frame.AbsolutePosition.Y, frame.AbsolutePosition.Y + frame.AbsoluteSize.Y;

			return (mouse.X >= x1 and mouse.X <= x2) and (mouse.Y >= y1 and mouse.Y <= y2);
		end;

		local function count(t)
			local c = 0;
			for i, v in next, t do
				c = c + 1;
			end;
			return c;
		end;

		button.MouseButton1Click:connect(function()
			if count(options) == 0 then
				return;
			end;

			if frame then
				frame:Destroy();
				frame = nil;
			end

			self.container.ClipsDescendants = false;

			frame = library:Create('Frame', {
				Position = UDim2.new(0, 0, 1, 0);
				BackgroundColor3 = Color3.fromRGB(40, 40, 40);
				Size = UDim2.new(0, dropdown.AbsoluteSize.X, 0, (count(options) * 21));
				BorderSizePixel = 0;
				Parent = dropdown;
				ClipsDescendants = true;
				ZIndex = 2;
			})

			library:Create('UIListLayout', {
				Name = 'Layout';
				Parent = frame;
			})

			for i, option in next, options do
				local selection = library:Create('TextButton', {
					Text = option;
					BackgroundColor3 = Color3.fromRGB(40, 40, 40);
					TextColor3 = Color3.fromRGB(255, 255, 255);
					BorderSizePixel = 0;
					TextSize = 16;
					Font = Enum.Font.SourceSans;
					Size = UDim2.new(1, 0, 0, 21);
					Parent = frame;
					ZIndex = 2;
				})

				selection.MouseButton1Click:connect(function()
					dropdown.Text = option;
					callback(option);
					frame.Size = UDim2.new(1, 0, 0, 0);
					game:GetService('Debris'):AddItem(frame, 0.1);
				end);
			end;
		end);

		game:GetService('UserInputService').InputBegan:connect(function(m)
			if m.UserInputType == Enum.UserInputType.MouseButton1 then
				if frame and (not isInGui(frame)) then
					game:GetService('Debris'):AddItem(frame);
				end
			end
		end)

		callback(default);
		self:Resize();
		return {
			Refresh = function(self, array)
				game:GetService('Debris'):AddItem(frame);
				options = array;
				dropdown.Text = options[1];
			end;
		};
	end;

	return library


-- // -- End of Script -- \\ --

	
	
