#[
      Solids  Fly
Solids  X         
Tongue  X     X    

Solids are things like frog and trash
Tongue is the tongue of the frog
]#

type
  CollisionLayer* = enum
    Solids, Tongue

  SolidEntityCommands* = ref object
    kick*: proc(direction: Direction)

  TongueEntityCommands* = ref object
    lick*: proc(direction: Direction)

  SolidCollisionData* = object
    isHit*: bool
    isStuck*: bool
    commandHandler*: SolidEntityCommands

  TongueCollisionData* = object
    isHit*: bool
    isStuck*: bool
    isFood*: bool
    commandHandler*: TongueEntityCommands

  SolidCollisionChecker* = proc(pos: Vector2i): SolidCollisionData
  TongueCollisionChecker* = proc(pos: Vector2i): TongueCollisionData

var solidColissionCheckers: seq[SolidCollisionChecker] = @[]
var tongueCollisionCheckers: seq[TongueCollisionChecker] = @[]

let emptySolidEntityCommands = SolidEntityCommands(
  kick: proc(direction: Direction) = discard,
)

let emptyTongueEntityCommands = TongueEntityCommands(
  lick: proc(direction: Direction) = discard,
)

proc registerSolidCollisionChecker*(checker: SolidCollisionChecker) =
  solidColissionCheckers.add(checker)

proc registerTongueCollisionChecker*(checker: TongueCollisionChecker) =
  tongueCollisionCheckers.add(checker)

proc checkSolidCollision*(pos: Vector2i): SolidCollisionData =
  for checker in solidColissionCheckers:
    let collisionData = checker(pos)
    if collisionData.isHit:
      return collisionData

  return SolidCollisionData(isHit: false, isStuck: false)

proc checkTongueCollision*(pos: Vector2i): TongueCollisionData =
  for checker in tongueCollisionCheckers:
    let collisionData = checker(pos)
    if collisionData.isHit:
      return collisionData

  return TongueCollisionData(isHit: false, isStuck: false, isFood: false)