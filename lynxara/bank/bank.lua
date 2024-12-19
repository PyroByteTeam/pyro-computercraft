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
    monitor.setBackgroundColor(colors.black)
    monitor.clear()

    local width, height = monitor.getSize()
    local labelText = "PyroTrain Menu"

    -- Title Label
    monitor.setCursorPos(math.floor(width / 2 - string.len(labelText) / 2), 1)
    monitor.setTextColor(colors.yellow)
    monitor.write(labelText)
    
    -- Gray border\
    monitor.setBackgroundColor(colors.gray)
    monitor.setCursorPos(2, 2)
    monitor.write(string.rep(" ", width - 2))
    for i = 3, height - 2 do
        monitor.setCursorPos(2, i)
        monitor.write(" ")
        monitor.setCursorPos(width, i)
        monitor.write(" ")
    end
    monitor.setCursorPos(2, height - 2)
    monitor.write(string.rep(" ", width - 2))
end

Pages.Reset = function()
    monitor.setBackgroundColor(colors.black)
    monitor.clear()

    -- Back Button
    monitor.setCursorPos(1, 1)
    monitor.setTextColor(colors.white)
    monitor.setBackgroundColor(colors.red)
    monitor.write("Back")

end

Pages.Deposit = function()
    monitor.setBackgroundColor(colors.black)
    monitor.clear()

    -- Back Button
    monitor.setCursorPos(1, 1)
    monitor.setTextColor(colors.black)
    monitor.setBackgroundColor(colors.red)
    monitor.write("Back")
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
    while true do 
        sleep(0.1)
        
        local event, side, xPos, yPos = os.pullEvent("monitor_touch")
        print(xPosy, yPos)
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