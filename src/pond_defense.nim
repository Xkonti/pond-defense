import raylib, raymath
import std/[math, random, sequtils]

randomize()

include common
include constants
include utils


include renderer
include entities/fly
# ----------------------------------------------------------------------------------------
# Global Variables Definition
# ----------------------------------------------------------------------------------------



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
    var turn = 0
    var frogStartPosition: Vector2i = (x: (mapSize.x / 2).int32, y: mapSize.y - 1)
    var frogPosition: Vector2i = frogStartPosition
    var frogDirection = Direction.Up
    var frogMoisture = 1.0 # max is 1.0
    var frogSatiety = 1.0 # max is 1.0
    var isFrogDead = true
    var isTongueOpen = false
    var maxTongueLength = 3
    var tongueLength = 1

    var maxFlyCount: int = 2
    var flySpawnInterval = 10'i32
    var flySpawnTimer = 0'i32
    var flySpawnMaxY = (mapSize.y / 2).int32
    var flies: seq[FlyData] = @[]
    
  gameLoop:
   
    update:

      ## Handle user input
      
      var playerTookAction = false # Used to determine if the player took an action that move the time forward

      # Licking
      if isKeyPressed(Z):
        isTongueOpen = true
        # Calculate possible length
        tongueLength = 0
        var currentCheckPos = frogPosition
        var isHit = false
        while not isHit and tongueLength < maxTongueLength:
          tongueLength += 1
          currentCheckPos = currentCheckPos + frogDirection.toOffset()
          for index, flyData in flies:
            if currentCheckPos == flyData.position:
              frogSatiety = 1.0
              isHit = true
              flies.delete(index)
              break
        
        if not isHit:
          frogSatiety -= satietyLickCost
        
      elif isKeyReleased(Z):
        isTongueOpen = false
        playerTookAction = true

      # TODO: Kicking

      # Movement
      var playerMoved = true
      if not isTongueOpen: # Block movement when tongue is open
        if isKeyPressed(Up):
          if frogDirection != Direction.Up:
            frogDirection = Direction.Up
          elif frogPosition.y > 0:
            frogPosition.y -= 1
        elif isKeyPressed(Down):
          if frogDirection != Direction.Down:
            frogDirection = Direction.Down
          elif frogPosition.y < mapSize.y - 1:
            frogPosition.y += 1
        elif isKeyPressed(Left):
          if frogDirection != Direction.Left:
            frogDirection = Direction.Left
          elif frogPosition.x > 0:
            frogPosition.x -= 1
        elif isKeyPressed(Right):
          if frogDirection != Direction.Right:
            frogDirection = Direction.Right
          elif frogPosition.x < mapSize.x - 1:
              frogPosition.x += 1
        else:
          playerMoved = false
      else:
        playerMoved = false

      if playerMoved:
        playerTookAction = true
        frogMoisture -= moistureLoss
        frogSatiety -= satietyMovementCost

      # If the player took an action, increment the time
      if playerTookAction:
        turn += 1

        # Process entities
        for flyData in flies.mitems:
          flyData.move()
        flies = flies.filterIt(isInMapBounds(it.position))
          
        flySpawnTimer = (flySpawnTimer + 1) mod flySpawnInterval
        if flySpawnTimer == 0 and flies.len < maxFlyCount:
          let newFly = newFly(rand(0'i32..flySpawnMaxY).int32)
          flies.add(newFly)


      # If frog is in the pond, refill moisture
      if frogPosition.y == mapSize.y - 1:
        frogMoisture = 1.0

      # Detect if the frog is dead
      if frogMoisture <= 0:
        isFrogDead = true
      if frogSatiety <= 0:
        isFrogDead = true

    draw:
      clearBackground(Black)
      
      if isFrogDead:
        drawText("You died!", 10, 10, 20, Red)
        if (drawButton(Rectangle(x: screenWidth / 2 - 200, y: screenHeight / 2 - 15, width: 400, height: 30), "Play again")):
          frogPosition = frogStartPosition
          frogDirection = Direction.Up
          frogMoisture = 1.0
          frogSatiety = 1.0
          flies = @[]
          isFrogDead = false
      else:
        # Draw world
        drawGround(gridOriginScreenSpace, mapSize)
        if isTongueOpen:
          drawTongue(frogPosition.toScreenCoords, frogDirection, tongueLength)
        drawFrog(frogPosition.toScreenCoords, frogDirection)
        
        for flyData in flies:
          drawFly(flyData.position.toScreenCoords)

        # Draw UI
        drawMeter(Rectangle(x: 10, y: 10, width: 250, height: 20), frogMoisture, 1.0, Blue)
        drawMeter(Rectangle(x: 10, y: 40, width: 250, height: 20), frogSatiety, 1.0, Yellow)

      drawFPS(screenWidth - 100, 10)
    
  deinitialize:
    discard