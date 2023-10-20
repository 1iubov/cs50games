--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu
    Student: Liubov Sergeeva
    1iubov.valerianovna@gmail.com

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}
local medal = {
    ['medal1'] = love.graphics.newImage('medal1.png'),
    ['medal2'] = love.graphics.newImage('medal3.png'),
    ['medal3'] = love.graphics.newImage('medal5.png')
}

showmedal = 0
--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
    if (self.score >= 1) and (self.score < 3) then
        showmedal = 1
    elseif (self.score >= 3) and (self.score < 5) then
        showmedal = 2
    
    elseif self.score >= 5 then
        showmedal = 3  
    end
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
    if showmedal == 1 then
        love.graphics.draw(medal['medal1'], VIRTUAL_WIDTH / 2 - 20, 118)
    elseif showmedal == 2 then
        love.graphics.draw(medal['medal1'], VIRTUAL_WIDTH / 2 - 50, 118)
        love.graphics.draw(medal['medal2'], VIRTUAL_WIDTH / 2 + 10, 118)
    elseif showmedal == 3 then
        love.graphics.draw(medal['medal1'], VIRTUAL_WIDTH / 2 - 70, 118)
        love.graphics.draw(medal['medal2'], VIRTUAL_WIDTH / 2 - 20, 118)
        love.graphics.draw(medal['medal3'], VIRTUAL_WIDTH / 2 + 30, 118)
    end

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end