require "maths"
require "physics"
_class = {
    new = function(self,o)
        o = o or {}
        setmetatable(o, self)
        self.__index = self
        return o
    end
}


_Island = _class:new({
    pos=nil, --_Vec2
    hasTreasure=true,
    img=love.graphics.newImage("Island.png"),
    img2=love.graphics.newImage("FullIsland.png"),
    width=nil,
    height=nil,
    triggerWidth=100,
    triggerHeight=100,
    physHard=nil,
    physTrigger=nil,
    scaleHard=1,
    scaleTrigger=1.5,
    teasureVal=100,
    new = function(self,o)
        o = _class.new(self,o)
        o.width = o.img:getWidth()
        o.height = o.img:getHeight()
        o.physHard = _PhysicsObj:new(o.pos,o.width,o.height,false,"static")
        o.physTrigger = _PhysicsObj:new(o.pos,o.triggerWidth*o.scaleTrigger,o.triggerHeight*o.scaleTrigger,true,"static")
        table.insert(islands,o)
        return o
    end,
    Loot = function(self)
        if self.hasTreasure then
            self.hasTreasure = false
            money = money + self.teasureVal
        end
    end,
    Draw = function(self)
        love.graphics.push()
        love.graphics.translate(self.physHard.body:getX(),self.physHard.body:getY())
        if self.hasTreasure then
            love.graphics.draw(self.img2,-(self.width*self.scaleHard)/2,-(self.height*self.scaleHard)/2,0,self.scaleHard)
        else
            love.graphics.draw(self.img,-(self.width*self.scaleHard)/2,-(self.height*self.scaleHard)/2,0,self.scaleHard)
        end
        love.graphics.pop()
    end
})



killDist=340 --distance where deleted

_CannonBall = _class:new({
    damage=20,
    speed=400,
    angle=nil,
    dir=nil, --dir[1],dir[2] - x,y - should be normalized
    pos=nil, --pos[1],pos[2] - x,y
    img=love.graphics.newImage("CannonBall.png"),
    scale=0.185,
    width=nil,
    height=nil,
    phys=nil,
    parentTable=nil,


    killDist=340, --distance where deleted
    startPos=nil,
    new = function(self,o)
        o = _class.new(self,o)
        --getmetatable(o)["__gc"] = function(t) print("Hello") end
        o.width = o.img:getWidth()
        o.height = o.img:getHeight()
        o.dir = _Vec2:new(math.cos(math.rad(o.angle)),math.sin(math.rad(o.angle)))
        o.startPos = o.pos:new()
        o.phys = _PhysicsObj:new(o.pos,o.width,o.height,true)
        o.phys.body:setLinearVelocity(o.dir.x*o.speed,o.dir.y*o.speed)
        return o
    end,
    Update = function(self,dt)
        -- self.pos.x = self.pos.x + (self.dir.x * dt * self.speed)
        -- self.pos.y = self.pos.y + (self.dir.y * dt * self.speed)
        if self.startPos:Distance(_Vec2:new(self.phys.body:getX(),self.phys.body:getY())) >= self.killDist then
            --delete this object
            self:Delete()
            return
        end
        for k,v in pairs(boats) do
            if self.phys.body:isTouching(v.phys.body) and (self.parentTable ~= v.cannonBallList) then
                --debug.debug()
                v:Damage(self.damage)
                self:Delete()
                break
            end
        end
        
    end,
    Delete = function(self)
        for k,v in pairs(self.parentTable) do
            if v == self then
                self.parentTable[k] = nil
            end
        end
    end,
    Draw = function(self)
        love.graphics.push()
        love.graphics.translate(self.phys.body:getX(),self.phys.body:getY())
        love.graphics.draw(self.img,-(self.width*self.scale)/2,-(self.height*self.scale)/2,0,self.scale)

        love.graphics.pop()
    end
    })

