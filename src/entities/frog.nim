

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