local GUI = {}

local Player = require("source/player")

function GUI:load()
    self.font = love.graphics.newFont("assets/bit.ttf", 36)

    self.collectedGifts = {}
    self.collectedGifts.scale = 3
    self.collectedGifts.x = ScreenWidth/2
    self.collectedGifts.y = 20
end

function GUI:draw(state)
    if state == GameState.home then
        self:displayHomeMessage()
    elseif state == GameState.inGame then
        self:displayCollectedGifts()
    elseif state == GameState.over then
        self:displayGameOver()
    end
end

function GUI:displayHomeMessage()
    love.graphics.setFont(self.font)

    local text = "press space to start...\n\n\n\n...and don't get out of the screen!"
    local x = ScreenWidth/2- self.font:getWidth(text) / 2
    local y = ScreenHeight/2 - self.font:getHeight(text)*3

    love.graphics.setColor(0,0,0,0.5)
    love.graphics.print(text, x + 2, y + 2) 

    love.graphics.setColor(1,1,1,1)
    love.graphics.print(text, x, y) 
end

function GUI:displayCollectedGifts()
    love.graphics.setFont(self.font)

    local collectedGifts = Player.gifts
    local x = self.collectedGifts.x - self.font:getWidth(collectedGifts) / 2
    local y = self.collectedGifts.y - self.font:getHeight() / 2

    love.graphics.setColor(0,0,0,0.5)
    love.graphics.print(collectedGifts, x + 2, y + 2) 

    love.graphics.setColor(1,1,1,1)
    love.graphics.print(collectedGifts, x, y) 
end

function GUI:displayGameOver()
    love.graphics.setFont(self.font)

    local text = "you lost D:\nbut you took "..Player.gifts.." gifts to their right time\n\n\npress space to try to take more"
    local x = ScreenWidth/2- self.font:getWidth(text) / 2
    local y = ScreenHeight/2 - self.font:getHeight(text)*3

    love.graphics.setColor(0,0,0,0.5)
    love.graphics.print(text, x + 2, y + 2) 

    love.graphics.setColor(1,1,1,1)
    love.graphics.print(text, x, y) 
end

return GUI