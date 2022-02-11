

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0
    self.level = LevelMaker.generate(100, 10)
    self.tileMap = self.level.tileMap
    self.background = 1
    self.backgroundX = 0

    self.gravityOn = true
    self.gravityAmount = 15
    self.player = Player({
        x = 0, y = 0,
        width = 16, height = 16,
        texture = 'mario',
        stateMachine = StateMachine {
            ['idle'] = function() return PlayerIdleState(self.player) end,
            ['walking'] = function() return PlayerWalkingState(self.player) end,
            ['jump'] = function() return PlayerJumpState(self.player, self.gravityAmount) end,
            ['jumper'] = function() return PlayerJumperState(self.player, self.gravityAmount) end,
            ['falling'] = function() return PlayerFallingState(self.player, self.gravityAmount) end,
            ['powerup'] = function() return PlayerPowerupState(self.player, self.gravityAmount) end
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
    self.level:update(dt)

    -- constrain player X no matter which state
    if self.player.x <= 0 then
        self.player.x = 0
    elseif self.player.x > 1730 + self.tileMap.width - self.player.width then
        self.player.x = 1730 + self.tileMap.width - self.player.width
    end

    self:updateCamera()
end

function PlayState:render()
    love.graphics.push()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 270), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 270),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)

    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))

    self.level:render()

    self.player:render()
    love.graphics.pop()

    -- render score
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print(tostring(self.player.score), 5, 5)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(tostring(self.player.score), 4, 4)
end

function PlayState:updateCamera()
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.tileMap.width,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

    -- adjust background X to move a third the rate of the camera for parallax
    self.backgroundX = (self.camX / 3) % 256
end

--[[
    Adds a series of enemies to the level randomly.
]]
function PlayState:spawnEnemies()
    -- spawn orlins in the level
    for x = 1, self.tileMap.levelwidth do

        -- flag for whether there's ground on this column of the level
        local groundFound = false

        for y = 1, self.tileMap.height do
            if not groundFound then
                if self.tileMap.tiles[y][x].id == TILE_ID_GROUND then
                    groundFound = true

                    -- random chance, 1 in 20
                    if math.random(20) == 1 then

                        -- instantiate orlin, declaring in advance so we can pass it into state machine
                        local greener
                        greener = Alien {
                            texture = 'frog',
                            x = (x - 1) * TILE_SIZE,
                            y = (y - 2) * TILE_SIZE + 2,
                            width = 16,
                            height = 16,

                            animationMoving =  Animation {
                                frames = {76,78},
                                interval = 0.5
                            },
                            animationIdle =  Animation {
                                frames = {77},
                                interval = 0.5
                            },
                            stateMachine = StateMachine {
                                ['idle'] = function() return AlienIdleState(self.tileMap, self.player, greener) end,
                                ['moving'] = function() return AlienMovingState(self.tileMap, self.player, greener) end,
                                ['chasing'] = function() return AlienChasingState(self.tileMap, self.player, greener) end
                            }
                        }
                        greener:changeState('idle', {
                            wait = math.random(5)
                        })

                        table.insert(self.level.entities, greener)
                    end
                    if math.random(30) == 1 then

                        -- instantiate orlin, declaring in advance so we can pass it into state machine
                        local orlin
                        orlin = Alien {
                            texture = 'frog',
                            x = (x - 1) * TILE_SIZE,
                            y = (y - 2) * TILE_SIZE + 2,
                            width = 16,
                            height = 16,

                            animationMoving =  Animation {
                                frames = {12, 10},
                                interval = 0.3
                            },
                            animationIdle =  Animation {
                                frames = {11},
                                interval = 1
                            },
                            stateMachine = StateMachine {
                                ['idle'] = function() return AlienIdleState(self.tileMap, self.player, orlin) end,
                                ['moving'] = function() return AlienMovingState(self.tileMap, self.player, orlin) end,
                                ['chasing'] = function() return AlienChasingState(self.tileMap, self.player, orlin) end
                            }
                        }
                        orlin:changeState('idle', {
                            wait = math.random(5)
                        })

                        table.insert(self.level.entities, orlin)
                    end
                    if math.random(30) == 1 then

                        -- instantiate orlin, declaring in advance so we can pass it into state machine
                        local blower
                        blower = Alien {
                            texture = 'frog',
                            x = (x - 1) * TILE_SIZE,
                            y = (y - 2) * TILE_SIZE + 2,
                            width = 16,
                            height = 16,

                            animationMoving =  Animation {
                                frames = {7, 8},
                                interval = 0.3
                            },
                            animationIdle =  Animation {
                                frames = {9},
                                interval = 1
                            },
                            stateMachine = StateMachine {
                                ['idle'] = function() return AlienIdleState(self.tileMap, self.player, blower) end,
                                ['moving'] = function() return AlienMovingState(self.tileMap, self.player, blower) end,
                                ['chasing'] = function() return AlienChasingState(self.tileMap, self.player, blower) end
                            }
                        }
                        blower:changeState('idle', {
                            wait = math.random(5)
                        })

                        table.insert(self.level.entities, blower)
                    end
                    if math.random(20) == 1 then
                        local monster 
                        monster = Alien {
                            texture = 'monster',
                            x = (x - 1) * TILE_SIZE,
                            y = (y - 2) * TILE_SIZE ,
                            width = 16,
                            height = 16,
                            animationMoving =  Animation {
                                frames = {44, 45},
                                interval = 0.3
                            },
                            animationIdle =  Animation {
                                frames = {46},
                                interval = 1
                            },
                            stateMachine = StateMachine {
                                ['idle'] = function() return AlienIdleState(self.tileMap, self.player, monster) end,
                                ['moving'] = function() return AlienMovingState(self.tileMap, self.player, monster) end,
                                ['chasing'] = function() return AlienChasingState(self.tileMap, self.player, monster) end
                            }
                        }
                        monster:changeState('idle', {
                            wait = math.random(5)
                        })

                        table.insert(self.level.entities, monster)
                    end
                            
                        
                    if math.random(30) == 1 then

                        -- instantiate orlin, declaring in advance so we can pass it into state machine
                        local wrecker
                        wrecker = Alien {
                            texture = 'truck',
                            x = (x - 1) * TILE_SIZE,
                            y = (y - 3) * TILE_SIZE + 2,
                            width = 16,
                            height = 16,

                            animationMoving =  Animation {
                                frames = {73, 74},
                                interval = 0.3
                            },
                            animationIdle =  Animation {
                                frames = {73},
                                interval = 1
                            },
                            stateMachine = StateMachine {
                                ['idle'] = function() return AlienIdleState(self.tileMap, self.player, wrecker) end,
                                ['moving'] = function() return AlienMovingState(self.tileMap, self.player, wrecker) end,
                                ['chasing'] = function() return AlienChasingState(self.tileMap, self.player, wrecker) end
                            }
                        }
                        wrecker:changeState('idle', {
                            wait = math.random(5)
                        })

                        table.insert(self.level.entities, wrecker)
                    end
                end
            end
        end
    end
end
