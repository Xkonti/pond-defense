import raylib, raymath
import std/[math, random]
include common
include utils
include renderer

# ----------------------------------------------------------------------------------------
# Global Variables Definition
# ----------------------------------------------------------------------------------------

const
  screenWidth = 1920
  screenHeight = 1080
  targetFramerate = 60
  windowName = "Pond defense"
  mapSize: Vector2i = (x: 10, y: 16)
  gridOriginScreenSpace = Vector2(
    x: (screenWidth / 2) - (mapSize.x / 2) * tileSize,
    y: (screenHeight / 2) - (mapSize.y / 2) * tileSize
  )

proc toScreenCoords(position: Vector2i): Vector2 =
  return gridOriginScreenSpace + Vector2(x: position.x.float32 * tileSize, y: position.y.float32 * tileSize)

# ----------------------------------------------------------------------------------------
# Program main entry point
# ----------------------------------------------------------------------------------------

game:
  # Initialization
  # --------------------------------------------------------------------------------------
  gameSetup:
    # Init more stuff here
    var framesLeftToRotation = 60
    var frogPosition: Vector2i = (x: 0, y: 0)
    var frogDirection = Direction.Up
    randomize()
    
  gameLoop:
   
    update:
      ## Handle user input
      if isKeyPressed(Up):
        if frogDirection != Direction.Up:
          frogDirection = Direction.Up
        elif frogPosition.y > 0:
          frogPosition.y -= 1
      if isKeyPressed(Down):
        if frogDirection != Direction.Down:
          frogDirection = Direction.Down
        elif frogPosition.y < mapSize.y - 1:
          frogPosition.y += 1
      if isKeyPressed(Left):
        if frogDirection != Direction.Left:
          frogDirection = Direction.Left
        elif frogPosition.x > 0:
          frogPosition.x -= 1
      if isKeyPressed(Right):
        if frogDirection != Direction.Right:
          frogDirection = Direction.Right
        elif frogPosition.x < mapSize.x - 1:
            frogPosition.x += 1

    draw:
      clearBackground(Black)
      drawGround(gridOriginScreenSpace, mapSize)
      drawFrog(frogPosition.toScreenCoords, frogDirection)
      drawFPS(10, 10)
    
  deinitialize:
    discard