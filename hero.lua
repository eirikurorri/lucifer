
local hero = {}
local HC = require "HardonCollider"
local collider

local ourHero
local lucifer
local collx, colly = 0
local camx, camy = 0
local offset = 250 -- originally 300
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
local objectspeed = 0

local souls = {}
local caughtSouls = {}

function hero.setupHero(x,y,coll)
	collider = coll
    ourHero = collider:addCircle(x,y,15) -- size of our hero
end

function hero.moveTo(x,y)
    ourHero:moveTo(x,y)
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

function hero.updateHero(dt,cam,speed,reached_bottom,distanceGoal,cameraoffset,slowdown,slowdistance,swipeaction,swipe,elapsedtime,herospeed,stage)
	-- apply a downward force to the hero (=gravity)
	herox,heroy = ourHero:center()
    
    
    if swipeaction == true then
        --print(swipeaction)
        swiping = swipeaction
        swipetimer = elapsedtime
        swipex, swipey = swipeobject:center()

        if swipex < herox and reached_bottom == false then
          swipeobject:move(4+objectspeed*dt,dt*speed+5)
        elseif swipex > herox and reached_bottom == false then
          swipeobject:move(-4+objectspeed*dt,dt*speed+5)
        elseif swipex < herox and reached_bottom == true then
          swipeobject:move(4+objectspeed*dt,-dt*speed-5)
        elseif swipex > herox and reached_bottom == true then
          swipeobject:move(-4+objectspeed*dt,-dt*speed-5)
        end
    end
    if stage < 3 then 
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
    else
        print(stage)
        if heroy < distanceGoal/2 - cameraoffset then
            ourHero:move(0,dt*speed) -- collider.move 
            cam:lookAt(400,heroy+offset+dt*speed)
        else
            ourHero:move(0,dt*speed/3)
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
            TEsound.play(thuds)
            bouncetimer = 0
            bounce = true
            bouncedistance = colly
        end
   elseif shape_b == ourHero and shape_a.type == "side" then
       hero_shape = shape_b
       if bounce == false then
            TEsound.play(thuds)
            bouncetimer = 0
            bounce = true
            bouncedistance = colly
        end
   elseif shape_a == ourHero and shape_b.type == "bottom" and reached_bottom == false then
        hero_shape = shape_a
        if bounce == false then
            bouncetimer = 0
            bounce = true
            bouncedistance = colly
        end
   elseif shape_b == ourHero and shape_a.type == "bottom" and reached_bottom == false then
       hero_shape = shape_b
       if bounce == false then
            bouncetimer = 0
            bounce = true
            bouncedistance = colly
        end
    elseif shape_a == ourHero and shape_b.type == "bottom" and reached_bottom == true then
       Gamestate.switch(gameover)
       return
   elseif shape_b == ourHero and shape_a.type == "bottom" and reached_bottom == true then
       Gamestate.switch(gameover)
       return
   elseif shape_a == ourHero and shape_b.type == "top" and reached_bottom == true then
       hero_shape = shape_a
        if bounce == false then
            bouncetimer = 0
            bounce = true
            bouncedistance = colly
        end
   elseif shape_b == ourHero and shape_a.type == "top" and reached_bottom == true then
       hero_shape = shape_b
       if bounce == false then
            bouncetimer = 0
            bounce = true
            bouncedistance = colly
        end
   elseif shape_a == ourHero and shape_b.type == "top" and reached_bottom == false then
        TEsound.play(splat)
        Gamestate.switch(gameover)
       return
   elseif shape_b == ourHero and shape_a.type == "top" and reached_bottom == false then
        TEsound.play(splat)
        Gamestate.switch(gameover)
        return
   elseif shape_a == swipeobject and shape_b.type == "soul" then
        map.layers["souls"]["objects"][shape_b.key]["visible"] = false
        table.insert(caughtSouls, shape_b)
        collider:remove(shape_b)
        scorecounter()
        return
    elseif shape_b == swipeobject and shape_a.type == "soul" then
        map.layers["souls"]["objects"][shape_a.key]["visible"] = false
        table.insert(caughtSouls, shape_a)
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
    collx, colly = ourHero:center()
    
    if reached_bottom == false then
        animation:draw(south, collx-89, colly-100, nil, 0.5)
            
        if swiping == true and swipetimer <= 0.5 then
            if swipeToTheLeft == true then
                animation = animations.southBoundSwipeL
            else
                animation = animations.southBoundSwipeR
            end
        else
            if slowdown == true then 
                animation = animations.southBoundCape 
            elseif swipeToTheLeft == true then
                animation = animations.southBoundForkL
            else
                animation = animations.southBoundForkR
            end
        end

    else
        animation:draw(north, collx-89, colly-100, nil, 0.5)

        if swiping == true and swipetimer <= 0.5 then
            if swipeToTheLeft == true then
                animation = animations.northBoundSwipeL
            else
                animation = animations.northBoundSwipeR
            end
        else
            if slowdown == true then
                animation = animations.northBoundCape
            elseif swipeToTheLeft == true then
                animation = animations.northBoundForkL
            else
                animation = animations.northBoundForkR
            end
        end

    end
    
