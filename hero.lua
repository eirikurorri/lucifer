
local hero = {}
local HC = require "HardonCollider"
local collider

local ourHero
local lucifer
local collx, colly = 0
local camx, camy = 0
local offset = 300
local colliderobject
local bounce = false
local bounceevent = false
local bouncedistance = 0 
local swipeobject
local swiping = false
local swipetimer = 0
local repeatTimer = 0 -- for swooshing sound
local repeatDelay = 0.8 -- for swooshing sound
local bouncetimer = 0
local verticalspeed = 0

function hero.setupHero(x,y,coll)
	  collider = coll
    ourHero = collider:addCircle(x,y,15) -- size of our hero
    luciferSpritesheet = love.graphics.newImage('gfx/tinySatan.png')
    luciferNorthFacing = love.graphics.newQuad(0, 0, 16, 16, 96, 72) -- head facing north
    luciferSouthFacing = love.graphics.newQuad(64, 56, 16, 16, 96, 72) -- head facing south

end

function hero.initSwipe(x,y)
  swipeobject = collider:addCircle(x,y,40)
  return swipeobject
end

function hero.heroycoords()
    --local hero = {}
    herox,heroy = ourHero:center()
    --print(camy)
    return heroy
end
function hero.heroxcoords()
    herox,heroy = ourHero:center()
    return herox
end

function hero.swipexcoords()
    swipex,swipey = swipeobject:center()
    return swipex
end

function hero.swipeycoords()
    swipex,swipey = swipeobject:center()
    return swipey
end

function hero.removeswipeobject()
    collider:remove(swipeobject)
    swiping = false
    swipeaction = false
end

function hero.updateHero(dt,cam,speed,reached_bottom,distanceGoal,cameraoffset,slowdown,slowdistance,swipeaction,swipe,elapsedtime,herospeed)
	-- apply a downward force to the hero (=gravity)
	herox,heroy = ourHero:center()
    
    

    if swipeaction == true then
        --print(swipeaction)
        swiping = swipeaction
        swipetimer = elapsedtime
        swipex, swipey = swipeobject:center()
       -- if swipex < herox and reached_bottom == false and slowdown == true then
       --   swipeobject:move(2+herospeed*dt,5+dt*speed/2)
       -- elseif swipex > herox and reached_bottom == false and slowdown == true then
       --   swipeobject:move(-2+herospeed*dt,5+dt*speed/2)
       -- elseif swipex < herox and reached_bottom == true and slowdown == true then
       --   swipeobject:move(2+herospeed*dt,-5-dt*speed/2)
       -- elseif swipex > herox and reached_bottom == true and slowdown == true then
       --   swipeobject:move(-2+herospeed*dt,-5-dt*speed/2)
        if swipex < herox and reached_bottom == false then
          swipeobject:move(2+verticalspeed*dt,dt*speed+5)
        elseif swipex > herox and reached_bottom == false then
          swipeobject:move(-2+verticalspeed*dt,dt*speed+5)
        elseif swipex < herox and reached_bottom == true then
          swipeobject:move(2+verticalspeed*dt,-dt*speed-5)
        elseif swipex > herox and reached_bottom == true then
          swipeobject:move(-2+verticalspeed*dt,-dt*speed-5)
        
        end
    end

    --if reached_bottom == false and slowdown == true then
    --    if heroy < distanceGoal - cameraoffset then
    --      ourHero:move(0,dt*speed/2) -- collider.move 
    --      cam:lookAt(400,heroy+offset+dt*speed/2)
    --    else
    --      ourHero:move(0,dt*speed/2)
    --    end
    --elseif reached_bottom == true and slowdown == true then
    --    if heroy < cameraoffset then
    --      ourHero:move(0,-dt*speed/2)
    --    else 
    --      ourHero:move(0,-dt*speed/2) -- collider.move 
    --      cam:lookAt(400,heroy-offset+dt*speed/2)
    --    end
    if reached_bottom == false then
        if heroy < distanceGoal - cameraoffset then
            ourHero:move(0,dt*speed) -- collider.move 
            cam:lookAt(400,heroy+offset+dt*speed)
        else
            ourHero:move(0,dt*speed)
        end
    elseif reached_bottom == true then
        if heroy < cameraoffset then
            ourHero:move(0,-dt*speed)
            
        else
            ourHero:move(0,-dt*speed)
            cam:lookAt(400,heroy-offset-dt*speed)
        end
    end

    
end


function hero.on_collide(dt, shape_a, shape_b, mtv_x, mtv_y,reached_bottom)

    hero.collideHeroWithTile(dt, shape_a, shape_b, mtv_x, mtv_y,reached_bottom)

end

