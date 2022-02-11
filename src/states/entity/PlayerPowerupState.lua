PlayerPowerupState = Class{__includes = BaseState}

function PlayerPowerupState:init(player)
    self.player = player

    self.animation = Animation {
        frames = {18, 19, 20},
        interval = 0.1
    }
    self.player.currentAnimation = self.animation
    self.poweruptimer = 30
end

function PlayerPowerupState:update(dt)
    self.player.currentAnimation:update(dt)
    self.poweruptimer = self.poweruptimer - 1

    if self.poweruptimer < 0 then
        self.player:changeState('idle')
    else
        local tileLeft = self.player.map:pointToTile(self.player.x + 3, self.player.y)
        local tileRight = self.player.map:pointToTile(self.player.x + self.player.width - 3, self.player.y)
        
        self.player.y = self.player.y + 12


        self.player.x = self.player.x + PLAYER_POWERUP_SPEED * dt
        self.player.y = self.player.y - 12

        for k, entity in pairs(self.player.level.entities) do
            if entity:collides(self.player) then
                gSounds['death']:play()
                self.player.score = self.player.score + 20
                table.remove(self.player.level.entities, k)
            end
        end
    end
end

