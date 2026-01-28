-- ============================================
-- DELTA EXECUTOR - MENÚ MÓVIL SIMPLE
-- Roblox Mod Menu para Celular
-- ============================================

-- Servicios necesarios
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Variables de estado
local noclipActive = false
local flyActive = false
local menuVisible = true

-- ============================================
-- FUNCIONES PRINCIPALES
-- ============================================

-- 1. FUNCIÓN PARA OBTENER DINERO
function getMoney()
    print("[DELTA] Intentando agregar dinero...")
    
    local player = LocalPlayer
    local success = false
    
    -- Método 1: Leaderstats (más común)
    if player:FindFirstChild("leaderstats") then
        for _, stat in pairs(player.leaderstats:GetChildren()) do
            if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                if stat.Name:lower():find("cash") or 
                   stat.Name:lower():find("money") or 
                   stat.Name:lower():find("coin") then
                    stat.Value = stat.Value + 100000000
                    print("[DELTA] +100M en " .. stat.Name)
                    success = true
                end
            end
        end
    end
    
    -- Método 2: Player Data
    if not success and player:FindFirstChild("Data") then
        for _, data in pairs(player.Data:GetChildren()) do
            if data:IsA("IntValue") or data:IsA("NumberValue") then
                data.Value = data.Value + 100000000
                print("[DELTA] +100M en Data")
                success = true
            end
        end
    end
    
    -- Método 3: Buscar cualquier valor numérico
    if not success then
        for _, child in pairs(player:GetChildren()) do
            if child:IsA("IntValue") or child:IsA("NumberValue") then
                if child.Value < 100000000 then
                    child.Value = 100000000
                    print("[DELTA] +100M en " .. child.Name)
                    success = true
                end
            end
        end
    end
    
    -- Resultado
    if success then
        createMessage("✅ +100 MILLONES AGREGADOS", Color3.fromRGB(0, 255, 0))
    else
        createMessage("⚠️ No se encontró sistema de dinero", Color3.fromRGB(255, 165, 0))
    end
end

