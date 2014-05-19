local menu = {}
	
	local menuimage
	

	function menu:init()
		menuimage = love.graphics.newImage('gfx/fall-of-lucifer.jpg')
		buttonPassive = love.graphics.newImage('gfx/ButtonNonSelected.png')
		buttonSelected = love.graphics.newImage('gfx/ButtonSelected.png')
		selectedState = 0
		print('menu.init')
	end

	function menu:draw()
	    love.graphics.draw(menuimage, 0, 0)
	    if selectedState == 0 then 
	    	love.graphics.draw(buttonSelected, 100, 600) -- Play
	    	love.graphics.draw(buttonPassive, 450, 600)
	    	love.graphics.draw(buttonPassive, 800, 600)
	    elseif selectedState == 1 then
	    	love.graphics.draw(buttonPassive, 100, 600) -- Scoreboard
	    	love.graphics.draw(buttonSelected, 450, 600)
	    	love.graphics.draw(buttonPassive, 800, 600)
	    elseif selectedState == 2 then
	    	love.graphics.draw(buttonPassive, 100, 600) -- Quit
	    	love.graphics.draw(buttonPassive, 450, 600)
	    	love.graphics.draw(buttonSelected, 800, 600)
	    end

	    love.graphics.print("Start", 185, 610, 0, 0.5, 0.5)
	    
	    love.graphics.print("Scoreboard", 470, 610, 0, 0.5, 0.5)
	    
	    love.graphics.print("Quit", 890, 610, 0, 0.5, 0.5)
        love.graphics.setColor(140,17,37)
        --love.graphics.print("Press Enter to begin", 400,400,0,0.5,0.5)
        love.graphics.setColor(255,255,255)
        -- if menu:keypressed('right') then
        -- 	print("pressed right from inside draw")
        -- end
    end

    function menu:enter(previous)
    	print('menu:enter')
    	scorecount = 0
    	love.graphics.draw(buttonSelected, 100, 600)
	    love.graphics.print("Start", 185, 610, 0, 0.5, 0.5)
    	-- highlight play button
    	--love.graphics.draw()
    end

    function menu:update(dt)
    	
    end

    function menu:leave()
    	print('menu:leave')
    end
    
    function menu:keyreleased(key)
    	if key == "right" then
    	 	selectedState = (selectedState + 1) % 3
	 	elseif key == "left" then 
	 		selectedState = (selectedState - 1) % 3
    	end

    	if key == "return" then
    		if selectedState == 0 then
    			Gamestate.switch(game)
			elseif selectedState == 1 then
				Gamestate.switch(gameover) -- Change to scoreboard when it's ready
			elseif selectedState == 2 then
				love.event.quit()
			end
    	end
    end

return menu