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

function background.drawBackground()
	love.graphics.draw(background, 160, backgroundy )
    love.graphics.draw(background2, 160, background2y + bgheight )

    -- movement of the scrolling movement of the background through Y-axis
    backgroundy = backgroundy - 4
    background2y = background2y - 4

    -- resets the background to create a scrolling feeling
    if backgroundy <= -bgheight then
        backgroundy = 0 
    end

    if background2y <= -bgheight then
        background2y = 0
    end

end

function background.debugBackground()

    -- debugging for positions of background images
    love.graphics.print(backgroundy, 680,100)
    love.graphics.print(background2y, 680, 120)
end

return background