end
  
function hero.playSoundWithTimer(dt, sound)
    if repeatTimer >= repeatDelay then
        TEsound.play(sound)
        repeatTimer = 0
    else 
        repeatTimer = repeatTimer + dt
    end
end

function hero.handleInput(dt,herospeed,speedmargin,swipeaction,swipe)
    collx, colly = ourHero:center()
    if bounce == true and herospeed > 0 then
        bouncetimer = bouncetimer + dt
        objectspeed = -herospeed/2.5
        ourHero:move(-herospeed*dt/2.5, 0)
        if bouncetimer >= 0.2 then
          bounce = false
          return -herospeed/2.5
        end
    elseif bounce == true and herospeed < 0 then
        bouncetimer = bouncetimer + dt
        objectspeed = -herospeed/2.5
        ourHero:move(-herospeed*dt/2.5, 0)
        if bouncetimer >= 0.2 then
          bounce = false
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
        end
        ourHero:move(herospeed*dt, 0)
        objectspeed = herospeed
    end
    
    return herospeed
end

function hero.findToptiles(map)
    local collidable_tiles = {}

     for i, obj in ipairs( map("top").objects ) do
         local collObject
         local coordlist = {}
         local crap = {}
            for j, k in ipairs(obj.polygon) do
              if j % 2 == 0 then
                table.insert(coordlist, k + obj.y)
              else
                table.insert(coordlist, k + obj.x - 120)
              end
      end
         collObject = collider:addPolygon(unpack(coordlist))
         collObject.type = "top"
         collider:addToGroup("top", collObject)
         collider:setPassive(collObject)
         table.insert(collidable_tiles, collObject)
         colliderobject = collObject
     end

    return collidable_tiles
end

function hero.findbottomTiles(map)
    local collidable_tiles = {}

     for i, obj in ipairs( map("bottom").objects ) do
         local collObject
         local coordlist = {}
         local crap = {}
            for j, k in ipairs(obj.polygon) do
              if j % 2 == 0 then
                table.insert(coordlist, k + obj.y)
              else
                table.insert(coordlist, k + obj.x - 120)
              end
      end
         collObject = collider:addPolygon(unpack(coordlist))
         collObject.type = "bottom"
         collider:addToGroup("bottom", collObject)
         collider:setPassive(collObject)
         table.insert(collidable_tiles, collObject)
         colliderobject = collObject
     end

    return collidable_tiles
end

function hero.findSide(map)
    local collidable_tiles = {}

     for i, obj in ipairs( map("side").objects ) do
         local collObject
         local coordlist = {}
         local crap = {}
            for j, k in ipairs(obj.polygon) do
              if j % 2 == 0 then
                table.insert(coordlist, k + obj.y)
              else
                table.insert(coordlist, k + obj.x - 120)
              end
      end
         collObject = collider:addPolygon(unpack(coordlist))
         collObject.type = "side"
         collider:addToGroup("side", collObject)
         collider:setPassive(collObject)
         table.insert(collidable_tiles, collObject)
         colliderobject = collObject

     end

    return collidable_tiles
end

-- this function might be unneccessary after all
function hero.reloadSoulObjects(map)
    print('reloading Soul Objects...')


    for i, soul in pairs( map("souls").objects ) do
        for property, value in pairs(soul) do
            --print(property, ", ", value)
            if property == "visible" then
                if value == false then
                    print(value)
                    value = true
                    print("put value to be true, like this: ", value)
                end
            end
        end

     for i, obj in pairs(caughtSouls) do
         table.insert(souls, obj)
    end

    end
end


-- for the souls object layer
function hero.findSoulObjects(map)
    --local souls = {}

    print('finding Soul Objects...')
    
      for i, obj in ipairs( map("souls").objects ) do
        local collObject = collider:addRectangle(obj.x-88, obj.y+14, 32, 56) -- hard coded according to soul image tile size
    
        collObject.type = "soul"
        collObject.key = i
        collObject.visible = true
        for j, k in pairs(collObject) do
           -- print(j, ": ", k)
        end
        collider:addToGroup("soul", collObject)
        collider:setPassive(collObject)
        table.insert(souls, collObject)
    end

    return souls
end


return hero
