type
  FlyData* = object
    position*: Vector2i
    step: int
    isLeft: bool

const flyMovementPatternLeft = [
  Left, Down, Left, Up, Right, Down, Down
]

const flyMovementPatternRight = [
  Right, Down, Right, Up, Left, Down, Down
]

proc newFly*(positionY: int32): FlyData =
  let direction = rand(0..1)
  let isLeft = direction == 0
  let posX = if isLeft: mapSize.x - 1 else: 0
  result = FlyData(
    position: (x: posX.int32, y: positionY),
    step: 0,
    isLeft: isLeft)

proc move*(fly: var FlyData) =
  let movementPattern = if fly.isLeft: flyMovementPatternLeft else: flyMovementPatternRight
  fly.position = fly.position + movementPattern[fly.step].toOffset()
  fly.step = (fly.step + 1) mod movementPattern.len
