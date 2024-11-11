local minPercentage = 10
local alarmPlacement = "top"
local blockPlacement = "back"
local type = "energy_cell"
local triggerAlarm = true

local connectedBlock = peripheral.wrap(blockPlacement)

local function getEnergyCellPercentage()
    local capacity = connectedBlock.getEnergyCapacity()
    local currentEnergy = connectedBlock.getEnergy()
    local percentage = (currentEnergy / capacity) * 100
    percentage = math.floor(percentage)
    return percentage
end

local function getFluidStoragePercentage()
    local capacity = connectedBlock.tanks()[1].capacity
    local currentFluid = connectedBlock.tanks()[1].amount
    local percentage = (currentFluid / capacity) * 100
    percentage = math.floor(percentage)
    return percentage
end

local function getPercentage()
    if type == "energy_cell" then
        return getEnergyCellPercentage()
    elseif type == "fluid_storage" then
        return getFluidStoragePercentage()
    end
end

local function setPercentage(percentage)
    minPercentage = percentage
    local file = fs.open("percentage.txt", "w")
    file.write(minPercentage)
    file.close()
end

local iterator = 0

local function printError()
    iterator = iterator + 1

    if iterator > 20 then
        iterator = 0
        term.setTextColour(colours.red)
        if type == "energy_cell" then
            print("Energy cell is below", minPercentage, "% - ", getPercentage(), "%")
        elseif type == "fluid_storage" then
            print("Fluid storage is below", minPercentage, "% - ", getPercentage(), "%")
        end
        term.setTextColour(colours.white)
    end
end

local function printInfo()
    if type == "energy_cell" then
        local currentEnergy = connectedBlock.getEnergy()
        currentEnergy = math.floor(currentEnergy)
        local capacity = connectedBlock.getEnergyCapacity()
        capacity = math.floor(capacity)
        local percentage = getPercentage()
        percentage = math.floor(percentage)
        print("Energy:", currentEnergy, "/", capacity, "(", percentage, "% /", minPercentage, "%)")
    elseif type == "fluid_storage" then
        local currentFluid = connectedBlock.tanks()[1].amount
        currentFluid = math.floor(currentFluid)
        local capacity = connectedBlock.tanks()[1].capacity
        capacity = math.floor(capacity)
        local percentage = getPercentage()
        percentage = math.floor(percentage)
        print("Fluid:", currentFluid, "/", capacity, "(", percentage, "% /", minPercentage, "%)")
    end
end

local function percentageCheck()
    while true do
        local currentPercentage = getPercentage()

        if currentPercentage <= minPercentage then
            printError()
            if triggerAlarm == true then
                redstone.setAnalogOutput(alarmPlacement, 15)
            else 
                redstone.setAnalogOutput(alarmPlacement, 0)
            end
        else
            redstone.setAnalogOutput(alarmPlacement, 0)
        end
    end
end

local function printTitle(afterText, acolor)
    term.clear()
    term.setCursorPos(1, 1)
    -- make text with borders
    term.setTextColour(colours.green)
    print("-----------------")
    print("| Block Monitor | ")
    print("-----------------")
    term.setTextColour(acolor or colours.white)
    if afterText then
        print(afterText)
        term.setTextColour(colours.white)
    end
end

local function commandCheck()
    printTitle("Welcome! You can type commmands here (or type \"help\"):", colours.green)
    while true do
        local command = read()
        if command == "help" then 
            printTitle("Help", colours.yellow)
            print("Commands: cls, alarm on, alarm off, info, percentage <number>, exit")
        elseif command == "cls" then
            printTitle("", colours.white)
        elseif command == "alarm off" then
            printTitle("Alarm is off", colours.red)
            triggerAlarm = false
        elseif command == "alarm on" then
            printTitle("Alarm is on", colours.green)
            triggerAlarm = true
        elseif command == "info" then
            printTitle("Info", colours.yellow)
            printInfo()
        elseif command:match("^percentage%s+%d+$") then 
            printTitle("Set min percentage", colours.yellow) 
            setPercentage(tonumber(command:match("%d+"))) 
            print("Min percentage set to: " .. minPercentage)
        elseif command == "exit" then
            printTitle("Goodbye!", colours.red)
            sleep(1)
            redstone.setAnalogOutput(alarmPlacement, 0)
            term.clear()
            term.setCursorPos(1, 1)
            break
        else
            printTitle("Unknown command", colours.red)
            printTitle("Welcome! You can type commmands here (or type \"help\"):", colours.green)
        end
    end
end

printTitle("Welcome! Configurating...", colours.green)
type = "none"
if peripheral.find("modern_industrialization:lv_storage_unit") then 
    type = "energy_cell"
    connectedBlock = peripheral.find("modern_industrialization:lv_storage_unit")
    print("[Configuration] Energy Cell found!")
elseif peripheral.find("modern_industrialization:large_tank") then
    type = "fluid_storage"
    connectedBlock = peripheral.find("modern_industrialization:large_tank")
    print("[Configuration] Fluid Storage found!")
end

if fs.exists("percentage.txt") then
    local file = fs.open("percentage.txt", "r")
    minPercentage = tonumber(file.readLine())
    file.close()
else 
    local file = fs.open("percentage.txt", "w")
    file.write(minPercentage)
    file.close()
end
print("[Configuration] Min Percentage set to: " .. minPercentage)
print("[Configuration] Configuration Complete!")

if type ~= "none" then 
    parallel.waitForAny(percentageCheck, commandCheck)
else
    printTitle("Active Block not found!", colours.red)
    sleep(1)
    term.clear()
    term.setCursorPos(1, 1)
end
