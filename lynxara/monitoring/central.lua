local basalt = require("basalt")

-- Get monitor
local monitor = peripheral.find("monitor")
if not monitor then
    error("Monitor not found!")
end

-- Setting monitor text scale
monitor.setTextScale(1)
local sizex, sizey = monitor.getSize()

-- Create main monitor frame
local monitorFrame = basalt.addMonitor()
monitorFrame:setMonitor(monitor)

-- Close button
monitorFrame:addButton()
    :setPosition(sizex, 1)
    :setSize(1, 1)
    :setText("X")
    :onClick(function()
        monitor.setBackgroundColor(colors.black)
        monitor.clear()
        os.shutdown()
    end)

-- Title label
monitorFrame:addLabel()
    :setPosition(2, 2)
    :setText("Base Monitoring")
    :setForeground(colors.black)

local function SetupUI()
    local posBarx, posBary = sizex / 2 - 10, sizey / 2
    local progressBar = monitorFrame:addProgressBar()
    progressBar:setPosition(posBarx, posBary)
    progressBar:setSize(20, 1)
    progressBar:setDirection("right")
    progressBar:setProgress(0)

    for i = 1, 100 do
        progressBar:setProgress(i)
        sleep(0.1)
    end
    sleep(1)
    progressBar:remove()
end

local function Main()
    local mod = peripheral.find("modem")
    if not mod then
        error("Modem not found!")
    end

    local working = true
    local opened = mod.isOpen(101)
    if not opened then
        mod.open(101)
    end

    -- Setup UI
    SetupUI()

    while working == true do 
        event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        if event == "modem_message" then
            testButton:remove()
        end
    end
end

parallel.waitForAny(Main, basalt.autoUpdate)