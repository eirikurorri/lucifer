
function love.load()
	-- background
    background=love.graphics.newImage('gfx/cave.png')
    background2= love.graphics.newImage('gfx/cave.png')
    background1y = 0
    background2y = 490
    dir =  -32
    -- lucifer's character
    pinkdude = love.graphics.newImage('gfx/pinkdude.bmp')
    dudeSpeed = 600
    dudeX = 400
end

function love.draw()
    love.graphics.draw(background, 0, background1y )
    love.graphics.rotate(1)
    love.graphics.draw(background2, 0, background2y )
    love.graphics.draw(pinkdude, dudeX, 180)
end

function love.update( dt )
    background1y = background1y + dir * dt
    background2y = background2y + dir * dt
    if (love.keyboard.isDown("left")) then 
    	dudeX = dudeX - dudeSpeed * dt
    end
    if (love.keyboard.isDown("right")) then 
    	dudeX = dudeX + dudeSpeed * dt
    end
end
