var
  showMenu = true

proc drawMenu(): bool =
  # Precalculate vertical button values
  const buttonHeight = 60
  const buttonGap = buttonHeight / 2
  const buttonsTotalHeight = buttonHeight * 2 + buttonGap
  const verticalStart = (screenHeight / 2) - (buttonsTotalHeight / 2)

  if isFrogDead:
    drawText("You died!", (screenWidth / 2 - 212).int32, (verticalStart - buttonHeight * 2 + 6).int32, 100, DarkGray)
    drawText("You died!", (screenWidth / 2 - 218).int32, (verticalStart - buttonHeight * 2).int32, 100, White)

  # Draw the start/restart button
  let startButtonText = if isFrogDead: "Play again" else: "Start game"

  if (drawButton(Rectangle(x: screenWidth / 2 - 200, y: verticalStart, width: 400, height: 60), startButtonText)):
    resetFrog()
    flies = @[]
    trashCans = @[]
    trashBoxes = @[]
    isFrogDead = false
    showMenu = false
    return true;

  # Always draw the exit button
  if (drawButton(Rectangle(x: screenWidth / 2 - 200, y: verticalStart + buttonHeight + buttonGap, width: 400, height: 60), "Exit")):
    return false

  # Don't stop the game if nothing is pressed
  return true