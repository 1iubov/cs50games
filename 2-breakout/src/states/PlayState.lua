--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    Student: Liubov Sergeeva
    
    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}
x = 1

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    AddBalls = false
    PowerKey = false
    KeyIs = false
    numBricks = math.random(3,8)
    

    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = {}
    self.ball[1] = params.ball1
    self.level = params.level
    self.powerup = Powerup(1)
    self.powerkey = Powerup(10)
    self.recoverPoints = 10000

    -- give ball random starting velocity
    self.ball[1].dx = math.random(-200, 200)
    self.ball[1].dy = math.random(-50, -60)

    -- 2 balls
    self.ball[2] = params.ball2
    self.ball[3] = params.ball3
    self.ball[2].dx = math.random(-200, 200)
    self.ball[2].dy = math.random(-50, -60)
    self.ball[3].dx = math.random(-200, 200)
    self.ball[3].dy = math.random(-50, -60)
    
    Bigger = self.score
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)
    self.ball[1]:update(dt)

    if AddBalls then 
        x = 3 
    else 
        x = 1 
    end
    for i = 1, x do
        if self.ball[i]:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            self.ball[i].y = self.paddle.y - 8
            self.ball[i].dy = -self.ball[i].dy

            --
            -- tweak angle of bounce based on where it hits the paddle
            --

            -- if we hit the paddle on its left side while moving left...
            if self.ball[i].x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                self.ball[i].dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball[i].x))
            
            -- else if we hit the paddle on its right side while moving right...
            elseif self.ball[i].x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                self.ball[i].dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball[i].x))
            end

            gSounds['paddle-hit']:play()
        end
    end

    -- detect collision across all bricks with the balls
    for k, brick in pairs(self.bricks) do
        for i = 1, x do
             -- only check collision if we're in play
            if brick.inPlay and self.ball[i]:collides(brick) then
                if KeyIs and brick.lock == true then
                    brick.lock = false
                    gSounds['unblocked']:play()
                    self.score = self.score + 500
                    KeyIs = false
                end
                if brick.lock == false or brick.unlocked then
                    -- add to score
                    self.score = self.score + (brick.tier * 200 + brick.color * 25)

                    -- paddle increase
                    if self.score > 500 + Bigger then
                        Bigger = self.score
                        if gSizePaddle < 4 then
                            gSizePaddle = gSizePaddle + 1
                        end
                    end

                    -- trigger the brick's hit function, which removes it from play
                    brick:hit()

                    -- num bricks 
                    numBricks = numBricks - 1


                    -- if we have enough points, recover a point of health
                    if self.score > self.recoverPoints then
                        -- can't go above 3 health
                        self.health = math.min(3, self.health + 1)

                        -- multiply recover points by 2
                        self.recoverPoints = self.recoverPoints + math.min(100000, self.recoverPoints * 2)

                        -- play recover sound effect
                        gSounds['recover']:play()
                    end

                    -- go to our victory screen if there are no more bricks left
                    if self:checkVictory() then
                        gSounds['victory']:play()

                        gStateMachine:change('victory', {
                            level = self.level,
                            paddle = self.paddle,
                            health = self.health,
                            score = self.score,
                            highScores = self.highScores,
                            ball = self.ball[1],
                            recoverPoints = self.recoverPoints
                        })
                    end
                else
                    PowerKey = true
                    gSounds['bloked-hit']:play()
                end
                

                --
                -- collision code for bricks
                --
                -- we check to see if the opposite side of our velocity is outside of the brick;
                -- if it is, we trigger a collision on that side. else we're within the X + width of
                -- the brick and should check to see if the top or bottom edge is outside of the brick,
                -- colliding on the top or bottom accordingly 
                --

                -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                if self.ball[i].x + 2 < brick.x and self.ball[i].dx > 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    self.ball[i].dx = -self.ball[i].dx
                    self.ball[i].x = brick.x - 8
                
                -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                elseif self.ball[i].x + 6 > brick.x + brick.width and self.ball[i].dx < 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    self.ball[i].dx = -self.ball[i].dx
                    self.ball[i].x = brick.x + 32
                
                -- top edge if no X collisions, always check
                elseif self.ball[i].y < brick.y then
                    
                    -- flip y velocity and reset position outside of brick
                    self.ball[i].dy = -self.ball[i].dy
                    self.ball[i].y = brick.y - 8
                
                -- bottom edge if no X collisions or top collision, last possibility
                else
                    
                    -- flip y velocity and reset position outside of brick
                    self.ball[i].dy = -self.ball[i].dy
                    self.ball[i].y = brick.y + 16
                end

                -- slightly scale the y velocity to speed up the game, capping at +- 150
                if math.abs(self.ball[i].dy) < 150 then
                    self.ball[i].dy = self.ball[i].dy * 1.02
                end

                -- only allow colliding with one brick, for corners
                break
            end
        end
       
    end
    for i = 1, 1 do
        -- if ball goes below bounds, revert to serve state and decrease health
        if self.ball[i].y >= VIRTUAL_HEIGHT then
            self.health = self.health - 1
            if gSizePaddle > 1 then
                gSizePaddle = gSizePaddle - 1
            end

            gSounds['hurt']:play()

            if self.health == 0 then
                gStateMachine:change('game-over', {
                    score = self.score,
                    highScores = self.highScores
                })
            else
                gStateMachine:change('serve', {
                    paddle = self.paddle,
                    bricks = self.bricks,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    level = self.level,
                    recoverPoints = self.recoverPoints,
                    --powerup = self.powerup
                })
            end
        end
    end
    

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- update powerup
    if numBricks <= 0 then
        Power = true
        numBricks = math.random(10, 18)
    end
    if Power then
        self.powerup:update(dt)
    end

    if self.powerup:collides(self.paddle) then
        gSounds['multiballs']:play()
        for i = 2, 3 do
            -- add setting balls
            self.ball[i].x = self.ball[1].x + math.random(-10,10)
            self.ball[i].y = self.ball[1].y 
            -- velocity 2 and 3 balls
            self.ball[i].dx = math.random(-200, 200)
            self.ball[i].dy = math.random(-50, -60)
        end
        AddBalls = true
    end
    if self.powerup.y > VIRTUAL_HEIGHT or self.powerup:collides(self.paddle) then
        self.powerup:reset()
        Power = false
    end
    if AddBalls then
        self.ball[2]:update(dt)
        self.ball[3]:update(dt)
    end


    -- POWER key
    if PowerKey then
        self.powerkey:update(dt)
    end
    if self.powerkey:collides(self.paddle) then
        KeyIs = true
        PowerKey = false
        gSounds['power']:play()
    end
    if self.powerkey.y > VIRTUAL_HEIGHT or self.powerkey:collides(self.paddle) then
        self.powerkey:reset()
        PowerKey = false
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    self.ball[1]:render()

    -- powerup and 2 balls
    self.powerup:render()
    self.powerkey:render()
    
    if AddBalls then
        self.ball[2]:render()
        self.ball[3]:render()
        love.graphics.setFont(gFonts['small'])
        --love.graphics.printf("addballs = true", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
    love.graphics.setFont(gFonts['small'])
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end
