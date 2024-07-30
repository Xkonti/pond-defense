template game*(gameLoopCode: untyped) =
  proc main =
    gameLoopCode
  main()

template gameSetup*(setupCode: untyped) =
  initWindow(screenWidth, screenHeight, windowName)
  defer: closeWindow()
  setupCode
  setTargetFPS(targetFramerate) # Set desired framerate (frames-per-second)

template gameLoop*(loopCode: untyped) =
  while not windowShouldClose():
    loopCode

template update*(updateCode: untyped) =
  updateCode

template draw*(drawCode) =
  beginDrawing()
  drawCode
  endDrawing()

template deinitialize*(deinitCode: untyped) =
  deinitCode


proc isInBounds*(minX, maxX, minY, maxY: int32, pos: Vector2i): bool =
  pos.x >= minX and pos.x <= maxX and pos.y >= minY and pos.y <= maxY

proc isInBounds*(rect: Rectangle, pos: Vector2): bool =
  isInBounds(rect.x.int32, rect.x.int32 + rect.width.int32, rect.y.int32, rect.y.int32 + rect.height.int32, pos.to2I)
  
proc isInBounds*(rect: Rectangle, pos: Vector2i): bool =
  isInBounds(rect.x.int32, rect.x.int32 + rect.width.int32, rect.y.int32, rect.y.int32 + rect.height.int32, pos)


proc isInMapBounds*(pos: Vector2i): bool =
  isInBounds(0, mapSize.x - 1, 0, mapSize.y - 1, pos)