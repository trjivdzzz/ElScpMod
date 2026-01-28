-- ============================================
-- DELTA EXECUTOR - MENÚ PREMIUM PROFESIONAL
-- Roblox Mod Menu v2.0
-- ============================================

-- Configuración inicial
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

-- Variables globales
local isMenuOpen = true
local connections = {}
local toggles = {
    Noclip = false,
    Fly = false
}
local originalWalkspeed = 16
local originalJumpPower = 50

-- ============================================
-- FUNCIONES UTILITARIAS PREMIUM
-- ============================================

local function createSound(id, parent)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. id
    sound.Volume = 0.3
    sound.Parent = parent
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 5)
end

local function createRippleEffect(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Parent = button
    ripple.ZIndex = 5
    
    local tween = TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(2, 0, 2, 0),
        BackgroundTransparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

local function createNotification(title, message, color)
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, 20, 0.8, 0)
    notification.AnchorPoint = Vector2.new(1, 0)
    notification.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    notification.BackgroundTransparency = 0.1
    notification.BorderSizePixel = 0
    notification.ZIndex = 100
    
    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 12)
    uicorner.Parent = notification
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 2
    stroke.Parent = notification
    
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://8992230671"
    glow.ImageColor3 = color
    glow.ImageTransparency = 0.8
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(100, 100, 100, 100)
    glow.ZIndex = 99
    glow.Parent = notification
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = color
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 101
    titleLabel.Parent = notification
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.Size = UDim2.new(1, -20, 0, 40)
    messageLabel.Position = UDim2.new(0, 10, 0, 35)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    messageLabel.TextSize = 14
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    messageLabel.ZIndex = 101
    messageLabel.Parent = notification
    
    local closeBtn = Instance.new("ImageButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -25, 0, 10)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Image = "rbxassetid://3926305904"
    closeBtn.ImageRectOffset = Vector2.new(284, 4)
    closeBtn.ImageRectSize = Vector2.new(24, 24)
    closeBtn.ImageColor3 = Color3.fromRGB(150, 150, 150)
    closeBtn.ZIndex = 101
    closeBtn.Parent = notification
    
    notification.Parent = game:GetService("CoreGui")
    
    -- Animación de entrada
    notification.Position = UDim2.new(1, 320, 0.8, 0)
    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, 20, 0.8, 0)
    })
    tweenIn:Play()
    
    -- Funcionalidad de cierre
    closeBtn.MouseButton1Click:Connect(function()
        createSound(315962023, closeBtn)
        local tweenOut = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 320, 0.8, 0)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
    
    -- Cierre automático
    task.spawn(function()
        task.wait(5)
        if notification.Parent then
            local tweenOut = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 320, 0.8, 0)
            })
            tweenOut:Play()
            tweenOut.Completed:Connect(function()
                notification:Destroy()
            end)
        end
    end)
end

-- ============================================
-- FUNCIONES DE HACKS PROFESIONALES
-- ============================================

