--background layer loaded
background = require "background"

-- Tiled stuff!
local loader = require "AdvTiledLoader/Loader"
-- set the path to the Tiled map files
loader.path = "gfx/"
-- End Tiled stuff
local HC = require "HardonCollider"
local Camera = require "hump.camera"
local gamemenu = require "menu"
local souls = require "souls"

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

love.window.setMode(1200, 800)

function love.load()

	-- Tiled stuff
	map = loader.load("derpmap.tmx")
    --map = loader.load("testmap2.tmx")
    map:setDrawRange(0,0,960,32000)
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
    --allSolidTiles = ourHero.findSolidTiles(map)
    --deathtiles = ourHero.findSolidTilesLayer(map)
    soulTiles = ourHero.findSoulObjects(map)
    -- set up the hero object, set him to position 32, 32
    reached_bottom = false
	-- background
    background.loadBackground()

    --distance monitor and goal
    distanceGoal = 3200
    distance = 0
    -- Tiled stuff
    -- speedometer, use for different speeds
	speed = 200
    death = false
    killed = love.graphics.newImage('gfx/death2.jpg')
    scoresign = love.graphics.newImage('gfx/scoresign.png')
	-- End Tiled stuff
    herospeed = 0
    -- menu loaded
    gamemenu.loadmenu()

end



function on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)
    ourHero.on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)
end


function love.draw()
    --love.graphics.scale(0.25, 0.25)
    if gamestate == "menu" then
        gamemenu.loadmenu()
        
    elseif death == false then
        -- background drawing
        background.drawBackground(reached_bottom)
        --background.debugBackground()
        if (cam.y < distanceGoal/2 and reached_bottom == false)
         or (cam.y > distanceGoal/2 and reached_bottom == true) then
            if speed < maxspeed then
                speed = speed + 0.3
            end
        elseif  (cam.y > distanceGoal/2 and reached_bottom == false)
         or (cam.y < distanceGoal/2 and reached_bottom == true)  then
            if speed > 200 then
                speed = speed - 0.1
            end
        end
        love.graphics.print("Cam pos y: ".. math.floor(cam.y),1050,200)
        love.graphics.print(math.floor(speed),1050,180)
        --love.graphics.print(math.floor(distance),1050,220)



        -- FPS meter and memory counter
        love.graphics.print("FPS: "..love.timer.getFPS() .. '\nMem(kB): ' .. math.floor(collectgarbage("count")), 1050, 300)
        
        
	   -- Tiled stuff
	   cam:draw(drawCamera)
       --souls.drawSouls(map) -- uncomment for soul drawing action!
       love.graphics.draw(scoresign, 1000, 20)
       love.graphics.print("Score: "..scorecount, 1050, 75)
	   -- end Tiled stuff
	    if ourHero.herocoords() >= distanceGoal - 100 then
            reached_bottom = true
        elseif ourHero.herocoords() <= 100 then
            reached_bottom = false
        end
        --love.graphics.print(cam.y, 680, 80)
        -- scrolling speed for ledge and soul
    else
        love.graphics.draw(killed,0,-100)
        love.graphics.print("FPS: "..love.timer.getFPS() .. '\nMem(kB): ' .. math.floor(collectgarbage("count")), 1050, 20)
        
    end
end

function scorecounter()
    scorecount = scorecount + 1
end

function drawCamera()

    map:draw()
    ourHero.draw()

end

function reset()
end

function love.update(dt)
    -- player events handled
    --print(speedmargin)
    

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
            herospeed = ourHero.handleInput(dt,herospeed,speedmargin)
            --print(herospeed)
            ourHero.updateHero(dt,cam,speed,reached_bottom)
            collider:update(dt) 

            if reached_bottom == false then
                distance = ourHero.herocoords()
            else
                distance = ourHero.herocoords()
            end 
        end
    end
    
end

function endgame()
    
    death = true
    speed = 0
end
