
function love.load()
	-- background
    background = love.graphics.newImage('gfx/cave.png')
    background2 = love.graphics.newImage('gfx/cave.png')
    backgroundy = 0
    --background2y = 440
    dir =  -128
    -- lucifer's character
    pinkdude = love.graphics.newImage('gfx/pinkdude.bmp')
    dudeSpeed = 600
    dudeX = 120
end

function love.draw()
    -- background drawing
    --love.graphics.rotate(1.57079633)
    love.graphics.draw(background, 160, backgroundy )
    love.graphics.draw(background2, 160, backgroundy + background:getHeight() )
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
