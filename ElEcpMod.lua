-- ============================================
-- DELTA EXECUTOR - FISH GO 🦈 MENÚ
-- Script específico para el juego "Fish Go"
-- ============================================

-- Servicios necesarios
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables de estado
local noclipActive = false
local flyActive = false
local flySpeed = 50
local menuVisible = true

-- ============================================
-- FUNCIÓN ESPECÍFICA PARA FISH GO 🦈
-- ============================================

function getMoneyFishGo()
    print("[FISH GO] Buscando sistema de dinero...")
    
    -- Método 1: Buscar en ReplicatedStorage (común en Fish Go)
    if ReplicatedStorage:FindFirstChild("Events") then
        local events = ReplicatedStorage.Events
        -- Buscar eventos de dinero
        for _, event in pairs(events:GetChildren()) do
            if event:IsA("RemoteEvent") then
                if event.Name:lower():find("money") or 
                   event.Name:lower():find("cash") or 
                   event.Name:lower():find("coin") or
                   event.Name:lower():find("add") then
                    pcall(function()
                        event:FireServer(100000000)
                        print("[FISH GO] Dinero enviado via evento: " .. event.Name)
                        createMessage("✅ +100M ENVIADO", Color3.fromRGB(0, 255, 0))
                        return
                    end)
                end
            end
        end
    end
    
    -- Método 2: Buscar en el player (leaderstats)
    if LocalPlayer:FindFirstChild("leaderstats") then
        for _, stat in pairs(LocalPlayer.leaderstats:GetChildren()) do
            if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                stat.Value = stat.Value + 100000000
                print("[FISH GO] +100M en " .. stat.Name)
                createMessage("✅ +100M EN " .. stat.Name:upper(), Color3.fromRGB(0, 255, 0))
                return
            end
        end
    end
    
    -- Método 3: Buscar en PlayerGui (interfaz)
    if LocalPlayer:FindFirstChild("PlayerGui") then
        for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
            if gui:IsA("TextLabel") or gui:IsA("TextButton") then
                local text = gui.Text
                if text and (text:find("$") or text:find("💰") or text:find("Cash") or text:find("Money")) then
                    -- Intentar extraer y aumentar número
                    local num = tonumber(text:gsub("%D", "")) or 0
                    gui.Text = tostring(num + 100000000)
                    print("[FISH GO] GUI actualizada")
                    createMessage("✅ GUI ACTUALIZADA +100M", Color3.fromRGB(0, 255, 0))
                    return
                end
            end
        end
    end
    
    -- Método 4: Buscar en Workspace (para sistemas de monedas físicas)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("money") or obj.Name:lower():find("cash") or obj.Name:lower():find("coin") then
            if obj:IsA("Part") then
                -- Intentar tocar la moneda
                local touch = obj:FindFirstChild("TouchInterest")
                if touch then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
                    print("[FISH GO] Moneda tocada")
                end
            end
        end
    end
    
    -- Método 5: Forzar creación de valor de dinero
    local moneyValue = Instance.new("IntValue")
    moneyValue.Name = "Cash"
    moneyValue.Value = 100000000
    moneyValue.Parent = LocalPlayer
    print("[FISH GO] Valor creado forzadamente")
    createMessage("💾 VALOR CASH CREADO", Color3.fromRGB(255, 215, 0))
end

-- ============================================
-- NOCLIP MEJORADO
-- ============================================

function toggleNoclip()
    noclipActive = not noclipActive
    
    if noclipActive then
        createMessage("🌀 NOCLIP ACTIVADO", Color3.fromRGB(0, 150, 255))
        
        -- Conexión continua para noclip
        while noclipActive do
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
            task.wait(0.1)
        end
    else
        createMessage("🌀 NOCLIP DESACTIVADO", Color3.fromRGB(255, 50, 50))
        
        -- Restaurar colisiones
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- ============================================
-- SISTEMA DE VUELO FUNCIONAL PARA MÓVIL
-- ============================================

local flyConnection
local velocity
local bodyGyro

function toggleFly()
    flyActive = not flyActive
    
    if flyActive then
        createMessage("✈️ VUELO ACTIVADO", Color3.fromRGB(0, 200, 255))
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            -- Guardar valores originales
            humanoid.PlatformStand = true
            
            -- Crear controles de vuelo
            velocity = Instance.new("BodyVelocity")
            velocity.MaxForce = Vector3.new(40000, 40000, 40000)
            velocity.Velocity = Vector3.new(0, 0, 0)
            velocity.P = 1250
            velocity.Parent = rootPart
            
            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000)
            bodyGyro.P = 3000
            bodyGyro.CFrame = rootPart.CFrame
            bodyGyro.Parent = rootPart
            
            -- Sistema de movimiento simple
            flyConnection = RunService.Heartbeat:Connect(function()
                if not flyActive or not character or not rootPart then return end
                
                local moveDirection = Vector3.new(0, 0, 0)
                
                -- Sistema simple de movimiento
                velocity.Velocity = Vector3.new(0, 5, 0) -- Siempre subir un poco
                
                -- Mantener posición horizontal
                bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + Workspace.CurrentCamera.CFrame.LookVector)
            end)
            
            -- Control táctil para móvil
            setupMobileFlightControls()
        end
    else
        flyActive = false
        
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid then
                humanoid.PlatformStand = false
            end
            
            if rootPart then
                if velocity then velocity:Destroy() end
                if bodyGyro then bodyGyro:Destroy() end
            end
        end
        
        createMessage("✈️ VUELO DESACTIVADO", Color3.fromRGB(255, 50, 50))
    end
