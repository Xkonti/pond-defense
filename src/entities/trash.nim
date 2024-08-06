type
  TrashVariant* = enum
    Can, Box

  TrashData* = ref object
    position*: Vector2i
    step: int
    variant: TrashVariant
    isStuck: bool

const trashMovementPatterns: array[TrashVariant, seq[PatternDirection]] = [
  Can: @[South, SouthWest, None, SouthEast, South, SouthEast, South, None, SouthWest],
  Box: @[None, South, None]
]


var
  trashCanMaxSpawnInterval = 30'i32
  trashCanMinSpawnInterval = 20'i32
  trashCanSpawnTimer: int32 = rand(trashCanMinSpawnInterval..trashCanMaxSpawnInterval)
  trashCans: seq[TrashData] = @[]

  trashBoxMaxSpawnInterval = 20'i32
  trashBoxMinSpawnInterval = 15'i32
  trashBoxSpawnTimer: int32 = rand(trashBoxMinSpawnInterval..trashBoxMaxSpawnInterval)
  trashBoxes: seq[TrashData] = @[]

  trashTexCan: Texture2D
  trashTexBox: Texture2D

proc loadTrashResources() =
  trashTexCan = loadTexture("assets/trash_can.png")
  trashTexBox = loadTexture("assets/trash_box.png")

proc trashSolidCollisionChecker(pos: Vector2i): SolidCollisionData =
  for trashData in trashCans:
    if trashData.position == pos:
      return SolidCollisionData(isHit: true, isStuck: trashData.isStuck)
  for trashData in trashBoxes:
    if trashData.position == pos:
      return SolidCollisionData(isHit: true, isStuck: trashData.isStuck)
  return SolidCollisionData(isHit: false, isStuck: false)

registerSolidCollisionChecker(trashSolidCollisionChecker)

proc newTrashCan(positionX: int32): TrashData =
  result = TrashData(
    position: (x: positionX, y: 0),
    step: rand(0..trashMovementPatterns[Can].len), 
    variant: Can,
    isStuck: false)

proc newTrashBox(positionX: int32): TrashData =
  result = TrashData(
    position: (x: positionX, y: 0),
    step: rand(0..trashMovementPatterns[Box].len), 
    variant: Box,
    isStuck: false)

proc move(trashData: TrashData) =
  if trashData.isStuck:
    return
  let movementPattern = trashMovementPatterns[trashData.variant]
  if trashData.step == movementPattern.len:
    dec trashData.step
  let newPosition = trashData.position + movementPattern[trashData.step].toOffset()
  let collisionData = if trashData.position != newPosition:
      checkSolidCollision(newPosition)
    else:
      SolidCollisionData(isHit: false, isStuck: false)
  if not collisionData.isHit:
    trashData.position = newPosition
    trashData.step = (trashData.step + 1) mod (movementPattern.len)

    # Has it reached the pond? Make it stuck!
    if (trashData.position.y == mapSize.y - 1):
      trashData.isStuck = true
  elif collisionData.isStuck:
    trashData.isStuck = true


proc drawTrashCan(position: Vector2i) =
  drawTexture(trashTexCan, position.toScreenCoords, 0'f32, 2.0, White)

proc drawTrashBox(position: Vector2i) =
  drawTexture(trashTexBox, position.toScreenCoords, 0'f32, 2.0, White)
  