-- 2. FUNCIÓN NOCLIP (ATRAVESAR PAREDES)
function toggleNoclip()
    noclipActive = not noclipActive
    
    if noclipActive then
        createMessage("🌀 NOCLIP ACTIVADO", Color3.fromRGB(0, 150, 255))
        
        -- Conexión para noclip
        RunService.Stepped:Connect(function()
            if noclipActive and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
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

-- 3. FUNCIÓN VUELO (MODO AVION)
function toggleFly()
    flyActive = not flyActive
    
    if flyActive then
        createMessage("✈️ MODO VUELO ACTIVADO", Color3.fromRGB(0, 200, 255))
        
        -- Activar vuelo
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = true
            end
            
            -- Mover al aire
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = Vector3.new(0, 0, 0)
                root.CFrame = root.CFrame + Vector3.new(0, 5, 0)
            end
        end
    else
        createMessage("✈️ MODO VUELO DESACTIVADO", Color3.fromRGB(255, 50, 50))
        
        -- Desactivar vuelo
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
    end
end

-- ============================================
-- INTERFAZ SIMPLE PARA MÓVIL
-- ============================================

function createMessage(text, color)
    -- Mensaje en consola
    print("[DELTA] " .. text)
    
    -- Crear notificación simple
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DeltaMessage"
    screenGui.Parent = game.CoreGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.7, 0, 0.1, 0)
    frame.Position = UDim2.new(0.15, 0, 0.05, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextSize = 18
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    frame.Parent = screenGui
    
    -- Eliminar después de 3 segundos
    task.wait(3)
    screenGui:Destroy()
end

function createMobileMenu()
    -- Crear GUI principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DeltaMobileMenu"
    screenGui.Parent = game.CoreGui
    
    -- Marco principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.8, 0, 0.6, 0)
    mainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0.15, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "DELTA MENU"
    title.TextColor3 = Color3.fromRGB(0, 150, 255)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Subtítulo
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0.1, 0)
    subtitle.Position = UDim2.new(0, 0, 0.15, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Versión Móvil"
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 200)
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = mainFrame
    
    -- Función para crear botones
    function createButton(name, position, color, callback)
        local button = Instance.new("TextButton")
        button.Name = name .. "Button"
        button.Size = UDim2.new(0.8, 0, 0.15, 0)
        button.Position = position
        button.BackgroundColor3 = color
        button.Text = name
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 16
        button.Font = Enum.Font.GothamBold
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = button
        
        -- Efecto al presionar
        button.MouseButton1Click:Connect(function()
            -- Efecto visual
            button.BackgroundColor3 = Color3.fromRGB(
                math.min(color.R * 1.3, 1),
                math.min(color.G * 1.3, 1),
                math.min(color.B * 1.3, 1)
            )
            task.wait(0.1)
            button.BackgroundColor3 = color
            
            -- Ejecutar función
            callback()
        end)
        
        button.Parent = mainFrame
        return button
    end
    
    -- Crear botones
    local btnMoney = createButton(
        "🤑 TAKE 100M",
        UDim2.new(0.1, 0, 0.3, 0),
        Color3.fromRGB(0, 200, 100),
        getMoney
    )
    
    local btnNoclip = createButton(
        "🌀 ATRAVIESA",
        UDim2.new(0.1, 0, 0.5, 0),
        Color3.fromRGB(0, 150, 255),
        toggleNoclip
    )
    
    local btnFly = createButton(
        "✈️ MODO AVION",
        UDim2.new(0.1, 0, 0.7, 0),
        Color3.fromRGB(0, 180, 255),
        toggleFly
    )
    
    -- Botón para cerrar menú
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0.3, 0, 0.1, 0)
    closeBtn.Position = UDim2.new(0.35, 0, 0.88, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.Text = "OCULTAR"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        menuVisible = false
        createMessage("Menú ocultado", Color3.fromRGB(255, 100, 100))
    end)
    
    closeBtn.Parent = mainFrame
    
    -- Botón para mostrar menú (cuando está oculto)
    local showBtn = Instance.new("TextButton")
    showBtn.Name = "ShowButton"
    showBtn.Size = UDim2.new(0.15, 0, 0.08, 0)
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
        menuVisible = true
    end)
    
    showBtn.Parent = screenGui
    
    -- Función para mostrar/ocultar menú
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        showBtn.Visible = true
        menuVisible = false
    end)
    
    mainFrame.Parent = screenGui
    showBtn.Parent = screenGui
    
    -- Información del jugador
    local playerInfo = Instance.new("TextLabel")
    playerInfo.Size = UDim2.new(1, 0, 0.08, 0)
    playerInfo.Position = UDim2.new(0, 0, 0.85, 0)
    playerInfo.BackgroundTransparency = 1
    playerInfo.Text = "Jugador: " .. LocalPlayer.Name
    playerInfo.TextColor3 = Color3.fromRGB(200, 200, 255)
    playerInfo.TextSize = 12
    playerInfo.Font = Enum.Font.Gotham
    playerInfo.Parent = mainFrame
    
    return screenGui, mainFrame, showBtn
end

-- ============================================
-- INICIALIZACIÓN
-- ============================================

-- Esperar a que el jugador cargue
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

-- Crear el menú
local menu, mainFrame, showBtn = createMobileMenu()

-- Mensaje de inicio
createMessage("Delta Menu Cargado ✓", Color3.fromRGB(0, 150, 255))
print("========================================")
print("DELTA EXECUTOR - MENÚ MÓVIL")
print("Versión: 1.0 (Simple)")
print("Jugador: " .. LocalPlayer.Name)
print("========================================")
print("Funciones disponibles:")
print("1. TAKE 100M - Agregar dinero")
print("2. ATRAVIESA - Modo noclip")
print("3. AVION - Modo vuelo")
print("========================================")

-- Mantener el script activo
while true do
    -- Sistema de vuelo continuo
    if flyActive and LocalPlayer.Character then
        local character = LocalPlayer.Character
        local humanoid = character:FindFirstChild("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and root then
            humanoid.PlatformStand = true
            
            -- Mantener en el aire
            root.Velocity = Vector3.new(0, 0, 0)
            
            -- Se pueden agregar controles táctiles aquí si es necesario
        end
    end
    
    task.wait(0.1)
end
