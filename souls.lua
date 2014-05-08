local souls = {}

soulImg = love.graphics.newImage('gfx/soul2.png')

function souls.drawSouls(map)

	--print(map.layers["souls"]["objects"])
	for i, j in pairs(map.layers["souls"]["objects"]) do
		print ("----")
		for k, l in pairs(j) do
			print ("    ****")
			print(k, " ", j)
			for m, n in pairs(l) do
				print("        %%%%")
				print(m, " ", n)
			end
		end
	end
	-- for i, j in pairs(tiles) do
 --        print(i, " ", j)
 --        print("-----")
 --        for k, l in pairs(j) do
 --        	print("**** ", k, " ", l)
 --        end
 --    end
    -- for soul in soulArray do
    --     if soul.visible == true then
    --         love.graphics.draw(soulImg, soul.x, soul.y)
    --     end
    -- end
end

return souls