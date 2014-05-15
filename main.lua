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
local slowdowninterval = 0
local slowdowninitiate = false
local slowdownstart = 0
local slowdownend = 0
local slowdistance = 0
local swipeaction = false
local soundtimer = 0

local stage = 1

local mainfont = love.graphics.setNewFont("font/ufonts.com_goatbeard.ttf", 120)

--local backgroundImage = love.graphics.newImage('gfx/tile5.jpg')
local menuimage = love.graphics.newImage('gfx/fall-of-lucifer.jpg')
local sounds = require('sounds')

love.window.setMode(1200, 800)

function love.load()

    --print("lol")
	-- Tiled stuff
	--map = loader.load("testmap.tmx")

    love.graphics.setFont(mainfont)


    map = loader.load("derpmap.tmx")
    map:setDrawRange(0,0,960,41600)
    map.offsetX = 120
    map("top").visible = false --true
   -- map("top").color = {255,0,0}
   -- map("side").color = {0,255,0}
   -- map("bottom").color = {0,0,255}
    map("ledge").visible = false
    map("sides").visible = false
    map("top").visible = false
    map("side").visible = false
    map("bottom").visible = false
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
    soulTiles = ourHero.findSoulObjects(map)
    --toptiles = ourHero.findToptiles(map)
    --sidetiles = ourHero.findSide(map)
    --bottomtiles = ourHero.findbottomTiles(map)
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
    killed = love.graphics.newImage('gfx/skulls-red-black-bonesq.jpeg')
    scoresign = love.graphics.newImage('gfx/scoresign.png')
	-- End Tiled stuff
    herospeed = 0
    -- menu loaded
    gamemenu.loadmenu()
    TEsound.playLooping(wind)

    stage = 1
end



function on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)
    ourHero.on_collide(dt, shape_a, shape_b, mtv_x, mtv_y,reached_bottom)
end


function love.draw()
    --love.graphics.scale(0.25, 0.25)

    if gamestate == "menu" then
        love.graphics.draw(menuimage, 0, 0)
        love.graphics.setColor(140,17,37)
        love.graphics.print("Press Enter to begin", 400,400,0,0.5,0.5)
        love.graphics.setColor(255,255,255)
        
    elseif death == false then
        if stage < 3 then
            if reached_bottom == false then
                if distance < distanceGoal/2 then
                    if speed < maxspeed then
                        speed = speed + 0.2
                    end
                else
                    if speed > 200 then
                        speed = speed - 0.2
                    end
                end
            else
                if distance > distanceGoal/2 then
                    if speed < maxspeed then
                        speed = speed + 0.2
                    end
                else
                    if speed > 200 then
                        speed = speed - 0.2
                    end
                end
            end
        else
            if speed < maxspeed then
                speed = speed + 0.4
            end
            if distance >= distanceGoal/2 then
                speed = 0    
            end
            
            
        end
        --love.graphics.setColor(140,17,37)
        love.graphics.print("Cam pos y: ".. math.floor(cam.y),1050,200,0,0.25,0.25)
        love.graphics.print("Speed: "..math.floor(speed),1050,180,0,0.25,0.25)
        love.graphics.print("Slowdown Speed: "..math.floor(slowdownstart),1000,80,0,0.25,0.25)
        love.graphics.print("Slowdownend speed: "..math.floor(slowdownend),1000,100,0,0.25,0.25)
        love.graphics.print(math.floor(distance),1050,220,0,0.25,0.25)
        -- FPS meter and memory counter
        love.graphics.print("FPS: "..love.timer.getFPS() .. '\nMem(kB): ' .. math.floor(collectgarbage("count")), 1050, 140,0,0.25,0.25)
        
	    cam:draw(drawCamera)

	    if ourHero.heroycoords() >= distanceGoal - 100 then
            if reached_bottom == false then
                stage = stage + 1
            end
            reached_bottom = true
            
            print(stage)
        elseif ourHero.heroycoords() <= 100 then
            if reached_bottom == true then
                stage = stage + 1
            end
            reached_bottom = false
            
            print(stage)
        end

    else
        love.graphics.draw(killed,0,-100)
        love.graphics.draw(killed,0,0)
        --love.graphics.print("FPS: "..love.timer.getFPS() .. '\nMem(kB): ' .. math.floor(collectgarbage("count")), 1050, 20)
        love.graphics.setColor(140,17,37)
        love.graphics.print("Press Enter to restart", 400,400,0,0.5,0.5)
        love.graphics.setColor(255,255,255)
        -- background.drawBackground(reached_bottom,distance)

        --cam:draw(drawCamera)
    end
    
