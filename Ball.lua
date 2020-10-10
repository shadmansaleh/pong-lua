Ball = Class{}

function Ball:init(x, y, radius)
	self.x = x
	self.y = y
	self.radius = radius
  local ball_max_dx = math.floor( 250 * WINDOW_WIDTH / 1280 )
  local ball_max_dy = math.floor(200 * WINDOW_HEIGHT / 720) * 1.5
  self.dx = 0 
  self.dy = 0
	self.attached = 0
end

function Ball:reset(playerNo)
  --self.x = (VERTUAL_WIDTH + WINDOW_BORDER) / 2 - self.radius / 2
  --self.y = (VERTUAL_HEIGHT + WINDOW_BORDER) / 2 - self.radius / 2

  local ball_max_dx = math.floor( 100 * WINDOW_WIDTH / 1280 )
  local ball_max_dy = math.floor(50 * WINDOW_HEIGHT / 720) * 1.5
  self.dx = math.floor(( playerNo == 1) and ball_max_dx
  or -ball_max_dx)
  self.dy = math.floor(math.random(-ball_max_dy, ball_max_dy)) 
	self.attached = playerNo
	if playerNo == 1 then
		self.x = player1.x + player1.width + 1
		self.y = player1.y + (player1.height / 2) - (self.radius / 2)
	elseif playerNo == 2 then
		self.x = player2.x - 3
		self.y = player2.y + (player2.height / 2) - (self.radius / 2)
	end
end

function Ball:update(dt)
	--if game_state == "play" then
	if self.attached == 0 then
		self.x = self.x + self.dx * dt
		self.y = self.y + self.dy * dt
	elseif self.attached == 1 then
		self.y = player1.y + (player1.height / 2) - (self.radius / 2)
	elseif self.attached == 2 then
		self.y = player2.y + (player2.height / 2) - (self.radius / 2)
	end
	--end	
end

function Ball:render()
	r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(30 / 255, 200 / 255, 200/ 255, 1)
  --love.graphics.rectangle('fill', 
  --self.x, 
	--self.y, 
  --self.radius, self.radius)	
  love.graphics.circle('fill', 
  self.x + self.radius / 2, 
	self.y + self.radius / 2, 
  self.radius / math.sqrt(2))	
	love.graphics.setColor(r, g, b, a)
end

function Ball:collides(box)
	if self.attached ~= 0 then
		return false
	end
	if self.x > box.x + box.width or
		self.x + self.radius < box.x then
		return false
	elseif self.y > box.y + box.height or
		self.y + self.radius < box.y then
		return false
	else
		return true
	end
end

