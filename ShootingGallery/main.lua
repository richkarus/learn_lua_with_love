--[[
    A Shooting Gallery game where the target randomly moves and you have to use
    your mouse to shoot the target. 

    By default the following values apply:
        - Time is set to 10s
--]]

function love.load()
	-- Array ("table") to define the target we are to shoot
	target = {}
	target.x = 300
	target.y = 300
	target.radius = 50

	-- Initialise empty values for our score, timer and gameState
	score = 0
	timer = 0
	gameState = 1

	-- Controls the size of our font for "Score:" and "Time:"
	gameFont = love.graphics.newFont(40)

	-- Loads external sprite graphics
	sprites = {}
	sprites.sky = love.graphics.newImage('sprites/sky.png')
	sprites.target = love.graphics.newImage('sprites/target.png')
	sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')

	-- Hides the mouse pointer, this is so our crosshair becomes the 
	-- main focus, rather than the mouse itself
	love.mouse.setVisible(false)
end

-- love.update() runs every single time a frame is loaded
function love.update(dt)
	-- Incorporate 'dt' which is time delta - this is keep time consistent
	-- as there may be irregularities with FPS
	if timer > 0 then
		timer = timer - dt
	end
	
	-- Ends our game if the timer hits 0
	if timer < 0 then
		timer = 0
		gameState = 1
	end
end

function love.draw()
	-- Injects the background in before anything else is drawn on the screen
	love.graphics.draw(sprites.sky, 0, 0)

	-- Sets font to white
	love.graphics.setColor(1,1,1)
	-- Sets the font size to our variable above 'gameFont'
	love.graphics.setFont(gameFont)
	-- Concatenante the strings with the score and set it to offset 5px, 5px
	love.graphics.print("Score: " .. score, 5, 5)
	-- Concatenane the strings with the time and set it to the offset of 300px, 5px
	love.graphics.print("Time: " .. math.ceil(timer), 300, 5)

	-- Initialises our 'menu' by waiting for the game state to change
	if gameState == 1 then
		love.graphics.printf("Click to play the game!", 0, 250, love.graphics.getWidth(), "center")
	end

	-- Renders the target sprite on the screen because the game state has changed
	if gameState == 2 then 
		love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
	end
	-- Renders the crosshairs sprite on the screen
	love.graphics.draw(sprites.crosshairs, love.mouse.getX() - 20, love.mouse.getY() - 20)
end

function love.mousepressed(x, y, button, istouch, presses)
	-- this is the distance between the target and our mouse that has been square rooted
	local mouseToTarget = distanceBetween(x, y, target.x, target.y)

	-- Enter the game and perform logic on the mouse clicks
	if gameState == 2 then
		if mouseToTarget < target.radius then
		    if button == 1 then
		        score = score + 1
			randomiseTarget()
		    elseif button == 2 then
			score = score + 2 
			timer = timer - 1
		    end
		    randomiseTarget()
		elseif score > 0 then
			score = score - 1
		end
	-- Activates the game if we left-click and game state is 1
	elseif button == 1 and gameState == 1 then
		gameState = 2
		score = 0
		timer = 10
	end

end

-- Reusable function for randomising the target
function randomiseTarget()
	target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
	target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
end

function distanceBetween(x1, y1, x2, y2)
	return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end
