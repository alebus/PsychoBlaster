


Player = Class{}


    -- NOTE -  `self` is a reference to *this* object, whichever object is
    -- instantiated at the time this function is called.


    function Player:init()
        self.x = VIRTUAL_WIDTH/2
        self.y = VIRTUAL_HEIGHT/2
        
        -- self.width = 6
        -- self.height = 6
        
        self.radius = 6
   
       -- x and y velocity
       self.dx = 0
       self.dy = 0
   
    
      

    end


    function Player:update(dt)

        -- move the player
        -- and prevent the player from going off the screen
        
        if self.dy < 0 then
            self.y = math.max(self.radius, self.y + self.dy * dt)

        else
            self.y = math.min(VIRTUAL_HEIGHT - self.radius, self.y + self.dy * dt)
        end



        if self.dx < 0 then
            self.x = math.max(self.radius, self.x + self.dx * dt)

        else
            
            self.x = math.min(VIRTUAL_WIDTH - self.radius, self.x + self.dx * dt)
        end



    end

    -- added math.floor to prevent fractional coords making it move funky (I think)
    function Player:render()
        
        love.graphics.setColor( 57 / 255, 90 / 255, 220 / 255, 1)
        -- love.graphics.rectangle('fill', math.floor(self.x), math.floor(self.y), self.width, self.height)
        love.graphics.circle('fill', self.x, self.y, self.radius)
        
        love.graphics.setColor( 20 / 255, 108 / 255, 255 / 255, 1)
        love.graphics.circle('line', self.x, self.y, self.radius)
    end



    


