type
  TrashVariant* = enum
    Can, Box

  TrashData* = ref object
    position*: Vector2i
    step: int
    variant: TrashVariant
    isStuck: bool
    isKicked: bool
    kickDirection: Direction

const trashMovementPatterns: array[TrashVariant, seq[PatternDirection]] = [
  Can: @[SouthWest, SouthWest, None, None, SouthEast, SouthEast, None, None],
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

proc trashKickAction(direction: Direction, data: TrashData) =
  # If the trash is at the pond, don't let it move
  if data.position.y == mapSize.y - 1:
    return
  # If not in pond, make it flyyyyyy
  data.isStuck = false
  data.isKicked = true
  data.kickDirection = direction

proc trashLickAction(direction: Direction, data: TrashData) =
  # If the trash is at the pond, don't let it move
  if data.position.y == mapSize.y - 1:
    return
  # If not in pond, make it move towards the frog 1 tile
  data.isStuck = false
  let newPosition = data.position + direction.reverse().toOffset()
  # Check if possible to move to the new position
  let collisionData = checkSolidCollision(newPosition)
  if not collisionData.isHit:
    data.position = newPosition

proc trashSolidCollisionChecker(pos: Vector2i): SolidCollisionData =
  for index, trashData in trashCans:
    if trashData.position == pos:
      let data = trashData
      return SolidCollisionData(isHit: true, isStuck: trashData.isStuck, commandHandler: SolidEntityCommands(
        kick: proc(direction: Direction) = trashKickAction(direction, data),
      ))
  for index, trashData in trashBoxes:
    if trashData.position == pos:
      let data = trashData
      return SolidCollisionData(isHit: true, isStuck: trashData.isStuck, commandHandler: SolidEntityCommands(
        kick: proc(direction: Direction) = trashKickAction(direction, data),
      ))
  return SolidCollisionData(isHit: false, isStuck: false, commandHandler: emptySolidEntityCommands)

registerSolidCollisionChecker(trashSolidCollisionChecker)

proc trashTongueCollisionChecker(pos: Vector2i): TongueCollisionData =
  for index, trashData in trashCans:
    if trashData.position == pos:
      let data = trashData
      return TongueCollisionData(isHit: true, isStuck: trashData.isStuck, isFood: false, commandHandler: TongueEntityCommands(
        lick: proc(direction: Direction) = trashLickAction(direction, data),
      ))
  for index, trashData in trashBoxes:
    if trashData.position == pos:
      let data = trashData
      return TongueCollisionData(isHit: true, isStuck: trashData.isStuck, isFood: false, commandHandler: TongueEntityCommands(
        lick: proc(direction: Direction) = trashLickAction(direction, data),
      ))
  return TongueCollisionData(isHit: false, isStuck: false, isFood: false, commandHandler: emptyTongueEntityCommands)

registerTongueCollisionChecker(trashTongueCollisionChecker)

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

  if trashData.isKicked:
    let newPosition = trashData.position + trashData.kickDirection.toOffset()
    let collisionData = if trashData.position != newPosition:
        checkSolidCollision(newPosition)
      else:
        SolidCollisionData(isHit: false, isStuck: false)
    if not collisionData.isHit:
      trashData.position = newPosition
    else:
      trashData.isKicked = false
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
  