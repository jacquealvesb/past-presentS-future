local Camera = {
    x = 0,
    y = 0,
    scale = 2.5
}

function Camera:apply()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.scale(self.scale, self.scale)
end

function Camera:clear()
    love.graphics.pop()
end

return Camera