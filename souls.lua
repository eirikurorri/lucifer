local souls = {}

soulImg = love.graphics.newImage('gfx/soul2.png')

function souls.drawSouls(tiles)
	for i, j in pairs(tiles) do
        print(i, " ", j)
        print("-----")
        for k, l in pairs(j) do
        	print("**** ", k, " ", l)
        end
    end
    -- for soul in soulArray do
    --     if soul.visible == true then
    --         love.graphics.draw(soulImg, soul.x, soul.y)
    --     end
    -- end
end

return souls