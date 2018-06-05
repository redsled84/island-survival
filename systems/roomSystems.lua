local roomSystems = {}

roomSystems.new = function(position, name, sprite, staticEntities)
	return {
		position = position,
		name = name,
		sprite = sprite,
		staticEntities = staticEntities
	}
end

roomSystems.drawRooms = System(
	{"position", "sprite"},
	function(position, sprite)
		love.graphics.setColor(1, 1, 1)
		love.graphics.draw(sprite, position.x, position.y)
	end
)

return roomSystems
