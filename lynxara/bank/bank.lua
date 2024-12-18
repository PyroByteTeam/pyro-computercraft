local monitor = peripheral.find("monitor")
local deposit = peripheral.find("storagedrawers:oak_full_drawers_1")
local storage = peripheral.find("sophisticatedstorage:iron_chest")

local balance = 0

local function EverythingExists()
    if monitor == nil then
        print("Monitor not found")
        return false
    end
    if deposit == nil then
        print("Deposit not found")
        return false
    end
    if storage == nil then
        print("Storage not found")
        return false
    end
    return true
end

if EverythingExists() == false then
    print("Error: Not all peripherals found")
    return
end

local function SetupUI()
    monitor.setBackgroundColor(colors.white)
    monitor.clear()

    local width, height = monitor.getSize()
    local labelText = "PyroTrain"

    -- Creating label
    monitor.setCursorPos(math.floor(width / 2 - string.len(labelText) / 2), 1)
    monitor.setTextColor(colors.black)
    monitor.write(labelText)

    -- Creating balance label
    monitor.setCursorPos(1, 3)
    monitor.setTextColor(colors.black)
    monitor.write("Balance: ")
    monitor.setTextColor(colors.green)
    monitor.write(balance)
    monitor.write("C")
end

SetupUI()