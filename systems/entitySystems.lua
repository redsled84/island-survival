local entitySystems = {}

entitySystems.new = function(rigid, body, dirs, name,
    position, speed, velocity)
  return {
    rigid = rigid,
    body = body,
    dirs = dirs,
    name = name,
    position = position,
    speed = speed,
    velocity = velocity,
  }
end

entitySystems.updateVelocity = System(
  {"dirs", "speed", "velocity"},
  function (dirs, speed, vel, dt)
    vel.x = speed * dirs.x * dt
    vel.y = speed * dirs.y * dt
  end
)

entitySystems.updateDirections = System(
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

entitySystems.rotateBody = System(
  {"body", "name"},
  function(body, name, dt)
    if name == "player" then
      body:rotate(dt)
    elseif name == "monster" then
      body:rotate(-dt)
    end
  end
)

entitySystems.handleCollisions = System(
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

entitySystems.updatePosition = System(
  {"body", "velocity"},
  function(body, vel)
    body:move(vel.x, vel.y)
  end
)

entitySystems.drawEntity = System(
  {"body", "name"},
  function (body, name)
    if name == "_" then return end
    if name == "player" then
      love.graphics.setColor(.8, .45, .1)
    elseif name == "monster" then
      love.graphics.setColor(.03, .75, .4)
    end
    body:draw("fill")
  end
)

return entitySystems