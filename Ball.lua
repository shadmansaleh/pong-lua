Ball = Class{}

function Ball:init(x, y, radius)
	self.x = x
	self.y = y
	self.radius = radius
  local ball_max_dx = math.floor( 100 * WINDOW_WIDTH / 1280 )
  local ball_max_dy = math.floor(50 * WINDOW_HEIGHT / 720) * 1.5
  self.dx = math.floor(( math.random(2) == 1) and -ball_max_dx
  or ball_max_dx)
  self.dy = math.floor(math.random(-ball_max_dy, ball_max_dy)) 
end

function Ball:reset()
  self.x = (VERTUAL_WIDTH + WINDOW_BORDER) / 2 - self.radius / 2
  self.y = (VERTUAL_HEIGHT + WINDOW_BORDER) / 2 - self.radius / 2

  local ball_max_dx = math.floor( 100 * WINDOW_WIDTH / 1280 )
  local ball_max_dy = math.floor(50 * WINDOW_HEIGHT / 720) * 1.5
  self.dx = math.floor(( math.random(2) == 1) and -ball_max_dx
  or ball_max_dx)
  self.dy = math.floor(math.random(-ball_max_dy, ball_max_dy)) 
end

function Ball:update(dt)
  if game_state == "play" then
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
  end	
end

function Ball:render()
  love.graphics.rectangle('fill', 
  self.x, 
	self.y, 
  self.radius, self.radius)	
end