end

function setupMobileFlightControls()
    -- Crear controles táctiles para móvil
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FlightControls"
    screenGui.Parent = game.CoreGui
    
    -- Controles direccionales
    local function createControlButton(name, position, size)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(size, 0, size, 0)
        button.Position = position
        button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        button.BackgroundTransparency = 0.7
        button.Text = ""
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 20
        button.Font = Enum.Font.GothamBold
        button.Visible = flyActive
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = button
        
        return button
    end
    
    -- Botón para subir
    local upBtn = createControlButton("Up", UDim2.new(0.8, 0, 0.7, 0), 0.1)
    upBtn.MouseButton1Down:Connect(function()
        while flyActive and upBtn:IsDescendantOf(game) do
            if velocity then
                velocity.Velocity = velocity.Velocity + Vector3.new(0, 10, 0)
            end
            task.wait()
        end
    end)
    upBtn.Parent = screenGui
    
    -- Botón para bajar
    local downBtn = createControlButton("Down", UDim2.new(0.8, 0, 0.85, 0), 0.1)
    downBtn.MouseButton1Down:Connect(function()
        while flyActive and downBtn:IsDescendantOf(game) do
            if velocity then
                velocity.Velocity = velocity.Velocity + Vector3.new(0, -10, 0)
            end
            task.wait()
        end
    end)
    downBtn.Parent = screenGui
    
    -- Botón para adelante
    local forwardBtn = createControlButton("Forward", UDim2.new(0.65, 0, 0.85, 0), 0.1)
    forwardBtn.MouseButton1Down:Connect(function()
        while flyActive and forwardBtn:IsDescendantOf(game) do
            if velocity then
                local look = Workspace.CurrentCamera.CFrame.LookVector
                velocity.Velocity = velocity.Velocity + (look * 10)
            end
            task.wait()
        end
    end)
    forwardBtn.Parent = screenGui
    
    -- Actualizar visibilidad
    RunService.Heartbeat:Connect(function()
        if screenGui then
            upBtn.Visible = flyActive
            downBtn.Visible = flyActive
            forwardBtn.Visible = flyActive
        end
    end)
end

-- ============================================
-- INTERFAZ MÓVIL PARA FISH GO
-- ============================================

