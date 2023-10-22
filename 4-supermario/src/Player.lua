--[[
    GD50
    Super Mario Bros. Remake

    -- Player Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
    Student: Liubov Sergeeva
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
    self.score = 0

end

function Player:update(dt)
    Entity.update(self, dt)
    self.currentAnimation:update(dt)
end

function Player:render()
    Entity.render(self)
    
end

function Player:checkLeftCollisions(dt)
    -- check for left two tiles collision
    local tileTopLeft = self.map:pointToTile(self.x + 1, self.y + 1)
    local tileBottomLeft = self.map:pointToTile(self.x + 1, self.y + self.height - 1)

    -- place player outside the X bounds on one of the tiles to reset any overlap
    if (tileTopLeft and tileBottomLeft) and (tileTopLeft:collidable() or tileBottomLeft:collidable()) then
        self.x = (tileTopLeft.x - 1) * TILE_SIZE + tileTopLeft.width - 1
    else
        
        -- allow us to walk atop solid objects even if we collide with them
        self.y = self.y - 1
        local collidedObjects = self:checkObjectCollisions()
        self.y = self.y + 1

        -- reset X if new collided object
        if #collidedObjects > 0 then
            self.x = self.x + PLAYER_WALK_SPEED * dt
        end
    end
end

function Player:checkRightCollisions(dt)
    -- check for right two tiles collision
    local tileTopRight = self.map:pointToTile(self.x + self.width - 1, self.y + 1)
    local tileBottomRight = self.map:pointToTile(self.x + self.width - 1, self.y + self.height - 1)

    -- place player outside the X bounds on one of the tiles to reset any overlap
    if (tileTopRight and tileBottomRight) and (tileTopRight:collidable() or tileBottomRight:collidable()) then
        self.x = (tileTopRight.x - 1) * TILE_SIZE - self.width
    else
        
        -- allow us to walk atop solid objects even if we collide with them
        self.y = self.y - 1
        local collidedObjects = self:checkObjectCollisions()
        self.y = self.y + 1

        -- reset X if new collided object
        if #collidedObjects > 0 then
            self.x = self.x - PLAYER_WALK_SPEED * dt
        end
    end
end

function Player:checkObjectCollisions()
    local collidedObjects = {}

    for k, object in pairs(self.level.objects) do
        if object:collides(self) then
            if object.solid and object.key then
                if keyishere then
                    local portal = GameObject {
                        texture = 'portal',
                        x = (self.map.width - 5) * TILE_SIZE,
                        y = 3 * TILE_SIZE,
                        width = 16,
                        height = 48,
                        frame = 3,
                        collidable = false,
                        consumable = false,
                        solid = false,
                    }
                    local flag = GameObject {
                        texture = 'flag-portal',
                        x = (self.map.width - 5) * TILE_SIZE + TILE_SIZE/ 2,
                        y = 3 * TILE_SIZE,
                        width = 16,
                        height = 16,
                        animation = Animation {
                            frames = {7, 8, 7, 8, 9},
                            interval = 0.3
                        },
                        collidable = false,
                        consumable = true,
                        solid = false,
                        onConsume = function(player, object)
                            
                            if lvlscore then
                                lvlscore = self.score + lvlscore
                                lvl = lvl + 1
                            else
                                lvlscore = self.score
                                lvl = 2
                            end
                            gSounds['pickup']:play()
                            player.score = player.score + 100
                            gStateMachine:change('play', {
                                score = lvlscore,
                                width = math.floor(50 + (20 * lvl))
                            })
                            
                            
                        end
                    }

                    
                    table.insert(self.level.objects, portal)
                    table.insert(self.level.objects, flag)
        
                    gSounds['powerup-reveal']:play()

                    
                    table.remove(self.level.objects, k)
                    keyinpocket = false
                    gPortaltrue = true
                    
                else
                    table.insert(collidedObjects, object)
                end
            elseif object.solid then
                table.insert(collidedObjects, object)
            elseif object.consumable then
                object.onConsume(self)
                table.remove(self.level.objects, k)
            end
        end
    end

    return collidedObjects
end