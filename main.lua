


push = require 'push'
Class = require 'class'
require 'Player'
require 'Background'
require 'Bullet'
require 'Enemy'

WINDOW_WIDTH = 1024
WINDOW_HEIGHT = 768

-- this is a 16x9 ratio window
--VIRTUAL_WIDTH = 640
--VIRTUAL_HEIGHT = 360

VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 480


gameState = ""


CONTROL_SPEED = 175
MAX_SPEED = 250
PLAYER_DRAG = 6

BULLET_SPEED = 400

GAME_TITLE = "PsychoBlaster"

titleImageFile = "graphics/psychoblaster title 640.png"



function love.load()

    local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]

    math.randomseed(os.time())

    can_fire = true 
	fire_wait = 0.1 -- Delay between shots - see note below about maybe changing how this works
	fire_timer = 0 

    played_gameover = false
    
    -- I think it will be more fun to have slower enemies but more of them

    -- note this is changed below again
	enemy_wait = math.random( 1,3 ) - 0.5
	enemy_timer = 0 

    score = 0
    
    enemy_speed = 50 -- this will increase slowly over time!


    -- Each bullet will be its own table inside the bullets table. 
    -- It will contain the properties x, y, dx, and dy. 
    -- The dx and dy variables define how much the bullet should move in pixels per second on the x and y axis.
    -- got ideas from: https://love2d.org/wiki/Tutorial:Fire_Toward_Mouse
    -- and also https://sheepolution.com/learn/book/14
    bullets = {}

    enemies = {}



    -- todo - check other filters

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle(GAME_TITLE)

    titleFont = love.graphics.newFont('font.ttf', 25)
    hugeFont = love.graphics.newFont('font.ttf', 100)
    scoreFont = love.graphics.newFont('font.ttf', 50)

    
      
    -- sound effects
    sounds = {
        ['shoot'] = love.audio.newSource('sounds/player_shoot3.wav', 'static'),
        ['enemy_hit'] = love.audio.newSource('sounds/enemy_hit3.mp3', 'static'),
        ['enemy_spawn'] = love.audio.newSource('sounds/enemy_spawn.mp3', 'static'),
        ['gameover'] = love.audio.newSource('sounds/player_die.mp3', 'static')
    }

        
            
    



  -- initialize window with virtual resolution
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
    })

    playerScore = 0


    player = Player()

    background = Background("graphics/psychoblaster color bg.png", 1, 0.0, 0)
    background_top = Background("graphics/grid flat.png", 1.5, 0.4, math.pi / -20)
    background_tri = Background("graphics/mountains.png", 1.0, 0.3, 0)
        
    background_close = Background("graphics/grid flat.png", 3.5, 0, math.pi / 6)


    -- on first play only, show title
    if gameState ~= 'start' then
        gameState = 'title'
    end

end -- end of love.load



--[[
    Called by LÖVE whenever we resize the screen; here, we just want to pass in the
    width and height to push so our virtual resolution can be resized as needed.
]]
function love.resize(w, h)
    push:resize(w, h)
end




