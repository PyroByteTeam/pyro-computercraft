local Encryption = require("encryption")

local monitor = peripheral.find("monitor")
local deposit = peripheral.find("storagedrawers:oak_full_drawers_1")
local storage = peripheral.find("sophisticatedstorage:iron_chest")

local drive = peripheral.find("drive")

local balance = 0
local depositAmount = 0
local ticketPrice = 1

local key = { 77, 30, 36, 18, 39, 34, 49, 56, 44, 19, 99, 97, 77, 29, 59, 100, 72, 62, 1, 1, 15, 58, 51, 5, 7, 79, 50, 3, 40, 85, 0, 87 }

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
    local exists = false 
    while exists == false do
        print("Some peripherals are missing:")
        if monitor == nil then
            print("Monitor is missing!")
        end
        if deposit == nil then
            print("Deposit is missing!")
        end
        if storage == nil then
            print("Storage is missing!")
        end
        if drive == nil then
            print("Drive is missing!")
        end

        sleep(1)

        exists = EverythingExists()
        if exists == true then
            print("All peripherals are connected!")
        end
    end
end

local function BlinkButton(type, state)
    if type == "deposit" then
        local width, height = monitor.getSize()
        if state == true then
            monitor.setBackgroundColor(colors.blue)
            monitor.setCursorPos(5, 15)
            monitor.setTextColor(colors.white)
            monitor.write(string.rep(" ", width - 8))
            monitor.setCursorPos(math.floor(width / 2 - string.len("Deposit") / 2) + 1, 15)
            monitor.write("Deposit")
            sleep(1)
            monitor.setBackgroundColor(colors.green)
            monitor.setCursorPos(5, 15)
            monitor.setTextColor(colors.white)
            monitor.write(string.rep(" ", width - 8))
            monitor.setCursorPos(math.floor(width / 2 - string.len("Deposit") / 2) + 1, 15)
            monitor.write("Deposit")
        else
            monitor.setBackgroundColor(colors.red)
            monitor.setCursorPos(5, 15)
            monitor.setTextColor(colors.white)
            monitor.write(string.rep(" ", width - 8))
            monitor.setCursorPos(math.floor(width / 2 - string.len("Deposit") / 2) + 1, 15)
            monitor.write("Deposit")
            sleep(1)
            monitor.setBackgroundColor(colors.green)
            monitor.setCursorPos(5, 15)
            monitor.setTextColor(colors.white)
            monitor.write(string.rep(" ", width - 8))
            monitor.setCursorPos(math.floor(width / 2 - string.len("Deposit") / 2) + 1, 15)
            monitor.write("Deposit")
        end
    elseif type == "convert" then
        if state == true then
            monitor.setBackgroundColor(colors.green)
            monitor.setCursorPos(24, 5)
            monitor.write("            ")
            monitor.setTextColor(colors.white)
            monitor.setCursorPos(24, 6)
            monitor.write("Convert Disk")
            monitor.setCursorPos(24, 7)
            monitor.write("            ")
            sleep(1)
            monitor.setBackgroundColor(colors.blue)
            monitor.setCursorPos(24, 5)
            monitor.write("            ")
            monitor.setTextColor(colors.white)
            monitor.setCursorPos(24, 6)
            monitor.write("Convert Disk")
            monitor.setCursorPos(24, 7)
            monitor.write("            ")
        else
            monitor.setBackgroundColor(colors.red)
            monitor.setCursorPos(24, 5)
            monitor.write("            ")
            monitor.setTextColor(colors.white)
            monitor.setCursorPos(24, 6)
            monitor.write("Convert Disk")
            monitor.setCursorPos(24, 7)
            monitor.write("            ")
            sleep(1)
            monitor.setBackgroundColor(colors.blue)
            monitor.setCursorPos(24, 5)
            monitor.write("            ")
            monitor.setTextColor(colors.white)
            monitor.setCursorPos(24, 6)
            monitor.write("Convert Disk")
            monitor.setCursorPos(24, 7)
            monitor.write("            ")
        end
    end
end

