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
  love.graphics.rectangle('fill',
  self.x, self.y, 
  self.width, self.height)	
end

