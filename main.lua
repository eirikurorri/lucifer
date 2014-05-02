
function love.load()
    background=love.graphics.newImage('gfx/cave.png')
    background2= love.graphics.newImage('gfx/cave.png')
    background1y = 0
    background2y = 490
    dir =  -32
end

function love.draw()
    love.graphics.draw(background, 0, background1y )
    love.graphics.draw(background2, 0, background2y )
end

function love.update( dt )
    background1y = background1y + dir * dt
    background2y = background2y + dir * dt
end