love = love
require "maths"
require("imgui")
imgui = imgui
_class = {
    new = function(self,o)
        o = o or {}
        setmetatable(o, self)
        self.__index = self
        return o
    end
}

_Boat = _class:new({
    x=nil,
    y=nil,
    angle=nil,
    imgPath=nil,
    speed=nil,
    width=20,
    height=20,
    Draw = function(self)
        love.graphics.push()
        love.graphics.translate(self.x,self.y)
        love.graphics.rotate(DegtoRad(self.angle))
        love.graphics.rectangle("fill",-self.width/2,-self.height/2,20,20)
        love.graphics.pop()
    end
})


function love.load()
    you = _Boat:new({x=300,y=20,angle=1})
    love.graphics.setColor(0,1,1,1)

end

function love.update(dt)
    imgui.NewFrame()

end

number = 0
function love.draw()
    you:Draw()
    --imgui.SetNextWindowPos(0, 0)
    imgui.SetNextWindowSize(200, love.graphics.getHeight())
    imgui.Begin("Hello")
    
    you.x = imgui.DragFloat("x",you.x,1.0)
    you.y = imgui.DragFloat("y",you.y,1.0)
    you.angle = imgui.SliderFloat("angle",you.angle,0.0,360.0)

    imgui.End()

    imgui.Render()
end


function love.textinput(t)
    imgui.TextInput(t)
end

function love.keypressed(key)
    imgui.KeyPressed(key)
    if key == "w" then
        print("Hello")
    end

end

function love.keyreleased(key)
    imgui.KeyReleased(key)
end

function love.mousemoved(x, y)
    imgui.MouseMoved(x, y)
end

function love.mousepressed(x, y, button)
    imgui.MousePressed(button)
end

function love.mousereleased(x, y, button)
    imgui.MouseReleased(button)
end

function love.wheelmoved(x, y)
    imgui.WheelMoved(y)
end