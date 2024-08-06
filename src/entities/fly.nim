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
  fliesForRemoval: seq[FlyData] = @[]

  flyTex: Texture2D

proc loadFlyResources() =
  flyTex = loadTexture("assets/fly.png")

proc removeDeadFlies() =
  for flyData in fliesForRemoval:
    for index, liveFlyData in flies:
      if flyData == liveFlyData:
        flies.delete(index)
        break
  fliesForRemoval = @[]

proc flyLickAction(direction: Direction, flyData: FlyData) =
  fliesForRemoval.add(flyData)

proc flyTongueCollisionChecker(pos: Vector2i): TongueCollisionData =
  for flyData in flies:
    if flyData.position == pos:
      let data = flyData
      return TongueCollisionData(isHit: true, isStuck: false, isFood: true, commandHandler: TongueEntityCommands(
        lick: proc(direction: Direction) = flyLickAction(direction, data)
      ))

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

proc drawFly(position: Vector2i) =
  drawTexture(flyTex, position.toScreenCoords, 0'f32, 2.0, White)