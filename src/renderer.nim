const tileSize = 64
const halfTileSize = tileSize / 2

proc drawFrog*(position: Vector2, rotation: Direction) =
  let pos = position + Vector2(x: halfTileSize, y: halfTileSize)
  drawCircle(pos, halfTileSize - 4, Green)
  var eyeLeftPos = pos
  var eyeRightPos = pos
  case rotation:
  of Up:
    eyeLeftPos += Vector2(x: -10, y: -20)
    eyeRightPos += Vector2(x: 10, y: -20)
  of Right:
    eyeLeftPos += Vector2(x: 20, y: -10)
    eyeRightPos += Vector2(x: 20, y: 10)
  of Down:
    eyeLeftPos += Vector2(x: 10, y: 20)
    eyeRightPos += Vector2(x: -10, y: 20)
  of Left:
    eyeLeftPos += Vector2(x: -20, y: 10)
    eyeRightPos += Vector2(x: -20, y: -10)
  drawCircle(eyeLeftPos, 8, White)
  drawCircle(eyeLeftPos, 4, Black)
  drawCircle(eyeRightPos, 8, White)
  drawCircle(eyeRightPos, 4, Black)


proc drawGround*(startPos: Vector2, sizeInTiles: Vector2i) =

  for x in 0 ..< sizeInTiles.x:
    for y in 0 ..< sizeInTiles.y:
      let pos = startPos + Vector2(x: (x * tileSize + 2).float32, y: (y * tileSize + 2).float32)
      drawRectangle(pos, Vector2(x: tileSize - 4, y: tileSize - 4), Gray)
