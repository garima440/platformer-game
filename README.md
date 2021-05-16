# MY FINAL PROJECT
#### Video Demo:  <https://youtu.be/u4W9hcKed4I>
#### Description:

My project is basic platformer game using lua in LOV

# Contents

* [Introduction](#introduction)
* [main.lua](#main.lua)
* [enemy.lua](#enemy.lua)
* [player.lua](#player.lua)
* [coins.lua](#coins.lua)
* [Libraries-used](#libraries-used)

<br>

# Introduction

A simple very **basic platformer** made using lua in LOVE. The game entails navigating through two
levels and reaching big gem at the end while collecting blue gems on our way through.

<br>


# main.lua
The main.lua file have most of the basic but important functions. It includes all the libraries used.

<br>

## function love.load()
This function includes libraries. Create animations, sprites and include audios. Create different collision classes and initiates different variables and save data at different levels.

<br>

## function love.update()
Updates colliders, gamemap, player, enemies and gems(coins). Also takes care of scrolling screen using cam:lookat(). Takes care of changing levels when queried for circle area.

<br>

## function love.draw()
Draws background, prints number of gems collected on the screen. Prints various messages on the screen.

<br>

## function love.keypressed(key)
When space pressed, makes player jump.

<br>

## function spawnPlatform()
Spawns platforms, create chasms.

<br>

## function destroyAll()
Destroys preceeding level's platforms and spawned enemies.

<br>

## function loadMap()
Loads all the tiles and objects on the screen.

<br>

# enemy.lua
Creates a table of enemies.

<br>

## function spawnEnemy()
Each enemy has an attribute of direction, speed, animation.

<br>

## function updateEnemies()
Iterates over the table enemies, creates colliders for every enemy spawned, makes enemy move in to and fro motion.

<br>

## function drawEnemies()
Draws enemies to the screen

<br>

# player.lua
Initiates player coordinates. Creates it's collider. Sets it's attributes like speed, animation,
direction etc.

<br>

## function playerUpdate()
Takes in parameter dt. Takes care of player movement(right, left), check for colliders, landing of player on platforms.

<br>

## function drawPlayer()
Simply draws the player to the screen.

<br>

# coins.lua
Creates a table of coins(gems) to be collected.

<br>

## function spawnCoin()
Takes x and y coordinates as parameters to spawn gems. Creates colliders for gems to be drawn.

<br>

## function updateCoins()
Iterates over coins table quarrying for collision with player. Increase the score when collision happens, simultaneously removing gems from the table.

<br>

## function drawCoins()
Simply draws coins(gems) on the screen.

<br>

# Libraries Used
All of the libraries included in the project are from github:

1. anim8 (https://github.com/kikito/anim8.git)
2. hump (https://github.com/vrld/hump.git)
3. Simple-Tiled-Implementation (https://github.com/karai17/Simple-Tiled-Implementation.git)
4. windfield (https://github.com/a327ex/windfield.git)






