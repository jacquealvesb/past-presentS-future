love.graphics.setDefaultFilter("nearest", "nearest")

local Camera = require("source/camera")
local Player = require("source/player")
local GiftController = require("source/giftController")

function love.load()
    World = love.physics.newWorld(0, 0)
    World:setCallbacks(beginContact)

    ScreenWidth = love.graphics:getWidth()
    ScreenHeight = love.graphics:getHeight()

    pastBackground = love.graphics.newImage("assets/background/past.png")
    futureBackground = love.graphics.newImage("assets/background/future.png")

    GameOver = false

    GiftController:init()
    Player:load()
end

function love.update(dt)
    World:update(dt)

    if GameOver then return end
    Player:update(dt)
    GiftController:update(dt)
end

function love.draw()
    if GameOver then
        return
    end

    Camera:apply()

    love.graphics.draw(futureBackground, -20, -8)

    love.graphics.setColor(200/255, 200/255, 200/255, 1)
    love.graphics.draw(pastBackground, -20, 2*(ScreenHeight / (2 * Camera.scale)) + 8, 0, 1, -1)

    GiftController.draw()
    Player:draw()
    
    Camera:clear()
end

function love.keypressed(key)
    if key == "space" then
        Player:jump()
    else
        Player:flip(key)
    end
end

function beginContact(a, b, collision)
    if GiftController:checkContact(a, b, collision) then return end
end

function newGift()
    GiftController:new()
end

function newAnimation(imageFile, width, height, duration)
    local image = love.graphics.newImage(imageFile)
    local animation = {}
    animation.spritesheet = image
    animation.quads = {}

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end