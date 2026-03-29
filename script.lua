local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local onenabledshotho = false

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

-- Botón principal (Frame) con borde y glow
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(0, 140, 0, 55)
buttonFrame.Position = UDim2.new(0.1, 0, 0.7, 0)
buttonFrame.BackgroundTransparency = 0
buttonFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
buttonFrame.Parent = screenGui

-- 🔹 Borde negro y esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = buttonFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 0, 0)
stroke.Thickness = 2
stroke.Parent = buttonFrame

-- 🔹 Glow más grande
local glow = Instance.new("UIStroke")
glow.Color = Color3.fromRGB(255, 255, 255)
glow.Thickness = 6  -- más grande
glow.Transparency = 0.7 -- menos transparente para resaltar
glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
glow.Parent = buttonFrame

-- 🔹 Frame interno para la imagen de fondo
local imgFrame = Instance.new("Frame")
imgFrame.Size = UDim2.new(1, -8, 1, -8) -- deja espacio para borde
imgFrame.Position = UDim2.new(0, 4, 0, 4)
imgFrame.BackgroundTransparency = 1
imgFrame.Parent = buttonFrame

local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundTransparency = 1
bg.Image = "rbxassetid://97814938166007"
bg.Parent = imgFrame

-- 🔹 Overlay verde al activar
local greenOverlay = Instance.new("Frame")
greenOverlay.Size = UDim2.new(1, -8, 1, -8)
greenOverlay.Position = UDim2.new(0, 4, 0, 4)
greenOverlay.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
greenOverlay.BackgroundTransparency = 0.88
greenOverlay.Visible = false
greenOverlay.ZIndex = 2
greenOverlay.Parent = buttonFrame

-- 🔹 Texto principal “Rivals” con outline
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.6, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Rivals"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.ZIndex = 3
title.Parent = buttonFrame

local titleOutline = Instance.new("UIStroke")
titleOutline.Color = Color3.new(0, 0, 0) -- contorno negro
titleOutline.Thickness = 2
titleOutline.Parent = title

-- 🔹 Subtexto “one shot” con outline
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0.4, 0)
subtitle.Position = UDim2.new(0, 0, 0.6, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "one shot"
subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitle.Font = Enum.Font.Gotham
subtitle.TextScaled = true
subtitle.ZIndex = 3
subtitle.Parent = buttonFrame

local subtitleOutline = Instance.new("UIStroke")
subtitleOutline.Color = Color3.new(0, 0, 0)
subtitleOutline.Thickness = 1.5
subtitleOutline.Parent = subtitle

-- 🔹 Clickable
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, 0, 1, 0)
button.BackgroundTransparency = 1
button.Text = ""
button.Parent = buttonFrame

-- Toggle (misma lógica)
button.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    onenabledshotho = not onenabledshotho

    -- Mostrar overlay verde si está activado
    greenOverlay.Visible = onenabledshotho

    if onenabledshotho then
        task.spawn(function()
            while onenabledshotho do
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    if humanoid.MaxHealth > 0 and (humanoid.Health / humanoid.MaxHealth) <= 0.2 then
                        onenabledshotho = false
                        greenOverlay.Visible = false
                        break
                    end
                end

                local pos = hrp.Position
                hrp.CFrame = CFrame.new(pos.X, pos.Y - 795679695796326795679695796326, pos.Z)
                task.wait(0.01)
            end
        end)
    end
end)

-- DRAG SYSTEM
local dragging = false
local dragStart
local startPos

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = buttonFrame.Position
    end
end)

button.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        buttonFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
