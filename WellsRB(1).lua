--[[
    WellsRB | Universal Luau Interface
    Version: 1.2.0

    Run in a client-side Luau environment. This script uses standard Roblox
    Instances and services; executor-specific APIs are only probed for GUI
    parenting. Compatibility with any particular injector is not guaranteed.

    Controls:
      RightShift / F4 - show or hide the window
      Fly: WASD / Space / LeftControl
      Freecam: mouse look, WASD, Space / LeftControl, LeftShift = boost
      Languages: RU / EN / UA in Settings
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    warn("[WellsRB] LocalPlayer is unavailable. Run this on the client.")
    return
end

local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
if not PlayerGui then
    warn("[WellsRB] PlayerGui is unavailable.")
    return
end

local Theme = {
    background = Color3.fromRGB(15, 15, 21),
    panel = Color3.fromRGB(22, 22, 30),
    card = Color3.fromRGB(29, 29, 40),
    cardHover = Color3.fromRGB(36, 35, 49),
    accent = Color3.fromRGB(139, 92, 246),
    accentDark = Color3.fromRGB(100, 65, 190),
    text = Color3.fromRGB(245, 245, 250),
    muted = Color3.fromRGB(148, 148, 166),
    off = Color3.fromRGB(62, 62, 78),
    line = Color3.fromRGB(54, 49, 72),
    green = Color3.fromRGB(91, 202, 142),
    red = Color3.fromRGB(238, 99, 115),
}

local Language = "EN"
local Translations = {
    RU = {
        ["Search features..."] = "Поиск функций...",
        ["UNIVERSAL GAME TOOLKIT  /  v1.2"] = "УНИВЕРСАЛЬНЫЙ НАБОР ИНСТРУМЕНТОВ / v1.1",
        ["WELLSRB  /  CLIENT UI"] = "WELLSRB  /  ИНТЕРФЕЙС",
        ["READY"] = "ГОТОВО",
        ["Ready"] = "Готово",
        ["Fly active"] = "Полёт активен",
        ["Freecam active"] = "Свободная камера активна",
        ["NO CHARACTER"] = "НЕТ ПЕРСОНАЖА",
        ["FPS"] = "FPS",
        ["XYZ"] = "XYZ",
        ["General"] = "Общее",
        ["Movement"] = "Движение",
        ["Visuals"] = "Графика",
        ["Player"] = "Персонаж",
        ["Utility"] = "Инструменты",
        ["Camera"] = "Камера",
        ["Settings"] = "Настройки",
        ["GENERAL"] = "ОБЩЕЕ",
        ["MOVEMENT"] = "ДВИЖЕНИЕ",
        ["VISUALS"] = "ГРАФИКА",
        ["PLAYER"] = "ПЕРСОНАЖ",
        ["UTILITY"] = "ИНСТРУМЕНТЫ",
        ["CAMERA"] = "КАМЕРА",
        ["SETTINGS"] = "НАСТРОЙКИ",
        ["A cleaner way to manage your session."] = "Удобное управление игровой сессией.",
        ["Movement controls and character handling."] = "Управление движением и персонажем.",
        ["Client-side visual preferences."] = "Локальные настройки графики.",
        ["Character information and tuning."] = "Информация и настройки персонажа.",
        ["Small tools for everyday gameplay."] = "Полезные инструменты для игры.",
        ["Camera controls and free movement."] = "Управление камерой и свободное перемещение.",
        ["Personalize the WellsRB interface."] = "Настрой внешний вид WellsRB.",
        ["WELCOME BACK"] = "С ВОЗВРАЩЕНИЕМ",
        ["WellsRB keeps the controls simple and organized."] = "Полезные функции собраны в одном месте.",
        ["Character status"] = "Состояние персонажа",
        ["Check whether your character is ready."] = "Проверить готовность персонажа.",
        ["CHECK"] = "ПРОВЕРИТЬ",
        ["UI animations"] = "Анимации интерфейса",
        ["Smooth transitions across the interface"] = "Плавные переходы и анимации.",
        ["Compact layout"] = "Компактный интерфейс",
        ["Reduce card spacing"] = "Уменьшить расстояние между карточками.",
        ["MOVEMENT"] = "ДВИЖЕНИЕ",
        ["WASD controls flight. Space rises; Left Ctrl descends."] = "WASD — движение; Space — вверх; Left Ctrl — вниз.",
        ["Fly"] = "Полёт",
        ["Client-side flight controller"] = "Локальное управление полётом.",
        ["Fly speed"] = "Скорость полёта",
        ["Flight movement speed"] = "Скорость перемещения в полёте.",
        ["Noclip"] = "Прохождение сквозь объекты",
        ["Temporarily disable character collisions locally"] = "Временно отключает столкновения персонажа локально.",
        ["Speed"] = "Скорость",
        ["Set the local humanoid WalkSpeed"] = "Изменить локальную скорость ходьбы.",
        ["Walk speed"] = "Скорость ходьбы",
        ["Applied while Speed is enabled"] = "Применяется при включённой функции Speed.",
        ["Jump boost"] = "Усиленный прыжок",
        ["Set the humanoid jump power"] = "Изменить силу прыжка.",
        ["Jump power"] = "Сила прыжка",
        ["Applied while Jump Boost is enabled"] = "Применяется при включённом усилении прыжка.",
        ["Infinite jump"] = "Бесконечный прыжок",
        ["Request another jump when jump input fires"] = "Позволяет повторно прыгать по нажатию кнопки.",
        ["VISUALS"] = "ГРАФИКА",
        ["Local lighting controls. Original values are restored on disable."] = "Локальные настройки освещения; исходные значения восстанавливаются.",
        ["Fullbright"] = "Полная яркость",
        ["Brighten the local scene and reduce fog"] = "Увеличить яркость и уменьшить туман локально.",
        ["Performance display"] = "Показ FPS",
        ["Show approximate client FPS in the header"] = "Показывать примерный FPS в заголовке.",
        ["Disable post effects"] = "Отключить постэффекты",
        ["Disable local blur, bloom and color effects"] = "Отключить локальные blur, bloom и цветовые эффекты.",
        ["PLAYER"] = "ПЕРСОНАЖ",
        ["Simple character information and controls."] = "Информация о персонаже и простые действия.",
        ["Position display"] = "Координаты персонажа",
        ["Show approximate coordinates in the header"] = "Показывать приблизительные координаты в заголовке.",
        ["Refresh character"] = "Обновить персонажа",
        ["Reacquire Humanoid and root part."] = "Повторно найти Humanoid и корневую часть.",
        ["REFRESH"] = "ОБНОВИТЬ",
        ["QUICK TOOLS"] = "БЫСТРЫЕ ИНСТРУМЕНТЫ",
        ["Utilities for the current client session."] = "Инструменты для текущей клиентской сессии.",
        ["Stop movement features"] = "Остановить функции движения",
        ["Disable Fly, Noclip, Speed and jump helpers."] = "Отключить полёт, Noclip, скорость и прыжки.",
        ["STOP ALL"] = "ОТКЛЮЧИТЬ",
        ["Restore visual effects"] = "Восстановить графику",
        ["Restore lighting and post-processing settings."] = "Восстановить освещение и постэффекты.",
        ["Lighting and post effects are already restored."] = "Освещение и постэффекты уже восстановлены.",
        ["Restore lighting"] = "Восстановить освещение",
        ["Restore original local lighting values."] = "Вернуть исходные локальные параметры освещения.",
        ["RESTORE"] = "ВЕРНУТЬ",
        ["CAMERA TOOLS"] = "ИНСТРУМЕНТЫ КАМЕРЫ",
        ["Freecam"] = "Свободная камера",
        ["Move the camera independently of your character."] = "Перемещать камеру независимо от персонажа.",
        ["Mouse look; WASD move; Space/Ctrl up and down."] = "Мышь — обзор; WASD — движение; Space/Ctrl — вверх/вниз.",
        ["Freecam speed"] = "Скорость свободной камеры",
        ["Camera movement speed; hold Shift to boost."] = "Скорость камеры; удерживай Shift для ускорения.",
        ["Camera FOV"] = "Угол обзора камеры",
        ["Adjust the local camera field of view."] = "Изменить локальный угол обзора.",
        ["Reset camera FOV"] = "Сбросить угол обзора",
        ["Restore the FOV captured when WellsRB started."] = "Вернуть угол обзора на момент запуска WellsRB.",
        ["RESET"] = "СБРОС",
        ["PREFERENCES"] = "НАСТРОЙКИ",
        ["Interface preferences for this session."] = "Настройки интерфейса для текущей сессии.",
        ["Interface language"] = "Язык интерфейса",
        ["Choose the WellsRB menu language."] = "Выбери язык меню WellsRB.",
        ["UI scale"] = "Масштаб интерфейса",
        ["Adjust interface scale percentage"] = "Изменить масштаб интерфейса в процентах.",
        ["Notifications"] = "Уведомления",
        ["Show small status toasts"] = "Показывать небольшие уведомления.",
        ["Remember interface"] = "Сохранять интерфейс при возрождении",
        ["Keep the menu alive after character respawn"] = "Не сбрасывать меню после возрождения персонажа.",
        ["Recenter window"] = "Вернуть окно в центр",
        ["Return the window to the center of the screen."] = "Переместить окно в центр экрана.",
        ["RECENTER"] = "ПО ЦЕНТРУ",
        ["Close WellsRB"] = "Закрыть WellsRB",
        ["Stop active features and remove the interface."] = "Отключить функции и удалить интерфейс.",
        ["CLOSE"] = "ЗАКРЫТЬ",
        ["Language changed"] = "Язык изменён",
        ["Menu language updated."] = "Язык меню обновлён.",
        ["Character is not ready."] = "Персонаж ещё не готов.",
        ["Camera is not ready."] = "Камера ещё не готова.",
        ["Disable post effects enabled"] = "Отключение постэффектов включено",
        ["Post effects restored"] = "Постэффекты восстановлены",
        ["WellsRB loaded"] = "WellsRB загружен",
        ["Press RightShift or F4 to hide/show the menu."] = "RightShift или F4 — скрыть/показать меню.",
        ["Character unavailable"] = "Персонаж недоступен",
        ["Wait for your character to spawn."] = "Дождись появления персонажа.",
        ["Character refreshed"] = "Персонаж обновлён",
        ["Humanoid and root part found."] = "Humanoid и корневая часть найдены.",
        ["Lighting restored"] = "Освещение восстановлено",
        ["Fullbright enabled"] = "Полная яркость включена",
        ["Fly enabled — WASD / Space / Ctrl"] = "Полёт включён — WASD / Space / Ctrl",
        ["Fly disabled"] = "Полёт выключен",
        ["Freecam enabled — RightShift opens the menu and stops Freecam."] = "Свободная камера включена — RightShift открывает меню и выключает её.",
        ["Freecam disabled"] = "Свободная камера выключена",
        ["Noclip enabled"] = "Noclip включён",
        ["Noclip disabled"] = "Noclip выключен",
        ["Speed enabled"] = "Ускорение включено",
        ["Speed disabled"] = "Ускорение выключено",
        ["Jump boost enabled"] = "Усиленный прыжок включён",
        ["Jump boost disabled"] = "Усиленный прыжок выключен",
        ["Infinite jump enabled"] = "Бесконечный прыжок включён",
        ["Infinite jump disabled"] = "Бесконечный прыжок выключен",
        ["Movement features stopped."] = "Функции движения отключены.",
        ["Lighting is already restored."] = "Исходное освещение уже восстановлено.",
        ["Fullbright disabled"] = "Полная яркость выключена",
        ["Position display enabled"] = "Показ координат включён",
        ["Position display disabled"] = "Показ координат выключен",
        ["Performance display enabled"] = "Показ FPS включён",
        ["Performance display disabled"] = "Показ FPS выключен",
        ["Character ready"] = "Персонаж готов",
        ["Health %.0f  •  Position %.0f, %.0f, %.0f"] = "Здоровье %.0f • Координаты %.0f, %.0f, %.0f",
        ["WASD / Space / Ctrl"] = "WASD / Space / Ctrl",
    },
    UA = {
        ["Search features..."] = "Пошук функцій...",
        ["UNIVERSAL GAME TOOLKIT  /  v1.2"] = "УНІВЕРСАЛЬНИЙ НАБІР ІНСТРУМЕНТІВ / v1.1",
        ["WELLSRB  /  CLIENT UI"] = "WELLSRB  /  ІНТЕРФЕЙС",
        ["READY"] = "ГОТОВО",
        ["Ready"] = "Готово",
        ["Fly active"] = "Політ активний",
        ["Freecam active"] = "Вільна камера активна",
        ["NO CHARACTER"] = "НЕМАЄ ПЕРСОНАЖА",
        ["FPS"] = "FPS",
        ["XYZ"] = "XYZ",
        ["General"] = "Загальне",
        ["Movement"] = "Рух",
        ["Visuals"] = "Графіка",
        ["Player"] = "Персонаж",
        ["Utility"] = "Інструменти",
        ["Camera"] = "Камера",
        ["Settings"] = "Налаштування",
        ["GENERAL"] = "ЗАГАЛЬНЕ",
        ["MOVEMENT"] = "РУХ",
        ["VISUALS"] = "ГРАФІКА",
        ["PLAYER"] = "ПЕРСОНАЖ",
        ["UTILITY"] = "ІНСТРУМЕНТИ",
        ["CAMERA"] = "КАМЕРА",
        ["SETTINGS"] = "НАЛАШТУВАННЯ",
        ["A cleaner way to manage your session."] = "Зручне керування ігровою сесією.",
        ["Movement controls and character handling."] = "Керування рухом і персонажем.",
        ["Client-side visual preferences."] = "Локальні налаштування графіки.",
        ["Character information and tuning."] = "Інформація та налаштування персонажа.",
        ["Small tools for everyday gameplay."] = "Корисні ігрові інструменти.",
        ["Camera controls and free movement."] = "Керування камерою та вільний рух.",
        ["Personalize the WellsRB interface."] = "Налаштуй вигляд WellsRB.",
        ["WELCOME BACK"] = "З ПОВЕРНЕННЯМ",
        ["WellsRB keeps the controls simple and organized."] = "Корисні функції зібрані в одному місці.",
        ["Character status"] = "Стан персонажа",
        ["Check whether your character is ready."] = "Перевірити готовність персонажа.",
        ["CHECK"] = "ПЕРЕВІРИТИ",
        ["UI animations"] = "Анімації інтерфейсу",
        ["Smooth transitions across the interface"] = "Плавні переходи та анімації.",
        ["Compact layout"] = "Компактний інтерфейс",
        ["Reduce card spacing"] = "Зменшити відстань між картками.",
        ["WASD controls flight. Space rises; Left Ctrl descends."] = "WASD — рух; Space — вгору; Left Ctrl — вниз.",
        ["Fly"] = "Політ",
        ["Client-side flight controller"] = "Локальне керування польотом.",
        ["Fly speed"] = "Швидкість польоту",
        ["Flight movement speed"] = "Швидкість переміщення в польоті.",
        ["Noclip"] = "Проходження крізь об'єкти",
        ["Temporarily disable character collisions locally"] = "Тимчасово вимикає локальні зіткнення персонажа.",
        ["Speed"] = "Швидкість",
        ["Set the local humanoid WalkSpeed"] = "Змінити локальну швидкість ходьби.",
        ["Walk speed"] = "Швидкість ходьби",
        ["Applied while Speed is enabled"] = "Застосовується, коли Speed увімкнено.",
        ["Jump boost"] = "Посилений стрибок",
        ["Set the humanoid jump power"] = "Змінити силу стрибка.",
        ["Jump power"] = "Сила стрибка",
        ["Applied while Jump Boost is enabled"] = "Застосовується, коли посилений стрибок увімкнено.",
        ["Infinite jump"] = "Нескінченний стрибок",
        ["Request another jump when jump input fires"] = "Дозволяє повторно стрибати кнопкою стрибка.",
        ["Local lighting controls. Original values are restored on disable."] = "Локальне освітлення; початкові значення відновлюються.",
        ["Fullbright"] = "Максимальна яскравість",
        ["Brighten the local scene and reduce fog"] = "Збільшити яскравість і зменшити туман локально.",
        ["Performance display"] = "Показ FPS",
        ["Show approximate client FPS in the header"] = "Показувати приблизний FPS у заголовку.",
        ["Disable post effects"] = "Вимкнути постефекти",
        ["Disable local blur, bloom and color effects"] = "Вимкнути локальні blur, bloom і кольорові ефекти.",
        ["Simple character information and controls."] = "Інформація про персонажа та прості дії.",
        ["Position display"] = "Координати персонажа",
        ["Show approximate coordinates in the header"] = "Показувати приблизні координати в заголовку.",
        ["Refresh character"] = "Оновити персонажа",
        ["Reacquire Humanoid and root part."] = "Повторно знайти Humanoid і кореневу частину.",
        ["REFRESH"] = "ОНОВИТИ",
        ["QUICK TOOLS"] = "ШВИДКІ ІНСТРУМЕНТИ",
        ["Utilities for the current client session."] = "Інструменти для поточної клієнтської сесії.",
        ["Stop movement features"] = "Зупинити функції руху",
        ["Disable Fly, Noclip, Speed and jump helpers."] = "Вимкнути політ, Noclip, швидкість і стрибки.",
        ["STOP ALL"] = "ВИМКНУТИ ВСЕ",
        ["Restore visual effects"] = "Відновити графіку",
        ["Restore lighting and post-processing settings."] = "Відновити освітлення та постефекти.",
        ["Lighting and post effects are already restored."] = "Освітлення та постефекти вже відновлено.",
        ["Restore lighting"] = "Відновити освітлення",
        ["Restore original local lighting values."] = "Повернути початкові локальні налаштування освітлення.",
        ["RESTORE"] = "ВІДНОВИТИ",
        ["CAMERA TOOLS"] = "ІНСТРУМЕНТИ КАМЕРИ",
        ["Freecam"] = "Вільна камера",
        ["Move the camera independently of your character."] = "Переміщувати камеру незалежно від персонажа.",
        ["Mouse look; WASD move; Space/Ctrl up and down."] = "Миша — огляд; WASD — рух; Space/Ctrl — вгору/вниз.",
        ["Freecam speed"] = "Швидкість вільної камери",
        ["Camera movement speed; hold Shift to boost."] = "Швидкість камери; утримуй Shift для прискорення.",
        ["Camera FOV"] = "Кут огляду камери",
        ["Adjust the local camera field of view."] = "Змінити локальний кут огляду.",
        ["Reset camera FOV"] = "Скинути кут огляду",
        ["Restore the FOV captured when WellsRB started."] = "Повернути кут огляду на момент запуску WellsRB.",
        ["RESET"] = "СКИНУТИ",
        ["PREFERENCES"] = "НАЛАШТУВАННЯ",
        ["Interface preferences for this session."] = "Налаштування інтерфейсу для поточної сесії.",
        ["Interface language"] = "Мова інтерфейсу",
        ["Choose the WellsRB menu language."] = "Обери мову меню WellsRB.",
        ["UI scale"] = "Масштаб інтерфейсу",
        ["Adjust interface scale percentage"] = "Змінити масштаб інтерфейсу у відсотках.",
        ["Notifications"] = "Сповіщення",
        ["Show small status toasts"] = "Показувати невеликі сповіщення.",
        ["Remember interface"] = "Зберігати інтерфейс після відродження",
        ["Keep the menu alive after character respawn"] = "Не скидати меню після відродження персонажа.",
        ["Recenter window"] = "Повернути вікно в центр",
        ["Return the window to the center of the screen."] = "Перемістити вікно в центр екрана.",
        ["RECENTER"] = "ПО ЦЕНТРУ",
        ["Close WellsRB"] = "Закрити WellsRB",
        ["Stop active features and remove the interface."] = "Вимкнути функції та видалити інтерфейс.",
        ["CLOSE"] = "ЗАКРИТИ",
        ["Language changed"] = "Мову змінено",
        ["Menu language updated."] = "Мову меню оновлено.",
        ["Character is not ready."] = "Персонаж ще не готовий.",
        ["Camera is not ready."] = "Камера ще не готова.",
        ["Disable post effects enabled"] = "Вимкнення постефектів увімкнено",
        ["Post effects restored"] = "Постефекти відновлено",
        ["WellsRB loaded"] = "WellsRB завантажено",
        ["Press RightShift or F4 to hide/show the menu."] = "RightShift або F4 — сховати/показати меню.",
        ["Character unavailable"] = "Персонаж недоступний",
        ["Wait for your character to spawn."] = "Дочекайся появи персонажа.",
        ["Character refreshed"] = "Персонажа оновлено",
        ["Humanoid and root part found."] = "Humanoid і кореневу частину знайдено.",
        ["Lighting restored"] = "Освітлення відновлено",
        ["Fullbright enabled"] = "Максимальну яскравість увімкнено",
        ["Fly enabled — WASD / Space / Ctrl"] = "Політ увімкнено — WASD / Space / Ctrl",
        ["Fly disabled"] = "Політ вимкнено",
        ["Freecam enabled — RightShift opens the menu and stops Freecam."] = "Вільну камеру ввімкнено — RightShift відкриває меню та вимикає її.",
        ["Freecam disabled"] = "Вільну камеру вимкнено",
        ["Noclip enabled"] = "Noclip увімкнено",
        ["Noclip disabled"] = "Noclip вимкнено",
        ["Speed enabled"] = "Прискорення увімкнено",
        ["Speed disabled"] = "Прискорення вимкнено",
        ["Jump boost enabled"] = "Посилений стрибок увімкнено",
        ["Jump boost disabled"] = "Посилений стрибок вимкнено",
        ["Infinite jump enabled"] = "Нескінченний стрибок увімкнено",
        ["Infinite jump disabled"] = "Нескінченний стрибок вимкнено",
        ["Movement features stopped."] = "Функції руху вимкнено.",
        ["Lighting is already restored."] = "Початкове освітлення вже відновлено.",
        ["Position display enabled"] = "Показ координат увімкнено",
        ["Position display disabled"] = "Показ координат вимкнено",
        ["Performance display enabled"] = "Показ FPS увімкнено",
        ["Performance display disabled"] = "Показ FPS вимкнено",
        ["Character ready"] = "Персонаж готовий",
        ["Health %.0f  •  Position %.0f, %.0f, %.0f"] = "Здоров'я %.0f • Координати %.0f, %.0f, %.0f",
    },
}


-- Supplemental localization for less common cards and status messages.
local ExtraTranslations = {
    RU = {
        ["UNIVERSAL GAME TOOLKIT  /  v1.2"] = "УНИВЕРСАЛЬНЫЙ НАБОР ИНСТРУМЕНТОВ / v1.2",
        ["Restore visual effects"] = "Восстановить визуальные эффекты",
        ["Restore lighting and post-processing settings."] = "Вернуть исходное освещение и постэффекты.",
        ["Lighting and post effects are already restored."] = "Освещение и постэффекты уже восстановлены.",
        ["Function error"] = "Ошибка функции",
        [" failed. See console."] = " не сработала. Подробности в консоли.",
        ["Your tools, one clean interface."] = "Все инструменты в одном удобном интерфейсе.",
        ["A cleaner way to manage your session."] = "Удобное управление игровой сессией.",
        ["WellsRB tools."] = "Инструменты WellsRB.",
        ["Simple character information and controls."] = "Информация о персонаже и простые действия.",
        ["Freecam enabled — RightShift opens the menu and stops Freecam."] = "Свободная камера включена — RightShift возвращает меню и отключает камеру.",
        ["Character has not spawned yet."] = "Персонаж ещё не появился.",
        ["Lighting and post effects are already restored."] = "Освещение и постэффекты уже восстановлены.",
        ["Health %.0f  •  Position %.0f, %.0f, %.0f"] = "Здоровье %.0f • Координаты %.0f, %.0f, %.0f",
        ["Your tools, one clean interface."] = "Все инструменты в одном удобном интерфейсе.",
    },
    UA = {
        ["UNIVERSAL GAME TOOLKIT  /  v1.2"] = "УНІВЕРСАЛЬНИЙ НАБІР ІНСТРУМЕНТІВ / v1.2",
        ["Restore visual effects"] = "Відновити візуальні ефекти",
        ["Restore lighting and post-processing settings."] = "Повернути початкове освітлення та постефекти.",
        ["Lighting and post effects are already restored."] = "Освітлення та постефекти вже відновлено.",
        ["Function error"] = "Помилка функції",
        [" failed. See console."] = " не спрацювала. Подробиці в консолі.",
        ["Your tools, one clean interface."] = "Усі інструменти в одному зручному інтерфейсі.",
        ["A cleaner way to manage your session."] = "Зручне керування ігровою сесією.",
        ["WellsRB tools."] = "Інструменти WellsRB.",
        ["Simple character information and controls."] = "Інформація про персонажа та прості дії.",
        ["Freecam enabled — RightShift opens the menu and stops Freecam."] = "Вільну камеру ввімкнено — RightShift повертає меню та вимикає камеру.",
        ["Character has not spawned yet."] = "Персонаж ще не з'явився.",
        ["Health %.0f  •  Position %.0f, %.0f, %.0f"] = "Здоров'я %.0f • Координати %.0f, %.0f, %.0f",
    },
}

for languageCode, entries in pairs(ExtraTranslations) do
    for sourceText, translatedText in pairs(entries) do
        Translations[languageCode][sourceText] = translatedText
    end
end

local function tr(text)
    if type(text) ~= "string" then return text end
    local dictionary = Translations[Language]
    return dictionary and dictionary[text] or text
end

local State = {
    fly = false,
    freecam = false,
    noclip = false,
    speed = false,
    jumpBoost = false,
    infiniteJump = false,
    fullbright = false,
    postEffects = false,
    coordinates = false,
    performance = false,
    notifications = true,
    animations = true,
    compact = false,
    remember = true,
}

local Values = {
    walkSpeed = 32,
    jumpPower = 75,
    flySpeed = 55,
    freecamSpeed = 70,
    cameraFov = workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView or 70,
    uiScale = 100,
}

local Connections = {}
local Controls = {}
local updateScale
local RegisteredCards = {}
local CurrentCategory = "General"
local WindowVisible = true
local Destroyed = false
local Dragging = false
local DragInput = nil
local DragStart = nil
local DragStartPosition = nil

local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(Connections, connection)
    return connection
end

local function safeDisconnect(connection)
    if connection then
        pcall(function() connection:Disconnect() end)
    end
end

local function getGuiParent()
    -- Several injectors expose gethui(); normal client contexts usually do not.
    local ok, hui = pcall(function()
        if type(gethui) == "function" then
            return gethui()
        end
        return nil
    end)
    if ok and hui then
        return hui
    end

    -- Fall back to PlayerGui, which is the normal Roblox client UI container.
    return PlayerGui
end

local GuiParent = getGuiParent()
local existing = GuiParent:FindFirstChild("WellsRB")
if existing then
    pcall(function() existing:Destroy() end)
end

local function make(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties or {}) do
        if (property == "Text" or property == "PlaceholderText") and type(value) == "string" then
            value = tr(value)
        end
        object[property] = value
    end
    object.Parent = parent
    return object
end

local function round(object, radius)
    make("UICorner", { CornerRadius = UDim.new(0, radius or 10) }, object)
end

local function stroke(object, color, transparency, thickness)
    return make("UIStroke", {
        Color = color or Theme.line,
        Transparency = transparency or 0,
        Thickness = thickness or 1,
    }, object)
end

local function animate(object, duration, properties)
    if not State.animations then
        for property, value in pairs(properties) do
            pcall(function() object[property] = value end)
        end
        return nil
    end

    local ok, tween = pcall(function()
        return TweenService:Create(
            object,
            TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            properties
        )
    end)
    if ok and tween then
        tween:Play()
        return tween
    end
    return nil
end

local function getCharacter()
    return LocalPlayer.Character
end

local function getHumanoid()
    local character = getCharacter()
    return character and character:FindFirstChildOfClass("Humanoid") or nil
end

local function getRoot()
    local character = getCharacter()
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
end

local GUI = make("ScreenGui", {
    Name = "WellsRB",
    ResetOnSpawn = not State.remember,
    IgnoreGuiInset = true,
    DisplayOrder = 999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, GuiParent)

local UIScale = make("UIScale", { Scale = 1 }, GUI)

local Main = make("Frame", {
    Name = "Window",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.fromOffset(740, 490),
    BackgroundColor3 = Theme.background,
    BorderSizePixel = 0,
}, GUI)
round(Main, 15)
stroke(Main, Theme.line, 0.2, 1)

local Header = make("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 64),
    BackgroundColor3 = Theme.panel,
    BorderSizePixel = 0,
}, Main)
round(Header, 15)
make("Frame", {
    Position = UDim2.new(0, 0, 1, -15),
    Size = UDim2.new(1, 0, 0, 15),
    BackgroundColor3 = Theme.panel,
    BorderSizePixel = 0,
}, Header)

local Logo = make("Frame", {
    Position = UDim2.fromOffset(17, 15),
    Size = UDim2.fromOffset(34, 34),
    BackgroundColor3 = Theme.accent,
    BorderSizePixel = 0,
}, Header)
round(Logo, 10)
make("TextLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "W",
    TextColor3 = Theme.text,
    Font = Enum.Font.GothamBold,
    TextSize = 21,
}, Logo)

make("TextLabel", {
    Position = UDim2.fromOffset(62, 11),
    Size = UDim2.fromOffset(250, 25),
    BackgroundTransparency = 1,
    Text = "WellsRB",
    TextColor3 = Theme.text,
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Header)
local HeaderSubtitle = make("TextLabel", {
    Position = UDim2.fromOffset(63, 36),
    Size = UDim2.fromOffset(260, 15),
    BackgroundTransparency = 1,
    Text = "UNIVERSAL GAME TOOLKIT  /  v1.2",
    TextColor3 = Theme.muted,
    Font = Enum.Font.GothamMedium,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Header)

local StatusPill = make("Frame", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -58, 0.5, 0),
    Size = UDim2.fromOffset(105, 26),
    BackgroundColor3 = Theme.card,
    BorderSizePixel = 0,
}, Header)
round(StatusPill, 13)
local StatusDot = make("Frame", {
    Position = UDim2.fromOffset(10, 10),
    Size = UDim2.fromOffset(6, 6),
    BackgroundColor3 = Theme.green,
    BorderSizePixel = 0,
}, StatusPill)
round(StatusDot, 10)
local StatusText = make("TextLabel", {
    Position = UDim2.fromOffset(22, 0),
    Size = UDim2.new(1, -25, 1, 0),
    BackgroundTransparency = 1,
    Text = "READY",
    TextColor3 = Theme.text,
    Font = Enum.Font.GothamBold,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left,
}, StatusPill)

local HideButton = make("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -15, 0.5, 0),
    Size = UDim2.fromOffset(28, 28),
    BackgroundColor3 = Theme.card,
    Text = "—",
    TextColor3 = Theme.text,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    AutoButtonColor = false,
    BorderSizePixel = 0,
}, Header)
round(HideButton, 8)

