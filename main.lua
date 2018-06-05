require "util"
local inspect = require "inspect"

HC = require "HC"
System = require "knife.system"
local entitySystems = require "systems.entitySystems"
local roomSystems = require "systems.roomSystems"
local viewportSystem = require "systems.viewportSystem"

-- rigid, body, dirs, name, spawnPosition, speed, velocity
local entities = {
  entitySystems.new(false, HC.circle(0, 0, 16), v2(0, 0), "player", v2(30, 300), 150, v2(0, 0)),
  entitySystems.new(false, HC.rectangle(0, 0, 32, 32), v2(0, 0), "monster", v2(100, 450), 50, v2(0, 0)),
  entitySystems.new(false, HC.rectangle(0, 0, 413, 45), v2(0, 0), "_", v2(413/2, 185 + 22), 0, v2(0, 0))
}

local rooms = {
  roomSystems.new(v2(0, 0), "jungleEntrance", love.graphics.newImage("images/jungleEntrance.png"))
}

local viewport = viewportSystem.new(rooms[1].position.x, rooms[1].position.y,
  rooms[1].sprite:getWidth(), rooms[1].sprite:getHeight())

function love.load()
  love.graphics.setBackgroundColor(.8, .8, .8)
  for i = 1, #entities do
    local entity = entities[i]
    entity.body:moveTo(entity.position.x, entity.position.y)
  end
end

function love.update(dt)
  -- print(viewport.cam.x, viewport.cam.y)
  local px, py = entities[1].body:center()
  viewportSystem.bindCamera(viewport, v2(px, py))
  -- print(love.mouse.getX(), love.mouse.getY())
  for ei, entity in ipairs(entities) do
    entitySystems.updateDirections(entity)
    entitySystems.updateVelocity(entity, dt)
    entitySystems.updatePosition(entity)
    entitySystems.handleCollisions(entity, ei, entities)
  end
end

function love.draw()
  viewport.cam:attach()

  for _, room in ipairs(rooms) do
    roomSystems.drawRooms(room)
  end

  for _, entity in ipairs(entities) do
    entitySystems.drawEntity(entity)
  end

  viewport.cam:detach()
end
