local fg = {}

function fg.loadForeground()
	fg[1] = love.graphics.newImage('gfx/map0.png')
	fg[2] = love.graphics.newImage('gfx/map1.png')
	fg[3] = love.graphics.newImage('gfx/map2.png')
	fg[4] = love.graphics.newImage('gfx/map3.png')
	fg[5] = love.graphics.newImage('gfx/map4.png')
	fg[6] = love.graphics.newImage('gfx/map5.png')
	fg[7] = love.graphics.newImage('gfx/map6.png')
	fg[8] = love.graphics.newImage('gfx/map7.png')
	fg[9]= love.graphics.newImage('gfx/map8.png')
	fg[10]= love.graphics.newImage('gfx/map9.png')
	fg[11] = love.graphics.newImage('gfx/map10.png')
	fg[12] = love.graphics.newImage('gfx/map11.png')
	fg[13] = love.graphics.newImage('gfx/map12.png')
	fg[14] = love.graphics.newImage('gfx/map13.png')
	fg[15] = love.graphics.newImage('gfx/map14.png')
	fg[16] = love.graphics.newImage('gfx/map15.png')

	fgImageHeight = 2600
	fgXoffset = -fgImageHeight
	fgScalingFactor = 1 -- was 2.2429906542
end

function fg.drawForeground(turningPoint)
	i = 1
	for i=1,16,1 do
		love.graphics.draw(fg[i], -120, i*fgImageHeight+fgXoffset, 0, fgScalingFactor)
		-- print(i)
	end
end

return fg