function love.update(dt)


    if gameState == "playerlose" then

        if not played_gameover then
            sounds['gameover']:play()
            played_gameover = true
        end

        return

    end



    if gameState == "title" then
       
        return
    
    end



    -- these are just temp values for each bullet we instantiate below
    local bullet_dx = 0
    local bullet_dy = 0


    -- this idea on the delay was from a forum
    -- todo - doesn't this vary though based on the framerate? 
    if not can_fire then
		fire_timer = fire_timer + dt 
		if fire_timer > fire_wait then
			can_fire = true
			fire_timer = 0
		end
	end


    -- todo - same thing as fire_timer, should this be time-based and not use dt?
    if not spawn_enemy then
		enemy_timer = enemy_timer + dt 
		if enemy_timer > enemy_wait then
            spawn_enemy = true
            
            
            enemy_timer = 0 
            
            -- it gets harder after 25 enemies
            if (score < 25 ) then
                enemy_wait = math.random( 1,3 ) - 0.5
            else 
                enemy_wait = math.random( 0,2 ) 
                gameState = "psycho"
            end
            
		end
	end



    -- joystick movement
    -- the value is from -1 to 1
    if joystick then

        local leftx = joystick:getGamepadAxis('leftx')
        local lefty = joystick:getGamepadAxis('lefty')
        local rightx = joystick:getGamepadAxis('rightx')
        local righty = joystick:getGamepadAxis('righty')

        -- Joystick movement
        -- I am clamping the values but keeping some existing velocity to hopefully make the control feel better and not so ON-OFF

        if leftx < -.5 then
            player.dx = math.max(-MAX_SPEED, player.dx + -CONTROL_SPEED)
        end

        if leftx > .5 then
            player.dx = math.min(MAX_SPEED, player.dx + CONTROL_SPEED)
        end
           
        if lefty < -.5 then
            player.dy = math.max(-MAX_SPEED, player.dy + -CONTROL_SPEED)
        end

        if lefty > .5 then
            player.dy = math.min(MAX_SPEED, player.dy + CONTROL_SPEED)
        end



        -- joystick firing control
        -- the joystick coords are -1,-1 in the upper left and 1,1 lower right
        
        -- left
        if rightx < -.5 then
            bullet_dx = bullet_dx + -BULLET_SPEED
        end

        -- right 
        if rightx > .5 then
            bullet_dx = bullet_dx + BULLET_SPEED
        end
        
        -- up
        if righty < -.5 then
            bullet_dy = bullet_dy + -BULLET_SPEED
        end

        -- down
        if righty > .5 then
            bullet_dy = bullet_dy + BULLET_SPEED
        end

        -- debug
        --print("Rightx | righty" .. rightx .. " | " .. righty )

              

    end

    
    -- debug - size of table
    -- print(table.getn(bullets))

    

    -- player keyboard movement
    if love.keyboard.isDown('up') then
        player.dy = math.max(-MAX_SPEED, player.dy + -CONTROL_SPEED)
    end

    if love.keyboard.isDown('down') then
        player.dy = math.min(MAX_SPEED, player.dy + CONTROL_SPEED)
    end
        
    if love.keyboard.isDown('left') then
        player.dx = math.max(-MAX_SPEED, player.dx + -CONTROL_SPEED)
    end

    if love.keyboard.isDown('right') then
        player.dx = math.min(MAX_SPEED, player.dx + CONTROL_SPEED)
    end
        
    

    -- player keyboard firing

    -- up
    if love.keyboard.isDown('w') then
        bullet_dy = bullet_dy + -BULLET_SPEED
    end

    -- down
    if love.keyboard.isDown('s') then
        bullet_dy = bullet_dy + BULLET_SPEED
    end

    -- left
    if love.keyboard.isDown('a') then
        bullet_dx = bullet_dx + -BULLET_SPEED
    end
        
    -- right
    if love.keyboard.isDown('d') then
        bullet_dx = bullet_dx + BULLET_SPEED
    end



    
    
    
    -- make the player slow down but not stop instantly
    -- this applies to both keyboard and joystick movement
        
    if player.dy > 0 then
        player.dy = math.max(0,player.dy - PLAYER_DRAG)  
    elseif player.dy < 0 then 
        player.dy = math.min(0,player.dy + PLAYER_DRAG)  
    end

    if player.dx > 0 then 
        player.dx = math.max(0,player.dx - PLAYER_DRAG) 
    elseif player.dx < 0 then 
        player.dx = math.min(0,player.dx + PLAYER_DRAG) 
    end




     -- instantiate bullet and add it to the table of bullets 
     -- I thought about adding the two values and testing if not zero, but then two of the diagonals don't work! :D
    
    if can_fire then  -- this is a delay so firing isn't constant
    
        if bullet_dx ~=0 or bullet_dy ~= 0 then
            table.insert(bullets, Bullet(player.x, player.y,bullet_dx, bullet_dy))
            sounds['shoot']:play()
            can_fire = false
        end

    end


    
    
    if spawn_enemy then
        
        -- spawn from one of the four corners or the top/bottom middle edge

        spawn_loc = math.random(1,7)
        
        print("spawn_loc: " .. spawn_loc)

        if spawn_loc >= 1 and spawn_loc <= 2 then
            enemy_x = 0
            enemy_y = 0
        elseif spawn_loc >= 2 and spawn_loc <= 3 then
            enemy_x = 0
            enemy_y = VIRTUAL_HEIGHT
        elseif spawn_loc >= 3 and spawn_loc <= 4 then
            enemy_x = VIRTUAL_WIDTH
            enemy_y = 0
        elseif spawn_loc >= 4 and spawn_loc <= 5 then
            enemy_x = VIRTUAL_WIDTH / 2
            enemy_y = 0
        elseif spawn_loc >= 5 and spawn_loc <= 6 then
            enemy_x = VIRTUAL_WIDTH / 2
            enemy_y = VIRTUAL_HEIGHT
        else 
            enemy_x = VIRTUAL_WIDTH
            enemy_y = VIRTUAL_HEIGHT
        end



        -- enemies get faster every time :>
        
        table.insert(enemies, Enemy(enemy_x, enemy_y, enemy_speed))
        enemy_speed = enemy_speed + 5
        sounds['enemy_spawn']:play()
        spawn_enemy = false
    end
    


    
    player:update(dt)
    

    -- update all bullets in table
    for i,v in ipairs(bullets) do
        v:update(dt)
        v:checkCollision(enemies)

        -- debug
        print("Bullet dx | dy" .. bullet_dx .. " | " .. bullet_dy )

        if v.dead then
            --Remove it from the list
            table.remove(bullets, i)
        end

    end

    -- update all enemies in table
    for i,v in ipairs(enemies) do
        v:update(dt)
        v:checkCollision()

        if v.dead then
            --Remove it from the list
            score = score + 1
            table.remove(enemies, i)
            sounds['enemy_hit']:play()
        end
    
    end


    
    -- parallax scrolling background
    background:update(dt,player.dx,player.dy)
    background_top:update(dt,player.dx,player.dy)
    background_tri:update(dt,player.dx,player.dy)
    background_close:update(dt,player.dx,player.dy)
