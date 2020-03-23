love = love
require "imgui"
imgui = imgui
require "objects"

boats={}
islands={}
ZOOOM=1
money = 0 --in dollars

CHUNKSIZE=50
SpawnScale=75
function LoadChunk(x,y)
    
end
gameOver = false
youTimer = 0

function love.load()
    love.window.setMode(800,500,{resizable=true})

    love.graphics.setDefaultFilter("nearest")

    you = _Boat:new({pos=_Vec2:new(200,300),angle=0})
--    enemy = _Boat:new({pos=_Vec2:new(300,200),angle=0})

    --testIsland = _Island:new({pos=_Vec2:new(400,500)})

    rng = love.math.newRandomGenerator()

    for xx=0,CHUNKSIZE do
        for yy=0,CHUNKSIZE do
            if love.math.noise(xx,yy) >= 0.983 then
                -- love.graphics.setColor(1,1,0)
                -- love.graphics.points()
                table.insert(boats,_Boat:new({
                    pos=_Vec2:new((xx*SpawnScale)-(CHUNKSIZE*SpawnScale/2),(yy*SpawnScale)-(CHUNKSIZE*SpawnScale/2))
                }))
            end
        end
    end
    love.math.setRandomSeed(rng:random())
    CHUNKSIZE=25
    SpawnScale=100
    for xx=0,CHUNKSIZE do
        for yy=0,CHUNKSIZE do
            if love.math.noise(xx,yy) >= 0.983 then
                -- love.graphics.setColor(1,1,0)
                -- love.graphics.points()
                table.insert(islands,_Island:new({
                    pos=_Vec2:new((xx*SpawnScale)-(CHUNKSIZE*SpawnScale/2),(yy*SpawnScale)-(CHUNKSIZE*SpawnScale/2))
                }))
            end
        end
    end
end

function love.update(dt)
    imgui.NewFrame()

    for k,v in pairs(boats) do
        v.phys.body:setLinearVelocity(0,0)
    end

    if love.keyboard.isDown("up") then
        you:MoveForward(dt*you.speed)
    end
    if love.keyboard.isDown("right") then
        you.angle = you.angle + (you.speed * dt)
    end
    if love.keyboard.isDown("left") then
        you.angle = you.angle - (you.speed * dt)
    end
    for bk,bv in pairs(boats)do
        for k,v in pairs(bv.cannonBallList) do
            v:Update(dt)
        end
    end
    youTimer = youTimer + dt
    for k,v in pairs(islands) do
        if v.physTrigger.body:isTouching(you.phys.body) and love.keyboard.isDown("c") then
            v:Loot()
        end
    end

    for k,v in pairs(boats) do
        if v ~= you then
            v:Update(dt)
        end
    end
    world:update(dt)
end


function love.draw()
    if gameOver then
        love.graphics.clear(1,0,0)
        love.graphics.print("YOU DIED",0,0,0,10)
        love.graphics.print("$"..money,0,300,0,5)
    else
        love.graphics.clear(0,0.5,1)
        
        love.graphics.push()
        love.graphics.translate((love.graphics.getWidth()/2),(love.graphics.getHeight()/2))
        love.graphics.scale(ZOOOM)
        love.graphics.translate(-you.phys.body:getX(),-you.phys.body:getY())
        
        for bk,bv in pairs(boats) do
            bv:Draw()
            love.graphics.print(tostring(bv.health),bv.phys.body:getX(),bv.phys.body:getY())
            for k,v in pairs(bv.cannonBallList) do
                v:Draw()
            end
        end
        for k,v in pairs(islands) do
            v:Draw()
        end
        --imgui.SetNextWindowPos(0, 0)
        -- invRez = 15
        -- for x=0, love.graphics.getWidth() do
        --     for y=0, love.graphics.getHeight() do
        --         love.graphics.setColor(love.math.noise(x/invRez,y/invRez),love.math.noise(x/invRez,y/invRez),love.math.noise(x/invRez,y/invRez))
        --         love.graphics.points(x,y)
        --     end
        -- end
        -- love.graphics.setColor(1,1,1,1)

        love.graphics.pop()
        -- imgui.SetNextWindowSize(200, 400)
        -- imgui.Begin("Hello")

        -- you.pos.x = imgui.DragFloat("x",you.pos.x,1.0)
        -- you.pos.y = imgui.DragFloat("y",you.pos.y,1.0)
        -- you.angle = imgui.DragFloat("angle",you.angle,2)
        -- you.speed = imgui.DragFloat("speed",you.speed,2)
        -- imgui.Text("CannonBall")
        -- _CannonBall.scale = imgui.DragFloat("scale##cannonball",_CannonBall.scale,0.005)
        -- _CannonBall.speed = imgui.DragFloat("speed##cannonball",_CannonBall.speed,1)
        -- _CannonBall.killDist = imgui.DragFloat("dist##cannonball",_CannonBall.killDist,1)
        -- if imgui.Button("Debug") then
        --     debug.debug()
        -- end
        -- if imgui.Button("New enemy") then
        --     table.insert(boats,_Boat:new(
        --         {pos=_Vec2:new(love.math.random(0,400),love.math.random(0,400)),
        --         angle=love.math.random(0,360)
        --     }))
        -- end
        -- imgui.Text("Coord System")
        -- ZOOOM = imgui.DragFloat("ZOOOOM##Coords",ZOOOM,0.005)
        -- CHUNKSIZE = imgui.DragFloat("ChunkSize##Noise",CHUNKSIZE,10)
        -- SpawnScale = imgui.DragFloat("SpawnScale##Noise",SpawnScale,1)
        -- ---------------------------------
        -- imgui.End()

        -- imgui.Render()

        love.graphics.print("$"..tostring(money),0,0,0,2)
    end
end


function love.textinput(t)
    imgui.TextInput(t)
end

function love.keypressed(key,scancode,isrepeat)
    imgui.KeyPressed(key)
    if youTimer > 0.5 then
        if key == "z" then
            you:Fire(false)
        end
        if key == "x" then
            you:Fire(true)
        end
        youTimer = 0
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