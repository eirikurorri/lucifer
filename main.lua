--background layer loaded
background = require "background"
require('TEsound')

-- Tiled stuff!
local loader = require "AdvTiledLoader/Loader"
-- set the path to the Tiled map files
loader.path = "gfx/"
-- End Tiled stuff
local HC = require "HardonCollider"
local Camera = require "hump.camera"
local gamemenu = require "menu"
local souls = require "souls"
local foreground = require "foreground"

local scoresign
local ourHero = require "hero"
local collider
-- local allSolidTiles
local distanceGoal
local distance
local speed
local maxspeed = 800
local death
local scorecount
local gamestate = "menu"
local herospeed = 0
local speedmargin = 0.1
local cameraoffset = 700
local slowdown = false
local slowdowntimer 
local slowdowninterval
local slowdowninitiate = false
local slowdistance = 0
local swipeaction = false

--local backgroundImage = love.graphics.newImage('gfx/tile5.jpg')
local menuimage = love.graphics.newImage('gfx/fall-of-lucifer.jpg')
local sounds = require('sounds')

love.window.setMode(1200, 800)

function love.load()

    --print("lol")
	-- Tiled stuff
	--map = loader.load("testmap.tmx")
    map = loader.load("derpmap.tmx")
    map:setDrawRange(0,0,960,41600)
    map.offsetX = 120
    map("top").visible = false --true
   -- map("top").color = {255,0,0}
   -- map("side").color = {0,255,0}
   -- map("bottom").color = {0,0,255}
    map("ledge").visible = false
    map("sides").visible = false
    -- map("object").visible = false -- makes object map invisible
	-- End Tiled stuff
    camY = 0
    cam = Camera(0,0)
    cam:cameraCoords(0,0)
	-- Collider stuff
    scorecount = 0
	-- load HardonCollider, set callback to on_collide and size of 100
    collider = HC(100, on_collide)
    -- find all the tiles that we can collide with
    ourHero.setupHero(400,-300, collider)
    -- print("wat")
    --allSolidTiles = ourHero.findSolidTiles(map)
    --deathtiles = ourHero.findSolidTilesLayer(map)
    soulTiles = ourHero.findSoulObjects(map)
    toptiles = ourHero.findToptiles(map)
    sidetiles = ourHero.findSide(map)
    bottomtiles = ourHero.findbottomTiles(map)
    -- set up the hero object, set him to position 32, 32
    reached_bottom = false
    slowdown = false
    swipeaction = false
	-- background
    --background.loadBackground()
    foreground.loadForeground()
    

    --distance monitor and goal
    distanceGoal = 41600
    distance = 0
    -- Tiled stuff
    -- speedometer, use for different speeds
	speed = 200
    death = false
    killed = love.graphics.newImage('gfx/death3.jpg')
    scoresign = love.graphics.newImage('gfx/scoresign.png')
	-- End Tiled stuff
    herospeed = 0
    -- menu loaded
    gamemenu.loadmenu()
    TEsound.playLooping(wind)
end



function on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)
    ourHero.on_collide(dt, shape_a, shape_b, mtv_x, mtv_y,reached_bottom)
end


function love.draw()
    --love.graphics.scale(0.25, 0.25)
    if gamestate == "menu" then
        love.graphics.draw(menuimage, 0, 0)
        love.graphics.print("Press Enter to begin", 400,400)
        
    elseif death == false then
        -- background drawing
        --background.drawBackground(reached_bottom, heroy)
        -- background.drawBackground(reached_bottom,distance)
        --background.debugBackground()

        if (cam.y < distanceGoal/2 and reached_bottom == false)
         or (cam.y > distanceGoal/2 and reached_bottom == true) then
            if speed < maxspeed then
                speed = speed + 0.2
            end
        elseif  (cam.y > distanceGoal/2 and reached_bottom == false)
         or (cam.y < distanceGoal/2 and reached_bottom == true)  then
            if speed > 200 then
                speed = speed - 0.2
            end
        end
        love.graphics.print("Cam pos y: ".. math.floor(cam.y),1050,200)
        love.graphics.print("Speed: "..math.floor(speed),1050,180)
        love.graphics.print(math.floor(distance),1050,220)



        -- FPS meter and memory counter
        love.graphics.print("FPS: "..love.timer.getFPS() .. '\nMem(kB): ' .. math.floor(collectgarbage("count")), 1050, 140)
        
        
	   -- Tiled stuff
	   cam:draw(drawCamera)
       --souls.drawSouls(map) -- uncomment for soul drawing action!
       love.graphics.draw(scoresign, 1050, 20)
       love.graphics.print("Hell Population: ", 1060, 46)
       love.graphics.print(scorecount, 1100, 61)
	   -- end Tiled stuff
	    if ourHero.heroycoords() >= distanceGoal - 100 then
            reached_bottom = true
        elseif ourHero.heroycoords() <= 100 then
            reached_bottom = false
        end
        --love.graphics.print(cam.y, 680, 80)
        -- scrolling speed for ledge and soul

    else
        --love.graphics.draw(killed,0,-100)
        --love.graphics.draw(killed,0,0)
        --love.graphics.print("FPS: "..love.timer.getFPS() .. '\nMem(kB): ' .. math.floor(collectgarbage("count")), 1050, 20)
        love.graphics.print("Press Enter to restart", 400,400)
        -- background.drawBackground(reached_bottom,distance)

        cam:draw(drawCamera)

    end
    
