local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local targetPlayer = nil
local followConnection = nil

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Text = "Search Player"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = frame

-- Username Input
local usernameBox = Instance.new("TextBox")
usernameBox.PlaceholderText = "Type name..."
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
avatarImage.Size = UDim2.new(0, 100, 0, 100)
avatarImage.Position = UDim2.new(0.5, -50, 0, 100)
avatarImage.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
avatarImage.Parent = frame

-- Teleport Button
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(1, -20, 0, 40)
teleportButton.Position = UDim2.new(0, 10, 0, 220)
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextScaled = true
teleportButton.Text = "Teleport"
teleportButton.Parent = frame

-- Turn Off Button
local turnOffButton = Instance.new("TextButton")
turnOffButton.Size = UDim2.new(1, -20, 0, 40)
turnOffButton.Position = UDim2.new(0, 10, 0, 270)
turnOffButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
turnOffButton.TextColor3 = Color3.fromRGB(255, 255, 255)
turnOffButton.Font = Enum.Font.GothamBold
turnOffButton.TextScaled = true
turnOffButton.Text = "Turn Off"
turnOffButton.Parent = frame

-- Function: Update Avatar & Select Player
local function updateAvatar(name)
	targetPlayer = nil
	avatarImage.Image = ""
	if name == "" then return end
	
	for _, plr in ipairs(Players:GetPlayers()) do
		if string.lower(plr.Name):find(string.lower(name)) then
			targetPlayer = plr
			local thumbType = Enum.ThumbnailType.HeadShot
			local thumbSize = Enum.ThumbnailSize.Size100x100
			local content, isReady = Players:GetUserThumbnailAsync(plr.UserId, thumbType, thumbSize)
			if isReady then
				avatarImage.Image = content
			end
			break
		end
	end
end

-- When username is entered
usernameBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		updateAvatar(usernameBox.Text)
	end
end)

-- Teleport + Follow
teleportButton.MouseButton1Click:Connect(function()
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local myChar = player.Character or player.CharacterAdded:Wait()
		local hrp = myChar:FindFirstChild("HumanoidRootPart")
		if hrp then
			-- Teleport
			hrp.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
		end
		
		-- Follow
		if followConnection then followConnection:Disconnect() end
		followConnection = game:GetService("RunService").Heartbeat:Connect(function()
			if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
				end
			end
		end)
	end
end)

-- Turn Off
turnOffButton.MouseButton1Click:Connect(function()
	if followConnection then
		followConnection:Disconnect()
		followConnection = nil
	end
end)
