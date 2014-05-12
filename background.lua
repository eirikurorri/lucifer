local background = {}

function background.loadBackground()
	--background pictures loaded
    -- background = love.graphics.newImage('gfx/map0.png')
    -- background2 = love.graphics.newImage('gfx/map1.png')
    -- background3 = love.graphics.newImage('gfx/map2.png')
    background = love.graphics.newImage('gfx/cave.png')
    background2 = love.graphics.newImage('gfx/cave.png')
    -- background Y coordinates set
    backgroundy = 0
    background2y = 0
    -- background3y = 0
    backgroundSpeed = 4
    -- a fixed height of a background saved for scrolling purposes
    bgheight = background:getHeight()

end  

function background.drawBackground(bottom_reached, heroY)
	
    -- movement of the scrolling movement of the background through Y-axis
    if bottom_reached == false then
        love.graphics.draw(background2, 120, background2y - bgheight )
        love.graphics.draw(background, 120, backgroundy )
        love.graphics.draw(background2, 120, background2y + bgheight )
        --love.graphics.draw(background3, 120, background2y + bgheight )
        backgroundy = backgroundy - backgroundSpeed
        background2y = background2y - backgroundSpeed
        --background3y = background3y - backgroundSpeed
        
        if backgroundy <= -bgheight then
            backgroundy = 0 
        end

        if background2y <= -bgheight then
            background2y = 0
        end
    else
        love.graphics.draw(background2, 120, background2y - bgheight )
        love.graphics.draw(background, 120, backgroundy )
        love.graphics.draw(background2, 120, background2y + bgheight )
        
        backgroundy = backgroundy + backgroundSpeed
        background2y = background2y + backgroundSpeed

        if backgroundy >= bgheight then
            backgroundy = 0 
        end

        if background2y >= bgheight then
            background2y = 0
        end
    end

    -- resets the background to create a scrolling feeling
    

end

function background.debugBackground()

    -- debugging for positions of background images
    love.graphics.print(backgroundy, 680,100)
    love.graphics.print(background2y, 680, 120)
end

return background