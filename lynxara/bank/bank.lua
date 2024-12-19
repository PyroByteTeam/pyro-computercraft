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
    monitor.setCursorPos(math.floor(width / 2 - string.len(labelText) / 2) + 1, 1)
    monitor.setTextColor(colors.yellow)
    monitor.write(labelText)
    
    -- Border
    monitor.setBackgroundColor(colors.gray)
    monitor.setCursorPos(2, 2)
    monitor.write(string.rep(" ", width - 2))
    for i = 3, height - 2 do
        monitor.setCursorPos(2, i)
        monitor.write(" ")
        monitor.setCursorPos(width - 1, i)
        monitor.write(" ")
    end
    monitor.setCursorPos(2, height - 1)
    monitor.write(string.rep(" ", width - 2))

    -- Drive Info Module
    -- Border
    local diTitle = "Drive Status"
    monitor.setBackgroundColor(colors.gray)
    monitor.setCursorPos(4, 4)
    monitor.write("  ")
    monitor.setBackgroundColor(colors.black)
    monitor.write(" ")
    monitor.write(diTitle)
    monitor.write(" ")
    monitor.setBackgroundColor(colors.gray)
    monitor.write("  ")
    for i = 1, 3 do
        monitor.setCursorPos(4, 4 + i)
        monitor.write(" ")
        monitor.setCursorPos(21, 4 + i)
        monitor.write(" ")
    end
    monitor.setCursorPos(4, 8)
    monitor.write("                  ")
    monitor.setCursorPos(6, 6)
    if drive.isDiskPresent() == true then 
        monitor.setBackgroundColor(colors.green)
        monitor.setTextColor(colors.white)
        monitor.write("   Inserted   ")
    else 
        monitor.setBackgroundColor(colors.red)
        monitor.setTextColor(colors.black)
        monitor.write(" Not Inserted ")
    end

    -- Button to convert disk
    monitor.setCursorPos(23, 4)
    monitor.setBackgroundColor(colors.gray)
    monitor.write(string.rep(" ", width - 25))
    monitor.setCursorPos(23, 5)
    for i = 1, 3 do
        monitor.setCursorPos(23, 5 + i)
        monitor.write(" ")
        monitor.setCursorPos(width - 3, 5 + i)
        monitor.write(" ")
    end
    monitor.setCursorPos(23, 8)
    monitor.write(string.rep(" ", width - 25))
    monitor.setBackgroundColor(colors.blue)
    monitor.setCursorPos(24, 5)
    monitor.write("            ")
    monitor.setCursorPos(24, 7)
    monitor.write("            ")
    monitor.setTextColor(colors.white)
    monitor.setCursorPos(26, 6)
    monitor.write("Convert Disk")
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
local driveStatus = false
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

        if status == "main" then 
            if driveStatus ~= drive.isDiskPresent() then 
                previousStatus = "none"
            end
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