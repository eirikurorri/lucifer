local player = {}

function player.loadPlayer()
	-- avatar loaded
	pinkdude = love.graphics.newImage('gfx/pinkdude.bmp')
	-- movement speed
    dudeSpeed = 600 
    -- X axis placement, initial value is 90
    dudeX = 420 
    dudeY = 90 
end

function player.drawPlayer()
	-- our character drawn
    love.graphics.draw(pinkdude, dudeX, dudeY)
end

function player.updatePlayer( dt )

	if (love.keyboard.isDown("left")) then 
    	dudeX = dudeX - dudeSpeed * dt
    end
    if (love.keyboard.isDown("right")) then 
    	dudeX = dudeX + dudeSpeed * dt
    end 
    if (love.keyboard.isDown("up")) then 
        dudeY = dudeY - dudeSpeed * dt
    end 
    if (love.keyboard.isDown("down")) then 
        dudeY = dudeY + dudeSpeed * dt
    end 

end

return player