_Boat = _class:new({
    pos=nil,
    angle=0,
    img=love.graphics.newImage("Ship.png"),
    speed=100,
    width=20,
    height=20,
    phys=nil,
    health=100,
    timer=0,

    debugText=nil,

    status="alive", --can be "alive" or "dead"
    cannonBallList=nil,

    new = function(self,o)
        o = _class.new(self,o)
        o.width = o.img:getWidth()
        o.height = o.img:getHeight()
        o.cannonBallList = {}
        o.phys=_PhysicsObj:new(o.pos,o.width,o.height,false)
        --setmetatable(o.cannonBallList,{__mode = "vk"})
        table.insert(boats,o)
        return o
    end,
    Draw = function(self)
        love.graphics.push()
        love.graphics.translate(self.phys.body:getX(),self.phys.body:getY())
        love.graphics.rotate(math.rad(self.angle+90))
        if self.img ~= nil then
            love.graphics.draw(self.img,-self.width/2,-self.height/2)
        else
            love.graphics.rectangle("fill",-self.width/2,-self.height/2,20,20)
        end
        love.graphics.rotate(-math.rad(self.angle+90))

        if self.debugText ~= nil then
            love.graphics.print(self.debugText,0,10)
        end
        love.graphics.pop()
    end,
    MoveForward = function(self,amount)
        local dir = _Vec2:new(math.cos(math.rad(self.angle)),math.sin(math.rad(self.angle)))
        -- self.pos.x = self.pos.x + dir.x * amount
        -- self.pos.y = self.pos.y + dir.y * amount
        -- self.phys.body:setPosition(self.pos.x,self.pos.y)
        -- self.pos.x = self.phys.body:getX()
        -- self.pos.y = self.phys.body:getY()
        amount = amount * 100
        self.phys.body:setLinearVelocity(dir.x*amount,dir.y*amount)
    end,
    --right is bool
    Fire = function(self,right)

            table.insert(self.cannonBallList,_CannonBall:new({
                parentTable=self.cannonBallList,
                pos = _Vec2:new(self.phys.body:getX(),self.phys.body:getY()),
                angle=self.angle + (90 * (right and 1 or -1))
            }))
         
    end,
    Damage = function(self,damage)
        self.health = self.health - damage
        if self.health <= 0 then
            self.status = "dead"
            self.health = 0
            self:Kill()
        end
    end,
    Kill = function(self)
        for k,v in pairs(boats) do
            if v == self then
                --self.phys.body:destroy()
                boats[k] = nil
                collectgarbage()
                if v == you then
                    gameOver = true
                end
            end
        end
    end,
    Update = function(self,dt) --ENEMIES ONLY!1!!!
        if _Vec2:new(self.phys.body:getX(),self.phys.body:getY()):Distance(_Vec2:new(you.phys.body:getX(),you.phys.body:getY())) <= 300 then
            -- self:MoveForward(self.speed*dt)
            youPos = _Vec2:new(you.phys.body:getX(),you.phys.body:getY())
            mePos = _Vec2:new(self.phys.body:getX(),self.phys.body:getY())
            local unNormal =_Vec2:new(self.phys.body:getX(),self.phys.body:getY()) - _Vec2:new(you.phys.body:getX(),you.phys.body:getY())
            local dir=_Vec2:new(math.normalize(unNormal.x,unNormal.y))
            local targetAngle=math.deg(math.atan2(dir.y,dir.x))+180
           -- self.debugText = tostring(targetAngle-(self.angle%360))
            --self.debugText = tostring(targetAngle).." -> "..tostring(targetAngle-self.angle)
            if mePos:Distance(youPos) < killDist/2 then
                ---get perpendickular; close enough
                if ((targetAngle+90)%360) - self.angle > 10 then

                     if (((targetAngle+90)%360) - self.angle)%360 > (self.angle - ((targetAngle+90)%360))%360 then
                        self.angle = self.angle - ((targetAngle+90)%360)*dt
                    else
                        self.angle = self.angle + ((targetAngle+90)%360)*dt
                    end
                else
                    if self.timer > 2 then
                        self:Fire(false)
                        self.timer=0
                    end
                end
            else
                if (targetAngle - self.angle)%360 < 10 then
                    --aimed twards you, and too far away
                    self:MoveForward(self.speed*dt)
                else
                    --not aimed or close enough
                    if (targetAngle - self.angle)%360 > (self.angle - targetAngle)%360 then
                        self.angle = self.angle - targetAngle*dt
                    else
                        self.angle = self.angle + targetAngle*dt
                    end
                end
            end

        end

        self.timer = self.timer + dt
    end
})