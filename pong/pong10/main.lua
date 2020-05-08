WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

Class = require('class')
push = require('push')

require('Ball')
require('Paddle')


function love.load()
  math.randomseed(os.time())
  love.graphics.setDefaultFilter('nearest','nearest')
  love.window.setTitle('Pong')
  smallFont = love.graphics.newFont('font.ttf', 8)
  scoreFont = love.graphics.newFont('font.ttf', 32)
  victoryFont = love.graphics.newFont('font.ttf',24)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = false
  })

  player1Score = 0
  player2Score = 0
  servingPlayer = math.random(2) == 1 and 1 or 2
  winningPlayer = 0
  ball = Ball(VIRTUAL_WIDTH/2-2,VIRTUAL_HEIGHT/2-2,5,5)
  if  servingPlayer == 1 then
    ball.dx = 100
  else
    ball.dx = -100
  end
  player1 = Paddle(5,20,5,20)
  player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30,5,20)
  gameState = 'start'

end

function love.update(dt)

  if gameState == 'play' then

    if ball.x <= 0 then
      player2Score = player2Score + 1
      servingPlayer = 1
      ball:reset()
      ball.dx = 100
      if player2Score >= 10 then
        gameState = 'victory'
        winningPlayer = 2
      else
        gameState = 'serve'
      end
    end

    if ball.x >= VIRTUAL_WIDTH - 5 then
      player1Score = player1Score + 1
      servingPlayer = 2
      ball:reset()
      ball.dx = -100
      if player1Score >= 10 then
        gameState = 'victory'
        winningPlayer = 1
      else
        gameState = 'serve'
      end
    end

    if ball.y <=0 then
      ball.dy = -ball.dy
      ball.y = 0
    end

    if ball.y >= VIRTUAL_HEIGHT - 5  then
      ball.dy = -ball.dy
      ball.y =  VIRTUAL_HEIGHT - 5
    end

    if ball:collides(player1) then
      ball.dx = -ball.dx
    end

    if ball:collides(player2) then
      ball.dx = -ball.dx
    end

    if love.keyboard.isDown('w') then
      player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
      player1.dy = PADDLE_SPEED
    else
      player1.dy = 0
    end

    if love.keyboard.isDown('up') then
      player2.dy = -PADDLE_SPEED
    elseif  love.keyboard.isDown('down') then
      player2.dy = PADDLE_SPEED
    else
      player2.dy = 0
    end

    ball:update(dt)
    player1:update(dt)
    player2:update(dt)
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'serve'
    elseif gameState == 'victory' then
      gameState = 'start'
      player1Score = 0
      player2Score = 0
    elseif gameState == 'serve' then
      gameState = 'play'
    end
  end
end

function love.draw()
  push:apply('start')
  love.graphics.clear(40/255,45/255,52/255,255/255)
  love.graphics.setFont(smallFont)
  displayScore()

  if gameState == 'start' then
    love.graphics.setFont(smallFont)
    love.graphics.printf("Welcome to Pong!", 0, 10, VIRTUAL_WIDTH,'center')
    love.graphics.printf("Press Enter to Play!", 0, 20, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'serve' then
    love.graphics.setFont(smallFont)
    love.graphics.printf("Player ".. tostring(servingPlayer) .. "'s turn!", 0, 10, VIRTUAL_WIDTH,'center')
    love.graphics.printf("Press Enter to serve!", 0, 20, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'victory' then
    love.graphics.setFont(victoryFont)
    love.graphics.printf("Player ".. tostring(winningPlayer) .. " wins!", 0, 10, VIRTUAL_WIDTH,'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf("Press Enter to serve!", 0, 42, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'play' then
  end

  ball:render()
  player1:render()
  player2:render()
  displayFPS()
  push:apply('end')
end

function displayFPS()
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.setFont(smallFont)
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20)
  love.graphics.setColor(1,1,1,1)
end

function displayScore()
  love.graphics.setFont(scoreFont)
  love.graphics.print(tostring(player1Score),VIRTUAL_WIDTH/2-50,VIRTUAL_HEIGHT/3)
  love.graphics.print(tostring(player2Score),VIRTUAL_WIDTH/2+30,VIRTUAL_HEIGHT/3)
end
