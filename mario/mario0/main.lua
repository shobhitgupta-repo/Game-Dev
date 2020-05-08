Class = require('class')
push = require('push')
require('Util')
require('Map')

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243


function love.load()
  math.randomseed(os.time())
  map = Map()
  love.graphics.setDefaultFilter('nearest','nearest')
  love.graphics.setFont(love.graphics.newFont('fonts/font.ttf',8))
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })
  love.window.setTitle('Super Mario 50')
  love.keyboard.keysPressed = {}
  love.keyboard.keysReleased = {}
end

function love.resize(w,h)
  push:resize(w,h)
end

function love.keyboard.wasPressed(key)
  if  (love.keyboard.keysPressed[key]) then
    return true
  else
    return false
  end
end

function love.keyboard.wasReleased(key)
    if (love.keyboard.keysReleased[key]) then
        return true
    else
        return false
    end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
  love.keyboard.keysPressed[key] = true
end

function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end

function love.update(dt)
  map:update(dt)
  love.keyboard.keysPressed = {}
  love.keyboard.keysReleased = {}
end

function love.draw()
  push:apply('start')
  love.graphics.clear(108/255,140/255,1,1)
  love.graphics.translate(math.floor(-map.camX), math.floor(-map.camY))
  map:render()
  push:apply('end')
end
