local Gift = {}
Gift.__index = Gift

local Camera = require("source/camera")
local Player = require("source/player")
local ActiveGifts = {}

function Gift.new(x1, y1, x2, y2)
    local instance = setmetatable({}, Gift)
    instance.x = x1
    instance.y = y1 
    instance.yScale = 1
    instance.image = love.graphics.newImage("assets/gift/gift-color.png")
    instance.width = instance.image:getWidth()
    instance.height = instance.image:getHeight()

    instance.collected = false
    instance.toBeRemoved = false

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)

    instance.shadow = {}
    instance.shadow.x = x2
    instance.shadow.y = y2
    instance.shadow.yScale = 1
    instance.shadow.image = love.graphics.newImage("assets/gift/gift-shadow.png")

    instance.shadow.physics = {}
    instance.shadow.physics.body = love.physics.newBody(World, instance.shadow.x, instance.shadow.y, "static")
    instance.shadow.physics.body:setFixedRotation(true)
    instance.shadow.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.shadow.physics.fixture = love.physics.newFixture(instance.shadow.physics.body, instance.shadow.physics.shape)
    instance.shadow.physics.fixture:setSensor(true)

    if y1 > ScreenHeight / (2 * Camera.scale) then
        instance.yScale = -instance.yScale
    elseif y2 > ScreenHeight / (2 * Camera.scale) then
        instance.image = love.graphics.newImage("assets/gift/gift-baw.png")
        instance.shadow.yScale = -instance.shadow.yScale
    end

    table.insert(ActiveGifts, instance)
end

function Gift.updateAll(dt)
    for i, instance in ipairs(ActiveGifts) do 
        instance:update(dt)
    end
end

function Gift:update(dt)
    if self.toBeRemoved then
        self:destroy()
    end
end

function Gift.drawAll()
    for i, instance in ipairs(ActiveGifts) do 
        instance:draw()
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function Gift:draw()
    if self.collected then 
        love.graphics.setColor(1, 1, 1, 0.5)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end

    love.graphics.draw(self.image, self.x, self.y, 0, 1, self.yScale, self.width/2, self.height/2)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.shadow.image, self.shadow.x, self.shadow.y, 0, 1, self.shadow.yScale, self.width/2, self.height/2)
end

function Gift:destroy()
    for i, instance in ipairs(ActiveGifts) do
        if instance == self then
            Player:incrementGifts()
            self.shadow.physics.body:destroy()
            self.physics.body:destroy()
            table.remove(ActiveGifts, i)
        end
    end
end

function Gift.beginContact(a, b, collision)
    for i, instance in ipairs(ActiveGifts) do 
        if a == Player.physics.fixture or b == Player.physics.fixture then
            if a == instance.physics.fixture or b == instance.physics.fixture then
                instance.collected = true
                return true
            elseif instance.collected and (a == instance.shadow.physics.fixture or b == instance.shadow.physics.fixture) then
                instance.toBeRemoved = true
                return true
            end
        end
    end
end

return Gift