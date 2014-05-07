
local menuitem = {}
local menuimage

function menuitem.loadmenu()
	menuimage = love.graphics.newImage('gfx/satanmenu.jpg')
	love.graphics.draw(menuimage, 0, 0)
    love.graphics.print("Press Enter to begin", 400,400)
end

return menuitem