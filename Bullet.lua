



Bullet = Class{}


function Bullet:init(x, y, dx, dy)
    self.x = x
    self.y = y
   

    self.dx = dx
    self.dy = dy

    self.height = 3
    self.width = 3
  
    self.dead = false

end


function Bullet:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt


    -- remove the bullet when it leaves the edge of the screen
    if self.x > VIRTUAL_WIDTH or self.x < 0 or self.y < 0 or self.y > VIRTUAL_HEIGHT then
        self.dead = true
    end


end


-- partly from https://sheepolution.com/learn/book/14
-- this is different than the logic used in the Pong examples but they both make sense
-- this seems a bit shorter
-- I made it loop through the enemies table
function Bullet:checkCollision(obj_table)
    local self_left = self.x
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y + self.height


    -- todo if you change the enemies then you need to ensure the collision height or radius etc is still correct

    -- so this is expecting a table of objects
    for i,v in ipairs(obj_table) do

        local obj_left = v.x
        local obj_right = v.x + v.radius * 2
        local obj_top = v.y
        local obj_bottom = v.y + v.radius * 2

        if self_right > obj_left and
        self_left < obj_right and
        self_bottom > obj_top and
        self_top < obj_bottom then
            self.dead = true
            v.dead = true
        end
    end
end







function Bullet:render()
    self.red = math.random(0.2,1)
    love.graphics.setColor(self.red, 0, 0, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.height, self.width)
end