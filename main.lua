
function love.load()
	-- background
    background = love.graphics.newImage('gfx/cave.png')
    background2 = love.graphics.newImage('gfx/cave.png')
    backgroundy = 0
    --background2y = 440
    dir =  -128
    -- lucifer's character
    pinkdude = love.graphics.newImage('gfx/pinkdude.bmp')
    dudeSpeed = 600 -- movement speed
    dudeX = 420 -- X axis placement, initial value is 120
    -- ledge obstacle
    ledge = love.graphics.newImage('gfx/ledge.bmp')
    -- soul dude
    soul = love.graphics.newImage('gfx/souldude.bmp')
    soulmovementX = 0 -- want to have soul dude float back and forth a little bit
end

function love.draw()
    -- background drawing
    love.graphics.draw(background, 160, backgroundy )
    love.graphics.draw(background2, 160, backgroundy + background:getHeight() )
    -- ledge drawing
    love.graphics.draw(ledge, -20, backgroundy + background:getHeight() )
    -- soul dude drawn
    love.graphics.draw(soul, 550, 200 + backgroundy + background:getHeight() )
    -- our character drawn
    love.graphics.draw(pinkdude, dudeX, 90)
    -- FPS meter
    love.graphics.print("FPS: "..love.timer.getFPS() .. '\nMem(kB): ' .. math.floor(collectgarbage("count")), 680, 20)
    love.graphics.print(background:getHeight(),680,80)
    love.graphics.print(backgroundy, 680,100)

    backgroundy = backgroundy - 4
    --background2y = background2y - 1
    if backgroundy <= -background:getHeight() then
        backgroundy = 0 
    end

end

function love.update( dt )
    --backgroundy = backgroundy + dir * dt
    --background2y = background2y + dir * dt
    
    if (love.keyboard.isDown("left")) then 
    	dudeX = dudeX - dudeSpeed * dt
    end
    if (love.keyboard.isDown("right")) then 
    	dudeX = dudeX + dudeSpeed * dt
    end   

end
