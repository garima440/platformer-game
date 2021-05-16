function love.load()
    love.window.setMode(1000, 768)


    anim8 = require 'libraries/anim8/anim8'
    sti = require 'libraries/Simple-Tiled-Implementation/sti'
    cameraFile = require 'libraries/hump/camera'

    cam = cameraFile()
    
    myFont = love.graphics.newFont("fonts/Pacifico.ttf", 30)
    --myfont = love.graphics.newFont("fonts/myfont.ttf", 30)

    sounds = {}
    sounds.jump = love.audio.newSource("audio/jump.wav", "static")
    sounds.music = love.audio.newSource("audio/music.mp3", "stream")
    sounds.music:setLooping(true)
    sounds.music:setVolume(0.3)
    sounds.music:play()

    sprites = {}
    sprites.playerSheet = love.graphics.newImage('sprites/spritesheet.png')
    sprites.enemySheet = love.graphics.newImage('sprites/ghost.png')
    sprites.background = love.graphics.newImage('sprites/BG.png')
    sprites.coinSheet = love.graphics.newImage('maps/coin.png')


    local grid = anim8.newGrid(416, 454, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())
    local enemyGrid = anim8.newGrid(102, 90, sprites.enemySheet:getWidth(), sprites.enemySheet:getHeight())
    --local collectibleGrid = anim8.newGrid(32, 32, sprites.collectibleSheet:getWidth(), sprites.enemySheet:getHeight())

    animations = {}
    animations.idle = anim8.newAnimation(grid('1-7', 1), 0.08)
    animations.jump = anim8.newAnimation(grid('8-17', 1), 0.08)
    animations.run = anim8.newAnimation(grid('18-27', 1), 0.08)
    animations.enemy = anim8.newAnimation(enemyGrid('4-10', 1), 0.9)
    --animations.collectible = anim8.newAnimation(collectibleGrid('1-2', 1), 1)

    wf = require 'libraries/windfield/windfield'
    world = wf.newWorld(0, 800, false)
    world:setQueryDebugDrawing(true)

    world:addCollisionClass('Platform')
    world:addCollisionClass('Player' --[[{ignores = {'Platform'}}]])
    world:addCollisionClass('Danger')
    world:addCollisionClass('Collect', {ignores = {'Player'}})
    

    require('player')

    require('enemy')
    require('coins')

    require('libraries/show')

    dangerZone = world:newRectangleCollider(-500, 800, 6000, 50, {collision_class = "Danger"})
    dangerZone:setType('static')

    platforms = {}
    

    gemX = 0
    gemY = 0


    score = 0

    saveData = {}
    saveData.currentLevel = "level1"

    if love.filesystem.getInfo("data.lua") then
        local data = love.filesystem.load("data.lua")
        data()
    end

    loadMap(saveData.currentLevel)
    --spawnCoins()

end

function love.update(dt)

    world:update(dt)
    gameMap:update(dt)
    playerUpdate(dt)
    updateEnemies(dt)
    updateCoins()
    local px, py = player:getPosition()

    cam:lookAt(px, love.graphics.getHeight()/2)

    local colliders = world:queryCircleArea(gemX, gemY, 10, {"Player"})
    if #colliders > 0 then
        if saveData.currentLevel == "level1" then
            loadMap("level2")
        elseif saveData.currentLevel == "level2" then
            loadMap("level1")
        end
    end

end

function love.draw()

    love.graphics.draw(sprites.background, 0, 0, nil, 0.5, 0.5)
    love.graphics.setFont(myFont) 
    love.graphics.printf("GEMS:  ".. coins.count, 0, 0, love.graphics.getWidth() / 2 - 100, "left")

    cam:attach()
        gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
        --world:draw()
        drawPlayer()
        drawEnemies()
        drawCoins()
    
        if saveData.currentLevel == "level1" then
            love.graphics.setFont(myFont) 
            love.graphics.printf("Hi! I am Garima. Welcome to my Final Project!", 0, 0, love.graphics.getWidth() / 2 - 100, "left")
            love.graphics.printf("We just have to navigate through the levels and reach the Gem at the end.", 800, 0, love.graphics.getWidth() / 2 - 100, "left")
            --love.graphics.printf(coins.count, 0, 0, love.graphics.getWidth() / 2 - 100, "left")
            love.graphics.printf("Beware of ghosts!", 1600, 0, love.graphics.getWidth() / 2 - 100, "left")
            love.graphics.printf("See this Gem at the end? Let's grab it!", 2600, 0, love.graphics.getWidth() / 2 - 100, "left")
        end
        if saveData.currentLevel == "level2" then
            love.graphics.setFont(myFont) 
            love.graphics.printf("THIS IS LEVEL 2!", 0, 40, love.graphics.getWidth() / 2 - 100, "left")
            love.graphics.printf("LET'S GRAB THE FINAL GEM!!", 800, 0, love.graphics.getWidth() / 2 - 100, "left")
            love.graphics.printf("OKAY! SO THIS IS IT. THANK YOU FOR VISITING!", 3200, 40, love.graphics.getWidth() / 2 - 100, "left")
            love.graphics.printf("THANK YOU CS50!", 2800, 40, love.graphics.getWidth() / 2 - 100, "left")
        end
        --local colliders = world:queryCircleArea(collectiblesX, collectiblesY, 15, {"Player"})
        --if #colliders > 0 then
           -- if 
        --end
    cam:detach()

end

function love.keypressed(key)
    if key == 'space' then
        if player.grounded then
            player:applyLinearImpulse(0, -4800)
            sounds.jump:play()
        end
    end
    if key == 'r' then
        loadMap("level2")
    end

end

function love.mousepressed(x, y, button)
    if button == 1 then
        local colliders = world:queryCircleArea(x, y, 200, {'Platform', 'Danger'})
        for i,c in ipairs(colliders) do
            c:destroy()
        end
    end
end


function spawnPlatform(x, y, width, height)
    local platform = world:newRectangleCollider(x, y, width, height, {collision_class = "Platform"})
    platform:setType('static')
    table.insert(platforms, platform)
end


function destroyAll()
    local i = #platforms
    while i > -1 do
        if platforms[i] ~= nil then
            platforms[i]:destroy()
        end
        table.remove(platforms, i)
        i = i - 1
    end

    local i = #enemies
    while i > -1 do
        if enemies[i] ~= nil then
            enemies[i]:destroy()
        end
        table.remove(enemies, i)
        i = i - 1
    end
end

function loadMap(mapName)
    saveData.currentLevel = mapName
    love.filesystem.write("data.lua", table.show(saveData, "saveData"))
    
    
    destroyAll()
    gameMap = sti("maps/" .. mapName .. ".lua")
    
    for i , obj in pairs(gameMap.layers["Start"].objects) do
        playerStartX = obj.x
        playerStartY = obj.y
    end
    player:setPosition(playerStartX, playerStartY)

    for i , obj in pairs(gameMap.layers["Platforms"].objects) do
        spawnPlatform(obj.x, obj.y, obj.width, obj.height)

    end

    for i , obj in pairs(gameMap.layers["Enemies"].objects) do
        spawnEnemy(obj.x, obj.y)
    end

    for i , obj in pairs(gameMap.layers["Gem"].objects) do
        gemX = obj.x
        gemY = obj.y
    end

    for i , obj in pairs(gameMap.layers["Coins"].objects) do
        spawnCoin(obj.x, obj.y)
    end

end