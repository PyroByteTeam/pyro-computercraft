rot = 0
box = 4
boxY = 4 



local function mine()
    for i = 1, box do
        for i = 1, box do
            turtle.dig()
            turtle.forward()   
        end
        if rot == 0 then
            turtle.turnLeft()
            turtle.dig()
            turtle.forward()
            turtle.turnLeft()
            rot = 1
        else if rot == 1 then
            turtle.turnRight()
            turtle.dig()
            turtle.forward()
            turtle.turnRight()
            rot = 0
            end
        end
    end

    for i = 1, box do
        turtle.dig()
        turtle.forward()
    end
end

for y = 1, boxY do
    mine()
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.digUp(Top)
    if y ~= boxY then
        turtle.up()
    end
end