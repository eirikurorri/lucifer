
local hero = {}
local HC = require "HardonCollider"
local collider

local ourHero
local camY
local lucifer

function hero.setupHero(x,y,coll)
	collider = coll
	ourHero = collider:addRectangle(x,y,48,48) -- size of our hero
	--ourHero.speed = 400
    luciferSpritesheet = love.graphics.newImage('gfx/tinySatan.png')
    -- lucifer = love.graphics.newQuad(0, 0, 16, 16, 96, 72) -- head facing north
    lucifer = love.graphics.newQuad(64, 56, 16, 16, 96, 72) -- head facing south

end


function hero.updateHero(dt,cam,speed,reached_bottom)
	-- apply a downward force to the hero (=gravity)
	
    if reached_bottom == false then
        ourHero:move(0,dt*speed) -- collider.move 
        cam:move(0,dt*speed)     -- camera.move
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
   if shape_a == ourHero and shape_b.type == "tile" then
       hero_shape = shape_a
   elseif shape_b == ourHero and shape_a.type == "tile" then
       hero_shape = shape_b
   elseif shape_a == ourHero and shape_b.type == "collide" then
       endgame()
       return
   elseif shape_b == ourHero and shape_a.type == "collide" then
       endgame()
       return
   elseif shape_a == ourHero and shape_b.type == "soul" then
        --map.layers["souls"]["objects"][shape_b.key]["visible"] = false
        map.layers["soulTiles"]["objects"][shape_b.key]["visible"] = false
        collider:remove(shape_b)
        scorecounter()
        return
    elseif shape_b == ourHero and shape_a.type == "soul" then
        -- map.layers["souls"]["objects"][shape_a.key]["visible"] = false
        map.layers["soulTiles"]["objects"][shape_a.key]["visible"] = false
        collider:remove(shape_a)
        scorecounter()
        return
   else
       -- none of the two shapes is a tile, return to upper function
       return
   end
    -- why not in one function call? because we will need to differentiate between the axis later
    hero_shape:move(mtv_x, 0)
    hero_shape:move(0, mtv_y)

end

function hero.draw()

	-- ourHero:draw('fill')
    local collx, colly = ourHero:center()
    love.graphics.draw(luciferSpritesheet, lucifer, collx-24, colly-24, 0, 3)
    -- print(collx, " ", colly)

end

function hero.handleInput(dt,herospeed,speedmargin)

    if love.keyboard.isDown("left") then
        if herospeed > 0 then
            herospeed = herospeed - 30
        else
            herospeed = herospeed - 10
        end 
    elseif love.keyboard.isDown("right") then
        if herospeed < 0 then
            herospeed = herospeed + 30
        else
            herospeed = herospeed + 10  
        end  
    else  
            if herospeed < -speedmargin then 
                herospeed = herospeed + 10
            elseif herospeed > speedmargin then
                herospeed = herospeed - 10
            else
                herospeed = 0
            end
    end
    ourHero:move(herospeed*dt, 0)
    return herospeed
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

function hero.findSolidTilesLayer(map)
    local collidable_tiles = {}

    for x, y, tile in map("ledge"):iterate() do -- tile layer
        love.graphics.print(string.format("Tile at (%d,%d) has an id of %d", x, y, tile.id),10,10)
        --if tile.properties.solid then
            local ctile = collider:addRectangle((x)*32,(y)*32,32,32)
            ctile.type = "collide"
            collider:addToGroup("collide", ctile)
            collider:setPassive(ctile)
            table.insert(collidable_tiles, ctile)
        --end
    end

    -- for i, obj in pairs( map("object").objects ) do
    --     local collObject
    --     -- now we check if the shape is a polygon or a rect
    --     if obj.name == "polygon" then -- polygons should have this name in Tiled
    --         collObject = collider:addPolygon(obj.polygon)  
    --     else 
    --         collObject = collider:addRectangle(obj.x, obj.y, obj.width, obj.height)
    --     end
    --     collObject.type = "collide"
    --     collider:addToGroup("collide", collObject)
    --     collider:setPassive(collObject)
    --     table.insert(collidable_tiles, collObject)
    -- end

    return collidable_tiles
end

-- for the soulTiles layer
function hero.findSouls(map)
    local souls = {}
        for x, y, tile in map("soulTiles"):iterate() do -- tile layer
            local ctile = collider:addRectangle((x)*32,(y)*32,32,32)
            ctile.type = "soul"
            collider:addToGroup("soul", ctile)
            collider:setPassive(ctile)
            table.insert(souls, ctile)
        end
    return souls
    end

-- for the souls object layer
function hero.findSoulObjects(map)
    local souls = {}
    
      for i, obj in pairs( map("souls").objects ) do
          -- debugging print statment
          -- for a, att in pairs(obj) do
          --     print(a, " ", att)
          -- end
        local x = map.layers["souls"]["objects"][i]["x"]
        local y = map.layers["souls"]["objects"][i]["y"]
        --local collObject = collider:addRectangle(obj.x, obj.y, obj.width, obj.height)
        local collObject = collider:addRectangle(obj.x, obj.y, 70, 122) -- hard coded according to soul image tile size
        collObject.type = "soul"
        collObject.key = i
        collObject.visible = true
        collider:addToGroup("soul", collObject)
        collider:setPassive(collObject)
        table.insert(souls, collObject)
    end

    -- for a, b in pairs(souls) do
    --     print("---", a, "---")
    --     for x, y in pairs(b) do
    --         print(x, " ", y, "OOOO")
    --         -- for one, two in pairs(y) do
    --         --     print(one, " ", two, "******")
    --         -- end
    --     end
    -- end

    return souls
end


return hero
