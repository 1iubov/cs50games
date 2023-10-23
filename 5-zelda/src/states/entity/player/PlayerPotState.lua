--[[
    GD50
    Legend of Zelda

    Author: Liubov Sergeeva
    1iubov.valerianovna@gmail.com
]]

PlayerPotState = Class{__includes = EntityWalkState}

function PlayerPotState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0
    self.uppot = false
    self.timeruppot = false
    
end

function PlayerPotState:update(dt)
    
    --[[if self.entity.currentAnimation.timesPlayed < 1  and not self.uppot then
        self.entity:changeAnimation('pot-take-' .. self.entity.direction)
        self.uppot = true 
    else]]
        if love.keyboard.isDown('left') then
            self.entity.direction = 'left'
            self.entity:changeAnimation('pot-left')
        elseif love.keyboard.isDown('right') then
            self.entity.direction = 'right'
            self.entity:changeAnimation('pot-right')
        elseif love.keyboard.isDown('up') then
            self.entity.direction = 'up'
            self.entity:changeAnimation('pot-up')
        elseif love.keyboard.isDown('down') then
            self.entity.direction = 'down'
            self.entity:changeAnimation('pot-down')
        else
            self.entity:changeState('idle')
        end
    --end

    if love.keyboard.wasPressed('space')  then
        self.entity.tookpot = false
        self.entity.withpot = false
        self.entity:changeState('idle')
    end


    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)

    -- if we bumped something when checking collision, check any object collisions
    if self.bumped then
        if self.entity.direction == 'left' then
            
            -- temporarily adjust position into the wall, since bumping pushes outward
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
            

            -- readjust
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt


        elseif self.entity.direction == 'right' then
            
            -- temporarily adjust position
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
            

            -- readjust
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt


        elseif self.entity.direction == 'up' then
            
            -- temporarily adjust position
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
            

            -- readjust
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
        elseif self.entity.direction == 'down' then
            
            -- temporarily adjust position
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt

            -- readjust
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
        end
    end
end
