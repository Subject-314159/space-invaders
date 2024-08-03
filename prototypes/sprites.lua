require("util")

data:extend({{
    type = "sprite",
    name = "si_rocket",
    priority = "extra-high-no-scale",
    layers = {{
        filename = "__base__/graphics/entity/rocket-silo/02-rocket.png",
        width = 154,
        height = 300,
        shift = util.by_pixel(-4, -28),
        hr_version = {
            filename = "__base__/graphics/entity/rocket-silo/hr-02-rocket.png",
            width = 310,
            height = 596,
            shift = util.by_pixel(-5, -27),
            scale = 0.5
        }
    }}
}, {
    type = "sprite",
    name = "si_rocket-shadow",
    priority = "extra-high-no-scale",
    layers = {{
        filename = "__base__/graphics/entity/rocket-silo/09-rocket-shadow.png",
        priority = "medium",
        width = 336,
        height = 110,
        draw_as_shadow = true,
        shift = util.by_pixel(146, 120),
        hr_version = {
            filename = "__base__/graphics/entity/rocket-silo/hr-09-rocket-shadow.png",
            priority = "medium",
            width = 672,
            height = 216,
            draw_as_shadow = true,
            shift = util.by_pixel(146, 121),
            scale = 0.5
        }
    }}
}, {
    type = "sprite",
    name = "si_all-your-base",
    filename = "__space-invaders__/graphics/images/all-your-base.png",
    priority = "medium",
    width = 400,
    height = 200
}})
