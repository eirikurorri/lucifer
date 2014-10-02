local souls = {}

soulImg = love.graphics.newImage('gfx/soul2.png')

function souls.drawSouls(map)

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
end

return souls
