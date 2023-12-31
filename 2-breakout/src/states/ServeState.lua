--[[
    GD50
    Breakout Remake

    -- ServeState Class --

    Author: Colton Ogden
    Student: Liubov Sergeeva

    The state in which we are waiting to serve the ball; here, we are
    basically just moving the paddle left and right with the ball until we
    press Enter, though everything in the actual game now should render in
    preparation for the serve, including our current health and score, as
    well as the level we're on.
]]

ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
    -- grab game state from params
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.level = params.level
    self.recoverPoints = params.recoverPoints
    --self.powerup = Powerup(1)
    --self.powerkey = Powerup(10)

    -- init new ball (random color 1-4)

    self.ball = {}
    self.ball[1] = Ball()
    self.ball[1].skin = math.random(4)

    -- init new 2 balls (color 5,7)
    self.ball[2] = Ball()
    self.ball[2].skin = 5
    self.ball[3] = Ball()
    self.ball[3].skin = 7

end

function ServeState:update(dt)
    -- have the ball track the player
    self.paddle:update(dt)
    for i = 1, x do
        self.ball[i].x = self.paddle.x + (self.paddle.width / 2) - 4
        self.ball[i].y = self.paddle.y - 8
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- pass in all important state info to the PlayState
        gStateMachine:change('play', {
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            highScores = self.highScores,
            ball1 = self.ball[1],
            ball2 = self.ball[2],
            ball3 = self.ball[3],
            level = self.level,
            recoverPoints = self.recoverPoints,
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if AddBalls then
        x = 3
    else
        x = 1
    end

    
end

function ServeState:render()
    self.paddle:render()
    for i = 1, x do
        self.ball[i]:render()
    end
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level), 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end