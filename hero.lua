
local hero = {}
local HC = require "HardonCollider"
local collider
local map
local ourHero
local camY

function hero.setupHero(x,y,coll)
	collider = coll
	ourHero = collider:addRectangle(x,y,16,16)
	ourHero.speed = 400
end


function hero.updateHero(dt,cam,speed,reached_bottom)
	-- apply a downward force to the hero (=gravity)
	
    if reached_bottom == false then
        ourHero:move(0,dt*speed)
        cam:move(0,dt*speed)
    else
        ourHero:move(0,-dt*speed)
        cam:move(0,-dt*speed)
    end
end


function hero.on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)

    hero.collideHeroWithTile(dt, shape_a, shape_b, mtv_x, mtv_y)

end

function hero.collideHeroWithTile(dt, shape_a, shape_b, mtv_x, mtv_y)

    -- sort out which one our hero shape is
   local hero_shape, tileshape
   --if shape_a == ourHero and shape_b.type == "tile" then
   --    hero_shape = shape_a
   --elseif shape_b == hero and shape_a.type == "tile" then
   --    hero_shape = shape_b
   --else
   --    -- none of the two shapes is a tile, return to upper function
   --    return
   --end

    -- why not in one function call? because we will need to differentiate between the axis later
    hero_shape:move(mtv_x, 0)
    hero_shape:move(0, mtv_y)

end

function hero.draw(camY)
	ourHero:draw("fill")
end

function hero.handleInput(dt)

    if love.keyboard.isDown("left") then
        ourHero:move(-ourHero.speed*dt, 0)
    end
    if love.keyboard.isDown("right") then
        ourHero:move(ourHero.speed*dt, 0)
    end
    --if love.keyboard.isDown("up") then
    --	ourHero:move(0, -ourHero.speed*dt*2)
    --end

end

function hero.findSolidTiles(map)
    local collidable_tiles = {}

    for x, y, tile in map("sides"):iterate() do
        love.graphics.print(string.format("Tile at (%d,%d) has an id of %d", x, y, tile.id),10,10)
        --if tile.properties.solid then
            local ctile = collider:addRectangle((x)*32,(y)*32,32,32)
            ctile.type = "tile"
            collider:addToGroup("tiles", ctile)
            collider:setPassive(ctile)
            table.insert(collidable_tiles, ctile)
        --end
    end

    return collidable_tiles
end

function hero.findSolidTileslayer(map)
    local collidable_tiles = {}

    for x, y, tile in map("ledge"):iterate() do
        love.graphics.print(string.format("Tile at (%d,%d) has an id of %d", x, y, tile.id),10,10)
        --if tile.properties.solid then
            local ctile = collider:addRectangle((x)*32,(y)*32,32,32)
            ctile.type = "tile"
            collider:addToGroup("tiles", ctile)
            collider:setPassive(ctile)
            table.insert(collidable_tiles, ctile)
        --end
    end

    return collidable_tiles
end

return hero
