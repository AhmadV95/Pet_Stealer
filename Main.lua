local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local targetPlayer = nil
local followConnection = nil

-- Main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Minimize Icon
local minimizeIcon = Instance.new("TextButton")
minimizeIcon.Size = UDim2.new(0, 50, 0, 50)
minimizeIcon.Position = UDim2.new(0, 20, 0, 200)
minimizeIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
minimizeIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeIcon.Font = Enum.Font.GothamBold
minimizeIcon.TextScaled = true
minimizeIcon.Text = "T"
minimizeIcon.Visible = false
minimizeIcon.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 8)
iconCorner.Parent = minimizeIcon

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Close (X) Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "X"
closeButton.TextScaled = true
closeButton.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

-- Resize Handle
local resizeHandle = Instance.new("Frame")
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -20, 1, -20)
resizeHandle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
resizeHandle.BorderSizePixel = 0
resizeHandle.Active = true
resizeHandle.Parent = frame

local resizeCorner = Instance.new("UICorner")
resizeCorner.CornerRadius = UDim.new(0, 5)
resizeCorner.Parent = resizeHandle

-- Drag-to-resize
resizeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local startPos = UserInputService:GetMouseLocation()
		local startSize = frame.Size
		local moveConn, releaseConn

		moveConn = UserInputService.InputChanged:Connect(function(moveInput)
			if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = UserInputService:GetMouseLocation() - startPos
				frame.Size = UDim2.new(
					startSize.X.Scale, math.max(250, startSize.X.Offset + delta.X),
					startSize.Y.Scale, math.max(250, startSize.Y.Offset + delta.Y)
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
title.Text = "Select Player"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = frame

-- Dropdown Player Button
local dropdownButton = Instance.new("TextButton")
dropdownButton.Size = UDim2.new(1, -20, 0, 40)
dropdownButton.Position = UDim2.new(0, 10, 0, 50)
dropdownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdownButton.Font = Enum.Font.Gotham
dropdownButton.TextSize = 18
dropdownButton.Text = "Select Player ▼"
dropdownButton.Parent = frame

local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 5)
dropdownCorner.Parent = dropdownButton

-- Dropdown Player List
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, -20, 0, 0)
dropdownFrame.Position = UDim2.new(0, 10, 0, 90)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.Visible = false
dropdownFrame.Parent = frame

local dropdownFrameCorner = Instance.new("UICorner")
dropdownFrameCorner.CornerRadius = UDim.new(0, 5)
dropdownFrameCorner.Parent = dropdownFrame

-- Avatar
local avatarImage = Instance.new("ImageLabel")
avatarImage.Size = UDim2.new(0, 100, 0, 100)
avatarImage.Position = UDim2.new(0.5, -50, 0, 150)
avatarImage.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
avatarImage.Parent = frame

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(0, 8)
avatarCorner.Parent = avatarImage

-- Teleport Button
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(1, -20, 0, 40)
teleportButton.Position = UDim2.new(0, 10, 0, 270)
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextScaled = true
teleportButton.Text = "Teleport"
teleportButton.Parent = frame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 5)
teleportCorner.Parent = teleportButton

-- Turn Off Button
local turnOffButton = Instance.new("TextButton")
turnOffButton.Size = UDim2.new(1, -20, 0, 40)
turnOffButton.Position = UDim2.new(0, 10, 0, 320)
turnOffButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
turnOffButton.TextColor3 = Color3.fromRGB(255, 255, 255)
turnOffButton.Font = Enum.Font.GothamBold
turnOffButton.TextScaled = true
turnOffButton.Text = "Turn Off"
turnOffButton.Parent = frame

local turnOffCorner = Instance.new("UICorner")
turnOffCorner.CornerRadius = UDim.new(0, 5)
turnOffCorner.Parent = turnOffButton

-- Update Player List
local function updatePlayerList()
	dropdownFrame:ClearAllChildren()
	local y = 0
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 30)
			btn.Position = UDim2.new(0, 0, 0, y)
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 16
			btn.Text = plr.Name
			btn.Parent = dropdownFrame

			btn.MouseButton1Click:Connect(function()
				targetPlayer = plr
				dropdownButton.Text = plr.Name .. " ▼"
				local content, isReady = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
				if isReady then avatarImage.Image = content end
				dropdownFrame.Visible = false
			end)

			y += 30
		end
	end
	dropdownFrame.Size = UDim2.new(1, -20, 0, y)
end

-- Toggle Dropdown
dropdownButton.MouseButton1Click:Connect(function()
	dropdownFrame.Visible = not dropdownFrame.Visible
end)

-- Refresh list every 5 sec
task.spawn(function()
	while true do
		updatePlayerList()
		task.wait(5)
	end
end)

-- Teleport + Follow
teleportButton.MouseButton1Click:Connect(function()
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local myChar = player.Character or player.CharacterAdded:Wait()
		local hrp = myChar:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
		end

		if followConnection then followConnection:Disconnect() end
		followConnection = RunService.Heartbeat:Connect(function()
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

-- Minimize
closeButton.MouseButton1Click:Connect(function()
	frame.Visible = false
	minimizeIcon.Visible = true
end)

-- Restore from Minimize
minimizeIcon.MouseButton1Click:Connect(function()
	frame.Visible = true
	minimizeIcon.Visible = false
end)

-- Initial
updatePlayerList()
