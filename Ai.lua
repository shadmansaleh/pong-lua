local ai = {}



local function calculate_end_pos(x, y, dx, dy, iter)
	if iter > 10 then
		return 0, 0
	end
	if dx > 0 then
		if dy > 0 then
			-- detect how far it will go in x axis to hit border
			local border_Y = VERTUAL_HEIGHT - WINDOW_BORDER - ball.radius
			local border_X = VERTUAL_WIDTH - WINDOW_BORDER - 5 - PADDLE_WIDTH - ball.radius
			if x + ((border_Y - y) / dy * dx) < border_X then
				x = x + ((border_Y - y) / dy * dx)
				y = border_Y
				dy = -dy
				return calculate_end_pos(x, y, dx, dy, iter + 1)
			else
				return border_X , (y + ((border_X - x) / dx) * dy)
			end
		else
			-- detect how far it will go in x axis to hit border
			local border_Y = 0 + WINDOW_BORDER
			local border_X = VERTUAL_WIDTH - WINDOW_BORDER - 5 - PADDLE_WIDTH - ball.radius
			if dy ~= 0 and x + ((y - border_Y) / dy * dx) < border_X then
				x = x + ((y - border_Y) / dy * dx)
				y = border_Y
				dy = -dy
				return calculate_end_pos(x, y, dx, dy, iter + 1)
			else
				return border_X , (y + ((border_X - x) / dx) * dy)
			end			
		end
	else
		return 0, 0
--[[	 else
		if dy > 0 then
			-- detect how far it willmgo pn x axis to hit borser
			local border_Y = VERTUAL_HEIGHT - WINDOW_BORDER + ball.radius
			local border_X = 0 + WINDOW_BORDER + 5 + PADDLE_WIDTH
			if x + (border_Y / dy * dx) < border_X then
				x = x + (border_Y / dy * dx)
				y = border_Y
				dy = - dy
				return calculate_end_pos(x, y, dx, dy)
			else
				return border_X , (y + (border_X / dx) * dy)
			end
		else
			-- detect how far it willmgo pn x axis to hit borser
			local border_Y = 0 + WINDOW_BORDER
			local border_X = 0 + WINDOW_BORDER + 5 + PADDLE_WIDTH
			if dy ~= 0 and x + (border_Y / dy * dx) < border_X then
				x = x + (border_Y / dy * dx)
				y = border_Y
				dy = - dy
				return calculate_end_pos(x, y, dx, dy)
			else
				return border_X , (y + (border_X / dx) * dy)
			end			
		end]]
	end
end

local function get_ball_end_pos_time()
	local x, y = calculate_end_pos(ball.x, ball.y, ball.dx, ball.dy, 0)
	return x, y
end

function ai.move_player(box)
	x, y = get_ball_end_pos_time()
	if x ~= nil and y ~= nil then
		if x == 0 and y == 0 then
			box.x = x
			box.y = y
			box:render()
		end
		--player2.y = y -- - player2.height / 2
	end
end


return ai

