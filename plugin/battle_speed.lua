local CHEATED = false
local MUTEX = false
local SPEEDS = { 1, 3 }
local SPEED_INDEX = 1

local function before_battle()
    SPEED_INDEX = 1
    game.options_set_cheat_mode(1)
    if not MUTEX then
        CHEATED = game.op.options_get_cheat_mode()
        MUTEX = true
    end
    return false
end

local function toggle_speed()
    if game.key_clicked(game.const.triggers.key_y) then
        SPEED_INDEX = SPEED_INDEX % 2 + 1
        game.set_fixed_point_multiplier(1)
        game.mission_set_time_speed(SPEEDS[SPEED_INDEX])
    end
    return false
end

local function after_battle()
    MUTEX = true
    game.set_fixed_point_multiplier(1)
    game.mission_set_time_speed(1)
    if not CHEATED then
        game.options_set_cheat_mode(0)
    end
    return true
end

for i = 0, game.getNumTemplates() - 1 do
    game.addTrigger(i, 0, 0, 0, toggle_speed)
    game.addTrigger(i, game.const.ti_after_mission_start, 0, 0, before_battle)
end

game.hookOperation(game.const.finish_mission, after_battle)