local Pages = {}
Pages.Main = function()
    monitor.setBackgroundColor(colors.black)
    monitor.clear()

    local width, height = monitor.getSize()
    local labelText = "PyroTrain"


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
    monitor.setTextColor(colors.yellow)
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
        monitor.setCursorPos(23, 4 + i)
        monitor.write(" ")
        monitor.setCursorPos(width - 3, 4 + i)
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
    monitor.setCursorPos(24, 6)
    monitor.write("Convert Disk")

    -- Deposit Module
    -- Border all width
    local depositTitle = " Deposit "
    monitor.setBackgroundColor(colors.gray)
    monitor.setTextColor(colors.yellow)
    monitor.setCursorPos(4, 10)
    monitor.write(string.rep(" ", width / 2 - string.len(depositTitle) / 2 - 3))
    monitor.setBackgroundColor(colors.black)
    monitor.write(depositTitle)
    monitor.setBackgroundColor(colors.gray)
    monitor.write(string.rep(" ", width / 2 - string.len(depositTitle) / 2 - 3))
    for i = 1, 5 do
        monitor.setCursorPos(4, 10 + i)
        monitor.write(" ")
        monitor.setCursorPos(width - 3, 10 + i)
        monitor.write(" ")
    end
    monitor.setCursorPos(4, 14)
    monitor.write(string.rep(" ", width - 6))
    monitor.setCursorPos(4, 16)
    monitor.write(string.rep(" ", width - 6))

    -- Money Label
    if drive.isDiskPresent() == true then
        local exists = fs.exists("disk/data")
        if exists == true then
            local data = fs.open("disk/data", "r")
            local encryptedData = data.readAll()
            data.close()
            local decryptedData = Encryption.Decrypt(encryptedData, key)
            local data = textutils.unserializeJSON(decryptedData)
            balance = data.money
        end
    else
        balance = 0
    end

    local moneyLabel = "Drives: " .. math.floor(balance / ticketPrice) .. " | Deposit: " .. depositAmount .. "C"
    monitor.setCursorPos(math.floor(width / 2 - string.len(moneyLabel) / 2 + 1), 12)
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)
    monitor.write("Drives: ")
    monitor.setTextColor(colors.green)
    monitor.write(math.floor(balance / ticketPrice))
    monitor.setTextColor(colors.white)
    monitor.write(" | Deposit: ")
    monitor.setTextColor(colors.green)
    monitor.write(depositAmount)
    monitor.setTextColor(colors.white)
    monitor.write("C")

    -- Deposit Button
    local depositText = "Deposit"
    monitor.setCursorPos(5, 15)
    monitor.setBackgroundColor(colors.green)
    monitor.setTextColor(colors.white)
    monitor.write(string.rep(" ", width - 8))
    monitor.setCursorPos(math.floor(width / 2 - string.len(depositText) / 2) + 1, 15)
    monitor.write(depositText)
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

local function CheckMoney()
    local moneyTypes = {
        [1] = {
            name = "numismatics:spur",
            value = 1
        },
        [2] = {
            name = "numismatics:bevel",
            value = 8
        },
        [3] = {
            name = "numismatics:sprocket",
            value = 16
        },
        [4] = {
            name = "numismatics:cog",
            value = 64
        },
        [5] = {
            name = "numismatics:crown",
            value = 512
        },
        [6] = {
            name = "numismatics:sun",
            value = 4096
        }
    }

    depositAmount = 0
    local items = deposit.list()
    if items[2] ~= nil then
        for i = 1, #moneyTypes do
            if items[2].name == moneyTypes[i].name then
                depositAmount = depositAmount + items[2].count * moneyTypes[i].value
            end
        end
    end
end

local status = "main"
local previousStatus = "main"
local driveStatus = false
local function Update()
    Pages.Main()
    while true do
        sleep(0.1)
        CheckMoney()
        if status == "main" and previousStatus ~= "main" then
            Pages.Main()
            previousStatus = "main"
        elseif status == "deposit" and previousStatus ~= "deposit" then
            Pages.Deposit()
            previousStatus = "deposit"
        end

        if previousDeposit ~= depositAmount then
            previousDeposit = depositAmount
            Pages.Main()
        end
        if status == "main" then
            if driveStatus ~= drive.isDiskPresent() then
                previousStatus = "none"
            end
        end
    end
end

local Buttons = {}

Buttons.Deposit = function()
    if depositAmount > 0 and drive.isDiskPresent() then
        local tempAmount = depositAmount
        storage.pullItems(peripheral.getName(deposit), 2)
        depositAmount = 0
        balance = balance + tempAmount
        local data = { money = balance }
        local encryptedData = textutils.serializeJSON(data)
        encryptedData = Encryption.Encrypt(encryptedData, key)
        if fs.exists("disk/data") == true then
            fs.delete("disk/data")
        end
        local file = fs.open("disk/data", "w")
        file.write(encryptedData)
        file.close()
        drive.setDiskLabel("PyroTrain Pass")
        BlinkButton("deposit", true)
    else
        BlinkButton("deposit", false)
    end
end

Buttons.Back = function()
    status = "main"
end

Buttons.Convert = function()
    local success = false

    if drive.isDiskPresent() == true then
        balance = 0
        local data = { money = balance }
        local encryptedData = textutils.serializeJSON(data)
        encryptedData = Encryption.Encrypt(encryptedData, key)
        if fs.exists("disk/data") == true then
            fs.delete("disk/data")
        end
        local file = fs.open("disk/data", "w")
        file.write(encryptedData)
        file.close()
        status = "none"
        BlinkButton("convert", true)
        drive.setDiskLabel("PyroTrain Pass")
        status = "main"
        previousStatus = "none"
    else
        BlinkButton("convert", false)
        status = "main"
        previousStatus = "none"
    end
end

local function EventCheck()
    while true do
        sleep(0.1)

        local event, side, xPos, yPos = os.pullEvent("monitor_touch")
        if status == "main" then
            if yPos == 6 and (xPos > 0 and xPos < 11) then
                Buttons.Reset()
            elseif (yPos > 14 and yPos < 16) and (xPos > 4 and xPos < 36) then
                Buttons.Deposit()
            elseif (yPos > 4 and yPos < 8) and (xPos > 23 and xPos < 36) then
                Buttons.Convert()
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
