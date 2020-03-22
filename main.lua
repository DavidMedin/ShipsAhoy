love = love
require "imgui"
imgui = imgui
require "objects"

masterCannonBallList = {}

function love.load()
    you = _Boat:new({pos=_Vec2:new(200,300),angle=1,speed=100,imgPath="Ship.png"})
    --love.graphics.setColor(0,1,1,1)

end

function love.update(dt)
    imgui.NewFrame()
    if love.keyboard.isDown("up") then
        you:MoveForward(dt*you.speed)
    end
    if love.keyboard.isDown("right") then
        you.angle = you.angle + (you.speed * dt)
    end
    if love.keyboard.isDown("left") then
        you.angle = you.angle - (you.speed * dt)
    end

    for i,v in ipairs(you.cannonBallList) do
        v:Update(dt)
    end

end


function love.draw()
    love.graphics.clear(0,0.5,1)
    you:Draw()
    for i,v in ipairs(you.cannonBallList) do
        v:Draw()
    end
    --imgui.SetNextWindowPos(0, 0)
    imgui.SetNextWindowSize(200, love.graphics.getHeight())
    imgui.Begin("Hello")
    
    you.x = imgui.DragFloat("x",you.pos.x,1.0)
    you.y = imgui.DragFloat("y",you.pos.y,1.0)
    you.angle = imgui.DragFloat("angle",you.angle,2)
    imgui.Text("CannonBall")
    _CannonBall.scale = imgui.DragFloat("scale##cannonball",_CannonBall.scale,0.005)
    _CannonBall.speed = imgui.DragFloat("speed##cannonball",_CannonBall.speed,1)
    if imgui.Button("Debug") then
        debug.debug()
    end
    imgui.End()

    imgui.Render()
end


function love.textinput(t)
    imgui.TextInput(t)
end

function love.keypressed(key,scancode,isrepeat)
    imgui.KeyPressed(key)
    if key == "z" then
        you:Fire(false)
    end
    if key == "x" then
        you:Fire(true)
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