--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        },
        taken = false
    },

    ['heart'] = {
        type = 'heart',
        texture = 'heart', 
        frame = 1,
        width = 8,
        height = 8,
        solid = false,
        consumable = true,
        taken = false
    },

    ['pot'] = {
        -- TODO
        type = 'pot',
        texture = 'tiles',
        frame = 14,
        width = 16,
        height = 16,
        solid = true,
        defaultState = 'unbroken',
        states = {
            ['unbroken'] = {
                frame = 14
            },
            ['broken'] = {
                frame = 52
            }
        },
        taken = false,
        uped = false
    }
}