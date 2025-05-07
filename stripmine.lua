-- Title
local title = [[
Stripper by Trint66
]]

-- Helper: Turn around
local function turn_around()
    turtle.turnRight()
    turtle.turnRight()
end

-- Helper: Move forward with digging
local function move_forward(n)
    for i = 1, n do
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
    turtle.turnRight()

    -- Back to center
    turtle.turnRight()
    mine_tunnel(32)
    return_to_main(32)
    turtle.turnLeft()
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

-- Begin mining loop
for i = 1, branch_count do
    do_branch()
    -- Back up 2 blocks to start new branch position
    move_forward(2)
    -- Unload before next branch
    turn_around()
    move_forward(3 * i + 2 * (i - 1)) -- Go back to chest
    unload()
    turn_around()
    move_forward(3 * i + 2 * (i - 1)) -- Return to work site
    turn_around()
end

print("Finished mining.")
