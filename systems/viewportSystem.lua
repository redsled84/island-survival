local camera = require "camera"
local viewportSystem = {}

viewportSystem.new = function(x1, y1, x2, y2)
	return {
		cam = camera(x1, y1),
		x1 = x1,
		y1 = y1,
		x2 = x2,
		y2 = y2,
	}
end

viewportSystem.bindCamera = System(
	{"cam", "x1", "y1", "x2", "y2"},
	function(cam, x1, y1, x2, y2, target)
		-- need to improve on binding the camera to a room
		-- local x, y = cam.x, cam.y
		-- local xOffset = cam.scale * love.graphics.getWidth() / 2
		-- local yOffset = cam.scale * love.graphics.getHeight() / 2
		-- local out = x - xOffset < x1 or x + xOffset > x2
		-- 	or y - yOffset < y1 or y + yOffset > y2
		-- if out then
		-- 	if x - xOffset < x1 then
		-- 		cam:move(x1 - x + xOffset, 0)
		-- 	end
		-- 	if x + xOffset > x2 then
		-- 		cam:move(x - x2 - xOffset, 0)
		-- 	end
		-- 	if y - yOffset < y1 then
		-- 		cam:move(0, y1 - y + yOffset)
		-- 	end
		-- 	if y + yOffset > y2 then
		-- 		cam:move(0, y - y2 - yOffset)
		-- 	end
		-- 	return
		-- end
		cam:lookAt(target.x, target.y)
	end
)

return viewportSystem