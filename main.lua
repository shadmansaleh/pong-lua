-- Height amd width of screen

WINDOW_BORDER_SPACE = 0
WINDOW_BORDER_THIKNESS = 5

WINDOW_BORDER = WINDOW_BORDER_SPACE + WINDOW_BORDER_THIKNESS


WINDOW_HEIGHT =  love.graphics.getHeight() --360
WINDOW_WIDTH = love.graphics.getWidth() --640
VERTUAL_HEIGHT = WINDOW_HEIGHT  / 3.0 --183 -- 122
VERTUAL_WIDTH = WINDOW_WIDTH / 3.0 --330 --230

PADDLE_SPEED = 250 * WINDOW_HEIGHT / 720
PADDLE_HEIGHT = 20 * WINDOW_HEIGHT / 720 * 1.3
PADDLE_WIDTH = 5 * WINDOW_HEIGHT / 720
BALL_RADIOUS = 5 * WINDOW_HEIGHT / 720

WINNING_SCORE = 10

-- import libraries
Class = require "class"
push = require "push"
ai = require "Ai"

require "Paddle"
require "Ball"

--------------------------
-- Handle touch inputs  --
--------------------------


local function handle_touches(touch, dt) 
  -- Reset player speed
  player2.dy = 0
  player1.dy = 0

  local x, y = love.touch.getPosition(touch)
  -- start and reset in the middle
  if x > WINDOW_WIDTH / 2 - 120 and
    x < WINDOW_WIDTH / 2 + 120
    --[[and y > WINDOW_HEIGHT / 2 - 30 and y < WINDOW_HEIGHT + 30 ]]then
    if touch_delay > 0.2 then
      touch_delay = 0
      switch_game_state()
    end
    -------------------------
    --   PADDLE MOVEMENT   --
    -------------------------
    
  elseif x < WINDOW_WIDTH / 2 then -- player 1
    if y < WINDOW_HEIGHT / 2 then -- Go up
      player1.dy = -PADDLE_SPEED
    else -- Go down
      player1.dy = PADDLE_SPEED
    end
  else -- player2
    if y < WINDOW_HEIGHT / 2 then -- Go up
      player2.dy = -PADDLE_SPEED
    else -- Go down
      player2.dy = PADDLE_SPEED
    end
  end
end

----------------------------
-- handle keyboard input  --
----------------------------

local function handle_keyboard(dt)
  if love.keyboard.isDown('w') then
    player1.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('s') then
    player1.dy = PADDLE_SPEED
  else 
    player1.dy = 0
  end
  if love.keyboard.isDown('up') then
    player2.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then
    player2.dy = PADDLE_SPEED
  else
    player2.dy = 0
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
  love.graphics.setColor(70 / 255, 70 / 255, 70 / 255, 1)
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
  --if game_state ~= 'victory' then
    -- backup current font for restore
    local font = love.graphics.getFont()
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(200 / 255,150 / 255,20 / 255, 1)
    love.graphics.setFont(score_font)
    if game_state ~= 'victory' then
    love.graphics.print(player1Score,
      (VERTUAL_WIDTH + WINDOW_BORDER) / 2 - 50 * WINDOW_WIDTH / 1280,
      (VERTUAL_HEIGHT + WINDOW_BORDER) / 3)
    love.graphics.print(player2Score,
      (VERTUAL_WIDTH + WINDOW_BORDER) / 2 + 30 * WINDOW_WIDTH / 1280, 
      (VERTUAL_HEIGHT + WINDOW_BORDER) / 3)
    else
    love.graphics.print(player1Score,
      (VERTUAL_WIDTH + WINDOW_BORDER) / 2 - 50 * WINDOW_WIDTH / 1280,
      (VERTUAL_HEIGHT + WINDOW_BORDER) * 2 / 3)
    love.graphics.print(player2Score,
      (VERTUAL_WIDTH + WINDOW_BORDER) / 2 + 30 * WINDOW_WIDTH / 1280, 
      (VERTUAL_HEIGHT + WINDOW_BORDER) * 2 / 3)
    end
    -- resotre font
    love.graphics.setFont(font)
    love.graphics.setColor(r, g, b, a)
  --end
