local GUI = {}

local Player = require("source/player")

function GUI:load()
    self.font = love.graphics.newFont("assets/bit.ttf", 36)

    self.collectedGifts = {}
    self.collectedGifts.scale = 3
    self.collectedGifts.x = ScreenWidth/2
    self.collectedGifts.y = 20
end


function GUI:draw()
    self:displayCollectedGifts()
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

return GUI