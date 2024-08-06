var
  grassTex: Texture2D
  pondTex: Texture2D

proc loadTerrainResources() =
  grassTex = loadTexture("assets/tile_grass.png")
  pondTex = loadTexture("assets/tile_pond.png")

proc toTileCenter(position: Vector2): Vector2 =
  position + Vector2(x: halfTileSize, y: halfTileSize)

proc adjustTilePosByDirection(pos: Vector2i, direction: Direction): Vector2i =
  case direction:
  of Up:
    return pos
  of Right:
    return pos + (x: 1'i32, y: 0'i32)
  of Down:
    return pos + (x: 1'i32, y: 1'i32)
  of Left:
    return pos + (x: 0'i32, y: 1'i32)

proc drawGround*(startPos: Vector2, sizeInTiles: Vector2i) =

  # Draw grass
  for x in 0 ..< sizeInTiles.x:
    for y in 0 ..< sizeInTiles.y - 1:
      let pos = startPos + Vector2(x: (x * tileSize + 2).float32, y: (y * tileSize + 2).float32)
      drawTexture(grassTex, pos, 0'f32, 2.0, White)

  # Draw water
  for x in 0 ..< sizeInTiles.x:
    let pos = startPos + Vector2(x: (x * tileSize + 2).float32, y: ((sizeInTiles.y - 1) * tileSize + 2).float32)
    drawTexture(pondTex, pos, 0'f32, 2.0, White)

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