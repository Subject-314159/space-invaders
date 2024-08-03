local util = {}

util.area_has_ghosts = function(surface, area)
    local gh = surface.find_entities_filtered({
        area = area,
        name = "entity-ghost",
        limit = 1
    })

    return gh and #gh > 0
end

return util
