type
  Vector2i* = tuple
    x, y: int32

proc `+`*(v: Vector2i, other: Vector2): Vector2i =
  (x: v.x + other.x.int32, y: v.y + other.y.int32)

proc `+`*(v: Vector2i, other: Vector2i): Vector2i =
  (x: v.x + other.x, y: v.y + other.y)

proc `+`*(v: Vector2, other: Vector2i): Vector2 =
  Vector2(x: v.x + other.x.float32, y: v.y + other.y.float32)



proc to2I*(v: Vector2): Vector2i =
  (x: v.x.int32, y: v.y.int32)

proc to2F*(v: Vector2i): Vector2 =
  Vector2(x: v.x.float32, y: v.y.float32)

type
  Direction* = enum
    Up, Right, Down, Left

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