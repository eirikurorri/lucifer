local fg = {}

function fg.loadForeground()
	fg[1] = love.graphics.newImage('gfx/ledges/map0.jpg')
	fg[2] = love.graphics.newImage('gfx/ledges/map1.jpg')
	fg[3] = love.graphics.newImage('gfx/ledges/map2.jpg')
	fg[4] = love.graphics.newImage('gfx/ledges/map3.jpg')
	fg[5] = love.graphics.newImage('gfx/ledges/map4.jpg')
	fg[6] = love.graphics.newImage('gfx/ledges/map5.jpg')
	fg[7] = love.graphics.newImage('gfx/ledges/map6.jpg')
	fg[8] = love.graphics.newImage('gfx/ledges/map7.jpg')
	fg[9] = love.graphics.newImage('gfx/ledges/map8.jpg')
	fg[10] = love.graphics.newImage('gfx/ledges/map9.jpg')
	fg[11] = love.graphics.newImage('gfx/ledges/map10.jpg')
	fg[12] = love.graphics.newImage('gfx/ledges/map11.jpg')
	fg[13] = love.graphics.newImage('gfx/ledges/map12.jpg')
	fg[14] = love.graphics.newImage('gfx/ledges/map13.jpg')
	fg[15] = love.graphics.newImage('gfx/ledges/map14.jpg')
	fg[16] = love.graphics.newImage('gfx/ledges/map15.jpg')

	fgImageHeight = 2600
	fgXoffset = -fgImageHeight
	fgScalingFactor = 1
end

function fg.drawForeground()
	i = 1
	for i=1,16,1 do
		love.graphics.draw(fg[i], -120, i*fgImageHeight+fgXoffset, 0, fgScalingFactor)
	end
end

return fg