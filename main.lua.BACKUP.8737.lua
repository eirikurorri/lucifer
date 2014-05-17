--background layer loaded
background = require "background"
require('TEsound')
require('utf8')

-- Tiled stuff
loader = require "AdvTiledLoader/Loader"
anim8 = require "anim8-master/anim8"
-- set the path to the Tiled map files
loader.path = "gfx/"
-- End Tiled stuff
<<<<<<< HEAD
HC = require "HardonCollider"
Camera = require "hump.camera"
gamemenu = require "menu"
souls = require "souls"
foreground = require "foreground"
=======
local HC = require "HardonCollider"
local Camera = require "hump.camera"
local gamemenu = require "menu"
local souls = require "souls"
local foreground = require "foreground"
local http = require "socket.http"
local ltn12 = require "ltn12"
>>>>>>> 8bdadd6628e8d717a0fcaf25759db3b8cbbee3e3

local scoresign
ourHero = require "hero"

<<<<<<< HEAD
=======
local text = ""

local postscore = false

local stage = 1
>>>>>>> 8bdadd6628e8d717a0fcaf25759db3b8cbbee3e3

-- gamestates 
Gamestate = require "hump.gamestate"

menu = require "menu"
game = require "game"
gameover = require "gameover"

stage = 1

local mainfont = love.graphics.setNewFont("font/ufonts.com_goatbeard.ttf", 120)
local sounds = require('sounds')


love.keyboard.setTextInput(disable)
love.window.setMode(1200, 800)

function love.load()

    love.graphics.setFont(mainfont)

<<<<<<< HEAD
=======

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
    toptiles = ourHero.findToptiles(map)
    sidetiles = ourHero.findSide(map)
    bottomtiles = ourHero.findbottomTiles(map)
    -- set up the hero object, set him to position 32, 32
    reached_bottom = false
    slowdown = false
    swipeaction = false
    slowdowninitiate = false
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
    postscore = false
    killed = love.graphics.newImage('gfx/skulls-red-black-bonesq.jpeg')
    scoresign = love.graphics.newImage('gfx/scoresign.png')
	-- End Tiled stuff
    herospeed = 0
    -- menu loaded
    gamemenu.loadmenu()
>>>>>>> 8bdadd6628e8d717a0fcaf25759db3b8cbbee3e3
    TEsound.playLooping(wind)
    TEsound.playLooping(fire, 'hellfire', nil, fireVolume)

    -- load HardonCollider, set callback to on_collide and size of 100
    collider = HC(100, on_collide)

    Gamestate.registerEvents()
    Gamestate.switch(menu)
end



function on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)
    ourHero.on_collide(dt, shape_a, shape_b, mtv_x, mtv_y,reached_bottom)
end


<<<<<<< HEAD
=======
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

        if ourHero.heroycoords() <= distanceGoal/2 then
        	TEsound.volume("hellfire", ourHero.heroycoords()/(distanceGoal/2))
        else
        	reversedY = distanceGoal - ourHero.heroycoords()
        	TEsound.volume("hellfire", reversedY/(distanceGoal/2))
        end
        
        -- print(fireVolume)
    else
        love.graphics.draw(killed,0,-100)
        love.graphics.draw(killed,0,0)
        --love.graphics.print("FPS: "..love.timer.getFPS() .. '\nMem(kB): ' .. math.floor(collectgarbage("count")), 1050, 20)
        love.graphics.setColor(140,17,37)
        love.graphics.print("Press Enter to restart", 400,400,0,0.5,0.5)
        love.graphics.setColor(255,255,255)
        -- background.drawBackground(reached_bottom,distance)

        
        love.graphics.print(text, 300, 500)
        love.graphics.print("Score: " ..scorecount, 300,600)

        --cam:draw(drawCamera)
    end
    
end
>>>>>>> 8bdadd6628e8d717a0fcaf25759db3b8cbbee3e3

function scorecounter()
    scorecount = scorecount + 1
end

function drawCamera()
	foreground.drawForeground()
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
<<<<<<< HEAD
=======

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
        else
            if postscore == false then
            --arnarth.pythonanywhere.com/save/

            
            --local respbody = {} -- for the response body
            --local result = http.request("http://arnarth.pythonanywhere.com/save/"..name.."/"..score.."/".."lucifer")
            --local result = http.request("http://arnarth.pythonanywhere.com/load/lucifer")

            text = ""
            enabled = love.keyboard.hasTextInput( )
            print(enabled)    
            love.keyboard.setTextInput(true)
            enabled = love.keyboard.hasTextInput( )
            print(enabled)

            --local einn = string.gmatch(result,'"score":%s"(%d+)"')
            --local tveir = string.gmatch(result,'"name":%s"(%a+)"')
            --for w in einn do 
            --    print(w)
            --end
            --for x in tveir do
            --    print(x)
            --end
            --print(result)
            --print(einn)
            --print(tveir)
            
            postscore = true
            end

            

            --love.graphics.setColor(255,255,255)
            --love.graphics.printf(text, 400, 400, love.graphics.getWidth())
        end
    end
    
end

function love.keyreleased(key)
    if key == "backspace" then
        text = text:utf8sub(1,-2) 
    end
    if key == "return" then
        --http.request("http://arnarth.pythonanywhere.com/save/"..text.."/"..scorecount.."/".."lucifer")
        print(scorecount)
        love.keyboard.setTextInput(false)
    end
    print(scorecount)
end

function love.textinput(t)
    text = text .. t
    print(text)
end

function endgame()
    TEsound.play(splat)
    death = true
    speed = 0
>>>>>>> 8bdadd6628e8d717a0fcaf25759db3b8cbbee3e3
end
