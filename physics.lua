require "maths"
world = love.physics.newWorld()

_PhysicsObj = {
    body=nil,
    fixture=nil, --is a fixture
    shape=nil, --always a rectangle
    new = function(self,pos,width,height,sensor,type)
        o={}
        o.body=love.physics.newBody(world,pos.x,pos.y,type or "dynamic")
        o.shape = love.physics.newRectangleShape(width,height)
        o.fixture = love.physics.newFixture(o.body,o.shape)
        if sensor then
            o.fixture:setSensor(true)
        end
        return o
    end
}