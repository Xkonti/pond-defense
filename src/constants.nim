const
  screenWidth = 1920
  screenHeight = 1080
  targetFramerate = 60
  windowName = "Pond defense"

  tileSize = 64
  halfTileSize = tileSize / 2

  mapSize: Vector2i = (x: 10, y: 16)
  gridOriginScreenSpace = Vector2(
    x: (screenWidth / 2) - (mapSize.x / 2) * tileSize,
    y: (screenHeight / 2) - (mapSize.y / 2) * tileSize
  )

  moistureLoss = 0.02
  satietyMovementCost = 0.02
  satietyKickCost = 0.06
  satietyLickCost = 0.04