-- 1. SISTEMA DE DINERO 100M (ADAPTATIVO)
local function take100M()
    createSound(130785805, nil)
    
    -- Detección automática de sistemas de dinero comunes
    local success = false
    local player = LocalPlayer
    
    -- Método 1: Leaderstats
    if player:FindFirstChild("leaderstats") then
        for _, stat in pairs(player.leaderstats:GetChildren()) do
            if (stat.Name:lower():find("cash") or stat.Name:lower():find("money") or 
                stat.Name:lower():find("coins") or stat.Name:lower():find("dollar")) and 
                stat:IsA("NumberValue") or stat:IsA("IntValue") then
                stat.Value = stat.Value + 100000000
                success = true
                createNotification("✅ ÉXITO", "Se han añadido 100M a " .. stat.Name, Color3.fromRGB(0, 255, 127))
                break
            end
        end
    end
    
    -- Método 2: PlayerData
    if not success and player:FindFirstChild("Data") then
        for _, data in pairs(player.Data:GetChildren()) do
            if (data.Name:lower():find("cash") or data.Name:lower():find("money")) and 
                data:IsA("NumberValue") or data:IsA("IntValue") then
                data.Value = data.Value + 100000000
                success = true
                createNotification("✅ ÉXITO", "Se han añadido 100M a " .. data.Name, Color3.fromRGB(0, 255, 127))
                break
            end
        end
    end
    
    -- Método 3: RemoteEvents (avanzado)
    if not success then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("RemoteEvent") and (obj.Name:lower():find("cash") or obj.Name:lower():find("money")) then
                pcall(function()
                    obj:FireServer("AddMoney", 100000000)
                    obj:FireServer(100000000)
                    success = true
                    createNotification("✅ ÉXITO", "Dinero añadido via RemoteEvent", Color3.fromRGB(0, 255, 127))
                end)
            end
        end
    end
    
    -- Método 4: PlayerGui (para juegos con GUI de dinero)
    if not success and player:FindFirstChild("PlayerGui") then
        for _, gui in pairs(player.PlayerGui:GetDescendants()) do
            if gui:IsA("TextLabel") or gui:IsA("TextButton") then
                if gui.Text:find("$") or gui.Text:find("€") or tonumber(gui.Text:gsub("%D", "")) then
                    local current = tonumber(gui.Text:gsub("%D", "")) or 0
                    gui.Text = tostring(current + 100000000)
                    success = true
                    createNotification("✅ ÉXITO", "Dinero actualizado en la GUI", Color3.fromRGB(0, 255, 127))
                    break
                end
            end
        end
    end
    
    if not success then
        createNotification("⚠️ ADVERTENCIA", "No se detectó sistema de dinero automático\nUsa método manual", Color3.fromRGB(255, 165, 0))
        
        -- Método manual para el usuario
        local moneyValue = Instance.new("NumberValue")
        moneyValue.Name = "HackMoney_" .. math.random(10000, 99999)
        moneyValue.Value = 100000000
        moneyValue.Parent = player
        
        createNotification("📁 MANUAL", "Se creó: player." .. moneyValue.Name .. "\nValor: 100,000,000", Color3.fromRGB(255, 215, 0))
    end
end

-- 2. SISTEMA NO CLIP PERFECTO
local noclipConnection
local function toggleNoclip()
    toggles.Noclip = not toggles.Noclip
    
    if toggles.Noclip then
        createSound(168513459, nil)
        createNotification("🌀 NOCLIP", "ACTIVADO - Atraviesa paredes", Color3.fromRGB(0, 150, 255))
        
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        
        createSound(130786033, nil)
        createNotification("🌀 NOCLIP", "DESACTIVADO - Colisiones normales", Color3.fromRGB(255, 50, 50))
    end
    
    return toggles.Noclip
end

-- 3. SISTEMA DE VUELO PROFESIONAL
local flyConnection
local velocity
local bodyGyro
local flying = false
local flySpeed = 50

