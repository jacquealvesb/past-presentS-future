local Sound = {active = {}, source = {}}

function Sound:init(id, source, soundType)
    assert(self.source[id] == nil, "Sound already exists")
    self.source[id] = love.audio.newSource(source, soundType)
end

function Sound:play(id, channel, volume, loop)
    local channel = channel or "default"
    local clone = Sound.source[id]:clone()

    clone:setVolume(volume or 1)
    clone:setLooping(loop or false)
    clone:play()

    if Sound.active[channel] == nil then
        Sound.active[channel] = {}
    end

    table.insert(Sound.active[channel], clone)
end

function Sound:stop(channel)
    assert(self.source[id] == nil, "Channel does not exist")
    for k, sound in pairs(Sound.active[channel]) do
        sound:stop()
    end
end

function Sound:update()
    for k, channel in pairs(Sound.active) do
        if channel[1] == nil and not channel[1]:isPlaying() then
            table.remove(channel, 1)
        end
    end
end

return Sound