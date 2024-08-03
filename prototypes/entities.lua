require("util")
local sounds = require("__base__/prototypes/entity/sounds")

data:extend({{
    type = "container",
    name = "si_crashed-rocket",
    icon = "__base__/graphics/icons/crash-site-spaceship.png",
    icon_size = 64,
    icon_mipmaps = 4,
    flags = {"placeable-player", "placeable-enemy", "placeable-off-grid", "not-repairable"},
    map_color = {
        r = 0,
        g = 0.365,
        b = 0.58,
        a = 1
    },
    max_health = 600,
    alert_when_damaged = false,
    allow_copy_paste = false,
    resistances = {{
        type = "fire",
        percent = 100
    }},
    inventory_size = 5,
    enable_inventory_bar = false,
    minable = {
        mining_time = 2.3
    },
    collision_box = {{-5, -2.5}, {5, 2.5}},
    selection_box = {{-5, -2.5}, {5, 2.5}},
    dying_explosion = "nuke-explosion",

    picture = {
        filename = "__space-invaders__/graphics/entities/crashed-rocket.png",
        priority = "very-low",
        width = 738,
        height = 529,
        shift = util.by_pixel(-12, 34),
        dice_x = 4,
        dice_y = 3,
        scale = 0.5,
        hr_version = {
            filename = "__space-invaders__/graphics/entities/hr-crashed-rocket.png",
            priority = "very-low",
            width = 738,
            height = 529,
            shift = util.by_pixel(5, -4),
            dice_x = 4,
            dice_y = 3,
            scale = 0.5 -- TODO: Make scaled
        }

    },
    vehicle_impact_sound = sounds.generic_impact
}})
