local LoadStart = tick()
Abysall.SavePath = "Doors/Game"

local Library = Abysall.Interface.Library
local SaveManager = Abysall.Interface.SaveManager
local ThemeManager = Abysall.Interface.ThemeManager

local Toggles = Library.Toggles
local Options = Library.Options

local function CloneReference(Object)
	if Abysall and Abysall.Environment.cloneref then
		return Abysall.Environment.cloneref(Object)
	end
	return Object
end

local Services = setmetatable({}, {
	__index = function(Self, Name)
		return CloneReference(game:GetService(Name))
	end
})

local Globals = {}
local Connections = {}
local ESPConnections = {}
local Groupboxes = {}
local FakePrompts = {}
local Functions = {}
local PartProperties = {}

local Objects = {
	Prompts = {},
	Objectives = {},
	Doors = {},
	HidingSpots = {},
	Entities = {},
	SeekObstructions = {},
	Items = {},
	Chests = {},
	Currency = {},
	Ladders = {},
	Obstructions = {},
	EventTriggers = {},
	JumpscareModules = {},
	SeekHighlights = {},
	EyestalkHighlights = {},
	SeekNodes = {},
	SeekDuckBoards = {},
	SeekBridges = {},
	PathLights = {}
}

Globals.IncompatibleMessage = "Your executor doesn't support this feature."

Functions.CheckCompatability = function(Array)
	for _, Name in Array do
		if not Abysall.Environment[Name] then
			return false
		end
	end
	return true
end

local Entities = {
	["RushMoving"] = {
		Alias = "Rush",
		NotifyMessage = { Title = "Entity 'Rush' has spawned.", Body = "Find a hiding spot." }
	},
	["AmbushMoving"] = {
		Alias = "Ambush",
		NotifyMessage = { Title = "Entity 'Ambush' has spawned.", Body = "Find a hiding spot." }
	},
	["Eyes"] = {
		Alias = "Eyes",
		NotifyMessage = { Title = "Entity 'Eyes' has spawned.", Body = "Avoid looking at it." }
	},
	["Lookman"] = {
		Alias = "Eyes",
		NotifyMessage = { Title = "Entity 'Eyes' has spawned.", Body = "Avoid looking at it." }
	},
	["BackdoorRush"] = {
		Alias = "Blitz",
		NotifyMessage = { Title = "Entity 'Blitz' has spawned.", Body = "Find a hiding spot." }
	},
	["BackdoorLookman"] = {
		Alias = "Lookman",
		NotifyMessage = { Title = "Entity 'Lookman' has spawned.", Body = "Avoid looking at its eyes." }
	},
	["Groundskeeper"] = {
		Alias = "Groundskeeper",
		NotifyMessage = { Title = "Entity 'Groundskeeper' has spawned.", Body = "Avoid stepping on the grass." }
	},
	["A60"] = {
		Alias = "A-60",
		NotifyMessage = { Title = "Entity 'A-60' has spawned.", Body = "Find a hiding spot." }
	},
	["A120"] = {
		Alias = "A-120",
		NotifyMessage = { Title = "Entity 'A-120' has spawned.", Body = "Find a hiding spot." }
	},
	["GloombatSwarm"] = {
		Alias = "Gloombat Swarm",
		NotifyMessage = { Title = "Entity 'Gloombat Swarm' has spawned.", Body = "Keep all light sources turned off." }
	},
	["GlitchRush"] = {
		Alias = "RNIUSHCG==",
		NotifyMessage = { Title = "Entity 'RNIUSHCG==' has spawned.", Body = "Find a hiding spot." }
	},
	["GlitchAmbush"] = {
		Alias = "AR0xMBUSH",
		NotifyMessage = { Title = "Entity 'AR0xMBUSH' has spawned.", Body = "Find a hiding spot." }
	},
	["MonumentEntity"] = {
		Alias = "Monument",
		NotifyMessage = { Title = "Entity 'Monument' has spawned.", Body = "It can't move while you are looking at it." }
	},
	["JeffTheKiller"] = {
		Alias = "Jeff the Killer",
		NotifyMessage = { Title = "Entity 'Jeff the Killer' has spawned.", Body = "Avoid touching him." }
	},
	["CustomEntity"] = {
		Alias = "Custom Entity",
		NotifyMessage = { Title = "Entity 'Custom Entity' has spawned.", Body = "Find a hiding spot." }
	},
	["FrozenAmbush"] = {
		Alias = "Frozen Ambush",
		NotifyMessage = { Title = "Entity 'Frozen Ambush' has spawned.", Body = "Find a hiding spot." }
	},
	["SallyMoving"] = {
		Alias = "Sally",
		NotifyMessage = { Title = "Entity 'Sally' has spawned.", Body = "Drop an item for her." }
	}
}

local EntityIcons = {
	["RushMoving"]      = "rbxassetid://10716032262",
	["AmbushMoving"]    = "rbxassetid://10110576663",
	["A60"]             = "rbxassetid://12571092295",
	["A120"]            = "rbxassetid://12711591665",
	["BackdoorRush"]    = "rbxassetid://16602023490",
	["Eyes"]            = "rbxassetid://10183704772",
	["Lookman"]         = "rbxassetid://10183704772",
	["BackdoorLookman"] = "rbxassetid://16764872677",
	["GloombatSwarm"]   = "rbxassetid://79221203116470",
	["Halt"]            = "rbxassetid://11331795398",
	["JeffTheKiller"]   = "rbxassetid://94479432156278",
	["GlitchRush"]      = "rbxassetid://73859273102919",
	["GlitchAmbush"]    = "rbxassetid://88369678433359",
	["SallyMoving"]     = "rbxassetid://10840888070",
	["MonumentEntity"]  = "rbxassetid://88933556873017",
	["Groundskeeper"]   = "rbxassetid://114991380115557"
}

local ItemNames = {
	["Lighter"]           = "Lighter",
	["Flashlight"]        = "Flashlight",
	["Lockpick"]          = "Lockpicks",
	["Vitamins"]          = "Vitamins",
	["Bandage"]           = "Bandage",
	["StarVial"]          = "Starlight Vial",
	["StarBottle"]        = "Starlight Bottle",
	["StarJug"]           = "Starlight Barrel",
	["Shakelight"]        = "Gummy Flashlight",
	["Straplight"]        = "Straplight",
	["Bulklight"]         = "Spotlight",
	["Battery"]           = "Battery",
	["Candle"]            = "Candle",
	["Crucifix"]          = "Crucifix",
	["CrucifixWall"]      = "Crucifix",
	["Glowsticks"]        = "Glowstick",
	["SkeletonKey"]       = "Skeleton Key",
	["Candy"]             = "Candy",
	["ShieldMini"]        = "Mini Shield Potion",
	["ShieldBig"]         = "Big Shield Potion",
	["BandagePack"]       = "Bandage Pack",
	["BatteryPack"]       = "Battery Pack",
	["RiftCandle"]        = "Moonlight Candle",
	["LaserPointer"]      = "Laser Pointer",
	["HolyGrenade"]       = "Holy Hand Grenade",
	["Shears"]            = "Shears",
	["Smoothie"]          = "Smoothie",
	["Cheese"]            = "Cheese",
	["Bread"]             = "Bread",
	["AlarmClock"]        = "Alarm Clock",
	["RiftSmoothie"]      = "Moonlight Smoothie",
	["GweenSoda"]         = "Gween Soda",
	["GlitchCube"]        = "Glitch Fragment",
	["Scanner"]           = "Tablet",
	["Bomb"]              = "Bomb",
	["Knockbomb"]         = "Knockbomb",
	["Nanner"]            = "Nanner",
	["BigBomb"]           = "Big Bomb",
	["SnakeBox"]          = "Hiding Box",
	["GoldGun"]           = "Golden Gun",
	["StopSign"]          = "Stop Sign",
	["TipJar"]            = "Tip Jar",
	["Lantern"]           = "Lantern",
	["IronKey"]           = "Iron Key",
	["LotusPetal"]        = "Lotus Petal",
	["Compass"]           = "Compass",
	["LotusPetalPickup"]  = "Lotus Petal",
	["LanternLitItem"]    = "Lantern",
	["KeyIron"]           = "Iron Key",
	["IronKeyForCrypt"]   = "Iron Key",
	["LotusHolder"]       = "Lotus Petal",
	["Multitool"]         = "Multitool",
	["RiftJar"]           = "Rift Jar",
	["AloeVera"]          = "Aloe Vera",
	["Donut"]             = "Donut",
	["Lotus"]             = "Lotus",
	["BoxingGloves"]      = "Boxing Gloves"
}

local CutsceneNames = {
    "Figure",
    "FigureEnd",
    "FigureHotelEnd",
    "FigureHotelFire",
    "SeekIntroFools",
    "SeekIntroHotel",
    "SeekIntroMines",
    "SeekIntroMines2",
    "SerewSeekDrain",
    "SewerSeekLower",
    "GrumbleNestEnd",
    "EyestalkIntro",
}

local Character
local Humanoid
local RootPart

local Collision
local CollisionClone
local CollisionPart
local CollisionPartClone

local Camera
local LocalPlayer = Services.Players.LocalPlayer

local RemotesFolder   = Services.ReplicatedStorage:FindFirstChild("RemotesFolder")
local LiveModifiers   = Services.ReplicatedStorage:FindFirstChild("LiveModifiers")
local FloorReplicated = Services.ReplicatedStorage:FindFirstChild("FloorReplicated")
local CurrentRooms    = Services.Workspace:FindFirstChild("CurrentRooms")
local Drops           = Services.Workspace:FindFirstChild("Drops")
local GameData        = Services.ReplicatedStorage:WaitForChild("GameData")
local Floor           = GameData:WaitForChild("Floor").Value
local LatestRoom      = GameData:WaitForChild("LatestRoom")
local FinishedLoadingRoom = GameData:FindFirstChild("FinishedLoadingRoom")
if FinishedLoadingRoom then
	FinishedLoadingRoom:Destroy()
end

local function GetHiddenContainer()
	if Functions.CheckCompatability({"gethui"}) then
		return Abysall.Environment.gethui()
	end
	return Services.CoreGui
end

local NotificationLibrary = {
	LiveNotifications = 0,
	Notifications = 1
}

local Container = Instance.new("ScreenGui")
Container.Name = Abysall.ESPLibrary:GenerateRandomString()
Container.Parent = GetHiddenContainer()
Container.DisplayOrder = 32767
Container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if not Library.Scheme then
	Library.Scheme = setmetatable({}, {
		__index = function(Self, Name)
			return Library[Name]
		end
	})
end

function NotificationLibrary:Notify(TitleText, Desc, Delay)
	task.spawn(function()
		local Notification = Instance.new("Frame")
		local Line = Instance.new("Frame")
		local Warning = Instance.new("ImageLabel")
		local UICorner = Instance.new("UICorner")
		local UICorner2 = Instance.new("UICorner")
		local Title = Instance.new("TextLabel")
		local Description = Instance.new("TextLabel")

		Notification.Name = "Notification"
		Notification.Parent = Container
		Notification.BackgroundColor3 = Library.Scheme.BackgroundColor
		Notification.BackgroundTransparency = 0.4
		Notification.BorderSizePixel = 0
		Notification.Position = UDim2.new(1, 5, 0, 60 + (60 * NotificationLibrary.LiveNotifications))
		Notification.Size = UDim2.new(0, 420, 0, 50)
		Notification:SetAttribute("ID", NotificationLibrary.Notifications)
		Notification:SetAttribute("CurrentPosition", Notification.Position)

		Line.Name = "Line"
		Line.Parent = Notification
		Line.BackgroundColor3 = Library.Scheme.AccentColor
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(0, 0, 1, -3)
		Line.Size = UDim2.new(0, 0, 0, 3)

		Warning.Name = "Warning"
		Warning.Parent = Notification
		Warning.BackgroundTransparency = 1
		Warning.Position = UDim2.new(0, 10, 0, 5)
		Warning.Size = UDim2.new(0, 40, 0, 40)
		Warning.Image = "rbxassetid://3944668821"
		Warning.ImageColor3 = Library.Scheme.AccentColor
		Warning.ScaleType = Enum.ScaleType.Fit

		UICorner.CornerRadius = UDim.new(0, 20)
		UICorner.Parent = Warning

		UICorner2.CornerRadius = UDim.new(0, 4)
		UICorner2.Parent = Notification

		Title.Name = "Title"
		Title.Parent = Notification
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title.BackgroundTransparency = 1
		Title.Position = UDim2.new(0, 60, 0.155, 0)
		Title.Size = UDim2.new(0, 205, 0, 15)
		Title.Text = TitleText or "..."
		Title.TextColor3 = Library.Scheme.FontColor
		Title.TextSize = 10
		Title.TextStrokeTransparency = 0.75
		Title.TextXAlignment = Enum.TextXAlignment.Left

		Description.Name = "Description"
		Description.Parent = Notification
		Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Description.BackgroundTransparency = 1
		Description.Position = UDim2.new(0, 60, 0.483, 0)
		Description.Size = UDim2.new(0, 205, 0, 18)
		Description.Text = Desc or "..."
		Description.TextColor3 = Library.Scheme.FontColor
		Description.TextTransparency = 0.1
		Description.TextSize = 10
		Description.TextStrokeTransparency = 0.75
		Description.TextXAlignment = Enum.TextXAlignment.Left

		NotificationLibrary.LiveNotifications += 1
		NotificationLibrary.Notifications += 1

		Services.TweenService:Create(
			Notification,
			TweenInfo.new(1, Enum.EasingStyle.Exponential),
			{ Position = UDim2.new(1, -370, 0, Notification.Position.Y.Offset) }
		):Play()

		task.wait(0.25)
		if typeof(Delay) == "Instance" then
			Delay.Destroying:Wait()
		else
			Services.TweenService:Create(
				Line,
				TweenInfo.new(Delay - 0.25, Enum.EasingStyle.Linear),
				{ Size = UDim2.new(0, 400, 0, 3) }
			):Play()
			task.wait(Delay - 0.25)
		end

		Notification:SetAttribute("Destroying", true)

		Services.TweenService:Create(
			Notification,
			TweenInfo.new(0.75, Enum.EasingStyle.Exponential, Enum.EasingDirection.In),
			{ Position = UDim2.new(1, 5, 0, Notification.Position.Y.Offset) }
		):Play()

		NotificationLibrary.LiveNotifications -= 1

		local NotifId = Notification:GetAttribute("ID")
		local NotifY = Notification:GetAttribute("CurrentPosition").Y.Offset

		for _, Object in Container:GetChildren() do
			if Object.Name == "Notification"
				and Object:GetAttribute("ID")
				and Object:GetAttribute("ID") > NotifId
				and Object:GetAttribute("Destroying") ~= true
				and Object.Position.Y.Offset ~= 60
			then
				local NewY = Object:GetAttribute("CurrentPosition").Y.Offset - 60
				Object:SetAttribute("CurrentPosition", UDim2.new(1, -450, 0, NewY))
				Services.TweenService:Create(
					Object,
					TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut),
					{ Position = UDim2.new(1, -370, 0, NewY) }
				):Play()
			end
		end

		task.wait(0.75)
		Notification:Destroy()
	end)
end

Globals.DoorsNotify = function(NotifyOptions)
	local function PlaySound(Parent, SoundId, Volume)
		local Sound = Instance.new("Sound")
		Sound.SoundId = SoundId
		Sound.Volume = Volume or 1
		Sound.Parent = Parent
		task.spawn(function()
			task.wait(0.1)
			Sound:Play()
			Sound.Ended:Wait()
			Sound:Destroy()
		end)
	end

	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
	local UIContainer = PlayerGui:FindFirstChild("GlobalUI") or PlayerGui:FindFirstChild("MainUI")
	if not UIContainer then return end

	local AchievementsHolder = UIContainer:FindFirstChild("AchievementsHolder")
	if not AchievementsHolder then return end

	local Achievement = AchievementsHolder.Achievement:Clone()
	Achievement.Size = UDim2.new(0, 0, 0, 0)
	Achievement.Frame.Position = UDim2.new(1.1, 0, 0, 0)
	Achievement.Name = "LiveAchievement"
	Achievement.Visible = true

	Achievement.Frame.TextLabel.Text = NotifyOptions.Style or "NOTIFICATION"
	Achievement.Frame.Details.Title.Text = NotifyOptions.Title or "Sem Título"
	Achievement.Frame.Details.Desc.Text = NotifyOptions.Description or "Sem Descrição"
	Achievement.Frame.Details.Reason.Text = NotifyOptions.Reason or ""
	Achievement.Frame.ImageLabel.Image = (NotifyOptions.Image ~= "" and NotifyOptions.Image) or "rbxassetid://6023426923"

	local Color = NotifyOptions.Color or Color3.new(1, 1, 1)
	Achievement.Frame.TextLabel.TextColor3 = Color
	Achievement.Frame.UIStroke.Color = Color
	Achievement.Frame.Glow.ImageColor3 = Color
	Achievement.Parent = AchievementsHolder

	PlaySound(AchievementsHolder, "rbxassetid://10469938989", 1)

	task.spawn(function()
		Achievement:TweenSize(UDim2.new(1, 0, 0.2, 0), "In", "Quad", 0.8, true)
		task.wait(0.8)
		Achievement.Frame:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.5, true)
		Services.TweenService:Create(
			Achievement.Frame.Glow,
			TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ ImageTransparency = 1 }
		):Play()

		if typeof(NotifyOptions.Time) == "Instance" then
			NotifyOptions.Time.Destroying:Wait()
		else
			task.wait(NotifyOptions.Time or 5)
		end

		Achievement.Frame:TweenPosition(UDim2.new(1.1, 0, 0, 0), "In", "Quad", 0.5, true)
		task.wait(0.5)
		Achievement:TweenSize(UDim2.new(1, 0, -0.1, 0), "InOut", "Quad", 0.5, true)
		task.wait(0.5)
		Achievement:Destroy()
	end)
end

Globals.STX = loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/Components/STX.luau"))()
Functions.Notify = function(Settings)
	local HiddenContainer = GetHiddenContainer()

	if not Settings.Body then
		Settings.Body = "..."
	end

	if not Options.NotifyStyle or Options.NotifyStyle.Value == "Abysall" then
		local Sound = Instance.new("Sound", HiddenContainer)
		Sound.SoundId = "rbxassetid://8784885431"
		Sound.Volume = (Toggles.NotifyPlaySound and Toggles.NotifyPlaySound.Value and Options.NotifySoundVolume.Value) or (Toggles.NotifyPlaySound and 0 or 3)
		Sound.PlayOnRemove = true
		Sound:Destroy()
		NotificationLibrary:Notify(Settings.Title, Settings.Body, Settings.Time or 5)
	elseif Options.NotifyStyle.Value == "Doors" then
		local IsEntity = false
		local EntityName = ""
		for Index, Object in pairs(Entities) do
			if Object.NotifyMessage.Title == Settings.Title or Object.NotifyMessage.Body == Settings.Body then
				IsEntity = true
				EntityName = Index
			end
		end
		Globals.DoorsNotify({
			Title = "Abysall Hub",
			Description = Settings.Title,
			Reason = Settings.Body,
			Style = IsEntity and "WARNING" or "NOTIFICATION",
			Color = IsEntity and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 222, 189),
			Image = Settings.Image,
			Time = Settings.Time
		})
	elseif Options.NotifyStyle.Value == "STX" then
		local Sound = Instance.new("Sound", HiddenContainer)
		Sound.SoundId = "rbxassetid://4590657391"
		Sound.Volume = (Toggles.NotifyPlaySound and Toggles.NotifyPlaySound.Value and Options.NotifySoundVolume.Value) or (Toggles.NotifyPlaySound and 0 or 3)
		Sound.PlayOnRemove = true
		Sound:Destroy()

		if Settings.Image then
			Globals.STX:Notify(
				{Title = "Abysall Hub", Description = Settings.Title .. "\n" .. Settings.Body},
				{OutlineColor = Library.Scheme.AccentColor,Time = Settings.Time or 5, Type = "image"},
				{Image = Settings.Image, ImageColor = Color3.fromRGB(255, 255, 255)}
			)
		else
			Globals.STX:Notify(
				{Title = "Abysall Hub", Description = Settings.Title .. "\n" .. Settings.Body},
				{OutlineColor = Library.Scheme.AccentColor,Time = Settings.Time or 5, Type = "default"}
			)
		end
	else
		local Sound = Instance.new("Sound", HiddenContainer)
		Sound.SoundId = "rbxassetid://4590662766"
		Sound.Volume = (Toggles.NotifyPlaySound and Toggles.NotifyPlaySound.Value and Options.NotifySoundVolume.Value) or (Toggles.NotifyPlaySound and 0 or 3)
		Sound.PlayOnRemove = true
		Sound:Destroy()
		Library:OldNotify({ Title = Settings.Title, Description = Settings.Body, Time = Settings.Time })
	end
end

Functions.Caption = function(Text, PlaySound)
	if typeof(PlaySound) ~= "boolean" then
		PlaySound = true
	end
	local CaptionValue = Instance.new("NumberValue")
	local Caption = Globals.MainUI:WaitForChild("MainFrame"):WaitForChild("Caption"):Clone()
	local CaptionSound = Globals.MainUI:WaitForChild("Initiator"):WaitForChild("Main_Game"):WaitForChild("Reminder"):WaitForChild("Caption")
	local CaptionSoundClone = CaptionSound:Clone()
	CaptionSoundClone.Parent = CaptionSound.Parent
	CaptionSoundClone.Volume = 0.1

	Caption.Destroying:Connect(function()
		CaptionValue:Destroy()
	end)

	for _, Child in Globals.MainUI:GetChildren() do
		if Child.Name == "LiveCaption" then
			Child:Destroy()
		end
	end

	Caption.Parent = Globals.MainUI
	Caption.Visible = true
	Caption.Name = "LiveCaption"
	Caption.Text = Text

	if PlaySound then
		CaptionSoundClone:Play()
	end

	Services.Debris:AddItem(CaptionSoundClone, 5)

	local HolderTween = Services.TweenService:Create(CaptionValue, TweenInfo.new(3), { Value = 100 })
	HolderTween:Play()
	HolderTween.Completed:Connect(function()
		CaptionValue:Destroy()
		Services.TweenService:Create(Caption, TweenInfo.new(4, Enum.EasingStyle.Linear), { TextTransparency = 1 }):Play()
		Services.TweenService:Create(Caption, TweenInfo.new(4, Enum.EasingStyle.Linear), { TextStrokeTransparency = 1 }):Play()
	end)
end

Functions.GetHasteTime = function()
	local TimeRemaining = FloorReplicated.DigitalTimer.Value
	local Minutes = math.floor(TimeRemaining / 60)
	local Seconds = TimeRemaining - (Minutes * 60)
	local MinutesText = Minutes < 10 and ("0" .. tostring(Minutes)) or tostring(Minutes)
	local SecondsText = Seconds < 10 and ("0" .. tostring(Seconds)) or tostring(Seconds)
	return MinutesText .. ":" .. SecondsText
end

Library.OldNotify = Library.Notify
Library.Notify = function(Data, Body, Time)
	Functions.Notify({ Title = Body, Time = Time or 5 })
end

if not LocalPlayer.Character or not CurrentRooms:FindFirstChildOfClass("Model") then
	Functions.Notify({ Title = "Waiting for the game to load..." })
	while not LocalPlayer.Character or not CurrentRooms:FindFirstChildOfClass("Model") do
		task.wait()
	end
	task.wait(4)
end

if not RemotesFolder then
	if Services.ReplicatedStorage:FindFirstChild("EntityInfo") then
		RemotesFolder = Services.ReplicatedStorage:FindFirstChild("EntityInfo")
	elseif Services.ReplicatedStorage:FindFirstChild("Bricks") then
		RemotesFolder = Services.ReplicatedStorage:FindFirstChild("Bricks")
	end
end

if Floor == "Hotel" and RemotesFolder.Name == "Bricks" then
	Floor = "OldHotel"
end

if not LiveModifiers then
	LiveModifiers = Instance.new("Folder")
end

if not FloorReplicated then
	FloorReplicated = Instance.new("Folder")
end

local FakeEvents = {
	Screech = Instance.new("RemoteEvent"),
	Shade   = Instance.new("RemoteEvent"),
	A90     = Instance.new("RemoteEvent"),
	Surge   = Instance.new("RemoteEvent"),
}

FakeEvents.Screech.Name  = "Screech"
FakeEvents.Shade.Name    = "ShadeResult"
FakeEvents.A90.Name      = "A90"
FakeEvents.Surge.Name    = "SurgeRemote"

FakeEvents.Screech_Real = RemotesFolder:WaitForChild("Screech")
FakeEvents.Shade_Real   = RemotesFolder:WaitForChild("ShadeResult")
FakeEvents.A90_Real     = RemotesFolder:FindFirstChild("A90")
FakeEvents.Surge_Real   = RemotesFolder:FindFirstChild("SurgeRemote")

if RemotesFolder:FindFirstChild("FootstepRemoteThatWeNeed") then
    local RealRemote = RemotesFolder:FindFirstChild("FootstepRemoteThatWeNeed")
    RealRemote:Destroy()

    local FakeRemote = Instance.new("RemoteEvent", RemotesFolder)
    FakeRemote.Name = "FootstepRemoteThatWeNeed"
end

Globals.FogInstances = {}
Globals.OldFog = Services.Lighting.FogEnd

for _, Object in Services.Lighting:GetChildren() do
	if Object:IsA("Atmosphere") then
		Object:SetAttribute("Density_Old", Object.Density)

		local AtmoConnection = Object:GetPropertyChangedSignal("Density"):Connect(function()
			if Object.Density ~= 0 then
				Object:SetAttribute("Density_Old", Object.Density)
			end
			if Toggles.RemoveCameraFog.Value then
				Object.Density = 0
			end
		end)

		Object.Destroying:Once(function()
			AtmoConnection:Disconnect()
		end)

		table.insert(Connections, AtmoConnection)
		table.insert(Globals.FogInstances, Object)
	end
end

Globals.SeekNodesFolder = Instance.new("Folder", Services.Workspace)
Globals.SeekNodesFolder.Name = Abysall.ESPLibrary:GenerateRandomString()

Globals.RoomsNodesFolder = Instance.new("Folder", Services.Workspace)
Globals.RoomsNodesFolder.Name = Abysall.ESPLibrary:GenerateRandomString()

Functions.SendChat = function(Message)
	local Folder = Services.ReplicatedStorage:FindFirstChild("DefaultChatSystemEvents") or Instance.new("Folder")
	local Event = Folder:FindFirstChild("SayMessageRequest") or Instance.new("RemoteEvent")
	Event:FireServer(Message, "All")
	local Channel = (Services.TextChatService:FindFirstChild("TextChannels") and Services.TextChatService.TextChannels:FindFirstChild("RBXGeneral")) or Instance.new("TextChannel")
	Channel:SendAsync(Message)
end

Functions.IsCrouching = function()
	if Floor == "Fools" or Floor == "OldHotel" then
		return Character:GetAttribute("Crouching")
	end
	return CollisionPart.CollisionGroup == "PlayerCrouching"
end

Functions.GetInjuriesSpeed = function()
	return 0.075 * (Humanoid.MaxHealth - Humanoid.Health)
end

Functions.GetCurrentSpeed = function()
	local Speed = 15
	Speed += Character:GetAttribute("SpeedBoost") or 0
	Speed += Character:GetAttribute("SpeedBoostBehind") or 0
	Speed += Character:GetAttribute("SpeedBoostExtra") or 0
	Speed += (Floor == "Party" and 10 or 0)
	Speed += (LiveModifiers:FindFirstChild("PlayerFast") and 3 or 0)
	Speed += (LiveModifiers:FindFirstChild("PlayerFaster") and 6 or 0)
	Speed += (LiveModifiers:FindFirstChild("PlayerFastest") and 20 or 0)
	Speed -= (LiveModifiers:FindFirstChild("PlayerSlow") and 3 or 0)
	Speed -= (LiveModifiers:FindFirstChild("PlayerSlowHealth") and Functions.GetInjuriesSpeed() or 0)
	if Functions.IsCrouching() then
		if LiveModifiers:FindFirstChild("PlayerCrouchSlow") then
			Speed -= 8
		elseif LiveModifiers:FindFirstChild("PlayerSlow") then
			Speed -= 8
		else
			Speed -= 5
		end
	end
	return Speed
end

Functions.GetMousePosition = function()
	if Library.IsMobile then
		return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	end
	local MouseLocation = Services.UserInputService:GetMouseLocation()
	return Vector2.new(MouseLocation.X, MouseLocation.Y)
end

Functions.FormatOxygen = function(Oxygen)
	return "Oxygen: " .. (math.floor(Oxygen * 10) / 10) .. "%"
end

Functions.IsHidePersistent = function()
	return Floor == "Mines"
		or Floor == "Ripple"
		or Floor == "Party"
		or LiveModifiers:FindFirstChild("HideLevel2") ~= nil
end

Functions.GetPlayerFromMouse = function(TargetPart, MaxDistance)
	local Closest
	local ClosestDistance = math.huge

	for _, Player in Services.Players:GetPlayers() do
		local Char = Player.Character
		if Char then
			local Target = Char:FindFirstChild(TargetPart)
			if Target then
				local Result = Camera:WorldToViewportPoint(Target.Position)
				local ScreenPos = Vector2.new(Result.X, Result.Y)
				local Distance = (Functions.GetMousePosition() - ScreenPos).Magnitude
				if Player.Name ~= LocalPlayer.Name and Distance < ClosestDistance and Distance < MaxDistance then
					Closest = Target
					ClosestDistance = Distance
				end
			end
		end
	end
	return Closest
end

local EntityDistances = {
	["RushMoving"]    = 85,
	["AmbushMoving"]  = 150,
	["A60"]           = 125,
	["A120"]          = 85,
	["GlitchRush"]    = 90,
	["GlitchAmbush"]  = 175,
	["BackdoorRush"]  = 85,
	["CustomEntity"]  = 85,
}

Functions.GetNearestEntity = function(CheckDisabled, List, UseRaycasting)
	local Nearest = { Distance = math.huge, Object = nil }

	for _, Entity in Services.Workspace:GetChildren() do
		if Entity and EntityDistances[Entity.Name] and Entity.PrimaryPart then
			local EntityData = Entities[Entity.Name]
			if not (List and List[EntityData.Alias]) then
				local Distance = LocalPlayer:DistanceFromCharacter(Entity.PrimaryPart.Position)
				if Distance < EntityDistances[Entity.Name] and Distance < Nearest.Distance then
					if not CheckDisabled or Entity:GetAttribute("Inactive") ~= true then
						Nearest.Distance = Distance
						Nearest.Object = Entity
					end
				end
			end
		end
	end
	return Nearest.Object
end

Functions.GetNearestFigure = function()
	local Nearest = { Distance = math.huge, Object = nil }
	local FigureNames = { FigureRig = true, FigureRagdoll = true, Figure = true }

	for _, Object in Objects.Entities do
		if Object:IsA("Model") and Object.PrimaryPart and FigureNames[Object.Name] then
			local Distance = LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)
			if Distance < Nearest.Distance and Distance < 25 then
				Nearest.Distance = Distance
				Nearest.Object = Object
			end
		end
	end
	return Nearest.Object
end

Functions.GetNearestHidingSpot = function()
	local Nearest = { Distance = math.huge, Object = nil }
	local LastHideSpot = Character:FindFirstChild("LastHideSpot")

	for _, Object in Objects.HidingSpots do
		if Object.PrimaryPart and Object:FindFirstChild("HidePrompt") then
			local Distance = LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)
			if Distance < Object.HidePrompt.MaxActivationDistance and Distance < Nearest.Distance then
				local Persistent = Functions.IsHidePersistent()
				if not Persistent or (LastHideSpot and LastHideSpot.Value ~= Object) or not LastHideSpot then
					Nearest.Distance = Distance
					Nearest.Object = Object
				end
			end
		end
	end
	return Nearest.Object
end

Functions.GetNearestTurnNode = function()
	local Nearest = { Distance = math.huge, Object = nil }

	for _, Node in Objects.SeekNodes do
		local Distance = LocalPlayer:DistanceFromCharacter(Node.Position)
		if Distance < Options.AutoSteerMinecartTurnDistance.Value and Distance < Nearest.Distance then
			Nearest.Distance = Distance
			Nearest.Object = Node
		end
	end
	return Nearest.Object
end

Functions.GetNearestDuckBoard = function()
	local Nearest = { Distance = math.huge, Object = nil }

	for _, Board in Objects.SeekDuckBoards do
		if Board.PrimaryPart then
			local Distance = LocalPlayer:DistanceFromCharacter(Board.PrimaryPart.Position)
			if Distance < Options.AutoSteerMinecartDuckDistance.Value and Distance < Nearest.Distance then
				Nearest.Distance = Distance
				Nearest.Object = Board
			end
		end
	end
	return Nearest.Object
end

Functions.GetCurrentAnchor = function()
	local AnchorCode = Globals.MainUI.AnchorHintFrame.AnchorCode.Text
	for _, Anchor in Objects.Objectives do
		if Anchor.Name == "MinesAnchor" and Anchor:FindFirstChild("Sign") then
			if Anchor.Sign.TextLabel.Text == AnchorCode then
				return Anchor
			end
		end
	end
end

Functions.GetMinecart = function()
	return Camera:FindFirstChild("MinecartRig") ~= nil
end

Functions.HasItem = function(Name, OnlyCharacter)
	if not OnlyCharacter and LocalPlayer.Backpack:FindFirstChild(Name) then
		return LocalPlayer.Backpack:FindFirstChild(Name)
	elseif Character:FindFirstChild(Name) then
		return Character:FindFirstChild(Name)
	end
end

Functions.GetFlyVelocity = function()
	if Humanoid.MoveDirection == Vector3.zero then
		return Humanoid.MoveDirection
	end
	local LookFlat = Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z)
	local FlatFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + LookFlat)
	local Velocity = (Camera.CFrame * CFrame.new(FlatFrame:VectorToObjectSpace(Humanoid.MoveDirection))).Position - Camera.CFrame.Position
	if Velocity == Vector3.zero then
		return Velocity
	end
	return Velocity.Unit
end

Globals.PromptContainer = Instance.new("Folder")
Globals.PromptContainer.Name = "PromptContainer"
Globals.PromptContainer.Parent = GetHiddenContainer()

local ESPBlacklist = {}

Functions.AddESP = function(ESPOptions, RoomBased)
	local Object = ESPOptions.Object

	if table.find(ESPBlacklist, Object) then
		return
	end

	if RoomBased then
		local CurrentRoom = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
		local ObjectRoom = tonumber(Object:GetAttribute("ParentRoom"))

		if ObjectRoom == CurrentRoom or (table.find(Objects.Doors, Object) and ObjectRoom == CurrentRoom + 1) then
			Abysall.ESPLibrary:AddESP(ESPOptions)
		end

		local RoomConnection = LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
			if Abysall.ESPLibrary.ColorTable[Object] then
				ESPOptions.Color = Abysall.ESPLibrary.ColorTable[Object]
			end

			local NewCurrentRoom = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
			local ObjRoom = tonumber(Object:GetAttribute("ParentRoom"))

			if ObjRoom == NewCurrentRoom or (table.find(Objects.Doors, Object) and ObjRoom == NewCurrentRoom + 1) then
				Abysall.ESPLibrary:AddESP(ESPOptions)
			else
				Abysall.ESPLibrary:RemoveESP(Object)
			end
		end)

		table.insert(Connections, RoomConnection)
		ESPConnections[Object] = RoomConnection

		Object.Destroying:Once(function()
			RoomConnection:Disconnect()
			if Abysall then
				Abysall.ESPLibrary:RemoveESP(Object)
			end
			local Pos = table.find(Connections, RoomConnection)
			if Pos then table.remove(Connections, Pos) end
		end)
	else
		Abysall.ESPLibrary:AddESP(ESPOptions)
	end
end

Functions.RemoveESP = function(Object)
	local Conn = ESPConnections[Object]
	if Conn then
		Conn:Disconnect()
		ESPConnections[Object] = nil
		local Pos = table.find(Connections, Conn)
		if Pos then table.remove(Connections, Pos) end
	end
	Abysall.ESPLibrary:RemoveESP(Object)
end

Functions.BlacklistESP = function(Object)
	table.insert(ESPBlacklist, Object)
end

Functions.GetDoorNumber = function(Object)
	local DoorNumber = tonumber(Object.Parent.Name) or tonumber(Object.Parent.Parent.Name)
	if DoorNumber then
		DoorNumber = DoorNumber + 1
	end
	if Floor == "Mines" then
		DoorNumber = DoorNumber + 100
	end
	if Floor == "Backdoor" then
		DoorNumber = DoorNumber - 50
	end

	return tostring(DoorNumber)
end

Functions.GetLibraryCode = function()
	local Paper = Character:FindFirstChild("LibraryHintPaper")
		or Character:FindFirstChild("LibraryHintPaperHard")
		or LocalPlayer.Backpack:FindFirstChild("LibraryHintPaper")
		or LocalPlayer.Backpack:FindFirstChild("LibraryHintPaperHard")

	if Paper and Paper:FindFirstChild("UI") then
		local Code = {}
		local CodeLength = Floor == "Fools" and 10 or 5
		for I = 1, CodeLength do Code[I] = "_" end

		local HintChildren = LocalPlayer.PlayerGui.PermUI.Hints:GetChildren()
		local UIChildren = Paper.UI:GetChildren()

		for _, Hint in HintChildren do
			for _, UIChild in UIChildren do
				if Hint:IsA("ImageLabel") and UIChild:IsA("ImageLabel")
					and Hint.ImageRectOffset == UIChild.ImageRectOffset
					and Code[tonumber(UIChild.Name)]
				then
					Code[tonumber(UIChild.Name)] = Hint.TextLabel.Text
				end
			end
		end
		return table.concat(Code)
	end
	return Floor == "Fools" and "__________" or "_____"
end

Globals.UsedRandomCodes = {}
Functions.GetRandomCode = function()
    local CodeTemplate = Functions.GetLibraryCode()
    if not CodeTemplate then
        return nil
    end

    local NewCode
    local Tries = 0
    repeat
        NewCode = CodeTemplate:gsub("_", function()
            return tostring(math.random(0, 9))
        end)
        Tries = Tries + 1
    until not Globals.UsedRandomCodes[NewCode] or Tries >= 10

    Globals.UsedRandomCodes[NewCode] = true
    return NewCode
end

local Window = Library:CreateWindow({
	Title = "Abysall Hub",
	Footer = "dsc.gg/abysallhub",
	NotifySide = "Right",
	ShowCustomCursor = false,
	AutoShow = true,
	Center = true,
	TabPadding = 3,
	MenuFadeTime = 0,
	CornerRadius = 2,
})

Abysall.Interface.ApplyInfoTab(Window)

local Tabs = {
	General  = Window:AddTab("General", "house"),
	Exploits = Window:AddTab("Exploits", "shield"),
	Visuals  = Window:AddTab("Visuals", "eye"),
	Floors   = Window:AddTab("Floors", "earth"),
}

-- Tplay's Addon is integrated directly into the Abysall window.
local TplayTab = Window:AddTab("Tplay's Addon", "wrench")

Groupboxes.General_Character = Tabs.General:AddLeftGroupbox("Character")
Groupboxes.General_Character:AddSlider("SpeedBoostSlider", {
	Text = "Speed Boost", Min = 0, Max = 100, Default = 0, Rounding = 0, Compact = true
})
Groupboxes.General_Character:AddToggle("SpeedBoostToggle", {
	Text = "Enable Speed Boost", Default = false, Tooltip = "Increases your walkspeed by the specified amount."
})
Groupboxes.General_Character:AddToggle("FlyToggle", {
	Text = "Fly", Default = false, Tooltip = "Allows you to freely fly around the map."
})
Toggles.FlyToggle:AddKeyPicker("FlyKeybind", {
	Text = "Fly", Default = "F", Mode = "Toggle", SyncToggleState = true
})
Groupboxes.General_Character:AddSlider("FlySpeed", {
	Text = "Fly Speed", Min = 0, Max = 115, Default = 20, Rounding = 0, Compact = true
})
Groupboxes.General_Character:AddDivider()
Groupboxes.General_Character:AddToggle("NoclipToggle", {
	Text = "Noclip", Default = false, Tooltip = "Allows your character to pass through solid objects."
})
Groupboxes.General_Character:AddToggle("RemoveClosetDelay", {
	Text = "Remove Closet Delay", Default = false,
	Tooltip = "Removes the short window where you can't exit out of a closet after the animation finishes."
})
Groupboxes.General_Character:AddToggle("RemoveAcceleration", {
	Text = "Remove Acceleration", Default = false, Tooltip = "Prevents your character from sliding while moving."
})

local CustomPhysics

Options.SpeedBoostSlider:OnChanged(function(Value)
	if RemotesFolder:FindFirstChild("Crouch") then
		RemotesFolder.Crouch:FireServer(Value and true or Functions.IsCrouching(), true)
	end
end)

Toggles.NoclipToggle:AddKeyPicker("NoclipKeybind", {
	Text = "Noclip", Default = "N", Mode = "Toggle", SyncToggleState = true
})
Toggles.RemoveAcceleration:OnChanged(function(Value)
	for Index, Old in PartProperties do
		Index.CustomPhysicalProperties = Value and CustomPhysics or Old
	end
end)

Groupboxes.General_Character:AddDivider()
Groupboxes.General_Character:AddToggle("EnableCharacterJump", {
	Text = "Enable Jumping", Default = false, Tooltip = "Allows your character to jump."
})
Groupboxes.General_Character:AddToggle("EnableCharacterSlide", {
	Text = "Enable Sliding", Default = false, Tooltip = "Allows your character to slide."
})
Groupboxes.General_Character:AddToggle("InfiniteJumps", {
	Text = "Infinite Jumps", Default = false, Tooltip = "Allows you to jump while in the air."
})

local OldJump = false
local OldSlide = false

Toggles.SpeedBoostToggle:OnChanged(function(Value)
	if Humanoid then
		Humanoid.WalkSpeed = Functions.GetCurrentSpeed() + (Value and Options.SpeedBoostSlider.Value or 0)
	end
end)
Toggles.EnableCharacterJump:OnChanged(function(Value)
	if Character then
		Character:SetAttribute("CanJump", Value and true or OldJump)
	end
end)
Toggles.EnableCharacterSlide:OnChanged(function(Value)
	if Character then
		Character:SetAttribute("CanSlide", Value and true or OldSlide)
	end
end)

Groupboxes.General_Self = Tabs.General:AddLeftGroupbox("Self")
Groupboxes.General_Self:AddToggle("DoorReachToggle", {
	Text = "Door Reach", Default = false, Tooltip = "Allows you to open doors from further away."
})
Groupboxes.General_Self:AddToggle("DisableIdleKick", {
	Text = "Disable Idle Kick", Default = false, Tooltip = "Prevents the kick from being idle for 20 minutes."
})
Toggles.DisableIdleKick:OnChanged(function(Value)
	if Functions.CheckCompatability({"getconnections"}) then
		for _, Conn in Abysall.Environment.getconnections(LocalPlayer.Idled) do
			if Value then Conn:Disable() else Conn:Enable() end
		end
	end
end)
LocalPlayer.Idled:Connect(function()
	if Toggles.DisableIdleKick.Value then
		Services.VirtualUser:CaptureController()
		Services.VirtualUser:ClickButton2(Vector2.new())
	end
end)

Groupboxes.General_Self:AddDivider()
Groupboxes.General_Self:AddSlider("PromptReachSlider", {
	Text = "Prompt Reach Multiplier", Min = 1, Max = 2, Default = 1, Rounding = 1, Compact = true
})
Groupboxes.General_Self:AddToggle("InstantPrompts", {
	Text = "Instant Prompts", Default = false, Tooltip = "Allows you to trigger all prompts instantly."
})
Groupboxes.General_Self:AddToggle("PromptClip", {
	Text = "Prompt Clip", Default = false, Tooltip = "Allows you to interact with prompts through walls."
})

Options.PromptReachSlider:OnChanged(function(Value)
	for _, Prompt in Objects.Prompts do
		Prompt.MaxActivationDistance = Prompt:GetAttribute("MaxActivationDistance_Old") * Value
	end
end)
Toggles.InstantPrompts:OnChanged(function(Value)
	for _, Prompt in Objects.Prompts do
		Prompt.HoldDuration = Value and 0 or Prompt:GetAttribute("HoldDuration_Old")
	end
end)
Toggles.PromptClip:OnChanged(function(Value)
	for _, Prompt in Objects.Prompts do
		Prompt.RequiresLineOfSight = Value and false or Prompt:GetAttribute("RequiresLineOfSight_Old")
	end
end)

Groupboxes.Self_Automation = Tabs.General:AddRightGroupbox("Automation")
Groupboxes.Self_Automation:AddToggle("AutoBreakerBox", {
	Text = "Auto Breaker Box", Default = false, Tooltip = "Automatically solves the breaker box."
})
Groupboxes.Self_Automation:AddToggle("AutoSolveAnchors", {
	Text = "Auto Solve Anchors", Default = false,
	Tooltip = "Automatically enters the correct code into anchors when you are near them."
})
Toggles.AutoBreakerBox:OnChanged(function(Value)
	if Value and CurrentRooms:FindFirstChild("ElevatorBreaker", true) then
		if not Globals.BreakerBoxInteracted then
			if not Globals.BreakerBoxNotified then
				Functions.Notify({ Title = "Interact with the breaker box.", Body = "It will be automatically solved." })
				Globals.BreakerBoxInteracted = true
			end
		else
			RemotesFolder.EBF:FireServer()
		end
	end
end)

Groupboxes.Self_Automation:AddToggle("AutoHeartbeatMinigame", { Text = "Auto Heartbeat Minigame", Default = false, Tooltip = "Prevents the 'Figure' minigame from ever failing.", Disabled = not Functions.CheckCompatability({"hookmetamethod", "newcclosure", "getnamecallmethod"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Self_Automation:AddDivider()
Groupboxes.Self_Automation:AddToggle("AutoUnlockPadlockToggle", {
	Text = "Auto Unlock Padlock", Default = false, Tooltip = "Automatically enters the code into the library padlock."
})
Groupboxes.Self_Automation:AddSlider("AutoUnlockPadlockSlider", {
	Text = "Unlock Distance", Min = 1, Max = 50, Default = 10, Rounding = 0, Compact = true
})
Groupboxes.Self_Automation:AddToggle("AutoLibraryGuessCode", {
	Text = "Guess Library Code", Default = false,
	Tooltip = "Attempts to guess the library code, but collecting some books is also necessary."
})
Groupboxes.Self_Automation:AddDivider()
Groupboxes.Self_Automation:AddToggle("AutoInteractToggle", {
	Text = "Auto Interact", Default = false, Tooltip = "Automatically triggers nearby prompts."
})
Toggles.AutoInteractToggle:AddKeyPicker("AutoInteractKeybind", {
	Text = "Auto Interact", Default = "R",
	Mode = Library.IsMobile and "Toggle" or "Hold", SyncToggleState = true
})
Groupboxes.Self_Automation:AddDropdown("AutoInteractIgnoreList", {
	Text = "Ignore List",
	Values = { "Glitch Fragments", "Jeff Items", "Dropped Items", "Currency", "Minecarts", "Locks" },
	Default = { "Glitch Fragments", "Jeff Items", "Dropped Items" },
	Multi = true, AllowNull = true
})
Groupboxes.Self_Automation:AddDivider()
Groupboxes.Self_Automation:AddToggle("AutoClosetToggle", {
	Text = "Auto Closet", Default = false,
	Tooltip = "Automatically hides in a nearby closet when an entity is near."
})
Toggles.AutoClosetToggle:AddKeyPicker("AutoClosetKeybind", {
	Text = "Auto Closet", Default = "Q", Mode = "Toggle", SyncToggleState = true
})
Groupboxes.Self_Automation:AddDropdown("AutoClosetEntityList", {
	Text = "Ignore List",
	Values = { "Rush", "Ambush", "Blitz", "A-60", "A-120", "AR0xMBUSH", "RNIUSHCG==" },
	Multi = true, AllowNull = true
})
Groupboxes.Self_Automation:AddToggle("SpectateEntityToggle", {
	Text = "Spectate Entity",
	Default = false,
	Tooltip = "Spectates the entity while auto hiding."
})
Groupboxes.Self_Automation:AddDropdown("SpecateEntityMode", {
	Values = {"Player to Entity", "Entity to Player"},
	Default = 1,
	AllowNull = true
})

Groupboxes.Self_Misc = Tabs.General:AddRightGroupbox("Miscellaneous")
Groupboxes.Self_Misc:AddButton({
	Text = "Play Again", Tooltip = "Makes you join a new run, click again to cancel.", DoubleClick = true,
	Func = function() RemotesFolder.PlayAgain:FireServer() end
})
Groupboxes.Self_Misc:AddButton({
	Text = "Return to Lobby", Tooltip = "Makes you teleport back to the lobby.", DoubleClick = true,
	Func = function() RemotesFolder.Lobby:FireServer() end
})
Groupboxes.Self_Misc:AddButton({
	Text = "Revive",
	Tooltip = "Makes you revive, if you have a revive and haven't already revived in this run.",
	DoubleClick = true,
	Func = function() RemotesFolder.Revive:FireServer() end
})
Groupboxes.Self_Misc:AddButton({
	Text = "Reset Character",
	Tooltip = "Kills your character on the server. (takes around 20 seconds if replicatesignal isn't supported)",
	DoubleClick = true,
	Func = function()
		Globals.SelfKilled = true
		if Functions.CheckCompatability({"replicatesignal"}) then
			Abysall.Environment.replicatesignal(LocalPlayer.Kill)
		else
			if RemotesFolder:FindFirstChild("Underwater") then
				RemotesFolder.Underwater:FireServer(true)
			else
				Humanoid.Health = 0
			end
		end
	end
})

Groupboxes.Exploits_Bypass = Tabs.Exploits:AddLeftGroupbox("Bypass")
Groupboxes.Exploits_Bypass:AddToggle("BypassGiggle",         { Text = "Bypass Giggle",           Default = false, Tooltip = "Prevents 'Giggle' from attacking you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassDupe",           { Text = "Bypass Dupe",             Default = false, Tooltip = "Prevents you from open 'Dupe' fake doors." })
Groupboxes.Exploits_Bypass:AddToggle("BypassEyes",           { Text = "Bypass Eyes",             Default = false, Tooltip = "Prevents 'Eyes' from hurting you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassLookman",        { Text = "Bypass Lookman",          Default = false, Tooltip = "Prevents 'Lookman' from hurting you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassGloombatEggs",   { Text = "Bypass Gloombat Eggs",    Default = false, Tooltip = "Prevents taking damage from stepping on 'Gloombat' eggs." })
Groupboxes.Exploits_Bypass:AddToggle("BypassSeekObstructions", { Text = "Bypass Seek Obstructions", Default = false, Tooltip = "Prevents obstacles in the 'Seek' chase from harming you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassVacuum",         { Text = "Bypass Vacuum",           Default = false, Tooltip = "Prevents you from falling into 'Vacuum' fake doors." })
Groupboxes.Exploits_Bypass:AddToggle("BypassKillbricks",     { Text = "Bypass Killbricks",       Default = false, Tooltip = "Prevents 'Lava' from hurting you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassSeekingWall",    { Text = "Bypass Seeking Wall",     Default = false, Tooltip = "Prevents 'ScaryWall' from hurting you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassSnare",          { Text = "Bypass Snare",            Default = false, Tooltip = "Prevents 'Snare' from trapping you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassBanana",         { Text = "Bypass Banana",           Default = false, Tooltip = "Prevents 'Banana Peel' from slipping you up (sometimes doesn't work)." })
Groupboxes.Exploits_Bypass:AddToggle("BypassJeff",           { Text = "Bypass Jeff",             Default = false, Tooltip = "Prevents 'Jeff the Killer' from stabbing you (sometimes doesn't work)." })

Toggles.BypassGiggle:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "GiggleCeiling" then
			Object:WaitForChild("Hitbox").CanTouch = not Value
		end
	end
end)
Toggles.BypassDupe:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "DoorFake" or Object.Name == "FakeDoor" then
			Object:WaitForChild("Hidden").CanTouch = not Value
			if Object:FindFirstChild("Lock") then
				Object.Lock.UnlockPrompt.Enabled = not Value
			end
		end
	end
end)
Toggles.BypassEyes:OnChanged(function(Value)
	if Value and Globals.IsEyes then
		if Floor == "Fools" or Floor == "OldHotel" then
			RemotesFolder.MotorReplication:FireServer(0, (Globals.SpoofOffset == 200 and 65 or -65), 0, false)
		else
			RemotesFolder.MotorReplication:FireServer(-650)
		end
	end
end)
Toggles.BypassLookman:OnChanged(function(Value)
	if Value and Globals.IsLookman then
		if Floor == "Fools" or Floor == "OldHotel" then
			RemotesFolder.MotorReplication:FireServer(0, (Globals.SpoofOffset == 200 and 65 or -65), 0, false)
		else
			RemotesFolder.MotorReplication:FireServer(-650)
		end
	end
end)
Toggles.BypassGloombatEggs:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		for _, Part in Object:GetDescendants() do
			if Part:IsA("BasePart") then
				Part.CanTouch = not Value
			end
		end
	end
end)
Toggles.BypassSeekObstructions:OnChanged(function(Value)
	for _, Object in Objects.SeekObstructions do
		Object.CanTouch = not Value
		if Object.Name == "SeekFloodline" then
			Object.CanCollide = Value
		end
	end
	for _, Object in Objects.SeekBridges do
		Object.CanCollide = Value
		Object.Transparency = Value and 0 or 1
	end
end)
Toggles.BypassVacuum:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "SideroomSpace" then
			Object:WaitForChild("Collision").CanCollide = Value
			Object:WaitForChild("Collision").CanTouch = not Value
		end
	end
end)
Toggles.BypassKillbricks:OnChanged(function(Value)
	for _, Object in Objects.Obstructions do
		if Object.Name == "Lava" then Object.CanTouch = not Value end
	end
end)
Toggles.BypassSeekingWall:OnChanged(function(Value)
	for _, Object in Objects.Obstructions do
		if Object.Name == "ScaryWall" then
			for _, Part in Object:GetDescendants() do
				if Part:IsA("BasePart") then
					Part.CanTouch = not Value
					Part.CanCollide = not Value
				end
			end
		end
	end
end)
Toggles.BypassSnare:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "Snare" then
			for _, Part in Object:GetDescendants() do
				if Part:IsA("BasePart") then Part.CanTouch = not Value end
			end
		end
	end
end)
Toggles.BypassBanana:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "BananaPeel" then Object.CanTouch = not Value end
	end
end)
Toggles.BypassJeff:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "JeffTheKiller" then
			for _, Part in Object:GetDescendants() do
				if Part:IsA("BasePart") then
					Part.CanCollide = not Value
					Part.CanTouch = not Value
				end
			end
			Object:WaitForChild("Humanoid").Health = 0
		end
	end
end)

Groupboxes.Exploits_BypassRight = Tabs.Exploits:AddRightGroupbox("Bypass")
Groupboxes.Exploits_BypassRight:AddToggle("DisableAnticheat", {
	Text = "Anticheat Bypass", Default = false,
	Tooltip = "Completely disables the anticheat, after interacting with a ladder."
})
Groupboxes.Exploits_BypassRight:AddToggle("VelocityManipulationToggle", {
	Text = "Velocity Manipulation", Default = false,
	Tooltip = "Moves your character forward slowly, mitigating the game's anti-noclip."
})
Toggles.DisableAnticheat:OnChanged(function(Value)
	if Globals.AnticheatDisabled == true and not Value then
		RemotesFolder.ClimbLadder:FireServer()
		Globals.AnticheatDisabled = false
	end
end)
Toggles.VelocityManipulationToggle:AddKeyPicker("VelocityManipulationKeybind", {
	Text = "Velocity Manipulation", Default = "V",
	Mode = Library.IsMobile and "Toggle" or "Hold", SyncToggleState = true
})
Groupboxes.Exploits_BypassRight:AddDropdown("VelocityManipulationMode", {
	Values = {"Velocity", "Pivot"}, Text = "Manipulation Method",
	Default = 1,
})

Groupboxes.Exploits_BypassRight:AddDivider()
Groupboxes.Exploits_BypassRight:AddToggle("InfiniteItemsToggle", {
	Text = "Infinite Items", Default = false,
	Tooltip = "Allows certain items to be used without draining their uses.",
	Disabled = not Functions.CheckCompatability({"fireproximityprompt"}),
	DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Exploits_BypassRight:AddDropdown("InfiniteItemsList", {
	Text = "Item List",
	Values = { "Lockpicks", "Skeleton Key", "Shears", "Multitool" },
	Multi = true, AllowNull = true,
	Disabled = not Functions.CheckCompatability({"fireproximityprompt"}),
	DisabledTooltip = Globals.IncompatibleMessage
})

Groupboxes.Exploits_BypassRight:AddDivider()
Groupboxes.Exploits_BypassRight:AddToggle("PositionSpoof", {
	Text = "Position Spoof", Default = false,
	Tooltip = "Makes your character appear underground on the server, protecting you from rush-like entities."
})
Groupboxes.Exploits_BypassRight:AddToggle("CrouchSpoof", {
	Text = "Crouch Spoof", Default = false, Tooltip = "Makes the game think you are always crouching."
})
Toggles.PositionSpoof:OnChanged(function(Value)
	if Floor ~= "Fools" and Floor ~= "OldHotel" then
		if Value then
			RootPart.CFrame = RootPart.CFrame * CFrame.new(0, -2.346, 0)
			Humanoid.HipHeight = 0.05
			RemotesFolder.Crouch:FireServer(true, true)
		else
			RootPart.CFrame = RootPart.CFrame * CFrame.new(0, 2.346, 0)
			Humanoid.HipHeight = 2.396
		end
	end
end)
Toggles.PositionSpoof:AddKeyPicker("PositionSpoof", {
	Text = "Position Spoof", Default = "B", Mode = "Toggle", SyncToggleState = true
})
Toggles.CrouchSpoof:OnChanged(function(Value)
	if RemotesFolder:FindFirstChild("Crouch") then
		RemotesFolder.Crouch:FireServer(Value and true or Functions.IsCrouching(), true)
	end
end)

Groupboxes.Exploits_Remove = Tabs.Exploits:AddRightGroupbox("Remove")
Groupboxes.Exploits_Remove:AddToggle("RemoveScreech", { Text = "Remove Screech",  Default = false, Tooltip = "Prevents 'Screech' from spawning." })
Groupboxes.Exploits_Remove:AddToggle("RemoveHalt",    { Text = "Remove Halt",     Default = false, Tooltip = "Prevents 'Halt' from spawning." })
Groupboxes.Exploits_Remove:AddToggle("RemoveA90",     { Text = "Remove A-90",     Default = false, Tooltip = "Prevents 'A-90' from spawning." })
Groupboxes.Exploits_Remove:AddToggle("RemoveDread",   { Text = "Remove Dread",    Default = false, Tooltip = "Prevents 'Dread' from spawning." })
Groupboxes.Exploits_Remove:AddToggle("RemoveSurge", { Text = "Remove Surge", Default = false, Tooltip = "Prevents 'Surge' from spawning."})
Groupboxes.Exploits_Remove:AddDivider()
Groupboxes.Exploits_Remove:AddToggle("NoScreechDamage", { Text = "No Screech Damage", Default = false, Tooltip = "Prevents 'Screech' from hurting you." })
Groupboxes.Exploits_Remove:AddToggle("NoHaltDamage",    { Text = "No Halt Damage",    Default = false, Tooltip = "Prevents 'Halt' from hurting you." })
Groupboxes.Exploits_Remove:AddToggle("NoA90Damage",     { Text = "No A-90 Damage",    Default = false, Tooltip = "Prevents 'A-90' from hurting you." })
Groupboxes.Exploits_Remove:AddToggle("NoSurgeDamage",   { Text = "No Surge Damage",   Default = false, Tooltip = "Prevents 'Surge' from hurting you." })

Toggles.NoScreechDamage:OnChanged(function(Value)
	if Value then
		FakeEvents.Screech.Parent = RemotesFolder
		FakeEvents.Screech_Real.Parent = nil
	else
		FakeEvents.Screech_Real.Parent = RemotesFolder
		FakeEvents.Screech.Parent = nil
	end
end)
Toggles.NoHaltDamage:OnChanged(function(Value)
	if Value then
		FakeEvents.Shade.Parent = RemotesFolder
		FakeEvents.Shade_Real.Parent = nil
	else
		FakeEvents.Shade_Real.Parent = RemotesFolder
		FakeEvents.Shade.Parent = nil
	end
end)
Toggles.NoA90Damage:OnChanged(function(Value)
	if RemotesFolder:FindFirstChild("A90") then
		if Value then
			FakeEvents.A90.Parent = RemotesFolder
			FakeEvents.A90_Real.Parent = nil
		else
			FakeEvents.A90_Real.Parent = RemotesFolder
			FakeEvents.A90.Parent = nil
		end
	end
end)
Toggles.NoSurgeDamage:OnChanged(function(Value)
	if RemotesFolder:FindFirstChild("SurgeRemote") then
		if Value then
			FakeEvents.Surge.Parent = RemotesFolder
			FakeEvents.Surge_Real.Parent = nil
		else
			FakeEvents.Surge_Real.Parent = RemotesFolder
			FakeEvents.Surge.Parent = nil
		end
	end
end)

local Modules = {}

Toggles.RemoveScreech:OnChanged(function(Value)
	Modules.Screech.Name = Value and "Screech_Disabled" or "Screech"
	if Modules.GlitchScreech then
		Modules.GlitchScreech.Name = Value and "GlitchScreech_Disabled" or "GlitchScreech"
	end
end)
Toggles.RemoveHalt:OnChanged(function(Value)
	Modules.Shade.Name = Value and "Shade_Disabled" or "Shade"
end)
Toggles.RemoveA90:OnChanged(function(Value)
	if Modules.A90 then
		Modules.A90.Name = Value and "A90_Disabled" or "A90"
	end
end)
Toggles.RemoveDread:OnChanged(function(Value)
	if Modules.Dread then
		Modules.Dread.Name = Value and "Dread_Disabled" or "Dread"
	end
end)
Toggles.RemoveSurge:OnChanged(function(Value)
	if Globals.SurgeFrame then
		Globals.SurgeFrame.Name = (Value and "SurgeVignette_Disabled" or "SurgeVignette")
	end
end)

Groupboxes.Exploits_Audio = Tabs.Exploits:AddLeftGroupbox("Audio")
Globals.JamMuffle = Services.SoundService:WaitForChild("Main"):FindFirstChild("Jamming") or Instance.new("EqualizerSoundEffect")

Groupboxes.Exploits_Audio:AddToggle("RemoveFootstepSounds",    { Text = "Remove Footstep Sounds",    Default = false, Tooltip = "Removes the sounds when walking." })
Groupboxes.Exploits_Audio:AddToggle("RemoveJamminMusic",       { Text = "Remove Jammin Music",       Default = false, Tooltip = "Removes the music and muffle effect from the 'Jammin' modifier." })
Groupboxes.Exploits_Audio:AddToggle("RemoveInteractingSounds", { Text = "Remove Interacting Sounds", Default = false, Tooltip = "Removes the sounds when interacting with proximity prompts." })

Toggles.RemoveJamminMusic:OnChanged(function(Value)
	local Jam = Globals.MainUI.Initiator.Main_Game.Health:FindFirstChild("Jam")
	if Jam then
		Jam.Volume = Value and 0 or 0.45
		Globals.JamMuffle.Enabled = LiveModifiers:FindFirstChild("Jammin") and not Value or false
	end
end)
Toggles.RemoveInteractingSounds:OnChanged(function(Value)
	local PS = Globals.MainUI.Initiator.Main_Game.PromptService
	PS.Triggered.Volume   = Value and 0 or 0.04
	PS.Holding.Volume     = Value and 0 or 0.1
	PS.Notification.Volume = Value and 0 or 0.03
	Globals.MainUI.Initiator.Main_Game.Reminder.Caption.Volume = Value and 0 or 0.1
end)

Groupboxes.Visuals_LeftTab = Tabs.Visuals:AddLeftTabbox("Camera / Effects")
Groupboxes.Visuals_Camera = Groupboxes.Visuals_LeftTab:AddTab("Camera")
Groupboxes.Visuals_Camera:AddToggle("AmbientToggle", { Text = "Ambient", Default = false, Tooltip = "Changes the lighting color to the specified value." })
Groupboxes.Visuals_Camera:AddSlider("FieldOfView", { Text = "Field of View", Min = 1, Max = 120, Default = 70, Rounding = 0 })
Groupboxes.Visuals_Camera:AddDivider()
Groupboxes.Visuals_Camera:AddToggle("RemoveCameraShake", {
	Text = "Remove Camera Shake", Default = false, Tooltip = "Prevents the camera from shaking.",
	Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Visuals_Camera:AddToggle("RemoveCameraBobbing", {
	Text = "Remove Camera Bobbing", Default = false, Tooltip = "Prevents the camera from bobbing when moving.",
	Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Visuals_Camera:AddToggle("RemoveCutscenes", { Text = "Remove Cutscenes", Default = false, Tooltip = "Removes all non-necessary cutscenes." })
Groupboxes.Visuals_Camera:AddToggle("RemoveCameraFog", { Text = "Remove Fog", Default = false, Tooltip = "Removes all fog effects from the camera." })
Groupboxes.Visuals_Camera:AddDivider()
Groupboxes.Visuals_Camera:AddToggle("ThirdPersonToggle", { Text = "Third Person", Default = false, Tooltip = "Zooms out your camera, allowing you to see your character from behind." })
Toggles.ThirdPersonToggle:AddKeyPicker("ThirdPersonKeybind", { Text = "Third Person", Default = "T", Mode = "Toggle", SyncToggleState = true })
Groupboxes.Visuals_Camera:AddSlider("ThirdPersonOffsetX", { Text = "X Offset", Min = -10, Max = 10, Default = 1.5, Rounding = 1, Compact = true })
Groupboxes.Visuals_Camera:AddSlider("ThirdPersonOffsetY", { Text = "Y Offset", Min = -10, Max = 10, Default = 1,   Rounding = 1, Compact = true })
Groupboxes.Visuals_Camera:AddSlider("ThirdPersonOffsetZ", { Text = "Z Offset", Min = -10, Max = 10, Default = 5,   Rounding = 1, Compact = true })
Groupboxes.Visuals_Camera:AddToggle("ThirdPersonWallCheck", { Text = "Wall Check", Default = false, Tooltip = "Prevents third person from going through walls." })
Groupboxes.Visuals_Camera:AddDivider()
Groupboxes.Visuals_Camera:AddToggle("ViewmodelOffsetToggle", {
	Text = "Viewmodel Offset", Default = false, Tooltip = "Changes the offset of your viewmodel while holding an item.",
	Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Visuals_Camera:AddSlider("ViewmodelOffsetX", { Text = "X Offset", Min = -10, Max = 10, Default = 0, Rounding = 1, Compact = true, Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Visuals_Camera:AddSlider("ViewmodelOffsetY", { Text = "Y Offset", Min = -10, Max = 10, Default = 0, Rounding = 1, Compact = true, Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Visuals_Camera:AddSlider("ViewmodelOffsetZ", { Text = "Z Offset", Min = -10, Max = 10, Default = 0, Rounding = 1, Compact = true, Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage })

Toggles.AmbientToggle:AddColorPicker("AmbientColor", { Text = "Ambient", Default = Color3.fromRGB(255, 255, 255), Transparency = 0 })
Toggles.AmbientToggle:OnChanged(function(Value)
	local OldAmbient = CurrentRooms:FindFirstChild(tostring(LocalPlayer:GetAttribute("CurrentRoom"))):GetAttribute("Ambient")
	Services.TweenService:Create(Services.Lighting, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
		Ambient = Value and Options.AmbientColor.Value or OldAmbient
	}):Play()
end)

local Main_Game
local ClientModules

Toggles.RemoveCameraBobbing:OnChanged(function(Value)
	if Main_Game then Main_Game.spring.Speed = Value and 9e9 or 8 end
end)
Toggles.RemoveCameraFog:OnChanged(function(Value)
	Services.Lighting.FogEnd = Value and 10000000 or Globals.OldFog
	for _, Object in Globals.FogInstances do
		Object.Density = Value and 0 or Object:GetAttribute("Density_Old")
	end
end)
Toggles.RemoveCutscenes:OnChanged(function(Value)
    local Cutscenes = Globals.MainUI.Initiator.Main_Game.RemoteListener.Cutscenes
    for _, Object in pairs(Cutscenes:GetChildren()) do
        if table.find(CutsceneNames, Object.Name) and Object:IsA("ModuleScript") or table.find(CutsceneNames, Object:GetAttribute("OriginalName")) and Object:IsA("ModuleScript") then
            Object.Name = (Value and Object.Name .. "_Disabled" or Object:GetAttribute("OriginalName"))
        end
    end
    for _, Object in pairs(FloorReplicated:GetChildren()) do
        if table.find(CutsceneNames, Object.Name) and Object:IsA("ModuleScript") or table.find(CutsceneNames, Object:GetAttribute("OriginalName")) and Object:IsA("ModuleScript") then
            Object.Name = (Value and Object.Name .. "_Disabled" or Object:GetAttribute("OriginalName"))
        end
    end
end)

Groupboxes.Visuals_Effects = Groupboxes.Visuals_LeftTab:AddTab("Effects")
Groupboxes.Visuals_Effects:AddToggle("TransparentHidingSpotsToggle", { Text = "Transparent Hiding Spots", Default = false, Tooltip = "Makes a hiding spot transparent when you enter it." })
Groupboxes.Visuals_Effects:AddSlider("TransparentHidingSpotsSlider", { Text = "Transparency", Min = 0, Max = 1, Default = 0.5, Rounding = 2, Compact = true })

local function ApplyHidingTransparency(Value, SliderValue)
	for _, Object in Objects.HidingSpots do
		local IsHiding = false
		for _, Child in Object:GetDescendants() do
			if Child.Name == "HiddenPlayer" and Child.Value == Character then
				IsHiding = true
				break
			end
		end
		for _, Part in Object:GetDescendants() do
			if Part:IsA("BasePart") and Part:GetAttribute("Transparency_Old") then
				Services.TweenService:Create(Part, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
					Transparency = (Value and IsHiding) and SliderValue or Part:GetAttribute("Transparency_Old")
				}):Play()
			end
		end
	end
end

Toggles.TransparentHidingSpotsToggle:OnChanged(function(Value)
	ApplyHidingTransparency(Value, Options.TransparentHidingSpotsSlider.Value)
end)
Options.TransparentHidingSpotsSlider:OnChanged(function(Value)
	ApplyHidingTransparency(Toggles.TransparentHidingSpotsToggle.Value, Value)
end)

Groupboxes.Visuals_Effects:AddDivider()
Groupboxes.Visuals_Effects:AddToggle("DisableGlitchJumpscare",   { Text = "Disable Glitch Jumpscare",   Default = false, Tooltip = "Disables the jumpscare from 'Glitch'" })
Groupboxes.Visuals_Effects:AddToggle("DisableTimothyJumpscare",  { Text = "Disable Timothy Jumpscare",  Default = false, Tooltip = "Disables the jumpscare from 'Timothy'" })
Groupboxes.Visuals_Effects:AddToggle("DisableVoidJumpscare",     { Text = "Disable Void Jumpscare",     Default = false, Tooltip = "Disables the jumpscare from 'Void'" })
Groupboxes.Visuals_Effects:AddDivider()
Groupboxes.Visuals_Effects:AddToggle("DisableHideVignette",      { Text = "Disable Hide Vignette",      Default = false, Tooltip = "Disables the hiding screen effect." })
Groupboxes.Visuals_Effects:AddToggle("DisableFiredampEffect",    { Text = "Disable Firedamp Effect",    Default = false, Tooltip = "Disables the firedamp screen effect." })
Groupboxes.Visuals_Effects:AddToggle("DisableEntityJumpscares",  { Text = "Disable Entity Jumpscares",  Default = false, Tooltip = "Disables jumpscares from entities like Rush and Ambush." })

Toggles.DisableGlitchJumpscare:OnChanged(function(Value)
	Modules.Glitch.Name = Value and "Glitch_Disabled" or "Glitch"
end)
Toggles.DisableTimothyJumpscare:OnChanged(function(Value)
	Modules.SpiderJumpscare.Name = Value and "SpiderJumpscare_Disabled" or "SpiderJumpscare"
end)
Toggles.DisableVoidJumpscare:OnChanged(function(Value)
	if Modules.Void then Modules.Void.Name = Value and "Void_Disabled" or "Void" end
end)
Toggles.DisableHideVignette:OnChanged(function(Value)
	local Vignette = Globals.MainUI:FindFirstChild("HideVignette") or Globals.MainUI.MainFrame:FindFirstChild("HideVignette")
	if Vignette then Vignette.Image = Value and "Disabled" or "rbxassetid://6100076320" end
end)
Toggles.DisableFiredampEffect:OnChanged(function(Value)
	for _, Object in CurrentRooms:GetChildren() do
		if Value then
			Object:SetAttribute("Firedamp", false)
			for _, FiredampObj in Camera:GetChildren() do
				if FiredampObj.Name == "LiveFiredamp" then FiredampObj:Destroy() end
			end
		else
			Object:SetAttribute("Firedamp", Object:GetAttribute("Firedamp_Old"))
		end
	end
	local Old = LocalPlayer:GetAttribute("CurrentRoom")
	LocalPlayer:SetAttribute("CurrentRoom", 0)
	task.wait()
	LocalPlayer:SetAttribute("CurrentRoom", Old)
end)
Toggles.DisableEntityJumpscares:OnChanged(function(Value)
	local Jumpscares = Globals.MainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscares")
		or Globals.MainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscares_Disabled")
	if Jumpscares then
		Jumpscares.Name = Value and "Jumpscares_Disabled" or "Jumpscares"
		for _, Object in Objects.JumpscareModules do
			Object.Name = Value and (Object:GetAttribute("OriginalName") .. "_Disabled") or Object:GetAttribute("OriginalName")
		end
	end
end)

Groupboxes.Visuals_RightTab     = Tabs.Visuals:AddRightTabbox("Entities / Settings")
Groupboxes.Visuals_Entities     = Groupboxes.Visuals_RightTab:AddTab("Entities")
Groupboxes.Visuals_EntitySettings = Groupboxes.Visuals_RightTab:AddTab("Settings")

Groupboxes.Visuals_Entities:AddDropdown("EntityList", {
	Text = "Entity List",
	Values = { "Rush","Ambush","Eyes","Halt","Blitz","Lookman","Gloombat Swarm","A-60","A-120","Sally","Jeff the Killer","Groundskeeper","Monument","AR0xMBUSH","RNIUSHCG==" },
	Multi = true, AllowNull = true
})
Groupboxes.Visuals_Entities:AddToggle("NotifyEntities",    { Text = "Notify Entities",    Default = false, Tooltip = "Sends a notification when an entity spawns." })
Groupboxes.Visuals_Entities:AddDivider()

local ItemsToNotify = {}
for Index, Name in pairs(ItemNames) do
	if not table.find(ItemsToNotify, Name) then
		table.insert(ItemsToNotify, Name)
	end
end

Groupboxes.Visuals_Entities:AddDropdown("NotifyItemList", {
	Text = "Item List",
	Values = ItemsToNotify,
	Multi = true, AllowNull = true
})
Groupboxes.Visuals_Entities:AddToggle("NotifyItemsToggle",    { Text = "Notify Items",    Default = false, Tooltip = "Sends a notification when an item spawns." })
Groupboxes.Visuals_Entities:AddToggle("NotifyItemsShowDistance",    { Text = "Show Distance",    Default = false, Tooltip = "Shows how far away the item is in the notification." })
Groupboxes.Visuals_Entities:AddDivider()
Groupboxes.Visuals_Entities:AddToggle("NotifyLibraryCode", { Text = "Notify Library Code", Default = false, Tooltip = "Automatically solves the code for the library padlock." })
Groupboxes.Visuals_Entities:AddToggle("NotifyOxygen",      { Text = "Notify Oxygen Level", Default = false, Tooltip = "Shows how much oxygen you have remaining." })
Groupboxes.Visuals_Entities:AddToggle("NotifyHasteTime",   { Text = "Notify Haste Time",   Default = false, Tooltip = "Shows how much time you have remaining before 'Haste' spawns." })

Globals.LibraryCodeFound = false
Toggles.NotifyLibraryCode:OnChanged(function(Value)
	if Value then
		local Code = Functions.GetLibraryCode()
		if Code and not Code:find("_") and not Globals.LibraryCodeFound and CurrentRooms:FindFirstChild("50") then
			local Lock = Services.Workspace:FindFirstChild("Padlock", true)
			Functions.Notify({ Title = "Padlock code found!", Body = "The code is: '" .. Code .. "'", Time = Toggles.NotifyKeepNotifications.Value and Lock or 15 })
			Globals.LibraryCodeFound = true
		end
	end
end)

Groupboxes.Visuals_EntitySettings:AddToggle("EntityChatToggle", { Text = "Notify Chat", Default = false, Tooltip = "Sends a message in the chat when an entity spawns." })
Groupboxes.Visuals_EntitySettings:AddInput("EntityChatMessage", { Text = "Message", Default = "spawned!", Numeric = false, Placeholder = "Message" })
Groupboxes.Visuals_EntitySettings:AddDivider()
Groupboxes.Visuals_EntitySettings:AddDropdown("NotifyStyle", { Text = "Notify Style", Values = { "Abysall", "Doors", "STX", "Library" }, Default = 1 })
Groupboxes.Visuals_EntitySettings:AddSlider("NotifySoundVolume", { Text = "Sound Volume", Min = 0, Max = 10, Default = 3, Rounding = 1 })
Groupboxes.Visuals_EntitySettings:AddToggle("NotifyPlaySound", { Text = "Play Sound", Default = true, Tooltip = "Makes notifications play an alert sound." })
Groupboxes.Visuals_EntitySettings:AddToggle("NotifyKeepNotifications", { Text = "Keep Notifications", Default = false, Tooltip = "Certain notifications will stay on screen until they are no longer needed." })
Groupboxes.Visuals_EntitySettings:AddButton({ Text = "Test Notification", DoubleClick = false, Tooltip = "Sends a test notifcation, so you can see how your settings look.", Func = function()
	Functions.Notify({Title = "This is a test."})
end})

Groupboxes.Visuals_ESP          = Tabs.Visuals:AddRightTabbox("ESP/Settings")
Groupboxes.Visuals_ESP_Toggles  = Groupboxes.Visuals_ESP:AddTab("ESP")
Groupboxes.Visuals_ESP_Settings = Groupboxes.Visuals_ESP:AddTab("Settings")

local function MakeESPToggle(ToggleKey, ColorKey, Text, Tooltip, ObjectsTable, LabelFunc, RoomBased)
	Groupboxes.Visuals_ESP_Toggles:AddToggle(ToggleKey, { Text = Text, Default = false, Tooltip = Tooltip })
	Toggles[ToggleKey]:AddColorPicker(ColorKey, { Text = Text, Default = Options[ColorKey] and Options[ColorKey].Value or Color3.new(1,1,1), Transparency = 0 })
	Toggles[ToggleKey]:OnChanged(function(Value)
		for _, Object in ObjectsTable do
			if Value then
				local Label, UseRoom = LabelFunc(Object)
				if Label then
					Functions.AddESP({ Object = Object, Text = Label, Color = Options[ColorKey].Value }, UseRoom ~= nil and UseRoom or RoomBased)
				end
			else
				Functions.RemoveESP(Object)
			end
		end
	end)
	Options[ColorKey]:OnChanged(function(Value)
		for _, Object in ObjectsTable do
			Abysall.ESPLibrary:UpdateObjectColor(Object, Value)
		end
	end)
end

Groupboxes.Visuals_ESP_Toggles:AddToggle("ObjectiveESPToggle", { Text = "Objectives", Default = false, Tooltip = "Highlights all objects required to progress." })
Toggles.ObjectiveESPToggle:AddColorPicker("ObjectiveESPColor", { Text = "Objectives", Default = Color3.fromRGB(0, 255, 0), Transparency = 0 })

local ObjectiveLabels = {
	["KeyObtain"]              = "Door Key",
	["ElectricalKeyObtain"]    = "Electrical Key",
	["MinesGenerator"]         = "Generator",
	["FuseObtain"]             = "Generator Fuse",
	["LiveHintBook"]           = "Hint Book",
	["LiveBreakerPolePickup"]  = "Fuse Breaker",
	["LibraryHintPaper"]       = "Hint Paper",
	["PickupItem"]             = "Hint Paper",
	["CringlePresent"]         = "Present",
	["LeverForGate"]           = "Gate Lever",
	["MinesGateButton"]        = "Gate Button",
	["GardenGateButton"]       = "Gate Button",
}

Toggles.ObjectiveESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Objectives do
		if Value then
			local Label = ObjectiveLabels[Object.Name]
			if Object.Name == "TimerLever" then
				Label = "Time Lever [+" .. Object:GetAttribute("AddTime") .. "s]"
			elseif Object.Name == "MinesAnchor" then
				Label = "Anchor [" .. Object:WaitForChild("Sign").TextLabel.Text .. "]"
			elseif Object.Name == "WaterPump" then
				Functions.AddESP({ Object = Object.Wheel, Text = "Water Pump", Color = Options.ObjectiveESPColor.Value }, true)
			elseif Object.Name == "VineGuillotine" then
				Functions.AddESP({ Object = Object.Lever, Text = "Vine Lever", Color = Options.ObjectiveESPColor.Value }, true)
			end
			if Label then
				Functions.AddESP({ Object = Object, Text = Label, Color = Options.ObjectiveESPColor.Value }, true)
			end
		else
			Functions.RemoveESP(Object)
		end
	end
end)
Options.ObjectiveESPColor:OnChanged(function(Value)
	for _, Object in Objects.Objectives do
		Abysall.ESPLibrary:UpdateObjectColor(Object, Value)
	end
end)

Groupboxes.Visuals_ESP_Toggles:AddToggle("DoorESPToggle",       { Text = "Doors",        Default = false, Tooltip = "Highlights the next door." })
Groupboxes.Visuals_ESP_Toggles:AddToggle("HidingSpotESPToggle", { Text = "Hiding Spots", Default = false, Tooltip = "Highlights places where you can hide from entities" })
Groupboxes.Visuals_ESP_Toggles:AddToggle("PlayerESPToggle",     { Text = "Players",      Default = false, Tooltip = "Highlights other players." })
Groupboxes.Visuals_ESP_Toggles:AddToggle("ChestESPToggle",      { Text = "Chests",       Default = false, Tooltip = "Highlights objects that can contain loot." })
Groupboxes.Visuals_ESP_Toggles:AddToggle("ItemESPToggle",       { Text = "Items",        Default = false, Tooltip = "Highlights all collectable items/consumables." })
Groupboxes.Visuals_ESP_Toggles:AddToggle("CurrencyESPToggle",   { Text = "Currency",     Default = false, Tooltip = "Highlights all currency that spawns." })
Groupboxes.Visuals_ESP_Toggles:AddToggle("LadderESPToggle",     { Text = "Ladders",      Default = false, Tooltip = "Highlights ladders that can be used to disable the anticheat." })
Groupboxes.Visuals_ESP_Toggles:AddDivider()
Groupboxes.Visuals_ESP_Toggles:AddDropdown("EntityESPOptions",     { 
	Text = "Entity List",
	Values = { "Rush","Ambush","Eyes","Dupe","Figure","Blitz","Lookman","Snare","Giggle","Gloombat Eggs","Grumble","A-60","A-120","Sally","Jeff the Killer","Groundskeeper","Mandrake Hole","Monument","Bramble","AR0xMBUSH","RNIUSHCG==" },
	Multi = true,
	AllowNull = true
})
Groupboxes.Visuals_ESP_Toggles:AddToggle("EntityESPToggle",     { Text = "Entities",      Default = false, Tooltip = "Highlights all entities that spawn." })

Toggles.DoorESPToggle:AddColorPicker("DoorESPColor",           { Text = "Doors",        Default = Color3.fromRGB(0, 200, 255),  Transparency = 0 })
Toggles.HidingSpotESPToggle:AddColorPicker("HidingSpotESPColor", { Text = "Hiding Spots", Default = Color3.fromRGB(255, 170, 0),  Transparency = 0 })
Toggles.PlayerESPToggle:AddColorPicker("PlayerESPColor",       { Text = "Players",      Default = Color3.fromRGB(255, 255, 255), Transparency = 0 })
Toggles.ChestESPToggle:AddColorPicker("ChestESPColor",         { Text = "Chests",       Default = Color3.fromRGB(255, 255, 0),   Transparency = 0 })
Toggles.ItemESPToggle:AddColorPicker("ItemESPColor",           { Text = "Items",        Default = Color3.fromRGB(170, 0, 255),   Transparency = 0 })
Toggles.CurrencyESPToggle:AddColorPicker("CurrencyESPColor",   { Text = "Currency",     Default = Color3.fromRGB(255, 255, 0),   Transparency = 0 })
Toggles.LadderESPToggle:AddColorPicker("LadderESPColor",       { Text = "Ladders",      Default = Color3.fromRGB(255, 255, 255), Transparency = 0 })
Toggles.EntityESPToggle:AddColorPicker("EntityESPColor",       { Text = "Entities",     Default = Color3.fromRGB(255, 0, 0),     Transparency = 0 })

local HidingSpotLabels = {
	Wardrobe = "Closet", ["Backdoor_Wardrobe"] = "Closet", Toolshed = "Closet",
	RetroWardrobe = "Closet", ["Wardrobe-FOOLS26"] = "Closet",
	Locker_Large = "Locker", Rooms_Locker = "Locker", Rooms_Locker_Fridge = "Locker",
	Bed = "Bed", Double_Bed = "Double Bed", CircularVent = "Vent", Dumpster = "Dumpster"
}
local ChestLabels = {
	ChestBox = true, ChestBoxLocked = true, Toolbox = true, Toolbox_Locked = true,
	Chest_Vine = "Vine Chest", Toolshed_Small = "Toolshed", Locker_Small_Locked = "Locked Item Locker", MouseHole = "Mouse"
}
local EntityESPLabels = {
	JeffTheKiller = "Jeff the Killer", GiggleCeiling = "Giggle",
	Snare = "Snare", GrumbleRig = "Grumble",
	Drakobloxxer = "Drakobloxxer", Hole = "Mandrake Hole", Groundskeeper = "Groundskeeper",
	LiveEntityBramble = "Bramble", Figure = "Figure", FigureRig = "Figure", FigureRagdoll = "Figure",
	FakeDoor = "Dupe", DoorFake = "Dupe"
}

local NodeEntities = {
	Rush = true, Ambush = true, Eyes = true, Blitz = true, Lookman = true, ["A-60"] = true, ["A-120"] = true, Sally = true, ["Jeff The Killer"] = true, Monument = true, ["AR0xMBUSH"] = true, ["RNIUSHCG=="] = true
}

Toggles.DoorESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Doors do
		if Value then Functions.AddESP({ Object = Object, Text = "Door " .. Functions.GetDoorNumber(Object), Color = Options.DoorESPColor.Value }, true)
		else Functions.RemoveESP(Object) end
	end
end)
Options.DoorESPColor:OnChanged(function(Value)
	for _, Object in Objects.Doors do Abysall.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Toggles.HidingSpotESPToggle:OnChanged(function(Value)
	for _, Object in Objects.HidingSpots do
		local Label = HidingSpotLabels[Object.Name]
		if Value and Label then Functions.AddESP({ Object = Object, Text = Label, Color = Options.HidingSpotESPColor.Value }, true)
		elseif not Value then Functions.RemoveESP(Object) end
	end
end)
Options.HidingSpotESPColor:OnChanged(function(Value)
	for _, Object in Objects.HidingSpots do Abysall.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Toggles.PlayerESPToggle:OnChanged(function(Value)
	task.wait()
	for _, Player in Services.Players:GetPlayers() do
		if Player.Character and Player ~= LocalPlayer then
			if Value and Player:GetAttribute("Alive") == true then
				Functions.AddESP({ Object = Player.Character, Text = Player.Name, Color = Options.PlayerESPColor.Value })
			else
				Functions.RemoveESP(Player.Character)
			end
		end
	end
end)
Options.PlayerESPColor:OnChanged(function(Value)
	for _, Player in Services.Players:GetPlayers() do
		if Player.Character and Player ~= LocalPlayer then
			Abysall.ESPLibrary:UpdateObjectColor(Player.Character, Value)
		end
	end
end)

Toggles.ChestESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Chests do
		if Value then
			local Label
			if Object.Name == "ChestBox" or Object.Name == "ChestBoxLocked" then
				Label = Object:GetAttribute("Locked") and "Locked Chest" or "Chest"
			elseif Object.Name == "Toolbox" or Object.Name == "Toolbox_Locked" then
				Label = Object:GetAttribute("Locked") and "Locked Toolbox" or "Toolbox"
			elseif ChestLabels[Object.Name] and ChestLabels[Object.Name] ~= true then
				Label = ChestLabels[Object.Name]
			end
			if Label then Functions.AddESP({ Object = Object, Text = Label, Color = Options.ChestESPColor.Value }, true) end
		else
			Functions.RemoveESP(Object)
		end
	end
end)

Options.ChestESPColor:OnChanged(function(Value)
	for _, Object in Objects.Chests do Abysall.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Toggles.ItemESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Items do
		if Value then
			local Label = ItemNames[Object.Name] or (Object.Name == "Green_Herb" and "Green Herb")
			if Label then
				Functions.AddESP({ Object = Object, Text = Label, Color = Options.ItemESPColor.Value }, Object:GetAttribute("ParentRoom") ~= nil)
			end
		else
			Functions.RemoveESP(Object)
		end
	end
end)
Options.ItemESPColor:OnChanged(function(Value)
	for _, Object in Objects.Items do Abysall.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Toggles.CurrencyESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Currency do
		if Value then
			local Label
			if Object.Name == "GoldPile" and Object:GetAttribute("GoldValue") then
				Label = "Gold Pile [" .. Object:GetAttribute("GoldValue") .. "]"
			elseif Object.Name == "StardustPickup" then
				Label = "Stardust Pile"
			end
			if Label then Functions.AddESP({ Object = Object, Text = Label, Color = Options.CurrencyESPColor.Value }, true) end
		else
			Functions.RemoveESP(Object)
		end
	end
end)
Options.CurrencyESPColor:OnChanged(function(Value)
	for _, Object in Objects.Currency do Abysall.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Toggles.EntityESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Value then
			local Label = EntityESPLabels[Object.Name]
			if not Label and Entities[Object.Name] then Label = Entities[Object.Name].Alias end
			if Label and Options.EntityESPOptions.Value[Label] then
				Functions.AddESP({ Object = Object, Text = Label, Color = Options.EntityESPColor.Value }, NodeEntities[Label] ~= true)
			else
				Functions.RemoveESP(Object)
			end
		else
			Functions.RemoveESP(Object)
		end
	end
end)

Options.EntityESPOptions:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Toggles.EntityESPToggle.Value then
			local Label = EntityESPLabels[Object.Name]
			if not Label and Entities[Object.Name] then Label = Entities[Object.Name].Alias end
			if Label and Options.EntityESPOptions.Value[Label] then
				Functions.AddESP({ Object = Object, Text = Label, Color = Options.EntityESPColor.Value }, NodeEntities[Label] ~= true)
			else
				Functions.RemoveESP(Object)
			end
		else
			Functions.RemoveESP(Object)
		end
	end
end)

Options.EntityESPColor:OnChanged(function(Value)
	for _, Object in Objects.Entities do Abysall.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Toggles.LadderESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Ladders do
		if Value then Functions.AddESP({ Object = Object, Text = "Ladder", Color = Options.LadderESPColor.Value }, true)
		else Functions.RemoveESP(Object) end
	end
end)
Options.LadderESPColor:OnChanged(function(Value)
	for _, Object in Objects.Ladders do Abysall.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Groupboxes.Visuals_ESP_Settings:AddToggle("ESPRainbow",     { Text = "Rainbow Effect", Default = false, Tooltip = "Makes the esp objects change colour like a rainbow." })
Groupboxes.Visuals_ESP_Settings:AddToggle("ESPShowDistance",{ Text = "Show Distance",  Default = true,  Tooltip = "Shows how far away your character is from the object." })
Groupboxes.Visuals_ESP_Settings:AddDivider()
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPFillTransparency",        { Text = "Fill Transparency",         Min = 0, Max = 1, Default = 0.75, Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPOutlineTransparency",     { Text = "Outline Transparency",      Min = 0, Max = 1, Default = 0,    Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTextTransparency",        { Text = "Text Transparency",         Min = 0, Max = 1, Default = 0,    Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTextOutlineTransparency", { Text = "Text Outline Transparency", Min = 0, Max = 1, Default = 0,    Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPFadeTime",                { Text = "Fade Time",                 Min = 0, Max = 1, Default = 0.25, Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPRenderLimit",             { Text = "Render Limit",              Min = 30, Max = 240, Default = 240, Rounding = 0, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTextSize",                { Text = "Text Size",                 Min = 12, Max = 24, Default = 20, Rounding = 0, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddDropdown("ESPTextFont", {
	Text = "Text Font",
	Values = { "Legacy","Arial","ArialBold","SourceSans","SourceSansBold","SourceSansLight","SourceSansItalic","Bodoni","Garamond","Cartoon","Code","Highway","SciFi","Arcade","Fantasy","Antique","SourceSansSemibold","Gotham","GothamMedium","GothamBold","GothamBlack","AmaticSC","Bangers","Creepster","DenkOne","Fondamento","FredokaOne","GrenzeGotisch","IndieFlower","JosefinSans","Jura","Kalam","LuckiestGuy","Merriweather","Michroma","Nunito","Oswald","PatrickHand","PermanentMarker","Roboto","RobotoCondensed","RobotoMono","Sarpanch","SpecialElite","TitilliumWeb","Ubuntu","BuilderSans","BuilderSansMedium","BuilderSansBold","BuilderSansExtraBold","Arimo","ArimoBold" },
	Default = 12
})
Groupboxes.Visuals_ESP_Settings:AddDivider()
Groupboxes.Visuals_ESP_Settings:AddDropdown("ESPTracersOrigin",  { Text = "Tracer Origin", Values = { "Bottom","Center","Top","Mouse" }, Default = 1 })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTracerThickness",  { Text = "Tracer Thickness", Min = 0.5, Max = 2, Default = 0.75, Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddToggle("ESPTracersToggle",    { Text = "Enable Tracers", Default = false, Tooltip = "Draws a line to highlighted objects." })
Groupboxes.Visuals_ESP_Settings:AddDivider()
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPArrowsRadius",     { Text = "Arrow Radius", Min = 100, Max = 500, Default = 250, Rounding = 0, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddToggle("ESPArrowsToggle",     { Text = "Enable Arrows", Default = false, Tooltip = "Shows arrow that point to off-screen objects." })

Abysall.ESPLibrary:SetRainbow(false)
Abysall.ESPLibrary:SetShowDistance(true)
Abysall.ESPLibrary:SetFillTransparency(0.75)
Abysall.ESPLibrary:SetOutlineTransparency(0)
Abysall.ESPLibrary:SetTextTransparency(0)
Abysall.ESPLibrary:SetTextOutlineTransparency(0)
Abysall.ESPLibrary:SetRenderLimit(240)
Abysall.ESPLibrary:SetFadeTime(0.25)
Abysall.ESPLibrary:SetTextSize(20)
Abysall.ESPLibrary:SetFont(Enum.Font.Highway)
Abysall.ESPLibrary:SetTracers(false)
Abysall.ESPLibrary:SetTracerSize(0.75)
Abysall.ESPLibrary:SetTracerOrigin("Bottom")
Abysall.ESPLibrary:SetArrows(false)
Abysall.ESPLibrary:SetArrowRadius(250)
Abysall.ESPLibrary:SetDistanceSizeRatio(0.8)

Toggles.ESPRainbow:OnChanged(function(V)        Abysall.ESPLibrary:SetRainbow(V) end)
Toggles.ESPShowDistance:OnChanged(function(V)   Abysall.ESPLibrary:SetShowDistance(V) end)
Options.ESPFillTransparency:OnChanged(function(V)        Abysall.ESPLibrary:SetFillTransparency(V) end)
Options.ESPOutlineTransparency:OnChanged(function(V)     Abysall.ESPLibrary:SetOutlineTransparency(V) end)
Options.ESPTextTransparency:OnChanged(function(V)        Abysall.ESPLibrary:SetTextTransparency(V) end)
Options.ESPTextOutlineTransparency:OnChanged(function(V) Abysall.ESPLibrary:SetTextOutlineTransparency(V) end)
Options.ESPFadeTime:OnChanged(function(V)        Abysall.ESPLibrary:SetFadeTime(V) end)
Options.ESPRenderLimit:OnChanged(function(V)     Abysall.ESPLibrary:SetRenderLimit(V) end)
Options.ESPTextSize:OnChanged(function(V)        Abysall.ESPLibrary:SetTextSize(V) end)
Options.ESPTextFont:OnChanged(function(V)        Abysall.ESPLibrary:SetFont(Enum.Font[V]) end)
Toggles.ESPTracersToggle:OnChanged(function(V)   Abysall.ESPLibrary:SetTracers(V) end)
Options.ESPTracersOrigin:OnChanged(function(V)   Abysall.ESPLibrary:SetTracerOrigin(V) end)
Options.ESPTracerThickness:OnChanged(function(V) Abysall.ESPLibrary:SetTracerSize(V) end)
Toggles.ESPArrowsToggle:OnChanged(function(V)    Abysall.ESPLibrary:SetArrows(V) end)
Options.ESPArrowsRadius:OnChanged(function(V)    Abysall.ESPLibrary:SetArrowRadius(V) end)

Tabs.Floors:UpdateWarningBox({
	Visible = true,
	Title = "Compatability Warning",
	Text = "Features highlighted in red do not work in the current floor.",
})

Groupboxes.Floors_Automation = Tabs.Floors:AddRightGroupbox("Automation")
Groupboxes.Floors_Automation:AddToggle("AutoSteerMinecart", {
	Text = "Auto Steer Minecart", Default = false, Tooltip = "Automatically completes the minecart chase.",
	Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Floors_Automation:AddSlider("AutoSteerMinecartTurnDistance", {
	Text = "Turn Distance", Min = 20, Max = 40, Default = 30, Rounding = 0,
	Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Floors_Automation:AddSlider("AutoSteerMinecartDuckDistance", {
	Text = "Crouch Distance", Min = 20, Max = 40, Default = 30, Rounding = 0,
	Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Floors_Automation:AddDivider()
Groupboxes.Floors_Automation:AddToggle("RoomsAutoWalk",             { Text = "Auto Rooms",       Default = false, Tooltip = "Automatically moves and hides from entities in The Rooms." })
Groupboxes.Floors_Automation:AddSlider("RoomsAutoWalkPathfindTimeout", { Text = "Pathfind Timeout", Min = 0.5, Max = 3, Default = 1, Rounding = 1 })
Groupboxes.Floors_Automation:AddToggle("RoomsAutoWalkIgnoreA60",    { Text = "Ignore A-60",      Default = false, Tooltip = "Continues to walk if entity 'A-60' is present, enables position spoof automatically." })
Groupboxes.Floors_Automation:AddToggle("RoomsAutoWalkShowPathToggle", { Text = "Show Path",       Default = false, Tooltip = "Shows the current path of rooms auto-walk." })
Groupboxes.Floors_Automation:AddToggle("RoomsAutoWalkSpoofFootsteps", {
    Text = "Spoof Footsteps", Default = false, Tooltip = "Makes it appear as if your character is walking normally.",
    Disabled = not Functions.CheckCompatability({"hookmetamethod", "newcclosure", "getnamecallmethod"}), DisabledTooltip = Globals.IncompatibleMessage
})

Toggles.RoomsAutoWalk:OnChanged(function()
	for _, Object in Globals.RoomsNodesFolder:GetChildren() do
		if Object.Name == "PathNode" then Object:Destroy() end
	end
end)
Toggles.RoomsAutoWalkShowPathToggle:AddColorPicker("RoomsAutoWalkShowPathColor", { Text = "Path", Default = Color3.fromRGB(0, 255, 0), Transparency = 0 })
Toggles.RoomsAutoWalkShowPathToggle:OnChanged(function(Value)
	for _, Object in Globals.RoomsNodesFolder:GetChildren() do
		if Object.Name == "PathNode" then Object.Transparency = Value and 0.5 or 1 end
	end
end)
Options.RoomsAutoWalkShowPathColor:OnChanged(function(Value)
	for _, Object in Globals.RoomsNodesFolder:GetChildren() do
		if Object.Name == "PathNode" then Object.Color = Value end
	end
end)

Functions.RoomsAutoWalk = {}
Functions.RoomsAutoWalk.GetNearestHidingSpot = function()
	local Nearest = { Distance = math.huge, Object = nil }
	for _, Object in Objects.HidingSpots do
		if Object.PrimaryPart and Object:FindFirstChild("HidePrompt") then
			local Distance = LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)
			if Distance < Nearest.Distance and Object.PrimaryPart.Position.Y > -10 then
				local HiddenPlayer = Object:FindFirstChild("HiddenPlayer", true)
				if HiddenPlayer and not HiddenPlayer.Value then
					Nearest.Distance = Distance
					Nearest.Object = Object
				end
			end
		end
	end
	return Nearest.Object
end

local RoomsEntityList = { "RushMoving","AmbushMoving","BackdoorRush","A60","A120","CustomEntity","GlitchRush","GlitchAmbush" }
Functions.RoomsAutoWalk.GetPathfindTarget = function()
	for _, Object in Services.Workspace:GetChildren() do
		if table.find(RoomsEntityList, Object.Name) and Object.PrimaryPart then
			local Y = Object.PrimaryPart.Position.Y
			if Y > -10 and Y < 150 then
				if Object.Name == "A60" and not Toggles.RoomsAutoWalkIgnoreA60.Value or Object.Name ~= "A60" then
					return Functions.RoomsAutoWalk.GetNearestHidingSpot() or CurrentRooms[tostring(LatestRoom.Value)]:FindFirstChild("RoomExit")
				end
			end
		end
	end
	return CurrentRooms[tostring(LatestRoom.Value)]:FindFirstChild("RoomExit")
end

Connections.RoomsAutoWalkHandler = Services.RunService.Heartbeat:Connect(function()
	if Floor ~= "Rooms" or not Toggles.RoomsAutoWalk.Value or Globals.RoomsAutoWalkActive or not CollisionPart or LatestRoom.Value >= 1000 then return end
	Globals.RoomsAutoWalkActive = true

	local Path = Services.PathfindingService:CreatePath({
		AgentCanJump = true, AgentCanClimb = false, WaypointSpacing = 4,
		AgentRadius = 1.5, AgentHeight = 1.5, Costs = { StuckPart = 8 }
	})

	if Toggles.RoomsAutoWalkIgnoreA60.Value and not Toggles.PositionSpoof.Value then
		Toggles.PositionSpoof:SetValue(true)
	end

	local TargetPart = Functions.RoomsAutoWalk.GetPathfindTarget()
	if not TargetPart then
		Globals.RoomsAutoWalkActive = false
		return
	end

	local TargetPosition
	if TargetPart.Name == "RoomExit" then
		TargetPosition = TargetPart.Position
	elseif TargetPart:FindFirstChild("HidePrompt") then
		for _, Part in TargetPart:GetDescendants() do
			if Part:IsA("BasePart") then Part.CanCollide = false end
		end
		TargetPosition = TargetPart.PrimaryPart.Position
	end

	if CollisionPart.Anchored and not TargetPart:FindFirstChild("HidePrompt") then
		Character:SetAttribute("Hiding", true)
		RemotesFolder.CamLock:FireServer()
		Character:SetAttribute("Hiding", false)
	end

	local CurrentRoom = CurrentRooms[tostring(LatestRoom.Value)]
	if CurrentRoom:FindFirstChild("Door") then
		CurrentRoom.Door.Door.CanCollide = false
	end

	if not TargetPosition or LocalPlayer:DistanceFromCharacter(TargetPosition) >= 750 then
		Globals.RoomsAutoWalkActive = false
		return
	end

	Path:ComputeAsync(CollisionPart.Position, TargetPosition)
	local Waypoints = Path:GetWaypoints()

	if #Waypoints == 0 then
		local RoomExit = CurrentRoom:FindFirstChild("RoomExit")
		if RoomExit then Humanoid:MoveTo(RoomExit.Position) end
		Globals.RoomsAutoWalkActive = false
		return
	end

	for _, Node in Globals.RoomsNodesFolder:GetChildren() do
		if Node.Name == "PathNode" then Node:Destroy() end
	end

	for _, Waypoint in Waypoints do
		local Block = Instance.new("Part", Globals.RoomsNodesFolder)
		Block.Transparency = Toggles.RoomsAutoWalkShowPathToggle.Value and 0.5 or 1
		Block.Size = Vector3.one
		Block.Position = Waypoint.Position
		Block.Shape = Enum.PartType.Ball
		Block.CanCollide = false
		Block.Anchored = true
		Block.Name = "PathNode"
		Block.Color = Options.RoomsAutoWalkShowPathColor.Value
		Block.Material = Enum.Material.Neon
	end

	local Stuck = false
	for _, Waypoint in Waypoints do
		if Stuck or not Toggles.RoomsAutoWalk.Value then break end

		local Finished = false
		local Start = tick()

		local StepConnection = Services.RunService.RenderStepped:Connect(function()
			if Stuck or not Toggles.RoomsAutoWalk.Value then Finished = true return end

			local NewTarget = Functions.RoomsAutoWalk.GetPathfindTarget()
			if NewTarget and NewTarget:FindFirstChild("HidePrompt") and not TargetPart:FindFirstChild("HidePrompt") then
				Finished = true return
			end
			if TargetPart:FindFirstChild("HidePrompt") then
				local HidePrompt = TargetPart:FindFirstChild("HidePrompt")
				if LocalPlayer:DistanceFromCharacter(TargetPosition) < HidePrompt.MaxActivationDistance
					and Character:GetAttribute("Hiding") ~= true
				then
					Functions.ForceFirePrompt(HidePrompt)
				end
			end
			local FlatPos = Vector3.new(Waypoint.Position.X, RootPart.Position.Y, Waypoint.Position.Z)
			if LocalPlayer:DistanceFromCharacter(FlatPos) < 5 then Finished = true end
			Humanoid:MoveTo(Waypoint.Position)
		end)

		while not Finished do
			if tick() - Start > Options.RoomsAutoWalkPathfindTimeout.Value then
				local StuckBlock = Instance.new("Part", Globals.RoomsNodesFolder)
				StuckBlock.Transparency = 1
				StuckBlock.Size = Vector3.one
				StuckBlock.CFrame = Collision.CFrame
				StuckBlock.Shape = Enum.PartType.Ball
				StuckBlock.CanCollide = false
				StuckBlock.Anchored = true
				StuckBlock.Name = "StuckPart"
				local Modifier = Instance.new("PathfindingModifier", StuckBlock)
				Modifier.Label = "StuckPart"
				Stuck = true
				break
			end
			task.wait()
		end
		StepConnection:Disconnect()
		Humanoid:MoveTo(RootPart.Position)
	end

	Globals.RoomsAutoWalkActive = false
end)

Connections.RoomsHandler = CurrentRooms.ChildAdded:Connect(function(Room)
	for _, Object in Globals.RoomsNodesFolder:GetChildren() do
		if Object.Name == "StuckPart" then Object:Destroy() end
	end

	if Room:GetAttribute("RawName") and string.find(Room:GetAttribute("RawName"), "Eyestalk") then
        local PreviousNode = nil

		local function CreateEyestalkNode(WaypointPos)
			local NewNode = Instance.new("Part")
			NewNode.Size = Vector3.one
			NewNode.Transparency = 1
			NewNode.Parent = Globals.SeekNodesFolder
			NewNode.Anchored = true
			NewNode.Position = WaypointPos
			NewNode.CanCollide = false
			NewNode.Name = "SeekLightNode"

			local PrevNode = PreviousNode or NewNode
			PreviousNode = NewNode

			local NewBeam = Instance.new("Beam")
			NewBeam.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Options.ShowEyestalkPathColor.Value), ColorSequenceKeypoint.new(1, Options.ShowEyestalkPathColor.Value) })
			NewBeam.FaceCamera = true
			NewBeam.Width0 = 0.2
			NewBeam.Width1 = 0.2
			NewBeam.Brightness = 10
			NewBeam.LightInfluence = 0
			NewBeam.LightEmission = 0
			NewBeam.Enabled = true

			local Vis = Toggles.ShowEyestalkPathToggle.Value and 0 or 1
			NewBeam.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, Vis), NumberSequenceKeypoint.new(1, Vis) })
			NewBeam.Parent = Globals.SeekNodesFolder

			local A0 = Instance.new("Attachment", NewNode)
			local A1 = Instance.new("Attachment", PrevNode)
			NewBeam.Attachment0 = A0
			NewBeam.Attachment1 = A1

			table.insert(Objects.EyestalkHighlights, NewBeam)
		end

		Room:WaitForChild("RoomEntrance", 9e9)
		Room:WaitForChild("RoomExit", 9e9)

		while not Room:GetAttribute("PathFound") do
			if Toggles.ShowEyestalkPathToggle.Value then
				local EyePath = game:GetService("PathfindingService"):CreatePath({
					AgentCanJump = false, AgentCanClimb = false, WaypointSpacing = 2, AgentRadius = 1, AgentHeight = 1
				})
				EyePath:ComputeAsync(RootPart.Position, Room.RoomExit.Position)
				if EyePath.Status == Enum.PathStatus.Success then
					Room:SetAttribute("PathFound", true)
					for _, Waypoint in EyePath:GetWaypoints() do
						CreateEyestalkNode(Waypoint.Position)
						task.wait()
					end
                    break
				end
			end
			task.wait(0.25)
		end
	end
end)

Groupboxes.Floors_Completion = Tabs.Floors:AddRightGroupbox("Completion")
Groupboxes.Floors_Completion:AddButton({
    Text = "Auto Complete Dam Seek",
    Tooltip = "Automatically teleports to and interacts with each water pump.",
    Func = function()
        if LatestRoom.Value < 100 or Floor ~= "Mines" then
            Functions.Notify({Title = "You must be in Room 200 to do this."})
            return
        end

		local IsCutscene = false
		local CutsceneConnection = RemotesFolder.Cutscene.OnClientEvent:Connect(function()
			IsCutscene = true
			task.wait(7)
			IsCutscene = false
		end)

        local function GetNextPump()
            local Highest = {
                Height = -69420,
                Object = nil
            }
            for _, Object in pairs(Objects.Objectives) do
                if Object.Name == "WaterPump" and Object:GetAttribute("Abysall_Completed") ~= true then
                    if Object.PrimaryPart and Object.PrimaryPart.Position.Y > Highest.Height then
                        Highest.Object = Object
                        Highest.Height = Object.PrimaryPart.Position.Y
                    end
                end
            end
            return Highest.Object
        end

        local function HandlePump(Pump)

            while task.wait(0.1) do
				if IsCutscene then
					continue
				end

                Character:PivotTo(Pump:GetPivot())

                local Prompt = Pump:FindFirstChild("ValvePrompt", true)
                if Prompt then
                    Functions.ForceFirePrompt(Prompt)
                end

                if Pump:GetAttribute("Abysall_Completed") then
                    break
                end
            end
        end

        Functions.Notify({Title = "Attempting to complete the valves.", Body = "Please wait."})
        while task.wait(0.1) do
            local Pump = GetNextPump()
            if Pump then
                HandlePump(Pump)
            else
                break
            end
        end
        Functions.Notify({Title = "Successfully completed the valves."})
    end
})

Groupboxes.Floors_Completion:AddButton({
    Text = "Auto Complete Cringle",
    Tooltip = "Instantly completes the quest.",
    Func = function()
        local TouchPart = CurrentRooms:FindFirstChild("RippleExitDoor", true)
        if TouchPart then
            Character:PivotTo(TouchPart:GetPivot())
        end
    end
})

Groupboxes.Floors_Visuals = Tabs.Floors:AddLeftGroupbox("Visuals")
Groupboxes.Floors_Visuals:AddToggle("ShowSeekPathToggle", {
	Text = "Show Seek Path", Default = false, Tooltip = "Shows you the correct path in seek chases.",
	Risky = Floor ~= "Mines"
})
Toggles.ShowSeekPathToggle:AddColorPicker("ShowSeekPathColor", { Text = "Seek Path", Default = Color3.fromRGB(0, 255, 0), Transparency = 0 })

local function UpdateBeamVisibility(BeamTable, ColorKey, Visible)
	local Vis = Visible and 0 or 1
	local Seq = NumberSequence.new({ NumberSequenceKeypoint.new(0, Vis), NumberSequenceKeypoint.new(1, Vis) })
	for _, Beam in BeamTable do Beam.Transparency = Seq end
end
local function UpdateBeamColor(BeamTable, Value)
	local Seq = ColorSequence.new({ ColorSequenceKeypoint.new(0, Value), ColorSequenceKeypoint.new(1, Value) })
	for _, Beam in BeamTable do Beam.Color = Seq end
end

Toggles.ShowSeekPathToggle:OnChanged(function(V)  UpdateBeamVisibility(Objects.SeekHighlights, "ShowSeekPathColor", V) end)
Options.ShowSeekPathColor:OnChanged(function(V)   UpdateBeamColor(Objects.SeekHighlights, V) end)

Groupboxes.Floors_Visuals:AddToggle("ShowEyestalkPathToggle", {
	Text = "Show Eyestalk Path", Default = false, Tooltip = "Shows you the correct path in the eyestalk chase.",
	Risky = Floor ~= "Garden"
})
Toggles.ShowEyestalkPathToggle:AddColorPicker("ShowEyestalkPathColor", { Text = "Eyestalk Path", Default = Color3.fromRGB(0, 255, 0), Transparency = 0 })
Toggles.ShowEyestalkPathToggle:OnChanged(function(V) UpdateBeamVisibility(Objects.EyestalkHighlights, "ShowEyestalkPathColor", V) end)
Options.ShowEyestalkPathColor:OnChanged(function(V)  UpdateBeamColor(Objects.EyestalkHighlights, V) end)

Groupboxes.Floors_Bypass = Tabs.Floors:AddLeftGroupbox("Bypass")
Groupboxes.Floors_Bypass:AddToggle("RemoveSeekTrigger", {
	Text = "Delete Seek Trigger", Default = false, Tooltip = "Diables the 'Seek' chase trigger.",
	Risky = not (Floor == "Fools" or Floor == "OldHotel"),
	Disabled = not Functions.CheckCompatability({"firetouchinterest"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Floors_Bypass:AddToggle("RemoveFigure", {
	Text = "Delete Figure", Default = false, Tooltip = "Completely removes the entity 'Figure' (doesn't always work).",
	Risky = not (Floor == "Fools" or Floor == "OldHotel" or Floor == "Mines"),
	Disabled = not Functions.CheckCompatability({"isnetworkowner"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Floors_Bypass:AddToggle("AutoRevive", {
	Text = "Infinite Revives", Default = false, Tooltip = "Automatically revives after dying, with unlimited respawns.",
	Risky = not (Floor == "Fools" or Floor == "OldHotel")
})
Groupboxes.Floors_Bypass:AddToggle("FigureGodmode", {
	Text = "Figure Godmode", Default = false, Tooltip = "Prevents 'Figure' from hurting you.",
	Risky = not (Floor == "Fools" or Floor == "OldHotel")
})
Groupboxes.Floors_Bypass:AddDivider()
Groupboxes.Floors_Bypass:AddToggle("RemoveBasementGate",  { Text = "Remove Basement Gate",   Default = false, Tooltip = "Removes the gate from basement rooms.",            Risky = not (Floor == "Fools" or Floor == "OldHotel") })
Groupboxes.Floors_Bypass:AddToggle("RemovePaintingsDoor", { Text = "Remove Paintings Door",  Default = false, Tooltip = "Removes the fireplace doors from painting rooms.", Risky = not (Floor == "Fools" or Floor == "OldHotel") })
Groupboxes.Floors_Bypass:AddToggle("RemoveSkeletonDoor",  { Text = "Remove Skeleton Door",   Default = false, Tooltip = "Removes the skeleton door from the infirmary.",    Risky = Floor ~= "Fools" })

local ObstructionNames = { ThingToOpen = "RemoveBasementGate", MovingDoor = "RemovePaintingsDoor", Wax_Door = "RemoveSkeletonDoor" }
for ObjName, ToggleName in ObstructionNames do
	Toggles[ToggleName]:OnChanged(function(Value)
		for _, Object in Objects.Obstructions do
			if Object.Name == ObjName then
				Object:PivotTo(Value and CFrame.new(-10000, -10000, -10000) or Object:GetAttribute("OriginalPosition"))
			end
		end
	end)
end

Groupboxes.Floors_Farming = Tabs.Floors:AddLeftGroupbox("Farming")
Groupboxes.Floors_Farming:AddToggle("KnobFarm", {
    Text = "Knob Farm",
    Default = false,
    Tooltip = "Automatically gains knobs for you, dies and revives repeatedly.",
})

Groupboxes.Floors_Farming:AddButton({
    Text = "Start Knob Farm",
    Tooltip = "Starts farming knobs, click this when you have enough gold.",
    Func = function()
		if LatestRoom.Value ~= 0 then
			Functions.Notify({Title = "You must be in Room 0 to use this."})
			return
		end

		if LocalPlayer.PlayerGui:FindFirstChild("TopbarUI") then 
			local GoldCount = LocalPlayer.PlayerGui.TopbarUI.Topbar.StatsTopbarHandler.StatModules.Gold.GoldVal
			if GoldCount.Value <= 0 then
				Functions.Notify({Title = "You must have gold to do this."})
				return
			end
		end

        Globals.KnobFarmStarted = true
    end
})

Groupboxes.Floors_Farming:AddDivider()
Groupboxes.Floors_Farming:AddButton({
	Text = "Start Death Farm",
	DoubleClick = true,
	Tooltip = "Automatically farms deaths, joining new runs.",
	Func = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/Scripts/DeathFarm.luau"))()
	end,

	Disabled = not Functions.CheckCompatability({"fireproximityprompt", "firesignal"}),
	DisabledTooltip = Globals.ImcompatibleMessage
})
Groupboxes.Floors_Farming:AddButton({
	Text = "Copy Death Farm Loadstring",
	DoubleClick = false,
	Tooltip = "Copies the death farm loadstring to your clipboard.",
	Func = function()
		toclipboard([==[
			loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/Scripts/DeathFarm.luau"))()
		]==])
		Library:Notify("Loadstring has been copied to your clipboard.")
	end,

	Disabled = not Functions.CheckCompatability({"fireproximityprompt", "firesignal"}),
	DisabledTooltip = Globals.ImcompatibleMessage
})

Toggles.KnobFarm:OnChanged(function(Value)
    if Value then
        Functions.Notify({Title = "Please collect some gold to earn knobs.", Body = "Click 'Start Knob Farm' when you're ready."})
	else
		Globals.KnobFarmStarted = false
    end
end)

Globals.KnobFarmActive = false
Globals.KnobFarmStarted = false
Connections.KnobFarm = Services.RunService.Heartbeat:Connect(function()
	if Toggles.KnobFarm.Value and Globals.KnobFarmStarted then
		if not Globals.KnobFarmActive then
			Globals.KnobFarmActive = true
			if Functions.CheckCompatability({"replicatesignal"}) then
				Abysall.Environment.replicatesignal(LocalPlayer.Kill)
			else
				RemotesFolder.Underwater:FireServer(true)
			end
			while task.wait() do
				if LocalPlayer:GetAttribute("Alive") then
					break
				end
			end
			RemotesFolder.Statistics:FireServer()
			task.wait(0.25)
			Globals.KnobFarmActive = false
		end
	end
end)

local MainHook
local OtherHook
if Functions.CheckCompatability({"hookmetamethod", "newcclosure", "getnamecallmethod"}) then
	MainHook = Abysall.Environment.hookmetamethod(game, "__namecall", Abysall.Environment.newcclosure(function(Self, ...)
		local Args = { ... }
		if Abysall and Abysall.Environment then
			local Method = Abysall.Environment.getnamecallmethod()

			if Self.Name == "Crouch" and Method == "FireServer" then
				if Toggles.CrouchSpoof.Value or Toggles.PositionSpoof.Value then
					Args[1] = true
				end
				Args[2] = true
			end

			if Self.Name == "ClutchHeartbeat" and Method == "FireServer" and Toggles.AutoHeartbeatMinigame.Value or Self.Name == "HideMonster" and Method == "FireServer" and Toggles.AutoHeartbeatMinigame.Value then
				return
			end

			if Self.Name == "MotorReplication" and Method == "FireServer" then
				local DoBypass = (Toggles.BypassEyes.Value and Globals.IsEyes) or (Toggles.BypassLookman.Value and Globals.IsLookman)
				if DoBypass then
					if Floor == "Fools" or Floor == "OldHotel" then
						Args[1] = 0 Args[2] = (Globals.SpoofOffset == 200 and 65 or -65) Args[3] = 0 Args[4] = false
					else
						Args[1] = -650
					end
				end
			end
		end
		return MainHook(Self, table.unpack(Args))
	end))

    OtherHook = Abysall.Environment.hookmetamethod(game, "__index", Abysall.Environment.newcclosure(function(Self, Property)
        local Real = OtherHook(Self, Property)

        if Property == "MoveDirection" and Self == Humanoid and Globals.RoomsAutoWalkActive and Toggles.RoomsAutoWalkSpoofFootsteps.Value and Floor == "Rooms" and not Character:GetAttribute("Hiding") then
            return RootPart.CFrame.LookVector
        end
        
        return Real
    end))
end

if Services.ReplicatedStorage:FindFirstChild("ModulesClient") then
	ClientModules = Services.ReplicatedStorage.ModulesClient
else
	ClientModules = Services.ReplicatedStorage.ClientModules
end

Modules = {
	Glitch         = ClientModules.EntityModules.Glitch,
	Shade          = ClientModules.EntityModules.Shade,
	Void           = ClientModules.EntityModules:FindFirstChild("Void"),
	SpiderJumpscare = nil,
	A90            = nil,
	Screech        = nil,
	Dread          = nil,
	GlitchScreech  = nil,
}

local CharacterOldConnectionKeys = {
	"MainHandler", "JumpHandler", "SlideHandler", "LibraryCodeHandler1", "LibraryCodeHandler2",
	"OxygenConnection", "AnimationHandler", "AutoHideConnection", "AutoReviveHandler",
	"SHMFixer", "AnticheatDisabler", "AnticheatEnableDetector1", "AnticheatEnableDetector2",
	"AutoSteerMinecartDuckHandler", "AutoSolveAnchorsConnection", "InfiniteJumpsConnection1", "InfiniteJumpsConnection2",
	"FootstepHandler"
}

Globals.IsTyping = false
Connections.TextBoxConnection1 = Services.UserInputService.TextBoxFocused:Connect(function()
	Globals.IsTyping = true
end)
Connections.TextBoxConnection2 = Services.UserInputService.TextBoxFocusReleased:Connect(function()
	Globals.IsTyping = false
end)

Functions.HandleCharacter = function(NewCharacter)
	for _, Key in CharacterOldConnectionKeys do
		if Connections[Key] then
			Connections[Key]:Disconnect()
			Connections[Key] = nil
		end
	end

	while not LocalPlayer.PlayerGui:FindFirstChild("MainUI") do
		task.wait()
	end

	Character = NewCharacter
	Humanoid = NewCharacter:WaitForChild("Humanoid", 9e9)
	RootPart = NewCharacter:FindFirstChild("HumanoidRootPart")
	Camera   = Services.Workspace.CurrentCamera

	Globals.OldCamera = Camera
	Globals.MainUI = LocalPlayer.PlayerGui.MainUI

	Collision = NewCharacter:WaitForChild("Collision")
	CollisionPart  = NewCharacter:FindFirstChild("CollisionPart") or NewCharacter:FindFirstChild("Collision")
	CollisionClone = Collision:Clone()
	CollisionClone.Parent = NewCharacter
	CollisionClone.Name = "CollisionClone"
	CollisionClone.Massless = true

	CollisionPartClone = CollisionPart:Clone()
	CollisionPartClone.Parent = NewCharacter
	CollisionPartClone.Name = "CollisionPartClone"
	CollisionPartClone.CanCollide = false
	CollisionPartClone.Massless = true

	if CollisionPartClone:FindFirstChild("CollisionCrouch") then
		CollisionPartClone.CollisionCrouch:Destroy()
	end

	Character:SetAttribute("SpeedBoost", 0)
	Character:SetAttribute("SpeedBoostBehind", 0)
	Character:SetAttribute("SpeedBoostExtra", 0)

	OldJump  = NewCharacter:GetAttribute("CanJump")
	OldSlide = NewCharacter:GetAttribute("CanSlide")

	if Toggles.EnableCharacterJump.Value  then Character:SetAttribute("CanJump",  true) end
	if Toggles.EnableCharacterSlide.Value then Character:SetAttribute("CanSlide", true) end

	if Functions.CheckCompatability({"require"}) then
		Main_Game = Abysall.Environment.require(Globals.MainUI.Initiator.Main_Game)
	end

	if Main_Game and Toggles.RemoveCameraBobbing.Value then
		Main_Game.spring.Speed = 9e9
	end

	if Main_Game and Functions.CheckCompatability({"require"}) then
		local Controls = require(LocalPlayer.PlayerScripts.PlayerModule):GetControls()
		local OriginalGetMoveVector = Controls.GetMoveVector
		Globals.OriginalGetMoveVector = OriginalGetMoveVector
		Controls.GetMoveVector = function(...)
			if Toggles.AutoSteerMinecart.Value and Floor == "Mines" then
				local Node = Globals.NearestTurnNode
				if Node and Functions.GetMinecart() then
					local Turn = Node:GetAttribute("Turn")
					return Turn == "Left" and Vector3.new(-1, 0, 0) or Turn == "Right" and Vector3.new(1, 0, 0) or Vector3.zero
				end
			end
			return OriginalGetMoveVector(...)
		end
	end

	Globals.AutoMinecartDucked = false
	Globals.LastDuck = tick()
	Connections.AutoSteerMinecartDuckHandler = Services.RunService.Heartbeat:Connect(function()
		if not Toggles.AutoSteerMinecart.Value or not Functions.GetMinecart() or tick() - Globals.LastDuck < 0.1 then return end
		Globals.NearestTurnNode = Functions.GetNearestTurnNode()

		if not Globals.AutoMinecartDucked and Functions.GetNearestDuckBoard() then
			Main_Game.crouch(true)
			Globals.AutoMinecartDucked = true
		elseif not Functions.GetNearestDuckBoard() and Globals.AutoMinecartDucked then
			Main_Game.crouch(false)
			Globals.AutoMinecartDucked = false
		end
		if Main_Game then
			Main_Game.fovtarget = Options.FieldOfView.Value
		else
			Camera.FieldOfView = Options.FieldOfView.Value
		end
		Globals.LastDuck = tick()
	end)

	Globals.AnticheatDisabled = false

	local UIModules = Globals.MainUI.Initiator.Main_Game.RemoteListener.Modules
	Modules.A90             = UIModules:FindFirstChild("A90")
	Modules.Screech         = UIModules.Screech
	Modules.Dread           = UIModules:FindFirstChild("Dread")
	Modules.SpiderJumpscare = UIModules.SpiderJumpscare

	if Toggles.RemoveScreech.Value    then Modules.Screech.Name = "Screech_Disabled" end
	if Toggles.RemoveA90.Value and Modules.A90   then Modules.A90.Name = "A90_Disabled" end
	if Toggles.RemoveDread.Value and Modules.Dread then Modules.Dread.Name = "Dread_Disabled" end
	if Toggles.DisableTimothyJumpscare.Value then Modules.SpiderJumpscare.Name = "SpiderJumpscare_Disabled" end

	if Toggles.DisableHideVignette.Value then
		local Vignette = Globals.MainUI:FindFirstChild("HideVignette") or Globals.MainUI.MainFrame:FindFirstChild("HideVignette")
		if Vignette then Vignette.Image = "Disabled" end
	end
	if Toggles.RemoveInteractingSounds.Value then
		local PS = Globals.MainUI.Initiator.Main_Game.PromptService
		PS.Triggered.Volume = 0
		PS.Holding.Volume   = 0
		PS.Notification.Volume = 0
		Globals.MainUI.Initiator.Main_Game.Reminder.Caption.Volume = 0
	end
	if Toggles.DisableEntityJumpscares.Value then
		local JS = Globals.MainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscares")
		if JS then JS.Name = "Jumpscares_Disabled" end
	end
    local Cutscenes = Globals.MainUI.Initiator.Main_Game.RemoteListener.Cutscenes
    for _, Object in pairs(Cutscenes:GetChildren()) do
        if table.find(CutsceneNames, Object.Name) and Object:IsA("ModuleScript") then
            Object:SetAttribute("OriginalName", Object.Name)
            if Toggles.RemoveCutscenes.Value then
                Object.Name = Object.Name .. "_Disabled"
            end
        end
    end
    for _, Object in pairs(FloorReplicated:GetChildren()) do
        if table.find(CutsceneNames, Object.Name) and Object:IsA("ModuleScript") then
            Object:SetAttribute("OriginalName", Object.Name)
            if Toggles.RemoveCutscenes.Value then
                Object.Name = Object.Name .. "_Disabled"
            end
        end
    end

	CustomPhysics = PhysicalProperties.new(
		100,
		RootPart.CustomPhysicalProperties.Friction,
		RootPart.CustomPhysicalProperties.Elasticity,
		RootPart.CustomPhysicalProperties.FrictionWeight,
		RootPart.CustomPhysicalProperties.ElasticityWeight
	)
	for _, Part in NewCharacter:GetDescendants() do
		if Part:IsA("BasePart") then
			PartProperties[Part] = Part.CustomPhysicalProperties
			if Toggles.RemoveAcceleration.Value then
				Part.CustomPhysicalProperties = CustomPhysics
			end
		end
	end

	Connections.LibraryCodeHandler1 = LocalPlayer.PlayerGui.PermUI.Hints.ChildAdded:Connect(function()
		if Toggles.NotifyLibraryCode.Value then
			local Code = Functions.GetLibraryCode()
			if Code and not Code:find("_") and not Globals.LibraryCodeFound then
				local Lock = Services.Workspace:FindFirstChild("Padlock", true)
				Functions.Notify({ Title = "Padlock code found!", Body = "The code is: '" .. Code .. "'", Time = Toggles.NotifyKeepNotifications.Value and Lock or 15 })
				Globals.LibraryCodeFound = true
			end
		end
	end)

	Connections.LibraryCodeHandler2 = Character.ChildAdded:Connect(function(Child)
		if (Child.Name == "LibraryHintPaper" or Child.Name == "LibraryHintPaperHard") and Toggles.NotifyLibraryCode.Value then
			local Code = Functions.GetLibraryCode()
			if Code and not Code:find("_") and not Globals.LibraryCodeFound then
				local Lock = Services.Workspace:FindFirstChild("Padlock", true)
				Functions.Notify({ Title = "Padlock code found!", Body = "The code is: '" .. Code .. "'", Time = Toggles.NotifyKeepNotifications.Value and Lock or 15 })
				Globals.LibraryCodeFound = true
			end
		end
	end)

	Connections.FootstepHandler = Character.ChildAdded:Connect(function(Object)
		if Object:IsA("Sound") and Object.Name == "Sound" and Toggles.RemoveFootstepSounds.Value then
			Object.Volume = 0
		end
	end)

	Globals.OldOxygen = Character:GetAttribute("Oxygen")
	Connections.OxygenConnection = Character:GetAttributeChangedSignal("Oxygen"):Connect(function()
		local NewOxy = Character:GetAttribute("Oxygen")
		if NewOxy < Globals.OldOxygen and Toggles.NotifyOxygen.Value then
			Functions.Caption(Functions.FormatOxygen(NewOxy), true)
		end
		Globals.OldOxygen = NewOxy
	end)

	Connections.AutoReviveHandler = LocalPlayer:GetAttributeChangedSignal("Alive"):Connect(function()
		if LocalPlayer:GetAttribute("Alive") == false and Toggles.AutoRevive.Value then
			if Floor == "Fools" or Floor == "OldHotel" then
				while LocalPlayer:GetAttribute("Alive") ~= true do
					RemotesFolder.Revive:FireServer()
					task.wait(0.5)
				end
			end
		end
	end)

	Connections.SHMFixer = RootPart:GetPropertyChangedSignal("Anchored"):Connect(function()
		task.wait()
		if Floor == "Fools" and RootPart.Anchored and Character:GetAttribute("Hiding") ~= true then
			RootPart.Anchored = false
		end
	end)

	Connections.AnticheatDisabler = Character:GetAttributeChangedSignal("Climbing"):Connect(function()
		if Character:GetAttribute("Climbing") == true and Toggles.DisableAnticheat.Value and not Globals.AnticheatDisabled then
			task.wait(0.25)
			Character:SetAttribute("Climbing", false)
			Functions.Notify({ Title = "Successfully disabled the anticheat.", Body = "It will be re-enabled after a cutscene or halt room." })
			Globals.AnticheatDisabled = true
		end
	end)

	Connections.AnticheatEnableDetector1 = RemotesFolder:WaitForChild("Cutscene").OnClientEvent:Connect(function(CutsceneName)
		if Globals.AnticheatDisabled and not CutsceneName:find("SewerSeek") then
			Globals.AnticheatDisabled = false
			Functions.Notify({ Title = "The anticheat has been re-enabled.", Body = "Interact with a ladder to disable it again." })
		end
	end)

	Connections.AnticheatEnableDetector2 = RemotesFolder:WaitForChild("UseEnemyModule").OnClientEvent:Connect(function(ModuleName)
		if ModuleName == "Void" or ModuleName == "Glitch" then
			if Globals.AnticheatDisabled then
				Globals.AnticheatDisabled = false
				Functions.Notify({ Title = "The anticheat has been re-enabled.", Body = "Interact with a ladder to disable it again." })
			end
			LocalPlayer:SetAttribute("CurrentRoom", LatestRoom.Value)
		end
	end)

	Connections.AnimationHandler = Character.ChildAdded:Connect(function()
		local ToolNames = { "Lockpick","Shears","SkeletonKey","Key","GeneratorFuse","KeyElectrical","KeyBackdoor","KeyIron", "Multitool" }
		local Tool
		for _, Name in ToolNames do
			Tool = Character:FindFirstChild(Name)
			if Tool then break end
		end
		if not Tool then return end

		local UseAnim = Tool:FindFirstChild("use", true) or Tool:FindFirstChild("promptanim", true)
		if UseAnim then
			UseAnim = Humanoid:LoadAnimation(UseAnim)
			UseAnim.Priority = Enum.AnimationPriority.Action4
			Globals.UseAnimation = UseAnim
		end
		local UseAnimBreak = Tool:FindFirstChild("usefinish", true) or Tool:FindFirstChild("promptanimend", true) or Tool:FindFirstChild("lockpickuse", true)
		if UseAnimBreak then
			UseAnimBreak = Humanoid:LoadAnimation(UseAnimBreak)
			UseAnimBreak.Priority = Enum.AnimationPriority.Action4
			Globals.UseAnimationBreak = UseAnimBreak
		end
	end)

	Connections.JumpHandler = Character:GetAttributeChangedSignal("CanJump"):Connect(function()
		local Val = Character:GetAttribute("CanJump")
		if Toggles.EnableCharacterJump.Value and Val ~= true or not Toggles.EnableCharacterJump.Value then
			OldJump = Val
		end
		if Toggles.EnableCharacterJump.Value then Character:SetAttribute("CanJump", true) end
	end)

	Connections.SlideHandler = Character:GetAttributeChangedSignal("CanSlide"):Connect(function()
		local Val = Character:GetAttribute("CanSlide")
		if Toggles.EnableCharacterSlide.Value and Val ~= true or not Toggles.EnableCharacterSlide.Value then
			OldSlide = Val
		end
		if Toggles.EnableCharacterSlide.Value then Character:SetAttribute("CanSlide", true) end
	end)

	Connections.InfiniteJumpsConnection1 = Services.UserInputService.InputBegan:Connect(function(Input)
		if Input.KeyCode == Enum.KeyCode.Space and Toggles.InfiniteJumps.Value and not Globals.IsTyping then
			Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)

	local JumpButton = Globals.MainUI.MainFrame.MobileButtons:FindFirstChild("JumpButton")
	if JumpButton then
		Connections.InfiniteJumpsConnection2 = JumpButton.MouseButton1Down:Connect(function()
			if Toggles.InfiniteJumps.Value then
				Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	end

	Globals.SpoofOffset = 0
	Globals.LastAutoHide = tick()
	Connections.AutoHideConnection = Services.RunService.Heartbeat:Connect(function()
		if not Toggles.AutoClosetToggle.Value or tick() - Globals.LastAutoHide <= 0.1 then
			Globals.AutoClosetActive = false
			return
		end
		local Entity = Functions.GetNearestEntity(true, Options.AutoClosetEntityList.Value)
		if Entity then
			local Closet = Functions.GetNearestHidingSpot()
			if Character:GetAttribute("Hiding") ~= true and Closet then
				Globals.AutoClosetActive = true
				Functions.ForceFirePrompt(Closet.HidePrompt)
			end
			if Character:GetAttribute("Hiding") then
				if Toggles.SpectateEntityToggle.Value and Entity.PrimaryPart then
					Globals.SpectateEntity = Entity
				end
			end
		elseif Character:GetAttribute("Hiding") == true then
			Globals.SpectateEntity = nil
			Globals.AutoClosetActive = false
			RemotesFolder.CamLock:FireServer()
		else
			Globals.SpectateEntity = nil
		end
		Globals.LastAutoHide = tick()
	end)

	Globals.LastAutoAnchor = tick()
	Connections.AutoSolveAnchorsConnection = Services.RunService.Heartbeat:Connect(function()
		if not Toggles.AutoSolveAnchors.Value then return end
		if not Globals.MainUI:FindFirstChild("AnchorHintFrame") then return end
		if tick() - Globals.LastAutoAnchor <= 0.1 then return end
		local Anchor = Functions.GetCurrentAnchor()
		if Anchor and LocalPlayer:DistanceFromCharacter(Anchor.PrimaryPart.Position) < Anchor.ActivateEventPrompt.MaxActivationDistance and not Anchor:GetAttribute("Activated") then
			Anchor:WaitForChild("AnchorRemote"):InvokeServer(Globals.MainUI.AnchorHintFrame.Code.Text)
		end
		Globals.LastAutoAnchor = tick()
	end)

	Globals.ManipulateBody = Instance.new("BodyVelocity")
	Globals.ManipulateBody.MaxForce = Vector3.new(9e9, 9e9, 9e9)

	Globals.FlyBody = Instance.new("BodyVelocity")
	Globals.FlyBody.MaxForce = Vector3.new(9e9, 9e9, 9e9)

	Globals.SelfKilled = false
	Globals.ThirdPersonParts = {}
	for _, Object in Character:GetDescendants() do
		if Object:IsA("Accessory") and Object:FindFirstChild("Handle") then
			table.insert(Globals.ThirdPersonParts, Object.Handle)
		end
	end
	table.insert(Globals.ThirdPersonParts, Character:WaitForChild("Head"))

	Globals.LastAnimationCheck = tick()
	Globals.LastCrouchFire = tick()
	Globals.OriginalC1 = Character.LowerTorso.Root.C1

	local RayParams = RaycastParams.new()
	RayParams.FilterType = Enum.RaycastFilterType.Exclude

	local MainFrame = Globals.MainUI:FindFirstChild("MainFrame")
	if MainFrame and MainFrame:FindFirstChild("SurgeVignette") then
		Globals.SurgeFrame = MainFrame.SurgeVignette
		if Toggles.RemoveSurge.Value then
			Globals.SurgeFrame.Name = "SurgeVignette_Disabled"
		end
	end

	Connections.MainHandler = Services.RunService.RenderStepped:Connect(function()
		if Services.Workspace:FindFirstChild("Camera") then
			Camera = Services.Workspace:FindFirstChild("Camera")
		end

		if Toggles.SpeedBoostToggle.Value then
			Humanoid.WalkSpeed = Functions.GetCurrentSpeed() + Options.SpeedBoostSlider.Value
		end

		if Globals.Lagging or (Options.SpeedBoostSlider.Value <= 6 and Options.FlySpeed.Value <= 21) then
			CollisionPartClone.Massless = true
		end

		Globals.IsEyes    = Services.Workspace:FindFirstChild("Eyes") ~= nil or Services.Workspace:FindFirstChild("Lookman") ~= nil
		Globals.IsLookman = Services.Workspace:FindFirstChild("BackdoorLookman") ~= nil

		if Toggles.AmbientToggle.Value then
			Services.TweenService:Create(Services.Lighting, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), { Ambient = Options.AmbientColor.Value }):Play()
		end

		if Main_Game then
			if Toggles.RemoveCameraShake.Value     then Main_Game.csgo = CFrame.new() end
			if Toggles.ViewmodelOffsetToggle.Value then
				Main_Game.tooloffset = Vector3.new(Options.ViewmodelOffsetX.Value, Options.ViewmodelOffsetY.Value, Options.ViewmodelOffsetZ.Value)
			else
				Main_Game.tooloffset = Vector3.zero
			end
		end

		if Globals.SelfKilled and Globals.MainUI:FindFirstChild("Statistics") then
			Globals.MainUI.Statistics.Death.Text = "Died to Abysall Hub"
		end

		local MainFrame = Globals.MainUI:FindFirstChild("MainFrame")
		if MainFrame then
			local Effects = MainFrame.Healthbar:FindFirstChild("Effects")
			if Effects and Effects:FindFirstChild("Crouching") then
				Effects.Crouching.Visible = Functions.IsCrouching()
			end
		end

		if (Toggles.CrouchSpoof.Value or Toggles.PositionSpoof.Value) and RemotesFolder:FindFirstChild("Crouch") then
			RemotesFolder.Crouch:FireServer(true, true)
		end

		if Floor ~= "Fools" and Floor ~= "OldHotel" and not Camera:FindFirstChild("MinecartRig") then
			RootPart.CanCollide = false
		end

		for _, Part in Character:GetChildren() do
			if Part:IsA("BasePart") then Part.CanCollide = false end
		end

		if LocalPlayer:GetAttribute("Alive") == true then
			Services.SoundService:WaitForChild("Main").Volume = 1
		end

		if Floor == "OldHotel" or Floor == "Fools" then
			local SpoofOffset = Toggles.PositionSpoof.Value and Functions.GetNearestEntity() and 200 or Toggles.FigureGodmode.Value and Functions.GetNearestFigure() and 200 or 0
			Globals.SpoofOffset = SpoofOffset
			Collision.Position = RootPart.Position + Vector3.new(0, SpoofOffset, 0)
			Collision.CanCollide = false
			if Floor == "Fools" then
				Collision.CollisionCrouch.CanCollide = false
				CollisionClone.CollisionCrouch.CanCollide = false
			end
			RootPart.CanCollide = not (Toggles.NoclipToggle.Value or Toggles.VelocityManipulationToggle.Value)
		else
			Collision.CanCollide = false
			if Collision:FindFirstChild("CollisionCrouch") then Collision.CollisionCrouch.CanCollide = false end

			if CollisionClone:FindFirstChild("CollisionCrouch") then
				local IsCrouch = Functions.IsCrouching()
				CollisionClone.CanCollide = not (Toggles.NoclipToggle.Value or Toggles.VelocityManipulationToggle.Value or IsCrouch)
				CollisionClone.CollisionCrouch.CanCollide = not (Toggles.NoclipToggle.Value or Toggles.VelocityManipulationToggle.Value or not IsCrouch)
			else
				RootPart.CanCollide = not (Toggles.NoclipToggle.Value or Toggles.VelocityManipulationToggle.Value)
			end

			if Character:FindFirstChild("LowerTorso") and Character.LowerTorso:FindFirstChild("Root") then
				Character.LowerTorso.Root.C1 = Globals.OriginalC1 * CFrame.new(0, Toggles.PositionSpoof.Value and -2.346 or 0, 0)
			end

			local SpoofY = Toggles.PositionSpoof.Value and 2.328 or 0.18
			Collision.Position     = RootPart.Position + Vector3.new(0, SpoofY, 0)
			CollisionPart.Position = RootPart.Position + Vector3.new(0, SpoofY, 0)

			if Collision:FindFirstChild("CollisionCrouch") and CollisionClone:FindFirstChild("CollisionCrouch") then
				local CrouchY = Toggles.PositionSpoof.Value and 1.328 or -0.982
				Collision.CollisionCrouch.Position = RootPart.Position + Vector3.new(0, CrouchY, 0)
				CollisionClone.CollisionCrouch.CollisionGroup = Collision.CollisionCrouch.CollisionGroup
			end
			if CollisionClone:FindFirstChild("CollisionCrouch") then
				CollisionClone.CollisionCrouch.Position = RootPart.Position + Vector3.new(0, Toggles.PositionSpoof.Value and 0.75 or -0.982, 0)
			end
		end

		CollisionClone.CollisionGroup = Collision.CollisionGroup
		CollisionClone.Position = RootPart.Position + Vector3.new(0, Toggles.PositionSpoof.Value and 1.75 or 0.18, 0)

		if Toggles.VelocityManipulationToggle.Value and Options.VelocityManipulationMode.Value == "Velocity" then
			Globals.ManipulateBody.Parent = RootPart
			Globals.ManipulateBody.Velocity = RootPart.CFrame.LookVector * 2.25
		else
			Globals.ManipulateBody.Parent = nil
		end

		if Toggles.VelocityManipulationToggle.Value and Options.VelocityManipulationMode.Value == "Pivot" and Floor ~= "Fools" and Floor ~= "OldHotel" then
			Character:PivotTo(Camera:GetPivot() * CFrame.new(0, 0, 2560))
		end

		if Toggles.FlyToggle.Value then
			Globals.FlyBody.Parent = RootPart
			Globals.FlyBody.Velocity = Functions.GetFlyVelocity() * Options.FlySpeed.Value
		else
			Globals.FlyBody.Parent = nil
		end

		local DoEyesBypass = (Toggles.BypassEyes.Value and Globals.IsEyes) or (Toggles.BypassLookman.Value and Globals.IsLookman)
		if DoEyesBypass then
			if Floor == "Fools" or Floor == "OldHotel" then
				RemotesFolder.MotorReplication:FireServer(0, (Globals.SpoofOffset == 200 and 65 or -65), 0, false)
			else
				RemotesFolder.MotorReplication:FireServer(-650)
			end
		end

		if RemotesFolder:FindFirstChild("Crouch") and tick() - Globals.LastCrouchFire > 0.1 then
			local IsCrouch = Functions.IsCrouching()
			if Toggles.CrouchSpoof.Value or Toggles.PositionSpoof.Value then IsCrouch = true end
			RemotesFolder.Crouch:FireServer(IsCrouch, true)
			Globals.LastCrouchFire = tick()
		end

		if tick() - Globals.LastAnimationCheck > 0.1 then
			local Sliding = false
			for _, Anim in Humanoid:GetPlayingAnimationTracks() do
				if Anim.Name == "Slide" then Sliding = true break end
			end
			Globals.Sliding = Sliding
			Globals.LastAnimationCheck = tick()
		end

		Character:SetAttribute("Sliding", Globals.Sliding)
		if Character:GetAttribute("Crouching") ~= Functions.IsCrouching() then
			Character:SetAttribute("Crouching", Functions.IsCrouching())
		end

		RayParams.FilterDescendantsInstances = { Character }
		local TPOffset = CFrame.new(Options.ThirdPersonOffsetX.Value, Options.ThirdPersonOffsetY.Value, Options.ThirdPersonOffsetZ.Value)
		local Direction = (Camera.CFrame * TPOffset).Position - Camera.CFrame.Position
		local WallResult = Services.Workspace:Spherecast(Camera.CFrame.Position, 0.2, Direction, RayParams)

		if Toggles.ThirdPersonToggle.Value then
			if Toggles.ThirdPersonWallCheck.Value and WallResult and WallResult.Instance.CanCollide then
				local NewPos = Camera.CFrame.Position + Direction.Unit * WallResult.Distance
				Camera.CFrame = CFrame.new(NewPos, NewPos + Camera.CFrame.LookVector)
			else
				Camera.CFrame = Camera.CFrame * TPOffset
			end
		end

		for _, Part in Globals.ThirdPersonParts do
			Part.Transparency = Toggles.ThirdPersonToggle.Value and 0 or 1
			Part.LocalTransparencyModifier = Toggles.ThirdPersonToggle.Value and 0 or 1
		end

		if Globals.SpectateEntity and Toggles.AutoClosetToggle.Value and Toggles.SpectateEntityToggle.Value then
			local Entity = Globals.SpectateEntity

			local CamPosition
			if Options.SpecateEntityMode.Value == "Player to Entity" then
				CamPosition = CFrame.lookAt(Character.Head.Position, Entity.PrimaryPart.Position)
			else
				CamPosition = CFrame.lookAt(Entity.PrimaryPart.Position, Character.Head.Position)
			end

			Camera.CFrame = CamPosition
		end

		if Main_Game then
			task.wait()
			Main_Game.fovtarget = Options.FieldOfView.Value
		else
			Camera.FieldOfView = Options.FieldOfView.Value
		end

		if Toggles.RemoveClosetDelay.Value
			and Humanoid.MoveDirection ~= Vector3.zero
			and (CollisionPart.Anchored or RootPart.Anchored)
			and Character:GetAttribute("AnimatingClient") ~= true
			and Character:GetAttribute("Hiding") == true
		then
			RemotesFolder.CamLock:FireServer()
		end

		local ClosestPlayer = { Distance = math.huge, Object = nil }
		for _, Player in Services.Players:GetPlayers() do
			if Player.Character and Player ~= LocalPlayer then
				local Root = Player.Character:FindFirstChild("HumanoidRootPart")
				if Root then
					local D = (Camera.CFrame.Position - Root.Position).Magnitude
					if D < ClosestPlayer.Distance then
						ClosestPlayer.Distance = D
						ClosestPlayer.Object = Player
					end
				end
			end
		end
		if ClosestPlayer.Object and LocalPlayer:GetAttribute("Alive") ~= true then
			LocalPlayer:SetAttribute("CurrentRoom", ClosestPlayer.Object:GetAttribute("CurrentRoom"))
		end
	end)

	task.wait(1)
	if Toggles.PositionSpoof.Value and Floor ~= "Fools" and Floor ~= "OldHotel" then
		RootPart.CFrame = RootPart.CFrame * CFrame.new(0, -2.346, 0)
		Humanoid.HipHeight = 0.05
		RemotesFolder.Crouch:FireServer(true, true)
	end

	local Jam = Globals.MainUI.Initiator.Main_Game.Health:FindFirstChild("Jam")
	if Jam and Toggles.RemoveJamminMusic.Value then
		Jam.Volume = 0
		Globals.JamMuffle.Enabled = false
	end
end

Functions.HandleHidingTransparency = function(Model)
	local Parts = {}
	for _, Part in Model:GetDescendants() do
		if Part:IsA("BasePart") then
			Part:SetAttribute("Transparency_Old", Part.Transparency)
			table.insert(Parts, Part)
		end
		if Part.Name == "HiddenPlayer" then
			local HideConn = Part:GetPropertyChangedSignal("Value"):Connect(function()
				for _, P in Parts do
					if P:GetAttribute("Transparency_Old") then
						Services.TweenService:Create(P, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
							Transparency = (Part.Value == Character and Toggles.TransparentHidingSpotsToggle.Value)
								and Options.TransparentHidingSpotsSlider.Value
								or P:GetAttribute("Transparency_Old")
						}):Play()
					end
				end
			end)
			table.insert(Connections, HideConn)
			Model.Destroying:Once(function()
				HideConn:Disconnect()
				local Pos = table.find(Connections, HideConn)
				if Pos then table.remove(Connections, Pos) end
			end)
		end
	end
end

Functions.HandleObject = function(Object)
	for _, Room in CurrentRooms:GetChildren() do
		if Object:IsDescendantOf(Room) then
			Object:SetAttribute("ParentRoom", tonumber(Room.Name))
			break
		end
		task.wait()
	end

	if Object.Parent == CurrentRooms then
		local FiredampVal = Object:GetAttribute("Firedamp")
		Object:SetAttribute("Firedamp_Old", FiredampVal ~= nil and FiredampVal or false)
		if Toggles.DisableFiredampEffect.Value then
			Object:SetAttribute("Firedamp", false)
		end
	end

	local Name = Object.Name

	if Name == "KeyObtain" then
		task.spawn(function()
			task.wait(0.5)
			if Object.Parent then
				if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Door Key", Color = Options.ObjectiveESPColor.Value }, true) end
				table.insert(Objects.Objectives, Object)
			end
		end)
	elseif Name == "ElectricalKeyObtain" then
		task.spawn(function()
			task.wait(0.5)
			if Object.Parent then
				if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Electrical Key", Color = Options.ObjectiveESPColor.Value }, true) end
				table.insert(Objects.Objectives, Object)
			end
		end)
	elseif Name == "TimerLever" then
		task.spawn(function()
			task.wait(0.5)
			if Object.Parent then
				Object:SetAttribute("AddTime", Object.TakeTimer.TextLabel.Text == "01:00" and 60 or 30)
				if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Time Lever [+" .. Object:GetAttribute("AddTime") .. "s]", Color = Options.ObjectiveESPColor.Value }, true) end
				Object:WaitForChild("Main").SoundToPlay.Played:Once(function()
					Functions.RemoveESP(Object)
					Functions.BlacklistESP(Object)
				end)
				table.insert(Objects.Objectives, Object)
			end
		end)
	elseif Name == "LiveHintBook" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Hint Book", Color = Options.ObjectiveESPColor.Value }, true) end
		table.insert(Objects.Objectives, Object)
	elseif Name == "LiveBreakerPolePickup" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Fuse Breaker", Color = Options.ObjectiveESPColor.Value }, true) end
		for _, Child in Object:GetChildren() do
			if Child.Name == "ActivateEventPrompt" and (Child.MaxActivationDistance == 5 or Child:GetAttribute("MaxActivationDistance_Old") == 5) then
				Child:Destroy()
			end
		end
		table.insert(Objects.Objectives, Object)
	elseif Name == "LibraryHintPaper" or Name == "PickupItem" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Hint Paper", Color = Options.ObjectiveESPColor.Value }, true) end
		table.insert(Objects.Objectives, Object)
	elseif Name == "MinesAnchor" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Anchor [" .. Object:WaitForChild("Sign").TextLabel.Text .. "]", Color = Options.ObjectiveESPColor.Value }, true) end
		Object:GetAttributeChangedSignal("Activated"):Once(function()
			Functions.RemoveESP(Object)
			Functions.BlacklistESP(Object)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "WaterPump" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object:WaitForChild("Wheel"), Text = "Water Pump", Color = Options.ObjectiveESPColor.Value }, true) end
		Object:WaitForChild("Wheel").Sound.Played:Once(function()
			Object:SetAttribute("Abysall_Completed", true)

			Functions.RemoveESP(Object.Wheel)
			Functions.BlacklistESP(Object.Wheel)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "CringlePresent" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Present", Color = Options.ObjectiveESPColor.Value }, true) end
		Object:WaitForChild("ToolProp").Highlight:Destroy()
		table.insert(Objects.Objectives, Object)
	elseif Name == "LeverForGate" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Gate Lever", Color = Options.ObjectiveESPColor.Value }, true) end
		Object:WaitForChild("Main").SoundToPlay.Played:Once(function()
			Functions.RemoveESP(Object)
			Functions.BlacklistESP(Object)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "VineGuillotine" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object.Lever, Text = "Vine Lever", Color = Options.ObjectiveESPColor.Value }, true) end
		Object.Lever:WaitForChild("ActivateEventPrompt"):GetAttributeChangedSignal("Interactions"):Once(function()
			Functions.RemoveESP(Object)
			Functions.BlacklistESP(Object)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "MandrakeLive" then
		if Toggles.ObjectiveESPToggle.Value and Options.EntityESPOptions.Value["Mandrake Hole"] then Functions.AddESP({ Object = Object.Hole, Text = "Mandrake Hole", Color = Options.EntityESPColor.Value }, true) end
		table.insert(Objects.Entities, Object.Hole)
	elseif Name == "MinesGenerator" then
		task.spawn(function()
			task.wait(0.75)
			if Object.Parent then
				if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Generator", Color = Options.ObjectiveESPColor.Value }, true) end
				Object:WaitForChild("Lever").Sound.Played:Once(function()
					Functions.RemoveESP(Object)
					Functions.BlacklistESP(Object)
				end)
				table.insert(Objects.Objectives, Object)
			end
		end)
	elseif Name == "FuseObtain" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Generator Fuse", Color = Options.ObjectiveESPColor.Value }, true) end
		Object:WaitForChild("Hitbox").FuseModel:GetPropertyChangedSignal("LocalTransparencyModifier"):Once(function()
			Functions.RemoveESP(Object)
			Functions.BlacklistESP(Object)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "MinesGateButton" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Gate Button", Color = Options.ObjectiveESPColor.Value }, true) end
		Object.Parent:WaitForChild("MinesGate").Main.SoundOpen.Played:Once(function()
			Functions.RemoveESP(Object)
			Functions.BlacklistESP(Object)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "GardenGateButton" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Gate Button", Color = Options.ObjectiveESPColor.Value }, true) end
		Object.Parent:WaitForChild("GardenGate").Collision.Sound.Played:Once(function()
			Functions.RemoveESP(Object)
			Functions.BlacklistESP(Object)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "Ladder" then
		if Toggles.LadderESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Ladder", Color = Options.LadderESPColor.Value }, true) end
		table.insert(Objects.Ladders, Object)
	elseif Name == "Door" and Object.Parent and tonumber(Object.Parent.Name) then
		local DoorParts = {}
		for _, Child in Object:GetChildren() do
			if Child.Name == "Door" and Child:IsA("BasePart") then
				table.insert(DoorParts, Child)
			end
		end

		if #DoorParts == 2 then
			local HighlightModel = Instance.new("Model", Object)
			HighlightModel.Name = "HighlightModel"
			Instance.new("Humanoid", HighlightModel).Name = "HighlightHumanoid"
			HighlightModel:SetAttribute("ParentRoom", tonumber(Object.Parent.Name))

			for _, DoorPart in DoorParts do
				local HP = Instance.new("Part", HighlightModel)
				HP.Transparency = 0.999
				HP.Size = DoorPart.Size
				HP.CanCollide = false
				HP.CFrame = DoorPart.CFrame
				HP.Name = "HighlightPart"
				HP.Material = Enum.Material.Plastic
				HP:SetAttribute("ParentRoom", tonumber(Object.Parent.Name))
				local W = Instance.new("WeldConstraint", HP)
				W.Part0 = HP W.Part1 = DoorPart W.Enabled = true
			end
			table.insert(Objects.Doors, HighlightModel)
			if Toggles.DoorESPToggle.Value then Functions.AddESP({ Object = HighlightModel, Text = "Door " .. Functions.GetDoorNumber(Object), Color = Options.DoorESPColor.Value }, true) end
		else
			local Root = Object:WaitForChild("Door", 9e9)
			local HP = Instance.new("Part", Object)
			HP.Transparency = 0.999
			HP.Size = Root.Size
			HP.CanCollide = false
			HP.CFrame = Root.CFrame
			HP.Name = "HighlightPart"
			HP.Material = Enum.Material.Plastic
			HP:SetAttribute("ParentRoom", tonumber(Object.Parent.Name))
			local W = Instance.new("WeldConstraint", HP)
			W.Part0 = HP W.Part1 = Root W.Enabled = true
			Instance.new("Humanoid", Object).Name = "HighlightHumanoid"
			table.insert(Objects.Doors, HP)
			if Toggles.DoorESPToggle.Value then Functions.AddESP({ Object = HP, Text = "Door " .. Functions.GetDoorNumber(Object), Color = Options.DoorESPColor.Value }, true) end
		end

		local LastDoorFire = tick()
		local DoorConn = Services.RunService.Heartbeat:Connect(function()
			if Object:FindFirstChild("Door") and Object:FindFirstChild("ClientOpen") then
				if LocalPlayer:DistanceFromCharacter(Object.Door.Position) < 75
					and tick() - LastDoorFire > 0.1
					and (Toggles.DoorReachToggle.Value or Functions.GetMinecart())
				then
					Object.ClientOpen:FireServer()
					LastDoorFire = tick()
				end
			end
		end)
		Object:WaitForChild("Door"):WaitForChild("Open").Played:Once(function()
			DoorConn:Disconnect()
		end)
		table.insert(Connections, DoorConn)

	elseif Name == "PathLights" then
		local ObjectsToHighlight = {}
		local PLConn = Object.ChildAdded:Connect(function(Child)
			table.insert(ObjectsToHighlight, Child)
		end)
		for _, Child in Object:GetChildren() do
			table.insert(ObjectsToHighlight, Child)
		end

		local function CreateSeekNode(Light)
			if Light.Name ~= "SeekGuidingLight" or Light:GetAttribute("Highlighted") then return end
			Light:SetAttribute("Highlighted", true)

			local NewNode = Instance.new("Part")
			NewNode.Size = Vector3.one
			NewNode.Transparency = 1
			NewNode.Parent = Globals.SeekNodesFolder
			NewNode.Anchored = true
			NewNode.CFrame = Light.CFrame
			NewNode.CanCollide = false
			NewNode.Name = "SeekLightNode"

			local PrevNode2 = PreviousNode or NewNode
			PreviousNode = NewNode

			local Beam = Instance.new("Beam")
			Beam.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Options.ShowSeekPathColor.Value), ColorSequenceKeypoint.new(1, Options.ShowSeekPathColor.Value) })
			Beam.FaceCamera = true
			Beam.Width0 = 0.2
			Beam.Width1 = 0.2
			Beam.Brightness = 10
			Beam.LightInfluence = 0
			Beam.LightEmission = 0
			Beam.Enabled = true
			local Vis = Toggles.ShowSeekPathToggle.Value and 0 or 1
			Beam.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, Vis), NumberSequenceKeypoint.new(1, Vis) })
			Beam.Parent = Globals.SeekNodesFolder
			local A0 = Instance.new("Attachment", NewNode)
			local A1 = Instance.new("Attachment", PrevNode2)
			Beam.Attachment0 = A0
			Beam.Attachment1 = A1
			table.insert(Objects.SeekHighlights, Beam)
		end

		task.spawn(function()
			while task.wait() do
				local Light = table.remove(ObjectsToHighlight, 1)
				if Light then CreateSeekNode(Light) end
			end
		end)

		table.insert(Connections, PLConn)
		table.insert(Objects.PathLights, Object)
		Object.Destroying:Once(function() PLConn:Disconnect() end)
	elseif Name == "SeekMovingNewClone" then
		local Connection = Object.Destroying:Connect(function()
			for _, Folder in pairs(Objects.PathLights) do
				Folder:ClearAllChildren()
			end
			Globals.SeekNodesFolder:ClearAllChildren()
		end)
		table.insert(Connections, Connection)
	elseif Name == "Bridge" then
		for _, Child in Object:GetChildren() do
			if Child.Name == "PlayerBarrier" and Child.Size.Y == 2.75 and (Child.Rotation.X == 0 or Child.Rotation.X == 180) then
				local NewBridge = Child:Clone()
				NewBridge.CFrame = NewBridge.CFrame * CFrame.new(0, 0, -5)
				NewBridge.Name = Abysall.ESPLibrary:GenerateRandomString()
				NewBridge.Size = Vector3.new(NewBridge.Size.X, NewBridge.Size.Y, 11)
				NewBridge.Parent = Object
				NewBridge.CanCollide = Toggles.BypassSeekObstructions.Value
				NewBridge.Color = Color3.fromRGB(0, 255, 255)
				NewBridge.Transparency = Toggles.BypassSeekObstructions.Value and 0 or 1
				NewBridge.Material = Enum.Material.ForceField
				table.insert(Objects.SeekBridges, NewBridge)
			end
			task.wait()
		end
    elseif Name == "MinecartRig" then
        Globals.Minecart = Object
	elseif Name == "RunnerNodes" then
		local function IsBehind(Part1, Part2)
			local P1 = (Part1.CFrame + Part1.CFrame.LookVector).Position
			local P2 = (Part1.CFrame + Part1.CFrame.LookVector * -1).Position
			return (P1 - Part2.Position).Magnitude > (P2 - Part2.Position).Magnitude
		end
		local function GetDirection(Part1, Part2)
			local RightDist = Part1.CFrame.RightVector:Dot(Part1.Position - Part2.Position)
			if RightDist > 0.5    then return IsBehind(Part1, Part2) and "Right" or "Left" end
			if RightDist < -0.5   then return IsBehind(Part1, Part2) and "Left" or "Right" end
			return "Straight"
		end
		local function GetClosestNode(Node)
			local Best, BestDist = nil, math.huge
			local NodeID2 = tonumber(Node.Name:split("MinecartNode")[2])
			for _, OtherNode in Object:GetChildren() do
				local OtherID = tonumber(OtherNode.Name:split("MinecartNode")[2])
				if OtherNode ~= Node and OtherID and NodeID2 and OtherID > NodeID2 then
					local D = (Node.Position - OtherNode.Position).Magnitude
					if D < BestDist and OtherNode:GetAttribute("DistanceBlacklist") ~= true then
						BestDist = D Best = OtherNode
					end
				end
			end
			return Best
		end

		for _, Node in Object:GetChildren() do
			local NodeID = tonumber(Node.Name:split("MinecartNode")[2])
			if Node:GetAttribute("DeathType") then Node:SetAttribute("DistanceBlacklist", true) end
			for I = 1, 20 do
				local NextNode = NodeID and Object:FindFirstChild("MinecartNode" .. NodeID + I)
				if NextNode and NextNode:GetAttribute("DeathType") ~= nil then
					Node:SetAttribute("DistanceBlacklist", true)
				end
			end
			local PrevNode3 = NodeID and Object:FindFirstChild("MinecartNode" .. NodeID - 1)
			if PrevNode3 and PrevNode3:GetAttribute("ForceConnect") then
				Node:SetAttribute("DistanceBlacklist", nil)
			end
			task.wait()
		end

		for _, Node in Object:GetChildren() do
			if Node:GetAttribute("ForceConnect") then
				local NextNode = GetClosestNode(Node)
				if NextNode then
					Node:SetAttribute("Turn", GetDirection(Node, NextNode))
					table.insert(Objects.SeekNodes, Node)
				end
			end
			task.wait()
		end

	elseif Name == "EyestalkEndCutscene" then
		Object.Name = "_EyestalkEndCutscene"
	elseif Name == "DuckBoard" then
		table.insert(Objects.SeekDuckBoards, Object)
	elseif HidingSpotLabels[Name] then
		if Toggles.HidingSpotESPToggle.Value then Functions.AddESP({ Object = Object, Text = HidingSpotLabels[Name], Color = Options.HidingSpotESPColor.Value }, true) end
		Functions.HandleHidingTransparency(Object)
		table.insert(Objects.HidingSpots, Object)
	elseif Name == "Lava" then
		if Toggles.BypassKillbricks.Value then Object.CanTouch = false end
		table.insert(Objects.Obstructions, Object)
	elseif Name == "ScaryWall" then
		for _, Part in Object:GetDescendants() do
			if Part:IsA("BasePart") then
				Part.CanTouch = not Toggles.BypassSeekingWall.Value
				Part.CanCollide = not Toggles.BypassSeekingWall.Value

                local Connection1 = Part:GetPropertyChangedSignal("CanTouch"):Connect(function()
                    if Part.CanTouch == Toggles.BypassSeekingWall.Value then
                        Part.CanTouch = not Toggles.BypassSeekingWall.Value
                    end
                end)
                local Connection2 = Part:GetPropertyChangedSignal("CanCollide"):Connect(function()
                    if Part.CanCollide == Toggles.BypassSeekingWall.Value then
                        Part.CanCollide = not Toggles.BypassSeekingWall.Value
                    end
                end)

                table.insert(Connections, Connection1)
                table.insert(Connections, Connection2)
            end
		end
		table.insert(Objects.Obstructions, Object)
	elseif Name == "ChestBox" or Name == "ChestBoxLocked" then
		if Toggles.ChestESPToggle.Value then Functions.AddESP({ Object = Object, Text = Object:GetAttribute("Locked") and "Locked Chest" or "Chest", Color = Options.ChestESPColor.Value }, true) end
		table.insert(Objects.Chests, Object)
	elseif Name == "Toolbox" or Name == "Toolbox_Locked" then
		if Toggles.ChestESPToggle.Value then Functions.AddESP({ Object = Object, Text = Object:GetAttribute("Locked") and "Locked Toolbox" or "Toolbox", Color = Options.ChestESPColor.Value }, true) end
		table.insert(Objects.Chests, Object)
	elseif Name == "Chest_Vine" then
		if Toggles.ChestESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Vine Chest", Color = Options.ChestESPColor.Value }, true) end
		table.insert(Objects.Chests, Object)
	elseif Name == "Toolshed_Small" then
		if Toggles.ChestESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Toolshed", Color = Options.ChestESPColor.Value }, true) end
		table.insert(Objects.Chests, Object)
	elseif Name == "Locker_Small_Locked" then
		if Toggles.ChestESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Locked Item Locker", Color = Options.ChestESPColor.Value }, true) end
		table.insert(Objects.Chests, Object)
	elseif Name == "MouseHole" then
		if Toggles.ChestESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Mouse", Color = Options.ChestESPColor.Value }, true) end
		table.insert(Objects.Chests, Object)
	elseif ItemNames[Name] and Object:FindFirstChild("ModulePrompt") then
		if Toggles.ItemESPToggle.Value then Functions.AddESP({ Object = Object, Text = ItemNames[Name], Color = Options.ItemESPColor.Value }, Object:GetAttribute("ParentRoom") ~= nil) end
		if Name == "LotusHolder" or Name == "LotusPetalPickup" then
			Object.Handle:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
				Abysall.ESPLibrary:RemoveESP(Object)
				Functions.BlacklistESP(Object)
			end)
		end

		if Toggles.NotifyItemsToggle.Value and Options.NotifyItemList.Value[ItemNames[Name]] and Object.Parent.Name ~= "Drops" then
			if Toggles.NotifyItemsShowDistance.Value then
				Functions.Notify({ Title = "Item '" .. ItemNames[Name] .. "' has spawned.", Body = "It is '" .. math.round(LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)) .. "' studs away from you." })
			else
				Functions.Notify({ Title = "Item '" .. ItemNames[Name] .. "' has spawned."})
			end
		end

		table.insert(Objects.Items, Object)
	elseif Name == "Green_Herb" then
		if Toggles.ItemESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Green Herb", Color = Options.ItemESPColor.Value }, true) end
		table.insert(Objects.Items, Object)
	elseif Name == "GoldPile" and Object:GetAttribute("GoldValue") then
		if Toggles.CurrencyESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Gold Pile [" .. Object:GetAttribute("GoldValue") .. "]", Color = Options.CurrencyESPColor.Value }, true) end
		table.insert(Objects.Currency, Object)
	elseif Name == "StardustPickup" then
		if Toggles.CurrencyESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Stardust Pile", Color = Options.CurrencyESPColor.Value }, true) end
		table.insert(Objects.Currency, Object)
	elseif Name == "GiggleCeiling" then
		if Toggles.EntityESPToggle.Value and Options.EntityESPOptions.Value["Giggle"] then Functions.AddESP({ Object = Object, Text = "Giggle", Color = Options.EntityESPColor.Value }, true) end
		if Toggles.BypassGiggle.Value then Object:WaitForChild("Hitbox").CanTouch = false end
		table.insert(Objects.Entities, Object)
	elseif Name == "GloomPile" then
		if Toggles.BypassGloombatEggs.Value then
			for _, Part in Object:GetDescendants() do
				if Part:IsA("BasePart") then Part.CanTouch = false
				end
			end
		end
		local Connection = Object.DescendantAdded:Connect(function(Part)
			if Part:IsA("BasePart") then Part.CanTouch = false end
		end)

		if Toggles.EntityESPToggle.Value and Options.EntityESPOptions.Value["Gloombat Eggs"] then
			Functions.AddESP({ Object = Object, Text = "Gloombat Eggs", Color = Options.EntityESPColor.Value })
		end

		table.insert(Connections, Connection)
		table.insert(Objects.Entities, Object)
	elseif Name == "TriggerEventCollision" and Functions.CheckCompatability({"firetouchinterest"}) then
		if (Floor == "Fools" or Floor == "OldHotel") and Toggles.RemoveSeekTrigger.Value then
			task.spawn(function()
				while Object:IsDescendantOf(game) do
					for _, Part in Object:GetChildren() do
						if Part:IsA("BasePart") then
							Abysall.Environment.firetouchinterest(RootPart, Part, 0)
							task.wait()
							Abysall.Environment.firetouchinterest(RootPart, Part, 1)
						end
					end
					task.wait()
				end
			end)
		end
		table.insert(Objects.EventTriggers, Object)
	elseif Name == "DoorFake" or Name == "FakeDoor" then
		if Object.Parent and Object:FindFirstChild("Hidden") then
			if Toggles.BypassDupe.Value then
				Object:WaitForChild("Hidden").CanTouch = false
				local Lock = Object:FindFirstChild("Lock")
				if Lock and Lock:FindFirstChild("UnlockPrompt") then Lock.UnlockPrompt.Enabled = false end
			end
			if Toggles.EntityESPToggle.Value and Options.EntityESPOptions.Value["Dupe"] then
				Functions.AddESP({ Object = Object, Text = "Dupe", Color = Options.EntityESPColor.Value }, true)
			end
			table.insert(Objects.Entities, Object)
		end
	elseif Name == "SideroomSpace" then
		if Toggles.BypassVacuum.Value then
			Object:WaitForChild("Collision").CanCollide = true
			Object:WaitForChild("Collision").CanTouch = false
		end
		table.insert(Objects.Entities, Object)
	elseif Name == "Snare" then
		if Toggles.EntityESPToggle.Value and Options.EntityESPOptions.Value["Snare"] then Functions.AddESP({ Object = Object, Text = "Snare", Color = Options.EntityESPColor.Value }, true) end
		for _, Part in Object:GetDescendants() do
			if Part:IsA("BasePart") then Part.CanTouch = not Toggles.BypassSnare.Value end
		end
		local Connection = Object.DescendantAdded:Connect(function(Part)
			if Part:IsA("BasePart") then Part.CanTouch = not Toggles.BypassSnare.Value end
		end)
		table.insert(Connections, Connection)
		table.insert(Objects.Entities, Object)

		if Object:FindFirstChild("Snare") then
			Object:WaitForChild("Snare"):WaitForChild("Roots").Transparency = 1
			Object:WaitForChild("Snare"):WaitForChild("SnareBase").Transparency = 1
		end
		if Object:FindFirstChild("Void") then
			Object.Void.Transparency = 0
			Object.Void.Color = Color3.fromRGB(76, 67, 55)
		end
	elseif Name == "Seek_Arm" or Name == "ChandelierObstruction" then
		for _, Part in Object:GetDescendants() do
			if Part:IsA("BasePart") then
				Part.CanTouch = not Toggles.BypassSeekObstructions.Value
				table.insert(Objects.SeekObstructions, Part)
			end
		end
	elseif Name == "SeekFloodline" then
		Object.CanCollide = Toggles.BypassSeekObstructions.Value
		local FloodConn = Object:GetPropertyChangedSignal("CanCollide"):Connect(function()
			if Object.CanCollide ~= Toggles.BypassSeekObstructions.Value then
				Object.CanCollide = Toggles.BypassSeekObstructions.Value
			end
		end)
		Object.Destroying:Once(function() FloodConn:Disconnect() end)
		table.insert(Objects.SeekObstructions, Object)
	elseif Object:GetAttribute("RawName") and Object:GetAttribute("RawName"):find("Halt") or Object:GetAttribute("Shade") == true then
		if Toggles.NotifyEntities.Value and Options.EntityList.Value["Halt"] then
			Functions.Notify({ Title = "Entity 'Halt' will spawn in the next room.", Image = EntityIcons["Halt"] })
			if Toggles.EntityChatToggle.Value then Functions.SendChat("Halt next room!") end
		end
		local HaltLogConn
		HaltLogConn = Services.LogService.MessageOut:Connect(function(Message)
			if Message == "client teleporting" then
				if Globals.AnticheatDisabled then
					Globals.AnticheatDisabled = false
					Functions.Notify({ Title = "The anticheat has been re-enabled.", Body = "Interact with a ladder to disable it again." })
				end
				HaltLogConn:Disconnect()
			end
		end)
	elseif Name == "BananaPeel" then
		if Toggles.BypassBanana.Value then Object.CanTouch = false end
		table.insert(Objects.Entities, Object)
	elseif Name == "JeffTheKiller" then
		if Toggles.BypassJeff.Value then
			for _, Part in Object:GetDescendants() do
				if Part:IsA("BasePart") then Part.CanCollide = false Part.CanTouch = false end
			end
			Object:WaitForChild("Humanoid").Health = 0
		end
	elseif Name == "GrumbleRig" then
		if Toggles.EntityESPToggle.Value and Options.EntityESPOptions.Value["Grumble"] then Functions.AddESP({ Object = Object, Text = "Grumble", Color = Options.EntityESPColor.Value }, true) end
		table.insert(Objects.Entities, Object)
	elseif Name == "LiveEntityBramble" then
		if Toggles.EntityESPToggle.Value and Options.EntityESPOptions.Value["Bramble"] then Functions.AddESP({ Object = Object, Text = "Bramble", Color = Options.EntityESPColor.Value }, true) end
		table.insert(Objects.Entities, Object)
	elseif Name == "Groundskeeper" then
		if Toggles.EntityESPToggle.Value and Options.EntityESPOptions.Value["Groundskeeper"] then Functions.AddESP({ Object = Object, Text = "Groundskeeper", Color = Options.EntityESPColor.Value }, true) end
		if Toggles.NotifyEntities.Value and Options.EntityList.Value["Groundskeeper"] then
			local ED = Entities["Groundskeeper"]
			Functions.Notify({ Title = ED.NotifyMessage.Title, Body = ED.NotifyMessage.Body, Image = EntityIcons["Groundskeeper"] })
		end
		table.insert(Objects.Entities, Object)
	elseif Name == "Figure" or Name == "FigureRig" or Name == "FigureRagdoll" then
		for _, Part in Object:GetDescendants() do
			if Part:IsA("BasePart") then
				Part.CanTouch = false
			end
		end
		if Toggles.EntityESPToggle.Value and Options.EntityESPOptions.Value["Figure"] then Functions.AddESP({ Object = Object, Text = "Figure", Color = Options.EntityESPColor.Value }, true) end
		table.insert(Objects.Entities, Object)
		if Toggles.RemoveFigure.Value and Functions.CheckCompatability({"isnetworkowner"}) then
			if Floor == "Mines" then
				for _, Part in Object:GetDescendants() do
					if Part:IsA("BasePart") then
						task.spawn(function()
							if Abysall.Environment.isnetworkowner(Part) then
								Part.Position = Vector3.new(-49999, -49999, -49999)
							end
						end)
					end
				end
			elseif Floor == "OldHotel" or Floor == "Fools" then
				CurrentRooms.ChildAdded:Wait()
				for _, Part in Object:GetDescendants() do
					if Part:IsA("BasePart") then
						Part.CanCollide = false
						task.spawn(function()
							while Abysall.Environment.isnetworkowner(Part) do
								Part.Position = Vector3.new(math.random(-29999,29999), math.random(-29999,29999), math.random(-29999,29999))
								task.wait()
							end
						end)
					end
				end
			end
		end
	elseif (Name == "ThingToOpen" or Name == "MovingDoor") and (Floor == "Fools" or Floor == "OldHotel")
		or Name == "Wax_Door" and Floor == "Fools"
	then
		Object:SetAttribute("OriginalPosition", Object:GetPivot())
		local ToggleMap = { ThingToOpen = "RemoveBasementGate", MovingDoor = "RemovePaintingsDoor", Wax_Door = "RemoveSkeletonDoor" }
		if ToggleMap[Name] and Toggles[ToggleMap[Name]].Value then
			Object:PivotTo(CFrame.new(-10000, -10000, -10000))
		end
		table.insert(Objects.Obstructions, Object)
	elseif Name == "ElevatorBreaker" then
		if Toggles.AutoBreakerBox.Value and not Globals.BreakerBoxNotified then
			Functions.Notify({ Title = "Interact with the breaker box.", Body = "It will be automatically solved." })
			Globals.BreakerBoxNotified = true
		end
		Connections.BreakerConnection = Object:WaitForChild("SurfaceGui").Frame.Code:GetPropertyChangedSignal("Text"):Connect(function()
			if Toggles.AutoBreakerBox.Value then
				if not Globals.BreakerBoxStartNotified and (Floor == "Fools" or Floor == "OldHotel") then
					Functions.Notify({ Title = "Attempting to solve the breaker box.", Body = "Please wait." })
					Globals.BreakerBoxStartNotified = true
				end
				RemotesFolder.EBF:FireServer()
			end
			Globals.BreakerBoxInteracted = true
		end)
	elseif Name == "ElevatorCar" then
		local ElevConn = Object.DescendantAdded:Connect(function(Desc)
			if Toggles.AutoBreakerBox.Value and Desc.Name == "TouchInterest" and not Globals.BreakerBoxFinishedNotified then
				Functions.Notify({ Title = "Successfully solved the breaker box.", Body = "Try going to the elevator!" })
				Globals.BreakerBoxFinishedNotified = true
			end
		end)
		Object.Destroying:Once(function() ElevConn:Disconnect() end)
	elseif Object.ClassName == "ProximityPrompt" and not Object:GetAttribute("FakePrompt") then
		if Object:HasTag("DisableWhenEnabledOnClient") then Object:RemoveTag("DisableWhenEnabledOnClient") end

		Object:SetAttribute("HoldDuration_Old", Object.HoldDuration)
		Object:SetAttribute("RequiresLineOfSight_Old", Object.RequiresLineOfSight)
		Object:SetAttribute("MaxActivationDistance_Old", Object.MaxActivationDistance)

		if Toggles.InstantPrompts.Value    then Object.HoldDuration = 0 end
		if Toggles.PromptClip.Value        then Object.RequiresLineOfSight = false end
		Object.MaxActivationDistance = Object:GetAttribute("MaxActivationDistance_Old") * Options.PromptReachSlider.Value

		local LockPromptNames = { UnlockPrompt=true, SkullPrompt=true, LockPrompt=true, ThingToEnable=true, FusesPrompt=true }

		if Functions.CheckCompatability({"fireproximityprompt"}) and Floor ~= "OldHotel" and Floor ~= "Fools" then
			local IsLockPrompt = LockPromptNames[Object.Name]
				or (Object.Parent and Object.Parent:GetAttribute("Locked") == true)
				or (Object.Parent and Object.Parent.Parent and Object.Parent.Parent.Name == "Locker_Small_Locked" and Object.Name == "ActivateEventPrompt")

			if IsLockPrompt then
				local FakePrompt = Object:Clone()
				FakePrompt:SetAttribute("FakePrompt", true)
				task.wait()
				FakePrompt.Parent = Object.Parent

				FakePrompt:SetAttribute("HoldDuration_Old", Object:GetAttribute("HoldDuration_Old"))
				FakePrompt:SetAttribute("RequiresLineOfSight_Old", Object:GetAttribute("RequiresLineOfSight_Old"))
				FakePrompt:SetAttribute("MaxActivationDistance_Old", Object:GetAttribute("MaxActivationDistance_Old"))

				FakePrompt.HoldDuration = Object.HoldDuration
				FakePrompt.RequiresLineOfSight = Object.RequiresLineOfSight
				FakePrompt.MaxActivationDistance = Object.MaxActivationDistance

				if Toggles.InstantPrompts.Value    then FakePrompt.HoldDuration = 0 end
				if Toggles.PromptClip.Value        then FakePrompt.RequiresLineOfSight = false end
				FakePrompt.MaxActivationDistance = FakePrompt:GetAttribute("MaxActivationDistance_Old") * Options.PromptReachSlider.Value

				FakePrompts[FakePrompt] = Object
				pcall(function() Object.Parent = Globals.PromptContainer end)

				local FPEnabledConn = Object:GetPropertyChangedSignal("Enabled"):Connect(function()
					FakePrompt.Enabled = Object.Enabled
				end)
				Object:GetPropertyChangedSignal("ActionText"):Once(function()
					Object.Parent = FakePrompt.Parent
					FakePrompt:Destroy()
					FPEnabledConn:Disconnect()
				end)
				Object.Destroying:Once(function()
					FakePrompt:Destroy()
					FPEnabledConn:Disconnect()
				end)
				table.insert(Connections, FPEnabledConn)
				table.insert(Objects.Prompts, FakePrompt)

				FakePrompt.Enabled = false
				task.wait()
				FakePrompt.Enabled = Object.Enabled
			end
		end
		table.insert(Objects.Prompts, Object)
	elseif Name == "Padlock" then
		Connections.PadlockConnection = Services.RunService.Heartbeat:Connect(function()
			if Object.PrimaryPart then
				local Distance = LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)
				if Toggles.AutoUnlockPadlockToggle.Value then
					local Code = Functions.GetLibraryCode()
					if Code and tonumber(Code) and Distance < Options.AutoUnlockPadlockSlider.Value then
						RemotesFolder.PL:FireServer(Code)
					end
				end
				if Toggles.AutoLibraryGuessCode.Value and LatestRoom.Value == 50 then
					local Code = Functions.GetRandomCode()
					if Code then RemotesFolder.PL:FireServer(Code) end
				end
			end
		end)
		Object.Destroying:Once(function()
			if Connections.PadlockConnection then
				Connections.PadlockConnection:Disconnect()
				Connections.PadlockConnection = nil
			end
		end)
	end
end

Connections.PromptAnimationFixer1 = Services.ProximityPromptService.PromptButtonHoldBegan:Connect(function(Object)
	if not Object:GetAttribute("FakePrompt") then return end
	local ToolNames = { "Lockpick","Shears","SkeletonKey","Key","GeneratorFuse","KeyElectrical","KeyBackdoor","KeyIron", "Multitool" }
	local AnimateToolNames = { "Lockpick","Shears","SkeletonKey","Key","KeyElectrical","KeyBackdoor","KeyIron", "Multitool" }
	local Tool
	for _, N in ToolNames do Tool = Character:FindFirstChild(N) if Tool then break end end

	local Prompt = Object
	local LockPromptNames = { UnlockPrompt=true, SkullPrompt=true, LockPrompt=true, ThingToEnable=true, FusesPrompt=true }
	local IsLockPrompt = LockPromptNames[Object.Name]
		or (Object.Parent and Object.Parent:GetAttribute("Locked") == true)
		or (Object.Parent and Object.Parent.Parent and Object.Parent.Parent.Name == "Locker_Small_Locked" and Object.Name == "ActivateEventPrompt")
	if IsLockPrompt then
		if Options.AutoInteractIgnoreList.Value["Locks"] then return end
		local KeyItems = { "Key","GeneratorFuse","KeyBackdoor","KeyElectrical","KeyIron","Lockpick","SkeletonKey","Shears","Multitool" }
		local OffhandKeyItems = { "Key","GeneratorFuse","KeyElectrical","KeyIron" }
		local HasKey = false
		for _, K in KeyItems do if Functions.HasItem(K, true) then HasKey = true break end end
		for _, K in OffhandKeyItems do if Functions.HasItem(K) then HasKey = true break end end
		if not HasKey then return end
	end

	if Prompt.Parent.Name == "CuttableVines" and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) or Prompt.Parent.Name == "Chest_Vine" and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) or Prompt.Parent.Name == "Cellar" and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) then return end
	if Prompt.Parent.Name == "SkullLock" and not Functions.HasItem("SkeletonKey", true) then return end
	if Prompt.Parent.Name == "Lock1" and not Functions.HasItem("Lockpick", true) and not Functions.HasItem("Multitool", true) or Prompt.Parent.Name == "Lock2" and not Functions.HasItem("Lockpick", true) and not Functions.HasItem("Multitool", true) then return end
	if Functions.HasItem("Shears", true) and IsLockPrompt and Prompt.Parent.Name ~= "CuttableVines" and Prompt.Parent.Name ~= "Chest_Vine" and Prompt.Parent.Name ~= "Cellar" then return end
	
	if Tool and table.find(AnimateToolNames, Tool.Name) and Globals.UseAnimation then
		Globals.UseAnimationBreak:Stop()
		Globals.UseAnimation:Stop()
		Globals.UseAnimation:Play()
		if Tool.Name == "Shears" then Tool:WaitForChild("Handle"):WaitForChild("sound_prompt"):Play() end
	end
end)

Globals.ObjectQueue = {}
local AllowedInstances = {
	Lava=true, GoldPile=true, KeyObtain=true, Drakobloxxer=true, FuseObtain=true,
	MinesGenerator=true, JeffTheKiller=true, Snare=true, FakeDoor=true, DoorFake=true, SideroomSpace=true,
	ChestBox=true, ChestBoxLocked=true, Chest_Vine=true, Locker_Small_Locked=true, Toolbox=true,
	Toolbox_Locked=true, Wardrobe=true, ["Wardrobe-FOOLS26"]=true, Toolshed=true, Toolshed_Small=true,
	Bed=true, MinesAnchor=true, Double_Bed=true, RetroWardrobe=true, Backdoor_Wardrobe=true,
	Rooms_Locker=true, Rooms_Locker_Fridge=true, Locker_Large=true, FigureRig=true, FigureRagdoll=true,
	TimerLever=true, Lever=true, Seek_Arm=true, ChandelierObstruction=true, ScaryWall=true, Ladder=true,
	CircularVent=true, Dumpster=true, SquareGrate=true, TriggerEventCollision=true, GrumbleRig=true,
	GiggleCeiling=true, MinesGateButton=true, ElectricalKeyObtain=true, LibraryHintPaper=true,
	WaterPump=true, CringlePresent=true, Wheel=true, PickupItem=true, LiveHintBook=true,
	LiveBreakerPolePickup=true, LeverForGate=true, GloomPile=true, SeekFloodline=true, Door=true,
	Green_Herb=true, Bridge=true, MouseHole=true, BananaPeel=true, NannerPeel=true, PowerupPad=true,
	IndustrialGate=true, CollisionFloor=true, ElevatorCar=true, Wax_Door=true, ThingToOpen=true,
	MovingDoor=true, StardustPickup=true, Hole=true, Groundskeeper=true, MandrakeLive=true,
	GardenGateButton=true, LotusPetalPickup=true, VineGuillotine=true, LiveEntityBramble=true,
	RiftSpawn=true, ElevatorBreaker=true, RunnerNodes=true, PathLights=true, DuckBoard=true,
	Padlock=true, EyestalkEndCutscene=true, MinecartRig=true, SeekMovingNewClone=true
}

Functions.QueueObject = function(Object)
	if not AllowedInstances[Object.Name] and Object.ClassName ~= "ProximityPrompt" and Object.Parent ~= CurrentRooms and not ItemNames[Object.Name] then
		return
	end
	table.insert(Globals.ObjectQueue, Object)
end

Globals.QueueDone = true
Connections.QueueConnection = Services.RunService.RenderStepped:Connect(function()
	local Object = table.remove(Globals.ObjectQueue, 1)
	if Object then
		Functions.HandleObject(Object)
	end
end)

for _, Object in Services.Workspace:GetDescendants() do
	task.spawn(function() Functions.QueueObject(Object) end)
end

Connections.InstanceHandler = Services.Workspace.DescendantAdded:Connect(function(Object)
	Functions.QueueObject(Object)
end)

for _, Player in Services.Players:GetPlayers() do
	if Player ~= LocalPlayer then
		if Player.Character and Toggles.PlayerESPToggle.Value then
			Functions.AddESP({ Object = Player.Character, Text = Player.Name, Color = Options.PlayerESPColor.Value })
		end
		local CharConn = Player.CharacterAdded:Connect(function(NewCharacter)
			if Toggles.PlayerESPToggle.Value then
				Functions.AddESP({ Object = NewCharacter, Text = Player.Name, Color = Options.PlayerESPColor.Value })
			end
		end)
		local DeadConn = Player:GetAttributeChangedSignal("Alive"):Connect(function()
			if Player:GetAttribute("Alive") ~= true and Player.Character then
				Functions.RemoveESP(Player.Character)
			end
		end)
		table.insert(Connections, CharConn)
		table.insert(Connections, DeadConn)
		Player.Destroying:Once(function()
			CharConn:Disconnect()
			DeadConn:Disconnect()
		end)
	end
end

Connections.PlayerHandler = Services.Players.PlayerAdded:Connect(function(Player)
	if Player == LocalPlayer then return end
	if Player.Character and Toggles.PlayerESPToggle.Value then
		Functions.AddESP({ Object = Player.Character, Text = Player.Name, Color = Options.PlayerESPColor.Value })
	end
	local CharConn = Player.CharacterAdded:Connect(function(NewCharacter)
		if Toggles.PlayerESPToggle.Value then
			Functions.AddESP({ Object = NewCharacter, Text = Player.Name, Color = Options.PlayerESPColor.Value })
		end
	end)
	local DeadConn = Player:GetAttributeChangedSignal("Alive"):Connect(function()
		if Player:GetAttribute("Alive") ~= true and Player.Character then
			Functions.RemoveESP(Player.Character)
		end
	end)
	table.insert(Connections, CharConn)
	table.insert(Connections, DeadConn)
	Player.Destroying:Once(function()
		CharConn:Disconnect()
		DeadConn:Disconnect()
	end)
end)

local PromptsToFire = {}
local PromptCooldown = {}

Functions.FirePrompt      = Abysall.Environment.fireproximityprompt
Functions.ForceFirePrompt = Abysall.Environment.fireproximityprompt

if not Functions.FirePrompt then
	Functions.FirePrompt = function(Prompt)
		if not Prompt:IsA("ProximityPrompt") or PromptCooldown[Prompt] or table.find(PromptsToFire, Prompt) or not Camera then return end
		table.insert(PromptsToFire, Prompt)
	end
	Functions.ForceFirePrompt = Functions.FirePrompt

	task.spawn(function()
		while task.wait() do
			local Prompt = table.remove(PromptsToFire, 1)
			if not Prompt then continue end
			PromptCooldown[Prompt] = true

			local OldDist   = Prompt.MaxActivationDistance
			local OldEnable = Prompt.Enabled
			local OldParent = Prompt.Parent
			local OldHold   = Prompt.HoldDuration
			local OldLOS    = Prompt.RequiresLineOfSight

			Prompt.MaxActivationDistance = 99999
			Prompt.Enabled = true
			Prompt.HoldDuration = 0
			Prompt.RequiresLineOfSight = false

			local TempPart = Instance.new("Part")
			TempPart.Parent = Services.Workspace
			TempPart.CanCollide = false TempPart.CanQuery = false TempPart.CanTouch = false
			TempPart.Anchored = true TempPart.Transparency = 1
			TempPart.Size = Vector3.new(0.001, 0.001, 0.001)
			TempPart.Position = Camera.CFrame:ToWorldSpace(CFrame.new(0, 0, -0.1)).Position

			if not Prompt or not OldParent then
				TempPart:Destroy()
				PromptCooldown[Prompt] = nil
				continue
			end

			pcall(function() Prompt.Parent = TempPart end)

			local Shown, Fired = false, false

			local ShownConn = Services.ProximityPromptService.PromptShown:Connect(function(P)
				if P == Prompt then Shown = true end
			end)
			local FiredConn = Prompt.Triggered:Connect(function() Fired = true end)

			local T1 = 0
			while not Shown and T1 < 5 do T1 += 1 task.wait() end

			local T2 = 0
			while not Fired and T2 < 5 do
				Prompt:InputHoldBegin()
				Prompt:InputHoldEnd()
				T2 += 1 task.wait()
			end

			Prompt.MaxActivationDistance = OldDist
			Prompt.Enabled = OldEnable
			Prompt.HoldDuration = OldHold
			Prompt.RequiresLineOfSight = OldLOS
			pcall(function() Prompt.Parent = OldParent end)
			task.wait()
			PromptCooldown[Prompt] = nil
			TempPart:Destroy()
			ShownConn:Disconnect()
			FiredConn:Disconnect()
		end
	end)
end

local AutoInteractBlacklist = {
	HidePrompt=true, RiftPrompt=true, StarRiftPrompt=true, InteractPrompt=true, ClimbPrompt=true,
	DonatePrompt=true, DialoguePrompt=true, RevivePrompt=true, EnterPrompt=true, AnimatePrompt=true,
	ToolEventPrompt=true, Prompt=true, PropPrompt=true
}

local TriggerDebounce = false

Functions.TriggerPrompt = function(Prompt)
	if AutoInteractBlacklist[Prompt.Name] then return end
	if not Prompt or not Prompt.Parent then return end
	if TriggerDebounce then return end

	local ParentItem = Functions.HasItem(Prompt.Parent.Name)
	if ParentItem and ParentItem:GetAttribute("Durability") and ParentItem:GetAttribute("DurabilityMax")
		and ParentItem:GetAttribute("Durability") >= ParentItem:GetAttribute("DurabilityMax")
	then return end

	local LockPromptNames = { UnlockPrompt=true, SkullPrompt=true, LockPrompt=true, ThingToEnable=true, FusesPrompt=true }
	local IsLockPrompt = LockPromptNames[Prompt.Name]
		or (Prompt.Parent and Prompt.Parent:GetAttribute("Locked") == true)
		or (Prompt.Parent and Prompt.Parent.Parent and Prompt.Parent.Parent.Name == "Locker_Small_Locked" and Prompt.Name == "ActivateEventPrompt")

	if IsLockPrompt then
		if Options.AutoInteractIgnoreList.Value["Locks"] then return end
		local KeyItems = { "Key","GeneratorFuse","KeyBackdoor","KeyElectrical","KeyIron","Lockpick","SkeletonKey","Shears","Multitool" }
		local OffhandKeyItems = { "Key","GeneratorFuse","KeyElectrical","KeyIron" }
		local HasKey = false
		for _, K in KeyItems do if Functions.HasItem(K, true) then HasKey = true break end end
		for _, K in OffhandKeyItems do if Functions.HasItem(K) then HasKey = true break end end
		if not HasKey then return end
	end

	if Prompt.Parent.Name == "CuttableVines" and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) or Prompt.Parent.Name == "Chest_Vine" and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) or Prompt.Parent.Name == "Cellar" and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) then return end
	if Prompt.Parent.Name == "SkullLock" and not Functions.HasItem("SkeletonKey", true) then return end
	if Prompt.Parent.Name == "Lock1" and not Functions.HasItem("Lockpick", true) and not Functions.HasItem("Multitool", true) or Prompt.Parent.Name == "Lock2" and not Functions.HasItem("Lockpick", true) and not Functions.HasItem("Multitool", true) then return end
	if Functions.HasItem("Shears", true) and IsLockPrompt and Prompt.Parent.Name ~= "CuttableVines" and Prompt.Parent.Name ~= "Chest_Vine" and Prompt.Parent.Name ~= "Cellar" then return end

	if Prompt.Parent.Name == "GlitchCube" and Options.AutoInteractIgnoreList.Value["Glitch Fragments"] then return end

	if (Prompt.Parent.Name == "KeyObtain" and (Functions.HasItem("Key") or Functions.HasItem("KeyBackdoor")))
		or (Prompt.Parent.Name == "ElectricalKeyObtain" and Functions.HasItem("KeyElectrical"))
	then return end

	if Prompt:IsDescendantOf(Drops) and Options.AutoInteractIgnoreList.Value["Dropped Items"] then return end
	if Prompt.Parent.Name == "TrackLever" then return end
	if Prompt.Name == "ActivateEventPrompt" and (Prompt.ActionText == "Close"
		or Prompt.Parent.Name == "ElevatorBreaker"
		or (Prompt.Parent.Parent and Prompt.Parent.Parent.Name == "IndustrialGate"))
	then return end
	if Prompt.Name == "ActivateEventPrompt" and (Prompt.Parent.Name == "Padlock" or Prompt.Parent.Name == "MinesAnchor") then return end
	if Prompt.Parent.Name == "LeverForGate" and Prompt:GetAttribute("Interactions") then return end
	if Prompt.Parent.Parent and (Prompt.Parent.Parent.Name == "DoorFake" or Prompt.Parent.Parent.Name == "FakeDoor") then return end
	if Prompt.Parent:GetAttribute("JeffShop") and Options.AutoInteractIgnoreList.Value["Jeff Items"] then return end
	if Prompt:GetAttribute("AutoInteractIgnore") then return end
	if Prompt.Name == "PushPrompt" and Options.AutoInteractIgnoreList.Value["Minecarts"] then return end
	if (Prompt.Parent.Name == "GoldPile" or Prompt.Parent.Name == "StardustPickup") and Options.AutoInteractIgnoreList.Value["Currency"] then return end

	if Prompt.Parent.Name == "Bandage" then
		local BPack = Functions.HasItem("BandagePack")
		if Humanoid.Health >= Humanoid.MaxHealth and not BPack then return end
		if BPack and BPack:GetAttribute("Durability") >= BPack:GetAttribute("DurabilityMax") then return end
	end

	if Prompt.Parent.Name == "Battery" then
		local Tool = Character:FindFirstChildOfClass("Tool")
		local BPack = Functions.HasItem("BatteryPack")
		if not Tool and not BPack then return end
		if Tool and Tool:GetAttribute("LightSource") then
			if Tool:GetAttribute("Durability") and Tool:GetAttribute("DurabilityMax")
				and Tool:GetAttribute("Durability") > Tool:GetAttribute("DurabilityMax")
			then return end
		elseif not BPack then
			return
		end
		if BPack and BPack:GetAttribute("Durability") >= BPack:GetAttribute("DurabilityMax") then return end
	end

	if Prompt.Name == "HerbPrompt" then
		local Effects = Globals.MainUI.MainFrame.Healthbar:FindFirstChild("Effects")
		if Effects and Effects.HerbGreenEffect.Visible then return end
	end

	if (Prompt.Parent.Name == "LibraryHintPaper" or Prompt.Parent.Name == "PickupItem") and (Functions.HasItem("LibraryHintPaper") or Functions.HasItem("LibraryHintPaperHard")) then return end
	if Prompt.Parent.Name == "AlarmClock" and Functions.HasItem("AlarmClock") then return end
	if Prompt.Parent.Name == "KeyObtainFake" or Prompt.Parent.Name == "TithingPlate" then return end

	Functions.FirePrompt(Prompt)
	TriggerDebounce = true
	if Floor == "OldHotel" then task.wait() end
	TriggerDebounce = false
end

Globals.LastAutoInteractFire = tick()
Connections.AutoInteract = Services.RunService.Heartbeat:Connect(function()
	local Active = Toggles.AutoInteractToggle.Value or Options.AutoInteractKeybind:GetState()
    if not Active then return end
    if tick() - Globals.LastAutoInteractFire < 1/60 then return end

	for _, Prompt in Objects.Prompts do
        if Prompt:GetAttribute("ParentRoom") and tonumber(Prompt:GetAttribute("ParentRoom")) ~= tonumber(LocalPlayer:GetAttribute("CurrentRoom")) then continue end

		if Prompt.Parent and (Prompt.Parent:IsA("BasePart") or Prompt.Parent:IsA("Model")) then
			local Distance
			if Prompt.Parent:IsA("BasePart") then
				Distance = LocalPlayer:DistanceFromCharacter(Prompt.Parent.Position)
			else
				Distance = LocalPlayer:DistanceFromCharacter(Prompt.Parent:GetPivot().Position)
			end
			if Distance <= Prompt.MaxActivationDistance and Prompt.Enabled or Distance <= Prompt.MaxActivationDistance and Prompt.Name == "LongPushPrompt" or Distance <= Prompt.MaxActivationDistance and Prompt.Name == "BigPropPrompt" then
				task.spawn(Functions.TriggerPrompt, Prompt)
			end
		end
	end
    Globals.LastAutoInteractFire = tick()
end)

Connections.InfiniteItemsHandler = Services.ProximityPromptService.PromptTriggered:Connect(function(Object)
	if not Object:GetAttribute("FakePrompt") then return end

	local ToolNames = { "Lockpick","Shears","SkeletonKey","Key","GeneratorFuse","KeyElectrical","KeyBackdoor","KeyIron", "Multitool" }
	local AnimateToolNames = { "Lockpick","Shears","SkeletonKey","Key","KeyElectrical","KeyBackdoor","KeyIron", "Multitool" }
	local Tool
	for _, N in ToolNames do Tool = Character:FindFirstChild(N) if Tool then break end end

	local Prompt = Object
	local LockPromptNames = { UnlockPrompt=true, SkullPrompt=true, LockPrompt=true, ThingToEnable=true, FusesPrompt=true }
	local IsLockPrompt = LockPromptNames[Object.Name]
		or (Object.Parent and Object.Parent:GetAttribute("Locked") == true)
		or (Object.Parent and Object.Parent.Parent and Object.Parent.Parent.Name == "Locker_Small_Locked" and Object.Name == "ActivateEventPrompt")
	if IsLockPrompt then
		if Options.AutoInteractIgnoreList.Value["Locks"] then return end
		local KeyItems = { "Key","GeneratorFuse","KeyBackdoor","KeyElectrical","KeyIron","Lockpick","SkeletonKey","Shears","Multitool" }
		local OffhandKeyItems = { "Key","GeneratorFuse","KeyElectrical","KeyIron" }
		local HasKey = false
		for _, K in KeyItems do if Functions.HasItem(K, true) then HasKey = true break end end
		for _, K in OffhandKeyItems do if Functions.HasItem(K) then HasKey = true break end end
		if not HasKey then return end
	end

	if Prompt.Parent.Name == "CuttableVines" and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) or Prompt.Parent.Name == "Chest_Vine" and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) or Prompt.Parent.Name == "Cellar" and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) then return end
	if Prompt.Parent.Name == "SkullLock" and not Functions.HasItem("SkeletonKey", true) then return end
	if Prompt.Parent.Name == "Lock1" and not Functions.HasItem("Lockpick", true) and not Functions.HasItem("Multitool", true) or Prompt.Parent.Name == "Lock2" and not Functions.HasItem("Lockpick", true) and not Functions.HasItem("Multitool", true) then return end
	if Functions.HasItem("Shears", true) and IsLockPrompt and Prompt.Parent.Name ~= "CuttableVines" and Prompt.Parent.Name ~= "Chest_Vine" and Prompt.Parent.Name ~= "Cellar" then return end

	if Tool and table.find(AnimateToolNames, Tool.Name) and Globals.UseAnimation and Globals.UseAnimationBreak then
		Globals.UseAnimation:Stop()
		Globals.UseAnimationBreak:Stop()
		Globals.UseAnimationBreak:Play()
		if Tool.Name == "Shears" then Tool:WaitForChild("Handle"):WaitForChild("sound_prompt"):Play() end
	end

	local AnyTool = Character:FindFirstChildOfClass("Tool")
	local ToolData = AnyTool and ItemNames[AnyTool.Name]
	if AnyTool and ToolData and Toggles.InfiniteItemsToggle.Value and Options.InfiniteItemsList.Value[ToolData] then
		Drops.ChildAdded:Once(function(NewTool)
			local Prompt = NewTool:FindFirstChild("ModulePrompt")
			local RealPrompt = FakePrompts[Object]
			Functions.FirePrompt(Prompt)
			Functions.FirePrompt(RealPrompt)
		end)
		Character.ChildAdded:Once(function(NewTool)
			if NewTool.Name == "Shears" then NewTool:WaitForChild("Handle"):WaitForChild("sound_promptend"):Play() end
		end)
		RemotesFolder.DropItem:FireServer(AnyTool)
	else
		local RealPrompt = FakePrompts[Object]
		Functions.FirePrompt(RealPrompt)
	end
end)

Connections.FloorReplicatedHandler = FloorReplicated.DescendantAdded:Connect(function(Object)
	if Object.Name == "GlitchScreech" then
		Modules.GlitchScreech = Object
		if Toggles.RemoveScreech.Value then Object.Name = "GlitchScreech_Disabled" end
	end
	if Object.Name:find("Jumpscare") and Object:IsA("ModuleScript")
		and not Object.Name:find("Eyestalk") and not Object.Name:find("Groundskeeper") and not Object.Name:find("Monument")
	then
		Object:SetAttribute("OriginalName", Object.Name)
		if Toggles.DisableEntityJumpscares.Value then Object.Name = Object.Name .. "_Disabled" end
		table.insert(Objects.JumpscareModules, Object)
	end
end)

if FloorReplicated:FindFirstChild("DigitalTimer") then
	Connections.HasteTimerConnection = FloorReplicated.DigitalTimer:GetPropertyChangedSignal("Value"):Connect(function()
		if Toggles.NotifyHasteTime.Value then Functions.Caption(Functions.GetHasteTime(), true) end
	end)
end

Connections.FogHandler = Services.Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
	if Services.Lighting.FogEnd ~= 10000000 then
		Globals.OldFog = Services.Lighting.FogEnd
	end
	if Toggles.RemoveCameraFog.Value then
		Services.Lighting.FogEnd = 10000000
	end
end)

Connections.FogHandler2 = Services.Lighting.DescendantAdded:Connect(function(Object)
	if not Object:IsA("Atmosphere") then return end
	Object:SetAttribute("Density_Old", Object.Density)
	if Toggles.RemoveCameraFog.Value then Object.Density = 0 end

	local AtmoConn2 = Object:GetPropertyChangedSignal("Density"):Connect(function()
		if Object.Density ~= 0 then Object:SetAttribute("Density_Old", Object.Density) end
		if Toggles.RemoveCameraFog.Value then Object.Density = 0 end
	end)
	Object.Destroying:Once(function() AtmoConn2:Disconnect() end)
	table.insert(Connections, AtmoConn2)
	table.insert(Globals.FogInstances, Object)
end)

local RusherAliases = { Rush=true, Ambush=true, Eyes=true, Lookman=true, Blitz=true, ["A-60"]=true, ["A-120"]=true, AR0xMBUSH=true, ["RNIUSHCG=="]=true, ["Custom Entity"]=true }

Connections.EntityHandler = Services.Workspace.ChildAdded:Connect(function(Entity)
	local EntityData = Entities[Entity.Name]
	if not EntityData then return end

	while not Entity.PrimaryPart do
		for _, Child in Entity:GetChildren() do
			if Child:IsA("BasePart") then Entity.PrimaryPart = Child end
		end
		task.wait()
	end
	task.wait(0.1)

	if not Entity.PrimaryPart or LocalPlayer:DistanceFromCharacter(Entity.PrimaryPart.Position) >= 10000 then return end

	local Alias = EntityData.Alias
    local RealAlias = Alias
	if Options.EntityList.Value[Alias] and Toggles.NotifyEntities.Value then
		local NotifyTitle = EntityData.NotifyMessage.Title
		local NotifyBody  = EntityData.NotifyMessage.Body
		local NotifyImage = EntityIcons[Entity.Name]

		if Entity.Name == "RushMoving" and Entity.PrimaryPart.Name ~= "RushNew" then
			NotifyTitle = NotifyTitle:gsub("Rush", Entity.PrimaryPart.Name)
			NotifyImage = Entity.PrimaryPart:WaitForChild("Attachment").ParticleEmitter.Texture
			Alias = Entity.PrimaryPart.Name
		end

		Functions.Notify({ Title = NotifyTitle, Body = NotifyBody, Image = NotifyImage, Time = Toggles.NotifyKeepNotifications.Value and Entity or nil })

		if Toggles.EntityChatToggle.Value then
			Functions.SendChat(Alias .. " " .. Options.EntityChatMessage.Value)
		end
	end

	if Entity.Name ~= "GloombatSwarm" then
		if Toggles.EntityESPToggle.Value and Options.EntityESPOptions.Value[RealAlias] then
			if Entity.Name == "MonumentEntity" then
				Functions.AddESP({ Object = Entity.Top, Text = Alias, Color = Options.EntityESPColor.Value })
			else
				Functions.AddESP({ Object = Entity, Text = Alias, Color = Options.EntityESPColor.Value })
			end
		end
		table.insert(Objects.Entities, Entity)
	end

	if RusherAliases[EntityData.Alias] then
		Instance.new("Humanoid", Entity).Name = "HighlightHumanoid"
		local Root = Entity.PrimaryPart
		if Root then Root.Transparency = 0.999 Root.Material = Enum.Material.Plastic end
	end

	if Entity.Name == "Lookman" then
		CurrentRooms.ChildAdded:Wait()
		task.wait(10)
		Entity:Destroy()
	end
end)

local LastClean = tick()
Connections.Cleaner = Services.RunService.Heartbeat:Connect(function()
	if tick() - LastClean <= 0.5 then return end
	LastClean = tick()

	for ArrayName, Array in Objects do
		local I = #Array
		while I >= 1 do
			local Object = Array[I]
			if Object == nil or not Object:IsDescendantOf(Services.Workspace) then
				table.remove(Array, I)
				local Conn = ESPConnections[Object]
				if Conn then
					Conn:Disconnect()
					ESPConnections[Object] = nil
					local Pos = table.find(Connections, Conn)
					if Pos then table.remove(Connections, Pos) end
				end
			end
			I -= 1
		end
	end
end)

local LastPromptFix = tick()
Connections.PromptFixer = Services.RunService.Heartbeat:Connect(function()
	if tick() - LastPromptFix <= 0.5 then return end
	LastPromptFix = tick()
	for _, Prompt in Objects.Prompts do
		if Prompt:HasTag("DisableWhenEnabledOnClient") then
			Prompt:RemoveTag("DisableWhenEnabledOnClient")
		end
	end
end)

if LocalPlayer.Character then
	task.spawn(function() Functions.HandleCharacter(LocalPlayer.Character) end)
end

LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
	if Connections.MainHandler then
		Connections.MainHandler:Disconnect()
		Connections.MainHandler = nil
	end
	task.wait(0.5)
	Functions.HandleCharacter(NewCharacter)
end)

Library:OnUnload(function()
	for Key, Connection in Connections do
		if type(Key) == "string" then
			pcall(function() Connection:Disconnect() end)
		else
			pcall(function() Key:Disconnect() end)
			pcall(function() Connection:Disconnect() end)
		end
	end

	for _, Object in Objects.Entities do
		if Object.Name == "Snare" or Object.Name == "GiggleCeiling" then
			local Hitbox = Object:FindFirstChild("Hitbox")
			if Hitbox then Hitbox.CanTouch = true end
		end
		if Object.Name == "GloomPile" then
			for _, Part in Object:GetDescendants() do
				if Part:IsA("BasePart") then Part.CanTouch = true end
			end
		end
		if Object.Name == "FakeDoor" or Object.Name == "DoorFake" then
			local Hidden = Object:FindFirstChild("Hidden")
			if Hidden then Hidden.CanTouch = true end
			local Lock = Object:FindFirstChild("Lock")
			if Lock and Lock:FindFirstChild("UnlockPrompt") then Lock.UnlockPrompt.Enabled = true end
		end
		if Object.Name == "SideroomSpace" then
			local Coll = Object:FindFirstChild("Collision")
			if Coll then Coll.CanCollide = false Coll.CanTouch = true end
		end
	end

	for _, Object in Objects.SeekBridges do Object:Destroy() end

	for _, Fog in Globals.FogInstances do
		Fog.Density = Fog:GetAttribute("Density_Old")
	end
	Services.Lighting.FogEnd = Globals.OldFog

	local Vignette = Globals.MainUI:FindFirstChild("HideVignette") or Globals.MainUI.MainFrame:FindFirstChild("HideVignette")
	if Vignette then Vignette.Image = "rbxassetid://6100076320" end

	local ModuleRestores = {
		Screech = "Screech", Glitch = "Glitch", Shade = "Shade",
		SpiderJumpscare = "SpiderJumpscare", A90 = "A90", Dread = "Dread", Void = "Void"
	}
	for Key, OriginalName in ModuleRestores do
		if Modules[Key] then Modules[Key].Name = OriginalName end
	end

	FakeEvents.Screech:Destroy()
	FakeEvents.Screech_Real.Parent = RemotesFolder
	FakeEvents.Shade:Destroy()
	FakeEvents.Shade_Real.Parent = RemotesFolder

	if FakeEvents.A90_Real then
		FakeEvents.A90:Destroy()
		FakeEvents.A90_Real.Parent = RemotesFolder
	end
	if FakeEvents.Surge_Real then
		FakeEvents.Surge:Destroy()
		FakeEvents.Surge_Real.Parent = RemotesFolder
	end

	Globals.SeekNodesFolder:Destroy()
	Globals.RoomsNodesFolder:Destroy()
	Globals.ManipulateBody:Destroy()

	local OldAmbient = CurrentRooms:FindFirstChild(tostring(LocalPlayer:GetAttribute("CurrentRoom"))):GetAttribute("Ambient")
	Services.TweenService:Create(Services.Lighting, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), { Ambient = OldAmbient }):Play()

	for _, Prompt in Objects.Prompts do
		if FakePrompts[Prompt] then
			FakePrompts[Prompt].Parent = Prompt.Parent
			Prompt:Destroy()
		end
		if Prompt.Parent then
			Prompt.HoldDuration = Prompt:GetAttribute("HoldDuration_Old") or Prompt.HoldDuration
			Prompt.RequiresLineOfSight = Prompt:GetAttribute("RequiresLineOfSight_Old") or Prompt.RequiresLineOfSight
			Prompt.MaxActivationDistance = Prompt:GetAttribute("MaxActivationDistance_Old") or Prompt.MaxActivationDistance
		end
	end

	Character:SetAttribute("CanJump",  OldJump)
	Character:SetAttribute("CanSlide", OldSlide)

	for _, Object in Services.Workspace:GetDescendants() do
		task.spawn(function() Functions.RemoveESP(Object) end)
	end

	Humanoid.WalkSpeed  = Functions.GetCurrentSpeed()
	Humanoid.JumpPower  = 5
	Humanoid.HipHeight  = 2.367

	local BaseY = 0.18
	Collision.Position          = RootPart.Position + Vector3.new(0, BaseY, 0)
	CollisionPart.Position      = RootPart.Position + Vector3.new(0, BaseY, 0)
	CollisionPartClone.Position = RootPart.Position + Vector3.new(0, BaseY, 0)

	if Character:FindFirstChild("LowerTorso") and Character.LowerTorso:FindFirstChild("Root") then
		Character.LowerTorso.Root.C1 = Globals.OriginalC1
	end
	if Collision:FindFirstChild("CollisionCrouch") then
		Collision.CollisionCrouch.Position = RootPart.Position + Vector3.new(0, -0.982, 0)
	end

	CollisionClone:Destroy()
	CollisionPartClone:Destroy()
	Abysall.ESPLibrary:Unload()

	if Main_Game then
		Main_Game.fovtarget   = 70
		Main_Game.spring.Speed = 8
		Main_Game.tooloffset   = Vector3.zero
	end

	if Globals.OriginalGetMoveVector then 
		local Controls = require(LocalPlayer.PlayerScripts.PlayerModule):GetControls()
		Controls.GetMoveVector = Globals.OriginalGetMoveVector
	end

	getgenv().Abysall = nil
end)

while not Globals.MainUI do task.wait() end
Abysall.Interface.ApplySettingsTab(Window)
Functions.Notify({ Title = "Successfully loaded in " .. math.floor((tick() - LoadStart) * 1000) / 1000 .. " seconds." , Body = "Press '" .. tostring(Options.MenuKeybind.Value) .. "' to toggle the UI."})


-- ================= TPLAY'S ADDON INTEGRATION =================
local ADDON_CONFIG = {
	IncludeAddedFeatures = true,
	SeparateTabForAddon = true,
	AltFeatures = true,
	Debug = true,
}
ADDON_CONFIG = getgenv()._TPLAYS_ADDON_CONFIG or ADDON_CONFIG
getgenv()._TPLAYS_ADDON_CONFIG = ADDON_CONFIG

local mspaint = {
	AddonInfo = { Name = "TplaysAddon", Title = "Tplay's Addon", Game = "*" },
	ExecutorSupport = { firetouchinterest = type(firetouchinterest) == "function" }
}

local AddonName = mspaint.AddonInfo.Name
local AddonTitle = mspaint.AddonInfo.Title
local prefix = AddonName:lower().."_"

--wow its 'missing' function from infinite yield
function func(t, f, fallback)
	if type(f) == t then return f end
	return fallback
end

function GetFunction(fn: string, e: boolean, fs: Instance): (any) -> any
	local success, result = pcall(function()
		local result = filtergc("function", {
			Name = fn,
			IgnoreExecutor = not e,
		}, true)
		if typeof(result) == "table" and typeof(fs) == "Instance" and fs:IsA("Script") then
			for _, func in result do
				local info = debug.getinfo(func)
				if func.short_src == fs:GetFullName() then
					return func
				end
			end
		end
		result = result[1]
		return result
	end)
	return success and result
end

local oldestmethods = {}

local readfile = func("function", readfile, function() return "" end)
local writefile = func("function", writefile, function() end)
local delfile = func("function", delfile, function() end)
local isfile = func("function", isfile, function() end)
local makefolder = func("function", makefolder, function() end)
local listfiles = func("function", listfiles, function() return {} end)
local cloneref = func("function", cloneref, function(...) return ... end)
local isfunctionhooked = func("function", isfunctionhooked, function(...) return end)
local getrawmetatable = func("function", getrawmetatable or get_raw_metatable, function(...) return end)
local setreadonly = func("function", setreadonly or set_read_only)
local getnamecallmethod = func("function", getnamecallmethod or get_namecall_method)
local checkcaller = func("function", checkcaller or check_caller, function(...) return end)
local restoremetamethod = func("function", restoremetamethod or restore_meta_method, getrawmetatable(game) and setreadonly and function(object, method)
	local oldestmethod = oldestmethods[object] and oldestmethods[object][method]
	if oldestmethod then
		local metatable = getrawmetatable(object)
		setreadonly(metatable, false)
		metatable[method] = oldestmethod
		setreadonly(metatable, true)
		oldestmethods[object][method] = nil
	end
end)
local _hookmetamethod = func("function", hookmetamethod or hook_meta_method, getrawmetatable(game) and setreadonly and function(object, method, func)
	local metatable = getrawmetatable(object)
	local oldmethod = metatable[method]
	setreadonly(metatable, false)
	metatable[method] = func
	setreadonly(metatable, true)
	return oldmethod
end)

local hookmetamethod = _hookmetamethod and function(object: Object, method: string, func: (any) -> any)
	local result = _hookmetamethod(object, method, func)
	if result and not (oldestmethods[object] and oldestmethods[object][method]) then
		oldestmethods[object] = oldestmethods[object] or {}
		oldestmethods[object][method] = result
	end
	return result
end

function restoremetamethods()
	if not hookmetamethod then
		oldestmethods = nil
		restoremetamethods = nil
		return
	end
	for object, methods in oldestmethods do
		for methodName, method in methods do
			pcall(restoremetamethod, object, methodName)
		end
	end
	oldestmethods = nil
	restoremetamethods = nil
end

Services = setmetatable({}, {
	__index = function(self, name)
		local success, cache = pcall(function()
			return cloneref(game:GetService(name))
		end)
		if success then
			rawset(self, name, cache)
			return cache
		end
	end
})

local function genName()
	local str = ""
	for _ = 1,64 do
		str ..= string.char(math.random(33,126))
	end
	return str
end

local Toggles = {}
local KeyPickers = {}

local ReloadSignals
if debug.setinfo then
	if getgenv()._TPLAYS_ADDON_VALUES then
		for _, bool in getgenv()._TPLAYS_ADDON_VALUES do
			bool:Destroy()
		end
		getgenv()._TPLAYS_ADDON_VALUES = nil
	end
	getgenv()._TPLAYS_ADDON_VALUES = {
		Loaded = Instance.new("BoolValue"),
		Reload = Instance.new("BoolValue")
	}
	getgenv()._TPLAYS_ADDON_VALUES.Loaded.Value = true
	ReloadSignals = {}
end

local function destroyUnloadSignal(name)
	for index, func in Library.UnloadSignals do
		if debug.getinfo(func).name == name then
			table.remove(Library.UnloadSignals, index)
			break
		end
	end
end

local reloadConnection; reloadConnection = getgenv()._TPLAYS_ADDON_VALUES and getgenv()._TPLAYS_ADDON_VALUES.Reload:GetPropertyChangedSignal("Value"):Connect(function()
	if getgenv()._TPLAYS_ADDON_VALUES.Reload.Value then
		reloadConnection:Disconnect()
		for name, reloadFunc in ReloadSignals do
			destroyUnloadSignal(name)
			local success, err = pcall(reloadFunc, true)
			if not success then
				Library:Notify({
					Title = 'wow something went wrong while reloading',
					Description = err,
					Time = 10
				})
			end
		end
		ReloadSignals = nil
		if ADDON_CONFIG.SeparateTabForAddon then
			for _, picker in KeyPickers do
				picker:Destroy()
			end
			for _, toggle in Toggles do
				toggle:Destroy()
			end
		end
		task.wait(.1)
		getgenv()._TPLAYS_ADDON_VALUES.Loaded.Value = false
	end
end)

Library:OnUnload(function()
	if ReloadSignals then
		ReloadSignals = nil
	else
		return -- the addon was reloaded, don't try to unload using this function
	end
	if getgenv()._TPLAYS_ADDON_VALUES then
		for _, bool in getgenv()._TPLAYS_ADDON_VALUES do
			bool:Destroy()
		end
		getgenv()._TPLAYS_ADDON_VALUES = nil
	end
	if getgenv()._TPLAYS_ADDON_CONFIG then
		getgenv()._TPLAYS_ADDON_CONFIG = nil
	end
end)

local function OnUnload(func: (WasReloaded: boolean?) -> ()): ()
	if debug.setinfo then
		local funcName = genName()
		debug.setinfo(func, {name = funcName})
		Library:OnUnload(func)
		ReloadSignals[funcName] = func
	else
		Library:OnUnload(func)
	end
end

local tpath = "mspaint/"..AddonName
local addon = {
	makefolder = function(path: string): ()
		makefolder(`{tpath}/{path}`)
	end,
	listfiles = function(path: string): {string}
		return listfiles(`{tpath}/{path}`)
	end,
	readfile = function(path: string): string
		return readfile(`{tpath}/{path}`)
	end,
	writefile = function(path: string, str: string): ()
		writefile(`{tpath}/{path}`, str)
	end,
	delfile = function(path: string): ()
		delfile(`{tpath}/{path}`)
	end,
	isfile = function(path: string): boolean
		return isfile(`{tpath}/{path}`)
	end,
	getcustomasset = getcustomasset and function(path: string): string
		return getcustomasset(`{tpath}/{path}`)
	end,
}

local HttpService = Services.HttpService

makefolder(tpath)
addon.makefolder("cache")

local Module = {}
Module.LoadCustomAsset = function(url: string, name: string?): string?
	if addon.getcustomasset then
		local fileName = `cache/{name}` or `cache/TMP_{tick()}`
		local success, result = pcall(addon.getcustomasset, fileName)
		result = success and result
		if result then
			return result
		elseif url:lower():sub(1, 4) == 'http' then
			addon.writefile(fileName, game:HttpGet(url))
			result = addon.getcustomasset(fileName)
			if not name then
				addon.delfile(fileName)
			end
			return result
		elseif addon.isfile(url) then
			return addon.getcustomasset(url)
		end
	else
		warn("Executor doesn't support 'getcustomasset', rbxassetid only.")
	end
	if url:find('rbxassetid') or tonumber(url) then
		return 'rbxassetid://'..url:match('%d+')
	end
	error(debug.traceback('Failed to load custom asset for:\n'..url))
end

Module.LoadCustomInstance = function(url: string, name: string?): Instance?
	local s, r = pcall(function()
		return game:GetObjects(Module.LoadCustomAsset(url, name))[1]
	end)
	return s and r or nil
end


-- Integrated groupboxes inside Abysall Hub's own window.
local Window = TplayTab.Window
local Groupbox = TplayTab:AddLeftGroupbox("Main")
local Groupbox2 = TplayTab:AddRightGroupbox("Other")

if game.PlaceId == 6516141723 then
	local ReplicatedStorage = Services.ReplicatedStorage
	local RemotesFolder = ReplicatedStorage:WaitForChild("RemotesFolder")
	local Create = RemotesFolder.CreateElevator
	local Leave = RemotesFolder.ElevatorExit
	local Connections = {}

	local queue_on_teleport = func("function", queue_on_teleport or queueonteleport)
	local clear_teleport_queue = func("function", clear_teleport_queue or clearteleportqueue)

	writefile("teleporthandler", [[if game.PlaceId ~= 6839171747 then return end
function GetFunction(fn: string, e: boolean, fs: Instance): (any) -> any
	local success, result = pcall(function()
		return filtergc("function", {
			Name = fn,
			Source = fs and (typeof(fs) == "string" and fs or typeof(fs) == "Instance" and fs.Name),
			IgnoreExecutor = not e,
		}, true)
	end)
	return success and result
end
local players = game:GetService("Players")
local player = players.LocalPlayer
if not player then
    players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    player = players.LocalPlayer
end
local tpdata = game:GetService("TeleportService"):GetLocalPlayerTeleportData()
if tpdata and tpdata.Settings and tpdata.Settings.cMode == "true" and tpdata.Host == player.UserId then
    player:SetAttribute("Observer", true)
	if not player.Character then
		player.CharacterAdded:Wait()
	end
	workspace.CurrentRooms.ChildAdded:Once(function()
		replicatesignal(player.Kill)
	end)
	task.wait()
	while not pcall(function()GetFunction("healthChanged")(0)end)do task.wait()end
end
queue_on_teleport(readfile("teleporthandler"))]])
	local execute = readfile("teleporthandler")
	local hasteleporthandler = filtergc and queue_on_teleport and clear_teleport_queue and execute and true or false
	if hasteleporthandler then
		queue_on_teleport(execute)
	end

	Groupbox:AddDivider({
		Text = "MAIN",
		MarginTop = 2,
		MarginBottom = -2
	})

	Groupbox:AddButton(prefix..'BloxfestMode', {
		Text = 'Bloxfest Battle Elevator',
		Tooltip = 'Create battle elevator with observer powers (used for RB Battles)',
		Default = BloxfestMode,
		DisabledTooltip = "Executor is not supported",
		Disabled = not (hasteleporthandler and filtergc),
		Callback = function(value)
			Create:FireServer({
				Mods = {},
				Settings = {
					cMode = "true"
				},
				Destination = "Party",
				FriendsOnly = false,
				MaxPlayers = "20"
			})
		end
	})

	local button; button = Groupbox:AddButton(prefix..'Crash', {
		Text = 'Crash',
		DisabledTooltip = "Crashing...",
		DoubleClick = true,
		Risky = true,
		Func = function()
			button:SetDisabled(true)
			local coolseed = string.rep(utf8.char(2^16), 2^6)
			while''do
				coroutine.wrap(function()
					for i = 1,100 do
						coroutine.wrap(function()
							Create:FireServer({
								Mods = i%2 == 1 and {
									"AdminPanel",
									"Chaos3",
									"Gloombat",
									"NoGuidingLight",
									"PlayerCrouchSlow",
									"TimothyMore",
									"ItemDurabilityLess",
									"AmbushMore",
									"ScreechLight",
									"ScreechFast",
									"EyesTwice",
									"EyesLevel2",
									"AmbushFaster",
									"RushFaster",
									"BackdoorHaste",
									"BackdoorVacuum",
									"BackdoorLookman",
									"SnareMoster",
									"NoKeySound",
									"BackdoorRush",
									"LightsLess",
									"LeastHidingSpots",
									"Rooms",
									"Fog",
									"GiggleMore",
									"StreamerMode",
									"DreadMost",
									"HideLevel2",
									"GoldSpawnNone",
									"FigureFaster",
									"Slippery",
									"CustomSeed",
									"Voicelines",
									"RushLevel2",
									"RushQuiet",
									"RushMore",
									"EntitiesMoster",
									"LockMore",
									"DupeMore",
									"FiredampMost",
									"PlayerDamageMore"
								} or {"AdminPanel"},
								Settings = {
									seed = coolseed,
									cMode = coolseed
								},
								Destination = "Hotel",
								FriendsOnly = false,
								MaxPlayers = "50"
							})
							Leave:FireServer()
						end)()
					end
				end)()
				task.wait()
			end
		end
	})

	Groupbox:AddDivider({
		Text = "REJOIN",
		MarginTop = 2,
		MarginBottom = -2
	})

	local scripts = {
		HideRank = {
			source = [[while not game:GetService('ReplicatedStorage'):FindFirstChild('RemotesFolder') do
				task.wait()
			end
			while not game:GetService('ReplicatedStorage'):FindFirstChild('RemotesFolder'):FindFirstChild('CheckRank') do
				task.wait()
			end
			game:GetService('ReplicatedStorage').RemotesFolder.CheckRank:Destroy()]],
			enabled = false
		},
	}

	Toggles.HideRank = Groupbox:AddToggle(prefix..'HideRank', {
		Text = 'Hide Rank',
		DisabledTooltip = 'Executor is not supported',
		Tooltip = 'Hides rank while hardstuck badge is equipped',
		Disabled = not hasteleporthandler,
		Default = false,

		Callback = function(value)
			scripts.HideRank.enabled = value
		end
	})

	Groupbox:AddButton(prefix..'Rejoin', {
		Text = 'Rejoin',
		DoubleClick = true,
		Func = function()
			if queue_on_teleport then
				local finalscript = ""
				for _, script in scripts do
					if script.enabled then
						finalscript ..= `task.spawn(function() {script.source} end)`
					end
				end
				queue_on_teleport(finalscript)
			end
			Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
		end
	})

	OnUnload(function(wasReloaded)
		local success = 0
		local connections = 0
		for _, toggle in Toggles do
			if toggle.Value then
				pcall(toggle.Callback, false)
			end
		end
		for _, connection in Connections do
			pcall(function()
				connection:Disconnect()
				success += 1
			end)
			connections += 1
		end
		if hasteleporthandler then
			clear_teleport_queue()
		end
		restoremetamethods()
		print(`[{AddonTitle}]: {wasReloaded and "reloaded" or "unloaded"}!{connections > 0 and ` (disconnected {success} connections out of {connections})` or ""}`)
	end)
elseif game.GameId == 2440500124 then
	local Camera = workspace.CurrentCamera
	local Players = Services.Players
	local RunService = Services.RunService
	local EncodingService = Services.EncodingService
	local ReplicatedStorage = Services.ReplicatedStorage
	local PathfindingService = Services.PathfindingService
	local Debris = Services.Debris
	local RemotesFolder = ReplicatedStorage:WaitForChild("RemotesFolder", 999)
	local GameData = ReplicatedStorage:WaitForChild("GameData", 999)
	local Projectiles = ReplicatedStorage:WaitForChild("Projectiles", 999)
	local ReplicaDataModule = require(ReplicatedStorage:WaitForChild("ReplicaDataModule", 999))
	local Floor = GameData:WaitForChild("FloorDestination", 999).Value
	local LatestRoom = GameData:WaitForChild("LatestRoom", 999)
	local OpenedFirstDoor = GameData:WaitForChild("OpenedFirstDoor", 999)
	local PlayerRigs = ReplicatedStorage:WaitForChild("PlayerRigs", 999)

	local TPPath = PathfindingService:CreatePath({
		AgentRadius = 1,
		AgentHeight = 1,
		AgentCanJump = true,
		AgentCanClimb = true,
		WaypointSpacing = 3
	})

	local Crouch = RemotesFolder.Crouch
	local FireToolProjectile = RemotesFolder.FireToolProjectile
	--[[local FireProjectile = RemotesFolder.FireProjectile
	local SyncProjectile = RemotesFolder.SyncProjectile]]
	local DropItem = RemotesFolder.DropItem
	local Revive = RemotesFolder.Revive
	local RequestLocalAsset = RemotesFolder.RequestLocalAsset
	local ObtainGiftedRevive = RemotesFolder.ObtainGiftedRevive
	local Footstep = RemotesFolder.FootstepRemoteThatWeNeed
	local DeathHint = RemotesFolder.DeathHint
	local Statistics = RemotesFolder.Statistics
	local MotorReplication = RemotesFolder.MotorReplication
	local ServerTeleported = RemotesFolder.ServerTeleported
	local UpdateMinecartNodes = RemotesFolder.UpdateMinecartNodes
	local MinecartPos = RemotesFolder.MinecartPos
	local MinecartResult = RemotesFolder.MinecartResult
	local ReplicateAnimation = RemotesFolder.ReplicateAnimation

	--[[local oops; oops = hookmetamethod and hookmetamethod(game, "__namecall", function(self, ...)
		local args = {...}
		if self == Character then
			if getnamecallmethod() == "SetAttribute" and args[1] == "Crouching" then
				if not checkcaller() then
					oops(self, unpack(args))
				end
				args[1] = "_MSPAINT_Crouching"
			elseif getnamecallmethod() == "GetAttribute" and args[1] == "Crouching" then
				if not checkcaller() then
					return oops(self, unpack(args))
				end
				args[1] = "_MSPAINT_Crouching"
			end
		end
		return oops(self, unpack(args))
	end)]]

	local LocalPlayer = Players.LocalPlayer
	local PlayerGui = LocalPlayer.PlayerGui
	local CurrentRooms = workspace:WaitForChild('CurrentRooms', 999)
	local Drops = workspace:WaitForChild('Drops', 999)
	local thinkanims = {'18885101321', '18885098453', '18885095182'}
	local teleportdata = Services.TeleportService:GetLocalPlayerTeleportData()
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local main_game = PlayerGui:WaitForChild("MainUI", 999):WaitForChild("Initiator", 999):WaitForChild("Main_Game", 999)
	local required_main_game = require(main_game)

	type Weld = {
		Destroy: (self: Weld) -> ()
	}

	local function WeldTo(TargetPart: BasePart, Offset: CFrame): Weld
		local Root = Character and Character:WaitForChild("HumanoidRootPart", 10)
		if not Root then return end
		if not TargetPart then return end

		local Weld = {}
		local Connection = nil
		local OldAllowSleep = settings().Physics.AllowSleep

		settings().Physics.AllowSleep = false
		Connection = RunService.Heartbeat:Connect(function()
			if not Character.Parent or not TargetPart.Parent then
				if Weld and Weld.Destroy then Weld:Destroy() end
				return
			end
			local clamp = Vector3.new(math.clamp(TargetPart.AssemblyLinearVelocity.X,-10,10),0,math.clamp(TargetPart.AssemblyLinearVelocity.Z,-10,10))
			Character:PivotTo(TargetPart.CFrame * Offset + clamp / 10)
			Root.AssemblyLinearVelocity = Vector3.zero
			Root.AssemblyAngularVelocity = Vector3.zero
			if sethiddenproperty then
				pcall(sethiddenproperty, Root, "PhysicsRepRootPart", TargetPart)
			end
		end)

		Weld.OldAllowSleep = OldAllowSleep

		function Weld:Destroy()
			if Connection then Connection:Disconnect() end
			if Root then
				Root.AssemblyLinearVelocity = Vector3.zero
				Root.AssemblyAngularVelocity = Vector3.zero
			end
			if sethiddenproperty then
				pcall(sethiddenproperty, Root, "PhysicsRepRootPart", nil)
			end
			self.Destroy = nil
		end

		return Weld
	end

	local function inWhatRoom(object: Object): number?
		local parent = object.Parent
		while not parent or parent.Name:match("%d+") ~= parent.Name do
			parent = parent.Parent
		end
		return parent and parent.Parent == CurrentRooms and tonumber(parent.Name)
	end

	local function decodeBase64(str: string)
		return buffer.tostring(EncodingService:Base64Decode(buffer.fromstring(str)))
	end

	local ObtainedRevive = PlayerGui:WaitForChild("MainUI", 99):WaitForChild("ObtainedRevive", 99):Clone()
	ObtainedRevive.Confirm.Size = UDim2.fromScale(.3,.2)
	ObtainedRevive.Close.Size = UDim2.fromScale(.3,.2)
	ObtainedRevive.Confirm.Position = UDim2.fromScale(.3,1)
	ObtainedRevive.Close.Position = UDim2.fromScale(.7,1)

	ObtainedRevive.Confirm.Text = "KEEP"

	local Keep = ObtainedRevive.Confirm:Clone()
	Keep.Parent = ObtainedRevive
	Keep.AnchorPoint = Vector2.new(.5,1)
	Keep.Position = UDim2.fromScale(.5,1)
	Keep.Size = UDim2.fromScale(1/3,.2)
	Keep.BackgroundColor3 = Color3.fromRGB(165, 168, 207)
	Keep.Name = "Keep"
	Keep.Text = "KEEP 1X"

	local pendingGiftedRevives = {}
	local pendingGiftedRevivesALL = {}
	local blacklisted = {}
	local infYield = Instance.new("BindableFunction")

	local disableGifting = false
	local function OnReviveObtain(name)
		if disableGifting or blacklisted[name] then
			infYield:Invoke()
			return false
		elseif not (main_game and require(main_game).dead) then
			return false
		end

		local guid = HttpService:GenerateGUID(false)
		local player = game.Players:FindFirstChild(name)
		pendingGiftedRevives[name] = pendingGiftedRevives[name] or {}
		table.insert(pendingGiftedRevives[name], guid)

		local LiveRevive = PlayerGui.MainUI:FindFirstChild("FriendReviveLive")
		if LiveRevive and LiveRevive:GetAttribute("name") == name then
			LiveRevive.Keep.Text = `KEEP {#pendingGiftedRevives[name]}X`
		end

		table.insert(pendingGiftedRevivesALL, `{name}-[{guid}]`)
		local index = table.find(pendingGiftedRevivesALL, `{name}-[{guid}]`)
		while index and index > 1 do
			index = table.find(pendingGiftedRevivesALL, `{name}-[{guid}]`)
			task.wait()
		end

		local FriendRevive = ObtainedRevive:Clone()
		FriendRevive:SetAttribute("name", name)
		FriendRevive.Name = "FriendReviveLive"
		FriendRevive.Parent = PlayerGui.MainUI
		FriendRevive.Player.Username.Text = name
		FriendRevive.Keep.Text = `KEEP {#pendingGiftedRevives[name]}X`

		task.spawn(function()
			local success, userId = pcall(function()
				return player and player.UserId or Players:GetUserIdFromNameAsync(name)
			end)
			userId = success and userId
			FriendRevive.Player.PlayerIcon.Image = `rbxthumb://type=AvatarHeadShot&id={userId or 1}&w=150&h=150`
		end)

		FriendRevive.Timer.Text = "inf"
		FriendRevive.Visible = true

		local accepted = nil
		FriendRevive.Confirm.MouseButton1Down:Once(function()
			accepted = 1
			FriendRevive.Visible = false
		end)
		FriendRevive.Keep.MouseButton1Down:Once(function()
			accepted = 2
			FriendRevive.Visible = false
		end)
		FriendRevive.Close.MouseButton1Down:Once(function()
			accepted = false
			FriendRevive.Visible = false
		end)
		index = table.find(pendingGiftedRevives[name], guid)
		while pendingGiftedRevives[name] and pendingGiftedRevives[name][index] == guid and accepted == nil do
			task.wait()
		end
		if not (pendingGiftedRevives[name] and pendingGiftedRevives[name][index]) then
			return not (blacklisted[name] or LocalPlayer:GetAttribute("Alive"))
		end
		if accepted ~= 2 then
			pcall(table.remove, pendingGiftedRevives[name], index)
			index = table.find(pendingGiftedRevivesALL, `{name}-[{guid}]`)
			pcall(table.remove, pendingGiftedRevivesALL, index)
		elseif accepted == false then
			blacklisted[name] = true
			for _, guid in pendingGiftedRevives[name] do
				local oIndex = table.find(pendingGiftedRevivesALL, `{name}-[{guid}]`)
				pcall(table.remove, pendingGiftedRevives[name], index)
				pcall(table.remove, pendingGiftedRevivesALL, oIndex)
			end
			pendingGiftedRevives[name] = {}
		else
			for _, guid in pendingGiftedRevives[name] do
				local oIndex = table.find(pendingGiftedRevivesALL, `{name}-[{guid}]`)
				pcall(table.remove, pendingGiftedRevives[name], index)
				pcall(table.remove, pendingGiftedRevivesALL, oIndex)
			end
			pendingGiftedRevives[name] = {}
		end
		return not not accepted
	end

	local animtrack, Parts, UnanchoredParts, admin, gameid, fakegameid, raknet_hook -- stuff
	local Connections = {}
	local ItemsFromAddon = {}
	local StuffToRemoveLater = {}

	Connections.CameraChanged = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		Camera = workspace.CurrentCamera
	end)

	function isModifierEnabled(modifier)
		return not not(teleportdata and teleportdata.Modifiers and table.find(teleportdata.Modifiers, modifier))
	end

	local ScreenGui, delulucaption, spawncaption, script1
	task.spawn(function()
		ScreenGui = Instance.new('ScreenGui', PlayerGui)
		ScreenGui.Name = 'DeluluCaption'
		ScreenGui.DisplayOrder = PlayerGui.MainUI.DisplayOrder
		ScreenGui.ResetOnSpawn = false
		ScreenGui.IgnoreGuiInset = true
		delulucaption = Module.LoadCustomInstance('https://github.com/tplaygd/Tplays-Addon-Stuff/raw/main/caption.rbxm', "caption.rbxm")

		if delulucaption then
			delulucaption.Parent = ScreenGui
			script1 = Instance.new('LocalScript', delulucaption)
			local v_u_1 = Services.TweenService
			local v_u_2 = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			local tbas = Instance.new('Sound')
			tbas.SoundId = 'rbxassetid://6895079853'

			spawncaption = function(p3, p4, p5, p6, p7)
				local v8 = p3:Clone()
				v8.Parent = p4
				v8:WaitForChild('MainText').Text = ''
				local v9 = v8.Size
				v8.Size = UDim2.new(0, 0, 1, 0)
				v8.Visible = true
				Services.SoundService:PlayLocalSound(tbas)
				v_u_1:Create(v8, v_u_2, {
					['Size'] = v9
				}):Play()
				local v10 = Instance.new('Sound')
				v10.Parent = script1
				if p6 ~= nil and p6 ~= 'none' then
					v10.SoundId = p6
				else
					v10.SoundId = 'rbxassetid://7107161936'
				end
				if p7 ~= nil and p7 ~= 'none' then
					v8:WaitForChild('MainText').TextColor3 = p7
				end
				Debris:AddItem(v8, 3.1+1+(0.0175*#p5))
				task.wait(0.4)
				v8:WaitForChild('MainText').Visible = true
				for v11 = 1, #p5 do
					v8:WaitForChild('MainText').Text = p5:sub(1, v11)
					Services.SoundService:PlayLocalSound(v10)
					task.wait(0.0175)
				end
				task.wait(2.5)
				Services.TweenService:Create(v8:WaitForChild('MainText'), TweenInfo.new(0.2), {
					['TextTransparency'] = 1
				}):Play()
				Services.TweenService:Create(v8:WaitForChild('MainText'):WaitForChild('UIStroke'), TweenInfo.new(0.2), {
					['Transparency'] = 1
				}):Play()
				task.wait(0.2)
				v_u_1:Create(v8, v_u_2, {
					['Size'] = UDim2.new(0, 0, 1, 0)
				}):Play()
			end
		end
	end)

	local doorReach = false
	local oldUpValues = {}
	Connections.coolconn = LocalPlayer.CharacterAdded:Connect(function(character)
		main_game = PlayerGui:WaitForChild("MainUI", 999):WaitForChild("Initiator", 999):WaitForChild("Main_Game", 999)
		if Toggles.Freecam.Value then
			Toggles.Freecam:SetValue(false)
		end
		required_main_game = require(main_game)
		if Toggles.Stun.Value then
			Toggles.Stun.Callback(false, true)
		end
		if Toggles.SlideSpeedHack.Value then
			Crouch:FireServer(Character:GetAttribute("Crouching"), true)
		end
		if Toggles.CollisionOffsetGodmodeAlt.Value then
			Toggles.CollisionOffsetGodmodeAlt:SetValue(false)
			task.delay(.0001, function()
				Toggles.CollisionOffsetGodmodeAlt:SetValue(true)
			end)
		end
		Character = character
		if Connections.OnCharacterStun then
			Connections.OnCharacterStun:Disconnect()
		end
		Connections.OnCharacterStun = Character:GetAttributeChangedSignal('Stunned'):Connect(function()
			Toggles.Stun.Callback(Character:GetAttribute('Stunned'), true)
		end)
		blacklisted = {}
		pendingGiftedRevives = {}
		pendingGiftedRevivesALL = {}
	end)

	Connections.OnCharacterStun = Character:GetAttributeChangedSignal('Stunned'):Connect(function()
		Toggles.Stun.Callback(Character:GetAttribute('Stunned'), true)
	end)

	local success, username = pcall(function()
		return Players:GetNameFromUserIdAsync(teleportdata.Host)
	end)

	Groupbox:AddDivider({
		Text = "GAME INFO",
		MarginTop = 2,
		MarginBottom = -2
	})
	if teleportdata.Host and success and username then
		local player = Players:GetPlayerByUserId(teleportdata.Host)
		Groupbox:AddLabel('Host UserId: '..teleportdata.Host or "???")
		Groupbox:AddLabel('Host Username: '..Players:GetNameFromUserIdAsync(teleportdata.Host) or "???")
		local status = Groupbox:AddLabel('Status: '..(player and 'In-game' or 'Left'))
		if player then
			Connections.OnHostLeft = Players.ChildRemoved:Connect(function(leftPlayer)
				if leftPlayer == player then
					Connections.OnHostLeft:Disconnect()
					Connections.OnHostLeft = nil
					status:SetText('Status: Left')
				end
			end)
		end
	else
		Groupbox:AddLabel('HOST NOT FOUND')
	end

	Groupbox:AddDivider({
		Margin = -6
	})

	local playersInGame = Groupbox:AddLabel(`Players: {#Players:GetPlayers()}/{#PlayerRigs:GetChildren()}`)
	Connections.OnPlayerLeft = Players.ChildRemoved:Connect(function()
		playersInGame:SetText(`Players: {#Players:GetPlayers()}/{#PlayerRigs:GetChildren()}`)
	end)

	Groupbox:AddDivider({
		Text = "MAIN",
		MarginTop = 2,
		MarginBottom = -2
	})

	local motorReplicaAbuse = {
		methods = {
			BodyInLegs = {
				number = 3600,
				static = false,
				methodType = "Number"
			},
			BrokenSpine = {
				number = 1800,
				static = true,
				methodType = "Number"
			},
			Spin = function()
				local currentLVY = 0
				local v1 = os.clock()+1/30
				local v2 = 0
				return RunService.RenderStepped:Connect(function(dt)
					if os.clock() < v1 then v2 += dt return end
					currentLVY = (currentLVY+v2*7200)
					MotorReplication:FireServer(-currentLVY)
					v1 = os.clock()+1/30
					v2 = 0
				end)
			end
		},
		method = "BrokenSpine",
		enabled = false
	}
	--local antiFigure = false
	local showPathfind = false
	local cogAlt = false
	local slideSH = false
	local noReviveCutscene = false
	local noSpread = false
	local fastThrow = false
	local propsFastSpeed = {
		Bomb = 300,
		BigBomb = 300,
		Knockbomb = 250,
		GoldBullet = 10000,
		Bullet = 10000
	}
	local hook; hook = hookmetamethod and hookmetamethod(game, "__namecall", function(self, ...)
		local args, method = {...}, getnamecallmethod()
		if self == Crouch and method == "FireServer" then
			if cogAlt then
				args[1] = true
			end
			if slideSH then
				args[2] = true
			end
		end
		if self == MotorReplication and method == "FireServer" and cogAlt then
			if Floor == "Fools" or Floor == "OldHotel" then
				args[1] = 0
				args[2] = 65
				args[3] = 0
				args[4] = false
			else
				args[1] = -650
			end
		end
		--[[if not checkcaller() and self == Footstep and method == "FireServer" and antiFigure then
			return
		end]]
		local name = ...
		if not checkcaller() and method == "WaitForChild" then
			if (name == "PathfindNodes" and showPathfind) or (name == "ReviveCutscene" and noReviveCutscene) then
				return
			end
		end
		if motorReplicaAbuse.enabled and self == MotorReplication and method == "FireServer" then
			local value = motorReplicaAbuse.methods[motorReplicaAbuse.method]
			if typeof(value) == "table" and value.methodType == "Number" then
				args[1] = value.number+(not value.static and args[1] or 0)
			elseif not checkcaller() then
				return
			end
		end
		if self == FireToolProjectile and method == "Fire" then
			--args[1] = args[1] == "GoldBullet" and "Bullet" or args[1]
			args[3] = noSpread and Camera.CFrame.Position or args[3]
			args[4] = noSpread and Camera.CFrame.LookVector or args[4]
			args[5] = fastThrow and (propsFastSpeed[args[1]] or 500) or args[5]
		end
		return hook(self, unpack(args))
	end)

	local AllPathfindNodes = {}
	CurrentRooms.ChildAdded:Connect(function(room)
		local PathfindNodes = showPathfind and room:WaitForChild("PathfindNodes", 1)
		if PathfindNodes then
			table.insert(AllPathfindNodes, PathfindNodes)
			for _, node in PathfindNodes:GetChildren() do
				node.Transparency = .5
			end
		end
	end)

	StuffToRemoveLater.body = Instance.new("BodyVelocity")
	StuffToRemoveLater.body.MaxForce = Vector3.new(1/0, 1/0, 1/0)

	local function NoAltFeatures()
		if ADDON_CONFIG.AltFeatures then
			return nil
		else
			return {
				Value = false
			}
		end
	end

	wasAnchored = false
	Toggles.AnticheatManipulationAlt = NoAltFeatures() or Groupbox:AddToggle(prefix..'AnticheatManipulationAlt', {
		Text = 'Anticheat Manipulation Alt',
		Tooltip = "Alternative method of AC manipulation (from Abysall)",
		Default = false,

		Callback = function(value)
			if value then
				StuffToRemoveLater.body.Parent = Character.HumanoidRootPart
				Connections.ACMA = RunService.RenderStepped:Connect(function()
					StuffToRemoveLater.body.Velocity = Camera.CFrame.LookVector * 2.25
					Character.CollisionPart.CanCollide = false
					Character.HumanoidRootPart.CanCollide = false
					Character.Collision.CanCollide = false
					Character.Collision.CollisionCrouch.CanCollide = false
				end)
			else
				StuffToRemoveLater.body.Parent = nil
				if Connections.ACMA then
					Connections.ACMA:Disconnect()
					Connections.ACMA = nil
				end
				Character.CollisionPart.CanCollide = not Library.Toggles.Noclip.Value
				Character.HumanoidRootPart.CanCollide = not Library.Toggles.Noclip.Value
				Character.Collision.CanCollide = not Library.Toggles.Noclip.Value
				Character.Collision.CollisionCrouch.CanCollide = not Library.Toggles.Noclip.Value
			end
		end
	})
	
	KeyPickers.AnticheatManipulationAltKey = Toggles.AnticheatManipulationAlt.Callback and Toggles.AnticheatManipulationAlt:AddKeyPicker(prefix.."AnticheatManipulationAltKey", {
		Text = "Anticheat Manipulation Alt",
		Default = "Y",
		Mode = Library.IsMobile and "Toggle" or "Hold",
		SyncToggleState = true
	})

	local Groundskeepers = {}
	local FigureRigs = {}

	local stopTauntTimes = 0
	local lastTaunt = -1/0

	local function addGS(gs)
		if gs.Name == "Groundskeeper" and gs:WaitForChild("HumanoidRootPart", 1) then
			table.insert(Groundskeepers, gs)
			gs:WaitForChild("Head", 1/0).ChildAdded:Connect(function(child)
				if Toggles.GSNotifier.Value and child.Name:sub(1,7) == "gkgrunt" then
					lastTaunt = os.clock()
					stopTauntTimes += 1
					task.spawn(function()
						local staticTauntTimes = stopTauntTimes
						while staticTauntTimes == stopTauntTimes and lastTaunt < os.clock()-3 do
							task.wait()
						end
						if staticTauntTimes == stopTauntTimes then
							stopTauntTimes = 0
							if stopTauntTimes >= 3 then
								Library:Notify({
									Title = AddonTitle.." [Groundskeeper]",
									Description = "Groundskeeper is not stuck anymore!",
									Time = 3
								})
							end
						end
					end)
					if stopTauntTimes == 3 then
						Library:Notify({
							Title = AddonTitle.." [Groundskeeper]",
							Description = "Groundskeeper is stuck lol",
							Time = 3
						})
					end
				end
			end)
		end
	end

	local function addFR(fr)
		if fr.Name == "FigureRig" and fr:WaitForChild("Root", 1) then
			table.insert(FigureRigs, fr)
		end
	end

	for _, c in CurrentRooms:QueryDescendants("#Groundskeeper") do
		task.spawn(addGS, c)
	end
	for _, c in CurrentRooms:QueryDescendants("#FigureRig") do
		task.spawn(addFR, c)
	end
	CurrentRooms.DescendantAdded:Connect(addGS)
	CurrentRooms.DescendantAdded:Connect(addFR)
	CurrentRooms.DescendantRemoving:Connect(function(c)
		local foundGS = table.find(Groundskeepers, c)
		local foundFR = table.find(FigureRigs, c)
		if foundGS then
			table.remove(Groundskeepers, foundGS)
		end
		if foundFR then
			table.remove(FigureRigs, foundFR)
		end
	end)

	local function ShouldSpoofGS(human, hrp)
		if human.FloorMaterial == "Grass" then
			for _, gs in Groundskeepers do
				gs = gs:FindFirstChild("HumanoidRootPart")
				if gs and (gs.Position*Vector3.new(1,5,1)-hrp.Position*Vector3.new(1,5,1)).Magnitude < 90 then
					return true
				end
			end
		end
		return false
	end

	local function ShouldSpoofFR(hrp)
		for _, fr in FigureRigs do
			fr = fr:FindFirstChild("Root")
			if fr and (fr.Position*Vector3.new(1,0,1)-hrp.Position*Vector3.new(1,0,1)).Magnitude < 20 then
				return true
			end
		end
		return false
	end

	local function log(...)
		local text = table.concat({...}, " ")
		if ADDON_CONFIG.Debug then
			Library:Notify({
				Title = "Tplay's Addon [Debug]",
				Description = text,
				Time = math.clamp(#text/10, 2, 10)
			})
		end
	end

	local function logprint(...)
		if ADDON_CONFIG.Debug then
			print(...)
		end
	end

	Groupbox:AddDivider({
		Margin = -6
	})

	if ADDON_CONFIG.IncludeAddedFeatures then
		Toggles.NoSpread = Groupbox:AddToggle(prefix..'NoSpread', {
			Text = 'No Spread',
			Tooltip = 'Accurate prop throw',
			DisabledTooltip = "Executor is not supported",
			Disabled = not hook,
			Default = false,

			Callback = function(value)
				accurateAim = value
			end
		})

		Toggles.FastThrow = Groupbox:AddToggle(prefix..'FastThrow', {
			Text = 'Fast Throw',
			Tooltip = 'Throws prop as fast as Gold Bullet',
			DisabledTooltip = "Executor is not supported",
			Disabled = not hook,
			Default = false,

			Callback = function(value)
				fastThrow = value
			end
		})
	end

	Toggles.DeleteProps = Groupbox:AddToggle(prefix..'DeleteProps', {
		Text = 'Delete Props',
		Tooltip = 'Delete every prop you pickup (works only in Battle Mode)',

		Callback = function(value)
			if value then
				Connections.DeletePropsConnection = Character.ChildAdded:Connect(function(child)
					if child.Name == "BigPropTool" then
						child.Parent = LocalPlayer.Backpack
					end
				end)
			else
				if Connections.DeletePropsConnection then
					Connections.DeletePropsConnection:Disconnect()
					Connections.DeletePropsConnection = nil
				end
			end
		end
	})

	local function GetEquippedTool(player: Player)
		return player and player.Character and player.Character:FindFirstChildOfClass("Tool")
	end

	local reason = {
		Durability = "Gold Blaster should have Durability '1'",
		AlreadyBroken = "Gold Blaster is already broken"
	}

	KeyPickers.BreakToolKey = Groupbox:AddLabel('Use & Break Gold Blaster'):AddKeyPicker(prefix.."BreakToolKey", {
		Text = "Use & Break Gold Blaster",
		Default = "MB3",
		Mode = "Press",

		Callback = function()
			local tool = GetEquippedTool(LocalPlayer)
			if tool and tool.Name == "GoldGun" and not tool:GetAttribute("OnCooldown") and (tool:GetAttribute("Durability") and tool:GetAttribute("Durability") == 1) then
				GetFunction("FireTool", false, "Inventory")()
				task.wait(.2)
				DropItem:FireServer(tool)
			elseif tool and tool.Name == "GoldGun" then
				Library:Notify({
					Title = AddonTitle.." [Error]",
					Description = reason[tool:GetAttribute("OnCooldown") and "AlreadyBroken" or "Durability"],
					Time = 3
				})
			else
				Library:Notify({
					Title = AddonTitle.." [Error]",
					Description = "Wrong item",
					Time = 2
				})
			end
		end
	})

	Groupbox:AddDivider({
		Margin = -6
	})

	Toggles.ShowPathfind = Groupbox:AddToggle(prefix..'ShowPathfind', {
		Text = 'Show Pathfind Nodes',
		Tooltip = 'Show pathfind nodes that rush, ambush and etc. use to move',
		DisabledTooltip = 'Executor is not supported',
		Default = false,
		Disabled = not hook,

		Callback = function(value)
			showPathfind = value
			if not value then
				for _, PathfindNodes in AllPathfindNodes do
					PathfindNodes:Destroy()
				end
				AllPathfindNodes = {}
			end
		end
	})

	local DoorReach = Library.Toggles.DoorReach
	Toggles.DoorReachAlt = NoAltFeatures() or Groupbox:AddToggle(prefix..'DoorReachAlt', {
		Text = 'Door Reach Alt',
		DisabledTooltip = 'Executor is not supported',
		Default = false,
		Disabled = not filtergc,

		Callback = function(value)
			doorReach = value
			main_game:WaitForChild("Updated", 9e9)
			if value then
				if DoorReach.Value then
					DoorReach:SetValue(false)
				end
				DoorReach:SetDisabled(true)
				local lastOpened = {Time = -1/0}
				while doorReach do
					local Root = Character and Character.PrimaryPart or Character:FindFirstChild("HumanoidRootPart")
					local Room = CurrentRooms:FindFirstChild(LatestRoom.Value)
					local Door = Room and Room:FindFirstChild("Door")
					local DoorPart = Door and Door.PrimaryPart
					if Root and DoorPart and not Door:FindFirstChild("Lock") then
						if (Root.Position-DoorPart.Position).Magnitude < 30 and (not lastOpened.Door == Door or lastOpened.Time < os.clock()-1/3) then
							lastOpened.Door = Door
							lastOpened.Time = os.clock()
							Door.ClientOpen:FireServer()
						end
					end
					RunService.RenderStepped:Wait()
				end
			else
				DoorReach:SetDisabled(false)
			end
		end
	})

	Groupbox:AddDivider({
		Margin = -6
	})

	StuffToRemoveLater.NilConstraint = Instance.new("PrismaticConstraint")
	function disconnectDrawer(drawer)
		(drawer:WaitForChild("Constraint", 1) or StuffToRemoveLater.NilConstraint).Enabled = true
		local drawer = Connections.DrawersConnections[drawer]
		for index, connection in drawer or {} do
			connection:Disconnect()
		end
		drawer = nil
	end

	function handleDrawer(drawer)
		local constraint, main
		if drawer:IsA("Model") and drawer.Name == "DrawerContainer" then
			main = drawer:WaitForChild("Main", 1)
			if not main then
				return
			end
			constraint = drawer:WaitForChild("Constraint", 1)
			if not constraint then
				return
			end
		else
			return
		end
		Connections.DrawersConnections = Connections.DrawersConnections or {}
		if Connections.DrawersConnections[drawer] then
			return
		end
		Connections.DrawersConnections[drawer] = {
			AncestryChanged1 = drawer.AncestryChanged:Connect(function()
				if not drawer.Parent then
					disconnectDrawer(drawer)
				end
			end),
			AncestryChanged2 = main.AncestryChanged:Connect(function()
				if not main.Parent then
					disconnectDrawer(drawer)
				end
			end),
			BringLoop = RunService.RenderStepped:Connect(function()
				if isnetworkowner(main) and not main.Anchored then
					constraint.Enabled = false
					main.CFrame = Character:GetPivot()*CFrame.Angles(0,math.rad(180),0)+Character:GetPivot().LookVector*3
					main.AssemblyLinearVelocity = Vector3.zero
					main.AssemblyAngularVelocity = Vector3.zero
				else
					constraint.Enabled = true
				end
			end)
		}
	end

	Toggles.BringDrawerWithKey = Groupbox:AddToggle(prefix..'BringDrawerWithKey', {
		Text = 'Bring Drawer With Key',
		DisabledTooltip = 'Executor is not supported',
		Default = false,
		Disabled = not isnetworkowner,

		Callback = function(value)
			if value then
				toggleNetworkOwner(true)
				for _, drawer in CurrentRooms:QueryDescendants("#DrawerContainer") do
					task.spawn(function()
						local key = drawer:WaitForChild("KeyObtain", 1)
						if key then
							log("FOUND KEY IN DRAWER")
							handleDrawer(drawer)
						end
					end)
				end
				Connections.DrawerAdded = CurrentRooms.DescendantAdded:Connect(function(drawer)
					if drawer.Name == "DrawerContainer" then
						task.wait(.5)
						local key = drawer:WaitForChild("KeyObtain", 1)
						if key then
							log("FOUND KEY IN DRAWER")
							handleDrawer(drawer)
						end
					end
				end)
			else
				toggleNetworkOwner(false)
				if Connections.DrawerAdded then
					Connections.DrawerAdded:Disconnect()
					Connections.DrawerAdded = nil
				end
				for drawer, _ in Connections.DrawersConnections do
					task.spawn(disconnectDrawer, drawer)
				end
				Connections.DrawersConnections = nil
			end
		end
	})

	local Decode = require(ReplicatedStorage.NodeObject.MinecartNodes).Decode
	local oldnamecall
	local MinecartTeleport = Library.Toggles.MinecartTeleport
	Toggles.MinecartTeleportAlt = MinecartTeleport and Groupbox:AddToggle(prefix..'MinecartTeleportAlt', {
		Text = 'Minecart Teleport Alt',
		Default = false,

		Callback = function(value, yea)
			if value then
				if MinecartTeleport.Value then
					MinecartTeleport:SetValue(false)
				end
				MinecartTeleport:SetDisabled(true)
				local hook; hook = hookfunction(Decode, function(nodes, folder, start)
    				assert(folder, "wheres the folder?!?!") -- yea
    				if folder and folder.Parent and (tonumber(folder.Parent.Name) or 0) < 49 then
    				    return nil
    				end
    				return hook(nodes, folder, start)
				end)
				local latestroom = LatestRoom.Value
				Connections.LatestRoomChanged = LatestRoom:GetPropertyChangedSignal("Value"):Connect(function()
				    task.wait()
				    latestroom = LatestRoom.Value
				end)
				local mt = getrawmetatable(game)
				oldnamecall = mt.__namecall
				setreadonly(mt, false)
				mt.__namecall = function(self, cframe, ...)
					if not checkcaller() and self == MinecartPos and getnamecallmethod() == "FireServer" then
						if latestroom < 49 then
							local room = workspace.CurrentRooms:FindFirstChild(latestroom)
							local door = room and room:FindFirstChild("Door")
							if door then
								cframe = door:GetPivot()
								workspace.CurrentCamera.MinecartRig:PivotTo(cframe)
								door.ClientOpen:FireServer()
							end
						else
							setreadonly(mt, false)
							mt.__namecall = oldnamecall
							setreadonly(mt, true)
							restorefunction(Decode)
						end
					end
					return oldnamecall(self, cframe, ...)
				end
				setreadonly(mt, true)
			else
				MinecartTeleport:SetDisabled(false)
				if Connections.LatestRoomChanged then
					Connections.LatestRoomChanged:Disconnect()
				end
				if isfunctionhooked and isfunctionhooked(Decode) then
					restorefunction(Decode)
				end
				local mt = getrawmetatable(game)
				setreadonly(mt, false)
				mt.__namecall = oldnamecall
				setreadonly(mt, true)
			end
		end
	})

	StuffToRemoveLater.partwow = Instance.new("Part")
	StuffToRemoveLater.partwow.Transparency = 1
	StuffToRemoveLater.partwow.Color = Color3.new(1)
	StuffToRemoveLater.partwow.Material = "Glass"
	StuffToRemoveLater.partwow.CanCollide = false
	StuffToRemoveLater.partwow.CanQuery = false
	StuffToRemoveLater.partwow.CanTouch = false
	StuffToRemoveLater.partwow.Anchored = true
	StuffToRemoveLater.partwow.Size = Vector3.new(2,2,1)

	local highlight = Instance.new("Highlight", StuffToRemoveLater.partwow)
	highlight.FillTransparency = .75
	highlight.OutlineTransparency = .75

	local function CreateCoolPart(cframe)
		if not ADDON_CONFIG.Debug then return end
		local supercoolpart = StuffToRemoveLater.partwow:Clone()
		supercoolpart.Parent = workspace
		supercoolpart.CFrame = cframe
		Debris:AddItem(supercoolpart, 3)
	end

	local function getTpFunction()
		local connections = getconnections and getconnections(ServerTeleported.OnClientEvent)
		local connection = connections and connections[1]
		return connection and connection.Function
	end

	local tpFunction
	Toggles.AntiTeleport = Groupbox:AddToggle(prefix..'AntiTeleport', {
		Text = 'Anti Teleport [UNSTABLE]',
		Tooltip = "Tries to prevent any teleport attempt from server",
		Default = false,
		Risky = true,

		Callback = function(value, yea)
			if value then
				tpFunction = getTpFunction()
				if hookfunction then
					if tpFunction then
						local tp; tp = hookfunction(tpFunction, function(...)
							if checkcaller() then
								tp(...)
							end
						end)
					end
					local hook; hook = hookfunction(ServerTeleported.OnClientEvent.Connect, function(self, func)
						if not checkcaller() then
							hookfunction(func, function()end)
							tpFunction = func
						end
						return hook(self, func)
					end)
				end
				Connections.AntiTeleportConnection = RunService.Heartbeat:Connect(function()
					local root = Character and Character:FindFirstChild("HumanoidRootPart")
					local human = Character and Character:FindFirstChild("Humanoid")
					if root and human then
						local oldCFrame = root.CFrame
						local oldVelocity = root.AssemblyLinearVelocity
						RunService.Heartbeat:Wait()
						if (oldCFrame.Position-root.Position).Magnitude > human.WalkSpeed/100*2.5 then
							CreateCoolPart(root.CFrame)
							Character:PivotTo(oldCFrame)
							root.AssemblyLinearVelocity = oldVelocity
						end
					end 
				end)
			else
				if isfunctionhooked and restorefunction then
					if tpFunction and isfunctionhooked(tpFunction) then
						restorefunction(tpFunction)
					end
					if isfunctionhooked(ServerTeleported.OnClientEvent.Connect) then
						restorefunction(ServerTeleported.OnClientEvent.Connect)
					end
				end
				if Connections.AntiTeleportConnection then
					Connections.AntiTeleportConnection:Disconnect()
					Connections.AntiTeleportConnection = nil
				end
				if yea then
					task.spawn(pcall, function()
						RunService.RenderStepped:Wait()
						Toggles.AntiTeleport:SetValue(true)
					end)
				end
			end
		end
	})

	local walkspeed = 15
	local ladderspeed = 15
	local SpeedHack = Library.Toggles.EnableSpeedHack

	function StartWSConnection()
		Connections.WalkSpeed = RunService.RenderStepped:Connect(function()
			if Character and Character:FindFirstChild("Humanoid") and Character.Parent then
				Character:SetAttribute("SpeedBoostBehind", ladderspeed-15)
				Character.Humanoid.WalkSpeed = forceWs or walkspeed
			end
		end)
	end

	local confirmed = false
	Toggles.RakNetSpeedHack = Groupbox:AddToggle(prefix..'RakNetSpeedHack', {
		Text = 'SpeedHack RakNet method',
		Tooltip = "I dont recommend you to use this feature, try speedhack slide method instead",
		DisabledTooltip = raknet and 'Please wait...' or 'Executor is not supported',
		Disabled = not raknet,
		Default = false,
		Risky = true,

		Callback = function(value)
			if value then
				if not confirmed then
					confirmed = nil
					Window:AddDialog("RakNetSpeedHackWarning", {
    					Title = "WARNING!",
    					Description = "This feature can lead to ban or even worse account deletion because of raknet library usage, if you still want to use raknet method press Confirm",
    					AutoDismiss = true,
        				OutsideClickDismiss = true,
        				FooterButtons = {
            				Cancel = {
                				Title = "Cancel",
                				Variant = "Primary",
                				Order = 1,
               				 	Callback = function()
                				    confirmed = false
                				end
            				},
            				Confirm = {
            					Title = "Confirm",
            					Variant = "Destructive",
            					WaitTime = 2,
            					Order = 2,
           						Callback = function(self)
                					confirmed = true
            					end
        					}
						}
    				})
					while confirmed == nil do task.wait() end
					if not confirmed then
						Toggles.RakNetSpeedHack:SetValue(false)
						Toggles.RakNetSpeedHack:SetDisabled(true)
						task.wait(1)
						Toggles.RakNetSpeedHack:SetDisabled(false)
						return
					end
				end
				SpeedHack:SetValue(false)
				SpeedHack:SetDisabled(true)
				Toggles.SlideSpeedHack:SetDisabled(true)
				Toggles.RakNetSpeedHack:SetDisabled(true)

				local success, response = pcall(function()
					raknet_hook = raknet.add_send_hook(function(packet)
						if packet.PacketId == 0x1B then
							local data = packet.AsBuffer
							buffer.writeu32(data, 1, 0xFFFFFFFF)
							buffer.writeu32(data, 2, 0xFFFFFFFF)
							packet:SetData(data)
						end
					end)
				end)

				if not success then
					if response:find("raknet not allowed") then
						Library:Notify({
							Title = AddonTitle.." [Error]",
							Description = 'Raknet is not enabled (you can try to enable it in executor settings)',
							Time = 4
						})
					else
						Library:Notify({
							Title = AddonTitle.." [Error]",
							Description = 'Something went wrong while trying to load Speed Bypass',
							Time = 3
						})
					end
					Toggles.RakNetSpeedHack:SetDisabled(false)
					Toggles.RakNetSpeedHack:SetValue(false)
					return
				end

				StartWSConnection()

				Character:PivotTo(CFrame.new(0,1500000,0))
				Library:Notify({
					Title = AddonTitle,
					Description = 'Speed bypass is loading, please wait...',
					Time = 3
				})
				while Character.Collision.Position.Y > 1000000 do
					Character.Collision.AssemblyLinearVelocity = Vector3.new(0,0,0)
					RunService.RenderStepped:Wait()
				end
				Toggles.RakNetSpeedHack:SetDisabled(false)
				Library:Notify({
					Title = AddonTitle,
					Description = 'Speed bypass loaded',
					Time = 2
				})
			else
				if raknet_hook then
					raknet.remove_send_hook(raknet_hook)
				end
				if Connections.WalkSpeed then
					Connections.WalkSpeed:Disconnect()
				end
				Character:SetAttribute("SpeedBoostBehind", 0)
				Character.Humanoid.WalkSpeed = 15
				SpeedHack:SetDisabled(false)
				Toggles.SlideSpeedHack:SetDisabled(false)
			end
		end
	})

	if ADDON_CONFIG.IncludeAddedFeatures then
		Toggles.SlideSpeedHack = Groupbox:AddToggle(prefix..'SlideSpeedHack', {
			Text = 'SpeedHack Slide method',
			Tooltip = "Already in mspaint (speed bypass method discovered by @nahhthatscrazy)",
			Default = slideSH,

			Callback = function(value)
				if value then
					slideSH = true
					SpeedHack:SetValue(false)
					SpeedHack:SetDisabled(true)
					Toggles.RakNetSpeedHack:SetDisabled(true)

					StartWSConnection()

					if hook then
						Crouch:FireServer(Character:GetAttribute("Crouching"), true)
					else
						while slideSH do
							Crouch:FireServer(Character:GetAttribute("Crouching"), true)
							task.wait()
						end
					end
				else
					slideSH = false
					if Connections.WalkSpeed then
						Connections.WalkSpeed:Disconnect()
					end
					Character:SetAttribute("SpeedBoostBehind", 0)
					Character.Humanoid.WalkSpeed = 15
					SpeedHack:SetDisabled(false)
					Toggles.RakNetSpeedHack:SetDisabled(not raknet)
				end
			end
		})
	end

	Groupbox:AddSlider("WalkSpeed", {
		Text = "Walk Speed",
		Default = walkspeed,
		Min = 0,
		Max = 75,
		Rounding = 0,
		Compact = true,
		Callback = function(ws)
			walkspeed = ws
		end
	})

	Groupbox:AddSlider("LadderSpeed", {
		Text = "Ladder Speed",
		Default = ladderspeed,
		Min = 0,
		Max = 75,
		Rounding = 0,
		Compact = true,
		Callback = function(ls)
			ladderspeed = ls
		end
	})

	Groupbox:AddDivider({
		Margin = -3
	})

	local reviveGhost1, reviveGhost2
	reviveGhost1 = Groupbox:AddButton(prefix..'ReviveAsGhost1', {
		Text = 'Revive As Ghost',
		Tooltip = "Need to be executed at door 0, works like fake revive but its way more stable and doesn't break after any cutscene\nAfter any cutscene anticheat bypass stops working (but you'll be still invincible)\nTo interact with coins, stardust, closets, drawers and etc. you need to get heal from something",
		DisabledTooltip = not (require and replicatesignal and fireproximityprompt and firetouchinterest) and 'Executor is not supported' or 'Better Fake Death is already executed',
		DoubleClick = true,
		Disabled = not (require and replicatesignal and fireproximityprompt and firetouchinterest) or LocalPlayer:GetAttribute("_GhostRevived"),

		Func = function()
			if OpenedFirstDoor.Value then
				Library:Notify({
					Title = AddonTitle.." [Error]",
					Description = "The first door was opened, this method won't work anymore",
					Time = 3
				})
				return
			elseif Floor == "Mines" then
				Library:Notify({
					Title = AddonTitle.." [Error]",
					Description = "This method doesn't work in mines",
					Time = 2
				})
				return
			end
			reviveGhost1:SetDisabled(true)
			reviveGhost2:SetDisabled(true)
			Library:Notify({
				Title = AddonTitle,
				Description = 'Please wait...',
				Time = 2
			})
			local deadCharacter
			local lock = false
			local room = CurrentRooms:GetChildren()[1]
			local door = room and room.Door
			if door:FindFirstChild("Lock") then
				lock = true
			elseif not door then
				Library:Notify({
					Title = AddonTitle.." [Error]",
					Description = "Failed to find the door",
					Time = 2
				})
				return
			end
			task.spawn(function()
				while not deadCharacter do
					Crouch:FireServer(nil,true)
					task.wait()
				end
			end)
			local key = lock and (Character:FindFirstChild("Key") or LocalPlayer.Backpack:FindFirstChild("Key"))
			if lock and not key then
				local keyObtain = room.Assets.KeyObtain
				Character:PivotTo(keyObtain.Hitbox.CFrame)
				fireproximityprompt(keyObtain.ModulePrompt)
				key = Character:FindFirstChild("Key") or LocalPlayer.Backpack:FindFirstChild("Key")
				while not key do
					task.wait()
					Character:PivotTo(keyObtain.Hitbox.CFrame)
					fireproximityprompt(keyObtain.ModulePrompt)
					key = Character:FindFirstChild("Key") or LocalPlayer.Backpack:FindFirstChild("Key")
				end
				key.Parent = Character
			elseif key then
				key.Parent = Character
			end
			local Delay = os.clock()
			RequestLocalAsset:InvokeServer({{}})
			Delay = os.clock()-Delay
			deadCharacter = Character
			replicatesignal(LocalPlayer.Kill)
			task.wait(math.clamp(Delay-.01, 0, 1/0))
			if lock then
				task.spawn(function()
					deadCharacter:PivotTo(door.Door.CFrame)
					if door.Lock:FindFirstChild("UnlockPrompt") then
						fireproximityprompt(door.Lock.UnlockPrompt)
					else
						for _, prompt in workspace:FindFirstChild("Folder") and workspace.Folder:GetChildren() or {} do
							if prompt:IsA("ProximityPrompt") and prompt.Name == "UnlockPrompt" then
								fireproximityprompt(prompt) -- thanks mspaint devs for making my life harder and placing unlockprompt into folder that was created my mspaint
							end
						end
					end
					while deadCharacter.Parent do
						task.wait()
						deadCharacter:PivotTo(door.Door.CFrame)
						if door.Lock:FindFirstChild("UnlockPrompt") then
							fireproximityprompt(door.Lock.UnlockPrompt)
						else
							for _, prompt in workspace:FindFirstChild("Folder") and workspace.Folder:GetChildren() or {} do
								if prompt:IsA("ProximityPrompt") and prompt.Name == "UnlockPrompt" then
									fireproximityprompt(prompt)
								end
							end
						end
					end
				end)
			else
				task.spawn(function()
					local emptyPart = Instance.new("Part")
					deadCharacter.HumanoidRootPart.CFrame = (door:FindFirstChild("Collision") or door:FindFirstChild("Hidden") or emptyPart).CFrame
					firetouchinterest(deadCharacter.HumanoidRootPart, door:FindFirstChild("Collision") or door:FindFirstChild("Hidden") or emptyPart, 0)
					firetouchinterest(deadCharacter.HumanoidRootPart, door.Collision, 1)
					door.ClientOpen:FireServer()
					while deadCharacter.Parent do
						task.wait()
						deadCharacter.HumanoidRootPart.CFrame = (door:FindFirstChild("Collision") or door:FindFirstChild("Hidden") or emptyPart).CFrame
						firetouchinterest(deadCharacter.HumanoidRootPart, door:FindFirstChild("Collision") or door:FindFirstChild("Hidden") or emptyPart, 0)
						firetouchinterest(deadCharacter.HumanoidRootPart, door:FindFirstChild("Collision") or door:FindFirstChild("Hidden") or emptyPart, 1)
						door.ClientOpen:FireServer()
					end
					emptyPart:Destroy()
				end)
			end
			local character
			task.spawn(function()
				character = LocalPlayer.CharacterAdded:Wait()
			end)
			replicatesignal(LocalPlayer.Kill)
			while not character and task.wait() do
				replicatesignal(LocalPlayer.Kill)
			end
			if not OpenedFirstDoor.Value then
				reviveGhost1:SetDisabled(false)
				reviveGhost2:SetDisabled(false)
				Library:Notify({
					Title = AddonTitle.." [Error]",
					Description = 'Failed to open the first door, trying again...',
					Time = 3
				})
				task.wait(.1)
				reviveGhost1.Func()
				return
			end
			LocalPlayer:SetAttribute("Alive", true)
			LocalPlayer:GetAttributeChangedSignal("Alive"):Connect(function()
				LocalPlayer:SetAttribute("Alive", true)
			end)
			LocalPlayer:SetAttribute("_GhostRevived", true)
			local humanoid = character:WaitForChild("Humanoid", 9e9)
			local function nodead()
				pcall(humanoid.SetStateEnabled, humanoid, Enum.HumanoidStateType.Dead, false) -- if i do it using humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false) for some reason humanoid will turn into a CoreGui.Obsidian.Frame.Frame
			end
			nodead()
			RunService.RenderStepped:Connect(nodead)
			if _hookmetamethod then
				local oi; oi = _hookmetamethod(humanoid, "__index", function(self, key)
					if not checkcaller() and self == humanoid and key == "Health" then
						local maxhealth = humanoid.MaxHealth
						return maxhealth <= 0 and 1 or maxhealth
					end
					return oi(self, key)
				end)
				local oni; oni = _hookmetamethod(humanoid, "__newindex", function(self, key, new)
					if not checkcaller() and self == humanoid and key == "Health" then
						local maxhealth = humanoid.MaxHealth
						new = maxhealth <= 0 and 1 or maxhealth
					end
					return oni(self, key, new)
				end)
			else
				humanoid.Health = 100
				humanoid:GetPropertyChangedSignal("Health"):Connect(function()
					nodead()
					humanoid.Health = 100
				end)
			end
			if hookfunction and filtergc then
				hookfunction(GetFunction("healthChanged") or function() end, function() end)
			end
			Library:Notify({
				Title = AddonTitle,
				Description = 'Successfully revived as ghost',
				Time = 3
			})
		end
	})

	reviveGhost2 = Groupbox:AddButton(prefix..'ReviveAsGhost2', {
		Text = 'Revive As Ghost',
		Tooltip = "Requires at least 1 revive, works like fake revive but its way more stable and doesn't break after any cutscene\nThis feature can sometimes waste your revive + after any cutscene anticheat bypass stops working (but you'll be still invincible)\nTo interact with coins, stardust, closets, drawers and etc. you need to get heal from something",
		DisabledTooltip = not (require and replicatesignal) and 'Executor is not supported' or 'Better Fake Death is already executed',
		DoubleClick = true,
		Disabled = not (require and replicatesignal) or LocalPlayer:GetAttribute("_GhostRevived"),

		Func = function()
			local data = ReplicatedStorage:FindFirstChild("ReplicaDataModule") and require(ReplicatedStorage.ReplicaDataModule)
			if Floor ~= "Hotel" and Floor ~= "Mines" then
				Library:Notify({
					Title = AddonTitle.." [Error]",
					Description = "This method doesn't work in subfloors",
					Time = 3
				})
				return
			elseif not OpenedFirstDoor.Value then
				Library:Notify({
					Title = AddonTitle.." [Error]",
					Description = 'Please open the first door',
					Time = 2
				})
				return
			elseif not (data and data.data) or (data.data.Revives or 0) <= 0 then
				Library:Notify({
					Title = AddonTitle.." [Error]",
					Description = 'You need at least 1 revive',
					Time = 3
				})
				return
			end
			reviveGhost1:SetDisabled(true)
			reviveGhost2:SetDisabled(true)
			Library:Notify({
				Title = AddonTitle,
				Description = 'Please wait...',
				Time = 2
			})
			replicatesignal(LocalPlayer.Kill)
			task.wait(3)
			local character
			task.spawn(function()
				character = LocalPlayer.CharacterAdded:Wait()
			end)
			Revive:FireServer()
			replicatesignal(LocalPlayer.Kill)
			while not character and task.wait() do
				replicatesignal(LocalPlayer.Kill)
			end
			LocalPlayer:SetAttribute("Alive", true)
			LocalPlayer:GetAttributeChangedSignal("Alive"):Connect(function()
				LocalPlayer:SetAttribute("Alive", true)
			end)
			LocalPlayer:SetAttribute("_GhostRevived", true)
			local humanoid = character:WaitForChild("Humanoid", 9e9)
			local function nodead()
				pcall(humanoid.SetStateEnabled, humanoid, Enum.HumanoidStateType.Dead, false) -- if i do it using humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false) for some reason humanoid will turn into a CoreGui.Obsidian.Frame.Frame
			end
			nodead()
			RunService.RenderStepped:Connect(nodead)
			if _hookmetamethod then
				local oi; oi = _hookmetamethod(humanoid, "__index", function(self, key)
					if not checkcaller() and self == humanoid and key == "Health" then
						return 100
					end
					return oi(self, key)
				end)
				local oni; oni = _hookmetamethod(humanoid, "__newindex", function(self, key, new)
					if not checkcaller() and self == humanoid and key == "Health" then
						new = 100
					end
					return oni(self, key, new)
				end)
			else
				humanoid.Health = 100
				humanoid:GetPropertyChangedSignal("Health"):Connect(function()
					nodead()
					humanoid.Health = 100
				end)
			end
			if hookfunction and filtergc then
				hookfunction(GetFunction("healthChanged") or function() end, function() end)
			end
			Library:Notify({
				Title = AddonTitle,
				Description = 'Successfully revived as ghost',
				Time = 3
			})
		end
	})

	local function SetMethod(value)
		reviveGhost1:SetVisible(value == "Method #1")
		reviveGhost2:SetVisible(value == "Method #2")
	end

	local dropdown = Groupbox:AddDropdown(prefix..'GhostReviveMethod', {
		Text = 'Method',
		Values = {
			"Method #1",
			"Method #2",
		},
		Default = "Method #1",
		Callback = SetMethod
	})

	SetMethod(dropdown.Value)

	Groupbox2:AddDivider({
		Text = "QOL",
		MarginTop = 2,
		MarginBottom = -2
	})

	Toggles.Freecam = Groupbox2:AddToggle(prefix..'Freecam', {
		Text = 'Freecam',
		DisabledTooltip = 'Executor is not supported',
		Default = false,
		Disabled = not (firesignal or require),

		Callback = function(value)
			required_main_game.noclip = value
			required_main_game.freecam = value
			required_main_game.hideplayers = value and -1 or 0
		end
	})

	Groupbox2:AddDivider({
		Margin = -6
	})

	Toggles.NoWardrobeVignette = Groupbox2:AddToggle(prefix..'NoWardrobeVignette', {
		Text = 'No Wardrobe Vignette',
		Default = false,

		Callback = function(value)
			local vignette = PlayerGui.MainUI.MainFrame.HideVignette
			if value then
				vignette.Size = UDim2.new(0,0,0,0)
			else
				vignette.Size = UDim2.new(1,0,1,0)
			end
		end
	})

	Toggles.RemoveAmbience = Groupbox2:AddToggle(prefix..'RemoveAmbience', {
		Text = 'No Random Ambience',
		Default = false,

		Callback = function(value)
			if value then
				Connections.RemoveAmbience = workspace.Terrain.ChildAdded:Connect(function(child)
					if child:IsA('Attachment') then
						child:Destroy()
					end
				end)
			else
				if not Connections.RemoveAmbience then return end
				Connections.RemoveAmbience:Disconnect()
			end
		end
	})

	Toggles.AntiGreenEffect = Groupbox2:AddToggle(prefix..'AntiGreenEffect', {
		Text = 'Anti Gween Soda Effect',
		Default = false,

		Callback = function(value)
			if value then
				if Camera:FindFirstChild("Im green... No... NOOO!!!!") then
					Camera["Im green... No... NOOO!!!!"]:Destroy()
				end
				Connections.OnGreenEffectAdded = Camera.ChildAdded:Connect(function(child)
					if child.Name == "Im green... No... NOOO!!!!" then
						child:Destroy()
					end
				end)
			elseif Connections.OnGreenEffectAdded then
				Connections.OnGreenEffectAdded:Disconnect()
				Connections.OnGreenEffectAdded = nil
			end
		end
	})


	Toggles.NoReviveCutscene = Groupbox2:AddToggle(prefix..'NoReviveCutscene', {
		Text = 'No Revive Cutscene',
		Default = false,

		Callback = function(value)
			noReviveCutscene = value
		end
	})

	Toggles.NoMedalAutoclip = Groupbox2:AddToggle(prefix..'NoMedalAutoclip', {
		Text = 'No Medal Autoclip',
		DisabledTooltip = 'Executor is not supported',
		Tooltip = 'Disables Medal autoclip when you die to someone or complete the game (you can disable autoclip for roblox in medal settings, made this feature just for testing)',
		Default = false,
		Disabled = not hookfunction or not restorefunction,

		Callback = function(value)
			if value then
				local realPrint; realPrint = hookfunction(print, function(...)
					local args = {...}
					if not checkcaller() and args[1] == "[_MAPIEvent][v1/event/invoke]" then
						local success, result = pcall(function()
							return HttpService:JSONDecode(decodeBase64(args[2]))
						end)
						result = success and result
						if result and typeof(result.triggerActions) == "table" and table.find(result.triggerActions, "SaveClip") then
							return
						end
					end
					return realPrint(...)
				end)
			else
				if isfunctionhooked(print) then
					restorefunction(print)
				end
			end
		end
	})

	local successCFR, ClientFuncRemote = pcall(function()
		return ReplicatedStorage.FloorReplicated.ClientRemote.StreamVoteClientFunction.Remote
	end)
	task.spawn(function()
		while not successCFR do
			task.wait(.1)
			successCFR, ClientFuncRemote = pcall(function()
				return ReplicatedStorage.FloorReplicated.ClientRemote.StreamVoteClientFunction.Remote
			end)
		end
	end)

	local currentFuncToHook = successCFR and ClientFuncRemote and getconnections(ClientFuncRemote.OnClientEvent)[1].Function
	Toggles.NoRandomClientEvents = Groupbox2:AddToggle(prefix..'NoRandomClientEvents', {
		Text = 'No Random Client Events',
		DisabledTooltip = hookfunction and restorefunction and "Please wait..." or 'Executor is not supported',
		Tooltip = 'Disables all random client events (Chaos Mode)',
		Default = false,
		Disabled = not (hookfunction and restorefunction and successCFR and ClientFuncRemote),

		Callback = function(value)
			if value then
				local randomConnect; randomConnect = hookfunction(ClientFuncRemote.OnClientEvent.Connect, function(self, func)
					if not checkcaller() then
						hookfunction(func, function()end)
						currentFuncToHook = func
					end
					return randomConnect(self, func)
				end)
			else
				if isfunctionhooked(ClientFuncRemote.OnClientEvent and ClientFuncRemote.OnClientEvent.Connect or function()end) then
					restorefunction(ClientFuncRemote.OnClientEvent.Connect)
				end
				if isfunctionhooked(currentFuncToHook or function()end) then
					restorefunction(currentFuncToHook)
				end
			end
		end
	})

	Groupbox2:AddDivider({
		Margin = -6
	})

	function rn2ht(c)
		return 10+(10/3-10)*c/100
	end

	local annoying_notification

	function update(arg)
		if annoying_notification then
			if Floor == "Hotel" then
				annoying_notification:ChangeDescription(`Current hide time: {arg==50 and 20 or arg==100 and "Infinite" or math.clamp(math.round((rn2ht(arg)+(arg>=90 and 1.2 or 0))*1000)/1000, -1/0, isModifierEnabled("HideTime") and 4 or 1/0)}`)
			elseif Floor == "Mines" then
				annoying_notification:ChangeDescription(`Current hide time: {math.clamp(math.round((rn2ht(arg)+(arg>=61 and 1.4 or 0))*1000)/1000, -1/0, isModifierEnabled("HideTime") and 4 or 1/0)}`)
			end
		end
	end

	Toggles.CurrentHideTime = Groupbox2:AddToggle(prefix..'CurrentHideTime', {
		Text = 'Current Hide Time',
		DisabledTooltip = 'Floor is not supported',
		Default = false,
		Disabled = Floor ~= "Hotel" and Floor ~= "Mines",

		Callback = function(value)
			if value then
				annoying_notification = Library:Notify({
					Title = AddonTitle,
					Description = 'Current hide time: ?',
					Persist = true
				})
				update(LatestRoom.Value)
				Connections.HideTimeChanged = CurrentRooms.ChildAdded:Connect(function(child)
					update(LatestRoom.Value)
				end)
			else
				if annoying_notification then
					annoying_notification:Destroy()
				end
				if Connections.HideTimeChanged then
					Connections.HideTimeChanged:Disconnect()
				end
			end
		end
	})

	Toggles.HidingRoomNotify = Groupbox2:AddToggle(prefix..'HidingRoomNotify', {
		Text = 'Hiding Room Notify',
		Tooltip = 'May predict when Rush or Ambush will spawn',
		Default = false,

		Callback = function(value)
			if value then
				Connections.EntityPrediction = CurrentRooms.ChildAdded:Connect(function(child)
					if child:GetAttribute('HidingRoom') and not workspace:FindFirstChild('RushMoving') and not workspace:FindFirstChild('AmbushMoving') then
						Library:Notify({
							Title = AddonTitle,
							Description = 'Next room is a hiding room',
							Time = 2
						})
					end
				end)
			else
				if not Connections.EntityPrediction then return end
				Connections.EntityPrediction:Disconnect()
			end
		end
	})

	local CARRemote
	task.spawn(function()
		CARRemote = ReplicatedStorage:WaitForChild("ClientAnimationReceiver", 1/0):WaitForChild("RemoteEvent", 1/0)
	end)

	local GSNotifier = false
	Toggles.GSNotifier = Groupbox2:AddToggle(prefix..'GSNotifier', {
		Text = 'Groundskeeper Notifier',
		DisabledTooltip = 'Please wait...',
		Tooltip = 'Get notification when Groundskeeper wants to kill or killed somebody',
		Default = false,
		Disabled = not CARRemote,

		Callback = function(value)
			GSNotifier = Value
		end
	})

	local function getNameFromPartInLookAtAction(part)
		local player = part and part.Parent and Players:GetPlayerFromCharacter(part.Parent)
		if player then
			return `{player.DisplayName}{player.DisplayName == player.Name and "" or ` (@{player.Name})`}`
		elseif part and part.Name == "Root" and part.Parent and part.Parent.Name == "Mandrake" then
			return "Mandrake"
		else
			return "Someone"
		end
	end

	local lastLookAt
	local sprintTo
	task.spawn(function()
		while not CARRemote do
			task.wait()
		end
		Toggles.GSNotifier:SetDisabled(false)
		Connections.GroundskeeperWatcher = CARRemote.OnClientEvent:Connect(function(action, _, name, part)
			if not Toggles.GSNotifier.Value then return end
			if action == "ClientAction" and name == "LookAt" then
				lastLookAt = part
			elseif action == "PlayAnimation" then
				if name == "start_sprint" then
					sprintTo = lastLookAt
					Library:Notify({
						Title = AddonTitle.." [Groundskeeper]",
						Description = `Groundskeeper is sprinting to {getNameFromPartInLookAtAction(lastLookAt)}!`,
						Time = 3,
					})
				elseif name == "end_sprint" then
					Library:Notify({
						Title = AddonTitle.." [Groundskeeper]",
						Description = sprintTo and `Groundskeeper doesn't sprint to {getNameFromPartInLookAtAction(sprintTo)} now` or "Groundskeeper doesn't sprint now",
						Time = 3,
					})
					sprintTo = nil
				--[[elseif name == "kill_thing" then
					Library:Notify({
						Title = AddonTitle.." [Groundskeeper]",
						Description = `{getNameFromPartInLookAtAction(sprintTo)} was killed by Groundskeeper`,
						Time = 3,
					})
					sprintTo = nil]]
				elseif name == "crucifix" then
					Library:Notify({
						Title = AddonTitle.." [Groundskeeper]",
						Description = `Someone used crucifix on Groundskeeper, wtf?????`,
						Time = 3,
					})
					sprintTo = nil
				end
			elseif action == "StopAllAnimations" and not lastLookAt and sprintTo then
				Library:Notify({
					Title = AddonTitle.." [Groundskeeper]",
					Description = `{getNameFromPartInLookAtAction(sprintTo)} was killed by Groundskeeper`,
					Time = 3,
				})
				sprintTo = nil
			end
		end)
	end)

	Groupbox2:AddDivider({
		Margin = -6
	})

	local betterObtain = false
	local currentFunction = getcallbackvalue or getcallbackvalue(ObtainGiftedRevive, "OnClientInvoke") or function(...)end
	local obtain; obtain = hookmetamethod and hookmetamethod(game, "__newindex", function(...)
		local self, key, originalFunc = ...
		if not checkcaller() and self == ObtainGiftedRevive and key == "OnClientInvoke" then
			if betterObtain then
				hookfunction(originalFunc, OnReviveObtain)
			end
			currentFunction = originalFunc
		end
		return obtain(...)
	end)

	Toggles.BetterRevivesObtain = Groupbox2:AddToggle(prefix..'BetterRevivesObtain', {
		Text = 'Better Revives Obtain',
		DisabledTooltip = 'Executor is not supported',
		Tooltip = 'Lets you keep revives that players gifted you and receive multiple revive gifts without doors cancelling them',
		Default = betterObtain,
		Disabled = not (obtain and restorefunction),

		Callback = function(value)
			betterObtain = value
			local success, hooked = pcall(isfunctionhooked, currentFunction)
			hooked = success and hooked
			if value and not hooked then
				hookfunction(currentFunction, OnReviveObtain)
			elseif not value and hooked then
				restorefunction(currentFunction)
			end
			task.spawn(function()
				if disableGifting then
					Toggles.DisableReviveGifting:SetValue(false)
				end
				Toggles.DisableReviveGifting:SetDisabled(not value)
				disableGifting = false
			end)
		end
	})

	Toggles.DisableReviveGifting = Groupbox2:AddToggle(prefix..'DisableReviveGifting', {
		Text = 'Disable Revive Gifting',
		Tooltip = 'Prevent players from gifting you revives',
		Default = false,
		Disabled = true, -- it will be enabled with BetterRevivesObtain

		Callback = function(value)
			disableGifting = value
		end
	})

	local adminPanelOn = isModifierEnabled("AdminPanel")
	local adminLoaded = false
	local hook2

	if adminPanelOn then
		hook2 = hookmetamethod and hookmetamethod(game, '__index', function(...)
			local self, key = ...
			if self == game and key == 'GameId' and not checkcaller() and adminLoaded then
				return 3833818265
			end
			return hook2(...)
		end)

		admin = PlayerGui:FindFirstChild('DoorsAdmin')
		local Event = RemotesFolder.AdminPanelRunCommand
		local Stuff = {}

		function SetDisabled(bool)
			for name, stuff in Stuff do
				stuff:SetDisabled(bool)
			end
		end

		PlayerGui.ChildAdded:Connect(function(child)
			if child.Name == 'DoorsAdmin' and not admin then
				admin = child
				SetDisabled(false)
				Stuff.AdminPanelDebug:SetDisabled(false)
				admin.AncestryChanged:Once(function()
					admin = PlayerGui:FindFirstChild("DoorsAdmin")
					adminLoaded = not not admin
					SetDisabled(not admin)
				end)
			end
		end)

		Groupbox2:AddDivider({
			Text = "ADMIN PANEL",
			MarginTop = 2,
			MarginBottom = -2
		})

		Stuff.AdminPanelDebug = Groupbox2:AddButton(prefix..'AdminPanelDebug', {
			Text = 'Load Debug AP',
			DisabledTooltip = 'No admin panel',
			Tooltip = 'Adds debug & dev stuff in Admin Panel (and some custom things too)',
			DoubleClick = true,
			Disabled = not admin,
			Func = function()
				if adminLoaded then return end
				Stuff.AdminPanelDebug:SetDisabled(true)
				adminLoaded = true
				ItemsFromAddon = {}
				LocalPlayer:SetAttribute('ServerAdmin', 4)
				function AddItem(item, name, icon)
					local itemFolder = Instance.new('Folder', admin.AdminPanel.Items)
					itemFolder.Name = item
					itemFolder:SetAttribute('DisplayName', name)
					itemFolder:SetAttribute('Image', icon)
					ItemsFromAddon[#ItemsFromAddon+1] = itemFolder
				end
				AddItem('Candy', 'Candy', 'rbxassetid://91226846785149')
				AddItem('CandyBag', 'Candy Bag', 'rbxassetid://88108365460057')
				AddItem('Buddy', 'Buddy', 'rbxassetid://96164691124017')
				AddItem('Lotus', 'Lotus', 'rbxassetid://121905075599624')
				AddItem('LotusPetal', 'Lotus Petal', 'rbxassetid://82584389669499')
				AddItem('Scanner', 'NVCS-3000', 'rbxassetid://11374263930')
				task.wait()
				admin.AdminPanel.PanelClient.Enabled = false
				admin.Container.Pages:ClearAllChildren()
				local lol = admin.Container.TabButtons.UIListLayout:Clone()
				admin.Container.TabButtons:ClearAllChildren()
				lol.Parent = admin.Container.TabButtons
				admin.AdminPanel.PanelClient.Enabled = true
				Library:Notify({
					Title = AddonTitle,
					Description = 'Debug Admin Panel successfully loaded',
					Time = 3
				})
			end
		})

		local selected_players = nil

		Stuff.Players = Groupbox2:AddDropdown(prefix..'PlayersAdminPanel', {
			SpecialType = 'Player',
			Searchable = true,
			Multi = true,
			Text = 'Players',
			DisabledTooltip = 'No admin panel',
			Default = {},
			Disabled = not admin,
			Callback = function(value)
				selected_players = value
			end
		})

		Stuff.LagPlayer = Groupbox2:AddButton(prefix..'LagPlayer', {
			Text = 'Lag',
			DisabledTooltip = 'No admin panel',
			Tooltip = 'Lags player',
			DoubleClick = true,
			Disabled = not admin,
			Func = function()
				local PlayersNames = {}

				for player, _ in selected_players do
					PlayersNames[player.Name] = player.Name
				end

				for _ = 1,100 do
					Event:FireServer("GlitchPlayer", {
						Players = PlayersNames
					})
				end
			end
		})

		Stuff.LagAll = Groupbox2:AddButton(prefix..'LagAll', {
			Text = 'Lag All',
			DisabledTooltip = 'No admin panel',
			Tooltip = 'Lags all players (except you)',
			DoubleClick = true,
			Disabled = not admin,
			Func = function()
				local _Players = Players:GetPlayers()
				local PlayersNames = {}

				for _, player in _Players do
					if player ~= LocalPlayer then
						PlayersNames[player.Name] = player.Name
					end
				end

				for _ = 1,100 do
					Event:FireServer("GlitchPlayer", {
						Players = PlayersNames
					})
				end
			end
		})
	end

	Groupbox2:AddDivider({
		Text = "TROLL",
		MarginTop = 2,
		MarginBottom = -2
	})

	Toggles.Stun = Groupbox2:AddToggle(prefix..'Stun', {
		Text = 'Stun',
		Enabled = false,

		Callback = function(value, force)
			if force then return end
			if value then
				Character:SetAttribute('Stunned', true)
			else
				Character:SetAttribute('Stunned', false)
			end
		end
	})

	local thinkinganim = false
	Toggles.ThinkingAnimation = Groupbox2:AddToggle(prefix..'ThinkingAnimation', {
		Text = 'Thinking Animation',
		Enabled = false,

		Callback = function(value)
			if value then
				local animation = Instance.new('Animation')
				animation.AnimationId = 'rbxassetid://' .. thinkanims[math.random(1, #thinkanims)]
				animtrack = Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(animation)
				animtrack.Looped = true
				animtrack:Play()
			else
				if animtrack then
					animtrack:Stop()
					animtrack:Destroy()
				end
			end
		end
	})

	Groupbox2:AddDivider({
		Margin = -6
	})

	local WalkSpoofTable = {
		Methods = {
			ReallyFast = {
				Speed = "Framerate"
			},
			AnnoyingFootsteps = {
				Speed = "Framerate",
				Weight = 0
			},
			InvertedWalk = {
				Speed = "Inverted"
			},
			NoAnimation = {
				Speed = 0,
				Weight = 0
			}
		},
		Method = "NoAnimation"
	}

	local function getMethodValues()
		return WalkSpoofTable.Methods[WalkSpoofTable.Method]
	end

	local selfDontSpoof
	Toggles.WalkAnimSpoof = Groupbox2:AddToggle(prefix..'WalkAnimSpoof', {
		Text = 'Walking Anim Spoof',
		Tooltip = 'Makes your character walking differently',
		Enabled = false,

		Callback = function(value)
			if value then
				Connections.WalkAnimSpoofConnection = RunService.PreAnimation:Connect(function(dt)
					local forward = required_main_game.animations.Forward
					local vals = getMethodValues()
					if selfDontSpoof then
						RunService.PostSimulation:Wait()
					end
					if vals.Speed then
						forward:AdjustSpeed(vals.Speed == "Framerate" and 1/dt or vals.Speed == "Inverted" and -forward.Speed or vals.Speed)
					end
					if vals.Weight then
						forward:AdjustWeight(vals.Weight)
					end
				end)
			else
				if Connections.WalkAnimSpoofConnection then
					Connections.WalkAnimSpoofConnection:Disconnect()
					Connections.WalkAnimSpoofConnection = nil
				end
			end
		end
	})

	Toggles.DontShowSpoofedWalkAnim = Groupbox2:AddToggle(prefix..'DontShowSpoofedWalkAnim', {
		Text = 'Dont Spoof For Yourself',
		Tooltip = "Doesn't change walking animation for yourself",
		Enabled = false,

		Callback = function(value)
			selfDontSpoof = value
		end
	})

	local MethodsIndexWalk = {}
	for index, _ in WalkSpoofTable.Methods do
		table.insert(MethodsIndexWalk, index)
	end

	Groupbox2:AddDropdown(prefix..'WalkMethods', {
		Multi = false,
		Text = 'Methods',
		DisabledTooltip = 'Executor is not supported',
		Disabled = not hookmetamethod,
		Values = MethodsIndexWalk,
		Default = WalkSpoofTable.Method,

		Callback = function(value)
			WalkSpoofTable.Method = value
		end
	})

	Groupbox2:AddDivider({
		Margin = -3
	})

	function disconnectPart(part)
		local part = Connections.PartsConnections[part]
		for index, connection in part or {} do
			connection:Disconnect()
		end
		part = nil
	end

	function handlePart(part)
		if part:IsA("BasePart") then
			Connections.PartsConnections = Connections.PartsConnections or {}
			Connections.PartsConnections[part] = {
				AncestryChanged = part.AncestryChanged:Connect(function()
					if not part.Parent then
						disconnectPart(part)
					end
				end),
				CrazyLoop = RunService.RenderStepped:Connect(function()
					if isnetworkowner(part) and not part.Anchored then
						part.CFrame *= CFrame.Angles(math.rad(math.random(-1800,1800)/100*4),math.rad(math.random(-1800,1800)/100*4),math.rad(math.random(-1800,1800)/100*4))
					end
				end)
			}
		end
	end

	Toggles.CrazyUnanchoredParts = Groupbox2:AddToggle(prefix..'CrazyUnanchoredParts', {
		Text = 'Crazy Unanchored Parts',
		DisabledTooltip = 'Executor is not supported',
		Tooltip = 'Makes unanchored parts go crazy',
		Default = false,
		Disabled = not isnetworkowner,

		Callback = function(value)
			if value then
				toggleNetworkOwner(true)
				for _, part in CurrentRooms:GetDescendants() do
					handlePart(part)
				end
				Connections.UnanchoredPartAdded = CurrentRooms.DescendantAdded:Connect(handlePart)
			else
				toggleNetworkOwner(false)
				if Connections.UnanchoredPartAdded then
					Connections.UnanchoredPartAdded:Disconnect()
					Connections.UnanchoredPartAdded = nil
				end
				for part, _ in Connections.PartsConnections do
					disconnectPart(part)
				end
				Connections.PartsConnections = nil
			end
		end
	})

	grumblesOffset = Vector3.new(0,10000,0)
	Toggles.InvisibleGrumbles = Groupbox2:AddToggle(prefix..'InvisibleGrumbles', {
		Text = 'Invisible Grumbles',
		Default = false,

		Callback = function(value)
			if value then
				local nest = CurrentRooms:FindFirstChild('_NestHandler', true)
				local grumbles = nest and nest:FindFirstChild('Grumbles')
				if grumbles then
					toggleNetworkOwner(true)
					Connections.LoopInvisGrumbles = RunService.Heartbeat:Connect(function()
						for _, grumble in grumbles:GetChildren() do
							task.spawn(function()
								local rig = grumble:FindFirstChild("GrumbleRig")
								local root = rig and rig:FindFirstChild("Root")
								if root then
									root.CFrame += grumblesOffset
									RunService.RenderStepped:Wait()
									root.CFrame -= grumblesOffset
								end
							end)
						end
					end)
					Library:Notify({
						Title = AddonTitle,
						Description = "Grumbles won't appear for everyone now! (only you can see them)",
						Time = 4
					})
				else
					Library:Notify({
						Title = AddonTitle.." [Error]",
						Description = 'Grumbles not found',
						Time = 2
					})
					Toggles.InvisibleGrumbles:SetValue(false)
				end
			else
				toggleNetworkOwner(false)
				if Connections.LoopInvisGrumbles then
					Connections.LoopInvisGrumbles:Disconnect()
					Connections.LoopInvisGrumbles = nil
				end
			end
		end
	})

	Toggles.LoopTriggerFigure = Groupbox2:AddToggle(prefix..'LoopTriggerFigure', {
		Text = 'Loop Trigger Figure',
		Tooltip = 'Fakes footsteps to trigger figure',
		Default = false,

		Callback = function()
			while Toggles.LoopTriggerFigure.Value do
				Footstep:FireServer()
				task.wait()
			end
		end
	})

	KeyPickers.TriggerFigureKey = Toggles.LoopTriggerFigure:AddKeyPicker(prefix.."TriggerFigureKey", {
		Text = 'Loop Trigger Figure',
		Default = "Z",
		Mode = Library.IsMobile and "Toggle" or "Hold",
		SyncToggleState = true
	})

	local playerToKill
	Groupbox2:AddDropdown(prefix..'PlayerToKill', {
		SpecialType = 'Player',
		Searchable = true,
		Multi = false,
		Text = 'Player',
		Default = {},
		Callback = function(value)
			playerToKill = value
		end
	})

	local killPlayerWF; killPlayerWF = Groupbox2:AddButton(prefix..'KillPlayerWithFigure', {
		Text = 'Kill Player',
		DisabledTooltip = 'Please wait...',
		Tooltip = 'Requires Figure to be in the same room with selected player',
		DoubleClick = true,
		Func = function()
			if not (Character and Character:FindFirstChild("HumanoidRootPart")) then
				Library:Notify({
					Title = AddonTitle.." [Error]",
					Description = 'Root part of local player is not found',
					Time = 3
				})
				return
			end
			if playerToKill then
				if playerToKill == LocalPlayer then
					Library:Notify({
						Title = AddonTitle.." [Error]",
						Description = "bro u cant kill urself with figure",
						Time = 3
					})
					return
				end
				if playerToKill:GetAttribute("Alive") then
					local Victim = playerToKill.Character
					local VRoot = Victim and Victim:FindFirstChild("HumanoidRootPart")
					if VRoot then
						local figure = workspace:FindFirstChild("FigureRig", true)
						if not figure then
							Library:Notify({
								Title = AddonTitle.." [Error]",
								Description = 'Figure not found',
								Time = 2
							})
							return
						end
						local room = inWhatRoom(figure)
						if room ~= playerToKill:GetAttribute("CurrentRoom") then
							Library:Notify({
								Title = AddonTitle.." [Error]",
								Description = 'Figure is not in the same room with selected player',
								Time = 4
							})
							return
						end
						killPlayerWF:SetDisabled(true)
						local wasEnabled = {Toggles.CollisionOffsetGodmodeAlt.Value, Toggles.InfiniteCrucifixAlt.Value}
						if wasEnabled[1] then
							Toggles.CollisionOffsetGodmodeAlt:SetValue(false)
						end
						if wasEnabled[2] then
							Toggles.InfiniteCrucifixAlt:SetValue(false)
						end
						Toggles.CollisionOffsetGodmodeAlt:SetDisabled(true)
						Toggles.InfiniteCrucifixAlt:SetDisabled(true)
						Crouch:FireServer(nil,true)
						TPPath:ComputeAsync(Character.HumanoidRootPart.Position, VRoot.Position)
						local val = Toggles.AntiTeleport.Value
						if val then
							pcall(Toggles.AntiTeleport.Callback, false)
						end
						if #TPPath:GetWaypoints() > 0 then
							for _, point in TPPath:GetWaypoints() do
								Crouch:FireServer(nil,true)
								Character:PivotTo(CFrame.new(point.Position)+Vector3.new(0,12,0))
								task.wait()
							end
						end
						local OldCFrame = Character.HumanoidRootPart.CFrame
						local Weld = WeldTo(VRoot, CFrame.new(0,9,0))
						local lastfire = -1/0
						local started = os.clock()
						while room == playerToKill:GetAttribute("CurrentRoom") and playerToKill:GetAttribute("Alive") and Weld.Destroy and started > os.clock()-30 do
							Crouch:FireServer(nil,true)
							if lastfire < os.clock()-.5 then
								lastfire = os.clock()
								Footstep:FireServer()
							end
							task.wait()
						end
						if Weld.Destroy then Weld:Destroy() end
						settings().Physics.AllowSleep = Weld.OldAllowSleep
						task.wait()
						TPPath:ComputeAsync(VRoot.Position, OldCFrame.Position)
						if #TPPath:GetWaypoints() > 0 then
							for _, point in TPPath:GetWaypoints() do
								Crouch:FireServer(nil,true)
								Character:PivotTo(CFrame.new(point.Position)+Vector3.new(0,12,0))
								task.wait()
							end
							Character:PivotTo(OldCFrame)
						else
							Character:PivotTo(OldCFrame)
						end
						if val then
							pcall(Toggles.AntiTeleport.Callback, true)
						end
						Crouch:FireServer()
						if playerToKill:GetAttribute("Alive") then
							Library:Notify({
								Title = AddonTitle.." [Error]",
								Description = 'Failed to kill selected player',
								Time = 3
							})
						else
							Library:Notify({
								Title = AddonTitle,
								Description = 'Successfully killed selected player',
								Time = 3
							})
						end
					else
						Library:Notify({
							Title = AddonTitle.." [Error]",
							Description = 'Root part of selected player not found',
							Time = 3
						})
					end 
				else
					Library:Notify({
						Title = AddonTitle.." [Error]",
						Description = 'Selected player is already dead',
						Time = 3
					})
				end
			else
				Library:Notify({
					Title = AddonTitle.." [Error]",
					Description = 'No selected player',
					Time = 2
				})
			end
			killPlayerWF:SetDisabled(false)
			if wasEnabled[1] then
				Toggles.CollisionOffsetGodmodeAlt:SetValue(true)
			end
			if wasEnabled[2] then
				Toggles.InfiniteCrucifixAlt:SetValue(true)
			end
			Toggles.CollisionOffsetGodmodeAlt:SetDisabled(false)
			Toggles.InfiniteCrucifixAlt:SetDisabled(false)
		end
	})

	Groupbox2:AddDivider({
		Margin = -3
	})

	local MethodsIndex = {}
	for index, _ in motorReplicaAbuse.methods do
		table.insert(MethodsIndex, index)
	end

	Groupbox2:AddDropdown(prefix..'MotorMethods', {
		Multi = false,
		Text = 'Methods',
		DisabledTooltip = 'Executor is not supported',
		Disabled = not hookmetamethod,
		Values = MethodsIndex,
		Default = motorReplicaAbuse.method,

		Callback = function(value)
			motorReplicaAbuse.method = value
			if not motorReplicaAbuse.enabled then return end
			local method = motorReplicaAbuse.methods[value]
			if Connections.CurrentLVYAbuseMethodConnection then
				Connections.CurrentLVYAbuseMethodConnection:Disconnect()
				Connections.CurrentLVYAbuseMethodConnection = nil
			end
			if typeof(method) == "table" and method.methodType == "Number" then
				MotorReplication:FireServer(0)
			elseif typeof(method) == "function" then
				if Connections.CurrentLVYAbuseMethodConnection then
					Connections.CurrentLVYAbuseMethodConnection:Disconnect()
					Connections.CurrentLVYAbuseMethodConnection = nil
				end
				Connections.CurrentLVYAbuseMethodConnection = method()
			end
		end
	})

	Toggles.MotorAbuse = Groupbox2:AddToggle(prefix..'MotorAbuse', {
		Text = 'LVY Abuse',
		Tooltip = 'Does some funny stuff with Motor Replication event (Everyone will see this)',
		Default = motorReplicaAbuse.enabled,
		DisabledTooltip = 'Executor is not supported',
		Disabled = not hookmetamethod,

		Callback = function(value)
			motorReplicaAbuse.enabled = value
			local method = motorReplicaAbuse.methods[motorReplicaAbuse.method]
			if value then
				if typeof(method) == "table" and method.methodType == "Number" then
					MotorReplication:FireServer(0)
				elseif typeof(method) == "function" then
					if Connections.CurrentLVYAbuseMethodConnection then
						Connections.CurrentLVYAbuseMethodConnection:Disconnect()
						Connections.CurrentLVYAbuseMethodConnection = nil
					end
					Connections.CurrentLVYAbuseMethodConnection = method()
				end
			else
				if Connections.CurrentLVYAbuseMethodConnection then
					Connections.CurrentLVYAbuseMethodConnection:Disconnect()
					Connections.CurrentLVYAbuseMethodConnection = nil
				end
				MotorReplication:FireServer(0)
			end
		end
	})

	Groupbox:AddDivider({
		Text = "ITEMS",
		MarginTop = 2,
		MarginBottom = -2
	})

	local itemsOffset = Vector3.zero
	local selectedPlayerItem = nil
	local old = {}

	function toggleNetworkOwner(bool)
		if not(gethiddenproperty and sethiddenproperty) then return end
		if (Toggles.InvisibleGrumbles.Value or Toggles.LoopSteal.Value or Toggles.AntiMandrakeFE.Value or Toggles.OrbitDrops.Value or Toggles.OrbitGlowsticks.Value or Toggles.CrazyUnanchoredParts.Value or Toggles.BringDrawerWithKey.Value) and not bool then return end
		if bool and not Connections.network then
			old.allowSleep = settings().Physics.AllowSleep
			old.replicaFocus = LocalPlayer.ReplicationFocus
			old.maxSimRadius = gethiddenproperty(LocalPlayer, 'MaximumSimulationRadius')
			old.simRadius = gethiddenproperty(LocalPlayer, 'SimulationRadius')
			settings().Physics.AllowSleep = false
			LocalPlayer.ReplicationFocus = workspace
			Connections.network = RunService.Heartbeat:Connect(function()
				sethiddenproperty(LocalPlayer, 'MaximumSimulationRadius', 1/0)
				sethiddenproperty(LocalPlayer, 'SimulationRadius', 1/0)
				for _, Player in Players:GetPlayers() do
					if Player == LocalPlayer then return end
					sethiddenproperty(Player, 'MaxSimulationRadius', -1/0)
					sethiddenproperty(Player, 'SimulationRadius', -1/0)
				end
			end)
		elseif not bool and Connections.network then
			settings().Physics.AllowSleep = old.allowSleep
			Connections.network:Disconnect()
			Connections.network = nil
			LocalPlayer.ReplicationFocus = old.replicaFocus
			sethiddenproperty(LocalPlayer, 'MaximumSimulationRadius', old.maxSimRadius)
			sethiddenproperty(LocalPlayer, 'SimulationRadius', old.simRadius)
			old = {}
		end
	end

	local connectedPrompts = {}

	local function activatePrompt(hrp, drop, prompt)
		if typeof(prompt) == 'Instance' and prompt:IsA('ProximityPrompt') then
			local connection = {changeHrp = function(newhrp)
				hrp = newhrp or hrp
			end}
			function connection:onActivate()
				self = nil
			end
			table.insert(connectedPrompts, connection)
			task.spawn(function()
				local lastDetectedHrp = os.clock()
				while prompt.Parent and connection and os.clock()-lastDetectedHrp < 3 do
					if hrp.Parent then
						lastDetectedHrp = os.clock()
						drop:PivotTo(hrp.CFrame + itemsOffset)
						fireproximityprompt(prompt)
					end
					for _ = 1,math.clamp(#connectedPrompts,1,1/0) do -- math.clamp is here to prevent 'while true do end' crash
						task.wait()
					end
				end
				if connection then
					connection:onActivate()
				end
			end)
			return connection
		end
	end

	Groupbox:AddDropdown(prefix..'PlayerToBringItems', {
		SpecialType = 'Player',
		Searchable = true,
		Multi = true,
		Text = 'Player',
		Default = {},
		Callback = function(value)
			selectedPlayerItem = value
		end
	})

	Groupbox:AddButton(prefix.."BringDrops", {
		Text = 'Bring Drops',
		Tooltip = 'Bring all the dropped items to your current player',
		Func = function()
			local char = selectedPlayerItem and selectedPlayerItem.Character or Character
			local human = char and char:FindFirstChild('Humanoid')
			local hrp = human and human.RootPart

			if hrp then
				toggleNetworkOwner(true)
				for _, drop in Drops:GetChildren() do
					if drop:IsA('BasePart') then
						drop.CFrame = hrp.CFrame + itemsOffset
					elseif drop:IsA('Model') then
						drop:PivotTo(hrp.CFrame + itemsOffset)
					end
				end
				toggleNetworkOwner(false)
			end
		end
	})

	Groupbox:AddButton(prefix.."StealDrops", {
		Text = 'Steal Drops',
		Tooltip = 'Steal all the dropped items',
		Func = function()
			local char = Character
			local human = char and char:FindFirstChild('Humanoid')
			local hrp = human and human.RootPart

			if hrp then
				toggleNetworkOwner(true)
				for _, drop in Drops:GetChildren() do
					if drop:IsA('BasePart') then
						activatePrompt(hrp, drop, drop:FindFirstChild('ModulePrompt', true))
					elseif drop:IsA('Model') then
						activatePrompt(hrp, drop, drop:FindFirstChild('ModulePrompt', true))
					end
				end
				toggleNetworkOwner(false)
			end
		end
	})

	Toggles.LoopSteal = Groupbox:AddToggle(prefix..'LoopSteal', {
		Text = 'Loop Steal Drops',
		Tooltip = 'Loop steal all the dropped items (except yours)',
		Default = false,
		Callback = function(bool)
			if not bool then
				if Connections.loop then
					Connections.loop:Disconnect()
					Connections.loop = nil
				end
				if Connections.charchanged then
					Connections.charchanged:Disconnect()
					Connections.charchanged = nil
				end
				if Connections.rootchanged then
					Connections.rootchanged:Disconnect()
					Connections.rootchanged = nil
				end
				for _, connection in connectedPrompts do
					connection:onActivate()
				end
				toggleNetworkOwner(false)
				return
			end

			local char = Character or LocalPlayer.CharacterAdded:Wait()
			local human = char:WaitForChild('Humanoid', 99)
			local hrp = human.RootPart
			Connections.rootchanged = human:GetPropertyChangedSignal("RootPart"):Connect(function()
				hrp = human.RootPart
				for _, connection in connectedPrompts do
					connection:changeHrp(hrp)
				end
			end)

			if not Toggles.LoopSteal.Value then return end

			if hrp then
				toggleNetworkOwner(true)
				for _, drop in Drops:GetChildren() do
					if drop:GetAttribute("PlayerName") == LocalPlayer.Name then continue end
					if drop:IsA('BasePart') then
						activatePrompt(hrp, drop, drop:FindFirstChild('ModulePrompt', true))
					elseif drop:IsA('Model') then
						activatePrompt(hrp, drop, drop:FindFirstChild('ModulePrompt', true))
					end
				end
				Connections.loop = Drops.ChildAdded:Connect(function(drop)
					if drop:GetAttribute("PlayerName") == LocalPlayer.Name then return end
					if drop:IsA('BasePart') then
						activatePrompt(hrp, drop, drop:FindFirstChild('ModulePrompt', true))
					elseif drop:IsA('Model') then
						activatePrompt(hrp, drop, drop:FindFirstChild('ModulePrompt', true))
					end
				end)
				Connections.charchanged = LocalPlayer.CharacterAdded:Connect(function(c)
					char = c
					human = c:WaitForChild('Humanoid', 99)
					hrp = human.RootPart or hrp
					if Connections.rootchanged then
						Connections.rootchanged:Disconnect()
					end
					Connections.rootchanged = human:GetPropertyChangedSignal("RootPart"):Connect(function()
						hrp = human.RootPart
						for _, connection in connectedPrompts do
							connection:changeHrp(hrp)
						end
					end)
					for _, connection in connectedPrompts do
						connection:changeHrp(hrp)
					end
				end)
			else
				toggle:SetValue(false)
			end
		end
	})

	Groupbox:AddDivider({
		Margin = -6
	})

	local Settings = {}
	local VisualOrbitOffset = Vector3.new(0,-128,0)
	Toggles.OrbitDrops = Groupbox:AddToggle(prefix..'OrbitDrops', {
		Text = 'Orbit Drops',
		Default = false,
		Callback = function(bool)
			if bool then
				toggleNetworkOwner(true)
				local val = 0
				Connections.OrbitDropsConnection = RunService.Heartbeat:Connect(function(dt)
					val = (val + dt * 90 * Settings.Speed.Value) % 360
					local Root = Character and Character:FindFirstChild("HumanoidRootPart")
					if Root and Character:GetAttribute("Alive") then
						local drops = Drops:QueryDescendants("> Model")
						for num, drop in drops do
							drop:PivotTo((CFrame.Angles(0, math.rad(val - 360 / #drops * num), 0) + Root.Position) * CFrame.new(0, 0, Settings.Offset.Value) + (Toggles.AntiSteal.Value and VisualOrbitOffset or Vector3.zero))
							local prompt = drop:FindFirstChild("ModulePrompt")
							if prompt then
								prompt.Enabled = not Toggles.NoPrompt.Value
							end
							local main = drop:FindFirstChild("Main")
							if main then
								main.AssemblyLinearVelocity = Vector3.zero
								main.CanQuery = not Toggles.NoPrompt.Value
							end
							local itemDropPickup = drop:FindFirstChild("ItemDropPickup")
							if itemDropPickup then
								itemDropPickup.CanCollide = not Toggles.NoPrompt.Value
								itemDropPickup.CanQuery = not Toggles.NoPrompt.Value
							end
						end
						if Toggles.AntiSteal.Value then
							RunService.RenderStepped:Wait()
							for num, drop in drops do
								drop:PivotTo(drop:GetPivot() - VisualOrbitOffset)
							end
						end
					end
				end)
			else
				toggleNetworkOwner(false)
				if Connections.OrbitDropsConnection then
					if Toggles.AntiSteal.Value then
						pcall(Toggles.dfggfgfdgfdsdfgsgdf.Callback, false)
						RunService.RenderStepped:Wait()
					end
					Connections.OrbitDropsConnection:Disconnect()
					Connections.OrbitDropsConnection = nil
					if Toggles.NoPrompt.Value then
						local drops = Drops:QueryDescendants("> Model")
						for num, drop in drops do
							local prompt = drop:FindFirstChild("ModulePrompt")
							if prompt then
								prompt.Enabled = true
							end
							local main = drop:FindFirstChild("Main")
							if main then
								main.CanQuery = true
							end
							local itemDropPickup = drop:FindFirstChild("ItemDropPickup")
							if itemDropPickup then
								itemDropPickup.CanCollide = true
								itemDropPickup.CanQuery = true
							end
						end
					end
				end
			end
		end
	})

	Toggles.OrbitGlowsticks = Groupbox:AddToggle(prefix..'OrbitGlowsticks', {
		Text = 'Orbit Glowsticks',
		Default = false,
		Callback = function(bool)
			if bool then
				toggleNetworkOwner(true)
				local val = 0
				Connections.OrbitGlowsticksConnection = RunService.Heartbeat:Connect(function(dt)
					val = (val + dt * 90 * Settings.Speed.Value) % 360
					local Root = Character and Character:FindFirstChild("HumanoidRootPart")
					if Root and Character:GetAttribute("Alive") then
						local sticks = workspace:QueryDescendants(`> #GlowstickLive[$Owner = {LocalPlayer.Name}]`)
						for num, stick in sticks do
							stick.CFrame = (CFrame.Angles(0, math.rad(val - 360 / #sticks * num), 0) + Root.Position) * CFrame.new(0, 0, Settings.Offset.Value)
						end
					end
				end)
			else
				toggleNetworkOwner(false)
				if Connections.OrbitGlowsticksConnection then
					Connections.OrbitGlowsticksConnection:Disconnect()
					Connections.OrbitGlowsticksConnection = nil
				end
			end
		end
	})

	Settings.Speed = Groupbox:AddSlider(prefix.."Speed", {
    	Text = "Speed",
    	Default = 1,
    	Min = 0,
    	Max = 4,
    	Rounding = 1,
	})

	Settings.Offset = Groupbox:AddSlider(prefix.."Offset", {
    	Text = "Offset",
    	Default = 4,
    	Min = 2,
    	Max = 8,
    	Rounding = 1,
	})

	Toggles.AntiSteal = Groupbox:AddToggle(prefix..'AntiSteal', {
		Text = 'Anti Steal',
		Tooltip = "Doesn't allow players to steal items while Orbit Items is on",
		Default = false
	})

	Toggles.NoPrompt = Groupbox:AddToggle(prefix..'NoPrompt', {
		Text = 'No Prompt',
		Tooltip = 'Hides the prompt while Orbit Items is on',
		Default = false
	})

	Groupbox2:AddDivider({
		Text = "MISC",
		MarginTop = 2,
		MarginBottom = -2
	})

	local sound = '7107161936'
	local color = Color3.new(1,1,1)
	local captionEnabled = false

	Toggles.DeluluCaption = Groupbox2:AddToggle(prefix..'DeluluCaption', {
		Text = 'Delulu Caption',
		Tooltip = 'Caption from delusional office',
		DisabledTooltip = 'Please wait...',
		Disabled = not spawncaption,
		Default = false,

		Callback = function(value)
			if value then
				captionEnabled = true
				main_game.Reminder.Enabled = false
				Connections.caption = RemotesFolder.Caption.OnClientEvent:Connect(function(text)
					spawncaption(script1.Parent:WaitForChild('MainTextFrameSample'), script1.Parent, text, `rbxassetid://{sound}`, color)
				end)
				Connections.disableogcaption = RunService.RenderStepped:Connect(function()
					pcall(function()
						main_game.Reminder.Enabled = false
					end)
				end)
			else
				if not captionEnabled then return end
				captionEnabled = false
				Connections.caption:Disconnect()
				Connections.disableogcaption:Disconnect()
				main_game.Reminder.Enabled = true
			end
		end
	})

	task.spawn(function()
		while not spawncaption do
			task.wait()
		end
		Toggles.DeluluCaption:SetDisabled(false)
	end)

	local DeluluSettings = Groupbox2:AddDependencyBox(prefix.."DeluluSettings")

	DeluluSettings:AddInput(prefix..'DeluluSound', {
		Text = 'Caption Sound',
		Numeric = true,
		Finished = true,
		ClearTextOnFocus = true,
		Placeholder = sound,
		Default = sound,

		Callback = function(newsound)
			sound = newsound
		end
	})

	DeluluSettings:AddLabel('Caption Color'):AddColorPicker(prefix..'DeluluColor', {
		Title = 'Caption Color',
		Default = color,

		Callback = function(newcolor)
			color = newcolor
		end
	})

	DeluluSettings:SetupDependencies({
		{ Toggles.DeluluCaption, true }
	})

	Groupbox2:AddDivider({
		Margin = -6
	})

	local light = "Blue"

	Groupbox2:AddDropdown(prefix..'Lights', {
		Multi = false,
		Text = 'Lights',
		DisabledTooltip = 'Executor is not supported',
		Disabled = not firesignal,
		Values = {
			"Blue",
			"Yellow",
			"Glitch",
			"Rush"
		},
		Default = light,

		Callback = function(value)
			light = value
		end
	})

	local EvilTexts = {
		Blue = {
			Rush = {
				NoPosOffset = {
					"You died to Rush.",
					"Why can't you just hide in the closet.",
					"Are you stupid?"
				},
				PosOffset = {
					"Okay that is absolutely TERRIBLE...",
					"You died to a Rush with a FRICKING POSITION OFFSET.",
					"ARE YOU A ####### OR SOMETHING!?",
					"...",
					"You should probably get better at this game, NOOB."
				}
			},
			Blitz = {
				NoPosOffset = {
					"You died to Blitz.",
					"Why can't you just hide in the closet.",
					"Are you stupid?"
				},
				PosOffset = {
					"Okay that is TERRIBLE...",
					"You died to a Blitz with a POSITION OFFSET.",
					"HOW DID YOU EVEN MANAGED TO DIE!?!?",
					"You should probably get better at this game, NOOB."
				}
			},
			Ambush = {
				NoPosOffset = {
					"And you died to Ambush.",
					"Well, not surprised."
				},
				PosOffset = {
					"You have a Position Offset on...",
					"AND YOU STILL DIED TO AMBUSH!!!",
					"You can't even play this game with cheats!"
				}
			},
			ClientEntity = {
				"...",
				"Listen to me, skid.",
				"You can just disable this entity.",
				"But because you didn't do it,",
				"You probably can't have more than 7 IQ."
			},
			Other = {
				"You died to %s with cheats.",
				"Pfft, get better LOL."
			}
		},
		Yellow = {
			Rush = {
				NoPosOffset = {
					"Okay who killed you this time.",
					"...",
					"Bro, you was able to enter the ####### closet to survive,",
					"But because you are stupid you didn't do it."
				},
				PosOffset = {
					"Okay who killed you this time.",
					"...",
					"Well, you are terrible at this game,",
					"Can you just ####### leave please?"
				}
			},
			Blitz = {
				NoPosOffset = {
					"Who killed you this time.",
					"Ehh.. this guy.",
					"You was able just to hide in the closet to survive him bro,",
					"How many times i should repeat this."
				},
				PosOffset = {
					"Who killed you this time.",
					"Oh.",
					"Lmfao i think you have skill issue,",
					"Just get better bro."
				}
			},
			Ambush = {
				NoPosOffset = {
					"And you died to Ambush.",
					"Well, not surprised."
				},
				PosOffset = {
					"You have a Position Offset on...",
					"AND YOU STILL DIED TO AMBUSH!!!",
					"You can't even play this game with cheats!"
				}
			},
			ClientEntity = {
				"Press Right Shift,",
				"Go to Exploits,",
				"And disable the ####### entity, you #######."
			},
			Other = {
				"#### off bro Im not curious about who caused your death."
			}
		},
		Glitch = {
			Rush = {
				NoPosOffset = {
					"PRESS ALT+F4 TWICE TO REMOVE RUSH",
					"SO YOU DON'T HAVE TO HIDE"
				},
				PosOffset = {
					">",
					"SKID SKID SKID SAHUR"
				}
			},
			Blitz = {
				NoPosOffset = {
					"PRESS ALT+F4 TWICE TO REMOVE BLITZ",
					"SO YOU DON'T HAVE TO HIDE"
				},
				PosOffset = {
					">",
					"HEY, YOU [_] STUPID!"
				}
			},
			Ambush = {
				NoPosOffset = {
					"PRESS ALT+F4 TO REMOVE AMBUSH",
					"SO YOU DON'T HAVE TO HIDE"
				},
				PosOffset = {
					">",
					"EXECUTE 'setrawmetatable(game, {})'"
				}
			},
			ClientEntity = {
				">",
				"BRO DISABLE HIM :SOB:"
			},
			Other = {
				"WELL WELL WELL",
				">",
				unpack(table.create(100, "A")) -- this is gonna be fun
			}
		},
		Rush = {
			Rush = {
				NoPosOffset = table.create(math.random(1,5), string.rep("RUSH ", math.random(5, 10))),
				PosOffset = table.create(math.random(1,5), string.rep("RUSH ", math.random(5, 10)))
			},
			Blitz = {
				NoPosOffset = table.create(math.random(1,5), string.rep("RUSH ", math.random(5, 10))),
				PosOffset = table.create(math.random(1,5), string.rep("RUSH ", math.random(5, 10)))
			},
			Ambush = {
				NoPosOffset = table.create(math.random(1,5), string.rep("RUSH ", math.random(5, 10))),
				PosOffset = table.create(math.random(1,5), string.rep("RUSH ", math.random(5, 10)))
			},
			ClientEntity = table.create(math.random(1,5), string.rep("RUSH ", math.random(5, 10))),
			Other = table.create(math.random(1,5), string.rep("RUSH ", math.random(5, 10)))
		}
	}

	local Rushers = {
		"Rush",
		"Blitz",
		"Ambush"
	}

	local ClientEntities = {
		"Screech",
		"A-90",
		"Halt",
		"Snare"
	}

	local function pickEvilDialogue(light)
		local lightTexts = EvilTexts[light]
		local deathCause = Character:GetAttribute("DeathCause")
		if table.find(Rushers, deathCause) then
			local texts = lightTexts[deathCause]
			return Toggles.CollisionOffsetGodmodeAlt.Value and texts.PosOffset or texts.NoPosOffset
		elseif table.find(ClientEntities, deathCause) then
			return lightTexts.ClientEntity
		else
			return lightTexts.Other
		end
	end

	local lod = false
	local nld = false
	local edc = false
	local deathHintConnection = firesignal and DeathHint.OnClientEvent:Connect(function(texts, lightName, exploited)
		if not exploited and (lod or nld) then
			lightName = lod and light or lightName
			texts = nld and {} or edc and pickEvilDialogue(lightName) or texts
			for _ = 1,30 do -- so it would work 100%
				firesignal(DeathHint.OnClientEvent, texts, lightName, true)
				task.wait()
			end
		end
	end)

	Toggles.LightOnDeath = Groupbox2:AddToggle(prefix..'LightOnDeath', {
		Text = 'Light On Death',
		Tooltip = "Replace default light on current floor with other ones (text wouldn't change)",
		DisabledTooltip = 'Executor is not supported',
		Disabled = not deathHintConnection,
		Default = false,

		Callback = function(value)
			lod = value
		end
	})

	Toggles.NoLightDialog = Groupbox2:AddToggle(prefix..'NoLightDialog', {
		Text = 'No Light Dialog',
		Tooltip = "Remove dialog after you died",
		DisabledTooltip = 'Executor is not supported',
		Disabled = not deathHintConnection,
		Default = false,

		Callback = function(value)
			if Toggles.EvilLights.Value and value then
				Toggles.EvilLights:SetValue(false)
			end
			nld = value
		end
	})

	Toggles.EvilLights = Groupbox2:AddToggle(prefix..'EvilLights', {
		Text = 'Evil Lights',
		Tooltip = "Lights instead of helping you saying something else (why i made this)",
		DisabledTooltip = 'Executor is not supported',
		Disabled = not deathHintConnection,
		Default = false,

		Callback = function(value)
			if Toggles.NoLightDialog.Value and value then
				Toggles.NoLightDialog:SetValue(false)
			end
			edc = value
		end
	})

	Groupbox:AddDivider({
		Text = "ANTI ENTITIES",
		MarginTop = 2,
		MarginBottom = -2
	})

	OGC1 = CFrame.new()
	local POAClones = {}
	local POALastCrouchFire = 0

	local function PositionOffsetAltCleanup()
		if Connections.POA then
			Connections.POA:Disconnect()
			Connections.POA = nil
		end

		local Collision = Character and Character:FindFirstChild("Collision")
		local CollisionPart = Character and Character:FindFirstChild("CollisionPart")
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
		local LowerTorso = Character and Character:FindFirstChild("LowerTorso")

		if Humanoid then
			Humanoid.HipHeight = 2.4
		end

		if RootPart then
			RootPart.CFrame *= CFrame.new(0, 2.346, 0)
		end

		if LowerTorso and LowerTorso:FindFirstChild("Root") then
			LowerTorso.Root.C1 = OGC1
		end

		if Collision then
			Collision.Position = RootPart and (RootPart.Position + Vector3.new(0, .18, 0)) or Collision.Position
			Collision.CanCollide = not (Library.Toggles.Noclip.Value or Library.Toggles.VelocityManipulationToggle.Value)
			local crouch = Collision:FindFirstChild("CollisionCrouch")
			if crouch then
				crouch.Position = RootPart and (RootPart.Position + Vector3.new(0, -.982, 0)) or crouch.Position
				crouch.CanCollide = not Library.Toggles.Noclip.Value
			end
		end

		if CollisionPart and RootPart then
			CollisionPart.Position = RootPart.Position + Vector3.new(0, .18, 0)
			CollisionPart.CanCollide = not Library.Toggles.Noclip.Value
		end

		for _, clone in ipairs(POAClones) do
			if clone and clone.Parent then clone:Destroy() end
		end
		table.clear(POAClones)

		cogAlt = false
	end

	Toggles.CollisionOffsetGodmodeAlt = NoAltFeatures() or Groupbox:AddToggle(prefix..'CollisionOffsetGodmodeAlt', {
		Text = 'Position Offset Alt',
		Tooltip = "Alternative Position Offset based on Abysall's implementation",
		Default = false,

		Callback = function(value)
			if value then
				if Toggles.AntiGroundskeeper.Value then Toggles.AntiGroundskeeper:SetValue(false) end
				if Toggles.AntiFigure.Value then Toggles.AntiFigure:SetValue(false) end
				if Toggles.AntiTeleport.Value then pcall(Toggles.AntiTeleport.Callback, false, true) end

				local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
				local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
				local Collision = Character and Character:FindFirstChild("Collision")
				local CollisionPart = Character and Character:FindFirstChild("CollisionPart")
				local LowerTorso = Character and Character:FindFirstChild("LowerTorso")

				if not (Humanoid and RootPart and Collision) then
					Toggles.CollisionOffsetGodmodeAlt:SetValue(false)
					return
				end

				cogAlt = true
				if LowerTorso and LowerTorso:FindFirstChild("Root") then
					OGC1 = LowerTorso.Root.C1
				end

				for _, clone in ipairs(POAClones) do
					if clone and clone.Parent then clone:Destroy() end
				end
				table.clear(POAClones)

				local CollisionClone = Collision:Clone()
				CollisionClone.Name = "CollisionClone_POA"
				CollisionClone.Parent = Character
				CollisionClone.Massless = true
				table.insert(POAClones, CollisionClone)

				local CollisionPartClone
				if CollisionPart then
					CollisionPartClone = CollisionPart:Clone()
					CollisionPartClone.Name = "CollisionPartClone_POA"
					CollisionPartClone.Parent = Character
					CollisionPartClone.CanCollide = false
					CollisionPartClone.Massless = true
					local crouchClone = CollisionPartClone:FindFirstChild("CollisionCrouch")
					if crouchClone then crouchClone:Destroy() end
					table.insert(POAClones, CollisionPartClone)
				end

				RootPart.CFrame *= CFrame.new(0, -2.346, 0)
				Humanoid.HipHeight = 0.05

				if LowerTorso and LowerTorso:FindFirstChild("Root") then
					LowerTorso.Root.C1 = OGC1 * CFrame.new(0, -2.346, 0)
				end

				Crouch:FireServer(true, true)

				Connections.POA = RunService.RenderStepped:Connect(function()
					if not cogAlt or not Character or not Character.Parent then return end

					local hrp = Character:FindFirstChild("HumanoidRootPart")
					local hum = Character:FindFirstChildOfClass("Humanoid")
					local col = Character:FindFirstChild("Collision")
					local colPart = Character:FindFirstChild("CollisionPart")
					local torso = Character:FindFirstChild("LowerTorso")
					if not (hrp and hum and col and CollisionClone and CollisionClone.Parent) then return end

					hum.HipHeight = 0.05
					col.CanCollide = false
					col.Position = hrp.Position + Vector3.new(0, 2.328, 0)

					if colPart then
						colPart.CanCollide = false
						colPart.Position = hrp.Position + Vector3.new(0, 2.328, 0)
					end

					local crouch = col:FindFirstChild("CollisionCrouch")
					local cloneCrouch = CollisionClone:FindFirstChild("CollisionCrouch")
					local isCrouching

					-- Abysall determines the physical crouch state from the collision group.
					if colPart then
						isCrouching = colPart.CollisionGroup == "PlayerCrouching"
					elseif crouch then
						isCrouching = crouch.CollisionGroup == "PlayerCrouching"
					else
						isCrouching = false
					end

					local noclip = Library.Toggles.NoclipToggle and Library.Toggles.NoclipToggle.Value or false
					local velocityManip = Library.Toggles.VelocityManipulationToggle and Library.Toggles.VelocityManipulationToggle.Value or false

					if crouch then
						crouch.CanCollide = false
						crouch.Position = hrp.Position + Vector3.new(0, 1.328, 0)
					end

					CollisionClone.Position = hrp.Position + Vector3.new(0, 1.75, 0)
					CollisionClone.CollisionGroup = col.CollisionGroup

					if cloneCrouch then
						cloneCrouch.Position = hrp.Position + Vector3.new(0, 0.75, 0)
						if crouch then
							cloneCrouch.CollisionGroup = crouch.CollisionGroup
						else
							cloneCrouch.CollisionGroup = col.CollisionGroup
						end
					end

					-- Exactly one collider is active at a time:
					-- standing = tall collider; crouching = lower collider.
					CollisionClone.CanCollide = not (noclip or velocityManip or isCrouching)
					if cloneCrouch then
						cloneCrouch.CanCollide = not (noclip or velocityManip or not isCrouching)
					end

					if torso and torso:FindFirstChild("Root") then
						torso.Root.C1 = OGC1 * CFrame.new(0, -2.346, 0)
					end

					local now = tick()
					if now - POALastCrouchFire > 0.1 then
						Crouch:FireServer(true, true)
						POALastCrouchFire = now
					end
				end)
			else
				PositionOffsetAltCleanup()
				if RemotesFolder:FindFirstChild("Crouch") then
					Crouch:FireServer(false, true)
				end
			end
		end
	})

	KeyPickers.CollisionOffsetGodmodeAltKey = Toggles.CollisionOffsetGodmodeAlt.Callback and Toggles.CollisionOffsetGodmodeAlt:AddKeyPicker(prefix.."CollisionOffsetGodmodeAltKey", {
		Text = "Position Offset Alt",
		Default = "U",
		Mode = "Toggle",
		SyncToggleState = true
	})

	local RaycastParams = RaycastParams.new()
	RaycastParams.FilterType = Enum.RaycastFilterType.Include
	RaycastParams.RespectCanCollide = true

	local function visualizeRaycast(startpos, endpos)
		if not ADDON_CONFIG.Debug then return end
		local part = Instance.new("Part", workspace)
		local ok = endpos-startpos
		part.Size = Vector3.new(.1,.1,ok.Magnitude)
		part.CFrame = CFrame.lookAt(startpos, endpos)+ok.Unit*(ok.Magnitude/2)
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.Anchored = true
		part.Color = success and Color3.new(0,1) or Color3.new(1)
		Debris:AddItem(part, 5)
	end

	local ping = 0
	task.spawn(function()
		while task.wait(1/15) do
			task.spawn(function()
				local start = os.clock()
				RequestLocalAsset:InvokeServer({{}})
				ping = os.clock()-start
			end)
		end
	end)

	local Dupes = {}
	local function handleDupe(sideroomDupe)
		local hidden = sideroomDupe:WaitForChild("DoorFake", 1/0):WaitForChild("Hidden", 1/0)
		Connections[sideroomDupe] = hidden.Touched:Connect(function(hit)
			local collision = Character and Character:FindFirstChild("Collision")
			local tool = GetEquippedTool(LocalPlayer)
			if hit == collision and tool and tool.Name == "Crucifix" then
				table.remove(Dupes, table.find(Dupes, sideroomDupe))
				Connections[sideroomDupe]:Disconnect()
				Connections[sideroomDupe] = nil
				task.wait()
				DropItem:FireServer(tool)
				local crucifix
				local con; con = Drops.ChildAdded:Connect(function(child)
					if child.Name == "Crucifix" and child:GetAttribute("PlayerName") == LocalPlayer.Name then
						crucifix = child
						con:Disconnect()
					end
				end)
				while not crucifix do
					task.wait()
				end
				task.spawn(function()
					local start = os.clock()
					local prompt = crucifix:WaitForChild("ModulePrompt", 3)
					if prompt then
						crucifix:PivotTo(Character:GetPivot())
						if start <= os.clock()-.5 then
							fireproximityprompt(prompt)
						end
						while crucifix.Parent do
							task.wait()
							crucifix:PivotTo(Character:GetPivot())
							if start <= os.clock()-.5 then
								fireproximityprompt(prompt)
							end
						end
					end
				end)
			end
		end)
		table.insert(Dupes, sideroomDupe)
	end

	local Range = {
		RushMoving = 50,
		AmbushMoving = 60,
		["A60"] = 60,
	}

	local AntiDupe = Library.Toggles.AntiDupe

	Toggles.InfiniteCrucifixAlt = NoAltFeatures() or Groupbox:AddToggle(prefix..'InfiniteCrucifixAlt', {
		Text = 'Infinite Crucifix Alt',
		Risky = true,
		Tooltip = 'Should have more chance to dupe crucifix (WORKS ONLY ON RUSH, AMBUSH, A-60, DUPE)',
		Default = false,

		Callback = function(value)
			if value then
				if AntiDupe.Value then
					AntiDupe:SetValue(false)
				end
				AntiDupe:SetDisabled(true)
				Connections.InfiniteCrucifixConnection = workspace.ChildAdded:Connect(function(child)
					local n = child.Name
					if n=="RushMoving" or n=="AmbushMoving" or n=="A60" then
						local main = child:FindFirstChildWhichIsA("BasePart")
						if main then
							local speedTable = {}
							local speed = 0
							local dir = Vector3.zero
							local crucifixed = false
							task.spawn(function()
								local startpos = main.Position
								while startpos == main.Position do
									task.wait()
								end
								while not crucifixed do
									local pos = main.Position
									local dt = task.wait(1/15)
									local yea = main.Position-pos
									table.insert(speedTable, yea.Magnitude/dt)
									dir = yea.Unit
									if #speedTable > 15 then
										table.remove(speedTable, 1)
									end
									speed = 0
									for _, speed1 in speedTable do
										speed += speed1
									end
									speed /= #speedTable
								end
							end)
							while child.Parent do
								local cpart = Character and Character:FindFirstChild("CollisionPart")
								local tool = GetEquippedTool(LocalPlayer)
								RaycastParams.FilterDescendantsInstances = {CurrentRooms, cpart}
								local predictedpos = main.Position+(dir*ping)
								local yea = Range[n]
								local raycast = cpart and workspace:Raycast(predictedpos, (cpart.Position-predictedpos).Unit*yea, RaycastParams)
								local success = raycast and raycast.Instance == cpart
								--logprint(yea)
								logprint(raycast, raycast and raycast.Position, raycast and raycast.Instance)
								visualizeRaycast(predictedpos, raycast and raycast.Position or predictedpos+(cpart.Position-predictedpos).Unit*yea, success)
								if success and tool and tool.Name == "Crucifix" then
									log("DROP CRUCIFIX")
									DropItem:FireServer(tool)
									local crucifix
									local con1; con1 = child.AncestryChanged:Connect(function()
										if not child.Parent then
											crucifixed = true
											con1:Disconnect()
										end
									end)
									local con2; con2 = Drops.ChildAdded:Connect(function(child)
										if child.Name == "Crucifix" and child:GetAttribute("PlayerName") == LocalPlayer.Name then
											crucifix = child
											con2:Disconnect()
										end
									end)
									while not crucifix do
										task.wait()
									end
									task.spawn(function()
										local start = os.clock()
										local prompt = crucifix:WaitForChild("ModulePrompt", 3)
										if prompt then
											crucifix:PivotTo(Character:GetPivot())
											if not child.Parent or start <= os.clock()-1.5 then
												fireproximityprompt(prompt)
											end
											while crucifix.Parent do
												task.wait()
												crucifix:PivotTo(Character:GetPivot())
												if not child.Parent or start <= os.clock()-1.5 then
													fireproximityprompt(prompt)
												end
											end
										end
									end)
									break
								end
								RunService.Heartbeat:Wait()
							end
						end
					end
				end)
				Connections.OnDupeAnimation = Character:GetAttributeChangedSignal("Animating"):Connect(function()
					Character:SetAttribute("Animating", false)
				end)
				for _, dupe in CurrentRooms:QueryDescendants("Model >> #SideroomDupe") do
					handleDupe(dupe)
				end
				Connections.OnDupeSpawned = CurrentRooms.DescendantAdded:Connect(function(descendant)
					if descendant.Name == "SideroomDupe" then
						handleDupe(descendant)
					end
				end)
				Connections.OnDupeRemoved = CurrentRooms.DescendantRemoving:Connect(function(descendant)
					if descendant.Name == "SideroomDupe" then
						Connections[descendant]:Disconnect()
						Connections[descendant] = nil
						table.remove(Dupes, table.find(Dupes, descendant))
					end
				end)
			else
				AntiDupe:SetDisabled(false)
				if Connections.InfiniteCrucifixConnection then
					Connections.InfiniteCrucifixConnection:Disconnect()
					Connections.InfiniteCrucifixConnection = nil
				end
				if Connections.OnDupeAnimation then
					Connections.OnDupeAnimation:Disconnect()
					Connections.OnDupeAnimation = nil
				end
				if Connections.OnDupeSpawned then
					Connections.OnDupeSpawned:Disconnect()
					Connections.OnDupeSpawned = nil
				end
				for _, dupe in Dupes do
					Connections[dupe]:Disconnect()
					Connections[dupe] = nil
				end
				Dupes = {}
			end
		end
	})

	--[[Toggles.AntiFigureHearing = NoAltFeatures() or Groupbox:AddToggle(prefix..'AntiFigureHearing', {
		Text = 'Anti Figure Hearing Alt',
		Default = false,

		Callback = function(value)
			if value then
				if not hookmetamethod then
					Footstep.Parent = nil
				end
				antiFigure = true
			else
				if not hookmetamethod then
					Footstep.Parent = RemotesFolder
				end
				antiFigure = false
			end
		end
	})]]

	local MandrakesPos = {}

	StuffToRemoveLater.voidpos = Instance.new("BodyPosition")
	StuffToRemoveLater.voidpos.MaxForce = Vector3.new(1/0, 1/0, 1/0)
	StuffToRemoveLater.voidpos.Position = Vector3.new(0, -100000, 0)
	StuffToRemoveLater.voidpos.Name = "VoidPos"

	local function handleMandrake(mandrake)
		if mandrake.Name == "Mandrake" and mandrake:WaitForChild("ModulePrompt", 1) and mandrake:WaitForChild("KilledEvent", 1) and mandrake:WaitForChild("Root", 1) then
			local pos = StuffToRemoveLater.voidpos:Clone()
			pos.Parent = mandrake.Root
			MandrakesPos[mandrake] = pos
			mandrake.Goal.GoalAttach.CFrame = CFrame.new(0,-100000,0)
		end
	end

	local AutoMandrake = Library.Toggles.AutoMandrake
	Toggles.AntiMandrakeFE = Groupbox:AddToggle(prefix..'AntiMandrakeFE', {
		Text = 'Anti Mandrake [FE]',
		Default = false,

		Callback = function(value)
			if value then
				toggleNetworkOwner(true)
				if AutoMandrake then
					if AutoMandrake.Value then
						AutoMandrake:SetValue(false)
					end
					AutoMandrake:SetDisabled(true)
				end
				for _, mandrake in CurrentRooms:QueryDescendants("#Mandrake") do
					handleMandrake(mandrake)
				end
				Connections.MandrakeAddedConnection = CurrentRooms.DescendantAdded:Connect(handleMandrake)
				Connections.MandrakeRemovedConnection = CurrentRooms.DescendantRemoving:Connect(function(mandrake)
					if mandrake.Name == "Mandrake" and mandrake:WaitForChild("ModulePrompt", 1) and mandrake:WaitForChild("KilledEvent", 1) and MandrakesVel[mandrake] then
						MandrakesPos[mandrake]:Destroy()
						MandrakesPos[mandrake] = nil
					end
				end)
			else
				toggleNetworkOwner(false)
				if AutoMandrake then
					AutoMandrake:SetDisabled(false)
				end
				if Connections.MandrakeAddedConnection then
					Connections.MandrakeAddedConnection:Disconnect()
					Connections.MandrakeAddedConnection = nil
				end
				if Connections.MandrakeRemovedConnection then
					Connections.MandrakeRemovedConnection:Disconnect()
					Connections.MandrakeRemovedConnection = nil
				end
				for mandrake, pos in MandrakesPos do
					pos:Destroy()
					MandrakesPos[mandrake] = nil
					mandrake.Goal.GoalAttach.CFrame = CFrame.new(0,0,0)
				end
			end
		end
	})

	spoofed = false
	Toggles.AntiGroundskeeper = Groupbox:AddToggle(prefix..'AntiGroundskeeper', {
		Text = 'Anti Groundskeeper',
		Default = false,

		Callback = function(value)
			if value then
				if Toggles.InfiniteCrucifixAlt.Value then
					Toggles.InfiniteCrucifixAlt:SetValue(false)
				end
				if Toggles.CollisionOffsetGodmodeAlt.Value then
					Toggles.CollisionOffsetGodmodeAlt:SetValue(false)
				end
				Connections.AGS = RunService.Heartbeat:Connect(function()
					local Humanoid = Character and Character:FindFirstChild("Humanoid")
					local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
					if Humanoid and HumanoidRootPart and ShouldSpoofGS(Humanoid, HumanoidRootPart) and not killPlayerWF.Disabled then
						if not spoofed and Toggles.AntiTeleport.Value then
							pcall(Toggles.AntiTeleport.Callback, false, true)
						end
						spoofed = true
						HumanoidRootPart.CFrame *= CFrame.new(0, 3, 0)
						RunService.RenderStepped:Wait()
						HumanoidRootPart.CFrame *= CFrame.new(0, -3, 0)
						Camera.CFrame -= Vector3.new(0,3,0)
					else
						spoofed = false
					end
				end)
			else
				if Connections.AGS then
					if spoofed and Toggles.AntiTeleport.Value then
						pcall(Toggles.AntiTeleport.Callback, false, true)
					end
					Connections.AGS:Disconnect()
					Connections.AGS = nil
					spoofed = false
				end
			end
		end
	})

	spoofed2 = false
	Toggles.AntiFigure = Groupbox:AddToggle(prefix..'AntiFigure', {
		Text = 'Anti Figure',
		Default = false,

		Callback = function(value)
			if value then
				if Toggles.InfiniteCrucifixAlt.Value then
					Toggles.InfiniteCrucifixAlt:SetValue(false)
				end
				if Toggles.CollisionOffsetGodmodeAlt.Value then
					Toggles.CollisionOffsetGodmodeAlt:SetValue(false)
				end
				Connections.AFR = RunService.Heartbeat:Connect(function()
					local Humanoid = Character and Character:FindFirstChild("Humanoid")
					local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
					local offset = 9.5-(Toggles.AntiGroundskeeper.Value and ShouldSpoofGS(Humanoid, HumanoidRootPart) and 3 or 0)
					if HumanoidRootPart and ShouldSpoofFR(HumanoidRootPart) and not killPlayerWF.Disabled then
						if not spoofed2 and Toggles.AntiTeleport then
							pcall(Toggles.AntiTeleport.Callback, false, true)
						end
						spoofed2 = true
						HumanoidRootPart.CFrame *= CFrame.new(0, offset, 0)
						RunService.RenderStepped:Wait()
						HumanoidRootPart.CFrame *= CFrame.new(0, -offset, 0)
						Camera.CFrame -= Vector3.new(0,offset,0)
					else
						spoofed2 = false
					end
				end)
			else
				if Connections.AFR then
					if spoofed2 and Toggles.AntiTeleport then
						pcall(Toggles.AntiTeleport.Callback, false, true)
					end
					Connections.AFR:Disconnect()
					Connections.AFR = nil
					spoofed2 = false
				end
			end
		end
	})

	function clearEverything(list: {})
		list = typeof(list) == "table" and list or {}
		for _, val in list do
			if typeof(val) == "table" then
				clearEverything(val)
			elseif typeof(val) == "RBXScriptConnection" then
				pcall(val.Disconnect, val)
			elseif typeof(val) == "Instance" then
				pcall(val.Destroy, val)
			end
			val = nil
		end
	end

	OnUnload(function(wasReloaded)
		for _, toggle in Toggles do
			if toggle.Value then
				pcall(toggle.Callback, false)
			end
		end
		if deathHintConnection then
			deathHintConnection:Disconnect()
			deathHintConnection = nil
		end
		clearEverything(Connections)
		clearEverything(StuffToRemoveLater)
		GlobalIgnoreList = nil
		ScreenGui:Destroy()
		if raknet_hook then
			raknet.remove_send_hook(raknet_hook)
		end
		restoremetamethods()
		--Character:SetAttribute("_MSPAINT_Crouching", nil)
		if admin then
			task.spawn(function()
				clearEverything(ItemsFromAddon)
				task.wait()
				admin.AdminPanel.PanelClient.Enabled = false
				admin.Container.Pages:ClearAllChildren()
				local lol = admin.Container.TabButtons.UIListLayout:Clone()
				admin.Container.TabButtons:ClearAllChildren()
				lol.Parent = admin.Container.TabButtons
				admin.AdminPanel.PanelClient.Enabled = true
				admin = nil
			end)
		end
		print(`[{AddonTitle}]: {wasReloaded and "reloaded" or "unloaded"}!`)
	end)
elseif game.GameId == 6352299542 then
	if game.PlaceId == 18749553947 or game.PlaceId == 121496416407905 then
		local ReplicatedStorage = Services.ReplicatedStorage
		local Players = Services.Players
		local GenerateText = ReplicatedStorage.Remotes.GenerateTextClient

		local function sendmessage(string, type)
			if firesignal then
				if type == "error" then
					firesignal(GenerateText.OnClientEvent, string, "none", Color3.new(1,0.25,0.25))
				end
				if type == "success" then
					firesignal(GenerateText.OnClientEvent, string, "none", Color3.new(0.25,1,0.25))
				end
				if type == "message" then
					firesignal(GenerateText.OnClientEvent, string, "none", "none")
				end
			end
		end

		local CreateServer = Players.LocalPlayer.PlayerGui.MainGui.MainMenuFrames.ServersFrame.CreateServerFrame.MainFrame.CreateButton.r1
		local JoinServer = Players.LocalPlayer.PlayerGui.MainGui.MainMenuFrames.ServersFrame.MainFrame.ClickedOnServerCall
		local args = {}
		local servers = workspace.ServersFolder.MainServersHolder
		local LocalPlayer = Players.LocalPlayer

		-- Default Values
		Mode = "Normal"
		Rooms = "Main Game"
		Difficulty = "Normal"
		MaxPlayers = 4
		Password = ""
		LobbyName = ""
		SelectedPlr = nil

		Groupbox:AddInput(prefix.."mode", {
			Text = "Mode",
			ClearTextOnFocus = true,
			Default = "None",
			Callback = function(val)
				Mode = val
			end
		})

		Groupbox:AddInput(prefix.."rooms", {
			Text = "Rooms",
			ClearTextOnFocus = true,
			Default = "Main Game",
			Callback = function(val)
				Rooms = val
			end
		})

		Groupbox:AddInput(prefix.."diff", {
			Text = "Difficulty",
			ClearTextOnFocus = true,
			Default = "Normal",
			Callback = function(val)
				Difficulty = val
			end
		})

		Groupbox:AddInput(prefix.."players", {
			Text = "Players",
			Default = 4,
			Numeric = true,
			ClearTextOnFocus = true,
			Callback = function(val)
				MaxPlayers = val
			end
		})

		Groupbox:AddInput(prefix.."pass", {
			Text = "Password",
			ClearTextOnFocus = true,
			Callback = function(val)
				Password = val
			end
		})

		Groupbox:AddInput(prefix.."lobbyname", {
			Text = "Lobby Name",
			ClearTextOnFocus = true,
			Callback = function(val)
				LobbyName = val
			end
		})

		local bypassedpatch = false

		Groupbox:AddButton(prefix.."bypassmaxhealthpatch", {
			Text = "Bypass Max Health Patch",
			Tooltip = "You can change max health after you press this button and start game",
			Default = false,
			Func = function()
				if not bypassedpatch then
					bypassedpatch, _ = pcall(function()
						queue_on_teleport('local event = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 60):WaitForChild("EditValueCall", 60) if not event then return end local bypass; bypass = hookmetamethod(game, "__namecall", function(self, ...) local args = {...} if self == event and getnamecallmethod() == "FireServer" and args[1] == "blockmaxhealthfuturechanges" then return end return bypass(self, ...) end) _G.BypassedMaxHealthPatch = true')
					end)
					if bypassedpatch then
						sendmessage("[Bypass Max Health Patch] Patch bypassed", "success")
					else
						sendmessage("[Bypass Max Health Patch] Failed to bypass patch", "error")
					end
				else
					sendmessage("[Bypass Max Health Patch] Patch is already bypassed", "error")
				end
			end
		})

		Groupbox:AddButton(prefix.."createlobby", {
			Text = "Create Lobby",
			Func = function()
				if LobbyName:gsub("%s+") == "" then LobbyName = nil end
				local solo = nil
				local args = {}
				args = {
					Mode = Mode, 
					Room = Rooms, 
					Difficulty = Difficulty, 
					MaxPlayers = tonumber(MaxPlayers)
				}
				if game.PlaceId == 121496416407905 then
					args.RoomName = LobbyName
				elseif game.PlaceId == 18749553947 then
					args.Name = LobbyName
				end
				solo = tonumber(MaxPlayers) <= 1 or Rooms == "Testrooms"
				if Password:gsub("%s+") ~= "" then
					args.Password = Password
				end
				CreateServer:FireServer(args, solo)
				local timestamp = os.clock()
				local server = servers:WaitForChild(LocalPlayer.Name, 5)
				if server then
					sendmessage(`[Create Lobby] Created lobby successfully [ {math.floor((os.clock()-timestamp)*10)/10} sec ]`, "success")
				else
					sendmessage("[Create Lobby] Failed to create a lobby", "error")
				end
			end
		})

		Groupbox:AddDivider()

		Groupbox:AddDropdown(prefix.."selectedplr", {
			SpecialType = 'Player',
			Text = 'Selected Player',
			Default = nil,
			AllowNull = true,
			Multi = false,

			Callback = function(player)
				SelectedPlr = player
			end
		})

		Groupbox:AddButton(prefix.."joinlobby", {
			Text = "Join Player Lobby",
			Func = function()
				if SelectedPlr == nil then sendmessage("[Join Player Lobby] Please select a player", "error") else
					if servers:FindFirstChild(SelectedPlr.Name) then
						if not servers[SelectedPlr.Name].PlayersFolder:FindFirstChild(LocalPlayer.Name) then
							for _,_ in inservers:QueryDescendants(`StringValue[Name = {LocalPlayer.Name}]`) do
								return sendmessage("[Join Player Lobby] You already in a lobby, please leave it if you want to join another one", "error")
							end
							JoinServer:FireServer(SelectedPlr.Name)
							local value = servers[SelectedPlr.Name].PlayersFolder:WaitForChild(LocalPlayer.Name, 3)
							if value then
								sendmessage("[Join Player Lobby] Joined the lobby successfully", "success")
							else
								sendmessage("[Join Player Lobby] Failed to join the lobby", "error")
							end
						else
							sendmessage("[Join Player Lobby] You're already in this lobby", "error")
						end
					else
						sendmessage("[Join Player Lobby] Player didn't created lobby", "error")
					end
				end   
			end
		})

		OnUnload(function(wasReloaded)
			print(`[{AddonTitle}]: {wasReloaded and "reloaded" or "unloaded"}!`)
		end)
	else
		local ReplicatedStorage = Services.ReplicatedStorage
		local Players = Services.Players
		local UserInputService = Services.UserInputService
		local RunService = Services.RunService
		local GenerateText = ReplicatedStorage.Remotes.GenerateTextClient

		local function sendmessage(string, type)
			if type == "error" then
				GenerateText:FireServer(string, "none", Color3.new(1,0.25,0.25))
			end
			if type == "success" then
				GenerateText:FireServer(string, "none", Color3.new(0.25,1,0.25))
			end
			if type == "message" then
				GenerateText:FireServer(string, "none", "none")
			end
		end

		-- Folders
		local ens = workspace.Entities
		local remotes = game.ReplicatedStorage.Remotes

		-- Player + Some Stuff
		local player = Players.LocalPlayer
		local char = player.Character
		local backpack = player.Backpack
		local tpobbycall = remotes.EntityTpObbyCall
		local kys = remotes.KillPlayerCall
		local damagecall = remotes.DamageCall
		local editvalue = remotes.EditValueCall
		local breathingsound = remotes.BreathingSoundCall

		-- Chaos Events
		local events = {}
		for _, event in workspace.GameData.ChaosMode.MainChaosScript:GetChildren() do
			if event:IsA("LocalScript") then
				table.insert(events, event.Name)
			end
		end

		-- Health Manager
		local Health = char.HealthManager

		-- Functions
		local function edithealth(value)
			if remotes:FindFirstChild("EditValueCall") and Health.MaxHealth.Value-Health.Value > 0 then
				editvalue:FireServer("health", (value <= (Health.MaxHealth.Value-Health.Value) and value or Health.MaxHealth.Value-Health.Value))
			end
		end
		local function setmaxhealth(value)
			if remotes:FindFirstChild("EditValueCall") and _G.BypassedMaxHealthPatch then
				editvalue:FireServer("maxhealth", value-Health.MaxHealth.Value)
			end
		end
		local function annoyplayer(player, volume)
			breathingsound:FireServer(0,volume,player)
		end

		-- Check Place
		local PlaceIssue = game.PlaceId == 131662053719761
		local PlaceIssue2 = game.PlaceId == 131662053719761 or game.PlaceId == 126817484851889
		local PlaceIssue3 = game.PlaceId == 126817484851889

		local function deluludelete(instance)
			player.Character.CharacLocalScripts.PlayerInteractObjects.r1:FireServer({
				["maxrange"] = math.huge,
				["hittarget"] = instance,
				["camcframe"] = CFrame.new(0, -1000000, 0)
			})
			player.Character.CharacLocalScripts.PlayerInteractObjects.r1:FireServer({
				["unanchortarget"] = true
			})
		end

		-- Default Values
		local AllPlayers = false
		local SelectedPlayer = player.Name
		local DashBoostValue = 40
		local AccelerationValue = 0.015

		local Acceleration, OldAccelerationValue, OldDashCD, DashBoost, OldDashBoostValue, MaxHealthOld

		Groupbox:AddDivider({
			Text = "HEALTH MANAGER",
			MarginTop = 2,
			MarginBottom = -2
		})

		Toggles.godmode = Groupbox:AddToggle(prefix.."godmode",{
			Text = 'Godmode',
			Default = false,
			DisabledTooltip = reason2,
			Disabled = PlaceIssue,
			Callback = function(value)
				if value then
					kys.Name = "_KillPlayerCall"
					damagecall.Name = "_DamageCall"
					MaxHealthOld = Health.MaxHealth.Value
					setmaxhealth(100000)
					loopheal = RunService.Heartbeat:Connect(function()
						edithealth(1/0)
					end)
				else
					if loopheal then
						loopheal:Disconnect()
					end
					setmaxhealth(MaxHealthOld)
					MaxHealthOld = nil
					kys.Name = "KillPlayerCall"
					damagecall.Name = "DamageCall"
				end
			end
		})

		Toggles.restorehp = Groupbox:AddButton(prefix.."restorehp",{
			Text = 'Restore Health',
			--Tooltip = "Can trigger anticheat, i don't recommend to use it"
			Default = false,
			DisabledTooltip = reason2,
			Disabled = PlaceIssue,
			Func = function()
				edithealth(1/0)
			end
		})

		Groupbox:AddDivider({
			Text = "MOVEMENT",
			MarginTop = 2,
			MarginBottom = -2
		})

		local function bool2Int(bool: boolean): number
			return bool and 1 or 0
		end

		Toggles.nodashcd = Groupbox:AddToggle(prefix.."nodashcd",{
			Text = 'Remove Dash Cooldown',
			Default = false,
			DisabledTooltip = reason,
			Disabled = PlaceIssue or isgetconnectionsmissing,
			Callback = function(value)
				if value then
					OldDashCD = debug.getupvalue(debug.getupvalue(getconnections(char.AttributeChanged)[1].Function, 2), 2)
					debug.setupvalue(debug.getupvalue(getconnections(char.AttributeChanged)[1].Function, 2), 2, 0)
				else
					debug.setupvalue(debug.getupvalue(getconnections(char.AttributeChanged)[1].Function, 2), 2, OldDashCD)
				end
			end
		})

		Toggles.nojumpcd = Groupbox:AddToggle(prefix.."nojumpcd",{
			Text = 'Remove Jump Cooldown',
			Default = false,
			Callback = function(value)
				char.CharacterValues.LowerJumpCooldown.Value = bool2Int(value)
				while Toggles.nojumpcd.Value and task.wait() do
					char.CharacterValues.LowerJumpCooldown.Value = bool2Int(Toggles.nojumpcd.Value)
				end
			end
		})

		Toggles.autokick = Groupbox:AddToggle(prefix.."autokick",{
			Text = 'Auto Kick',
			Default = false,
			DisabledTooltip = reason,
			Disabled = PlaceIssue,
			Callback = function(value)
				editvalue:FireServer("editvalcharacter"..(value and "enable" or "disable"), "AutoKick")
				while Toggles.autokick.Value do
					task.wait()
					if not char.CharacterValues.AutoKick.Value then
						editvalue:FireServer("editvalcharacter"..(Toggles.autokick.Value and "enable" or "disable"), "AutoKick")
					end
				end
			end
		})

		local kickremote = char.MainControls.ScriptsForCall.KickRemote
		local kickFire; kickFire = hookmetamethod(game, "__namecall", function(self, ...)
			if not checkcaller() and self == kickremote and getnamecallmethod() == "FireServer" and Toggles.nokickcd.Value then
				return
			end
			return kickFire(self, ...)
		end)

		Toggles.nokickcd = Groupbox:AddToggle(prefix.."nokickcd",{
			Text = 'Remove Kick Cooldown',
			Default = false,
			Callback = function(value)
				if value then
					nocdkick = UserInputService.InputBegan:Connect(function(input)
						if input.KeyCode == Enum.KeyCode.F then
							if char.WalkspeedManager.Value < 52 then
								kickremote:FireServer(false)
							else
								kickremote:FireServer(true)
							end
						end
					end)
				else
					if nocdkick then
						nocdkick:Disconnect()
					end
				end
			end
		})

		Groupbox:AddDivider({
			Text = "MISC",
			MarginTop = 2,
			MarginBottom = -2
		})

		Toggles.nochaosevents = Groupbox:AddToggle(prefix.."nochaosevents",{
			Text = 'Disable Chaos Events',
			Tooltip = 'Only Client-sided Events',
			DisabledTooltip = reason2,
			Disabled = PlaceIssue2,
			Default = false,
			Callback = function(value)
				if value then
					loopdisablechaos = game.DescendantAdded:Connect(function(descendant)
						if table.find(events, descendant.Name) then
							descendant:Destroy()
						end
					end)
				else
					if loopdisablechaos then
						loopdisablechaos:Disconnect()
					end
				end
			end
		})

	--[[Groupbox:AddButton(prefix.."callvoidtp",{
		Text = 'Call Void Teleport',
		Default = false,
		DisabledTooltip = reason2,
		Disabled = PlaceIssue,
		Func = function()
			if mspaint.ExecutorSupport["firetouchinterest"] then
				firetouchinterest(workspace.RoomsHolder.AntivoidPart.MainAntivoidPart, char.HumanoidRootPart, 0)
				task.delay(0.1, function() firetouchinterest(workspace.RoomsHolder.AntivoidPart.MainAntivoidPart, char.HumanoidRootPart, 1) end)
			else
				char:MoveTo(workspace.RoomsHolder.AntivoidPart.MainAntivoidPart.Position)
			end
		end
	})]]

		KeyPickers.drinkwb = Groupbox:AddLabel('Drink Bottle of Water'):AddKeyPicker(prefix.."drinkwb", {
			Text = "Drink Bottle of Water",
			Default = "MB3",
			Mode = "Press",

			Callback = function()
				editvalue:FireServer("bottleofwateruse")
			end
		})

		Groupbox:AddButton(prefix.."getbadge1",{
			Text = 'Get Badge "UNAWOKEN"',
			DisabledTooltip = reason,
			Disabled = queueteleportmissing,
			Func = function()
				Services.TeleportService:Teleport(105262163721105, player)
				QueueTeleport([[
            if not game.Loaded then
                game.Loaded:Wait()
            end
            local badge = game:GetService("BadgeService"):CheckUserBadgesAsync(game.Players.LocalPlayer.UserId, {1289197938381069})
            if #badge == 1 then
                game.Players.LocalPlayer:Kick("you already have this badge")
            end
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("badgecall"):FireServer()
            print("Getting Badge...")
            wait(3)
            game.Players.LocalPlayer:Kick("aaaa badge")
        ]])
			end
		})

		Groupbox:AddButton(prefix.."getbadge2",{
			Text = 'Get Badge "PLACE"',
			DisabledTooltip = reason,
			Disabled = queueteleportmissing,
			Func = function()
				Services.TeleportService:Teleport(98402192137325, player)
				QueueTeleport([[
            if not game.Loaded then
                game.Loaded:Wait()
            end
            local badge = game:GetService("BadgeService"):CheckUserBadgesAsync(game.Players.LocalPlayer.UserId, {1624501183928838})
            if #badge == 1 then
                game.Players.LocalPlayer:kick("you already have this badge")
            end
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("badgecall"):FireServer()
            print("Getting Badge...")
            wait(3)
            game.Players.LocalPlayer:kick("aaaa badge")
        ]])
			end
		})

		Groupbox:AddButton(prefix.."deleteobjects",{
			Text = 'Delete Objects',
			Func = function()
				for i,v in workspace:QueryDescendants("#DeskChair, #PottedPlant, #TableLamp, #DeskChair, #MetalShelf, #PapersAsset, #metalfence") do
					deluludelete(v)
				end
			end
		})

		Groupbox:AddDivider({
			Text = "TROLL",
			MarginTop = 2,
			MarginBottom = -2
		})

		Groupbox:AddDropdown(prefix.."players",{
			SpecialType = 'Player',
			Text = 'Selected Player',
			Default = game.Players.LocalPlayer.Name,
			AllowNull = true,
			Multi = false,
			DisabledTooltip = reason2,
			Disabled = PlaceIssue3,
			Callback = function(value)
				player.PlayerGui.SpectateGui.MainSpectateScript.r1:FireServer(value.Name)
				SelectedPlayer = value.Name
			end
		})

		Toggles.annoyplayer = Groupbox:AddToggle(prefix.."annoyplayer",{
			Text = "Annoy Player",
			Tooltip = "Makes breathing sounds from a player (only 1 player)",
			Default = false,
			DisabledTooltip = reason2,
			Disabled = PlaceIssue3,
			Callback = function(value)
				if value then
					AnnoyPlayer = SelectedPlayer
					loopannoy = RunService.RenderStepped:Connect(function()
						annoyplayer(SelectedPlayer,10)
						if SelectedPlayer ~= AnnoyPlayer then
							annoyplayer(AnnoyPlayer,0)
							AnnoyPlayer = SelectedPlayer
						end
					end)
				else
					if loopannoy then
						loopannoy:Disconnect()
						annoyplayer(AnnoyPlayer,0)
						AnnoyPlayer = nil
					end
				end
			end
		})

		Groupbox:AddDivider({
			Text = "ANTI ENTITIES",
			MarginTop = 2,
			MarginBottom = -2
		})

		local tpobbyfire; tpobbyfire = hookmetamethod(game, "__namecall", function(self, ...)
			if self == tpobbycall and getnamecallmethod() == "FireServer" and Toggles.antihand then
				return
			end
			return tpobbyfire(self, ...)
		end)

		Toggles.antihand = Groupbox:AddToggle(prefix.."antihand",{
			Text = 'Anti Hand (EN-009) Obby',
			Tooltip = "Removes obby but not him",
			Default = false,
			DisabledTooltip = reason2,
			Disabled = PlaceIssue
		})

		Toggles.antidelmon = Groupbox:AddToggle(prefix.."antidelmon",{
			Text = 'Anti Delmon Crystals (EN-019)',
			Default = false,
			DisabledTooltip = reason2,
			Disabled = PlaceIssue,
			Callback = function(value)
				if value then
					for i,v in workspace:GetChildren() do
						if v.Name == "GlassSpikeStructureSpawnIndicator" or v.Name == "GlassSpikeStructure" then
							v:Destroy()
						end
					end
					local loopantien019; loopantien019 = workspace.ChildAdded:Connect(function()
						if v.Name == "GlassSpikeStructureSpawnIndicator" or v.Name == "GlassSpikeStructure" then
							v:Destroy()
						end
					end)
				else
					if loopantien019 then
						loopantien019:Disconnect()
					end
				end
			end
		})

		Toggles.antistalker = Groupbox:AddToggle(prefix.."antistalker",{
			Text = 'Anti Stalker (EN-016, EN-016-02)',
			Default = false,
			Callback = function(value)
				if value then
					local loopantistalker; loopantistalker = ens.OtherEntities.ChildAdded:Connect(function(child)
						if child.Name == "StalkerEntityAlreadyAttacked" then
							task.spawn(function()
								if Lighting:WaitForChild("ColorCorrection", 3) then
									Lighting.ColorCorrection:Destroy()
								end
								if Lighting:FindFirstChild("ColCorrectionType2Stalker", 3) then
									Lighting.ColCorrectionType2Stalker:Destroy()
								end
							end)
							char:WaitForChild("StalkerType2ScreenShake", 60):Destroy()
							char:WaitForChild("EntityLocalScript", 60):Destroy()
							child:Destroy()
						end
					end)
				else
					if loopantistalker then
						loopantistalker:Disconnect()
					end
				end
			end
		})

		Toggles.antiunknown = Groupbox:AddToggle(prefix.."antiunknown",{
			Text = 'Anti EN-013',
			Default = false,
			DisabledTooltip = reason2,
			Disabled = PlaceIssue,
			Callback = function(value)
				if value then
					local loopantien013; loopantien013 = ens.Rushers.ChildAdded:Connect(function(child)
						if child.Name == "UnknownEntityAlreadyAttacked" then
							char:WaitForChild("EntityLocalScript", 60):Destroy()
							child:Destroy()
						end
					end)
				else
					if loopantien013 then
						loopantien013:Disconnect()
					end
				end
			end
		})

		Toggles.antidelusion = Groupbox:AddToggle(prefix.."antidelusion",{
			Text = 'Anti Delusion (EN-011)',
			Default = false,
			Callback = function(value)
				if value then
					local loopantidelusion; loopantidelusion = ens.ClientEntities.ChildAdded:Connect(function(child)
						if child.Name == "ShadowEntity" then
							child:Destroy()
						end
					end)
				else
					if loopantidelusion then
						loopantidelusion:Disconnect()
					end
				end
			end
		})

		sendmessage("@tplaygd: just let you know that the addon is loaded", "message")

		OnUnload(function(wasReloaded)
			for _, toggle in Toggles do
				if toggle.Value then
					pcall(toggle.Callback, false)
				end
			end
			restoremetamethods()
			print(`[{AddonTitle}]: {wasReloaded and "reloaded" or "unloaded"}!`)
		end)
	end
else
	Groupbox:AddLabel(`<font color="#f00">Game is not supported</font>\n\n{AddonTitle} supports these games:\n\nDoors (Lobby & Game),\nDelusional Office (Lobby & Game, Recommend to use in testplace)\n\n`, true)
end

Groupbox:AddDivider({
	Text = "MOST IMPORTANT FEATURE",
	MarginTop = 2,
	MarginBottom = -2
})

Groupbox:AddButton(prefix.."FunnyButton", {
	Text = "Don't press this button...",
	Func = function()
		local ScreenGui = Instance.new("ScreenGui", gethui())
		ScreenGui.IgnoreGuiInset = true
		ScreenGui.DisplayOrder = 2147483647

		local TextBox = Instance.new("TextBox", ScreenGui)
		TextBox.Size = UDim2.new(1,0,1,0)
		TextBox.TextEditable = false
		TextBox.ClearTextOnFocus = false
		TextBox.BackgroundColor3 = Color3.new()
		TextBox.TextColor3 = Color3.new(1,1,1)
		TextBox.FontFace = Font.fromEnum(Enum.Font.Code)
		TextBox.TextSize = 14
		TextBox.ZIndex = 2147483647
		TextBox.Text = [[                                            ::::::::::::::                                             :::::::::::                                    
                                      -:::::::::::::::-----::::                                  ::::::::::::::::::::::                               
                                    ::::::::::::::::::------::::::                            :::::::::::::::::::::::::::                             
                                  ::::::::::::::::::::------::::::::                        :::::::::::::::::::::::::::::::                           
                                ::::::::::::::::::::::::---::::::::::                      :::::::::::::::::::::::::::::::::                          
                               ::::::::::::::::                   ::                       :::::               ::::::::::::::                         
                             ::::::::::::::                                                                       :-:-::::::::                        
                            :::::::::::-                                                                             ---:::::::                       
                           :::::::----                                                                                -----::::-                      
                          :::::::---                                                                                    -----::-:                     
                          ::::::::                                                                                       :-------                     
                         ::::::::                             %#%%%%%%%%%%%%%%%%%%%%%%                                     ------:                    
                        :::::::                      %%%%###############################%#%%%%%#                            ------:                   
                       :::::::                 %%%################################################%%%%                        -----                   
                       -::::              ##############################################################%%#                    -----                  
                       ---:           #######################################################################%#                 ----                  
                                   #############################################################################%%               ---                  
                               #%####################################################################################                                 
                            #%#########################################################################################%                              
                          #################################################################################################                           
                       ######################################################################################################                         
                     ###########%%%%%%%%%%%%%%#######################################################%%%%%%%%%%%%%%%%%#########                       
                   #######%%%@@@@%@@@@@@@@@@%%%@@@%##*####################%%%%%%#################%@@@@@@@@@@@@@@@@%%%%@@%%%######                     
                 ######%%%%%%%%%%%%%%%@@@@%%%%%%%%%%@@%**#####################################@@@@@@@@@@@@@%%%%%%%%%%%%@@@@@%%#####                   
                #####%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@#*################################%@@@@@@@@@@@%%@%%%%%%%%%%%%%%%%%@@@@@%####                 
              #####%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@#*############################%@@@@@@@%%%%%%%@%%%%%%%%%%%%%%%%%%%%@@@@@#####               
            #####%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@**########################%@@%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%@@@@%####              
           #####%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@@#*######################@%%%%%%%%%%%%%@@@@@@@@@@@@@@%%%%%%%%%%%%%%@@@@@%####            
          #####%%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@%**###################@%%%%%%%%%%%@@@@%+---:::::--=#%@%%%%%%%%%%%%%%@@@%####           
         #####%%%%%%%%%%%%%%%%%%%%%%%@@@#=-::::::::::-#@@@@@@@@@%**#################%%%%%%%%%%%@@#-:::::::::::::::::-#@@%%%%%%%%%%%%%@@%*###          
       ###*##%%%%%%%%%%%%%%%%%%%%%%@@*-:::::::::::::::::+@@@@@@@@%**###############%%%%%%%%%%@@*:::::::::::::::::--====#@@%%%%%%%%%%%%%@#*###         
      ####*#%%%%%%%%%%%%%%%%%%%%%%@*::::::::::::::::::-==-*@@@@@@@#*##############%%%%%%%%%%@%-:::::::::::::::::=++====-+%@%%%%%%%%%%%%@%#*###        
     ####*##%%%%%%%%%%%%%%%%%%%%%%-:::::::::::::::::=++===-=@@@@@@%**#############%%%%%%%%%%*::::::::::::::::::-+++====--+@@%%%%%%%%%%%%@#**###       
     ####*#%%%%%%%%%%%%%%%%%%%%%#::::::::::::::::::-++====---%@@@@@**###########*%%%%%%%%%%#::::::::::::::::::::++=====---%@%%%%%%%%%%%%@%**####      
    ####**#%%%%%%%%%%%%%%%%%%%%#:::::::::::::::::::-++====---=@@@@@#*############%%%%%%%%%%::::::::::::::::::::::-====----*@%%%%%%%%%%%%%%#*#####     
   #####**#%%%%%%%%%%%%%%%%%%%%:::::::::::::::::::::-++===----@@@@@%*############%%%%%%%%%#:::::::::::::::::::::::::::::::+@%%%%%%%%%%%%%%#*######    
  #####***#%%%%%%%%%%%%%%%%%%%*:::::::::::::::::::::::-==---::%@@%%%**###########%%%%%%%%%#:::::::::::::::::::::::::::::::%@%%%%%%%%%%%%%@#*######    
  #####***#%%%%%%%%%%%%%%%%%%%*:::::::::::::::::::::::::::::::@@@%%%**#########*#%%%%%%%%%%::::::::::::::::::::::::::::::+@%%%%%%%%%%%%%%@#*#######   
 ######***#%%%%%%%%%%%%%%%%%%%#::::::::::::::::::::::::::::::=@@@%@#**#########*#%%%%%%%%%%#::::::::::::::::::::::::::::#@%%%%%%%%%%%%%%%%**#######   
 ######****%%%%%%%%%%%%%%%%%%%%-:::::::::::::::::::::::::::::%@@%%@**###########*%%%%%%%%%#%*:::::::::::::::::::::::::-%@%%%%%%%%%%%%%%%@#**########  
 ######***+%%%%%%%%%%%%%%%%%%%%#:::::::::::::::::::::::::::-%@@%%@%+*###########*#%%%%%%%%##%#=:::::::::::::::::::::-%%%%%%%%%%%%%%%%%%%%**#########  
#######***+*%%%%%%%%%%%%%%%%%%%%#:::::::::::::::::::::::::=%@@%@@@***###########**%%%%%%%%####%%*=:::::::::::::::-*%%%%%%%%%%%%%%%%%%%%@***#########  
#######****+#%%%%%%%%%%%%%%%%%%%%%=:::::::::::::::::::::-#@@%%%@@#+*#############**%%%%%%%%######%%%*=-------=*%%%%%%%%%%%%%%%%%%%%%%%@***########### 
######******+#%%%%%%%%%%%%%%%%%%%%%%*:::::::::::::::::-%@%%%%%%@#+**##############**%%%%%%%%%#######%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%***############ 
#####********+#%%%%%%%%%%%%%%%%%%%%%%%%#-::::::::::+%@%%%%%%%%@#+**###############**+%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%+**############# 
#####*********++%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@*+**##################*+#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@*+**############## 
####***********++#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%+**#####################**+%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@*+**################ 
####*************+=#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%++**########################*+=#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%++**################## 
###****************+=#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%=+**############################*+=*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@#++**#################### 
*#*******************+=+%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%+=+**################################**+=*#%%%%%%%%%%%%%%%%%%%%%%%%*+++**###################### 
#**********************++=+#%%%%%%%%%%%%%%%%%%%%%%#+=++**#####################################**++=+*##%%%%%%%%%%%%#*+=++***######################### 
***************************++==+**###########*+-=+++***###########################################****+++++++++++++++*****+=----+###################  
 #******************************+++++++++++++++*****######################################################*********#####-:::::::::-#################  
 ##**************************************************##################################################################+:::=:::::::-################  
 ##***************************************************#####################################################################-:::-+:::*##############   
  ##****************************************************#################################################################+::::=####################   
  *#*********************************************************##########################################################=:::::*####################    
   *##************************************************************##################################################+::::::*#####################     
    ##***************************************************************############################################*-:::::=########################     
     ##*******************************************************************####################################+-:::::=*#########################      
      ##********************++*****************************************************#######################*=::::::=############################       
       ##*******************+-::-=+*****************************************************##############*-::::::-*##############################        
        ##********************+=-::::-=+**************************************************#######*-::::::::+#################################         
         ##***********************+=-::::::=+*****************************************######+:::::::::-#####****############################          
          ##**************************+=-::::::::-=+**************************######*+-:::::::::::+*##***********##########################           
           ####***************************+=-:::::::::::::::::--------------::::::::::::::::=+*##*****************#######################             
             ###********************************+=-::::::::::::::::::::::::::::::::::=+****************************#####################              
              ####***************************************++++++===========+++++*************************************##################                
                ####************************************************************************************************#################                 
                  ####*************************************************************************************************############                   
                   #####************************************************************************************************#########                     
                      ####***********************************************************************************************######                       
                        ###**********************************************************************************************####                         
                          ####*****************************************************************************************####                           
                             ######**********************************************************************************###                              
                                #######***************************************************************************###                                 
                                   ########********************************************************************##*                                    
                                       #######**************************************************************##                                        
                                           #########***************************************************#**                                            
                                                ###########***************************************##*                                                 
                                                      ###############*************###########*                                                        
                                                                  ####***********#                                                                    ]]
		game['Run Service']:SetRobloxGuiFocused(true)
		game.Debris:AddItem(ScreenGui, 4)
		task.wait(4)
		game['Run Service']:SetRobloxGuiFocused(false)
	end
})
