coins = {}
coins.count = 0

function spawnCoin(x, y)

    local coin = {}
    coin = world:newCircleCollider(x, y, 15, {collision_class = "Collect"})
    coin:setType('static')
    coin.collected = false
    table.insert(coins, coin)
    

end

function updateCoins()
    for i,c in ipairs(coins) do
        --e.animation:update(dt)
        local cx, cy = c:getPosition()

        local colliders = world:queryCircleArea(cx, cy, 15, {'Player'})
        if #colliders > 0 then
            c.collected = true
            coins.count = coins.count + 1
        end
        local i = #coins
        while i > -1 do
            if coins[i] ~= nil and coins[i].collected == true then
                coins[i]:destroy()
                table.remove(coins, i)
            end
            i = i - 1
        end
    end
end

function drawCoins()
    for i,c in ipairs(coins) do
        local cx, cy = c:getPosition()
        love.graphics.draw(sprites.coinSheet, cx, cy, nil, nil, nil, 10, 20)
    end
end