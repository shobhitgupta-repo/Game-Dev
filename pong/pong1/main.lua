WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push'


function love.load()
  love.graphics.setDefaultFilter('nearest','nearest')
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = false
  })
end


function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end


function love.draw()
  push:apply('start')

  love.graphics.printf("Hello pong!",0,VIRTUAL_HEIGHT/2 -6,VIRTUAL_WIDTH, 'center')

  push:apply('end')
end
