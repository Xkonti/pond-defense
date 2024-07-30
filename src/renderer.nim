proc toTileCenter(position: Vector2): Vector2 =
  position + Vector2(x: halfTileSize, y: halfTileSize)

proc drawFrog*(position: Vector2, rotation: Direction) =
  let pos = position.toTileCenter()
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


proc drawFly(position: Vector2) =
  let pos = position.toTileCenter()
  drawCircle(pos + Vector2(x: -5, y: -5), 10, White)
  drawCircle(pos + Vector2(x: 5, y: -5), 10, White)
  drawCircle(pos + Vector2(x: -5, y: 5), 10, White)
  drawCircle(pos + Vector2(x: 5, y: 5), 10, White)
  drawRectangle(pos.x.int32 - 4, pos.y.int32 - 11, 8, 22, Black)

proc drawTongue(startPos: Vector2, direction: Direction, lengthInTiles: int) =
  const tongueWidth = 4
  const halfTongueWidth = (tongueWidth / 2).int32
  let pos = startPos.toTileCenter()
  var bounds: Rectangle
  var tipPos: Vector2
  case direction:
  of Up:
    bounds = Rectangle(x: pos.x - halfTongueWidth.float32, y: pos.y - (lengthInTiles * tileSize).float32, width: tongueWidth.float32, height: lengthInTiles.float32 * tileSize)
    tipPos = Vector2(x: pos.x, y: pos.y - (lengthInTiles * tileSize).float32)
  of Right:
    bounds = Rectangle(x: pos.x.float32, y: pos.y - halfTongueWidth.float32, width: lengthInTiles.float32 * tileSize, height: tongueWidth.float32)
    tipPos = Vector2(x: pos.x + (lengthInTiles * tileSize).float32, y: pos.y)
  of Down:
    bounds = Rectangle(x: pos.x - halfTongueWidth.float32, y: pos.y.float32, width: tongueWidth.float32, height: lengthInTiles.float32 * tileSize)
    tipPos = Vector2(x: pos.x, y: pos.y + (lengthInTiles * tileSize).float32)
  of Left:
    bounds = Rectangle(x: pos.x - (lengthInTiles * tileSize).float32, y: pos.y - halfTongueWidth.float32, width: lengthInTiles.float32 * tileSize, height: tongueWidth.float32)
    tipPos = Vector2(x: pos.x - (lengthInTiles * tileSize).float32, y: pos.y)

  drawRectangle(bounds, Red)
  drawCircle(tipPos, 4, Red)

proc drawGround*(startPos: Vector2, sizeInTiles: Vector2i) =

  for x in 0 ..< sizeInTiles.x:
    for y in 0 ..< sizeInTiles.y - 1:
      let pos = startPos + Vector2(x: (x * tileSize + 2).float32, y: (y * tileSize + 2).float32)
      drawRectangle(pos, Vector2(x: tileSize - 4, y: tileSize - 4), Gray)

  for x in 0 ..< sizeInTiles.x:
    let pos = startPos + Vector2(x: (x * tileSize + 2).float32, y: ((sizeInTiles.y - 1) * tileSize + 2).float32)
    drawRectangle(pos, Vector2(x: tileSize - 4, y: tileSize - 4), Blue)

proc drawMeter*(screenBounds: Rectangle, value: float32, maxValue: float32, color: Color) =
  const borderWidth = 2
  drawRectangle(screenBounds, White)
  drawRectangle(
    screenBounds.x.int32 + borderWidth,
    screenBounds.y.int32 + borderWidth,
    screenBounds.width.int32 - (borderWidth * 2),
    screenBounds.height.int32 - (borderWidth * 2),
    Black)

  
  let scale = 1.0 / maxValue # Calculate the multiplier to scale the max value to 1.0
  let scaledValue = value * scale # Scale the value to the range 0.0 to 1.0
  let barWidth = (screenBounds.width - (borderWidth * 2).float32) * scaledValue
  drawRectangle(
    screenBounds.x.int32 + borderWidth,
    screenBounds.y.int32 + borderWidth,
    barWidth.int32,
    screenBounds.height.int32 - (borderWidth * 2),
    color)

type
  ButtonState* = enum
    Normal, Hover, Clicked

proc drawButton*(bounds: Rectangle, text: string): bool =
  var state = ButtonState.Normal
  let mousePos = getMousePosition()
  let isHovered = mousePos.x >= bounds.x and mousePos.x <= bounds.x + bounds.width and mousePos.y >= bounds.y and mousePos.y <= bounds.y + bounds.height
  if isHovered:
    if isMouseButtonDown(MouseButton.Left) or isMouseButtonReleased(MouseButton.Left):
      state = ButtonState.Clicked
    else:
      state = ButtonState.Hover

    if isMouseButtonReleased(MouseButton.Left):
      result = true

  drawRectangle(bounds, Black)
  let bgColor = case state:
    of ButtonState.Normal: LightGray
    of ButtonState.Hover: White
    of ButtonState.Clicked: Yellow
  drawRectangle(
    bounds.x.int32 + 1,
    bounds.y.int32 + 1,
    bounds.width.int32 - 2,
    bounds.height.int32 - 2,
    bgColor)

  let textColor = case state:
    of ButtonState.Normal: Black
    of ButtonState.Hover: Black
    of ButtonState.Clicked: Black
  drawText(text, bounds.x.int32 + 10, bounds.y.int32 + 5, (bounds.height - 10).int32, textColor)