

-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144

-- global standard tile size
TILE_SIZE = 16

-- camera scrolling speed
CAMERA_SPEED = 100

-- speed of scrolling background
BACKGROUND_SCROLL_SPEED = 10
-- player walking speed
PLAYER_WALK_SPEED = 60

-- player jumping velocity
PLAYER_JUMP_VELOCITY = -280
jumper_value = -360

PLAYER_POWERUP_SPEED = 200

-- snail movement speed
Alien_MOVE_SPEED = 10

--
-- tile IDs
--
TILE_ID_EMPTY = 139
TILE_ID_GROUND = 137

-- table of tiles that should trigger a collision
COLLIDABLE_TILES = {
    TILE_ID_GROUND 
}
