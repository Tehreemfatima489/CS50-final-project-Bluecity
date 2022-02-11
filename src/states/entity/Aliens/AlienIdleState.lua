

AlienIdleState = Class{__includes = BaseState}

function AlienIdleState:init(tilemap, player, alien)
    self.tilemap = tilemap
    self.player = player
    self.alien = alien
    self.waitTimer = 0
    self.animation = self.alien.animationIdle
    
    self.alien.currentAnimation = self.animation
end

function AlienIdleState:enter(params)
    self.waitPeriod = params.wait
end

function AlienIdleState:update(dt)
    if self.waitTimer < self.waitPeriod then
        self.waitTimer = self.waitTimer + dt
    else
        self.alien:changeState('moving')
    end

    -- calculate difference between Alien and player on X axis
    -- and only chase if <= 5 tiles
    local diffX = math.abs(self.player.x - self.alien.x)

    if diffX < 5 * TILE_SIZE then
        self.alien:changeState('chasing')
    end
end