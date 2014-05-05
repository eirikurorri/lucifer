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

function love.load()

	-- Tiled stuff
	--map = loader.load("testmap.tmx")
    
	-- End Tiled stuff
    camY = 0
    cam = Camera(400,0)
    cam:cameraCoords(0,0)
	-- Collider stuff
	-- load HardonCollider, set callback to on_collide and size of 100
    collider = HC(100, on_collide)
    -- find all the tiles that we can collide with
    --allSolidTiles = findSolidTiles(map)
    -- set up the hero object, set him to position 32, 32
    ourHero.setupHero(32,32, collider)


	-- background
    background.loadBackground()
    -- lucifer's character
    -- player.loadPlayer()
    -- ledge obstacle
    ledge = love.graphics.newImage('gfx/ledge.bmp')
    -- soul dude
    soul = love.graphics.newImage('gfx/souldude.bmp')
    soulmovementX = 0 -- want to have soul dude float back and forth a little bit
    
    -- lucifer's character
    --player.loadPlayer()

    ledgey = 0
    souly = 0

    --distance monitor and goal
    distanceGoal = 100000
    distance = 0
    -- Tiled stuff
	map = loader.load("testmap.tmx")
    map:setDrawRange(0,0,640,32000)
	-- End Tiled stuff


end

function on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)
    ourHero.on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)
end


function love.draw()
    --love.graphics.scale(1.25, 1.25)
    -- background drawing
    background.drawBackground()
    background.debugBackground()
    -- player avatar drawn
    -- player.drawPlayer()
    -- ledge drawing
    love.graphics.draw(ledge, -20, ledgey + bgheight )
    -- soul dude drawn
    love.graphics.draw(soul, 550, 200 + souly + bgheight )
    -- FPS meter and memory counter
    love.graphics.print("FPS: "..love.timer.getFPS() .. '\nMem(kB): ' .. math.floor(collectgarbage("count")), 680, 20)

	-- Tiled stuff
	cam:draw(drawCamera)
	-- end Tiled stuff
	

    -- scrolling speed for ledge and soul
    ledgey = ledgey - 6
    souly = souly - 6
   
    if ledgey <= -2000 then
        ledgey = 0
    end

    if souly <= -2000 then
        souly = 0
    end

end

function drawCamera()

    map:draw()
    ourHero.draw()

end

function findSolidTiles(map)
	local collidable_tiles = {}

    for x, y, tile in map("ground"):iterate() do
		love.graphics.print(string.format("Tile at (%d,%d) has an id of %d", x, y, tile.id),10,10)
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



function love.update(dt)
    -- player events handled
    --player.updatePlayer(dt) 
    ourHero.handleInput(dt)
    ourHero.updateHero(dt)
    collider:update(dt) 
    camY = camY + 4
    cam:lookAt(400,camY)   

end
