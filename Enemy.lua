



Enemy = Class{}

-- todo randomize the size and color 
-- or have it cycle through them, etcz
-- todo could have stuff leave behind light trails or particle trails 

function Enemy:init(x, y, movespeed)
    self.x = x
    self.y = y
   
    self.dx = 0
    self.dy = 0

    self.movespeed = movespeed

    -- self.height = 5
    -- self.width = 5

    self.dead = false
     
    -- math.randomseed(os.time())

    --self.x = math.random(200,800)
    --self.y = math.random(200,800)

    self.radius = math.random(4,15)

    self.red = math.random(0,1)
    self.green = math.random(0,1)
    self.blue = math.random(0,1)

    self.color = 0

    -- this will cause it to be pink or blue below
    if math.random( 1,2 ) > 1.5 then
        self.color = 1
    end

    
end


function Enemy:update(dt)
    
    if self.x >= player.x then
        self.dx = -self.movespeed
    elseif self.x <= player.x then
        self.dx = self.movespeed 
    end

    if self.y >= player.y then
        self.dy = -self.movespeed 
    elseif self.y <= player.y then
        self.dy = self.movespeed 
    end
    
    
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt


end


-- todo if you change the enemy size or shape then ensure this is still correct (radius or width etc)

function Enemy:checkCollision()
    local self_left = self.x
    local self_right = self.x + self.radius 
    local self_top = self.y
    local self_bottom = self.y + self.radius 

   
    local obj_left = player.x
    local obj_right = player.x + player.radius 
    local obj_top = player.y
    local obj_bottom = player.y + player.radius 

    if self_right > obj_left and
    self_left < obj_right and
    self_bottom > obj_top and
    self_top < obj_bottom then
        -- self.dead = true
        print("player hit")
        gameState = "playerlose"
    end
end



function Enemy:render()
    
    -- totally random colors
    -- love.graphics.setColor(self.red, self.green, self.blue, 1)

    -- pink or blue
    if self.color == 1 then
        love.graphics.setColor(60/255, 150/255, 240/255, 1)
    else
        love.graphics.setColor(220/255, 8/255, 255/255, 1)
    end



    love.graphics.circle('line', math.floor(self.x), math.floor(self.y), self.radius)
end