end


-------------------------------------------
--  [[ Runs whne first love loads up ]]  --
-------------------------------------------

function love.load()

  -- Seed 5he random genarator
  math.randomseed(os.time())

  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- Load fonts
  small_font = love.graphics.newFont('fonts/font.ttf', 10 * WINDOW_HEIGHT / 720)
  score_font = love.graphics.newFont('fonts/font.ttf', 32 * WINDOW_HEIGHT / 720)
  victoryFont = love.graphics.newFont('fonts/font.ttf', 24 * WINDOW_HEIGHT / 720)

	-- Load audio
	sounds = {
		paddle_hit = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
		wall_hit = love.audio.newSource('sounds/wall_hit.wav', 'static'),
		point_scored = love.audio.newSource('sounds/score.wav', 'static'),
	}

  love.window.setTitle('Pong')
  game_reset()
  --------------------------
  --  Initialize players  --
  --------------------------
  
  player1 = Paddle(5 + WINDOW_BORDER, 20 + WINDOW_BORDER,
    PADDLE_WIDTH, PADDLE_HEIGHT)
  player2 = Paddle(VERTUAL_WIDTH - 5 - PADDLE_WIDTH - WINDOW_BORDER,
    VERTUAL_HEIGHT - PADDLE_HEIGHT - 20 - WINDOW_BORDER,
    PADDLE_WIDTH, PADDLE_HEIGHT)

  --------------------------------------------------------------
  --   Draw ball at center of screen and set random velocity  --
  --------------------------------------------------------------
  
  local ballX = (VERTUAL_WIDTH + WINDOW_BORDER) / 2 - BALL_RADIOUS / 2
  local ballY = (VERTUAL_HEIGHT + WINDOW_BORDER) / 2 - BALL_RADIOUS / 2
  ball = Ball(ballX, ballY, BALL_RADIOUS)
	end_ball = Ball(0, 0, BALL_RADIOUS)
  ball:reset(servingPlayer)
  -----------------------
  --  Set window mode  --
  -----------------------
  
  push:setupScreen(VERTUAL_WIDTH, VERTUAL_HEIGHT,
  WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = true,
    resizable = true,
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
  --  Update players  --
  ----------------------
 player1:update(dt)
 player2:update(dt)
  -----------------
  -- Update ball --
  -----------------

  ball:update(dt)

  -------------------------
  -- Collision direction --
  -------------------------
  
  if ball:collides(player1) then
    ball.dx = -ball.dx
    ball.x = player1.x + 2 * player1.width
		sounds.paddle_hit:play()
  elseif ball:collides(player2) then
    ball.dx = -ball.dx
    ball.x = player2.x - player2.width
		sounds.paddle_hit:play()
  end
  if ball.y <= 0 + WINDOW_BORDER then
    ball.dy = -ball.dy
    ball.y = 0 + WINDOW_BORDER
		sounds.wall_hit:play()
  elseif ball.y >= VERTUAL_HEIGHT - WINDOW_BORDER - ball.radius then
    ball.dy = -ball.dy
    ball.y = VERTUAL_HEIGHT - WINDOW_BORDER - ball.radius
		sounds.wall_hit:play()
  end

  if ball.x <= 0 + WINDOW_BORDER then
    servingPlayer = 1
    player2Score = player2Score + 1
		sounds.point_scored:play()
    ball:reset(servingPlayer)
    if player2Score < WINNING_SCORE then
      game_state = 'serve'
    else
      game_state = 'victory'
      winner = 2
    end
  elseif ball.x >= VERTUAL_WIDTH - WINDOW_BORDER - ball.radius then
    servingPlayer = 2
    player1Score = player1Score + 1
		sounds.point_scored:play()
    ball:reset(servingPlayer)
    if player1Score < WINNING_SCORE then
      game_state = 'serve'
    else
      ball:reset(servingPlayer)
      game_state = 'victory'
      winner = 1
    end
  end
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
  
  -- Draw upper text
  draw_intro()


  -- Draw score 
  draw_scores()

  -- Draw the ball
  ball:render()

  -- Draw the padles
  player1:render()
  player2:render()
  --ai.move_player(end_ball)

  -- Diaplay FPS
	--displayFPS()

  push:apply('end')
end

function love.resize(w, h)
	push:resize(w, h)
end
------------------------------
--  [[ key press events ]]  --
------------------------------

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  else
    if key =='enter' then
      switch_game_state()
    end
  end
end

function switch_game_state()
  if game_state == 'start' then
    game_state = 'play'
    ball.attached = 0
  elseif game_state == 'serve' then
    game_state = 'play'
    ball.attached = 0
  elseif game_state == 'victory' then
    game_state = 'start'
    game_reset()
  end
end

function game_reset()
  player1Score = 0
  player2Score = 0
  servingPlayer = math.random(2) == 1 and 1 or 2
  winner = 0
  touch_delay = 0
end

function displayFPS()
  local r, g, b, a = love.graphics.getColor()
  local font = love.graphics.getFont()

  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.setFont(small_font)
  love.graphics.print('F P S : ' .. tostring(love.timer.getFPS()),
  40 * WINDOW_WIDTH / 1280, 20 * WINDOW_HEIGHT / 720)

  love.graphics.setColor(r, g, b, a)
  love.graphics.setFont(font)
end


function draw_intro() 
  local r, g, b, a = love.graphics.getColor()
  love.graphics.setColor( 93 / 255, 124 / 255, 1, 1)
  -- [ Draw hello pong ]
  if game_state == 'start' then
    love.graphics.printf('Hel lo, Welcome to Pong!',
    0 * WINDOW_WIDTH / 1280 ,                      --start x from 0
    20 * WINDOW_HEIGHT / 720 + WINDOW_BORDER,  --start y from middle -6 because font aize is 12
    VERTUAL_WIDTH, -- center it with WINDPW_WIDTH
    'center') -- Align cemter
    love.graphics.printf('Press Enter or\nTouch in the middle to play',
    0 * WINDOW_WIDTH / 1280 ,                      --start x from 0
    52 * WINDOW_HEIGHT / 720 + WINDOW_BORDER,  --start y from middle -6 because font aize is 12
    VERTUAL_WIDTH, -- center it with WINDPW_WIDTH
    'center') -- Align cemter
  elseif game_state == 'serve' then
    love.graphics.printf('Player ' .. tostring(servingPlayer) .. '\'s turn to serve',
    0 * WINDOW_WIDTH / 1280 ,                      --start x from 0
    20 * WINDOW_HEIGHT / 720  + WINDOW_BORDER,  --start y from middle -6 because font aize is 12
    VERTUAL_WIDTH, -- center it with WINDPW_WIDTH
    'center') -- Align cemter
  elseif game_state == 'victory' then
    draw_victory_dialouge()
  end
  love.graphics.setColor(r, g, b, a)
end

function draw_victory_dialouge()
  curFont = love.graphics.getFont()
  love.graphics.setFont(victoryFont)
  love.graphics.printf('Player ' .. tostring(winner) .. ' has Won',
  0 * WINDOW_WIDTH / 1280 ,                      --start x from 0
  20 * WINDOW_HEIGHT / 720 + WINDOW_BORDER,  --start y from middle -6 because font aize is 12
  VERTUAL_WIDTH, -- center it with WINDPW_WIDTH
  'center') -- Align cemter

  love.graphics.setFont(small_font)

  love.graphics.printf('Press Enter or\nTouch in the middle to play',
  0 * WINDOW_WIDTH / 1280 ,                      --start x from 0
  80 * WINDOW_HEIGHT / 720 + WINDOW_BORDER,  --start y from middle -6 because font aize is 12
  VERTUAL_WIDTH, -- center it with WINDPW_WIDTH
  'center') -- Align cemter


  love.graphics.setFont(victoryFont)
end


