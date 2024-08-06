

var
  frogStartPosition: Vector2i = (x: (mapSize.x / 2).int32, y: mapSize.y - 1)
  frogPosition: Vector2i = frogStartPosition
  frogDirection = Direction.Up
  frogMoisture = 1.0 # max is 1.0
  frogSatiety = 1.0 # max is 1.0
  isFrogDead = true
  isTongueOpen = false
  maxTongueLength = 3
  tongueLength = 1

  frogTexIdle: Texture2D
  frogTexStep1: Texture2D
  frogTexStep2: Texture2D
  tongueTexStart: Texture2D
  tongueTexMiddle: Texture2D
  tongueTexEnd: Texture2D


proc loadFrogResources() =
  frogTexIdle = loadTexture("assets/frog_still.png")
  frogTexStep1 = loadTexture("assets/frog_move_1.png")
  frogTexStep2 = loadTexture("assets/frog_move_2.png")
  tongueTexStart = loadTexture("assets/frog_tongue_start.png")
  tongueTexMiddle = loadTexture("assets/frog_tongue_full.png")
  tongueTexEnd = loadTexture("assets/frog_tongue_end.png")


proc frogSolidCollisionChecker(pos: Vector2i): SolidCollisionData =
  if pos == frogPosition:
    return SolidCollisionData(isHit: true, isStuck: false)
  return SolidCollisionData(isHit: false, isStuck: false)

registerSolidCollisionChecker(frogSolidCollisionChecker)

proc resetFrog() =
  frogPosition = frogStartPosition
  frogDirection = Direction.Up
  frogMoisture = 1.0
  frogSatiety = 1.0


proc drawTheFrog() =
  let frogTexPos = frogPosition.adjustTilePosByDirection(frogDirection).toScreenCoords
  drawTexture(frogTexIdle, frogTexPos, 90'f32 * frogDirection.float32, 2.0, White)
  # TODO: Draw the animations of the step between


proc drawTongue() =
  let tonguePos = frogPosition.adjustTilePosByDirection(frogDirection)
  for i in 0 .. tongueLength:
    let pos = (tonguePos + (frogDirection.toOffset() * i.int32)).toScreenCoords
    let tex =
      if i == 0:
        addr tongueTexStart
      elif i == tongueLength:
        addr tongueTexEnd
      else:
        addr tongueTexMiddle
    drawTexture(tex[], pos, 90'f32 * frogDirection.float32, 2.0, White)


proc drawFrog() =
  if isTongueOpen:
    drawTongue()
  drawTheFrog()