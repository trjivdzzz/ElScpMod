-- ===================================================================
-- == SCRIPT DE MENÚ DE DINERO PARA ROBLOX (VERSIÓN EXECUTOR)       ==
-- == Compatible con: Delta Executor (Móvil) y otros executors      ==
-- == Creado por: GLM 4.6 (Creador Profesional de Scripts Lua)       ==
-- == Fecha: 28/01/2026                                              ==
-- == Propósito: Inyectar un menú GUI funcional para dar dinero.    ==
-- ===================================================================

-- --- CONFIGURACIÓN ---
local SETTINGS = {
    MONEY_TO_GIVE = 100000000, -- Cantidad de dinero a añadir.
    MENU_POSITION = UDim2.new(0, 20, 0, 20), -- Posición inicial del menú
    MENU_SIZE = UDim2.new(0, 280, 0, 180), -- Tamaño del menú principal
    TOGGLE_KEY = Enum.KeyCode.M -- Tecla para mostrar/ocultar el menú (tecla 'M')
}

-- --- PALETA DE COLORES PROFESIONAL ---
local COLORS = {
    PRIMARY = Color3.fromRGB(25, 25, 35),      -- Gris oscuro azulado (fondo principal)
    SECONDARY = Color3.fromRGB(45, 45, 60),    -- Gris medio (botones, paneles)
    ACCENT = Color3.fromRGB(85, 170, 255),     -- Azul brillante (acentos, hover)
    TEXT = Color3.fromRGB(255, 255, 255),      -- Blanco puro (texto)
    SUCCESS = Color3.fromRGB(50, 255, 126),    -- Verde brillante (feedback de éxito)
    DISABLED = Color3.fromRGB(100, 100, 100)   -- Gris (estado deshabilitado)
}

-- --- SERVICIOS DE ROBLOX ---
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- --- VARIABLES DEL JUGADOR Y UI ---
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Elementos de la Interfaz Gráfica (GUI)
local screenGui
local mainFrame
local titleButton
local moneyButton
local feedbackLabel
local isOpen = false
local isDragging = false
local dragStart, startPos

-- --- FUNCIONES DE LÓGICA PRINCIPAL ---

-- Función para asegurar que el jugador tiene la estructura 'leaderstats' y 'Money'
-- Esto es crucial para que el script funcione en juegos que no tienen un sistema de dinero.
local function ensurePlayerMoney()
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        leaderstats = Instance.new("Folder")
        leaderstats.Name = "leaderstats"
        leaderstats.Parent = player
    end

    local money = leaderstats:FindFirstChild("Money")
    if not money then
        money = Instance.new("IntValue")
        money.Name = "Money"
        money.Value = 0 -- Empieza en 0 si no existía
        money.Parent = leaderstats
    end
    return money
end

-- Función que se ejecuta cuando el botón "Money Fixx" es presionado
local function onMoneyButtonClicked()
    -- Obtenemos la referencia al valor del dinero
    local moneyValue = ensurePlayerMoney()
    
    -- Añadimos la cantidad de dinero configurada
    moneyValue.Value = moneyValue.Value + SETTINGS.MONEY_TO_GIVE

    -- Feedback visual para el usuario
    if feedbackLabel then
        feedbackLabel.Text = "+" .. SETTINGS.MONEY_TO_GIVE .. "\$"
        feedbackLabel.TextColor3 = COLORS.SUCCESS
        feedbackLabel.Visible = true
        
        -- Animación de fade out para el feedback
        local fadeOut = TweenService:Create(feedbackLabel, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            feedbackLabel.Visible = false
            feedbackLabel.TextTransparency = 0
        end)
    end
    
    -- Efecto de sonido de compra (opcional, pero profesional)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://611538504" -- ID de un sonido de "caja registradora"
    sound.Volume = 0.5
    sound.Parent = player:WaitForChild("PlayerGui") -- Se reproduce localmente
    sound:Play()
    sound.Ended:Connect(function() sound:Destroy() end)
end

-- --- FUNCIONES DE CREACIÓN Y MANEJO DE LA UI ---

-- Función helper para crear esquinas redondeadas
local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

-- Función helper para crear sombras
local function createDropShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.4
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(22, 22, 222, 222)
    shadow.Size = UDim2.new(1, 36, 1, 36)
    shadow.Position = UDim2.new(0, -18, 0, -18)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
end

-- Función para construir toda la interfaz de usuario
local function buildUI()
    -- ScreenGui: Contenedor principal
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MoneyFixxMenu"
    screenGui.ResetOnSpawn = false -- MUY IMPORTANTE para executors
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui

    -- MainFrame: El panel principal del menú
    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = SETTINGS.MENU_SIZE
    mainFrame.Position = SETTINGS.MENU_POSITION
    mainFrame.BackgroundColor3 = COLORS.PRIMARY
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    createUICorner(mainFrame, 12)
    createDropShadow(mainFrame)

    -- TitleButton: Barra de título para poder arrastrar la ventana
    titleButton = Instance.new("TextButton")
    titleButton.Name = "TitleButton"
    titleButton.Size = UDim2.new(1, 0, 0, 40)
    titleButton.Position = UDim2.new(0, 0, 0, 0)
    titleButton.BackgroundColor3 = COLORS.SECONDARY
    titleButton.BorderSizePixel = 0
    titleButton.Text = "  Money Fixx Menu"
    titleButton.Font = Enum.Font.GothamSemibold
    titleButton.TextSize = 18
    titleButton.TextColor3 = COLORS.TEXT
    titleButton.TextXAlignment = Enum.TextXAlignment.Left
    titleButton.Parent = mainFrame
    createUICorner(titleButton, 12)
    
    -- MoneyButton: El botón principal para dar dinero
    moneyButton = Instance.new("TextButton")
    moneyButton.Name = "MoneyButton"
    moneyButton.Size = UDim2.new(0, 220, 0, 50)
    moneyButton.Position = UDim2.new(0.5, -110, 0.5, -25)
    moneyButton.BackgroundColor3 = COLORS.ACCENT
    moneyButton.BorderSizePixel = 0
    moneyButton.Text = "Money Fixx"
    moneyButton.Font = Enum.Font.GothamBold
    moneyButton.TextSize = 22
    moneyButton.TextColor3 = COLORS.TEXT
    moneyButton.Parent = mainFrame
    createUICorner(moneyButton, 8)

    -- FeedbackLabel: Label para mostrar el mensaje de "+100000000\$"
    feedbackLabel = Instance.new("TextLabel")
    feedbackLabel.Name = "FeedbackLabel"
    feedbackLabel.Size = UDim2.new(1, 0, 0, 30)
    feedbackLabel.Position = UDim2
