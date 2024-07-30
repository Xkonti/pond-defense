type
  FlyData* = ref object
    position*: Vector2i
    step: int
    isLeft: bool

const flyMovementPatternLeft = [
  Left, Down, Left, Up, Right, Down, Down
]

const flyMovementPatternRight = [
  Right, Down, Right, Up, Left, Down, Down
]


var
  maxFlyCount: int = 2
  flySpawnInterval = 10'i32
  flySpawnTimer = 0'i32
  flySpawnMaxY = (mapSize.y / 2).int32
  flies: seq[FlyData] = @[]

proc flyTongueCollisionChecker(pos: Vector2i): TongueCollisionData =
  for flyData in flies:
    if flyData.position == pos:
      return TongueCollisionData(isHit: true, isStuck: false, isFood: true)

registerTongueCollisionChecker(flyTongueCollisionChecker)

proc newFly*(positionY: int32): FlyData =
  let direction = rand(0..1)
  let isLeft = direction == 0
  let posX = if isLeft: mapSize.x - 1 else: 0
  result = FlyData(
    position: (x: posX.int32, y: positionY),
    step: 0,
    isLeft: isLeft)

proc move*(fly: FlyData) =
  let movementPattern = if fly.isLeft: flyMovementPatternLeft else: flyMovementPatternRight
  fly.position = fly.position + movementPattern[fly.step].toOffset()
  fly.step = (fly.step + 1) mod movementPattern.len

proc drawFly(position: Vector2) =
  let pos = position.toTileCenter()
  drawCircle(pos + Vector2(x: -5, y: -5), 10, White)
  drawCircle(pos + Vector2(x: 5, y: -5), 10, White)
  drawCircle(pos + Vector2(x: -5, y: 5), 10, White)
  drawCircle(pos + Vector2(x: 5, y: 5), 10, White)
  drawRectangle(pos.x.int32 - 4, pos.y.int32 - 11, 8, 22, Black)