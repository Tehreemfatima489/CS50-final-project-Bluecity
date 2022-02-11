
AlienChasingState = Class{__includes = BaseState}

function AlienChasingState:init(tilemap, player, alien)
    self.tilemap = tilemap
    self.player = player
    self.alien = alien
    self.animation = self.alien.animationMoving
    self.alien.currentAnimation = self.animation
end

function AlienChasingState:update(dt)
    self.alien.currentAnimation:update(dt)

    -- calculate difference between Alien and player on X axis
    -- and only chase if <= 5 tiles
    local diffX = math.abs(self.player.x - self.alien.x)

    if diffX > 5 * TILE_SIZE then
        self.alien:changeState('moving')
    elseif self.player.x < self.alien.x then
        self.alien.direction = 'left'
        self.alien.x = self.alien.x - Alien_MOVE_SPEED * dt

        -- stop the Alien if there's a missing tile on the floor to the left or a solid tile directly left
        local tileLeft = self.tilemap:pointToTile(self.alien.x, self.alien.y)
        local tileBottomLeft = self.tilemap:pointToTile(self.alien.x, self.alien.y + self.alien.height)

        if (tileLeft and tileBottomLeft) and (tileLeft:collidable() or not tileBottomLeft:collidable()) then
            self.alien.x = self.alien.x + Alien_MOVE_SPEED * dt
        end
    else
        self.alien.direction = 'right'
        self.alien.x = self.alien.x + Alien_MOVE_SPEED * dt

        -- stop the Alien if there's a missing tile on the floor to the right or a solid tile directly right
        local tileRight = self.tilemap:pointToTile(self.alien.x + self.alien.width, self.alien.y)
        local tileBottomRight = self.tilemap:pointToTile(self.alien.x + self.alien.width, self.alien.y + self.alien.height)

        if (tileRight and tileBottomRight) and (tileRight:collidable() or not tileBottomRight:collidable()) then
            self.alien.x = self.alien.x - Alien_MOVE_SPEED * dt
        end
    end
end