function hero.collideHeroWithTile(dt, shape_a, shape_b, mtv_x, mtv_y,reached_bottom)

  --print(reached_bottom)
    -- sort out which one our hero shape is
  collx, colly = ourHero:center()
   local hero_shape, tileshape
   if shape_a == ourHero and shape_b.type == "side" then
        hero_shape = shape_a
        if bounce == false then
            bouncetimer = 0
            bounce = true
            bouncedistance = colly
            --bouncetimer = love.timer.getTime()
        end
   elseif shape_b == ourHero and shape_a.type == "side" then
       hero_shape = shape_b
       if bounce == false then
            bouncetimer = 0
            bounce = true
            bouncedistance = colly
            --bouncetimer = love.timer.getTime()
        end
   elseif shape_a == ourHero and shape_b.type == "bottom" and reached_bottom == false then
        hero_shape = shape_a
        if bounce == false then
            bouncetimer = 0
            bounce = true
            bouncedistance = colly
            --bouncetimer = love.timer.getTime()
        end
   elseif shape_b == ourHero and shape_a.type == "bottom" and reached_bottom == false then
       hero_shape = shape_b
       if bounce == false then
            bouncetimer = 0
            bounce = true
            bouncedistance = colly
            --bouncetimer = love.timer.getTime()
        end
    elseif shape_a == ourHero and shape_b.type == "bottom" and reached_bottom == true then
       endgame()
       return
   elseif shape_b == ourHero and shape_a.type == "bottom" and reached_bottom == true then
       endgame()
       return
   elseif shape_a == ourHero and shape_b.type == "top" and reached_bottom == true then
       hero_shape = shape_a
        if bounce == false then
            bouncetimer = 0
            bounce = true
            bouncedistance = colly
            --bouncetimer = love.timer.getTime()
        end
   elseif shape_b == ourHero and shape_a.type == "top" and reached_bottom == true then
       hero_shape = shape_b
       if bounce == false then
            bouncetimer = 0
            bounce = true
            bouncedistance = colly
            --bouncetimer = love.timer.getTime()
        end
   elseif shape_a == ourHero and shape_b.type == "top" and reached_bottom == false then
       endgame()
       return
   elseif shape_b == ourHero and shape_a.type == "top" and reached_bottom == false then
       endgame()
       return
   elseif shape_a == swipeobject and shape_b.type == "soul" then
        map.layers["souls"]["objects"][shape_b.key]["visible"] = false
        -- map.layers["soulTiles"]["objects"][shape_b.key]["visible"] = false
        collider:remove(shape_b)
        scorecounter()
        return
    elseif shape_b == swipeobject and shape_a.type == "soul" then
        map.layers["souls"]["objects"][shape_a.key]["visible"] = false
        --map.layers["soulTiles"]["objects"][shape_a.key]["visible"] = false
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

	--ourHero:draw('fill')
    collx, colly = ourHero:center()
    --love.graphics.draw(luciferSpritesheet, lucifer, collx-24, colly-24, 0, 3)
    if reached_bottom == false then
        love.graphics.draw(luciferSpritesheet, luciferSouthFacing, collx-24, colly-24, 0, 3)
    else
        love.graphics.draw(luciferSpritesheet, luciferNorthFacing, collx-24, colly-24, 0, 3)
    end
    if swiping == true and swipetimer <= 0.5 then
      swipeobject:draw('fill')
      --print("drawing swipeobject")
    end
    -- print(collx, " ", colly)
    --colliderobject:draw('fill')
end
  
function hero.playSoundWithTimer(dt, sound)
    if repeatTimer >= repeatDelay then
        TEsound.play(sound)
        -- print('Swoosh!')
        repeatTimer = 0
    else 
        repeatTimer = repeatTimer + dt
    end
end

function hero.handleInput(dt,herospeed,speedmargin,swipeaction,swipe)
    collx, colly = ourHero:center()
    if bounce == true and herospeed > 0 then
        bouncetimer = bouncetimer + dt
        verticalspeed = -herospeed/2.5
        ourHero:move(-herospeed*dt/2.5, 0)
        --print(bouncedistance, colly)
        if bouncetimer >= 0.2 then
          --bounceevent = false
          bounce = false
          verticalspeed = -herospeed/2.5
          --print("bounce event over")
          return -herospeed/2.5
        end
    elseif bounce == true and herospeed < 0 then
        bouncetimer = bouncetimer + dt
        verticalspeed = -herospeed/2.5
        ourHero:move(-herospeed*dt/2.5, 0)
        --print(bouncedistance, colly)
        if bouncetimer >= 0.2 then
          --bounceevent = false
          bounce = false
          verticalspeed = -herospeed/2.5
          --print("bounce event over")
          return -herospeed/2.5
        end
    else
        if love.keyboard.isDown("left") then
            hero.playSoundWithTimer(dt, capeSwoosh)
            if herospeed > 0 then
                herospeed = herospeed - 30

            else
                herospeed = herospeed - 12
               
            end 
        elseif love.keyboard.isDown("right") then
            hero.playSoundWithTimer(dt, capeSwoosh)
            if herospeed < 0 then
                herospeed = herospeed + 30
            else
                herospeed = herospeed + 12  
            end  
        else  
            if herospeed < -speedmargin then 
                herospeed = herospeed + 12
            elseif herospeed > speedmargin then
                herospeed = herospeed - 12
            else
                herospeed = 0
            end
           -- repeatTimer = 0
        end
        ourHero:move(herospeed*dt, 0)
        verticalspeed = herospeed
    end
    
    return herospeed
