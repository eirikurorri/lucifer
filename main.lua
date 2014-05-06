--background layer loaded
background = require "background"
-- player code instatiated
--player = require "player"

-- Tiled stuff!
local loader = require "AdvTiledLoader/Loader"
-- set the path to the Tiled map files
loader.path = "gfx/"
-- End Tiled stuff
local HC = require "HardonCollider"
local Camera = require "hump.camera"


local ourHero = require "hero"
local collider
local allSolidTiles
local distanceGoal
local distance
local speed

function love.load()

	-- Tiled stuff
	--map = loader.load("testmap.tmx")
    map = loader.load("testmap2.tmx")
    map:setDrawRange(0,0,800,32000)
	-- End Tiled stuff
    camY = 0
    cam = Camera(400,0)
    cam:cameraCoords(0,0)
	-- Collider stuff
	-- load HardonCollider, set callback to on_collide and size of 100
    collider = HC(100, on_collide)
    -- find all the tiles that we can collide with
    ourHero.setupHero(32,32, collider)
    allSolidTiles = ourHero.findSolidTiles(map)
    deathtiles = ourHero.findSolidTileslayer(map)
    -- set up the hero object, set him to position 32, 32
    reached_bottom = false
	-- background
    background.loadBackground()

    --distance monitor and goal
    distanceGoal = 3200
    distance = 0
    -- Tiled stuff
    -- speedometer, use for different speeds
	speed = 300
	-- End Tiled stuff


end

function on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)
    ourHero.on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)
end


function love.draw()
    --love.graphics.scale(0.25, 0.25)

    -- background drawing
    background.drawBackground(reached_bottom)
    background.debugBackground()

    
    -- FPS meter and memory counter
    love.graphics.print("FPS: "..love.timer.getFPS() .. '\nMem(kB): ' .. math.floor(collectgarbage("count")), 680, 20)

	-- Tiled stuff
	cam:draw(drawCamera)
	-- end Tiled stuff
	if cam.y >= distanceGoal then
        reached_bottom = true
        love.graphics.print("DOWN", 680, 140)
    elseif cam.y <= 0 then
        reached_bottom = false
        love.graphics.print("UP", 680, 160)
    end
    love.graphics.print(cam.y, 680, 80)
    -- scrolling speed for ledge and soul

end

function drawCamera()

    map:draw()
    ourHero.draw()

end

function love.update(dt)
    -- player events handled
 
    ourHero.handleInput(dt)
    ourHero.updateHero(dt,cam,speed,reached_bottom)
    collider:update(dt) 

    if reached_bottom == false then
        distance = distance + cam.y
    else
        distance = distance - cam.y
    end 
    
end

function endgame()
    
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
