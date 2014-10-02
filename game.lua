local game = {}
	
	function game:init()
		print('game:init')


	    camY = 0
	    cam = Camera(0,0)
	    cam:cameraCoords(0,0)

		foreground.loadForeground()	    
	    
	    south = love.graphics.newImage('gfx/lucifer_spritesheet.png')
	    north = love.graphics.newImage('gfx/lucifer_spritesheet_north.png')
	    
	    local grid = anim8.newGrid(354, 454, south:getWidth(), south:getHeight())

	    animations = {

	    	-- left and right refers to the gamer's perspective

	  		northBoundForkL = anim8.newAnimation(grid(4,1, 1,2, 2,2), 0.1),
	  		northBoundForkR = anim8.newAnimation(grid(1,1, 2,1, 3,1), 0.1),
	  		northBoundSwipeL = anim8.newAnimation(grid(2,3, 3,3, 4,3), 0.1),
	  		northBoundSwipeR = anim8.newAnimation(grid(3,2, 4,2, 1,3), 0.1),
	  		northBoundCape = anim8.newAnimation(grid(1,4, 2,4, 3,4, 4,4, 1,5, 4,4, 3,4, 4,4, 1,5, 4,4, 3,4, 4,4, 1,5, 4,4, 3,4, 4,4, 1,5, 4,4, 3,4, 4,4, 1,5, 4,4, 3,4, 4,4, 1,5, 4,4, 3,4, 4,4, 1,5, 4,4, 3,4, 4,4, 1,5, 4,4, 3,4), 0.1),
	  		--northBoundCapeHold = anim8.newAnimation(grid(3,4, 4,4, 1,5), 0.1),

	  		southBoundForkL = anim8.newAnimation(grid(4,5, 2,4, 1,4), 0.1),
	  		southBoundForkR = anim8.newAnimation(grid(1,5, 2,5, 3,5), 0.1),
	  		southBoundSwipeL = anim8.newAnimation(grid(2,3, 3,3, 4,3), 0.1),
	  		southBoundSwipeR = anim8.newAnimation(grid(3,4, 4,4, 1,3), 0.1),
	  		southBoundCape = anim8.newAnimation(grid(1,2, 2,2, 3,2, 4,2, 1,1, 4,2, 3,2, 4,2, 1,1, 4,2, 3,2, 4,2, 1,1, 4,2, 3,2, 4,2, 1,1, 4,2, 3,2, 4,2, 1,1, 4,2, 3,2, 4,2, 1,1, 4,2, 3,2, 4,2, 1,1, 4,2, 3,2, 4,2, 1,1, 4,2, 3,2), 0.1)
	  		--southBoundCapeHold = anim8.newAnimation(grid(3,2, 4,2, 1,1), 0.1)

		}

		

	end

	function game:enter()
		print("game:enter")

		map = loader.load("derpmap.tmx")
		map:setDrawRange(0,0,960,41600)
	    map.offsetX = 120
	    

	   -- uncomment below to show collision polygons
	   -- map("top").color = {255,0,0}
	   -- map("side").color = {0,255,0}
	   -- map("bottom").color = {0,0,255}
           -- you can stop uncommenting now
	   -- end display collision polygons

		map("top").visible = false
	    map("ledge").visible = false
	    map("sides").visible = false
	    map("top").visible = false
	    map("side").visible = false
	    map("bottom").visible = false

            collider = HC(100, on_collide)
            -- Collider stuff	
	    ourHero.setupHero(400,-300, collider)

	    
	    toptiles = ourHero.findToptiles(map)
	    sidetiles = ourHero.findSide(map)
	    bottomtiles = ourHero.findbottomTiles(map)
	    
	   	
	    --ourHero.reloadSoulObjects(map)
		soulTiles = ourHero.findSoulObjects(map)

		--map("souls").visible = true

		animation = animations.southBoundForkL
	    reached_bottom = false
	    slowdown = false
	    swipeaction = false
	    swipeToTheLeft = true
            -- background
	    --background.loadBackground()
	    

	    --distance monitor and goal
	    distanceGoal = 41600
	    distance = 0
	    scorecount = 0

	    -- speedometer, use for different speeds
		speed = 200

		--collider reset
		ourHero.moveTo(400, 0)

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
		--collider = nil
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
                Gamestate.switch(gameover)  
            end           
        end
        

	    cam:draw(drawCamera)


	    if ourHero.heroycoords() >= distanceGoal - 100 then
            if reached_bottom == false then
                stage = stage + 1
            end
            reached_bottom = true
            
        elseif ourHero.heroycoords() <= 100 then
            if reached_bottom == true then
                stage = stage + 1
            end
            reached_bottom = false

            
        end

        if ourHero.heroycoords() <= distanceGoal/2 then
        	TEsound.volume("hellfire", ourHero.heroycoords()/(distanceGoal/2))
        else
        	reversedY = distanceGoal - ourHero.heroycoords()
        	TEsound.volume("hellfire", reversedY/(distanceGoal/2))
        end
        map:draw()
	end

	function game:update(dt)

		animation:update(dt)

	   	TEsound.cleanup()
	    soundtimer = soundtimer + dt

	    if love.keyboard.isDown("a") and swipeaction == false then
	        swipeaction = true
	        swipeToTheLeft = true
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
	        swipeToTheLeft = false
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