end

function hero.findSolidTiles(map)
    local collidable_tiles = {}

    for x, y, tile in map("sides"):iterate() do
        --love.graphics.print(string.format("Tile at (%d,%d) has an id of %d", x, y, tile.id),10,10)
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
        -- love.graphics.print(string.format("Tile at (%d,%d) has an id of %d", x, y, tile.id),10,10)
        --if tile.properties.solid then
            local ctile = collider:addRectangle((x)*32-120,(y)*32,32,32)
            ctile.type = "collide"
            collider:addToGroup("collide", ctile)
            collider:setPassive(ctile)
            table.insert(collidable_tiles, ctile)
        --end
    end

    return collidable_tiles
end

function hero.findToptiles(map)
    local collidable_tiles = {}

     for i, obj in ipairs( map("top").objects ) do
         local collObject
         local coordlist = {}
         local crap = {}
         -- now we check if the shape is a polygon or a rect
            --print(pairs(obj.polygon)[1])
            for j, k in ipairs(obj.polygon) do
              --print(j, " ", k)
              if j % 2 == 0 then
                table.insert(coordlist, k + obj.y)
                --print(k-120)
              else
                table.insert(coordlist, k + obj.x - 120)
              end
              --print(obj.x)
      end
            --print(unpack(coordlist))
            collObject = collider:addPolygon(unpack(coordlist))
        --print(collObject:center())
         collObject.type = "top"
         collider:addToGroup("top", collObject)
         collider:setPassive(collObject)
         table.insert(collidable_tiles, collObject)
         colliderobject = collObject
         --colliderobject:draw("fill")
     end

    return collidable_tiles
end

function hero.findbottomTiles(map)
    local collidable_tiles = {}

     for i, obj in ipairs( map("bottom").objects ) do
         local collObject
         local coordlist = {}
         local crap = {}
         -- now we check if the shape is a polygon or a rect
            --print(pairs(obj.polygon)[1])
            for j, k in ipairs(obj.polygon) do
              --print(j, " ", k)
              if j % 2 == 0 then
                table.insert(coordlist, k + obj.y)
                --print(k-120)
              else
                table.insert(coordlist, k + obj.x - 120)
              end
              --print(obj.x)
      end
            --print(unpack(coordlist))
            collObject = collider:addPolygon(unpack(coordlist))
        --print(collObject:center())
         collObject.type = "bottom"
         collider:addToGroup("bottom", collObject)
         collider:setPassive(collObject)
         table.insert(collidable_tiles, collObject)
         colliderobject = collObject
         --colliderobject:draw("fill")
     end

    return collidable_tiles
end

function hero.findSide(map)
    local collidable_tiles = {}

     for i, obj in ipairs( map("side").objects ) do
         local collObject
         local coordlist = {}
         local crap = {}
         -- now we check if the shape is a polygon or a rect
            --print(pairs(obj.polygon)[1])
            for j, k in ipairs(obj.polygon) do
              --print(j, " ", k)
              if j % 2 == 0 then
                table.insert(coordlist, k + obj.y)
                --print(k-120)
              else
                table.insert(coordlist, k + obj.x - 120)
              end
              --print(obj.x)
      end
            --print(unpack(coordlist))
            collObject = collider:addPolygon(unpack(coordlist))
        --print(collObject:center())
         collObject.type = "side"
         collider:addToGroup("side", collObject)
         collider:setPassive(collObject)
         table.insert(collidable_tiles, collObject)
         colliderobject = collObject
         --colliderobject:draw("fill")
     end

    return collidable_tiles
end

-- for the soulTiles layer
-- function hero.findSouls(map)
--     local souls = {}
--         for x, y, tile in map("souls"):iterate() do -- tile layer
--             local ctile = collider:addRectangle((x)*32,(y)*32,32,32)
--             ctile.type = "soul"
--             collider:addToGroup("soul", ctile)
--             collider:setPassive(ctile)
--             table.insert(souls, ctile)
--         end
--     return souls
--     end

-- for the souls object layer
function hero.findSoulObjects(map)
    local souls = {}
    
      for i, obj in ipairs( map("souls").objects ) do
          -- debugging print statment
          -- for a, att in pairs(obj) do
          --     print(a, " ", att)
          -- end
        local collObject = collider:addRectangle(obj.x-88, obj.y+14, 32, 56) -- hard coded according to soul image tile size
    
        collObject.type = "soul"
        collObject.key = i
        collObject.visible = true
        --obj.draw(obj.x,obj.y)
        collider:addToGroup("soul", collObject)
        collider:setPassive(collObject)
        table.insert(souls, collObject)
        --print(collObject:center())

    end

    return souls
end


return hero
