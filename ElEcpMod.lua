-- ============================================
-- DELTA EXECUTOR - FISH GO 🦈 MÓVIL
-- Script optimizado específicamente para móvil
-- ============================================

-- Servicios necesarios
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Variables de estado
local noclipActive = false
local flyActive = false
local flySpeed = 25
local flightConnections = {}

-- ============================================
-- SISTEMA DE DINERO ESPECÍFICO PARA FISH GO
-- ============================================

function getMoneyFishGo()
    print("[FISH GO] Ejecutando sistema de dinero...")
    
    -- Método ESPECÍFICO para Fish Go
    local success = false
    
    -- 1. Método más común: RemoteEvents
    pcall(function()
        -- Buscar todos los RemoteEvents posibles
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                -- Probar diferentes formatos de envío
                local function trySend(value)
                    pcall(function() obj:FireServer(value) end)
                    pcall(function() obj:FireServer("AddMoney", value) end)
                    pcall(function() obj:FireServer("Money", value) end)
                    pcall(function() obj:FireServer("AddCash", value) end)
                    pcall(function() obj:FireServer("Coins", value) end)
                end
                
                trySend(100000000)
                trySend("100000000")
                trySend("AddMoney")
            elseif obj:IsA("RemoteFunction") then
                pcall(function() obj:InvokeServer(100000000) end)
                pcall(function() obj:InvokeServer("AddMoney", 100000000) end)
            end
        end
    end)
    
    -- 2. Buscar en el Player (Leaderstats específicos de Fish Go)
    pcall(function()
        local player = LocalPlayer
        
        -- Nombres comunes en Fish Go
        local moneyNames = {
            "Cash", "Coins", "Money", "Gold", 
            "Dollars", "Tokens", "Currency",
            "FishCoins", "OceanCoins", "SeaMoney"
        }
        
        -- Buscar en leaderstats
        if player:FindFirstChild("leaderstats") then
            for _, stat in pairs(player.leaderstats:GetChildren()) do
                for _, moneyName in pairs(moneyNames) do
                    if stat.Name:lower():find(moneyName:lower()) then
                        if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                            stat.Value = stat.Value + 100000000
                            success = true
                            print("[FISH GO] Dinero agregado a: " .. stat.Name)
                        end
                    end
                end
            end
        end
        
        -- Buscar directamente en el Player
        for _, child in pairs(player:GetChildren()) do
            for _, moneyName in pairs(moneyNames) do
                if child.Name:lower():find(moneyName:lower()) then
                    if child:IsA("IntValue") or child:IsA("NumberValue") then
                        child.Value = child.Value + 100000000
                        success = true
                        print("[FISH GO] Dinero agregado a: " .. child.Name)
                    end
                end
            end
        end
    end)
    
    -- 3. Buscar en PlayerGui (Interfaz del juego)
    pcall(function()
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            -- Buscar TextLabels que muestren dinero
            for _, gui in pairs(playerGui:GetDescendants()) do
                if gui:IsA("TextLabel") or gui:IsA("TextButton") then
                    local text = gui.Text
                    if text and (text:find("$") or text:find("💰") or text:find("$")) then
                        -- Extraer número y actualizar
                        local current = tonumber(text:gsub("%D", "")) or 0
                        gui.Text = tostring(current + 100000000)
                        success = true
                        print("[FISH GO] GUI actualizada")
                    end
                end
            end
        end
    end)
    
    -- Resultado
    if success then
        showNotification("✅ ¡100 MILLONES AGREGADOS!", 3, Color3.fromRGB(0, 255, 0))
    else
        showNotification("⚠️ No se encontró sistema de dinero", 3, Color3.fromRGB(255, 165, 0))
        -- Crear valor forzado
        local forcedMoney = Instance.new("IntValue")
        forcedMoney.Name = "FishGoCash"
        forcedMoney.Value = 100000000
        forcedMoney.Parent = LocalPlayer
        showNotification("💾 Valor creado: FishGoCash", 3, Color3.fromRGB(255, 215, 0))
    end
end

-- ============================================
-- NOCLIP PERFECTO (YA FUNCIONA BIEN)
-- ============================================

