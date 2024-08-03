local invaders = require("scripts.invaders")
local scanner = require("scripts.scanner")

script.on_event(defines.events.on_tick, function()
    invaders.on_tick()
end)

script.on_init(function()

    invaders.init()
    scanner.init()

    local comm = commands.commands

    -- Add debug commands
    if not comm["invade"] then
        commands.add_command("invade", "Manually start the invasions", function(command)
            invaders.instant_invade()
        end)
    end

end)

script.on_event(defines.events.on_rocket_launched, function(e)
    invaders.on_rocket_launch(e)
end)

script.on_event(defines.events.on_gui_click, function(e)
    -- Close intermission GUI
    if e.element and e.element.name == "si_intermission_close_button" then
        local player = game.get_player(e.player_index)
        invaders.close_gui(player)
    end
end)

local on_built_entity = function(e)
    -- placement =  Script  returns 'entity' while player/robot placement returns 'created_entity'
    -- Convert player/robot entity to script entity so they can be handled the same way
    if e["created_entity"] and not e["entity"] then
        e["entity"] = e["created_entity"]
    end
    if not e["entity"] then
        return
    end
    local entity = e["entity"]
    if entity.name ~= "entity-ghost" then
        scanner.add_entity_chunk(entity)
    end
end
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity,
                 defines.events.script_raised_built, defines.events.script_raised_revive -- defines.events.on_entity_cloned
}, function(e)
    -- Triggers on entity built
    on_built_entity(e)
end)
