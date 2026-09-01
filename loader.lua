if not keyData then
        return false, "❌ Неверный ключ!"
    end
    
    if keyData.used then
        return false, "❌ Ключ уже использован!"
    end
    
    if os.time() > keyData.expires and keyData.expires ~= math.huge then
        return false, "⏰ Срок истёк!"
    end
    
    keyData.used = true
    ActiveKey = keyData
    TimerRunning = true
    
    local daysLeft = math.floor((keyData.expires - os.time()) / 86400)
    if keyData.expires == math.huge then
        return true, "✅ Доступ открыт навсегда!"
    end
    return true, "✅ Доступ открыт! (" .. daysLeft .. " дн.)"
end

-- ============================================
-- 🚀 ЗАГРУЗКА ОСНОВНОГО СКРИПТА
-- ============================================
local function LoadMainScript()
    ScreenGui:Destroy()
    BurgerButton:Destroy()
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/42a2bc214804ae20bf0604390151e443.lua"))()
end

-- ============================================
-- 🎯 ОБРАБОТЧИКИ
-- ============================================
ActivateButton.MouseButton1Click:Connect(function()
    local input = InputBox.Text
    
    if input == "" then
        StatusLabel.Text = "❌ Введите ключ!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        task.wait(1.5)
        StatusLabel.Text = ""
        return
    end
    
    local success, message = CheckKey(input)
    StatusLabel.Text = message
    StatusLabel.TextColor3 = success and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    
    if success then
        task.wait(0.8)
        
        spawn(function()
            while TimerRunning and ActiveKey do
                UpdateTimer()
                task.wait(1)
            end
        end)
        
        LoadMainScript()
    end
end)

InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        ActivateButton.MouseButton1Click:Fire()
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    BurgerButton:Destroy()
end)
