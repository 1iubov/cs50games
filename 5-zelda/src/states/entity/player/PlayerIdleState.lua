--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        if self.entity.withpot then
            self.entity:changeState('walkpot')
        else
            self.entity:changeState('walk')
        end
    end

    if love.keyboard.wasPressed('space') and self.entity.tookpot then
        --self.entity:changeState('walkpot')
        self.entity.tookpot = false
        self.entity.withpot = true
        self.entity:changeState('idle')
        gSounds['pickpot']:play()  
    elseif love.keyboard.wasPressed('space') and self.entity.withpot then
        self.entity.withpot = false
        self.entity.tookpot = false
        self.entity:changeState('idle')
        
    elseif love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end
end