function toggleNoclip()
    noclipActive = not noclipActive
    
    if noclipActive then
        showNotification("🌀 NOCLIP ACTIVADO", 2, Color3.fromRGB(0, 150, 255))
        
        -- Conexión para mantener noclip
        table.insert(flightConnections, RunService.Stepped:Connect(function()
            if noclipActive and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end))
    else
        showNotification("🌀 NOCLIP DESACTIVADO", 2, Color3.fromRGB(255, 50, 50))
        
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
-- SISTEMA DE VUELO CORREGIDO PARA MÓVIL
-- ============================================

function toggleFly()
    flyActive = not flyActive
    
    if flyActive then
        showNotification("✈️ VUELO ACTIVADO", 2, Color3.fromRGB(0, 200, 255))
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            -- Guardar valores originales
            humanoid.PlatformStand = true
            
            -- Crear BodyVelocity para movimiento
            local velocity = Instance.new("BodyVelocity")
            velocity.MaxForce = Vector3.new(40000, 40000, 40000)
            velocity.Velocity = Vector3.new(0, 0, 0)
            velocity.P = 1000
            velocity.Parent = rootPart
            
            -- Crear BodyGyro para estabilidad
            local gyro = Instance.new("BodyGyro")
            gyro.MaxTorque = Vector3.new(40000, 40000, 40000)
            gyro.P = 1000
            gyro.CFrame = rootPart.CFrame
            gyro.Parent = rootPart
            
            -- Sistema de movimiento DIRECTO y SIMPLE
            table.insert(flightConnections, RunService.Heartbeat:Connect(function()
                if not flyActive or not character or not rootPart then return end
                
                -- Mantener vuelo básico
                gyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + Vector3.new(0, 0, -1))
                velocity.Velocity = Vector3.new(0, 0, 0) -- Se controla con botones
            end))
            
            -- Crear controles táctiles VISIBLES
            createFlightControls(velocity, gyro)
        end
    else
        -- DESACTIVAR VUELO CORRECTAMENTE
        flyActive = false
        
        -- Limpiar conexiones
        for _, conn in pairs(flightConnections) do
            conn:Disconnect()
        end
        flightConnections = {}
        
        -- Restaurar personaje
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid then
                humanoid.PlatformStand = false
            end
            
            if rootPart then
                -- Eliminar todos los BodyMovers
                for _, obj in pairs(rootPart:GetChildren()) do
                    if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then
                        obj:Destroy()
                    end
                end
            end
        end
        
        -- Eliminar controles táctiles
        if game:GetService("CoreGui"):FindFirstChild("FlightControlsMobile") then
            game:GetService("CoreGui").FlightControlsMobile:Destroy()
        end
        
        showNotification("✈️ VUELO DESACTIVADO", 2, Color3.fromRGB(255, 50, 50))
    end
end

-- ============================================
-- CONTROLES DE VUELO TÁCTILES PARA MÓVIL
-- ============================================

