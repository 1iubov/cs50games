   
-- Powerup Class --
-- Author: Liubov Sergeeva

Powerup = Class{}

function Powerup:init(skin)
    self.x = math.random(10, VIRTUAL_WIDTH - 10)
    self.y = -16

    self.width = 16
    self.height = 16

    self.skin = skin
end

function Powerup:update(dt)
    self.y = self.y + 1
end

function Powerup:render()
    love.graphics.draw(gTextures['main'], gFrames['powerup'][self.skin],self.x, self.y)
end

function Powerup:reset()
    self.x = math.random(10, VIRTUAL_WIDTH - 10)
    self.y = -16
end

function Powerup:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 
    return true
end