-- Height amd width of screen

WINDOW_BORDER_SPACE = 0
WINDOW_BORDER_THIKNESS = 10

WINDOW_BORDER = WINDOW_BORDER_SPACE + WINDOW_BORDER_THIKNESS


WINDOW_HEIGHT =  love.graphics.getHeight() --360
WINDOW_WIDTH = love.graphics.getWidth() --640
VERTUAL_HEIGHT = WINDOW_HEIGHT  / 2.0 --183 -- 122
VERTUAL_WIDTH = WINDOW_WIDTH / 2.0 --330 --230

PADDLE_SPEED = 200 * WINDOW_HEIGHT / 720
PADDLE_HEIGHT = 20 * WINDOW_HEIGHT / 720
PADDLE_WIDTH = 5 * WINDOW_HEIGHT / 720
BALL_RADIOUS = 5 * WINDOW_HEIGHT / 720

-- import libraries
Class = require "class"
push = require "push"

require "Paddle"
require "Ball"

--------------------------
-- Handle touch inputs  --
--------------------------


local function handle_touches(touch, dt) 
  -- Reset paddle speed
  paddle2.dy = 0
  paddle1.dy = 0

  local x, y = love.touch.getPosition(touch)
  -- start and reset in the middle
  if x > WINDOW_WIDTH / 2 - 30 and x < WINDOW_WIDTH / 2 + 30
    and y > WINDOW_HEIGHT / 2 - 30 and y < WINDOW_HEIGHT + 30 then
    if touch_delay > 0.2 then
      touch_delay = 0
      if game_state == 'start' then
        game_state = 'play'
      elseif game_state == 'play' then
        game_state = 'start'
        ball:reset()
      end
    end
    -------------------------
    --   PADDLE MOVEMENT   --
    -------------------------
    
  elseif x < WINDOW_WIDTH / 2 then -- player 1
    if y < WINDOW_HEIGHT / 2 then -- Go up
      paddle1.dy = -PADDLE_SPEED
    else -- Go down
      paddle1.dy = PADDLE_SPEED
    end
  else -- player2
    if y < WINDOW_HEIGHT / 2 then -- Go up
      paddle2.dy = -PADDLE_SPEED
    else -- Go down
      paddle2.dy = PADDLE_SPEED
    end
  end
end

----------------------------
-- handle keyboard input  --
----------------------------

local function handle_keyboard(dt)
  if love.keyboard.isDown('w') then
    paddle1.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('s') then
    paddle1.dy = PADDLE_SPEED
  else 
    paddle1.dy = 0
  end
  if love.keyboard.isDown('up') then
    paddle2.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then
    paddle2.dy = PADDLE_SPEED
  else
    paddle2.dy = 0
  end
end


local function draw_window()
  local r, g, b, a = love.graphics.getColor()
  --[[    love.graphics.setColor(40 / 255, 45 / 255, 52 / 255, 1)
  love.graphics.rectangle('fill',
  0, 
  0,
  VERTUAL_WIDTH,
  VERTUAL_HEIGHT)

  love.graphics.setColor(1, 1, 1, 1)
  --]]
  love.graphics.rectangle('fill',
  WINDOW_BORDER_SPACE, 
  WINDOW_BORDER_SPACE,
  VERTUAL_WIDTH - 2 * WINDOW_BORDER_SPACE,
  VERTUAL_HEIGHT - 2 * WINDOW_BORDER_SPACE)

  love.graphics.setColor(40 / 255, 45 / 255, 52 / 255, 1)
  love.graphics.rectangle('fill',
  WINDOW_BORDER, 
  WINDOW_BORDER,
  VERTUAL_WIDTH - 2 * WINDOW_BORDER,
  VERTUAL_HEIGHT - 2 * WINDOW_BORDER)
  -- reset color
  love.graphics.setColor(r, g, b, a)
end

local function draw_scores()
  -- backup current font for restore
  local font = love.graphics.getFont()
  love.graphics.setFont(score_font)
  love.graphics.print(player1Score,
  (VERTUAL_WIDTH + WINDOW_BORDER) / 2 - 50,
  (VERTUAL_HEIGHT + WINDOW_BORDER)/ 3)
  love.graphics.print(player2Score,
  (VERTUAL_WIDTH + WINDOW_BORDER) / 2 + 30, 
  (VERTUAL_HEIGHT + WINDOW_BORDER) / 3)
  -- resotre font
  love.graphics.setFont(font)