end

function scorecounter()
    scorecount = scorecount + 1
end

function drawCamera()

	foreground.drawForeground(reached_bottom)
    map:draw()
    ourHero.draw()

end

function reset()
end

function love.update(dt)
    -- player events handled
    --print(speedmargin)
  	TEsound.cleanup()

    if love.keyboard.isDown("return") and gamestate == "menu"
        or love.keyboard.isDown("return") and death == true and gamestate == "playing" then
        gamestate = "playing"
        reset()
        love.load()
    elseif love.keyboard.isDown("escape") and death == true and gamestate == "playing" then
        gamestate = "menu"
        love.load()
    end
    if gamestate == "menu" then

    else
        if death == false then


            if love.keyboard.isDown("s") and slowdowninitiate == false then
            	--print("slo down!")
                --print(slowdowninterval)
                slowdown = true
                slowdowninitiate = true
                slowdownstart = speed
                --sounds.playSoundWithTimer(dt, chute)
                TEsound.play(chute)
                slowdowntimer = 0
                slowdowninterval = 0
            elseif slowdown == true and reached_bottom == false then
                slowdowntimer = slowdowntimer + dt
                speed = speed * 0.99
                --print(speed)
                if slowdowntimer >= 1.5 then
                    slowdown = false
                end
            elseif slowdown == true and reached_bottom == true then
                slowdowntimer = slowdowntimer + dt
                speed = speed * 0.99
                if slowdowntimer >= 1.5 then
                    slowdown = false
                end
            elseif slowdowninitiate == true then
                 slowdowninterval = slowdowninterval + dt 
                 if slowdownstart >= speed then
                    speed = speed * 1.01
                 end
                 if slowdowninterval >= 5 then
                    slowdowninitiate = false
                end
            end
            swipex,swipey = 0
            if love.keyboard.isDown("a") and swipeaction == false then
                swipeaction = true
                swipe = ourHero.initSwipe(ourHero.heroxcoords()-50,ourHero.heroycoords())
                elapsedtime = 0
            elseif swipeaction == true then
                elapsedtime = elapsedtime + dt
                if elapsedtime >= 0.5 then
                    
                    ourHero.removeswipeobject()
                end
                if elapsedtime >= 1 then
                    swipeaction = false
                end
            end
            if love.keyboard.isDown("d") and swipeaction == false then
                swipeaction = true
                swipe = ourHero.initSwipe(ourHero.heroxcoords()+50,ourHero.heroycoords())
                elapsedtime = 0
            elseif swipeaction == true then
                elapsedtime = elapsedtime + dt
                if elapsedtime >= 0.5 then
                    ourHero.removeswipeobject()
                end
                if elapsedtime >= 1 then
                    swipeaction = false
                end
            end
            herospeed = ourHero.handleInput(dt,herospeed,speedmargin)
            ourHero.updateHero(dt,cam,speed,reached_bottom,distanceGoal,cameraoffset,slowdown,slowdistance,swipeaction,swipe,elapsedtime,herospeed,slowdownstart)
            collider:update(dt) 

            if reached_bottom == false then
                distance = ourHero.heroycoords()
            else
                distance = ourHero.heroycoords()
            end 
        end
    end
    
end

function endgame()
    
    death = true
    speed = 0
end
