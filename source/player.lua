local Player = {}

local Camera = require("source/camera")
local Sound = require("source/sound")

function Player:load()
    self.animations = {width = 16, height = 16}
    self.animations["future"] = newAnimation("assets/player/player.png", self.animations.width, self.animations.height, 0.4)
    self.animations["past"] = newAnimation("assets/player/player-baw.png", self.animations.width, self.animations.height, 0.4)
    self.state = "future"

    self.width = self.animations.width
    self.height = self.animations.height
    self.initialX = ScreenWidth/(2 * Camera.scale)
    self.initialY = ScreenHeight / (2 * Camera.scale) - self.height/2
    self.x = self.initialX
    self.y = self.initialY
    self.xScale = 1
    self.yScale = 1

    self.initialMaxSpeed = 150
    self.maxSpeed = self.initialMaxSpeed
    self.xVel = self.maxSpeed
    self.yVel = 0

    self.gravity = 1000
    self.jumpAmount = -400
    self.grounded = true
    self.hasDoubleJump = true
    self.futureGround = ScreenHeight / (2 * Camera.scale) - self.height/2
    self.pastGround = ScreenHeight / (2 * Camera.scale) + self.height/2

    self.gifts = 0

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)

    Sound:init("jump", "sounds/jump.wav", "static")
end

function Player:update(dt)
    self:applyGravity(dt)
    self:syncPhysics()
    self:animate(dt)
end

function Player:animate(dt)
    local animation = self.animations[self.state]
    animation.currentTime = animation.currentTime + dt

    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
    end
end

function Player:move(key)
    if key == "right" or key == "d" then
        self.xVel = self.maxSpeed
        self.xScale = 1
    elseif key == "left" or key == "a" then
        self.xVel = -self.maxSpeed
        self.xScale = -1
    end
end

function Player:syncPhysics()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
    self.x, self.y = self.physics.body:getPosition()

    if self.yScale > 0 and self.y > self.futureGround then
        self.grounded = true
        self.yVel = 0
        self.physics.body:setPosition(self.x, self.futureGround)
    elseif self.yScale < 0 and self.y < self.pastGround then
        self.grounded = true
        self.yVel = 0
        self.physics.body:setPosition(self.x, self.pastGround)
    end

    if self.x < -self.width or self.x > (ScreenWidth / Camera.scale) + self.width then
        GameState.current = GameState.over
    end
end

function Player:applyGravity(dt)
    if not self.grounded then
        self.yVel = self.yVel + self.gravity * dt * self.yScale
    end
end

function Player:jump()
    if self.grounded then 
        self.grounded = false
        self.hasDoubleJump = true
        self.yVel = self.jumpAmount * self.yScale
        Sound:play("jump", "sfx", "0.2")
    elseif self.hasDoubleJump then
        self.yVel = self.jumpAmount * self.yScale * 0.8
        self.hasDoubleJump = false
        Sound:play("jump", "sfx", "0.1")
    end
end

function Player:flip(key)
    if key == "up" or key == "w" then
        if self.state == "future" then return end

        self.physics.body:setPosition(self.x, 2*(ScreenHeight / (2 * Camera.scale)) - self.y)
        self.yScale = 1
        self.state = "future"

        return true
    elseif key == "down" or key == "s" then
        if self.state == "past" then return end

        self.physics.body:setPosition(self.x, 2*(ScreenHeight / (2 * Camera.scale)) - self.y)
        self.yScale = -1
        self.state = "past"

        return true
    end
end

function Player:draw()
    local animation = self.animations[self.state]
    local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    love.graphics.draw(animation.spritesheet, animation.quads[spriteNum], self.x, self.y, 0, self.xScale, self.yScale, self.width/2, self.height/2)
end

function Player:incrementGifts()
    self.gifts = self.gifts + 1
    if math.fmod(self.gifts, 5) == 0 then
        self.maxSpeed = self.maxSpeed + 50
    end
    newGift()
end

function Player:reset()
    self.gifts = 0
    self.yScale = 1
    self.xScale = 1
    self.maxSpeed = self.initialMaxSpeed
    self.yVel = 0
    self.xVel = self.maxSpeed
    self.physics.body:setPosition(self.initialX, self.initialY)
end

return Player