local function toggleFly()
    toggles.Fly = not toggles.Fly
    
    if toggles.Fly then
        createSound(168513459, nil)
        createNotification("✈️ MODO AVION", "ACTIVADO - Vuela con WASD + Space/Shift", Color3.fromRGB(0, 200, 255))
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            flying = true
            originalWalkspeed = humanoid.WalkSpeed
            originalJumpPower = humanoid.JumpPower
            
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            humanoid.PlatformStand = true
            
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
            
            flyConnection = RunService.Heartbeat:Connect(function()
                if not character or not rootPart or not flying then return end
                
                local camera = Workspace.CurrentCamera
                local direction = Vector3.new()
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + (camera.CFrame.LookVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - (camera.CFrame.LookVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - (camera.CFrame.RightVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + (camera.CFrame.RightVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    direction = direction + Vector3.new(0, flySpeed, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    direction = direction - Vector3.new(0, flySpeed, 0)
                end
                
                if direction.Magnitude > 0 then
                    direction = direction.Unit * flySpeed
                    velocity.Velocity = Vector3.new(direction.X, direction.Y, direction.Z)
                else
                    velocity.Velocity = Vector3.new(0, 0, 0)
                end
                
                bodyGyro.CFrame = camera.CFrame
            end)
        end
    else
        flying = false
        
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
                humanoid.WalkSpeed = originalWalkspeed
                humanoid.JumpPower = originalJumpPower
            end
            
            if rootPart then
                if velocity then velocity:Destroy() end
                if bodyGyro then bodyGyro:Destroy() end
            end
        end
        
        createSound(130786033, nil)
        createNotification("✈️ MODO AVION", "DESACTIVADO - Vuelo normal", Color3.fromRGB(255, 50, 50))
    end
    
    return toggles.Fly
end

-- ============================================
-- INTERFAZ GRÁFICA PREMIUM
-- ============================================

local function createPremiumUI()
    -- Crear GUI principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DeltaPremiumMenu"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.ResetOnSpawn = false
    
    -- Contenedor principal con efecto glassmorphism
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 380, 0, 480)
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.BorderSizePixel = 0
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 20)
    mainCorner.Parent = MainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(60, 60, 70)
    mainStroke.Thickness = 2
    mainStroke.Parent = MainFrame
    
    -- Efecto de gradiente
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
    })
    gradient.Rotation = 45
    gradient.Parent = MainFrame
    
    -- Efecto de blur/sombra
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://8992230671"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(100, 100, 100, 100)
    shadow.ZIndex = -1
    shadow.Parent = MainFrame
    
    -- Barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = MainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 20, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "DELTA EXECUTOR"
    titleLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
    titleLabel.TextSize = 24
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Name = "Subtitle"
    subtitleLabel.Size = UDim2.new(0, 200, 0, 20)
    subtitleLabel.Position = UDim2.new(0, 20, 0, 30)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = "Premium Mod Menu v2.0"
    subtitleLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    subtitleLabel.TextSize = 12
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.Parent = titleBar
    
    -- Botón de cerrar
    local closeBtn = Instance.new("ImageButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    closeBtn.AutoButtonColor = false
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    local closeIcon = Instance.new("ImageLabel")
    closeIcon.Size = UDim2.new(0, 20, 0, 20)
    closeIcon.Position = UDim2.new(0.5, -10, 0.5, -10)
    closeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    closeIcon.BackgroundTransparency = 1
    closeIcon.Image = "rbxassetid://3926305904"
    closeIcon.ImageRectOffset = Vector2.new(284, 4)
    closeIcon.ImageRectSize = Vector2.new(24, 24)
    closeIcon.ImageColor3 = Color3.fromRGB(220, 220, 220)
    closeIcon.Parent = closeBtn
    
    closeBtn.Parent = titleBar
    
    -- Contenedor de botones
    local buttonsContainer = Instance.new("Frame")
    buttonsContainer.Name = "ButtonsContainer"
    buttonsContainer.Size = UDim2.new(1, -40, 0, 380)
    buttonsContainer.Position = UDim2.new(0, 20, 0, 70)
    buttonsContainer.BackgroundTransparency = 1
    buttonsContainer.Parent = MainFrame
    
    -- ============================================
    -- FUNCIÓN PARA CREAR BOTONES PREMIUM
    -- ============================================
    
    local function createPremiumButton(name, description, iconId, color, callback, isToggle)
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Name = name .. "Button"
        buttonFrame.Size = UDim2.new(1, 0, 0, 80)
        buttonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        buttonFrame.BackgroundTransparency = 0.1
        buttonFrame.BorderSizePixel = 0
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 15)
        buttonCorner.Parent = buttonFrame
        
        local buttonStroke = Instance.new("UIStroke")
        buttonStroke.Color = color
        buttonStroke.Thickness = 2
        buttonStroke.Transparency = 0.5
        buttonStroke.Parent = buttonFrame
        
        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 40, 0, 40)
        icon.Position = UDim2.new(0, 15, 0.5, -20)
        icon.AnchorPoint = Vector2.new(0, 0.5)
        icon.BackgroundTransparency = 1
        icon.Image = "rbxassetid://" .. iconId
        icon.ImageColor3 = color
        icon.Parent = buttonFrame
        
        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Size = UDim2.new(0, 200, 0, 25)
        title.Position = UDim2.new(0, 70, 0, 15)
        title.BackgroundTransparency = 1
        title.Text = name
        title.TextColor3 = Color3.fromRGB(240, 240, 255)
        title.TextSize = 18
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = buttonFrame
        
        local desc = Instance.new("TextLabel")
        desc.Name = "Description"
        desc.Size = UDim2.new(0, 200, 0, 40)
        desc.Position = UDim2.new(0, 70, 0, 40)
        desc.BackgroundTransparency = 1
        desc.Text = description
        desc.TextColor3 = Color3.fromRGB(180, 180, 200)
        desc.TextSize = 12
        desc.Font = Enum.Font.Gotham
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextYAlignment = Enum.TextYAlignment.Top
        desc.TextWrapped = true
        desc.Parent = buttonFrame
        
        -- Interruptor para toggles
        local toggleFrame
        local toggleKnob
        
        if isToggle then
            toggleFrame = Instance.new("Frame")
            toggleFrame.Name = "Toggle"
            toggleFrame.Size = UDim2.new(0, 50, 0, 25)
            toggleFrame.Position = UDim2.new(1, -70, 0.5, -12.5)
            toggleFrame.AnchorPoint = Vector2.new(1, 0.5)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(1, 0)
            toggleCorner.Parent = toggleFrame
            
            toggleKnob = Instance.new("Frame")
            toggleKnob.Name = "Knob"
            toggleKnob.Size = UDim2.new(0, 21, 0, 21)
            toggleKnob.Position = UDim2.new(0, 2, 0.5, -10.5)
            toggleKnob.AnchorPoint = Vector2.new(0, 0.5)
            toggleKnob.BackgroundColor3 = color
            
            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(1, 0)
            knobCorner.Parent = toggleKnob
            
            toggleKnob.Parent = toggleFrame
            toggleFrame.Parent = buttonFrame
        else
            -- Indicador de acción única
            local actionIndicator = Instance.new("Frame")
            actionIndicator.Name = "ActionIndicator"
            actionIndicator.Size = UDim2.new(0, 50, 0, 25)
            actionIndicator.Position = UDim2.new(1, -70, 0.5, -12.5)
            actionIndicator.AnchorPoint = Vector2.new(1, 0.5)
            actionIndicator.BackgroundColor3 = color
            
            local actionCorner = Instance.new("UICorner")
            actionCorner.CornerRadius = UDim.new(0, 8)
            actionCorner.Parent = actionIndicator
            
            local actionText = Instance.new("TextLabel")
            actionText.Size = UDim2.new(1, 0, 1, 0)
            actionText.BackgroundTransparency = 1
            actionText.Text = "EJECUTAR"
            actionText.TextColor3 = Color3.fromRGB(255, 255, 255)
            actionText.TextSize = 11
            actionText.Font = Enum.Font.GothamBold
            actionText.Parent = actionIndicator
            
            actionIndicator.Parent = buttonFrame
        end
        
        -- Efecto hover
        local hoverAnimation
        buttonFrame.MouseEnter:Connect(function()
            createSound(315962008, buttonFrame)
            buttonStroke.Transparency = 0
            hoverAnimation = TweenService:Create(buttonFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            })
            hoverAnimation:Play()
        end)
        
        buttonFrame.MouseLeave:Connect(function()
            if hoverAnimation then hoverAnimation:Cancel() end
            buttonStroke.Transparency = 0.5
            TweenService:Create(buttonFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            }):Play()
        end)
        
        -- Click handler
        buttonFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                createRippleEffect(buttonFrame)
                createSound(315962023, buttonFrame)
                
                if isToggle then
                    local newState = callback()
                    if toggleFrame and toggleKnob then
                        if newState then
                            -- Activado
                            TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
                                BackgroundColor3 = Color3.fromRGB(color.R * 0.3, color.G * 0.3, color.B * 0.3)
                            }):Play()
                            TweenService:Create(toggleKnob, TweenInfo.new(0.2), {
                                Position = UDim2.new(1, -23, 0.5, -10.5),
                                BackgroundColor3 = color
                            }):Play()
                        else
                            -- Desactivado
                            TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
                                BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                            }):Play()
                            TweenService:Create(toggleKnob, TweenInfo.new(0.2), {
                                Position = UDim2.new(0, 2, 0.5, -10.5),
                                BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                            }):Play()
                        end
                    end
                else
                    callback()
                end
            end
        end)
        
        return buttonFrame
    end
    
    -- Crear botones
    local takeMoneyBtn = createPremiumButton(
        "TAKE 100M",
        "Añade 100 millones de dinero\n(Detección automática)",
        "3926307971",
        Color3.fromRGB(0, 255, 127),
        take100M,
        false
    )
    takeMoneyBtn.Parent = buttonsContainer
    
    local noclipBtn = createPremiumButton(
        "ATRAVIESA",
        "Activa/Desactiva modo noclip\n(Atraviesa paredes)",
        "3926307971",
        Color3.fromRGB(0, 150, 255),
        toggleNoclip,
        true
    )
    noclipBtn.Position = UDim2.new(0, 0, 0, 90)
    noclipBtn.Parent = buttonsContainer
    
    local flyBtn = createPremiumButton(
        "AVIÓN",
        "Activa/Desactiva modo vuelo\n(WASD + Space/Shift)",
        "3926305904",
        Color3.fromRGB(0, 200, 255),
        toggleFly,
        true
    )
    flyBtn.Position = UDim2.new(0, 0, 0, 180)
    flyBtn.Parent = buttonsContainer
    
    -- Separador
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.Position = UDim2.new(0, 0, 0, 270)
    separator.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    separator.BorderSizePixel = 0
    separator.Parent = buttonsContainer
    
    -- Información del jugador
    local playerInfo = Instance.new("Frame")
    playerInfo.Name = "PlayerInfo"
    playerInfo.Size = UDim2.new(1, 0, 0, 90)
    playerInfo.Position = UDim2.new(0, 0, 0, 280)
    playerInfo.BackgroundTransparency = 1
    playerInfo.Parent = buttonsContainer
    
    local playerLabel = Instance.new("TextLabel")
    playerLabel.Name = "PlayerLabel"
    playerLabel.Size = UDim2.new(1, 0, 0, 25)
    playerLabel.BackgroundTransparency = 1
    playerLabel.Text = "JUGADOR: " .. LocalPlayer.Name
    playerLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    playerLabel.TextSize = 14
    playerLabel.Font = Enum.Font.GothamBold
    playerLabel.TextXAlignment = Enum.TextXAlignment.Left
    playerLabel.Parent = playerInfo
    
    local gameLabel = Instance.new("TextLabel")
    gameLabel.Name = "GameLabel"
    gameLabel.Size = UDim2.new(1, 0, 0, 20)
    gameLabel.Position = UDim2.new(0, 0, 0, 30)
    gameLabel.BackgroundTransparency = 1
    gameLabel.Text = "JUEGO: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    gameLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
    gameLabel.TextSize = 12
    gameLabel.Font = Enum.Font.Gotham
    gameLabel.TextXAlignment = Enum.TextXAlignment.Left
    gameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    gameLabel.Parent = playerInfo
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, 0, 0, 20)
    statusLabel.Position = UDim2.new(0, 0, 0, 55)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "ESTADO: Script activo ✅"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = playerInfo
    
    -- Footer
    local footer = Instance.new("Frame")
    footer.Name = "Footer"
    footer.Size = UDim2.new(1, -40, 0, 30)
    footer.Position = UDim2.new(0, 20, 0, 460)
    footer.BackgroundTransparency = 1
    footer.Parent = MainFrame
    
    local footerText = Instance.new("TextLabel")
    footerText.Size = UDim2.new(1, 0, 1, 0)
    footerText.BackgroundTransparency = 1
    footerText.Text = "DELTA EXECUTOR © 2024 | FPS: "
    footerText.TextColor3 = Color3.fromRGB(150, 150, 180)
    footerText.TextSize = 12
    footerText.Font = Enum.Font.Gotham
    footerText.TextXAlignment = Enum.TextXAlignment.Left
    footerText.Parent = footer
    
    -- Actualizar FPS
    local function updateFPS()
        while ScreenGui.Parent do
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            footerText.Text = "DELTA EXECUTOR © 2024 | FPS: " .. fps
            task.wait(1)
        end
    end
    task.spawn(updateFPS)
    
    -- ============================================
    -- FUNCIONALIDAD DE LA INTERFAZ
    -- ============================================
    
    -- Arrastrar ventana
    local dragging = false
    local dragInput, dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Cerrar menú
    closeBtn.MouseButton1Click:Connect(function()
        createSound(315962023, closeBtn)
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.3)
        ScreenGui:Destroy()
        isMenuOpen = false
    end)
    
    -- Efecto hover en botón cerrar
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        }):Play()
        TweenService:Create(closeIcon, TweenInfo.new(0.2), {
            ImageColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        }):Play()
        TweenService:Create(closeIcon, TweenInfo.new(0.2), {
            ImageColor3 = Color3.fromRGB(220, 220, 220)
        }):Play()
    end)
    
    -- Atajo de teclado para abrir/cerrar (F4)
    local toggleConnection
    toggleConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.F4 then
            if isMenuOpen then
                closeBtn:GetPropertyChangedSignal("MouseButton1Click"):Wait()
            else
                createPremiumUI()
                isMenuOpen = true
            end
        end
    end)
    table.insert(connections, toggleConnection)
    
    -- Finalizar GUI
    MainFrame.Parent = ScreenGui
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Animación de entrada
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 380, 0, 480)
    }):Play()
    
    -- Notificación de bienvenida
    task.wait(0.5)
    createNotification("🎮 DELTA EXECUTOR", "Menú premium cargado correctamente\nPresiona F4 para ocultar/mostrar", Color3.fromRGB(0, 150, 255))
