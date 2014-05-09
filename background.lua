local background = {}

function background.loadBackground()
	--background pictures loaded
	background = love.graphics.newImage('gfx/cave.png')
    background2 = love.graphics.newImage('gfx/cave.png')
    -- background Y coordinates set
    backgroundy = 0
    background2y = 0
    -- a fixed height of a background saved for scrolling purposes
    bgheight = background:getHeight()

end  

function background.drawBackground(bottom_reached)
	
    -- movement of the scrolling movement of the background through Y-axis
    if bottom_reached == false then
        love.graphics.draw(background2, 120, background2y - bgheight )
        love.graphics.draw(background, 120, backgroundy )
        love.graphics.draw(background2, 120, background2y + bgheight )
        backgroundy = backgroundy - 4
        background2y = background2y - 4
        
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
        
        backgroundy = backgroundy + 4
        background2y = background2y + 4

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