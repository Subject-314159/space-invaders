require("__base__/prototypes/entity/character-animations")
local hit_effects = require("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")
local movement_triggers = require("__base__/prototypes/entity/movement-triggers")

local alien = {
    type = "unit",
    name = "si_alien",
    icon = "__core__/graphics/icons/entity/character.png",
    icon_size = 64,
    icon_mipmaps = 4,
    flags = {"placeable-player", "placeable-enemy", "placeable-off-grid", "not-repairable", "breaths-air"},
    max_health = 500,
    order = "b-a-a",
    subgroup = "enemies",
    resistances = {},
    healing_per_tick = 0.01,
    collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
    selection_box = {{-0.4, -1.4}, {0.4, 0.2}},
    hit_visualization_box = {{-0.2, -1.1}, {0.2, 0.2}},
    sticker_box = {{-0.2, -1}, {0.2, 0}},
    damaged_trigger_effect = hit_effects.biter(),
    attack_parameters = {
        type = "projectile",
        range = 0.5,
        cooldown = 35,
        cooldown_deviation = 0.15,
        ammo_type = make_unit_melee_ammo_type(7),
        sound = sounds.biter_roars(0.35),
        animation = {
            layers = {character_animations.level1.mining_tool, character_animations.level1.mining_tool_mask,
                      character_animations.level1.mining_tool_shadow}
        },
        range_mode = "bounding-box-to-bounding-box"
    },
    vision_distance = 30,
    movement_speed = 0.2,
    distance_per_frame = 0.125,
    pollution_to_join_attack = 4,
    distraction_cooldown = 300,
    min_pursue_time = 10 * 60,
    max_pursue_distance = 50,
    corpse = "character-corpse",
    dying_explosion = "small-biter-die",
    dying_sound = sounds.biter_dying(0.5),
    working_sound = sounds.biter_calls(0.75),
    run_animation = {
        layers = {character_animations.level1.running, character_animations.level1.running_mask,
                  character_animations.level1.running_shadow}
    },
    running_sound_animation_positions = {5, 16},
    walking_sound = sounds.biter_walk(0.3),
    ai_settings = biter_ai_settings,
    water_reflection = {
        pictures = {
            filename = "__base__/graphics/entity/character/character-reflection.png",
            priority = "extra-high",
            -- flags = { "linear-magnification", "not-compressed" },
            -- default value: flags = { "terrain-effect-map" },
            width = 13,
            height = 19,
            shift = util.by_pixel(0, 67 * 0.5),
            scale = 5,
            variation_count = 1
        },
        rotate = false,
        orientation_to_variation = false
    }
}

data:extend({alien})
