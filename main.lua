--background layer loaded
require('TEsound')
require('utf8')

-- Tiled stuff
loader = require "AdvTiledLoader/Loader"
anim8 = require "anim8-master/anim8"
-- set the path to the Tiled map files
loader.path = "gfx/"
-- End Tiled stuff

HC = require "HardonCollider"
Camera = require "hump.camera"
gamemenu = require "menu"
souls = require "souls"
foreground = require "foreground"

local scoresign
ourHero = require "hero"
scorecount = 0

local stage = 1


-- gamestates 
Gamestate = require "hump.gamestate"
highscore = require "sick"
menu = require "menu"
game = require "game"
gameover = require "gameover"
offline = require "gameoveroffline"

stage = 1

local mainfont = love.graphics.setNewFont("font/ufonts.com_goatbeard.ttf", 120)
local sounds = require('sounds')


love.keyboard.setTextInput(false)
love.window.setMode(1200, 800)
--love.window.setFullscreen(true)

function love.load()

    love.graphics.setFont(mainfont)
    highscore.set("highscore", 5, "Johnnie", 3)

    TEsound.playLooping(wind)
    TEsound.playLooping(fire, 'hellfire', nil, fireVolume)

    Gamestate.registerEvents()
    -- print('about to switch')
    Gamestate.switch(menu) -- REMEMBER TO PUT TO MENU
end

function love.draw()
	
end


function on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)
    ourHero.on_collide(dt, shape_a, shape_b, mtv_x, mtv_y,reached_bottom)
end




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

            
end

function love.keyreleased(key)
    
end




