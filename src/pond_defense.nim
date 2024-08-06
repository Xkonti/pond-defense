import raylib, raymath
import std/[math, random, sequtils]

randomize()

include common
include constants
include utils

include collisions
include renderer
include entities/frog
include entities/fly
include entities/trash

# ----------------------------------------------------------------------------------------
# Program main entry point
# ----------------------------------------------------------------------------------------

game:
  # Initialization
  # --------------------------------------------------------------------------------------
  gameSetup:
    # Init more stuff here
    var turn = 0
    loadTerrainResources()
    loadFrogResources()
    loadFlyResources()
    loadTrashResources()
    
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

      # Kicking
      if isKeyPressed(Space):
        isKicking = true
        let kickDirection = frogDirection.reverse()
        let kickPosition = frogPosition + kickDirection.toOffset()
        let collisionData = checkSolidCollision(kickPosition)
        if collisionData.isHit:
          collisionData.commandHandler.kick(kickDirection)
        frogSatiety -= satietyKickCost

      elif isKeyReleased(Space):
        isKicking = false
        playerTookAction = true

      # Movement
      var playerMoved = true
      if not isTongueOpen and not isKicking: # Block movement when tongue is open or when kicking
        if isKeyPressed(Up):
          if frogDirection != Direction.Up:
            frogDirection = Direction.Up
          elif frogPosition.y > 0 and not checkSolidCollision(frogPosition + Direction.Up.toOffset).isHit:
            frogPosition.y -= 1
        elif isKeyPressed(Down):
          if frogDirection != Direction.Down:
            frogDirection = Direction.Down
          elif frogPosition.y < mapSize.y - 1 and not checkSolidCollision(frogPosition + Direction.Down.toOffset).isHit:
            frogPosition.y += 1
        elif isKeyPressed(Left):
          if frogDirection != Direction.Left:
            frogDirection = Direction.Left
          elif frogPosition.x > 0 and not checkSolidCollision(frogPosition + Direction.Left.toOffset).isHit:
            frogPosition.x -= 1
        elif isKeyPressed(Right):
          if frogDirection != Direction.Right:
            frogDirection = Direction.Right
          elif frogPosition.x < mapSize.x - 1 and not checkSolidCollision(frogPosition + Direction.Right.toOffset).isHit:
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

        # Process fly entities
        for flyData in flies:
          flyData.move()
        flies = flies.filterIt(isInMapBounds(it.position))
          
        flySpawnTimer = (flySpawnTimer + 1) mod flySpawnInterval
        if flySpawnTimer == 0 and flies.len < maxFlyCount:
          let newFly = newFly(rand(0'i32..flySpawnMaxY).int32)
          flies.add(newFly)

        # Process trash can entities
        for trashCanData in trashCans:
          trashCanData.move()
        trashCans = trashCans.filterIt(isInMapBounds(it.position)) # Things might roll sideways

        dec trashCanSpawnTimer
        if trashCanSpawnTimer == 0:
          let newCan = newTrashCan(rand(1'i32..mapSize.x - 1'i32).int32)
          trashCans.add(newCan)
          trashCanSpawnTimer = rand(trashCanMinSpawnInterval..trashCanMaxSpawnInterval)

        # Process trash box entities
        for trashBoxData in trashBoxes:
          trashBoxData.move()
        trashBoxes = trashBoxes.filterIt(isInMapBounds(it.position)) # Things might roll sideways

        dec trashBoxSpawnTimer
        if trashBoxSpawnTimer == 0:
          let newBox = newTrashBox(rand(1'i32..mapSize.x - 1'i32).int32)
          trashBoxes.add(newBox)
          trashBoxSpawnTimer = rand(trashBoxMinSpawnInterval..trashBoxMaxSpawnInterval)

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
          resetFrog()
          flies = @[]
          trashCans = @[]
          trashBoxes = @[]
          isFrogDead = false
      else:
        # Draw world
        drawGround(gridOriginScreenSpace, mapSize)
        
        for trashCanData in trashCans:
          drawTrashCan(trashCanData.position)

        for trashBoxData in trashBoxes:
          drawTrashBox(trashBoxData.position)

        drawFrog()

        # Draw flies last so they are on top
        for flyData in flies:
          drawFly(flyData.position)

        # Draw UI
        drawMeter(Rectangle(x: 10, y: 10, width: 250, height: 20), frogMoisture, 1.0, Blue)
        drawMeter(Rectangle(x: 10, y: 40, width: 250, height: 20), frogSatiety, 1.0, Yellow)

      drawFPS(screenWidth - 100, 10)
    
  deinitialize:
    discard