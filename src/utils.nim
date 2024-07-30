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

type
  Vector2i* = tuple
    x, y: int

proc to2I*(v: Vector2): Vector2i =
  (x: v.x.int, y: v.y.int)

proc to2F*(v: Vector2i): Vector2 =
  Vector2(x: v.x.float32, y: v.y.float32)