function createMessage(text, color)
    -- Mostrar en consola
    print("[FISH GO MENU] " .. text)
    
    -- Notificación simple
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DeltaNotify"
    screenGui.Parent = game.CoreGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.8, 0, 0.08, 0)
    frame.Position = UDim2.new(0.1, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextSize = 16
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    frame.Parent = screenGui
    
    -- Desaparecer después de 2 segundos
    task.wait(2)
    screenGui:Destroy()
end

function createFishGoMenu()
    -- Crear GUI principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FishGoMenu"
    screenGui.Parent = game.CoreGui
    
    -- Marco principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.85, 0, 0.65, 0)
    mainFrame.Position = UDim2.new(0.075, 0, 0.2, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 35) -- Azul marino como el juego
    mainFrame.BackgroundTransparency = 0.1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 150, 255)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    -- Título con tema de peces
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0.15, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🦈 FISH GO HACK 🦈"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0.08, 0)
    subtitle.Position = UDim2.new(0, 0, 0.15, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Delta Executor - By Request"
    subtitle.TextColor3 = Color3.fromRGB(150, 200, 255)
    subtitle.TextSize = 12
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = mainFrame
    
    -- Función para crear botones del juego
    function createGameButton(name, position, color, callback)
        local button = Instance.new("TextButton")
        button.Name = name .. "Btn"
        button.Size = UDim2.new(0.9, 0, 0.2, 0)
        button.Position = position
        button.BackgroundColor3 = color
        button.Text = name
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 18
        button.Font = Enum.Font.GothamBold
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 12)
        btnCorner.Parent = button
        
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(255, 255, 255)
        btnStroke.Thickness = 1
        btnStroke.Transparency = 0.5
        btnStroke.Parent = button
        
        -- Efecto al presionar
        button.MouseButton1Down:Connect(function()
            button.BackgroundTransparency = 0.3
            button.TextTransparency = 0.3
        end)
        
        button.MouseButton1Up:Connect(function()
            button.BackgroundTransparency = 0
            button.TextTransparency = 0
            callback()
        end)
        
        button.Parent = mainFrame
        return button
    end
    
    -- Botón 1: DINERO PARA FISH GO
    local btnMoney = createGameButton(
        "💰 OBTENER 100 MILLONES",
        UDim2.new(0.05, 0, 0.25, 0),
        Color3.fromRGB(0, 180, 0),
        function()
            getMoneyFishGo()
        end
    )
    
    -- Botón 2: NOCLIP
    local btnNoclip = createGameButton(
        "🌀 ATRAVESAR PAREDES",
        UDim2.new(0.05, 0, 0.47, 0),
        Color3.fromRGB(0, 120, 255),
        function()
            toggleNoclip()
        end
    )
    
    -- Botón 3: VUELO MEJORADO
    local btnFly = createGameButton(
        "✈️ ACTIVAR VUELO",
        UDim2.new(0.05, 0, 0.69, 0),
        Color3.fromRGB(255, 100, 0),
        function()
            toggleFly()
        end
    )
    
    -- Indicador de estado
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0.1, 0)
    statusLabel.Position = UDim2.new(0, 0, 0.9, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "🟢 MENÚ ACTIVO | Jugador: " .. LocalPlayer.Name
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.Parent = mainFrame
    
    -- Botón para ocultar
    local hideBtn = Instance.new("TextButton")
    hideBtn.Name = "HideBtn"
    hideBtn.Size = UDim2.new(0.3, 0, 0.08, 0)
    hideBtn.Position = UDim2.new(0.35, 0, 0.82, 0)
    hideBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    hideBtn.Text = "👁️ OCULTAR"
    hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    hideBtn.TextSize = 14
    hideBtn.Font = Enum.Font.GothamBold
    
    local hideCorner = Instance.new("UICorner")
    hideCorner.CornerRadius = UDim.new(0, 8)
    hideCorner.Parent = hideBtn
    
    hideBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        menuVisible = false
        createMessage("Menú ocultado", Color3.fromRGB(255, 100, 100))
    end)
    hideBtn.Parent = mainFrame
    
    -- Botón para mostrar (pequeño)
    local showBtn = Instance.new("TextButton")
    showBtn.Name = "ShowBtn"
    showBtn.Size = UDim2.new(0.1, 0, 0.06, 0)
    showBtn.Position = UDim2.new(0.02, 0, 0.02, 0)
    showBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    showBtn.Text = "▲"
    showBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    showBtn.TextSize = 18
    showBtn.Visible = false
    
    local showCorner = Instance.new("UICorner")
    showCorner.CornerRadius = UDim.new(0, 6)
    showCorner.Parent = showBtn
    
    showBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        showBtn.Visible = false
        menuVisible = true
    end)
    showBtn.Parent = screenGui
    
    -- Conectar botones de ocultar/mostrar
    hideBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        showBtn.Visible = true
        menuVisible = false
    end)
    
    mainFrame.Parent = screenGui
    return screenGui, mainFrame, showBtn
end

-- ============================================
-- INICIALIZACIÓN Y EJECUCIÓN
-- ============================================

-- Esperar al jugador
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

-- Crear menú
local menu, mainFrame, showBtn = createFishGoMenu()

-- Mensaje de bienvenida
createMessage("🦈 FISH GO HACK ACTIVADO!", Color3.fromRGB(0, 200, 255))
print("========================================")
print("FISH GO 🦈 - DELTA EXECUTOR")
print("========================================")
print("Script específico para Fish Go")
print("Funciones optimizadas para este juego")
print("========================================")

-- Sistema para mantener funciones activas
task.spawn(function()
    while true do
        -- Mantener noclip si está activo
        if noclipActive and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        
        -- Mantener vuelo si está activo
        if flyActive and LocalPlayer.Character then
            local character = LocalPlayer.Character
            local root = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChild("Humanoid")
            
            if root and humanoid then
                humanoid.PlatformStand = true
                
                -- Sistema simple de flotación
                if not velocity or not bodyGyro then
                    velocity = Instance.new("BodyVelocity")
                    velocity.MaxForce = Vector3.new(40000, 40000, 40000)
                    velocity.Velocity = Vector3.new(0, 5, 0)
                    velocity.Parent = root
                    
                    bodyGyro = Instance.new("BodyGyro")
                    bodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000)
                    bodyGyro.CFrame = root.CFrame
                    bodyGyro.Parent = root
                end
                
                -- Mantener altura
                velocity.Velocity = Vector3.new(0, 5, 0)
            end
        end
        
        task.wait(0.1)
    end
end)

-- Mantener script vivo
while true do
    task.wait(5)
    -- Heartbeat para evitar que se cierre
    if not menuVisible then
        -- El menú sigue activo en segundo plano
    end
end
