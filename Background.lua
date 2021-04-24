


Background = Class{}


  

    function Background:init(image, scale, speed, rotation_factor)
        self.x = VIRTUAL_WIDTH/2
        self.y = VIRTUAL_HEIGHT/2
         
   
        -- x and y velocity
        self.dx = 0
        self.dy = 0
   
        self.bgTrans = love.math.newTransform(VIRTUAL_WIDTH/2,VIRTUAL_HEIGHT/2)
        
        self.backgroundImage = love.graphics.newImage(image)
            
        self.scale = scale
        self.speed = speed

        -- set this to 1 if you want to rotate the background
        
        self.rotation = 0
        self.rotation_factor = rotation_factor

    end


    function Background:update(dt,player_dx,player_dy)

                
        self.y = self.y + player_dy * self.speed * dt
        self.x = self.x + player_dx * self.speed * dt

        self.rotation = self.rotation + self.rotation_factor * dt


    end


    function Background:render()
        
        -- with a TRANSFORM:
        --love.graphics.draw(backgroundImage,bgTrans)   

        -- the last 2 params are the offset, since my BG images that I made are 800x600 I am doing half that. 
        love.graphics.draw(self.backgroundImage, math.floor(self.x), math.floor(self.y), self.rotation, self.scale, self.scale, 400, 300 )
        

    end




