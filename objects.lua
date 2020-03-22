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

_CannonBall = _class:new({
    damage=20,
    speed=300,
    angle=nil,
    dir=nil, --dir[1],dir[2] - x,y - should be normalized
    pos=nil, --pos[1],pos[2] - x,y
    img=love.graphics.newImage("CannonBall.png"),
    scale=0.185,
    width=nil,
    height=nil,

    parentTable=nil,

    killDist=100, --distance where deleted
    startPos=nil,
    new = function(self,o)
        o = _class.new(self,o)
        --getmetatable(o)["__gc"] = function(t) print("Hello") end
        o.width = o.img:getWidth()
        o.height = o.img:getHeight()
        o.dir = _Vec2:new(math.cos(math.rad(o.angle)),math.sin(math.rad(o.angle)))
        o.startPos = o.pos:new()
        return o
    end,
    Update = function(self,dt)
        self.pos.x = self.pos.x + (self.dir.x * dt * self.speed)
        self.pos.y = self.pos.y + (self.dir.y * dt * self.speed)
        if self.startPos:Distance(self.pos) >= self.killDist then
            --delete this object
            self:Delete()
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
        love.graphics.translate(self.pos.x,self.pos.y)
        love.graphics.draw(self.img,-(self.width*self.scale)/2,-(self.height*self.scale)/2,0,self.scale)

        love.graphics.pop()
    end
    })

_Boat = _class:new({
    pos=nil,
    angle=nil,
    img=love.graphics.newImage("Ship.png"),
    speed=nil,
    width=20,
    height=20,
    phys=nil,
    health=100,
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
        love.graphics.pop()
    end,
    MoveForward = function(self,amount)
        local dir = _Vec2:new(math.cos(math.rad(self.angle)),math.sin(math.rad(self.angle)))
        self.pos.x = self.pos.x + dir.x * amount
        self.pos.y = self.pos.y + dir.y * amount
        self.phys.body:setPosition(self.pos.x,self.pos.y)
        self.pos.x = self.phys.body:getX()
        self.pos.y = self.phys.body:getY()
    end,
    --right is bool
    Fire = function(self,right)
        table.insert(self.cannonBallList,_CannonBall:new({
            parentTable=self.cannonBallList,
            pos = _Vec2:new(self.phys.body:getX(),self.phys.body:getY()),
            angle=self.angle + (90 * (right and 1 or -1))
        }))
    end
})