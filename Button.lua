Button = Class{}

function Button:init(arg_dict)
	--[[
	--	In arg_dict
	--		
	--		DIMENTION SCSIFIC
	--		x (num) = x cordinate   default(0)
	--		y (num) = y cordinate   default(0)
	--		width (num) = width of button   default(0)
	--		height (num) = heigh of button  default(0)
	--
	--		DRAWING SPECIFIC
	--		visible (bool) = is button visible   default(false)
	--		drawMode (string) [filled/line]= is filled			default(false)
	--		color (table with r,g,b,a values) = color to draw 
	--																							(already set color)	
	--		font (love.graphics.Font) = Font to use (already set font)
	--		text (string) = name pf button default(nil)
	--		textColor (table with r,g,b,a values) = color to draw the text
	--
	--		
	--		onClick (function) = function invoked when Button:clicked() is used
	--]]
	--
	-- Implement defaults
	if arg_dict.x == nil then
		arg_dict.x = 0
	end

	if arg_dict.y == nil then
		arg_dict.y = 0
	end

	if arg_dict.height == nil then
		arg_dict.height = 0
	end

	if arg_dict.width == nil then
		arg_dict.width = 0
	end

	if arg_dict.visible == nil then
		arg_dict.visible = false
	end

	if arg_dict.drawMode == nil then
		arg_dict.drawMode = 'line'
	end

	self.args = arg_dict
end

function Button:render()
	if self.args.visible then
		-- Change color and font if nessery
		if self.args.color ~= nil then
			local r, g, b, a = love.graphics.getcolor()			
			love.graphics.setcolor(self.args.color)
		end
		if self.args.font ~= nil then
			local font = love.graphics.getFont()
			love.graphics.setFont(self.args.font)
		end

		love.graphics.rectangle(self.args.drawMode,
			self.x,
			self.y,
			self.width,
			self.height
		)

		if self.args.text ~= nil then
			if self.args.textColor ~= nil then
				local tr, tg, tb, ta = love.graphics.getcolor()			
				love.graphics.setcolor(self.args.textColor)			
			end

			love.graphics.printf(self.text,
				self.x,
				self.y + self.heigth / 2,
				self.width,
				'center')

			if self.args.color ~= nil then
				love.graphics.setColor(tr, tg, tb, ta)
			end
		end

		--restore color and font if it was changed
		if self.args.color ~= nil then
			love.graphics.setColor(r, g, b, a)
		end
		if self.args.font ~= nil then
			love.graphics.setFont(font)
		end
	end
end

local function buttonPressed(touch_id, onClick)
	x, y = love.touch.getPosition(touch_id)
	if x < self.x  or x > self.x + self.width then
		return false
	elseif y < self.y or y > self.y + self.height then
		return false
	else
		if self.args.onClick ~= nil then
			self.args.onClick()
		end
		if onClick ~= nil then
			onClick()
		end
		return true
	end
end

local function mousePressed(onClick)
	if love.mouse.isDown(1) then
		x = love.mouse.getX()
		y = love.mouse.getY()
		if x < self.x  or x > self.x + self.width then
			return false
		elseif y < self.y or y > self.y + self.height then
			return false
		else
			if self.args.onClick ~= nil then
				self.args.onClick()
			end
			if onClick ~= nil then
				onClick()
			end
			return true
		end
	end
	return false
end

function Button:pressed(onClick)
	touches = love.touch.getTouches()
	touch_state = false
	for i, touch_id in ipairs(touches) do
		if onClick ~= nil then
			touch_state = buttonPressed(touch_id, onClick)
		else
			touch_state =  buttonPressed(touch_id)
		end
		if touch_state == true then
			return true
		end
	end
	if touch_state == false then
		if onClick ~= nil then
			return mousePressed(onClick)
		else
			return mousePressed()
		end	
	end
end


