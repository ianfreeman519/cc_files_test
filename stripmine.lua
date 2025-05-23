-- Title
local title = [[
Strinp mipe by Trint66
]]

-- Helper: Turn around
local function turn_around()
    turtle.turnRight()
    turtle.turnRight()
end

-- Helper: Move forward with digging (including above)
local function move_forward(n)
    for i = 1, n do
        -- Dig the block above before attempting to move
        turtle.digUp()

        while not turtle.forward() do
            if turtle.detect() then
                turtle.dig()
            else
                sleep(0.5)
            end
        end
    end
end


-- Helper: Move up with digging
local function move_up(n)
    for i = 1, n do
        while not turtle.up() do
            if turtle.detectUp() then
                turtle.digUp()
            else
                sleep(0.5)
            end
        end
    end
end

-- Helper: Move down
local function move_down(n)
    for i = 1, n do
        while not turtle.down() do
            if turtle.detectDown() then
                turtle.digDown()
            else
                sleep(0.5)
            end
        end
    end
end

-- Mine tunnel forward and 1 block above
local function mine_tunnel(length)
    for i = 1, length do
        turtle.dig()
        move_forward(1)
        turtle.digUp()
    end
end

-- Return to main tunnel
local function return_to_main(length)
    turn_around()
    move_forward(length)
    turn_around()
end

-- Dump all items to chest
local function unload()
    for slot = 1, 16 do
        turtle.select(slot)
        turtle.drop()
    end
end

-- Main branch function: digs 3 ahead, then left and right tunnels
local function do_branch()
    -- Forward 3 and dig above
    for i = 1, 3 do
        turtle.dig()
        move_forward(1)
        turtle.digUp()
    end

    -- Left T tunnel
    turtle.turnLeft()
    mine_tunnel(32)
    return_to_main(32)
    turtle.turnRight()  -- Face forward again

    -- Right T tunnel
    turtle.turnRight()
    mine_tunnel(32)
    return_to_main(32)
    turtle.turnLeft()  -- Face forward again
end

-------------------------
-- PROGRAM STARTS HERE --
-------------------------

term.clear()
print(title)

-- Startup check: Chest behind
turn_around()
local ok, item = turtle.inspect()
if not (ok and string.find(item.name, "chest")) then
    printError("ERROR: No chest behind me. Exiting...")
    return
end
turn_around()

-- Check fuel
if turtle.getFuelLevel() <= 0 then
    printError("ERROR: No fuel!")
    return
elseif turtle.getFuelLevel() < 1000 then
    print("WARNING: Low fuel")
end

-- Ask how many branches to dig
write("Number of T branches to dig: ")
local branch_count = tonumber(read())

-- Initialize distance tracking
local distance_from_chest = 0

-- Begin mining loop
for i = 1, branch_count do
    do_branch()
    
    -- Move forward 2 blocks for spacing
    move_forward(2)
    distance_from_chest = distance_from_chest + 5  -- 3 for T + 2 spacing
    
    -- Return to chest and unload
    turn_around()
    move_forward(distance_from_chest)
    unload()
    
    -- Go back to working position
    turn_around()
    move_forward(distance_from_chest)
end

print("Finished mining.")
