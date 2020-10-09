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

-- impprt push library
push = require "push"


-- Handle touch inputs
local function handle_touches(touch, dt) 
  local x, y = love.touch.getPosition(touch)
  if x < WINDOW_WIDTH / 2 then -- player 1
    if y < WINDOW_HEIGHT / 2 then -- Go up
      player1Y = math.max(0 + WINDOW_BORDER, player1Y - PADDLE_SPEED * dt)            else -- Go down
      player1Y = math.min(VERTUAL_HEIGHT - WINDOW_BORDER - PADDLE_HEIGHT, 
      player1Y + PADDLE_SPEED * dt)
    end
  else -- player2
    if y < WINDOW_HEIGHT / 2 then -- Go up
      player2Y = math.max(0 + WINDOW_BORDER, player2Y - PADDLE_SPEED * dt)
    else -- Go down
      player2Y = math.min(VERTUAL_HEIGHT - WINDOW_BORDER - PADDLE_HEIGHT,
      player2Y + PADDLE_SPEED * dt)
    end
  end
end

-- handle keyboard input
local function handle_keyboard(dt)
  if love.keyboard.isDown('w') then
    player1Y = math.max(0 + WINDOW_BORDER, player1Y - PADDLE_SPEED * dt)
  elseif love.keyboard.isDown('s') then
    player1Y = math.min(VERTUAL_HEIGHT - WINDOW_BORDER - PADDLE_HEIGHT,
    player1Y + PADDLE_SPEED * dt)
  elseif love.keyboard.isDown('up') then
    player2Y = math.max(0 + WINDOW_BORDER, player2Y - PADDLE_SPEED * dt)
  elseif love.keyboard.isDown('down') then
    player2Y = math.min(VERTUAL_HEIGHT - WINDOW_BORDER - PADDLE_HEIGHT,
    player2Y + PADDLE_SPEED * dt)
  end
end

-- Update ball location
local function update_ball()
  if game_state == "play" then
    ballX = ballX + ballDx * dt
    ballY = ballY + ballDy * dt
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
--[[ Runs whne first love loads up ]]
function love.load()

  -- Seed 5he random genarator
  math.randomseed(os.time())

  love.graphics.setDefaultFilter('nearest', 'nearest')

  small_font = love.graphics.newFont('fonts/font.ttf', 8)
  score_font = love.graphics.newFont('fonts/font.ttf', 32)

  player1Score = 0
  player2Score = 0

  player1Y = 20 + WINDOW_BORDER
  player2Y = VERTUAL_HEIGHT - PADDLE_HEIGHT - 20 - WINDOW_BORDER

  ballX = (VERTUAL_WIDTH + WINDOW_BORDER) / 2 - BALL_RADIOUS / 2
  ballY = (VERTUAL_HEIGHT + WINDOW_BORDER) / 2 - BALL_RADIOUS / 2

  local ball_max_dx = math.floor( 100 * VERTUAL_WIDTH / 1280 )
  local ball_max_dy = math.floor(50 * VERTUAL_HEIGHT / 720)
  ballDx = math.floor(( math.random(2) == 1) and -ball_max_dx
  or ball_max_dx)
  ballDy = math.floor(math.random(-ball_max_dy, ball_max_dy)) 

  -- Set window mode
  --love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
  push:setupScreen(VERTUAL_WIDTH, VERTUAL_HEIGHT,
  WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = true,
    resizable = false,
    vsync = true,
  })

  game_state = "start"

end

function love.update(dt)
  -- Key controls
  handle_keyboard(dt)
  --Touch controle
  local touches = love.touch.getTouches()
  for i, touch in ipairs(touches) do
    handle_touches(touch, dt)
  end
  --------------
  -- Update ball
  --------------
  update_ball()
end

--[[ Runs every time after love.update ]]
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
  love.graphics.rectangle('fill', 
  ballX, 
  ballY, 
  BALL_RADIOUS, BALL_RADIOUS)



  -- Draw the padles
  love.graphics.rectangle('fill',
  5 + WINDOW_BORDER, player1Y, 
  PADDLE_WIDTH, PADDLE_HEIGHT)

  love.graphics.rectangle('fill', 
  VERTUAL_WIDTH - 5 - PADDLE_WIDTH - WINDOW_BORDER, 
  player2Y, 
  PADDLE_WIDTH, PADDLE_HEIGHT)

  push:apply('end')
end

-- [[ key press events ]]
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

