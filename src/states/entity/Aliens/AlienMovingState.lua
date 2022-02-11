

AlienMovingState = Class{__includes = BaseState}

function AlienMovingState:init(tilemap, player, alien)
    self.tilemap = tilemap
    self.player = player
    self.alien = alien
    self.animation = self.alien.animationMoving
    
    self.alien.currentAnimation = self.animation

    self.movingDirection = math.random(2) == 1 and 'left' or 'right'
    self.alien.direction = self.movingDirection
    self.movingDuration = math.random(5)
    self.movingTimer = 0
end

function AlienMovingState:update(dt)
    self.movingTimer = self.movingTimer + dt
    self.alien.currentAnimation:update(dt)

    -- reset movement direction and timer if timer is above duration
    if self.movingTimer > self.movingDuration then

        -- chance to go into idle state randomly
        if math.random(4) == 1 then
            self.alien:changeState('idle', {

                -- random amount of time for Alien to be idle
                wait = math.random(5)
            })
        else
            self.movingDirection = math.random(2) == 1 and 'left' or 'right'
            self.alien.direction = self.movingDirection
            self.movingDuration = math.random(5)
            self.movingTimer = 0
        end
    elseif self.alien.direction == 'left' then
        self.alien.x = self.alien.x - Alien_MOVE_SPEED * dt

        -- stop the Alien if there's a missing tile on the floor to the left or a solid tile directly left
        local tileLeft = self.tilemap:pointToTile(self.alien.x, self.alien.y)
        local tileBottomLeft = self.tilemap:pointToTile(self.alien.x, self.alien.y + self.alien.height)

        if (tileLeft and tileBottomLeft) and (tileLeft:collidable() or not tileBottomLeft:collidable()) then
            self.alien.x = self.alien.x + Alien_MOVE_SPEED * dt

            -- reset direction if we hit a wall
            self.movingDirection = 'right'
            self.alien.direction = self.movingDirection
            self.movingDuration = math.random(5)
            self.movingTimer = 0
        end
    else
        self.alien.direction = 'right'
        self.alien.x = self.alien.x + Alien_MOVE_SPEED * dt

        -- stop the Alien if there's a missing tile on the floor to the right or a solid tile directly right
        local tileRight = self.tilemap:pointToTile(self.alien.x + self.alien.width, self.alien.y)
        local tileBottomRight = self.tilemap:pointToTile(self.alien.x + self.alien.width, self.alien.y + self.alien.height)

        if (tileRight and tileBottomRight) and (tileRight:collidable() or not tileBottomRight:collidable()) then
            self.alien.x = self.alien.x - Alien_MOVE_SPEED * dt

            -- reset direction if we hit a wall
            self.movingDirection = 'left'
            self.alien.direction = self.movingDirection
            self.movingDuration = math.random(5)
            self.movingTimer = 0
        end
    end

    -- calculate difference between Alien and player on X axis
    -- and only chase if <= 5 tiles
    local diffX = math.abs(self.player.x - self.alien.x)

    if diffX < 5 * TILE_SIZE then
        self.alien:changeState('chasing')
    end
end