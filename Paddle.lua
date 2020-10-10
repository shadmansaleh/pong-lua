Paddle = Class{}

function Paddle:init(x, y, width, height)
	self.x = x
	self.y = y
	self.height = height
	self.width = width
	self.dy = 0--200 * WINDOW_HEIGHT / 720
end

function Paddle:update(dt)
	if self.dy < 0 then
		self.y = math.max(0 + WINDOW_BORDER, self.y + self.dy * dt) 	
	elseif self.dy > 0 then
		self.y = math.min(VERTUAL_HEIGHT - WINDOW_BORDER - self.height, 
			self.y + self.dy * dt)
	end  
end

function Paddle:render()
  local r, g, b, a = love.graphics.getColor()
  love.graphics.setColor(20 / 255, 240 / 255, 0 / 255, 1)

  love.graphics.rectangle('fill',
  self.x, self.y, 
  self.width, self.height)	

  love.graphics.setColor(r, g, b, a)
end

