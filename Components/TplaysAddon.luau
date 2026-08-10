-- Tplay's Addon compatibility layer for Abysall.
--
-- This module intentionally contains only local, visual, and diagnostic
-- utilities. It does not hook metamethods, fire game remotes, change
-- character physics, bypass entities, or alter server-side game state.

return function(Context)
	local Window = Context.Window
	local Library = Context.Library
	local Services = Context.Services
	local CurrentRooms = Context.CurrentRooms
	local LocalPlayer = Context.LocalPlayer

	local Tab = Context.Tab or Window:AddTab("Tplay's Addon", "layers")
	local StatusBox = Tab:AddLeftGroupbox("Addon status")
	local VisualBox = Tab:AddRightGroupbox("Visual diagnostics")

	local watchedGroundskeepers = {}
	local pathfindNodes = {}
	local originalTransparency = {}
	local figureHighlights = {}
	local addonConnections = {}
	local notifyGroundskeeper
	local showPathfindNodes
	local highlightFigures
	local lastStatusUpdate = 0

	local function disconnect(Connection)
		if Connection then
			pcall(function()
				Connection:Disconnect()
			end)
		end
	end

	local function addConnection(Name, Connection)
		addonConnections[Name] = Connection
		return Connection
	end

	local function notifyGroundskeeperTaunt(Child)
		if not notifyGroundskeeper or not notifyGroundskeeper.Value then
			return
		end

		if Child.Name:sub(1, 7) == "gkgrunt" then
			Library:Notify({
				Title = "Tplay's Addon [Groundskeeper]",
				Description = "The Groundskeeper finished a taunt.",
				Time = 3
			})
		end
	end

	local function watchGroundskeeper(Object)
		if Object.Name ~= "Groundskeeper" or watchedGroundskeepers[Object] then
			return
		end

		local Head = Object:FindFirstChild("Head") or Object:WaitForChild("Head", 5)
		if not Head then
			return
		end

		watchedGroundskeepers[Object] = addConnection(
			"Groundskeeper_" .. Object:GetDebugId(),
			Head.ChildAdded:Connect(notifyGroundskeeperTaunt)
		)
	end

	local function setPathfindFolder(Folder, Enabled)
		for _, Node in Folder:GetChildren() do
			if Node:IsA("BasePart") then
				if Enabled then
					if originalTransparency[Node] == nil then
						originalTransparency[Node] = Node.Transparency
					end
					pathfindNodes[Node] = true
					Node.Transparency = 0.5
				elseif originalTransparency[Node] ~= nil then
					Node.Transparency = originalTransparency[Node]
				end
			end
		end
	end

	local function setFigureHighlight(Figure, Enabled)
		if Figure.Name ~= "FigureRig" then
			return
		end

		if Enabled then
			if figureHighlights[Figure] then
				return
			end

			local Highlight = Instance.new("Highlight")
			Highlight.Name = "TplaysAddonFigureHighlight"
			Highlight.Adornee = Figure
			Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			Highlight.FillColor = Color3.fromRGB(178, 88, 255)
			Highlight.FillTransparency = 0.72
			Highlight.OutlineColor = Color3.fromRGB(235, 210, 255)
			Highlight.OutlineTransparency = 0.1
			Highlight.Parent = Figure
			figureHighlights[Figure] = Highlight
		elseif figureHighlights[Figure] then
			figureHighlights[Figure]:Destroy()
			figureHighlights[Figure] = nil
		end
	end

	local function refreshPathfindNodes()
		for _, Object in CurrentRooms:GetDescendants() do
			if Object.Name == "PathfindNodes" then
				setPathfindFolder(Object, showPathfindNodes.Value)
			end
		end
	end

	local function refreshFigureHighlights()
		for _, Object in CurrentRooms:GetDescendants() do
			if Object.Name == "FigureRig" then
				setFigureHighlight(Object, highlightFigures.Value)
			end
		end
	end

	StatusBox:AddLabel("Safe local port of selected Tplay's Addon utilities.")
	StatusBox:AddLabel("Server remotes and anti-cheat manipulation are not included.")
	local roomStatus = StatusBox:AddLabel("Current room: unknown")

	local function updateStatus(Force)
		if not Force and os.clock() - lastStatusUpdate < 1 then
			return
		end

		lastStatusUpdate = os.clock()
		local Room = LocalPlayer:GetAttribute("CurrentRoom")
		local Groundkeepers = 0
		local Figures = 0

		for Object in watchedGroundskeepers do
			if Object and Object:IsDescendantOf(CurrentRooms) then
				Groundkeepers += 1
			end
		end

		for Object in figureHighlights do
			if Object and Object:IsDescendantOf(CurrentRooms) then
				Figures += 1
			end
		end

		roomStatus:SetText(
			("Current room: %s | Groundskeepers tracked: %d | Figure rigs highlighted: %d"):format(
				tostring(Room or "unknown"),
				Groundkeepers,
				Figures
			)
		)
	end

	notifyGroundskeeper = StatusBox:AddToggle("TplaysNotifyGroundskeeper", {
		Text = "Groundskeeper notifications",
		Default = false,
		Tooltip = "Shows a local notification when a tracked Groundskeeper taunts."
	})

	showPathfindNodes = VisualBox:AddToggle("TplaysShowPathfindNodes", {
		Text = "Show pathfind nodes",
		Default = false,
		Tooltip = "Makes the game's existing pathfind nodes visible locally."
	})

	highlightFigures = VisualBox:AddToggle("TplaysHighlightFigure", {
		Text = "Highlight Figure rigs",
		Default = false,
		Tooltip = "Adds a local visual highlight to Figure rigs."
	})

	VisualBox:AddButton({
		Text = "Refresh diagnostics",
		Func = function()
			refreshPathfindNodes()
			refreshFigureHighlights()
			updateStatus()
			Library:Notify({
				Title = "Tplay's Addon",
				Description = "Local diagnostics refreshed.",
				Time = 2
			})
		end
	})

	notifyGroundskeeper:OnChanged(function()
		updateStatus(true)
	end)
	showPathfindNodes:OnChanged(function(Value)
		for _, Object in CurrentRooms:GetDescendants() do
			if Object.Name == "PathfindNodes" then
				setPathfindFolder(Object, Value)
			end
		end
		updateStatus(true)
	end)
	highlightFigures:OnChanged(function(Value)
		for _, Object in CurrentRooms:GetDescendants() do
			if Object.Name == "FigureRig" then
				setFigureHighlight(Object, Value)
			end
		end
		updateStatus(true)
	end)

	for _, Object in CurrentRooms:GetDescendants() do
		watchGroundskeeper(Object)
	end

	addConnection("TplaysRoomDescendantAdded", CurrentRooms.DescendantAdded:Connect(function(Object)
		if Object.Name == "Groundskeeper" then
			task.defer(watchGroundskeeper, Object)
		elseif Object.Name == "PathfindNodes" and showPathfindNodes.Value then
			task.defer(setPathfindFolder, Object, true)
		elseif Object.Name == "FigureRig" and highlightFigures.Value then
			task.defer(setFigureHighlight, Object, true)
		end
	end))

	addConnection("TplaysRoomChanged", LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
		updateStatus(true)
	end))
	addConnection("TplaysStatusUpdate", Services.RunService.Heartbeat:Connect(function()
		updateStatus(false)
	end))

	Library:OnUnload(function()
		for _, Connection in addonConnections do
			disconnect(Connection)
		end

		for Node, Transparency in originalTransparency do
			if Node and Node.Parent then
				Node.Transparency = Transparency
			end
		end

		for _, Highlight in figureHighlights do
			if Highlight then
				Highlight:Destroy()
			end
		end

		table.clear(watchedGroundskeepers)
		table.clear(pathfindNodes)
		table.clear(originalTransparency)
		table.clear(figureHighlights)
		table.clear(addonConnections)
	end)

	updateStatus()
	return Tab
end