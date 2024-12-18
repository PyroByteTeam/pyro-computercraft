local monitor = peripheral.find("monitor")
local deposit = peripheral.find("storagedrawers:oak_full_drawers_1")
local storage = peripheral.find("sophisticatedstorage:iron_chest")

local drive = peripheral.find("drive")

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
    if drive == nil then
        print("Drive not found")
        return false
    end
    return true
end

if EverythingExists() == false then
    print("Error: Not all peripherals found")
    return
end

local Pages = {}
Pages.Main = function()
    monitor.setBackgroundColor(colors.white)
    monitor.clear()

    local width, height = monitor.getSize()
    local labelText = "PyroTrain Menu"

    -- Title Label
    monitor.setCursorPos(math.floor(width / 2 - string.len(labelText) / 2), 1)
    monitor.setTextColor(colors.black)
    monitor.setBackgroundColor(colors.yellow)
    monitor.write(labelText)

    -- Drive Status Label
    monitor.setCursorPos(1, 3)
    monitor.setTextColor(colors.black)
    monitor.setBackgroundColor(colors.white)
    monitor.write("Ticket Status: ")
    if drive.isDiskPresent() then
        monitor.setTextColor(colors.green)
        monitor.write("Present")
    else
        monitor.setTextColor(colors.red)
        monitor.write("Drive is Empty")
    end

    -- Balance Label
    monitor.setCursorPos(1, 4)
    monitor.setTextColor(colors.black)
    monitor.setBackgroundColor(colors.white)
    monitor.write("Balance: ")
    monitor.setTextColor(colors.green)
    monitor.write(balance)
    monitor.write("C")

    -- Button to Reset Disk
    monitor.setCursorPos(1, 6)
    monitor.setTextColor(colors.black)
    monitor.setBackgroundColor(colors.blue)
    monitor.write("Reset Disk")

    -- Button to Deposit
    monitor.setCursorPos(1, 8)
    monitor.setTextColor(colors.black)
    monitor.setBackgroundColor(colors.blue)
    monitor.write("Deposit")
end

Pages.Reset = function()
    monitor.setBackgroundColor(colors.white)
    monitor.clear()
end

Pages.Deposit = function()
    monitor.setBackgroundColor(colors.white)
    monitor.clear()
end

local status = "main"
local previousStatus = "main"
local function Update()
    Pages.Main()
    while true do 
        sleep(0.1)
        if status == "main" and previousStatus ~= "main" then 
            Pages.Main()
            previousStatus = "main"
        elseif status == "reset" and previousStatus ~= "reset" then 
            Pages.Reset()
            previousStatus = "reset"
        elseif status == "deposit" and previousStatus ~= "deposit" then
            Pages.Deposit()
            previousStatus = "deposit"
        end
    end
end

local Buttons = {}
Buttons.Reset = function()
    status = "reset"
end

Buttons.Deposit = function()
    status = "deposit"
end

Buttons.Back = function()
    status = "main"
end

local function EventCheck()
    local escape = false
    while escape == false do 
        sleep(0.1)
        local event, side, xPos, yPos = os.pullEvent("monitor_touch")
        if status == "main" then 
            if yPos == 6 and (xPos > 0 and xPos < 11) then 
                Buttons.Reset()
            elseif yPos == 8 and (xPos > 0 and xPos < 8) then 
                Buttons.Deposit()
            end
        elseif status ~= "main" then 
            if yPos == 1 and (xPos > 0 and xPos < 5) then 
                Buttons.Back()
            end
        end
    end
end

local function Close()
    print("Type exit to close")
    local input = read()
    while input ~= "exit" do
        sleep(0.1)
        input = read()
    end
end

parallel.waitForAny(Update, EventCheck, Close)