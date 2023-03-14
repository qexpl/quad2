local Registry = {};
local RegistryMap = {};
local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end);

local ScreenGui = Instance.new("ScreenGui");
ProtectGui(ScreenGui);

ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
ScreenGui.Parent = game.CoreGui;
function GetTextBounds(Text,Font,Size)
    return game:GetService("TextService"):GetTextSize(Text, Size, Font, Vector2.new(1920, 1080)).X
end
function Create(Class, Properties)
    local _Instance = Class;

    if type(Class) == "string" then
        _Instance = Instance.new(Class);
    end;

    for Property, Value in next, Properties do
        _Instance[Property] = Value;
    end;

    return _Instance;
end
function AddToRegistry(Instance, Properties, IsHud)
    local Idx = #Registry + 1;
    local Data = {
        Instance = Instance;
        Properties = Properties;
        Idx = Idx;
    };

    table.insert(Registry, Data);
    RegistryMap[Instance] = Data;
end;
function CreateLabel(Properties, IsHud)
    local _Instance = Create('TextLabel', {
        BackgroundTransparency = 1;
        Font = Enum.Font.Code;
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 16;
        TextStrokeTransparency = 0;
    });

    AddToRegistry(_Instance, {
        TextColor3 = 'FontColor';
    }, IsHud);

    return Create(_Instance, Properties);
end;
local NotificationArea = Create('Frame', {
    BackgroundTransparency = 1;
    Position = UDim2.new(0, 0, 0, 40);
    Size = UDim2.new(0, 300, 0, 200);
    ZIndex = 100;
    Parent = ScreenGui;
});
Create('UIListLayout', {
    Padding = UDim.new(0, 4);
    FillDirection = Enum.FillDirection.Vertical;
    SortOrder = Enum.SortOrder.LayoutOrder;
    Parent = NotificationArea;
})
getgenv().Notify = function(Text, Time)
    local MaxSize = GetTextBounds(Text, Enum.Font.Code, 14);

    local NotifyOuter = Create('Frame', {
        BorderColor3 = Color3.new(0, 0, 0);
        Position = UDim2.new(0, 100, 0, 10);
        Size = UDim2.new(0, 0, 0, 20);
        ClipsDescendants = true;
        ZIndex = 100;
        Parent = NotificationArea;
    });

    local NotifyInner = Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(28, 28, 28);
        BorderColor3 = Color3.fromRGB(50, 50, 50);
        BorderMode = Enum.BorderMode.Inset;
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 101;
        Parent = NotifyOuter;
    });

    AddToRegistry(NotifyInner, {
        BackgroundColor3 = Color3.fromRGB(28, 28, 28);
        BorderColor3 = Color3.fromRGB(50, 50, 50);
    }, true);

    local InnerFrame = Create('Frame', {
        BackgroundColor3 = Color3.new(1, 1, 1);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
        ZIndex = 102;
        Parent = NotifyInner;
    });

    local function inputBegan(input)
        xpcall(function()
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                task.spawn(function()
                    xpcall(function()
                        NotifyOuter:TweenSize(UDim2.new(0, 0, 0, 20), 'Out', 'Quad', 0.4, true)
                        task.wait(0.4)
                        NotifyOuter:Destroy()
                    end,warn)
                end)
            end
        end,warn)
    end
    InnerFrame.InputBegan:Connect(inputBegan)

    Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(27, 27, 27)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(52, 52, 52))
        });
        Rotation = -90;
        Parent = InnerFrame;
    });

    local NotifyLabel = CreateLabel({
        Position = UDim2.new(0, 4, 0, 0);
        Size = UDim2.new(1, -4, 1, 0);
        Text = Text;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextSize = 14;
        ZIndex = 103;
        Parent = InnerFrame;
    });

    local LeftColor = Create('Frame', {
        BackgroundColor3 = Color3.fromRGB(205, 0, 0);
        BorderSizePixel = 0;
        Position = UDim2.new(0, -1, 0, -1);
        Size = UDim2.new(0, 3, 1, 2);
        ZIndex = 104;
        Parent = NotifyOuter;
    });

    AddToRegistry(LeftColor, {
        BackgroundColor3 = Color3.fromRGB(205, 0, 0);
    }, true);

    NotifyOuter:TweenSize(UDim2.new(0, MaxSize + 8 + 4, 0, 20), 'Out', 'Quad', 0.4, true);

    task.spawn(function()
        task.wait(5 or Time);

        NotifyOuter:TweenSize(UDim2.new(0, 0, 0, 20), 'Out', 'Quad', 0.4, true);

        task.wait(0.4);

        NotifyOuter:Destroy();
    end);
end;
--for i = 1,15 do Notify("Test Worked",1) task.wait(0.1) end