end

function scorecounter()
    scorecount = scorecount + 1
end

function drawCamera()

	foreground.drawForeground(reached_bottom)
    love.graphics.setColor(82,74,74,128)
    if reached_bottom == false then
        if scorecount < 10 then
            love.graphics.print(scorecount, cam.x-50, cam.y,0,2,2)
        elseif scorecount < 100 and scorecount > 10 then
            love.graphics.print(scorecount, cam.x-90, cam.y,0,2,2)
        else
            love.graphics.print(scorecount, cam.x-130, cam.y,0,2,2)
        end
    else
        if scorecount < 10 then
            love.graphics.print(scorecount, cam.x-50, cam.y-300,0,2,2)
        elseif scorecount < 100 and scorecount > 10 then
            love.graphics.print(scorecount, cam.x-90, cam.y-300,0,2,2)
        else
            love.graphics.print(scorecount, cam.x-130, cam.y-300,0,2,2)
        end
    end
    --love.graphics.setColor(0,255,0)
    if reached_bottom == false then
        love.graphics.rectangle("fill", cam.x-100, cam.y+200, 200-slowdowninterval*40,20)
    else
        love.graphics.rectangle("fill", cam.x-100, cam.y-100, 200-slowdowninterval*40,20)
    end
    love.graphics.setColor(255,255,255)
    map:draw()
    ourHero.draw()

end

function love.update(dt)
    -- player events handled
  	TEsound.cleanup()
    soundtimer = soundtimer + dt
    if love.keyboard.isDown("return") and gamestate == "menu"
        or love.keyboard.isDown("return") and death == true and gamestate == "playing" then
        gamestate = "playing"
        love.load()
    elseif love.keyboard.isDown("escape") and death == true and gamestate == "playing" then
        gamestate = "menu"
        love.load()
    end
    if gamestate == "menu" then

    else
        if death == false then

            if love.keyboard.isDown("a") and swipeaction == false then
                swipeaction = true
                swipe = ourHero.initSwipe(ourHero.heroxcoords()-50,ourHero.heroycoords())
                elapsedtime = 0
                TEsound.play(pitchFork)
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
                TEsound.play(pitchFork)
            elseif swipeaction == true then
                elapsedtime = elapsedtime + dt
                if elapsedtime >= 0.5 then
                    ourHero.removeswipeobject()
                end
                if elapsedtime >= 1 then
                    swipeaction = false
                end
            end

             if love.keyboard.isDown("s") and slowdowninitiate == false then
                slowdownstart = 0
                slowdown = true
                slowdowninitiate = true
                slowdownstart = speed
                TEsound.play(chute)
                slowdowntimer = 0
                slowdowninterval = 0
            elseif slowdown == true then
                slowdownend = speed
                slowdowntimer = slowdowntimer + dt
                slowdowninterval = slowdowninterval + dt
                slowdownstart = slowdownstart * 0.99
                ourHero.updateHero(dt,cam,slowdownstart,reached_bottom,distanceGoal,cameraoffset,slowdown,slowdistance,swipeaction,swipe,elapsedtime,herospeed,stage)
                if slowdowntimer >= 1.5 then
                    slowdown = false
                end
            elseif slowdowninitiate == true then
                 slowdowninterval = slowdowninterval + dt 
                 slowdownend = speed
                 if slowdownstart <= slowdownend then
                    slowdownstart = slowdownstart * 1.01
                    ourHero.updateHero(dt,cam,slowdownstart,reached_bottom,distanceGoal,cameraoffset,slowdown,slowdistance,swipeaction,swipe,elapsedtime,herospeed,stage)
                 else
                    ourHero.updateHero(dt,cam,slowdownstart,reached_bottom,distanceGoal,cameraoffset,slowdown,slowdistance,swipeaction,swipe,elapsedtime,herospeed,stage)
                 end
                 if slowdowninterval >= 5 then
                    slowdowninitiate = false
                    slowdowninterval = 0
                end
            
            else
                ourHero.updateHero(dt,cam,speed,reached_bottom,distanceGoal,cameraoffset,slowdown,slowdistance,swipeaction,swipe,elapsedtime,herospeed,stage)
            end 
            herospeed = ourHero.handleInput(dt,herospeed,speedmargin)
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
    TEsound.play(splat)
    death = true
    speed = 0
end
