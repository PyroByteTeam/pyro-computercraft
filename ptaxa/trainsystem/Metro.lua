local Encryption = require("encryption")

local key = { 77, 30, 36, 18, 39, 34, 49, 56, 44, 19, 99, 97, 77, 29, 59, 100, 72, 62, 1, 1, 15, 58, 51, 5, 7, 79, 50, 3, 40, 85, 0, 87 }

local drive = peripheral.find("drive")
local red_integrator = peripheral.find("redstoneIntegrator")

local chatBox = peripheral.find("chatBox")
local playerDetector = peripheral.find("playerDetector")

local redstoneSide = "left"

local function EverythingExists()
    if drive == nil then
        return false
    end

    if red_integrator == nil then
        return false
    end

    if chatBox == nil then
        return false
    end

    if playerDetector == nil then
        return false
    end

    return true
end

if EverythingExists() == false then
    local exists = false 
    while exists == false do
        print("Some peripherals are missing:")
        if drive == nil then
            print("Drive is missing!")
        end

        if red_integrator == nil then
            print("Redstone Integrator is missing!")
        end

        if chatBox == nil then
            print("ChatBox is missing!")
        end

        if playerDetector == nil then
            print("PlayerDetector is missing!")
        end

        sleep(1)

        exists = EverythingExists()
        if exists == true then
            print("All peripherals are connected!")
        end
    end
end

local function SendMessage(cash)
    local line = "You successfully paid for the trip! Remaining trips: " .. cash
    local title = "Notification"
    local players = playerDetector.getPlayersInRange(15)
    for i = 1, #players do
        chatBox.sendToastToPlayer(line, title, players[i], "&6PyroTrain", "()", "&6")
    end
end

local function CheckDisk()
    if drive.isDiskPresent() == true then
        -- Disk
        local file = fs.open("disk/data", "r")
        local disket = fs.exists("disk/data")
        
        if disket == true then
            local file = fs.open("disk/data", "r")
            local text = file.readAll()
            file.close()

            local decrypted = Encryption.Decrypt(text, key)
            local result = textutils.unserializeJSON(decrypted)
            
            if result.money > 0 then
                result.money = result.money - 1

                local dataEdited = result
                local text = textutils.serializeJSON(dataEdited)
                local encrypted = Encryption.Encrypt(text, key)
                fs.delete("disk/data")
                local file = fs.open("disk/data", "w")
                file.write(encrypted)
                file.close()
                drive.ejectDisk()

                SendMessage(result.money)

                red_integrator.setOutput(redstoneSide, true)
                sleep(5)
                red_integrator.setOutput(redstoneSide, false)
            else
                drive.ejectDisk()
            end
        else
            drive.ejectDisk()
        end
    else
        drive.ejectDisk()
    end
end

while true do
    local event, side = os.pullEvent("disk")
    CheckDisk()
end