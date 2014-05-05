--background layer loaded
background = require "background"
-- player code instatiated
player = require "player"

function love.load()
	-- background
    background.loadBackground()
    -- lucifer's character
    player.loadPlayer()
    -- ledge obstacle
    ledge = love.graphics.newImage('gfx/ledge.bmp')
    -- soul dude
    soul = love.graphics.newImage('gfx/souldude.bmp')
    soulmovementX = 0 -- want to have soul dude float back and forth a little bit

    ledgey = 0
    souly = 0

end

function love.draw()
    -- background drawing
    background.drawBackground()
    background.debugBackground()
    -- player avatar drawn
    player.drawPlayer()
    -- ledge drawing
    love.graphics.draw(ledge, -20, ledgey + bgheight )
    -- soul dude drawn
    love.graphics.draw(soul, 550, 200 + souly + bgheight )
    -- FPS meter and memory counter
    love.graphics.print("FPS: "..love.timer.getFPS() .. '\nMem(kB): ' .. math.floor(collectgarbage("count")), 680, 20)
    
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

function love.update(dt)
    -- player events handled
    player.updatePlayer(dt)     

end
