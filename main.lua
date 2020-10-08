-- Height amd width of screen

WINDOW_BORDER_SPACE = 0
WINDOW_BORDER_THIKNESS = 10

WINDOW_BORDER = WINDOW_BORDER_SPACE + WINDOW_BORDER_THIKNESS


WINDOW_HEIGHT =  love.graphics.getHeight() --360
WINDOW_WIDTH = love.graphics.getWidth() --640
VERTUAL_HEIGHT = WINDOW_HEIGHT  / 2.5 --183 -- 122
VERTUAL_WIDTH = WINDOW_WIDTH / 2.5 --330 --230

PADDLE_SPEED = 200 * WINDOW_HEIGHT / 720
PADDLE_HEIGHT = 20 * WINDOW_HEIGHT / 720
PADDLE_WIDTH = 5 * WINDOW_HEIGHT / 720
BALL_RADIOUS = 5 * WINDOW_HEIGHT / 720

-- impprt push library
push = require "push"

--[[ Runs whne first love loads up ]]
function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    small_font = love.graphics.newFont('fonts/font.ttf', 8)
    score_font = love.graphics.newFont('fonts/font.ttf', 32)

    player1Score = 0
    player2Score = 0

    player1Y = 20 + WINDOW_BORDER
    player2Y = VERTUAL_HEIGHT - PADDLE_HEIGHT - 20 - WINDOW_BORDER
    -- Set window mode
    --love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    push:setupScreen(VERTUAL_WIDTH, VERTUAL_HEIGHT,
        WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = true,
        resizable = false,
        vsync = true,
    })

end

function love.update(dt)
    -- Key controls
    if love.keyboard.isDown('w') then
        player1Y = player1Y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        player1Y = player1Y + PADDLE_SPEED * dt
    elseif love.keyboard.isDown('up') then
        player2Y = player2Y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        player2Y = player2Y - PADDLE_SPEED * dt
    end
    --Touch controle
    local touches = love.touch.getTouches()
    for i, touch in ipairs(touches) do
        local x, y = love.touch.getPosition(touch)
        if x < WINDOW_WIDTH / 2 then -- player 1
            if y < WINDOW_HEIGHT / 2 then -- Go up
                player1Y = player1Y - PADDLE_SPEED * dt
            else -- Go down
                player1Y =player1Y + PADDLE_SPEED * dt
            end
        else -- player2
            if y < WINDOW_HEIGHT / 2 then -- Go up
                player2Y = player2Y - PADDLE_SPEED * dt
            else -- Go down
                player2Y =player2Y + PADDLE_SPEED * dt
            end
        end
    end
    -- Border control
    if player1Y < WINDOW_BORDER then
        player1Y = WINDOW_BORDER
    end
    if player1Y > VERTUAL_HEIGHT - WINDOW_BORDER - PADDLE_HEIGHT then
        player1Y = VERTUAL_HEIGHT - WINDOW_BORDER - PADDLE_HEIGHT
    end
    if player2Y < WINDOW_BORDER then
        player2Y = WINDOW_BORDER
    end
    if player2Y > VERTUAL_HEIGHT - WINDOW_BORDER - PADDLE_HEIGHT then
        player2Y = VERTUAL_HEIGHT - WINDOW_BORDER - PADDLE_HEIGHT
    end
end

--[[ Runs every time after love.update ]]
function love.draw()
    push:apply('start')
    -- Draw Border
    love.graphics.setColor(40 / 255, 45 / 255, 52 / 255, 1)
    love.graphics.rectangle('fill',
        0, 
        0,
        VERTUAL_WIDTH,
        VERTUAL_HEIGHT)

    love.graphics.setColor(1, 1, 1, 1)
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


    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setFont(small_font)
    -- clear the screen
    --lve.graphics.clear(40 / 255, 45 / 255, 52 / 255, 1)
    -- [ Draw hello pong ]
    love.graphics.printf('Hello, pong!',
    0,                      --start x from 0
    20 + WINDOW_BORDER,  --start y from middle -6 because font aize is 12
    VERTUAL_WIDTH, -- center it with WINDPW_WIDTH
    'center') -- Align cemter

    -- Draw score 
    love.graphics.setFont(score_font)
    love.graphics.print(player1Score,
        (VERTUAL_WIDTH + WINDOW_BORDER) / 2 - 50,
        (VERTUAL_HEIGHT + WINDOW_BORDER)/ 3)
    love.graphics.print(player2Score,
        (VERTUAL_WIDTH + WINDOW_BORDER) / 2 + 30, 
        (VERTUAL_HEIGHT + WINDOW_BORDER) / 3)

    love.graphics.setFont(small_font)
    -- Draw the ball
    love.graphics.rectangle('fill', 
        (VERTUAL_WIDTH + WINDOW_BORDER) / 2 - BALL_RADIOUS / 2, 
        (VERTUAL_HEIGHT + WINDOW_BORDER) / 2 - BALL_RADIOUS / 2, 
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
    end
end

