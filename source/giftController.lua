local GiftController = {}

local Camera = require("source/camera")
local Gift = require("source/gift")

function GiftController:init()
    self.border = 20
    math.randomseed(os.time())
    self:new()
end

function GiftController:update(dt)
    Gift.updateAll(dt)
end

function GiftController:draw()
    Gift.drawAll()
end

function GiftController:new()
    local x1 = math.random(0, (ScreenWidth / Camera.scale) - self.border)
    local x2 = math.random(0, (ScreenWidth / Camera.scale) - self.border)
    local y1 = math.random(self.border, (ScreenHeight / Camera.scale) - self.border)
    local y2 = 0

    if y1 > ScreenHeight / (Camera.scale * 2) then
        y2 = math.random(self.border, (ScreenHeight / (Camera.scale * 2)) - self.border)
    else
        y2 = math.random((ScreenHeight / (Camera.scale * 2)) + self.border, (ScreenHeight / Camera.scale) - self.border)
    end

    Gift.new(x1, y1, x2, y2)
end

function GiftController:checkContact(a, b, collision)
    return Gift.beginContact(a, b, collision)
end

return GiftController