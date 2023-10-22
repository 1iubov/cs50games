--[[
    GD50
    Super Mario Bros. Remake

    -- PlayState Class --
    Student: Liubov Sergeeva
]]
PlayState = Class{__includes = BaseState}
widthlvl = 40

function PlayState:enter(params)
    if params.score then 
        self.score = params.score
    else 
        self.score = 0
    end
    if params.width then
        self.width = params.width
    else
        self.width = 40
    end
    widthlvl = self.width
    
end

function PlayState:init()
    self.camX = 0
    self.camY = 0
    
    self.level = LevelMaker.generate(widthlvl, 10)
    self.tileMap = self.level.tileMap
    self.background = math.random(3)
    self.backgroundX = 0
    
   

    self.gravityOn = true
    self.gravityAmount = 6

    -- looking for ground 
    local PersX = 100
    for x = 1, self.tileMap.width do
        if self.tileMap.tiles[7][x].id == TILE_ID_GROUND and x < PersX then
            PersX = x
        end
    end


    self.player = Player({
        x = PersX * TILE_SIZE - TILE_SIZE, y = 0,
        width = 16, height = 20,
        texture = 'green-alien',
        stateMachine = StateMachine {
            ['idle'] = function() return PlayerIdleState(self.player) end,
            ['walking'] = function() return PlayerWalkingState(self.player) end,
            ['jump'] = function() return PlayerJumpState(self.player, self.gravityAmount) end,
            ['falling'] = function() return PlayerFallingState(self.player, self.gravityAmount) end
        },
        map = self.tileMap,
        level = self.level
    })

    self:spawnEnemies()

    self.player:changeState('falling')

    

end

function PlayState:update(dt)
    Timer.update(dt)

    -- remove any nils from pickups, etc.
    self.level:clear()

    -- update player and level
    self.player:update(dt)
    
    if self.score == 0 and self.player.score > 0 then
        self.lvlscore = self.player.score
    else
        self.lvlscore = self.score + self.player.score
    end
    
    self.level:update(dt)
    if not keyishere then
        self:updateCamera()
    else
        if not self.camX == (93 * TILE_SIZE) and gPortaltrue == false then
            self.camX = self.camX + 2 * dt
        else
            gPortaltrue = true
            self:updateCamera()
        end
    end
    

    -- constrain player X no matter which state
    if self.player.x <= 0 then
        self.player.x = 0
    elseif self.player.x > TILE_SIZE * self.tileMap.width - self.player.width then
        self.player.x = TILE_SIZE * self.tileMap.width - self.player.width
    end
end

function PlayState:render()
    love.graphics.push()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    
    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    
    self.level:render()

    self.player:render()
    love.graphics.pop()
    
    -- render score
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(tostring(self.lvlscore), 5, 5)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(self.lvlscore), 4, 4)
    
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(tostring(lvl), VIRTUAL_WIDTH - 16, 4)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(tostring(lvl)), VIRTUAL_WIDTH - 17, 4)
    love.graphics.setColor(1, 1, 1, 1)
    

    if keyinpocket then 
        love.graphics.draw(gTextures['keys-blocks'], gFrames['keys-blocks'][colorkey], 5, 18)
    elseif keyishere then 
        love.graphics.draw(gTextures['flag-portal'], gFrames['flag-portal'][7], 5, 20)
    end
end

function PlayState:updateCamera()
    
     -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
     -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
    math.min(TILE_SIZE * self.tileMap.width - VIRTUAL_WIDTH,
    self.player.x - (VIRTUAL_WIDTH / 2 - 8)))
    
    -- adjust background X to move a third the rate of the camera for parallax
    self.backgroundX = (self.camX / 3) % 256
end

--[[
    Adds a series of enemies to the level randomly.
]]
function PlayState:spawnEnemies()
    -- spawn snails in the level
    for x = 1, self.tileMap.width do

        -- flag for whether there's ground on this column of the level
        local groundFound = false

        for y = 1, self.tileMap.height do
            if not groundFound then
                if self.tileMap.tiles[y][x].id == TILE_ID_GROUND then
                    groundFound = true

                    -- random chance, 1 in 20
                    if math.random(20) == 1 then
                        
                        -- instantiate snail, declaring in advance so we can pass it into state machine
                        local snail
                        snail = Snail {
                            texture = 'creatures',
                            x = (x - 1) * TILE_SIZE,
                            y = (y - 2) * TILE_SIZE + 2,
                            width = 16,
                            height = 16,
                            stateMachine = StateMachine {
                                ['idle'] = function() return SnailIdleState(self.tileMap, self.player, snail) end,
                                ['moving'] = function() return SnailMovingState(self.tileMap, self.player, snail) end,
                                ['chasing'] = function() return SnailChasingState(self.tileMap, self.player, snail) end
                            }
                        }
                        snail:changeState('idle', {
                            wait = math.random(5)
                        })

                        table.insert(self.level.entities, snail)
                    end
                end
            end
        end
    end
    

end