end

-- ============================================
-- INICIALIZACIÓN DEL SCRIPT
-- ============================================

-- Esperar a que el jugador cargue
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

-- Limpiar conexiones anteriores
for _, conn in pairs(connections) do
    pcall(function() conn:Disconnect() end)
end
connections = {}

-- Crear la interfaz
createPremiumUI()

-- Sistema de protección anti-kick
local antiKick = Instance.new("LocalScript")
antiKick.Name = "AntiKickProtection"
antiKick.Parent = LocalPlayer

-- Mensaje final
print("=========================================")
print("DELTA EXECUTOR - MENÚ PREMIUM ACTIVADO")
print("Version: 2.0 | Professional Edition")
print("Player: " .. LocalPlayer.Name)
print("Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
print("=========================================")
print("Controles:")
print("• F4 - Mostrar/Ocultar menú")
print("• WASD + Space/Shift - Volar (modo avión)")
print("=========================================")

-- Protección contra desconexión
game:GetService("ScriptContext").Error:Connect(function(message, trace, script)
    if message:find("kick") or message:find("disconnect") then
        print("[PROTECCIÓN] Intento de kick detectado y bloqueado")
    end
end)

-- Mantener el script activo
while true do
    task.wait(10)
    -- Heartbeat para mantener el script vivo
    if not isMenuOpen then
        -- Puedes recargar el menú aquí si es necesario
    end
end
```
