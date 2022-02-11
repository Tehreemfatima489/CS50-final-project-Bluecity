

--
-- libraries
--
Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'


--

-- utility
require 'src/constants'
require 'src/StateMachine'
require 'src/Util'

-- game states
require 'src/states/BaseState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'

-- entity states

require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerFallingState'
require 'src/states/entity/PlayerJumpState'
require 'src/states/entity/PlayerJumperState'
require 'src/states/entity/PlayerWalkingState'
require 'src/states/entity/PlayerPowerupState'

require 'src/states/entity/Aliens/AlienChasingState'
require 'src/states/entity/Aliens/AlienIdleState'
require 'src/states/entity/Aliens/AlienMovingState'

-- general
require 'src/Animation'
require 'src/Entity'
require 'src/GameObject'
require 'src/GameLevel'
require 'src/LevelMaker'
require 'src/Player'
require 'src/Alien'
require 'src/Tile'
require 'src/TileMap'


gSounds = {
    ['jump'] = love.audio.newSource('sounds/jump.wav'),
    ['death'] = love.audio.newSource('sounds/death.wav'),
    ['music'] = love.audio.newSource('sounds/music.wav'),
    ['powerup-reveal'] = love.audio.newSource('sounds/powerup-reveal.wav'),
    ['pickup'] = love.audio.newSource('sounds/pickup.wav'),
    ['empty-block'] = love.audio.newSource('sounds/empty-block.wav'),
    ['kill'] = love.audio.newSource('sounds/kill.wav'),
    ['kill2'] = love.audio.newSource('sounds/kill2.wav')
}

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/entity.png'),
    ['mushrooms'] = love.graphics.newImage('graphics/mushrooms.png'),
    ['gems'] = love.graphics.newImage('graphics/gems.png'),
    ['backgrounds'] = love.graphics.newImage('graphics/back.png'),
    ['signs'] = love.graphics.newImage('graphics/ladders.png'),
    ['jumpers'] = love.graphics.newImage('graphics/ladders.png'),
    ['boards'] = love.graphics.newImage('graphics/sign.png'),
    ['spikes'] = love.graphics.newImage('graphics/skulls.png'),
    ['potion'] = love.graphics.newImage('graphics/red_potion.png'),
    ['monster'] = love.graphics.newImage('graphics/creatures.png'),
    ['creatures'] = love.graphics.newImage('graphics/creatures.png'),
    ['locks'] = love.graphics.newImage('graphics/lockin.jpg'),
    ['bar'] = love.graphics.newImage('graphics/bar.png'),
    ['flags'] = love.graphics.newImage('graphics/flags.png'),
    ['mario'] = love.graphics.newImage('graphics/Old hero.png'),
    ['keys'] = love.graphics.newImage('graphics/keys_and_locks.png'),
    ['coins'] = love.graphics.newImage('graphics/gems.png'),
    ['toppers'] = love.graphics.newImage('graphics/tile_tops.png'),
    ['frog'] = love.graphics.newImage('graphics/entity.png'),
    ['truck'] = love.graphics.newImage('graphics/entity.png'),
    ['shrooms'] = love.graphics.newImage('graphics/shrooms.png'),
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'],16, 16),
    ['frog'] = GenerateQuads(gTextures['frog'], 16, 16),
    ['truck'] = GenerateQuads(gTextures['truck'], 16, 19),
    ['spikes'] = GenerateQuads(gTextures['spikes'],16, 10),
    ['shrooms'] = GenerateQuads(gTextures['shrooms'], 16, 15),
    ['boards'] = GenerateQuads(gTextures['boards'], 18, 20),
    ['coins'] = GenerateQuads(gTextures['coins'], 16, 16),
    ['toppers'] = GenerateQuads(gTextures['toppers'], 16, 16),
    ['signs'] = GenerateQuads(gTextures['signs'], 16, 16),
    ['jumpers'] = GenerateQuads(gTextures['jumpers'], 16, 16),
    ['bar'] = GenerateQuads(gTextures['bar'], 27, 10),
    ['mushrooms'] = GenerateQuads(gTextures['mushrooms'], 16, 16),
    ['pillars'] = GenerateQuads(gTextures['mushrooms'], 16, 16),
    ['gems'] = GenerateQuads(gTextures['gems'], 16, 16),
    ['backgrounds'] = GenerateQuads(gTextures['backgrounds'], 384, 224),
    ['potion'] = GenerateQuads(gTextures['potion'], 16, 16),
    ['mario'] = GenerateQuads(gTextures['mario'], 16, 16),
    ['creatures'] = GenerateQuads(gTextures['creatures'], 16, 16),
    ['locks'] = GenerateQuads(gTextures['locks'],16, 16),
    ['keys'] = GenerateQuads(gTextures['keys'], 16, 16),
    ['flags'] = GenerateQuads(gTextures['flags'],31, 29),
    ['monster'] = GenerateQuads(gTextures['monster'], 16, 16)

}

-- these need to be added after gFrames is initialized because they refer to gFrames from within


gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['title'] = love.graphics.newFont('fonts/font.ttf', 32)
}
