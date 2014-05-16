local menu = {}
	
	local menuimage

	function menu:init()
		menuimage = love.graphics.newImage('gfx/fall-of-lucifer.jpg')
		print('menu.init')
	end

	function menu:draw()
	    love.graphics.draw(menuimage, 0, 0)
        love.graphics.setColor(140,17,37)
        love.graphics.print("Press Enter to begin", 400,400,0,0.5,0.5)
        love.graphics.setColor(255,255,255)
    end

    function menu:enter(previous)
    	print('menu:enter')
    end

    function menu:leave()
    	print('menu:leave')
    end
    
    function menu:keyreleased(key)
    	if key == "return" then
    		print("pressed enter from menu state")
    		Gamestate.switch(game)
    	end
    end

return menu