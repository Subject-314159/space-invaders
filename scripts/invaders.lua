local util = require("lib.util")
require("util")

local scanner = require("scripts.scanner")

local invaders = {}

local ROCKET_LAUNCH_DELAY_SEC = 6
local FIRST_INVASION_DELAY_SEC = 3

----------
-- Helpers

local first_rocket_is_launched = function()
    return global.invaders and global.invaders.rocket_is_launced
end

local set_first_rocket_is_launched = function()
    global.invaders.rocket_is_launced = true
end

local first_invasion_happened = function()
    return global.invaders and global.invaders.num_invasions and global.invaders.num_invasions > 0
end

local increase_num_invasions = function()
    global.invaders.num_invasions = (global.invaders.num_invasions or 0) + 1
end

local set_next_invasion = function(seconds)

    if not seconds then
        -- Get random interval in minutes
        local intvmin = settings.global["si_invasion-interval-min"].value
        local intvmax = settings.global["si_invasion-interval-max"].value
        local intv = math.random(intvmin, intvmax)

        -- Multiply minutes by 60sec
        seconds = intv * 60
    end

    global.invaders.NEXT_INVASION_TICK = game.tick + (seconds * 60)
    game.print("Next invasion in " .. math.floor(seconds / 60) .. " minutes")
end

local get_box_from_tgt = function(tgt)
    local box = {{
        x = tgt.x - 6,
        y = tgt.y - 3
    }, {
        x = tgt.x + 6,
        y = tgt.y + 3
    }}
    return box
end

----------
-- Invasions

local new_invasion = function()
    -- Early exit if there is a sprite already
    if global.rocket_crashing then
        return
    end

    -- Get first player and surface
    local p, s
    for _, gp in pairs(game.players) do
        if gp and gp.character then
            p = gp
            break
        end
    end

    if p and p.character then
        s = p.surface
    else
        s = game.surfaces[1]
    end

    -- Early exit if we did not find a surface
    if not s then
        return
    end

    local sprite = "si_rocket"
    local dist = -50
    local tgt = {
        x = 0,
        y = 0
    }

    tgt = scanner.get_random_crash_site(s)
    if not tgt then

        -- Set next invasion
        game.print("Unable to find a suitable landin spot, delaying invasion")
        set_next_invasion()

        return
    end

    local prop = {
        sprite = sprite,
        -- orientation_target = tgt,
        orientation = 0.37,
        target = {tgt.x + (dist * 1.2), tgt.y + (dist * 0.8)},
        surface = s
    }
    local propsh = {
        sprite = "si_rocket-shadow",
        -- orientation_target = tgt,
        target = {tgt.x + (dist * 1.2) - 5, tgt.y},
        surface = s
    }

    global.rocket_crashing = rendering.draw_sprite(prop)
    global.rocket_crashing_shadow = rendering.draw_sprite(propsh)
    global.rocket_offset = dist
    global.rocket_target = tgt
    global.rocket_crash_surface = s

    -- Inform the player

    local surface = "nauvis"
    if s and s.name then
        surface = s.name
    end
    game.print("Unidentified flying object incoming at [gps=" .. tgt.x .. "," .. tgt.y .. "," .. surface .. "]")

end

