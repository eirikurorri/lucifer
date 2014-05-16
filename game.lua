local game = {}
	
	function game:init()
		print('game:init')
		map = loader.load("derpmap.tmx")
		map:setDrawRange(0,0,960,41600)
	    map.offsetX = 120
	    map("top").visible = false --true

	   -- uncomment below to show collision polygons
	   -- map("top").color = {255,0,0}
	   -- map("side").color = {0,255,0}
	   -- map("bottom").color = {0,0,255}
	   -- end display collision polygons

	    map("ledge").visible = false
	    map("sides").visible = false
	    map("top").visible = false
	    map("side").visible = false
	    map("bottom").visible = false
	    -- map("object").visible = false -- makes object map invisible

	    camY = 0
	    cam = Camera(0,0)
	    cam:cameraCoords(0,0)
		-- Collider stuff
	    scorecount = 0
		
	    
		--collider = HC(100, on_collide)
	    ourHero.setupHero(400,-300, collider)
	    -- print("wat")
	    soulTiles = ourHero.findSoulObjects(map)
	    toptiles = ourHero.findToptiles(map)
	    sidetiles = ourHero.findSide(map)
	    bottomtiles = ourHero.findbottomTiles(map)
	    -- set up the hero object, set him to position 32, 32
	end

	function game:enter()
		print("game:enter")
		
	    reached_bottom = false
	    slowdown = false
	    swipeaction = false
		-- background
	    --background.loadBackground()
	    foreground.loadForeground()
	    --distance monitor and goal
	    distanceGoal = 41600
	    distance = 0

	    -- speedometer, use for different speeds
		speed = 200

		--collider
		ourHero.moveTo(400, -300)

		maxspeed = 800

		herospeed = 0
		speedmargin = 0.1
		cameraoffset = 700
		slowdown = false
		local slowdowntimer
		slowdowninterval = 0
		slowdowninitiate = false
		slowdownstart = 0
		slowdownend = 0
		slowdistance = 0
		swipeaction = false
		soundtimer = 0	
		stage = 1
	end

	function game:leave()
		print('game:leave')
	end

	function game:draw()
        if stage < 3 then
            if reached_bottom == false then
                if distance < distanceGoal/2 then
                    if speed < maxspeed then
                        speed = speed + 0.2
                    end
                else
                    if speed > 200 then
                        speed = speed - 0.2
                    end
                end
            else
                if distance > distanceGoal/2 then
                    if speed < maxspeed then
                        speed = speed + 0.2
                    end
                else
                    if speed > 200 then
                        speed = speed - 0.2
                    end
                end
            end
        else
            if speed < maxspeed then
                speed = speed + 0.4
            end
            if distance >= distanceGoal/2 then
                speed = 0    
            end           
        end
        --love.graphics.setColor(140,17,37)
        love.graphics.print("Cam pos y: ".. math.floor(cam.y),1050,200,0,0.25,0.25)
        love.graphics.print("Speed: "..math.floor(speed),1050,180,0,0.25,0.25)
        love.graphics.print("Slowdown Speed: "..math.floor(slowdownstart),1000,80,0,0.25,0.25)
        love.graphics.print("Slowdownend speed: "..math.floor(slowdownend),1000,100,0,0.25,0.25)
        love.graphics.print(math.floor(distance),1050,220,0,0.25,0.25)
        -- FPS meter and memory counter
        love.graphics.print("FPS: "..love.timer.getFPS() .. '\nMem(kB): ' .. math.floor(collectgarbage("count")), 1050, 140,0,0.25,0.25)
        
	    cam:draw(drawCamera)

	    if ourHero.heroycoords() >= distanceGoal - 100 then
            if reached_bottom == false then
                stage = stage + 1
            end
            reached_bottom = true
            
            --print(stage)
        elseif ourHero.heroycoords() <= 100 then
            if reached_bottom == true then
                stage = stage + 1
            end
            reached_bottom = false
            
            --print(stage)
        end

        if ourHero.heroycoords() <= distanceGoal/2 then
        	TEsound.volume("hellfire", ourHero.heroycoords()/(distanceGoal/2))
        else
        	reversedY = distanceGoal - ourHero.heroycoords()
        	TEsound.volume("hellfire", reversedY/(distanceGoal/2))
        end
        
        -- print(fireVolume)
	end

	function game:update(dt)

	   	TEsound.cleanup()
	    soundtimer = soundtimer + dt

	    if love.keyboard.isDown("a") and swipeaction == false then
	        swipeaction = true
	        swipe = ourHero.initSwipe(ourHero.heroxcoords()-50,ourHero.heroycoords())
	        elapsedtime = 0
	        TEsound.play(pitchFork)
	    elseif swipeaction == true then
	        elapsedtime = elapsedtime + dt
	        if elapsedtime >= 0.5 then   
	            ourHero.removeswipeobject()
	        end
	        if elapsedtime >= 1 then
	            swipeaction = false
	        end
	    end
	    if love.keyboard.isDown("d") and swipeaction == false then
	        swipeaction = true
	        swipe = ourHero.initSwipe(ourHero.heroxcoords()+50,ourHero.heroycoords())
	        elapsedtime = 0
	        TEsound.play(pitchFork)
	    elseif swipeaction == true then
	        elapsedtime = elapsedtime + dt
	        if elapsedtime >= 0.5 then
	            ourHero.removeswipeobject()
	        end
	        if elapsedtime >= 1 then
	            swipeaction = false
	        end
	    end

	    if love.keyboard.isDown("s") and slowdowninitiate == false then
	        slowdownstart = 0
	        slowdown = true
	        slowdowninitiate = true
	        slowdownstart = speed
	        TEsound.play(chute)
	        slowdowntimer = 0
	        slowdowninterval = 0
	    elseif slowdown == true then
	        slowdownend = speed
	        slowdowntimer = slowdowntimer + dt
	        slowdowninterval = slowdowninterval + dt
	        slowdownstart = slowdownstart * 0.99
	        ourHero.updateHero(dt,cam,slowdownstart,reached_bottom,distanceGoal,cameraoffset,slowdown,slowdistance,swipeaction,swipe,elapsedtime,herospeed,stage)
	        if slowdowntimer >= 1.5 then
	            slowdown = false
	        end
	    elseif slowdowninitiate == true then
	         slowdowninterval = slowdowninterval + dt 
	         slowdownend = speed
	         if slowdownstart <= slowdownend then
	            slowdownstart = slowdownstart * 1.01
	            ourHero.updateHero(dt,cam,slowdownstart,reached_bottom,distanceGoal,cameraoffset,slowdown,slowdistance,swipeaction,swipe,elapsedtime,herospeed,stage)
	         else
	            ourHero.updateHero(dt,cam,slowdownstart,reached_bottom,distanceGoal,cameraoffset,slowdown,slowdistance,swipeaction,swipe,elapsedtime,herospeed,stage)
	         end
	         if slowdowninterval >= 5 then
	            slowdowninitiate = false
	            slowdowninterval = 0
	        end
	    else
	        ourHero.updateHero(dt,cam,speed,reached_bottom,distanceGoal,cameraoffset,slowdown,slowdistance,swipeaction,swipe,elapsedtime,herospeed,stage)
	    end 
	    herospeed = ourHero.handleInput(dt,herospeed,speedmargin)
	    collider:update(dt)

	    if reached_bottom == false then
	        distance = ourHero.heroycoords()
	    else
	        distance = ourHero.heroycoords()
	    end 
	end

return game