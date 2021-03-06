local gameoveroffline = {}
    local hasPostedScore = false
    
    local scores = {}
    local names = {}
    local linespacing = 60
    local offsetX = 120
    local buffer = 0
    local bufferSize = 10
    local enterYourName
    local floodGateOpen = false


    local text = ""

	local gameoverImage

	function gameoveroffline:init()
		print("offline:init")
        gameoverImage = love.graphics.newImage('gfx/scorescreen.jpg')
        dialog = love.graphics.newImage('gfx/namedialog.jpg')
        
        speed = 0

	end

    function gameoveroffline:enter()
        print('offline:enter')
        hasPostedScore = false
       
        for score, name in highscore() do
            if scorecount > score then
                enterYourName = true -- go to enter your name dialog
            else
                enterYourName = false -- go to view highscores
                floodGateOpen = true -- allow one-time downloading of the higscores from server
            end
            print("entering, score: ", score)
        end
       print('end of offline:enter')
    end

    function gameoveroffline:leave()
        print('offline:leave')
    end
    
	function gameoveroffline:draw()
        print("offline:draw")
	    love.graphics.draw(gameoverImage, offsetX, 0)
        if enterYourName == true then
            love.graphics.draw(dialog, offsetX, 0)
            love.graphics.printf(scorecount, offsetX+475, 330, bufferSize, "center", 0, 0.5)
            love.graphics.printf(text, offsetX+475, 500, bufferSize, "center", 0, 0.5)
            
        else
        love.graphics.setColor(140,17,37)

        love.graphics.setColor(255,255,255)
    end

    function gameoveroffline:update(dt)
            print("offline:update")
            if hasPostedScore == true and floodGateOpen == true then
            --arnarth.pythonanywhere.com/save/

            print("We have posted a score and are entering update function with scorecount ", scorecount)


            floodGateOpen = false
            elseif enterYourName == true then
                enabled = love.keyboard.hasTextInput( )
                --print(enabled)    
                love.keyboard.setTextInput(true)
            end
        end
    
    end


    function gameoveroffline:keyreleased(key)
    	
        if enterYourName == true then
            if key == "backspace" then
                text = text:utf8sub(1,-2)
                if buffer >= 1 then
                    buffer = buffer - 1
                end
            elseif key == "return" then
                print("saving score to file...") -- 2147483647 is a popular score to post
                highscore.add(text, scorecount)
                love.keyboard.setTextInput(false)
                enterYourName = false
                hasPostedScore = true
                floodGateOpen = true
            end
        else
            if key == "return" then
        		print("pressed enter from gameover state")
        		Gamestate.switch(game)
        	end
            if key == "escape" then
                Gamestate.switch(menu)
            end
        end
    end

    function love.textinput(t)
        if buffer <= bufferSize then
            text = text .. t
            buffer = buffer + 1
        end
        print(text)
    end

return gameoveroffline
