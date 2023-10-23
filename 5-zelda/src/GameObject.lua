--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    -- default empty collision callback
    self.onCollide = function() end

    -- for heart
    self.taken = def.taken

    -- for pot
    self.uped = def.uped -- after 'space' on pot and before player.withpot
    self.inarms = def.inarms -- when player.withpot
    self.flying = def.flying -- boolean time flying pot
    self.direction = def.direction -- flying direction 

    -- flying pot
    self.bumped = false
    self.speed = 80
    self.tik = 0

    
end

function GameObject:update(dt)
    if self.type == 'pot' and self.flying and not self.bumped then
        if self.tik < 120 then
            self.tik = self.tik + 1
            if self.direction == 'left' then
                self.x = self.x - self.speed * dt
                
                if self.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then 
                    self.x = MAP_RENDER_OFFSET_X + TILE_SIZE
                    self.bumped = true
                    gSounds['hit-pot']:play()  
                end
            elseif self.direction == 'right' then
                self.x = self.x + self.speed * dt
        
                if self.x + self.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 then
                    self.x = VIRTUAL_WIDTH - TILE_SIZE * 2 - self.width
                    self.bumped = true
                    gSounds['hit-pot']:play()  
                end
            elseif self.direction == 'up' then
                self.y = self.y - self.speed * dt
        
                if self.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2 then 
                    self.y = MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2
                    self.bumped = true
                    gSounds['hit-pot']:play()  
                end
            elseif self.direction == 'down' then
                self.y = self.y + self.speed * dt
        
                local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
                    + MAP_RENDER_OFFSET_Y - TILE_SIZE
        
                if self.y + self.height >= bottomEdge then
                    self.y = bottomEdge - self.height
                    self.bumped = true
                    gSounds['hit-pot']:play()  
                end
            end
        else
             self.bumped = true 
             gSounds['hit-pot']:play()  
        end
    end
    if self.bumped then
        self.flying = false
        if self.state == 'unbroken' then
            self.state = 'broken'
        end
    end
    --if self.state == 'broken' then
        
    --end
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    if self.type == 'switch' or self.type == 'pot' then
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
        
    elseif self.taken == false then 
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
    end
end