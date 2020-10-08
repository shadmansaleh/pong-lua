-- Height amd width of screen
WINDOW_HEIGHT = 360
WINDOW_WIDTH = 640
VERTUAL_HEIGHT = 183 -- 122
VERTUAL_WIDTH = 330 --230
PADDLE_SPEED = 200


-- impprt push library
push = require "push"

--[[ Runs whne first love loads up ]]
function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    small_font = love.graphics.newFont('fonts/font.ttf', 8)
    score_font = love.graphics.newFont('fonts/font.ttf', 32)

    player1Score = 0
    player2Score = 0

    player1Y = 20
    player2Y = VERTUAL_HEIGHT - 30
    -- Set window mode
    --love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    push:setupScreen(VERTUAL_WIDTH, VERTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true,
    })

end

function love.update(dt)
    if love.keyboard.isDown('w'):

end

--[[ Runs every time after love.update ]]
function love.draw()
    love.graphics.setFont(small_font)
    push:apply('start')
    -- clear the screen
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)
    -- [ Draw hello pong ]
    love.graphics.printf('Hello, pong!',
    0,                      --start x from 0
    20,  --start y from middle -6 because font aize is 12
    VERTUAL_WIDTH, -- center it with WINDPW_WIDTH
    'center') -- Align cemter

    love.graphics.setFont(score_font)
    love.graphics.print(player1Score, VERTUAL_WIDTH / 2 - 50 , VERTUAL_HEIGHT / 3)
    love.graphics.print(player2Score, VERTUAL_WIDTH / 2 + 30 , VERTUAL_HEIGHT / 3)
    -- Draw the ball
    love.graphics.rectangle('fill', VERTUAL_WIDTH / 2 - 2, VERTUAL_HEIGHT / 2 - 2, 5, 5)
    -- the padles
    love.graphics.rectangle('fill', 5, player1Y, 5, 20)
    love.graphics.rectangle('fill', VERTUAL_WIDTH - 10, player2Y, 5, 20)
    push:apply('end')
end

-- [[ key press events ]]
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

