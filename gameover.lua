local gameover = {}
	
	local gameoverImage

	function gameover:init()
		gameoverImage = love.graphics.newImage('gfx/skulls-red-black-bonesq.jpeg')
        
        speed = 0
		print('game over.init')
	end

    function gameover:enter(previous)
        print('gameover:enter')
    end

    function gameover:leave()
        print('gameover:leave')
    end
    
	function gameover:draw()
	    love.graphics.draw(gameoverImage, 0, 0)
        love.graphics.setColor(140,17,37)
        love.graphics.print("Press Enter to restart", 400,400,0,0.5,0.5)
        love.graphics.print("Press Esc for Main Menu", 400,550,0,0.5,0.5)
        love.graphics.setColor(255,255,255)
    end

    function gameover:keyreleased(key)
    	if key == "return" then
    		print("pressed enter from gameover state")
    		Gamestate.switch(game)
    	end
        if key == "escape" then
            Gamestate.switch(menu)
        end
    end

return gameover