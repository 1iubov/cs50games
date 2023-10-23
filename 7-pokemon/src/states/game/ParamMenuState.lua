-- Меню без выбора о параметрах игрока
-- HP, attack, defense, speed

ParamMenuState = Class{__includes = BaseState}

function ParamMenuState:init(battleState, callback)
    self.battleState = battleState
    self.playerPokemon = self.battleState.player.party.pokemon[1]

    self.callback = callback or function() end

    self.HP = self.playerPokemon.HP
    self.Attack = self.playerPokemon.attack
    self.Defense = self.playerPokemon.defense
    self.Speed = self.playerPokemon.speed
    self.playerPokemon:levelUp()
    self.upHP = self.playerPokemon.HP
    self.upAttack  = self.playerPokemon.attack
    self.upDefense = self.playerPokemon.defense
    self.upSpeed = self.playerPokemon.speed

    

    self.ParamMenu = Menu {
        x = 0,
        y = VIRTUAL_HEIGHT - 122,
        width = VIRTUAL_WIDTH,
        height = 122,
        select = false,
        items = {
            {
                text = 'Health '.. tostring(self.HP) .. ' + ' .. tostring(self.upHP - self.HP) .. ' = ' .. tostring(self.upHP),
                onSelect = function()
                    self.callback()
                    gStateStack:pop() 
                end
            },
            {
                text = 'Attack '.. tostring(self.Attack) .. ' + ' .. tostring(self.upAttack - self.Attack) .. ' = ' .. tostring(self.upAttack)
            },
            {
                text = 'Defense '.. tostring(self.Defense) .. ' + ' .. tostring(self.upDefense - self.Defense) .. ' = ' .. tostring(self.upDefense)
            },
            {
                text = 'Speed '.. tostring(self.Speed) .. ' + ' .. tostring(self.upSpeed - self.Speed) .. ' = ' .. tostring(self.upSpeed)
            }
        }
    }
end

function ParamMenuState:update(dt)
    self.ParamMenu:update(dt)
end

function ParamMenuState:render()
    self.ParamMenu:render()
end