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
	fg[17] = love.graphics.newImage('gfx/map16.png')
	fg[18] = love.graphics.newImage('gfx/map17.png')
	fg[19] = love.graphics.newImage('gfx/map18.png')
	fg[20] = love.graphics.newImage('gfx/map19.png')
	fg[21] = love.graphics.newImage('gfx/map20.png')
	fg[22] = love.graphics.newImage('gfx/map21.png')
	fg[23] = love.graphics.newImage('gfx/map22.png')
	fg[24] = love.graphics.newImage('gfx/map23.png')
	-- fg[25] = love.graphics.newImage('gfx/map24.png')
	-- fg[26] = love.graphics.newImage('gfx/map25.png')
	-- fg[27] = love.graphics.newImage('gfx/map26.png')
	-- fg[28] = love.graphics.newImage('gfx/map27.png')
	fgXoffset = -700
	fgImageHeight = 700
	fgScalingFactor = 2.2429906542
end

function fg.drawForeground(turningPoint)
	i = 1
	for i=1,24,1 do
		love.graphics.draw(fg[i], -120, i*fgImageHeight+fgXoffset, 0, fgScalingFactor)
	end
end

return fg