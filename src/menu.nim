var
  showMenu = true

proc drawMenu(): bool =
  # Precalculate vertical button values
  const buttonHeight = 60
  const buttonGap = buttonHeight / 2
  const buttonsTotalHeight = buttonHeight * 2 + buttonGap
  const verticalStart = (screenHeight / 2) - (buttonsTotalHeight / 2)

  if isFrogDead:
    drawTextWithShadow(
      "You died!",
      (screenWidth / 2 - 218).int32,
      (verticalStart - buttonHeight * 2).int32,
      100, 6, White, DarkGray)

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

  # Draw small credits
  drawTextWithShadow(
      "Coded by Xkonti with YouTube and Twitch chat",
      10'i32, (screenHeight - 50).int32,
      40, 3, White, DarkGray)

  # Don't stop the game if nothing is pressed
  return true