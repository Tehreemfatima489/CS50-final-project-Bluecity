LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}
    local lockfound = false
    local jumperfound = false
    local levelwidth = width + 125 * TILE_SIZE
    local tileID = TILE_ID_GROUND
    local tile_empty = false
    local bridgefound = false
    powerup = false
                               

    -- whether we should draw our tiles with toppers
    local topper = true
    local topperset = 6
    local keyfound = false

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, 150 do
        local tileID = TILE_ID_EMPTY

        -- lay out the empty space
        for y = 1, 8 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, topperset))
        end


        -- chance to just be emptiness
        if x > 5 and x < 19 then
            for y = 9, height do
                tile_empty = true
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, topperset))
            end
            if tile_empty == true   then


                    table.insert(objects,
                        GameObject {
                            texture = 'bar',
                            x = 7 * TILE_SIZE,
                            y = (7 - 1) * TILE_SIZE,
                            width = 27,
                            height = 16,
                            frame = 1,
                            
                            solid = true
                        }
                    )
                    
                    table.insert(objects,
                        GameObject {
                            texture = 'bar',
                            x = 11 * TILE_SIZE,
                            y = (7 - 1) * TILE_SIZE,
                            width = 27,
                            height = 16,
                            frame = 1,
                            
                            solid = true
                        }
                    )
                    table.insert(objects,
                        GameObject {
                            texture = 'bar',
                            x = 15 * TILE_SIZE,
                            y = (7 - 1) * TILE_SIZE,
                            width = 27,
                            height = 16,
                            frame = 1,
                            
                            solid = true
                        }
                    )
                    
 
            


            end
 
        elseif x > width and x <= 150 then
            for y = 9, height do
                table.insert(tiles[y],
                    Tile(x , y, tileID, nil, topperset))
            end
            
            for y = 3, 4 do
                tileID = TILE_ID_GROUND
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 3 and topper or nil, topperset))
            end
            if math.random(2) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'coins',
                        x = (x - 1) * TILE_SIZE,
                        y = (2 - 1) * TILE_SIZE,
                        width = 2,
                        height = 1,
                        frame = math.random(3, 4),
                        collidable = true,
                        consumable = true,
                        solid = false,

                        onConsume = function(player, object)
                            gSounds['pickup']:play()
                            player.score = player.score + 1
                        end
                    }
                )
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'shrooms',
                        x = (x - 1) * TILE_SIZE,
                        y = (2 - 1) * TILE_SIZE + 2,
                        width = 16,
                        height = 16,
                        frame = 1,
                        collidable = false
                    }
                )
    
            end
        elseif math.random(7) == 1 and x ~= 1 and x ~= 2 
            and x ~= 3  then
                tileID = TILE_ID_EMPTY
                for y = 9, height do
                    table.insert(tiles[y],
                        Tile(x , y, tileID, nil, topperset))
                end
            
            
        else

            tileID = TILE_ID_GROUND

            local blockHeight = 4

            for y = 9, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 9 and topper or nil, topperset))
            end


            -- chance to generate a pillar
            if math.random(4) == 1 and x ~= width - 1 and x ~= width - 2 and x ~= width then
                blockHeight = 2
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'shrooms',
                            x = (x - 1) * TILE_SIZE,
                            y = (6 - 1) * TILE_SIZE + 2,
                            width = 16,
                            height = 16,
                            frame = 1,
                            collidable = false
                        }
                    )
                elseif math.random(12) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'spikes',
                            x = (x - 1) * TILE_SIZE,
                            y = (6 - 1) * TILE_SIZE + 6 ,
                            width = 16,
                            height = 16,
                            frame = 1,
                            collidable = false
                        }
                    )
                end

                -- chance to generate bush on pillar

                -- pillar tiles
                tiles[7][x] = Tile(x, 7, tileID, topper, topperset)
                tiles[8][x] = Tile(x, 8, tileID, nil, topperset)
                tiles[9][x].topper = nil
            elseif not jumperfound then
                table.insert(objects,
                    GameObject {
                        texture = 'jumpers',
                        x = 1586,
                        y = (7 - 1) * TILE_SIZE + 15,
                        width = 16,
                        height = 16,
                        frame = 11,
                        hit = false,
                        consumable = true,
                        onConsume = function(player, object)
                            player:changeState('jumper')
                        end  
                    }
                )
                jumperfound = true

            -- chance to generate bushes
            elseif math.random(20) == 1 and x ~= 1586 and x ~= 1587 and x ~= 1585 then
                table.insert(objects,
                    GameObject {
                        texture = 'mushrooms',
                        x = (x - 1) * TILE_SIZE,
                        y = (8 - 1) * TILE_SIZE,
                        width = 8,
                        height = 8,
                        frame = 17,
                        collidable = false
                    }
                )
            elseif math.random(22) == 1 and x ~= 1586 and x ~= 1587 and x ~= 1585 then
                table.insert(objects,
                    GameObject {
                        texture = 'mushrooms',
                        x = (x - 1) * TILE_SIZE,
                        y = (8 - 1) * TILE_SIZE,
                        width = 8,
                        height = 8,
                        frame = 22,
                        collidable = false
                    }
                )
            elseif math.random(22) == 1 and x ~= 1586 and x ~= 1587 and x ~= 1585 then
                table.insert(objects,
                    GameObject {
                        texture = 'mushrooms',
                        x = (x - 1) * TILE_SIZE,
                        y = (8 - 1) * TILE_SIZE,
                        width = 8,
                        height = 8,
                        frame = 4,
                        collidable = false
                    }
                )
            elseif math.random(2) == 1 and x ~= 1586 and x ~= 1587 and x ~= 1585 then
                table.insert(objects,
                    GameObject {
                        texture = 'coins',
                        x = (x - 1) * TILE_SIZE,
                        y = (8 - 1) * TILE_SIZE,
                        width = 2,
                        height = 1,
                        frame = math.random(3, 4),
                        collidable = true,
                        consumable = true,
                        solid = false,

                        onConsume = function(player, object)
                            gSounds['pickup']:play()
                            player.score = player.score + 1
                        end
                    }
                )

            
            elseif math.random(12) == 1 and x ~= 1586 and x ~= 1587 and x ~= 1585 then
                table.insert(objects,
                    GameObject {
                        texture = 'spikes',
                        x = (x - 1) * TILE_SIZE,
                        y = (8 - 1) * TILE_SIZE + 6 ,
                        width = 16,
                        height = 16,
                        frame = 1,
                        collidable = false
                    }
                )
            elseif math.random(15) == 1 and x ~= 1586 and x ~= 1587 and x ~= 1585 then
                table.insert(objects,
                    GameObject {
                        texture = 'shrooms',
                        x = (x - 1) * TILE_SIZE,
                        y = (10- 1) * TILE_SIZE + 11,
                        width = 16,
                        height = 16,
                        frame = 1,
                        collidable = false
                    }
                )
            elseif math.random(20) == 1 and x ~= 1586 and x ~= 1587 and x ~= 1585 then
                table.insert(objects,
                    GameObject{
                        texture = 'potion',
                        x = (x - 1) * TILE_SIZE,
                        y = (8 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = 1,
                        collidable = false,
                        consumable = true,
                        onConsume = function(player, object)
                            gSounds['pickup']:play()
                            player:changeState('powerup')
                            
                        end
                    }
                )

            elseif math.random(20) == 1 and x ~= 1586 and x ~= 1587 and x ~= 1585 then
                table.insert(objects,
                    GameObject {
                        texture = 'signs',
                        x = (x - 1) * TILE_SIZE,
                        y = (7 - 1) * TILE_SIZE + 15,
                        width = 16,
                        height = 16,
                        frame = 7,
                        solid = false,
                        hit = true,
                        consumable = true,
                        onConsume = function(player, object)
                            gStateMachine:change('start')
                            gSounds['pickup']:play()

                        end
                    }
                )
       
            
            elseif math.random(10) == 1 and x ~= 1586 and x ~= 1587 and x ~= 1585 then
                table.insert(objects,
                    GameObject {
                        texture = 'boards',
                        x = (x - 1) * TILE_SIZE,
                        y = (7 - 1) * TILE_SIZE + 11,
                        width = 16,
                        height = 16,
                        frame = 1,
                        collidable = false
                    }
                )
            end
 
            if not lockfound then
                table.insert(objects,
                    GameObject {
                        texture = 'locks',
                        x = width / 2 * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = math.random(1, 4),
                        collidable = true,
                        hit = false,
                        solid = true,
                        onCollide = function(obj)
                            keyfound = true
                            if not obj.hit then
                                local key = GameObject {
                                    texture = 'keys',
                                    x =  width / 2 * TILE_SIZE,
                                    y = (blockHeight - 1) * TILE_SIZE - 4,
                                    width = 16,
                                    height = 16,
                                    frame = obj.frame,
                                    collidable = true,
                                    consumable = true,
                                    solid = false,
                                    onConsume = function(player, object)
                                        gSounds['pickup']:play()

                                        if keyfound then
                                            obj.keyfound = true
                                            table.insert(objects,
                                            GameObject {
                                                texture = 'flags',
                                                x = (width + 13) * TILE_SIZE ,
                                                y = TILE_SIZE - 10,
                                                width = 16,
                                                height = 16,
                                                frame = 1,
                                                consumable = true,
                                                solid = false,
                                                onConsume = function(player, object)
                                                    gSounds['pickup']:play()
                                                   gStateMachine:change('play')

                                                end

                                            }
                                        )
                                        end

                                    end


                                }   

                                Timer.tween(0.1, {
                                    [key] = {y = (blockHeight - 2) * TILE_SIZE}
                                })
                                gSounds['powerup-reveal']:play()


                                table.insert(objects, key)



                            end


                            obj.hit = true


                        end

                    }

                )
                lockfound = true
            end

        end

    end
    local map = TileMap(width, height)
    map.tiles = tiles

    return GameLevel(entities, objects, map)
end