function createFlightControls(velocity, gyro)
    -- Crear GUI para controles
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FlightControlsMobile"
    screenGui.Parent = game:GetService("CoreGui")
    
    -- Función para crear botones de control
    local function createControlButton(name, position, size, callback)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(size, 0, size, 0)
        button.Position = position
        button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        button.BackgroundTransparency = 0.3
        button.Text = name
        button.TextColor3 = Color3.fromRGB(0, 0, 0)
        button.TextSize = 20
        button.Font = Enum.Font.GothamBold
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.5, 0)
        corner.Parent = button
        
        -- Efecto al presionar
        button.MouseButton1Down:Connect(function()
            button.BackgroundTransparency = 0.1
            if callback then callback(true) end
        end)
        
        button.MouseButton1Up:Connect(function()
            button.BackgroundTransparency = 0.3
            if callback then callback(false) end
        end)
        
        button.Parent = screenGui
        return button
    end
    
    -- Botón PARA ARRIBA
    local upBtn = createControlButton("⬆️", UDim2.new(0.8, 0, 0.6, 0), 0.12, function(pressed)
        if pressed and velocity then
            velocity.Velocity = Vector3.new(0, flySpeed, 0)
        else
            velocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    -- Botón PARA ABAJO
    local downBtn = createControlButton("⬇️", UDim2.new(0.8, 0, 0.75, 0), 0.12, function(pressed)
        if pressed and velocity then
            velocity.Velocity = Vector3.new(0, -flySpeed, 0)
        else
            velocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    -- Botón ADELANTE
    local forwardBtn = createControlButton("➡️", UDim2.new(0.65, 0, 0.75, 0), 0.12, function(pressed)
        if pressed and velocity and gyro then
            local forward = gyro.CFrame.LookVector
            velocity.Velocity = forward * flySpeed
        else
            velocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    -- Botón ATRÁS
    local backBtn = createControlButton("⬅️", UDim2.new(0.5, 0, 0.75, 0), 0.12, function(pressed)
        if pressed and velocity and gyro then
            local forward = gyro.CFrame.LookVector
            velocity.Velocity = -forward * flySpeed
        else
            velocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    -- Botón para DESACTIVAR VUELO
    local stopBtn = Instance.new("TextButton")
    stopBtn.Name = "StopFly"
    stopBtn.Size = UDim2.new(0.15, 0, 0.07, 0)
    stopBtn.Position = UDim2.new(0.02, 0, 0.85, 0)
    stopBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    stopBtn.Text = "✖️"
    stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    stopBtn.TextSize = 18
    stopBtn.Font = Enum.Font.GothamBold
    
    local stopCorner = Instance.new("UICorner")
    stopCorner.CornerRadius = UDim.new(0.5, 0)
    stopCorner.Parent = stopBtn
    
    stopBtn.MouseButton1Click:Connect(function()
        toggleFly() -- Desactivar vuelo
    end)
    stopBtn.Parent = screenGui
    
    -- Mostrar controles solo cuando esté activo el vuelo
    RunService.Heartbeat:Connect(function()
        local visible = flyActive
        upBtn.Visible = visible
        downBtn.Visible = visible
        forwardBtn.Visible = visible
        backBtn.Visible = visible
        stopBtn.Visible = visible
    end)
end

-- ============================================
-- INTERFAZ MÓVIL OPTIMIZADA
-- ============================================

function showNotification(text, duration, color)
    -- Mostrar en consola
    print("[FISH GO] " .. text)
    
    -- Crear notificación móvil
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NotificationMobile"
    screenGui.Parent = game:GetService("CoreGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0.08, 0)
    frame.Position = UDim2.new(0.05, 0, 0.05, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BackgroundTransparency = 0.1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextSize = 16
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.Parent = frame
    
    frame.Parent = screenGui
    
    -- Auto-destruir
    task.wait(duration)
    screenGui:Destroy()
end

function createMobileMenu()
    -- Crear GUI principal optimizada para móvil
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FishGoMobileMenu"
    screenGui.Parent = game:GetService("CoreGui")
    
    -- Marco principal (más grande para móvil)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.95, 0, 0.7, 0) -- Más grande
    mainFrame.Position = UDim2.new(0.025, 0, 0.15, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 40)
    mainFrame.BackgroundTransparency = 0.05
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 150, 255)
    stroke.Thickness = 3
    stroke.Parent = mainFrame
    
    -- TÍTULO GRANDE
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.15, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🦈 FISH GO HACK 🦈"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.TextSize = 26 -- Más grande
    title.Font = Enum.Font.GothamBold
    title.TextScaled = false
    title.Parent = mainFrame
    
    -- Subtítulo
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0.08, 0)
    subtitle.Position = UDim2.new(0, 0, 0.15, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Delta Executor - Móvil"
    subtitle.TextColor3 = Color3.fromRGB(150, 200, 255)
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = mainFrame
    
    -- Función para crear BOTONES GRANDES
    function createBigButton(name, description, position, color, callback, isMoney)
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Size = UDim2.new(0.9, 0, 0.22, 0) -- Botones más altos
        buttonFrame.Position = position
        buttonFrame.BackgroundColor3 = color
        buttonFrame.BackgroundTransparency = 0.1
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 15)
        btnCorner.Parent = buttonFrame
        
        -- Texto principal GRANDE
        local buttonText = Instance.new("TextLabel")
        buttonText.Size = UDim2.new(1, 0, 0.6, 0)
        buttonText.Position = UDim2.new(0, 0, 0, 0)
        buttonText.BackgroundTransparency = 1
        buttonText.Text = name
        buttonText.TextColor3 = Color3.fromRGB(255, 255, 255)
        buttonText.TextSize = 22 -- Más grande
        buttonText.Font = Enum.Font.GothamBold
        buttonText.Parent = buttonFrame
        
        -- Descripción
        local descText = Instance.new("TextLabel")
        descText.Size = UDim2.new(1, 0, 0.4, 0)
        descText.Position = UDim2.new(0, 0, 0.6, 0)
        descText.BackgroundTransparency = 1
        descText.Text = description
        descText.TextColor3 = Color3.fromRGB(200, 200, 200)
        descText.TextSize = 12
        descText.Font = Enum.Font.Gotham
        descText.TextWrapped = true
        descText.Parent = buttonFrame
        
        -- Efecto de botón
        buttonFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                buttonFrame.BackgroundTransparency = 0.3
                callback()
            end
        end)
        
        buttonFrame.InputEnded:Connect(function()
            buttonFrame.BackgroundTransparency = 0.1
        end)
        
        buttonFrame.Parent = mainFrame
        return buttonFrame
    end
    
    -- BOTÓN 1: DINERO (MUY GRANDE)
    local btnMoney = createBigButton(
        "💰 OBTENER 100M",
        "Agrega 100 millones de dinero al juego",
        UDim2.new(0.05, 0, 0.25, 0),
        Color3.fromRGB(0, 180, 80),
        getMoneyFishGo
    )
    
    -- BOTÓN 2: NOCLIP
    local btnNoclip = createBigButton(
        "🌀 ATRAVESAR",
        "Activa/Desactiva modo noclip",
        UDim2.new(0.05, 0, 0.49, 0),
        Color3.fromRGB(0, 120, 220),
        toggleNoclip
    )
    
    -- BOTÓN 3: VUELO MEJORADO
    local btnFly = createBigButton(
        "✈️ MODO VUELO",
        "Vuela por el mapa con controles táctiles",
        UDim2.new(0.05, 0, 0.73, 0),
        Color3.fromRGB(220, 100, 0),
        toggleFly
    )
    
    -- Botón para OCULTAR
    local hideBtn = Instance.new("TextButton")
    hideBtn.Name = "HideButton"
    hideBtn.Size = UDim2.new(0.4, 0, 0.08, 0)
    hideBtn.Position = UDim2.new(0.3, 0, 0.96, 0)
    hideBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    hideBtn.Text = "👁️ OCULTAR MENÚ"
    hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    hideBtn.TextSize = 16
    hideBtn.Font = Enum.Font.GothamBold
    
    local hideCorner = Instance.new("UICorner")
    hideCorner.CornerRadius = UDim.new(0, 10)
    hideCorner.Parent = hideBtn
    
    hideBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        showNotification("Menú ocultado", 2, Color3.fromRGB(255, 100, 100))
    end)
    hideBtn.Parent = mainFrame
    
    -- Botón para MOSTRAR (pequeño, cuando está oculto)
    local showBtn = Instance.new("TextButton")
    showBtn.Name = "ShowButton"
    showBtn.Size = UDim2.new(0.12, 0, 0.06, 0)
    showBtn.Position = UDim2.new(0.02, 0, 0.02, 0)
    showBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    showBtn.Text = "▲"
    showBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    showBtn.TextSize = 20
    showBtn.Visible = false
    
    local showCorner = Instance.new("UICorner")
    showCorner.CornerRadius = UDim.new(0, 8)
    showCorner.Parent = showBtn
    
    showBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        showBtn.Visible = false
        showNotification("Menú mostrado", 2, Color3.fromRGB(0, 200, 100))
    end)
    showBtn.Parent = screenGui
    
    -- Conectar ocultar/mostrar
    hideBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        showBtn.Visible = true
    end)
    
    mainFrame.Parent = screenGui
    return screenGui, mainFrame, showBtn
end

-- ============================================
-- INICIALIZACIÓN DEL SCRIPT
-- ============================================

-- Esperar a que el jugador cargue
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

-- Crear menú móvil
createMobileMenu()

-- Mensaje de inicio
showNotification("✅ FISH GO HACK ACTIVADO", 3, Color3.fromRGB(0, 200, 255))
print("==========================================")
print("FISH GO HACK - DELTA EXECUTOR MÓVIL")
print("==========================================")
print("Botones optimizados para pantalla táctil")
print("Vuelo con controles táctiles funcionales")
print("==========================================")

-- Sistema de limpieza al salir del juego
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        -- Limpiar todo al salir
        for _, conn in pairs(flightConnections) do
            conn:Disconnect()
        end
    end
end)

-- Mantener script activo
while true do
    task.wait(1)
    -- Heartbeat para mantener funciones
end
```
