--background layer loaded
--background = require "background"
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
local http = require "socket.http"
local ltn12 = require "ltn12"

local scoresign
ourHero = require "hero"


local text = ""

local postscore = false

local stage = 1


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
--love.window.setFullscreen(true)

function love.load()

    love.graphics.setFont(mainfont)


    TEsound.playLooping(wind)
    TEsound.playLooping(fire, 'hellfire', nil, fireVolume)

    -- load HardonCollider, set callback to on_collide and size of 100
    --collider = HC(100, on_collide)

    Gamestate.registerEvents()
    Gamestate.switch(menu)
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
    --print(scorecount)
end

function love.textinput(t)
    text = text .. t
    print(text)
end


