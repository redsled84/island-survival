local inspect = require "inspect"
local System = require "knife.system"
local HC = require "HC"

local function v2(x, y)
  return {x = x, y = y}
end

local updateVelocity = System(
  {"dirs", "speed", "velocity"},
  function (dirs, speed, vel, dt)
    vel.x = speed * dirs.x * dt
    vel.y = speed * dirs.y * dt
  end
)

local updateDirections = System(
  {"dirs", "name"},
  function (dirs, name) 
    if name ~= "player" then return end
    if love.keyboard.isDown("d") then
      dirs.x = 1
    elseif love.keyboard.isDown("a") then
      dirs.x = -1
    else
      dirs.x = 0
    end
    if love.keyboard.isDown("s") then
      dirs.y = 1
    elseif love.keyboard.isDown("w") then
      dirs.y = -1
    else
      dirs.y = 0
    end
  end
)

local rotateBody = System(
  {"body", "name"},
  function(body, name, dt)
    if name == "player" then
      body:rotate(dt)
    elseif name == "monster" then
      body:rotate(-dt)
    end
  end
)

local handleCollisions = System(
  {"body", "name"},
  function(body, name, i, entities)
    for j = 1, #entities do
      if j ~= i then
        local checkBody = entities[j].body
        local collides, dx, dy = body:collidesWith(checkBody)
        if collides and name == "player" then
          body:move(dx, dy)
        end
      end
    end
  end
)

local updatePosition = System(
  {"body", "velocity"},
  function(body, vel)
    body:move(vel.x, vel.y)
  end
)

local drawEntity = System(
  {"body", "name"},
  function (body, name)
    if name == "player" then
      love.graphics.setColor(230, 145, 20)
    elseif name == "monster" then
      love.graphics.setColor(35, 203, 113)
    end
    body:draw("line")
  end
)

-- dirs, name, position, speed, velocity
local entities = {
  {
    rigid = false,
    body = HC.circle(0, 0, 16),
    dirs = v2(0, 0),
    name = "player",
    spawnPosition = v2(30, 30),
    speed = 150,
    velocity = v2(0, 0),
  },
  {
    rigid = false,
    body = HC.rectangle(0, 0, 32, 32),
    dirs = v2(0, 0),
    name = "monster",
    spawnPosition = v2(100, 450),
    speed = 50,
    velocity = v2(0, 0),
  },
}


local hunger = 100

function love.load()
  love.graphics.setBackgroundColor(245, 235, 240)
  for i = 1, #entities do
    local entity = entities[i]
    entity.body:moveTo(entity.spawnPosition.x, entity.spawnPosition.y)
  end
end

function love.update(dt)
  -- if hunger > 0 then
    hunger = hunger - dt * 50
  -- end

  for ei, entity in ipairs(entities) do
    updateDirections(entity)
    updateVelocity(entity, dt)
    updatePosition(entity)
    handleCollisions(entity, ei, entities)
  end
end

function love.draw()
  for _, entity in ipairs(entities) do
    drawEntity(entity)
  end

  love.graphics.setColor(245, 0, 0)
  local width = hunger / 100
  love.graphics.rectangle("fill", 50, love.graphics.getHeight()-40, width * 100, 30)
end
