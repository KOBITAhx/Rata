-- Servicios de Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera
local SpectatingPlayer = nil
local IsSpectating = false

-- Creación del Hub
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0.3, 0, 0.3, 0) -- Tamaño pequeño
Frame.Position = UDim2.new(0.35, 0, 0.35, 0) -- Centrado en la pantalla
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Parent = ScreenGui

-- Título del Hub
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "Selecciona un Jugador para Espectar"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = Frame

-- Lista de jugadores
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, 0, 0.8, 0)
PlayerList.Position = UDim2.new(0, 0, 0.2, 0)
PlayerList.BackgroundTransparency = 1
PlayerList.Parent = Frame

-- Crear un botón para cada jugador
local function createPlayerButton(player)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 30)
    Button.Text = player.Name
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Parent = PlayerList
    
    -- Función al hacer clic en el botón de un jugador
    Button.MouseButton1Click:Connect(function()
        startSpectatingInFirstPerson(player)
        ScreenGui:Destroy() -- Destruir el hub al seleccionar un jugador
    end)
end

-- Poblamos el hub con todos los jugadores del servidor
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createPlayerButton(player)
    end
end

-- Función para iniciar el modo espectador en primera persona
local function startSpectatingInFirstPerson(player)
    IsSpectating = true
    SpectatingPlayer = player

    -- Conectar la cámara para seguir al jugador en primera persona
    RunService.RenderStepped:Connect(function()
        if IsSpectating and SpectatingPlayer and SpectatingPlayer.Character then
            local character = SpectatingPlayer.Character
            local head = character:FindFirstChild("Head")

            if head then
                -- Ajustar la cámara a la cabeza del jugador objetivo
                Camera.CFrame = CFrame.new(head.Position, head.Position + head.CFrame.LookVector)
                Camera.CameraSubject = head
                Camera.FieldOfView = 70 -- Puedes ajustar el FOV a tu gusto
            end
        end
    end)
end

-- Función para detener el modo espectador (puedes agregar un botón si lo deseas)
local function stopSpectating()
    IsSpectating = false
    Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    Camera.CFrame = LocalPlayer.Character.Head.CFrame -- Volver a la cámara original
end

-- Agregar nuevos jugadores cuando ingresan al juego
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        createPlayerButton(player)
    end
end)
