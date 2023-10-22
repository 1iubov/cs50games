--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
    Student: Liubov Sergeeva

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}


function Tile:init(x, y, color, variety, shine)
    
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety
    self.count = shine

    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 20)
    self.psystem:setParticleLifetime(2, 4)
    self.psystem:setLinearAcceleration(-3, -3, 3, 3) -- Random movement in all directions.
    self.psystem:setEmissionRate(10)
    if self.count == 10 then
        self.shine = true
        self.psystem:setColors(
            251/255,
            242/255,
            54/255, 10/255,
            251/255,
            242/255,
            54/255, 150/255
            )
        self.psystem:emit(15)
    else
        self.shine = false
    end


end

function Tile:update(dt)
    if self.shine == true then
        self.psystem:update(dt)        
    end
end

function Tile:render(x, y)
    
    -- draw shadow
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    -- draw tile itself
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
    if self.shine == true then
        -- draw particles 
        love.graphics.draw(self.psystem, self.x + x + 16, self.y + y + 16)
    end    
end


