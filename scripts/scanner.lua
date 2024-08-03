local util = require("lib.util")

local scanner = {}

scanner.get_random_chunk = function(surface)
    if not global.scanner.surfaces[surface.name] then
        return
    end

    local chunks = {}
    for k, v in pairs(global.scanner.surfaces[surface.name]) do
        table.insert(chunks, k)
    end
    local i = math.random(1, #chunks)
    local chid = chunks[i]
    return global.scanner.surfaces[surface.name][chid]
end

scanner.get_random_crash_site = function(surface)
    local action = 1

    while action < 50 do

        -- Get random chunk and position on that chunk
        local ch = scanner.get_random_chunk(surface)
        if ch then
            local x = math.random(1, 32) + (ch.x * 32)
            local y = math.random(1, 32) + (ch.y * 32)
            local box = {{
                x = x,
                y = y
            }, {
                x = x + 10,
                y = y + 5
            }}

            -- Check if there are any ghosts
            if not util.area_has_ghosts(surface, box) then
                local pos = {
                    x = x + 5,
                    y = y + 2.5
                }
                return pos
            end
        end
        action = action + 1
    end
end

scanner.add_entity_chunk = function(entity)
    -- Get some variables to work with
    local pos = entity.position
    local ch = {
        x = math.floor(pos.x / 32),
        y = math.floor(pos.y / 32)
    }
    local srf = entity.surface

    -- Create the global surface
    if not global.scanner.surfaces[srf.name] then
        global.scanner.surfaces[srf.name] = {}
    end

    -- Add the chunk to the global surface
    local chid = "x" .. ch.x .. "_y" .. ch.y .. "_" .. srf.name
    global.scanner.surfaces[srf.name][chid] = {
        x = ch.x,
        y = ch.y
    }

end

scanner.init = function()
    if not global.scanner then
        global.scanner = {}
    end

    if not global.scanner.surfaces then
        global.scanner.surfaces = {}
    end

    -- Scan all surfaces for entities and add each entity's chunk to the global surface
    for _, s in pairs(game.surfaces) do
        local ent = s.find_entities_filtered({
            force = "player"
        })
        for _, e in pairs(ent) do
            scanner.add_entity_chunk(e)
        end
    end

end
return scanner
