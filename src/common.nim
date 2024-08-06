type
  Vector2i* = tuple
    x, y: int32

proc `+`*(v: Vector2i, other: Vector2): Vector2i =
  (x: v.x + other.x.int32, y: v.y + other.y.int32)

proc `+`*(v: Vector2i, other: Vector2i): Vector2i =
  (x: v.x + other.x, y: v.y + other.y)

proc `+`*(v: Vector2, other: Vector2i): Vector2 =
  Vector2(x: v.x + other.x.float32, y: v.y + other.y.float32)

proc `*`*(v: Vector2i, other: int32): Vector2i =
  (x: v.x * other, y: v.y * other)

proc `*`*(v: Vector2, other: float32): Vector2 =
  Vector2(x: v.x * other, y: v.y * other)


proc to2I*(v: Vector2): Vector2i =
  (x: v.x.int32, y: v.y.int32)

proc to2F*(v: Vector2i): Vector2 =
  Vector2(x: v.x.float32, y: v.y.float32)

type
  Direction* = enum
    Up, Right, Down, Left
  PatternDirection* = enum
    None, North, NorthEast, East, SouthEast, South, SouthWest, West, NorthWest

proc reverse*(direction: Direction): Direction =
  case direction:
  of Up:
    Down
  of Right:
    Left
  of Down:
    Up
  of Left:
    Right

proc toOffset*(direction: Direction): Vector2i =
  case direction:
  of Up:
    (x: 0, y: -1)
  of Right:
    (x: 1, y: 0)
  of Down:
    (x: 0, y: 1)
  of Left:
    (x: -1, y: 0)

proc toOffset*(dir: PatternDirection): Vector2i =
  case dir:
  of None:
    (x: 0, y: 0)
  of North:
    (x: 0, y: -1)
  of NorthEast:
    (x: 1, y: -1)
  of East:
    (x: 1, y: 0)
  of SouthEast:
    (x: 1, y: 1)
  of South:
    (x: 0, y: 1)
  of SouthWest:
    (x: -1, y: 1)
  of West:
    (x: -1, y: 0)
  of NorthWest:
    (x: -1, y: -1)