local Sidebar = make("Frame", {
    Position = UDim2.fromOffset(13, 77),
    Size = UDim2.new(0, 166, 1, -90),
    BackgroundColor3 = Theme.panel,
    BorderSizePixel = 0,
}, Main)
round(Sidebar, 11)
make("UIPadding", {
    PaddingTop = UDim.new(0, 12),
    PaddingLeft = UDim.new(0, 9),
    PaddingRight = UDim.new(0, 9),
}, Sidebar)
make("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, Sidebar)

local SidebarCaption = make("TextLabel", {
    Position = UDim2.new(0, 27, 1, -35),
    Size = UDim2.new(0, 140, 0, 18),
    BackgroundTransparency = 1,
    Text = "WELLSRB  /  CLIENT UI",
    TextColor3 = Theme.muted,
    Font = Enum.Font.GothamMedium,
    TextSize = 8,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Main)

local Content = make("Frame", {
    Position = UDim2.fromOffset(192, 77),
    Size = UDim2.new(1, -205, 1, -90),
    BackgroundTransparency = 1,
}, Main)

local SearchBox = make("Frame", {
    Size = UDim2.new(1, 0, 0, 37),
    BackgroundColor3 = Theme.panel,
    BorderSizePixel = 0,
}, Content)
round(SearchBox, 9)
make("TextLabel", {
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.fromOffset(22, 37),
    BackgroundTransparency = 1,
    Text = "/",
    TextColor3 = Theme.accent,
    Font = Enum.Font.GothamBold,
    TextSize = 17,
}, SearchBox)
local Search = make("TextBox", {
    Position = UDim2.fromOffset(35, 0),
    Size = UDim2.new(1, -45, 1, 0),
    BackgroundTransparency = 1,
    PlaceholderText = "Search features...",
    PlaceholderColor3 = Theme.muted,
    Text = "",
    TextColor3 = Theme.text,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Left,
}, SearchBox)

local PageTitle = make("TextLabel", {
    Position = UDim2.fromOffset(2, 47),
    Size = UDim2.new(1, -4, 0, 28),
    BackgroundTransparency = 1,
    Text = "General",
    TextColor3 = Theme.text,
    Font = Enum.Font.GothamBold,
    TextSize = 19,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Content)
local PageSubtitle = make("TextLabel", {
    Position = UDim2.fromOffset(2, 72),
    Size = UDim2.new(1, -4, 0, 17),
    BackgroundTransparency = 1,
    Text = "Your tools, one clean interface.",
    TextColor3 = Theme.muted,
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
}, Content)

local Cards = make("ScrollingFrame", {
    Position = UDim2.fromOffset(0, 96),
    Size = UDim2.new(1, 0, 1, -96),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Theme.accent,
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, Content)
make("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, Cards)

local ToastHolder = make("Frame", {
    Name = "Toasts",
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -18, 0, 18),
    Size = UDim2.fromOffset(285, 220),
    BackgroundTransparency = 1,
}, GUI)
make("UIListLayout", {
    Padding = UDim.new(0, 8),
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    SortOrder = Enum.SortOrder.LayoutOrder,
}, ToastHolder)

local function notify(title, message)
    if not State.notifications or Destroyed then return end

    local toast = make("Frame", {
        Size = UDim2.fromOffset(270, 64),
        BackgroundColor3 = Theme.panel,
        BackgroundTransparency = 0.04,
        BorderSizePixel = 0,
    }, ToastHolder)
    round(toast, 10)
    stroke(toast, Theme.line, 0.15, 1)

    make("Frame", {
        Size = UDim2.new(0, 3, 1, -18),
        Position = UDim2.fromOffset(0, 9),
        BackgroundColor3 = Theme.accent,
        BorderSizePixel = 0,
    }, toast)

    make("TextLabel", {
        Position = UDim2.fromOffset(13, 9),
        Size = UDim2.new(1, -24, 0, 20),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.text,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, toast)
    make("TextLabel", {
        Position = UDim2.fromOffset(13, 30),
        Size = UDim2.new(1, -24, 0, 24),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = Theme.muted,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, toast)

    toast.Position = UDim2.fromOffset(18, 0)
    toast.BackgroundTransparency = 1
    animate(toast, 0.2, {
        Position = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 0.04,
    })

    task.delay(2.8, function()
        if toast and toast.Parent then
            animate(toast, 0.18, {
                Position = UDim2.fromOffset(18, 0),
                BackgroundTransparency = 1,
            })
            task.delay(0.2, function()
                if toast and toast.Parent then toast:Destroy() end
            end)
        end
    end)
end

-- Player controls
local FlyConnection = nil
local FreecamConnection = nil
local NoclipConnection = nil
local InfiniteJumpConnection = nil
local PerformanceConnection = nil
local CoordinateConnection = nil
local PostEffectsConnection = nil
local FlyVelocity = nil
local FlyGyro = nil
local SpeedOriginal = nil
local JumpOriginal = nil
local NoclipOriginal = {}
local LightingOriginal = nil
local PostEffectsOriginal = {}
local FreecamOriginal = nil
local FreecamPosition = nil
local FreecamYaw = 0
local FreecamPitch = 0
local OriginalCameraFov = workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView or 70
local LastFPSUpdate = 0
local FrameCount = 0
local CurrentFPS = 0

local function setStatus(text, color)
    StatusText.Text = string.upper(tr(text))
    StatusDot.BackgroundColor3 = color or Theme.green
end

local function applyWalkSpeed()
    local humanoid = getHumanoid()
    if humanoid and State.speed then
        humanoid.WalkSpeed = Values.walkSpeed
    end
end

local function setSpeed(enabled)
    local humanoid = getHumanoid()
    if enabled then
        if not humanoid then
            State.speed = false
            if Controls.speed then Controls.speed.Set(false, true) end
            notify("WellsRB", "Character is not ready.")
            return
        end
        SpeedOriginal = humanoid.WalkSpeed
        State.speed = true
        humanoid.WalkSpeed = Values.walkSpeed
        notify("Movement", "Speed enabled")
    else
        State.speed = false
        if humanoid and SpeedOriginal ~= nil then
            humanoid.WalkSpeed = SpeedOriginal
        end
        SpeedOriginal = nil
        notify("Movement", "Speed disabled")
    end
end

local function applyJumpPower()
    local humanoid = getHumanoid()
    if humanoid and State.jumpBoost then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = Values.jumpPower
    end
end

local function setJumpBoost(enabled)
    local humanoid = getHumanoid()
    if enabled then
        if not humanoid then
            State.jumpBoost = false
            if Controls.jumpBoost then Controls.jumpBoost.Set(false, true) end
            notify("WellsRB", "Character is not ready.")
            return
        end
        JumpOriginal = {
            useJumpPower = humanoid.UseJumpPower,
            jumpPower = humanoid.JumpPower,
            jumpHeight = humanoid.JumpHeight,
        }
        State.jumpBoost = true
        humanoid.UseJumpPower = true
        humanoid.JumpPower = Values.jumpPower
        notify("Movement", "Jump boost enabled")
    else
        State.jumpBoost = false
        if humanoid and JumpOriginal then
            humanoid.UseJumpPower = JumpOriginal.useJumpPower
            humanoid.JumpPower = JumpOriginal.jumpPower
            humanoid.JumpHeight = JumpOriginal.jumpHeight
        end
        JumpOriginal = nil
        notify("Movement", "Jump boost disabled")
    end
end

local function setFly(enabled)
    if not enabled then
        State.fly = false
        safeDisconnect(FlyConnection)
        FlyConnection = nil

        if FlyVelocity then
            pcall(function() FlyVelocity:Destroy() end)
            FlyVelocity = nil
        end
        if FlyGyro then
            pcall(function() FlyGyro:Destroy() end)
            FlyGyro = nil
        end

        local humanoid = getHumanoid()
        if humanoid then
            pcall(function()
                humanoid.PlatformStand = false
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end)
        end
        setStatus("Ready", Theme.green)
        notify("Movement", "Fly disabled")
        return
    end

    local humanoid = getHumanoid()
    local root = getRoot()
    if not humanoid or not root then
        State.fly = false
        if Controls.fly then Controls.fly.Set(false, true) end
        notify("WellsRB", "Character is not ready.")
        return
    end

    -- Keep character flight and independent camera movement mutually exclusive.
    if State.freecam and Controls.freecam then
        Controls.freecam.Set(false, false)
    end

    -- Create local movement controllers; a game's server may still override client motion.
    State.fly = true
    FlyVelocity = Instance.new("BodyVelocity")
    FlyVelocity.Name = "WellsRB_FlyVelocity"
    FlyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    FlyVelocity.P = 2e4
    FlyVelocity.Velocity = Vector3.zero
    FlyVelocity.Parent = root

    FlyGyro = Instance.new("BodyGyro")
    FlyGyro.Name = "WellsRB_FlyGyro"
    FlyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    FlyGyro.P = 2e4
    FlyGyro.CFrame = workspace.CurrentCamera and workspace.CurrentCamera.CFrame or root.CFrame
    FlyGyro.Parent = root

    humanoid.PlatformStand = true
    setStatus("Fly active", Theme.accent)

    FlyConnection = RunService.RenderStepped:Connect(function()
        if not State.fly then return end
        local currentRoot = getRoot()
        local currentHumanoid = getHumanoid()
        local camera = workspace.CurrentCamera

        if not currentRoot or not currentHumanoid or not camera
            or not FlyVelocity or not FlyGyro then
            return
        end

        local direction = Vector3.zero
        local cameraCF = camera.CFrame

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction += cameraCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction -= cameraCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction += cameraCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction -= cameraCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction += Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
            or UserInputService:IsKeyDown(Enum.KeyCode.C) then
            direction -= Vector3.new(0, 1, 0)
        end

        if direction.Magnitude > 0 then
            FlyVelocity.Velocity = direction.Unit * Values.flySpeed
        else
            FlyVelocity.Velocity = Vector3.zero
        end

        FlyGyro.CFrame = cameraCF
    end)

    notify("Movement", "Fly enabled — WASD / Space / Ctrl")
end

local function setFreecam(enabled)
    if not enabled then
        State.freecam = false
        safeDisconnect(FreecamConnection)
        FreecamConnection = nil

        local original = FreecamOriginal
        FreecamOriginal = nil
        if original then
            pcall(function()
                UserInputService.MouseBehavior = original.mouseBehavior
                UserInputService.MouseIconEnabled = original.mouseIconEnabled
            end)
            for camera, cameraState in pairs(original.cameras) do
                if camera and camera.Parent then
                    pcall(function()
                        camera.CameraSubject = cameraState.subject
                        camera.CameraType = cameraState.cameraType
                        if cameraState.cameraType == Enum.CameraType.Scriptable then
                            camera.CFrame = cameraState.cframe
                        end
                    end)
                end
            end
        end

        if not Destroyed then
            setStatus("Ready", Theme.green)
            notify("Camera", "Freecam disabled")
        end
        return
    end

    local camera = workspace.CurrentCamera
    if not camera then
        State.freecam = false
        if Controls.freecam then Controls.freecam.Set(false, true) end
        notify("WellsRB", "Camera is not ready.")
        return
    end

    if State.freecam and FreecamConnection then
        return
    end

    if State.fly and Controls.fly then
        Controls.fly.Set(false, false)
    end

    FreecamOriginal = {
        cameras = {},
        mouseBehavior = UserInputService.MouseBehavior,
        mouseIconEnabled = UserInputService.MouseIconEnabled,
    }
    FreecamOriginal.cameras[camera] = {
        cameraType = camera.CameraType,
        subject = camera.CameraSubject,
        cframe = camera.CFrame,
    }

    FreecamPosition = camera.CFrame.Position
    local look = camera.CFrame.LookVector
    FreecamYaw = math.atan2(-look.X, -look.Z)
    FreecamPitch = math.asin(math.clamp(look.Y, -0.999, 0.999))
    State.freecam = true

    camera.CameraType = Enum.CameraType.Scriptable
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    UserInputService.MouseIconEnabled = false
    setStatus("Freecam active", Theme.accent)

    FreecamConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if not State.freecam then return end
        local activeCamera = workspace.CurrentCamera
        if not activeCamera then return end

        if not FreecamOriginal.cameras[activeCamera] then
            FreecamOriginal.cameras[activeCamera] = {
                cameraType = activeCamera.CameraType,
                subject = activeCamera.CameraSubject,
                cframe = activeCamera.CFrame,
            }
            activeCamera.CameraType = Enum.CameraType.Scriptable
        elseif activeCamera.CameraType ~= Enum.CameraType.Scriptable then
            activeCamera.CameraType = Enum.CameraType.Scriptable
        end

        -- Mouse look is kept on the client; clamp pitch to avoid flipping over.
        local mouseDelta = Vector2.zero
        pcall(function()
            mouseDelta = UserInputService:GetMouseDelta()
        end)
        local sensitivity = 0.0025
        FreecamYaw -= mouseDelta.X * sensitivity
        FreecamPitch = math.clamp(FreecamPitch - mouseDelta.Y * sensitivity, -1.52, 1.52)

        local rotation = CFrame.fromOrientation(FreecamPitch, FreecamYaw, 0)
        local direction = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += rotation.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= rotation.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += rotation.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= rotation.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
            or UserInputService:IsKeyDown(Enum.KeyCode.C) then
            direction -= Vector3.yAxis
        end

        local speed = Values.freecamSpeed
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            speed *= 2.25
        end

        if direction.Magnitude > 0 then
            FreecamPosition += direction.Unit * speed * math.clamp(deltaTime, 0, 0.1)
        end
        activeCamera.CFrame = CFrame.new(FreecamPosition) * rotation
    end)

    notify("Camera", "Freecam enabled — RightShift opens the menu and stops Freecam.")
    -- Freecam captures the mouse; hide the menu so it does not block the view.
    -- RightShift/F4 brings the menu back and setWindowVisible() restores the camera.
    WindowVisible = false
    Main.Visible = false
end

local function setCameraFov(value)
    Values.cameraFov = math.clamp(value, 50, 120)
    local camera = workspace.CurrentCamera
    if camera then
        pcall(function() camera.FieldOfView = Values.cameraFov end)
    end
end

local function setPostEffects(enabled)
    State.postEffects = enabled
    safeDisconnect(PostEffectsConnection)
    PostEffectsConnection = nil

    if enabled then
        table.clear(PostEffectsOriginal)
        local function disableEffect(object)
            if object:IsA("PostEffect") then
                if PostEffectsOriginal[object] == nil then
                    PostEffectsOriginal[object] = object.Enabled
                end
                object.Enabled = false
            end
        end

        for _, object in ipairs(Lighting:GetDescendants()) do
            disableEffect(object)
        end
        PostEffectsConnection = Lighting.DescendantAdded:Connect(function(object)
            if State.postEffects then
                disableEffect(object)
            end
        end)
        notify("Visuals", "Disable post effects enabled")
    else
        for object, wasEnabled in pairs(PostEffectsOriginal) do
            if object and object.Parent then
                pcall(function() object.Enabled = wasEnabled end)
            end
        end
        table.clear(PostEffectsOriginal)
        notify("Visuals", "Post effects restored")
    end
end

local function restoreNoclip()
    safeDisconnect(NoclipConnection)
    NoclipConnection = nil

    for part, canCollide in pairs(NoclipOriginal) do
        if part and part.Parent then
            pcall(function() part.CanCollide = canCollide end)
        end
    end
    table.clear(NoclipOriginal)
end

local function setNoclip(enabled)
    if not enabled then
        State.noclip = false
        restoreNoclip()
        notify("Movement", "Noclip disabled")
        return
    end

    if not getCharacter() then
        State.noclip = false
        if Controls.noclip then Controls.noclip.Set(false, true) end
        notify("WellsRB", "Character is not ready.")
        return
    end

    State.noclip = true
    NoclipConnection = RunService.Stepped:Connect(function()
        local character = getCharacter()
        if not character or not State.noclip then return end

        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                if NoclipOriginal[part] == nil then
                    NoclipOriginal[part] = part.CanCollide
                end
                part.CanCollide = false
            end
        end
    end)

    notify("Movement", "Noclip enabled")
end

local function setInfiniteJump(enabled)
    State.infiniteJump = enabled
    safeDisconnect(InfiniteJumpConnection)
    InfiniteJumpConnection = nil

    if enabled then
        InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            if not State.infiniteJump then return end
            local humanoid = getHumanoid()
            if humanoid and humanoid.Health > 0 then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        notify("Movement", "Infinite jump enabled")
    else
        notify("Movement", "Infinite jump disabled")
    end
end

local function setFullbright(enabled)
    State.fullbright = enabled

    if enabled then
        if not LightingOriginal then
            LightingOriginal = {
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime,
                FogEnd = Lighting.FogEnd,
                GlobalShadows = Lighting.GlobalShadows,
                Ambient = Lighting.Ambient,
                OutdoorAmbient = Lighting.OutdoorAmbient,
            }
        end
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1000000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(180, 180, 180)
        Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
        notify("Visuals", "Fullbright enabled")
    else
        if LightingOriginal then
            for property, value in pairs(LightingOriginal) do
                pcall(function() Lighting[property] = value end)
            end
        end
        LightingOriginal = nil
        notify("Visuals", "Lighting restored")
    end
end

local function setCoordinates(enabled)
    State.coordinates = enabled
    safeDisconnect(CoordinateConnection)
    CoordinateConnection = nil

    if enabled then
        CoordinateConnection = RunService.RenderStepped:Connect(function()
            if not State.coordinates or Destroyed then return end
            local root = getRoot()
            if root then
                StatusText.Text = string.format("%s %.0f %.0f %.0f", tr("XYZ"), root.Position.X, root.Position.Y, root.Position.Z)
            else
                StatusText.Text = tr("NO CHARACTER")
            end
        end)
        notify("Utility", "Position display enabled")
    else
        setStatus(State.fly and "Fly active" or "Ready", State.fly and Theme.accent or Theme.green)
        notify("Utility", "Position display disabled")
    end
end

local function setPerformance(enabled)
    State.performance = enabled
    safeDisconnect(PerformanceConnection)
    PerformanceConnection = nil

    if enabled then
        FrameCount = 0
        LastFPSUpdate = os.clock()
        PerformanceConnection = RunService.RenderStepped:Connect(function()
            FrameCount += 1
            local now = os.clock()
            if now - LastFPSUpdate >= 1 then
                CurrentFPS = math.floor(FrameCount / (now - LastFPSUpdate) + 0.5)
                FrameCount = 0
                LastFPSUpdate = now
                if not State.coordinates then
                    StatusText.Text = tr("FPS") .. " " .. tostring(CurrentFPS)
                end
            end
        end)
        notify("Utility", "Performance display enabled")
    else
        if not State.coordinates then
            setStatus(State.fly and "Fly active" or "Ready", State.fly and Theme.accent or Theme.green)
        end
        notify("Utility", "Performance display disabled")
    end
end

-- UI builders
local function registerCard(name, description, object)
    table.insert(RegisteredCards, {
        name = string.lower(name),
        description = string.lower(description),
        translatedName = string.lower(tr(name)),
        translatedDescription = string.lower(tr(description)),
        object = object,
    })
end

local function applySearch()
    local query = string.lower(Search.Text or "")
    for _, item in ipairs(RegisteredCards) do
        item.object.Visible = query == ""
            or string.find(item.name, query, 1, true) ~= nil
            or string.find(item.description, query, 1, true) ~= nil
            or string.find(item.translatedName, query, 1, true) ~= nil
            or string.find(item.translatedDescription, query, 1, true) ~= nil
    end
end

local function addSection(title, description)
    local section = make("Frame", {
        Size = UDim2.new(1, -4, 0, 49),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, Cards)
    make("TextLabel", {
        Position = UDim2.fromOffset(4, 5),
        Size = UDim2.new(1, -8, 0, 20),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.accent,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, section)
    make("TextLabel", {
        Position = UDim2.fromOffset(4, 25),
        Size = UDim2.new(1, -8, 0, 17),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = Theme.muted,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, section)
    registerCard(title, description, section)
end

local function addToggle(name, description, stateKey, callback)
    local enabled = State[stateKey] == true
    local card = make("Frame", {
        Size = UDim2.new(1, -4, 0, 63),
        BackgroundColor3 = Theme.panel,
        BorderSizePixel = 0,
    }, Cards)
    round(card, 10)

    local title = make("TextLabel", {
        Position = UDim2.fromOffset(13, 9),
        Size = UDim2.new(1, -90, 0, 21),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.text,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    local desc = make("TextLabel", {
        Position = UDim2.fromOffset(13, 32),
        Size = UDim2.new(1, -90, 0, 17),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = Theme.muted,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, card)

    local track = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -13, 0.5, 0),
        Size = UDim2.fromOffset(43, 23),
        BackgroundColor3 = enabled and Theme.accent or Theme.off,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
    }, card)
    round(track, 20)
    local knob = make("Frame", {
        Position = enabled and UDim2.new(1, -20, 0, 3) or UDim2.fromOffset(3, 3),
        Size = UDim2.fromOffset(17, 17),
        BackgroundColor3 = Color3.fromRGB(250, 250, 252),
        BorderSizePixel = 0,
    }, track)
    round(knob, 20)

    local function set(value, silent)
        enabled = value == true
        State[stateKey] = enabled
        animate(track, 0.18, {
            BackgroundColor3 = enabled and Theme.accent or Theme.off,
        })
        animate(knob, 0.18, {
            Position = enabled and UDim2.new(1, -20, 0, 3) or UDim2.fromOffset(3, 3),
        })
        if not silent and callback then
            local ok, err = pcall(callback, enabled)
            if not ok then
                warn("[WellsRB] " .. name .. ": " .. tostring(err))
                notify("Function error", tr(name) .. tr(" failed. See console."))
            end
        end
    end

    track.Activated:Connect(function()
        set(not enabled, false)
    end)

    Controls[stateKey] = { Set = set, Get = function() return enabled end }
    registerCard(name, description, card)
    return Controls[stateKey]
end

local function addSlider(name, description, valueKey, minimum, maximum, callback)
    local initial = Values[valueKey]
    local card = make("Frame", {
        Size = UDim2.new(1, -4, 0, 79),
        BackgroundColor3 = Theme.panel,
        BorderSizePixel = 0,
    }, Cards)
    round(card, 10)

    make("TextLabel", {
        Position = UDim2.fromOffset(13, 8),
        Size = UDim2.new(1, -78, 0, 21),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.text,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    local valueLabel = make("TextLabel", {
        Position = UDim2.new(1, -63, 0, 8),
        Size = UDim2.fromOffset(50, 21),
        BackgroundTransparency = 1,
        Text = tostring(initial),
        TextColor3 = Theme.accent,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, card)

    make("TextLabel", {
        Position = UDim2.fromOffset(13, 30),
        Size = UDim2.new(1, -25, 0, 16),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = Theme.muted,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    local bar = make("Frame", {
        Position = UDim2.new(0, 13, 1, -17),
        Size = UDim2.new(1, -26, 0, 4),
        BackgroundColor3 = Theme.off,
        BorderSizePixel = 0,
    }, card)
    round(bar, 4)

    local startFraction = math.clamp((initial - minimum) / (maximum - minimum), 0, 1)
    local fill = make("Frame", {
        Size = UDim2.new(startFraction, 0, 1, 0),
        BackgroundColor3 = Theme.accent,
        BorderSizePixel = 0,
    }, bar)
    round(fill, 4)
    local sliderKnob = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(startFraction, 0, 0.5, 0),
        Size = UDim2.fromOffset(12, 12),
        BackgroundColor3 = Color3.fromRGB(250, 250, 252),
        BorderSizePixel = 0,
    }, bar)
    round(sliderKnob, 10)

    local hitbox = make("TextButton", {
        Position = UDim2.new(0, -4, 0.5, -11),
        Size = UDim2.new(1, 8, 0, 22),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
    }, bar)

    local draggingSlider = false
    local inputChangedConnection
    local inputEndedConnection

    local function updateFromX(x)
        local width = math.max(bar.AbsoluteSize.X, 1)
        local fraction = math.clamp((x - bar.AbsolutePosition.X) / width, 0, 1)
        local newValue = math.floor(minimum + fraction * (maximum - minimum) + 0.5)
        Values[valueKey] = newValue
        valueLabel.Text = tostring(newValue)
        animate(fill, 0.06, { Size = UDim2.new(fraction, 0, 1, 0) })
        animate(sliderKnob, 0.06, { Position = UDim2.new(fraction, 0, 0.5, 0) })
        if callback then
            local ok, err = pcall(callback, newValue)
            if not ok then warn("[WellsRB] Slider " .. name .. ": " .. tostring(err)) end
        end
    end

    hitbox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            updateFromX(input.Position.X)
        end
    end)

    inputChangedConnection = UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            updateFromX(input.Position.X)
        end
    end)
    inputEndedConnection = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)

    card.Destroying:Connect(function()
        safeDisconnect(inputChangedConnection)
        safeDisconnect(inputEndedConnection)
    end)

    registerCard(name, description, card)
end

local function addButton(name, description, buttonText, callback)
    local card = make("Frame", {
        Size = UDim2.new(1, -4, 0, 63),
        BackgroundColor3 = Theme.panel,
        BorderSizePixel = 0,
    }, Cards)
    round(card, 10)
    make("TextLabel", {
        Position = UDim2.fromOffset(13, 8),
        Size = UDim2.new(1, -130, 0, 21),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.text,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    make("TextLabel", {
        Position = UDim2.fromOffset(13, 31),
        Size = UDim2.new(1, -130, 0, 16),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = Theme.muted,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    local button = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(99, 30),
        BackgroundColor3 = Theme.accentDark,
        Text = buttonText,
        TextColor3 = Theme.text,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        AutoButtonColor = false,
        BorderSizePixel = 0,
    }, card)
    round(button, 8)
    button.Activated:Connect(function()
        if callback then callback() end
    end)
    button.MouseEnter:Connect(function()
        animate(button, 0.12, { BackgroundColor3 = Theme.accent })
    end)
    button.MouseLeave:Connect(function()
        animate(button, 0.12, { BackgroundColor3 = Theme.accentDark })
    end)
    registerCard(name, description, card)
end

local render
local selectCategory
local setLanguage

local function addLanguageSelector()
    local card = make("Frame", {
        Size = UDim2.new(1, -4, 0, 64),
        BackgroundColor3 = Theme.panel,
        BorderSizePixel = 0,
    }, Cards)
    round(card, 10)

    make("TextLabel", {
        Position = UDim2.fromOffset(13, 10),
        Size = UDim2.new(1, -205, 0, 20),
        BackgroundTransparency = 1,
        Text = "Interface language",
        TextColor3 = Theme.text,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    make("TextLabel", {
        Position = UDim2.fromOffset(13, 33),
        Size = UDim2.new(1, -205, 0, 17),
        BackgroundTransparency = 1,
        Text = "Choose the WellsRB menu language.",
        TextColor3 = Theme.muted,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    local choices = {
        { code = "RU", label = "RU" },
        { code = "EN", label = "EN" },
        { code = "UA", label = "UA" },
    }
    for index, choice in ipairs(choices) do
        local button = make("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -(12 + (3 - index) * 58), 0.5, 0),
            Size = UDim2.fromOffset(52, 29),
            BackgroundColor3 = Language == choice.code and Theme.accent or Theme.card,
            Text = choice.label,
            TextColor3 = Theme.text,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            AutoButtonColor = false,
            BorderSizePixel = 0,
        }, card)
        round(button, 8)
        button.Activated:Connect(function()
            if setLanguage then setLanguage(choice.code) end
        end)
    end
    registerCard("Interface language", "Choose the WellsRB menu language.", card)
end

render = function(category)
    CurrentCategory = category
    for _, child in ipairs(Cards:GetChildren()) do
        if child:IsA("GuiObject") then child:Destroy() end
    end
    table.clear(RegisteredCards)

    PageTitle.Text = tr(category)
    Search.Text = ""

    local subtitles = {
        General = "A cleaner way to manage your session.",
        Movement = "Movement controls and character handling.",
        Visuals = "Client-side visual preferences.",
        Player = "Character information and tuning.",
        Utility = "Small tools for everyday gameplay.",
        Camera = "Camera controls and free movement.",
        Settings = "Personalize the WellsRB interface.",
    }
    PageSubtitle.Text = tr(subtitles[category] or "WellsRB tools.")

    if category == "General" then
        addSection("WELCOME BACK", "WellsRB keeps the controls simple and organized.")
        addButton("Character status", "Check whether your character is ready.", "CHECK", function()
            local humanoid = getHumanoid()
            local root = getRoot()
            if humanoid and root then
                notify("Character ready", string.format(tr("Health %.0f  •  Position %.0f, %.0f, %.0f"), humanoid.Health, root.Position.X, root.Position.Y, root.Position.Z))
            else
                notify("Character unavailable", "Wait for your character to spawn.")
            end
        end)
        addToggle("UI animations", "Smooth transitions across the interface", "animations", nil)
        addToggle("Compact layout", "Reduce card spacing", "compact", function(value)
            local layout = Cards:FindFirstChildOfClass("UIListLayout")
            if layout then layout.Padding = UDim.new(0, value and 5 or 8) end
        end)

    elseif category == "Movement" then
        addSection("MOVEMENT", "WASD controls flight. Space rises; Left Ctrl descends.")
        addToggle("Fly", "Client-side flight controller", "fly", setFly)
        addSlider("Fly speed", "Flight movement speed", "flySpeed", 10, 120, function(value)
            Values.flySpeed = value
        end)
        addToggle("Noclip", "Temporarily disable character collisions locally", "noclip", setNoclip)
        addToggle("Speed", "Set the local humanoid WalkSpeed", "speed", setSpeed)
        addSlider("Walk speed", "Applied while Speed is enabled", "walkSpeed", 8, 120, function(value)
            Values.walkSpeed = value
            if State.speed then applyWalkSpeed() end
        end)
        addToggle("Jump boost", "Set the humanoid jump power", "jumpBoost", setJumpBoost)
        addSlider("Jump power", "Applied while Jump Boost is enabled", "jumpPower", 20, 150, function(value)
            Values.jumpPower = value
            if State.jumpBoost then applyJumpPower() end
        end)
        addToggle("Infinite jump", "Request another jump when jump input fires", "infiniteJump", setInfiniteJump)

    elseif category == "Visuals" then
        addSection("VISUALS", "Local lighting controls. Original values are restored on disable.")
        addToggle("Fullbright", "Brighten the local scene and reduce fog", "fullbright", setFullbright)
        addToggle("Disable post effects", "Disable local blur, bloom and color effects", "postEffects", setPostEffects)
        addToggle("Performance display", "Show approximate client FPS in the header", "performance", setPerformance)

    elseif category == "Camera" then
        addSection("CAMERA TOOLS", "Mouse look; WASD move; Space/Ctrl up and down.")
        addToggle("Freecam", "Move the camera independently of your character.", "freecam", setFreecam)
        addSlider("Freecam speed", "Camera movement speed; hold Shift to boost.", "freecamSpeed", 10, 200, function(value)
            Values.freecamSpeed = value
        end)
        addSlider("Camera FOV", "Adjust the local camera field of view.", "cameraFov", 50, 120, setCameraFov)
        addButton("Reset camera FOV", "Restore the FOV captured when WellsRB started.", "RESET", function()
            Values.cameraFov = OriginalCameraFov
            setCameraFov(OriginalCameraFov)
            if selectCategory then selectCategory("Camera") end
        end)

    elseif category == "Player" then
        addSection("PLAYER", "Simple character information and controls.")
        addToggle("Position display", "Show approximate coordinates in the header", "coordinates", setCoordinates)
        addButton("Refresh character", "Reacquire Humanoid and root part.", "REFRESH", function()
            local humanoid = getHumanoid()
            local root = getRoot()
            if humanoid and root then
                notify("Character refreshed", "Humanoid and root part found.")
            else
                notify("Character unavailable", "Character has not spawned yet.")
            end
        end)

    elseif category == "Utility" then
        addSection("QUICK TOOLS", "Utilities for the current client session.")
        addButton("Stop movement features", "Disable Fly, Noclip, Speed and jump helpers.", "STOP ALL", function()
            if Controls.fly then Controls.fly.Set(false) end
            if Controls.noclip then Controls.noclip.Set(false) end
            if Controls.speed then Controls.speed.Set(false) end
            if Controls.jumpBoost then Controls.jumpBoost.Set(false) end
            if Controls.infiniteJump then Controls.infiniteJump.Set(false) end
            notify("WellsRB", "Movement features stopped.")
        end)
        addButton("Restore visual effects", "Restore lighting and post-processing settings.", "RESTORE", function()
            local restored = false
            if State.fullbright then
                if Controls.fullbright then Controls.fullbright.Set(false) else setFullbright(false) end
                restored = true
            end
            if State.postEffects then
                if Controls.postEffects then Controls.postEffects.Set(false) else setPostEffects(false) end
                restored = true
            end
            if not restored then
                notify("Visuals", "Lighting and post effects are already restored.")
            end
        end)

    elseif category == "Settings" then
        addSection("PREFERENCES", "Interface preferences for this session.")
        addLanguageSelector()
        addSlider("UI scale", "Adjust interface scale percentage", "uiScale", 75, 110, function(value)
            Values.uiScale = value
            if updateScale then updateScale() end
        end)
        addToggle("Notifications", "Show small status toasts", "notifications", nil)
        addToggle("Remember interface", "Keep the menu alive after character respawn", "remember", function(value)
            GUI.ResetOnSpawn = not value
        end)
        addButton("Recenter window", "Return the window to the center of the screen.", "RECENTER", function()
            animate(Main, 0.22, {
                Position = UDim2.new(0.5, 0, 0.5, 0),
            })
        end)
        addButton("Close WellsRB", "Stop active features and remove the interface.", "CLOSE", function()
            if Controls.fly then Controls.fly.Set(false) end
            if Controls.noclip then Controls.noclip.Set(false) end
            if Controls.speed then Controls.speed.Set(false) end
            if Controls.jumpBoost then Controls.jumpBoost.Set(false) end
            if Controls.infiniteJump then Controls.infiniteJump.Set(false) end
            if Controls.fullbright then Controls.fullbright.Set(false) end
            if Controls.performance then Controls.performance.Set(false) end
            if Controls.coordinates then Controls.coordinates.Set(false) end
            GUI:Destroy()
        end)
    end

    local cardLayout = Cards:FindFirstChildOfClass("UIListLayout")
    if cardLayout then cardLayout.Padding = UDim.new(0, State.compact and 5 or 8) end
    applySearch()
end

local CategoryButtons = {}
local categoryLabels = {
    General = "GENERAL",
    Movement = "MOVEMENT",
    Visuals = "VISUALS",
    Player = "PLAYER",
    Utility = "UTILITY",
    Camera = "CAMERA",
    Settings = "SETTINGS",
}

selectCategory = function(category)
    for name, button in pairs(CategoryButtons) do
        local selected = name == category
        animate(button, 0.14, {
            BackgroundColor3 = selected and Theme.accentDark or Theme.panel,
        })
        local label = button:FindFirstChildOfClass("TextLabel")
        if label then
            label.Text = tr(categoryLabels[name] or string.upper(name))
            label.TextColor3 = selected and Theme.text or Theme.muted
        end
        local indicator = button:FindFirstChild("Indicator")
        if indicator then
            animate(indicator, 0.14, {
                BackgroundTransparency = selected and 0 or 1,
            })
        end
    end
    render(category)
end

setLanguage = function(code)
    if not Translations[code] and code ~= "EN" then return end
    Language = code
    HeaderSubtitle.Text = tr("UNIVERSAL GAME TOOLKIT  /  v1.2")
    SidebarCaption.Text = tr("WELLSRB  /  CLIENT UI")
    Search.PlaceholderText = tr("Search features...")
    for name, button in pairs(CategoryButtons) do
        local label = button:FindFirstChildOfClass("TextLabel")
        if label then label.Text = tr(categoryLabels[name] or string.upper(name)) end
    end
    if State.coordinates then
        local root = getRoot()
        if root then
            StatusText.Text = string.format("%s %.0f %.0f %.0f", tr("XYZ"), root.Position.X, root.Position.Y, root.Position.Z)
        else
            StatusText.Text = tr("NO CHARACTER")
        end
    elseif State.performance then
        StatusText.Text = tr("FPS") .. " " .. tostring(CurrentFPS)
    elseif State.freecam then
        setStatus("Freecam active", Theme.accent)
    elseif State.fly then
        setStatus("Fly active", Theme.accent)
    else
        setStatus("Ready", Theme.green)
    end
    selectCategory(CurrentCategory)
    notify("Language changed", "Menu language updated.")
end

for index, category in ipairs({ "General", "Movement", "Visuals", "Player", "Camera", "Utility", "Settings" }) do
    local button = make("TextButton", {
        LayoutOrder = index,
        Size = UDim2.new(1, 0, 0, 37),
        BackgroundColor3 = category == "General" and Theme.accentDark or Theme.panel,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
    }, Sidebar)
    round(button, 8)

    local indicator = make("Frame", {
        Name = "Indicator",
        Position = UDim2.new(0, 0, 0.5, -9),
        Size = UDim2.fromOffset(3, 18),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = category == "General" and 0 or 1,
        BorderSizePixel = 0,
    }, button)
    round(indicator, 3)

    make("TextLabel", {
        Position = UDim2.fromOffset(13, 0),
        Size = UDim2.new(1, -18, 1, 0),
        BackgroundTransparency = 1,
        Text = categoryLabels[category] or string.upper(category),
        TextColor3 = category == "General" and Theme.text or Theme.muted,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, button)

    CategoryButtons[category] = button
    button.Activated:Connect(function()
        selectCategory(category)
    end)
    button.MouseEnter:Connect(function()
        if CurrentCategory ~= category then
            animate(button, 0.12, { BackgroundColor3 = Theme.cardHover })
        end
    end)
    button.MouseLeave:Connect(function()
        if CurrentCategory ~= category then
            animate(button, 0.12, { BackgroundColor3 = Theme.panel })
        end
    end)
end

connect(Search:GetPropertyChangedSignal("Text"), applySearch)

-- Dragging header; the hide button does not initiate a drag.
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        local mousePosition = input.Position
        local isOnHide = HideButton.AbsolutePosition.X <= mousePosition.X
            and mousePosition.X <= HideButton.AbsolutePosition.X + HideButton.AbsoluteSize.X
            and HideButton.AbsolutePosition.Y <= mousePosition.Y
            and mousePosition.Y <= HideButton.AbsolutePosition.Y + HideButton.AbsoluteSize.Y
        if isOnHide then return end

        Dragging = true
        DragStart = input.Position
        DragStartPosition = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        DragInput = input
    end
end)

connect(UserInputService.InputChanged, function(input)
    if not Dragging or input ~= DragInput or not DragStartPosition then return end
    local delta = input.Position - DragStart
    Main.Position = UDim2.new(
        DragStartPosition.X.Scale,
        DragStartPosition.X.Offset + delta.X,
        DragStartPosition.Y.Scale,
        DragStartPosition.Y.Offset + delta.Y
    )
end)

local function setWindowVisible(visible)
    WindowVisible = visible
    if visible then
        -- Freecam locks the mouse to the center, so opening the UI stops it
        -- and restores the cursor before the player interacts with controls.
        if State.freecam and Controls.freecam then
            Controls.freecam.Set(false, false)
        end
        Main.Visible = true
        Main.BackgroundTransparency = 1
        animate(Main, 0.18, { BackgroundTransparency = 0 })
    else
        Main.Visible = false
    end
end

HideButton.Activated:Connect(function()
    setWindowVisible(false)
end)

connect(UserInputService.InputBegan, function(input, processed)
    if processed or Destroyed then return end
    if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.F4 then
        setWindowVisible(not WindowVisible)
    end
end)

-- Rebind safe movement defaults after respawn. Fly and noclip stop automatically.
connect(LocalPlayer.CharacterRemoving, function()
    if State.fly and Controls.fly then Controls.fly.Set(false) end
    if State.noclip and Controls.noclip then Controls.noclip.Set(false) end
    if State.speed and Controls.speed then Controls.speed.Set(false) end
    if State.jumpBoost and Controls.jumpBoost then Controls.jumpBoost.Set(false) end
end)

connect(LocalPlayer.CharacterAdded, function(character)
    task.spawn(function()
        character:WaitForChild("Humanoid", 10)
        task.wait(0.15)
        if Destroyed then return end
        if State.speed then applyWalkSpeed() end
        if State.jumpBoost then applyJumpPower() end
    end)
end)

-- Stop any active controllers if the UI is externally destroyed.
GUI.Destroying:Connect(function()
    if Destroyed then return end
    Destroyed = true
    pcall(function() setFly(false) end)
    pcall(function() setFreecam(false) end)
    pcall(function() setNoclip(false) end)
    pcall(function() setSpeed(false) end)
    pcall(function() setJumpBoost(false) end)
    pcall(function() setInfiniteJump(false) end)
    pcall(function() setFullbright(false) end)
    pcall(function() setPostEffects(false) end)
    pcall(function() setCameraFov(OriginalCameraFov) end)
    pcall(function() setCoordinates(false) end)
    pcall(function() setPerformance(false) end)
    for _, connection in ipairs(Connections) do
        safeDisconnect(connection)
    end
    table.clear(Connections)
end)

-- Fit the window on smaller screens.
updateScale = function()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    local scale = math.min(viewport.X / 800, viewport.Y / 560, 1)
    scale = math.clamp(scale, 0.68, 1)
    UIScale.Scale = scale * (Values.uiScale / 100)
end

if workspace.CurrentCamera then
    connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), updateScale)
end
updateScale()

selectCategory("General")

Main.Position = UDim2.new(0.5, 0, 0.5, 10)
Main.BackgroundTransparency = 1
animate(Main, 0.32, {
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundTransparency = 0,
})

setStatus("Ready", Theme.green)
print("[WellsRB] UI initialized. RightShift/F4 toggles the window.")
notify("WellsRB loaded", "Press RightShift or F4 to hide/show the menu.")