end




--[[
    Keyboard handling, called by LÖVE2D each frame; 
    passes in the key we pressed so we can access.
]]
function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == "playerlose" then
            gameState = "start"
            love.load()
        elseif gameState == "title" then
            gameState = "start"
        end
    end

end



--[[
    Called after update by LÖVE2D, used to draw anything to the screen, 
    updated or otherwise.
]]
function love.draw()

    -- graphics stuff needs to be in-between the push functions
    push:apply('start')




    --love.graphics.clear(0, 0, 0, 1)
       

    if gameState == "playerlose" then

        love.graphics.clear(60/255, 150/255, 240/255, 1)

        love.graphics.setFont(hugeFont)
        love.graphics.setColor(200/255, 8/255, 230/255, 1)
        love.graphics.printf('GAME OVER', 0, 50, VIRTUAL_WIDTH, 'center')
       
        
        love.graphics.setColor(1, 1, 1, 1)
        
        love.graphics.setFont(scoreFont)
        love.graphics.printf("Score: " .. score, 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')
        
        love.graphics.setFont(titleFont)
        love.graphics.printf('Press enter to try again', 0, VIRTUAL_HEIGHT - 150, VIRTUAL_WIDTH, 'center')


    elseif  gameState == "title" then
    
        titleImage = love.graphics.newImage(titleImageFile)
        love.graphics.draw(titleImage, 0, 0, 0, 1)
        
        love.graphics.setFont(titleFont)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf('Press enter to play', 0, VIRTUAL_HEIGHT - 150, VIRTUAL_WIDTH, 'center')
        


    else 

        -- note the 4th param sets the transparency 
        -- the order matters here, draw the top layers later 
        
        love.graphics.setColor(1, 1, 1, 1)
        background:render()

        love.graphics.setColor(1, 1, 1, .5)
        background_tri:render()
        
        love.graphics.setColor(1, 1, 1, .3)
        background_top:render()

        love.graphics.setColor(1, 1, 1, .3)
        background_close:render()
        
        love.graphics.setColor(1, 1, 1, 1)
        
        player:render()
        

        for i,v in ipairs(bullets) do
            v:render()
        end


        for i,v in ipairs(enemies) do
            v:render()
        end

    

    

        -- this is when the game gets PSYCHO! :D
        if gameState == "psycho" then
            
            -- flashing red color
            love.graphics.setColor(math.random(0.2,1), 0, 0, 1)
            
            love.graphics.setFont(titleFont)
            love.graphics.printf("Let's get PSYCHO!", 0, 20, VIRTUAL_WIDTH, "center")
        
            love.graphics.setFont(scoreFont)
            love.graphics.printf(score, 0, VIRTUAL_HEIGHT - 50, VIRTUAL_WIDTH, 'center')

        else
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.setFont(titleFont)
            love.graphics.printf('PSYCHOBLASTER', 0, 20, VIRTUAL_WIDTH, 'center')

            love.graphics.setFont(scoreFont)
            love.graphics.printf(score, 0, VIRTUAL_HEIGHT - 50, VIRTUAL_WIDTH, 'center')

        end

    end



    push:apply('end')
end