local progress_crash = function()

    if global.rocket_offset < 0 then
        local off = global.rocket_offset + 0.5
        local tgt = global.rocket_target
        local pos = {tgt.x + (off * 1.2) - 0.1, tgt.y + (off * 0.8) - 0.1}
        local possh = {tgt.x + (off * 1.2) - 5, tgt.y - 1}

        -- Update rocket
        if rendering.is_valid(global.rocket_crashing) then
            rendering.set_target(global.rocket_crashing, pos)
        end

        -- Update shadow
        if rendering.is_valid(global.rocket_crashing_shadow) then
            rendering.set_target(global.rocket_crashing_shadow, possh)
        end
        global.rocket_offset = off
    else
        local srf = global.rocket_crash_surface
        local tgt = {
            x = global.rocket_target.x + 2.5,
            y = global.rocket_target.y + 1
        }

        -- Draw explosion
        srf.create_entity {
            name = "nuke-explosion",
            position = tgt,
            target = tgt,
            speed = 0.1
        }
        srf.create_entity {
            name = "massive-explosion",
            position = tgt,
            target = tgt,
            speed = 0.03
        }
        srf.create_entity {
            name = "big-explosion",
            position = {tgt.x - 3, tgt.y - 3.5},
            speed = 0.5
        }
        srf.create_entity {
            name = "medium-explosion",
            position = {tgt.x + 3.5, tgt.y + 2.1},
            speed = 0.5
        }
        srf.create_entity {
            name = "medium-explosion",
            position = {tgt.x + 2, tgt.y + 3.1},
            speed = 0.5
        }

        -- Create the aliens (for now hardcoded)
        srf.create_entity({
            name = "si_crashed-rocket",
            position = tgt
        })
        for i = 1, 5, 1 do

            srf.create_entity {
                name = "si_alien",
                position = {tgt.x - i, tgt.y - 3}
            }
            srf.create_entity {
                name = "crash-site-fire-flame",
                position = {tgt.x - (i * 2) + 5, tgt.y + ((math.random(1, 10) / 5))}
            }
        end

        -- Destroy buildings around the target
        local box = get_box_from_tgt(tgt)
        local ent = srf.find_entities(box)
        local replace_ghosts = {}
        for _, e in pairs(ent) do
            if e.valid then
                local may_die = true
                for _, f in pairs({"entity-ghost", "si_alien", "si_crashed-rocket"}) do
                    if e.name == f then
                        may_die = false
                        break
                    end
                end
                if may_die then
                    e.die()
                elseif e.name == "entity-ghost" then
                    table.insert(replace_ghosts, table.deepcopy(e))
                end
            end
        end

        local ghosts = srf.find_entities_filtered({
            area = box,
            name = "entity-ghost"
        })
        for _, g in pairs(ghosts) do
            table.insert(replace_ghosts, table.deepcopy(g))
        end

        -- Recreate any ghosts that may have been removed
        -- Doesnt work yet
        -- for _, g in pairs(replace_ghosts) do
        --     srf.create_entity(g)
        -- end

        -- Destroy the sprite
        rendering.destroy(global.rocket_crashing)
        rendering.destroy(global.rocket_crashing_shadow)
        global.rocket_crashing = nil
        global.rocket_crashing_shadow = nil

        -- Set next invasion
        set_next_invasion()
    end
end

----------
-- Rocket launch handler

local create_gui = function()
    for _, p in pairs(game.players) do
        -- Close all other screens
        p.opened = nil

        -- Make new gui
        local scr = p.gui.screen
        local fr = scr.add {
            type = "frame",
            name = "si_first_launch_message",
            vertically_stretchable = "on",
            direction = "vertical",
            caption = {"si-gui.intermission-title"}
        }
        fr.style.width = 500
        fr.auto_center = true

        -- Pre label
        local pre = fr.add {
            type = "label",
            caption = {"si-gui.intermission-pre"}
        }
        pre.style.single_line = false

        -- HUD
        fr.add {
            type = "frame",
            name = "hud",
            direction = "vertical",
            style = "inside_shallow_frame_with_padding"
        }
        fr.hud.add {
            type = "sprite",
            sprite = "si_all-your-base"
        }
        local msg = fr.hud.add {
            type = "label",
            caption = {"si-gui.intermission-message"}
        }
        msg.style.single_line = false
        msg.style.font = "debug-mono"

        fr.add {
            type = "label",
            caption = {"si-gui.intermission-post"}
        }
        fr.add {
            type = "button",
            name = "si_intermission_close_button",
            caption = "Close"
        }
    end
end

local on_rocket_callback = function()
    create_gui()

end

----------
-- Global interfaces

invaders.instant_invade = function()
    new_invasion()
end

invaders.close_gui = function(player)
    if not player or not player.gui.screen then
        return
    end
    local scr = player.gui.screen
    if scr.si_first_launch_message then
        scr.si_first_launch_message.destroy()
        set_next_invasion(FIRST_INVASION_DELAY_SEC)

        game.print("Cornel, you better look at this radar")
        game.print("What is it son?")
        game.print("I don't know sir, but it looks like a giant...")
    end
end

invaders.on_rocket_launch = function(e)
    if not first_rocket_is_launched() then
        -- Set timer and callback
        -- script.on_nth_tick(e.tick + ROCKET_LAUNCH_DELAY_SEC, invaders.on_rocket_callback(e.rocket_silo))
        -- invaders.on_rocket_callback(e.rocket_silo)
        global.invaders.HUD_MESSAGE_TICK = e.tick + (ROCKET_LAUNCH_DELAY_SEC * 60)
        set_first_rocket_is_launched()
    end
end

invaders.on_tick = function()
    if game.tick == global.invaders.HUD_MESSAGE_TICK then
        on_rocket_callback()
    end

    if game.tick == global.invaders.NEXT_INVASION_TICK then
        new_invasion()
    end

    if global.rocket_crashing then
        progress_crash()
    end
end

invaders.init = function()

    if not global.invaders then
        global.invaders = {}
    end

end

return invaders
