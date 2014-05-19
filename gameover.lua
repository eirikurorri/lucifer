local gameover = {}
	local hasPostedScore = false
    local http = require "socket.http"
    local ltn12 = require "ltn12"
    local scores = {}
    local names = {}
    local linespacing = 60
    local offsetX = 120
    local buffer = 0
    local bufferSize = 10
    local enterYourName
    local floodGateOpen = false
    local online


    local nameText = ""

	local gameoverImage

	function gameover:init()
		--gameoverImage = love.graphics.newImage('gfx/skulls-red-black-bonesq.jpeg')
        gameoverImage = love.graphics.newImage('gfx/scorescreen.jpg')
        dialog = love.graphics.newImage('gfx/namedialog.jpg')
        
        speed = 0
        scorecount = 3
		print('game over.init')
	end

    function gameover:enter(previous)
        print('gameover:enter')
        hasPostedScore = false
        
        local result, status = http.request("http://arnarth.pythonanywhere.com/load/lucifer")

        if status == 200 then
            online = true
            --Gamestate.switch(offline)
            local scorestring = string.gmatch(result,'"score":%s"(%d+)"')
            print(scorestring)
            local namestring = string.gmatch(result,'"name":%s"([%a,%s]+)"')
            print(namestring)
            for name in namestring do
                table.insert(names, name)
                print("entering, name: ", name)
            end
            for score in scorestring do
                table.insert(scores, score)
                if scorecount > tonumber(score) then
                    enterYourName = true -- go to enter your name dialog
                else
                    enterYourName = false -- go to view highscores
                    floodGateOpen = true -- allow one-time downloading of the higscores from server
                end
                print("entering, score: ", score)
            end
        else
            online = false
            for score, name in highscore() do
                if scorecount > score then
                    enterYourName = true -- go to enter your name dialog
                else
                    enterYourName = false -- go to view highscores
                    floodGateOpen = true -- allow one-time downloading of the higscores from server
                end
            end
            print("entering offline, score: ", score)
        end
    end

    function gameover:leave()
        print('gameover:leave')
        --highscore.save()
    end
    
	function gameover:draw()
	    love.graphics.draw(gameoverImage, offsetX, 0)

        if enterYourName == true then
            love.graphics.draw(dialog, offsetX, 0)
            love.graphics.printf(scorecount, offsetX+475, 330, bufferSize, "center", 0, 0.5)
            love.graphics.printf(nameText, offsetX+475, 500, bufferSize, "center", 0, 0.5)
        else
            love.graphics.setColor(140,17,37)
        

            -- love.graphics.print("Press Enter to restart", 400,400,0,0.5,0.5)
            -- love.graphics.print("Press Esc for Main Menu", 400,550,0,0.5,0.5)
            --if floodGateOpen == true then
            if online == true then
               for i, name in ipairs(names) do
                   love.graphics.print(name, offsetX+150, i*linespacing+300, 0, 0.3)
                   --print("hi! ")

               end
               for i, score in ipairs(scores) do
                   love.graphics.print(score, offsetX+450, i*linespacing+300, 0, 0.3)
               end
            else
                for i, score, name in highscore() do
                   love.graphics.print(name, offsetX+150, i*linespacing+300, 0, 0.3)
                   love.graphics.print(score, offsetX+450, i*linespacing+300, 0, 0.3)
                end
            end
        end
        love.graphics.setColor(255,255,255)
    end

    function gameover:update(dt)
        
        if hasPostedScore == true and floodGateOpen == true then
        --arnarth.pythonanywhere.com/save/
            if online == true then
                print("We have posted a score and are entering update function with scorecount ", scorecount)
                --local respbody = {} -- for the response body
                --local result = http.request("http://arnarth.pythonanywhere.com/save/"..name.."/"..scorecount.."/".."lucifer")
                local result = http.request("http://arnarth.pythonanywhere.com/load/lucifer")

                for i=1, #names do 
                    names[i] = nil
                end

                for i=1, #scores do 
                    scores[i] = nil
                end
                
                local scorestring = string.gmatch(result,'"score":%s"(%d+)"')
                local namestring = string.gmatch(result,'"name":%s"([%a,%s]+)"')
                for name in namestring do
                    table.insert(names, name)
                    print(name)
                end
                for score in scorestring do
                    table.insert(scores, score)
                    print(score)
                end

                floodGateOpen = false
                --hasPostedScore = false
            else
                print("sorry, not online")
            end
        elseif enterYourName == true then
            enabled = love.keyboard.hasTextInput( )
            --print(enabled)    
            love.keyboard.setTextInput(true)
        end
    end


    function gameover:keyreleased(key)
    	
        if enterYourName == true then

            if key == "backspace" then
                nameText = nameText:utf8sub(1,-2)
                if buffer >= 1 then
                    buffer = buffer - 1
                end
            elseif key == "return" then
                if online == true then
                    print("saving score to server...") -- 2147483647 is a popular score to post
                    r, c, h = http.request("http://arnarth.pythonanywhere.com/save/"..nameText.."/"..scorecount.."/".."lucifer")
                    print("text: ", nameText, "scorecount: ", scorecount)
                    print("r: ", r, "c: ", c, "h: ", h)
                else
                    print("entering hardcoded offline score")
                    highscore.add("Mimmie", 7)
                    highscore.save()
                end
                love.keyboard.setTextInput(false)
                enterYourName = false
                hasPostedScore = true
                floodGateOpen = true
            -- else
            --     if buffer <= bufferSize then
            --         text = text .. key
            --         buffer = buffer + 1
            --     end
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
    --print(scorecount)
    end

    function love.textinput(t)
        
        --if buffer <= bufferSize then
            nameText = nameText .. t
            --buffer = buffer + 1
        --end
        
    end

return gameover