end


-------------------------------------------
--  [[ Runs whne first love loads up ]]  --
-------------------------------------------

function love.load()

  -- Seed 5he random genarator
  math.randomseed(os.time())

  love.graphics.setDefaultFilter('nearest', 'nearest')

  small_font = love.graphics.newFont('fonts/font.ttf', 8)
  score_font = love.graphics.newFont('fonts/font.ttf', 32)

  love.window.setTitle('Pong')

  player1Score = 0
  player2Score = 0

  --------------------------
  --  Initialize paddles  --
  --------------------------
  
  paddle1 = Paddle(5 + WINDOW_BORDER, 20 + WINDOW_BORDER,
    PADDLE_WIDTH, PADDLE_HEIGHT)
  paddle2 = Paddle(VERTUAL_WIDTH - 5 - PADDLE_WIDTH - WINDOW_BORDER,
    VERTUAL_HEIGHT - PADDLE_HEIGHT - 20 - WINDOW_BORDER,
    PADDLE_WIDTH, PADDLE_HEIGHT)

  --------------------------------------------------------------
  --   Draw ball at center of screen and set random velocity  --
  --------------------------------------------------------------
  
  local ballX = (VERTUAL_WIDTH + WINDOW_BORDER) / 2 - BALL_RADIOUS / 2
  local ballY = (VERTUAL_HEIGHT + WINDOW_BORDER) / 2 - BALL_RADIOUS / 2
  ball = Ball(ballX, ballY, BALL_RADIOUS)

  -----------------------
  --  Set window mode  --
  -----------------------
  
  push:setupScreen(VERTUAL_WIDTH, VERTUAL_HEIGHT,
  WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = true,
    resizable = false,
    vsync = true,
  })

  game_state = "start"
  touch_delay = 0

end

function love.update(dt)
  -- Key controls
  handle_keyboard(dt)
  --Touch controle
  touch_delay = touch_delay + dt
  local touches = love.touch.getTouches()
  for i, touch in ipairs(touches) do
    handle_touches(touch, dt)
  end
  ----------------------
  --  Update paddles  --
  ----------------------
 paddle1:update(dt)
 paddle2:update(dt)
  -----------------
  -- Update ball --
  -----------------
  ball:update(dt)
end

-----------------------------------------------
--  [[ Runs every time after love.update ]]  --
-----------------------------------------------

function love.draw()
  push:apply('start')
  -- Draw Border
  draw_window()

  love.graphics.setFont(small_font)
  -- clear the screen
  --lve.graphics.clear(40 / 255, 45 / 255, 52 / 255, 1)
  -- [ Draw hello pong ]
  if game_state == 'start' then
    love.graphics.printf('Hello, Start state!',
    0,                      --start x from 0
    20 + WINDOW_BORDER,  --start y from middle -6 because font aize is 12
    VERTUAL_WIDTH, -- center it with WINDPW_WIDTH
    'center') -- Align cemter
  elseif game_state == 'play' then
    love.graphics.printf('Hello, Play state!',
    0,                      --start x from 0
    20 + WINDOW_BORDER,  --start y from middle -6 because font aize is 12
    VERTUAL_WIDTH, -- center it with WINDPW_WIDTH
    'center') -- Align cemter
  end
  -- Draw score 
  draw_scores()

  -- Draw the ball
  ball:render()

  -- Draw the padles
  paddle1:render()
  paddle2:render()

  -- Diaplay FPS
  displayFPS()

  push:apply('end')
end

------------------------------
--  [[ key press events ]]  --
------------------------------

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  else
    if key =='enter' then
      if game_state == 'start' then
        game_state = 'play'
      elseif game_state == 'play' then
        game_state = 'start'
      end
    end
  end
end


function displayFPS()
  local r, g, b, a = love.graphics.getColor()
  local font = love.graphics.getFont()

  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.setFont(small_font)
  love.graphics.print('FPS : ' .. tostring(love.timer.getFPS()), 40, 20)

  love.graphics.setColor(r, g, b, a)
  love.graphics.setFont(font)
end
