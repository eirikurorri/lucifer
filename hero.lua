
local hero = {}
local HC = require "HardonCollider"
local collider

function hero.setupHero(x,y,coll)
	collider = coll
	hero = collider:addRectangle(x,y,16,16)
	hero.speed = 400
end


function hero.updateHero(dt)
	-- apply a downward force to the hero (=gravity)
	hero:move(0,dt*150)
end


function hero.on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)

    collideHeroWithTile(dt, shape_a, shape_b, mtv_x, mtv_y)

end

function hero.collideHeroWithTile(dt, shape_a, shape_b, mtv_x, mtv_y)

    -- sort out which one our hero shape is
    local hero_shape, tileshape
    if shape_a == hero and shape_b.type == "tile" then
        hero_shape = shape_a
    elseif shape_b == hero and shape_a.type == "tile" then
        hero_shape = shape_b
    else
        -- none of the two shapes is a tile, return to upper function
        return
    end

    -- why not in one function call? because we will need to differentiate between the axis later
    hero_shape:move(mtv_x, 0)
    hero_shape:move(0, mtv_y)

end

function hero.draw()
	hero:draw("fill")
end

function hero.handleInput(dt)

    if love.keyboard.isDown("left") then
        hero:move(-hero.speed*dt, 0)
    end
    if love.keyboard.isDown("right") then
        hero:move(hero.speed*dt, 0)
    end
    if love.keyboard.isDown("up") then
    	hero:move(hero.speed*dt*2, 0)
    end

end

return hero