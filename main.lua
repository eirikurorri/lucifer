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

local ourHero = require "hero"
local collider
local allSolidTiles
local distanceGoal
local distance
local speed
local maxspeed = 700
local death
local scorecount
local gamestate = "menu"

function love.load()

	-- Tiled stuff
	--map = loader.load("testmap.tmx")
    map = loader.load("testmap2.tmx")
    map:setDrawRange(0,0,800,32000)
    -- map("object").visible = false -- makes object map invisible
	-- End Tiled stuff
    camY = 0
    cam = Camera(400,0)
    cam:cameraCoords(0,0)
	-- Collider stuff
    scorecount = 0
	-- load HardonCollider, set callback to on_collide and size of 100
    collider = HC(100, on_collide)
    -- find all the tiles that we can collide with
    ourHero.setupHero(400,-200, collider)
    allSolidTiles = ourHero.findSolidTiles(map)
    deathtiles = ourHero.findSolidTilesLayer(map)
    soulTiles = ourHero.findSouls(map)
    -- set up the hero object, set him to position 32, 32
    reached_bottom = false
	-- background
    background.loadBackground()

    --distance monitor and goal
    distanceGoal = 32000
    distance = 0
    -- Tiled stuff
    -- speedometer, use for different speeds
	speed = 200
    death = false
    killed = love.graphics.newImage('gfx/death2.jpg')
	-- End Tiled stuff

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
        
        if speed < maxspeed then
            speed = speed * 1.001
        end
        love.graphics.print(speed,680,100)

        -- FPS meter and memory counter
        love.graphics.print("FPS: "..love.timer.getFPS() .. '\nMem(kB): ' .. math.floor(collectgarbage("count")), 680, 20)
        love.graphics.print("Score: "..scorecount, 680, 60)
	   -- Tiled stuff
	   cam:draw(drawCamera)
	   -- end Tiled stuff
	    if cam.y >= distanceGoal then
            reached_bottom = true
        elseif cam.y <= 0 then
            reached_bottom = false
        end
        love.graphics.print(cam.y, 680, 80)
        -- scrolling speed for ledge and soul
    else
        love.graphics.draw(killed,0,-100)
        love.graphics.print("FPS: "..love.timer.getFPS() .. '\nMem(kB): ' .. math.floor(collectgarbage("count")), 680, 20)
        
    end
end

function scorecounter()
    scorecount = scorecount + 1
end

function drawCamera()

    map:draw()
    ourHero.draw()

end

function love.update(dt)
    -- player events handled
    ourHero.handleInput(dt,speed)
    ourHero.updateHero(dt,cam,speed,reached_bottom)
    collider:update(dt) 

    if love.keyboard.isDown("return") and gamestate == "menu"
        or love.keyboard.isDown("return") and death == true and gamestate == "playing" then
        gamestate = "playing"
        love.load()
    elseif love.keyboard.isDown("escape") and death == true and gamestate == "playing" then
        gamestate = "menu"
        love.load()
    end
    if reached_bottom == false then
        distance = distance + cam.y
    else
        distance = distance - cam.y
    end 
    
end

function endgame()
    
    death = true
    speed = 0
end

function findSolidTiles(map)
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
