love.graphics.setDefaultFilter("nearest", "nearest")

local Camera = require("source/camera")
local Player = require("source/player")
local GiftController = require("source/giftController")

function love.load()
    World = love.physics.newWorld(0, 0)
    World:setCallbacks(beginContact)

    ScreenWidth = love.graphics:getWidth()
    ScreenHeight = love.graphics:getHeight()

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

    love.graphics.setColor(15/255, 56/255, 128/255, 1)
    love.graphics.rectangle("fill", 0, 0, ScreenWidth, ScreenHeight / (2 * Camera.scale))

    love.graphics.setColor(164/255, 175/255, 181/255, 1)
    love.graphics.rectangle("fill", 0, ScreenHeight / (2 * Camera.scale), ScreenWidth, ScreenHeight / (2 * Camera.scale))

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