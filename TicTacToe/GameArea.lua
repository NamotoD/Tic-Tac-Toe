---------------------------------------------------------------------------------
--
-- GameArea.lua
--
---------------------------------------------------------------------------------

----DEFINE VARIABLES- -------------------------------------------------------------------
local d = display
local gameElements = d.newGroup()
local tempMoves = d.newGroup()
local buttonElements = d.newGroup()
local EMPTY, X, O = 0, 1, 2

local STROKE_WIDTH = 5
local W_20 = d.contentWidth * .2
local H_20 = d.contentHeight * .2 
local W_40 = d.contentWidth * .4
local H_40 = d.contentHeight * .4
local W_60 = d.contentWidth * .6
local H_60 = d.contentHeight * .6
local W_80 = d.contentWidth * .8
local H_80 = d.contentHeight * .8
local X_OFFSET = W_20 * .25
local Y_X1 = H_20 * .25
local Y_X2 = H_20 * .75
local CIRCLE_OFFSET = .5
local CIRCLE_RADIUS = .36

local FONT = "Arial"
local TEXT_SIZE = 25
local TEXT_Y = d.contentCenterY
local TEXT_X_CENTER = d.contentCenterX

local WINNING_TEXT_SIZE = 30
local WINNING_TEXT_FONT = native.systemFontBold
local undoButton

-- local drawDiffButtons -- pre-declare function second part of assignment
local widget = require( "widget" )



local function hideButtons ()
	buttonElements.isVisible = false
end

local function showButtons ()
	buttonElements.isVisible = true
end

local function hideUndoButton ()
	undoButton.isVisible = false
end

local function showUndoButton ()
	undoButton.isVisible = true
end

----- DEFINE MAIN FUNCTIONS ------------------------------------------------------------------			

-- Print the result to the screen
local function showGameResult(result)	
		local t = d.newText(result, TEXT_X_CENTER, TEXT_Y, WINNING_TEXT_FONT, WINNING_TEXT_SIZE)
		t:setFillColor( 255, 255, 0 )
		transition.blink( t, { time = 2000 } )
		gameElements:insert(t)
end	

local function clearGameArea(result)
	gameElements:removeSelf() -- remove game elements
	gameElements = d.newGroup()
	tempMoves:removeSelf() -- remove temporary game elements
	tempMoves = d.newGroup()
end

local function endGame(result)	
	--showButtons()
	showGameResult(result)
	timer.performWithDelay( 2000, clearGameArea )
	-- GameArea.drawDiffButtons(easy, medium, hard) second part of assignment
	return false
end
			
local function startGame()
	return true
end	

-- Sets up the playing board
local function setupBoard(board)

	----DRAW LINES FOR BOARD
	local lline = d.newLine(W_40, H_20, W_40, H_80 )
	lline.strokeWidth = STROKE_WIDTH
	gameElements:insert(lline)
	local rline = d.newLine(W_60, H_20, W_60, H_80 )
	rline.strokeWidth = STROKE_WIDTH
	gameElements:insert(rline)
	local bline = d.newLine(W_20, H_40, W_80, H_40 )
	bline.strokeWidth = STROKE_WIDTH
	gameElements:insert(bline)
	local tline = d.newLine(W_20, H_60, W_80, H_60 )
	tline.strokeWidth = STROKE_WIDTH
	gameElements:insert(tline)

	--PLACE BOARD COMPARTMENT DIMENSIONS IN TABLE
	board ={
		{"tl", 1, W_20, H_40, W_40, H_20, 0},
		{"tm", 2, W_40, H_40, W_60, H_20, 0},
		{"tr", 3, W_60, H_40, W_80, H_20, 0},
		{"ml", 4, W_20, H_60, W_40, H_40, 0},
		{"mm", 5, W_40, H_60, W_60, H_40, 0},
		{"mr", 6, W_60, H_60, W_80, H_40, 0},
		{"bl", 7, W_20, H_80, W_40, H_60, 0},
		{"bm", 8, W_40, H_80, W_60, H_60, 0},
		{"br", 9, W_60, H_80, W_80, H_60, 0}
	}
	hideButtons ()
	return board
end

-- Draws crosses
local function drawX(myX, board)
	local x1 = d.newLine(board[myX][3] + X_OFFSET, board[myX][6] + Y_X1, board[myX][3] + W_20 - X_OFFSET, board[myX][6] + H_20 - Y_X1)
	local x2 = d.newLine(board[myX][3] + X_OFFSET, board[myX][6] + Y_X2, board[myX][3] + W_20 - X_OFFSET, board[myX][6] + H_20 - Y_X2)
	x1.strokeWidth, x2.strokeWidth = STROKE_WIDTH, STROKE_WIDTH
	gameElements:insert(x1)
	gameElements:insert(x2)
end

-- Draws noughts
local function drawO(myO, board)
	local o = d.newCircle(board[myO][3] + W_20 * CIRCLE_OFFSET , board[myO][6] + H_20 * CIRCLE_OFFSET, W_20 * CIRCLE_RADIUS)
	o:setFillColor(0,0,0)
	o.strokeWidth = STROKE_WIDTH
	gameElements:insert(o)
end

-- Draws noughts
local function drawTempO(myO, board)
	tempMove = d.newCircle(board[myO][3] + W_20 * CIRCLE_OFFSET , board[myO][6] + H_20 * CIRCLE_OFFSET, W_20 * CIRCLE_RADIUS)
	tempMove:setFillColor(0,0,0)
	tempMove.strokeWidth = STROKE_WIDTH
	tempMoves:insert(tempMove)
end

-- Draws noughts
local function undrawTempO()
	tempMove:removeSelf()
	tempMove = nil
end


-- Saves X moves 
local function registerMove(move, player, computerMoves, board)
	if player == X then
		drawX(move, board)
	else
		drawO(move, board)
	end
	board[move][7] = player
	table.insert(computerMoves, move)
end

----DRAW START GAME BUTTONS
-- Prompts user to choose who starts first
local function drawButtons (undoMove, resetGameHumanFirst, resetGameComputerFirst)
	local startText = d.newText("Choose who starts next", TEXT_X_CENTER, 410, FONT, TEXT_SIZE)

	undoButton = widget.newButton(
		{
			label = "Undo",
			onRelease =  undoMove,
			emboss = false,
			-- Properties for a rounded rectangle button
			shape = "roundedRect",
			x = TEXT_X_CENTER - 70,
			y = 450,
			width = answerWidth,
			height = answerHeight,
			cornerRadius = 2,
			fillColor = answerFillColor,
			strokeColor = answerStrokeFillColor,
			strokeWidth = 4,
			fontSize = 23,
			width = 130,
			height = 50
		}
	)
	undoButton.isVisible = false
	
	local humanStartsButton = widget.newButton(
		{
			label = "Human",
			onRelease =  resetGameHumanFirst,
			emboss = false,
			-- Properties for a rounded rectangle button
			shape = "roundedRect",
			x = TEXT_X_CENTER - 70,
			y = 450,
			width = answerWidth,
			height = answerHeight,
			cornerRadius = 2,
			fillColor = answerFillColor,
			strokeColor = answerStrokeFillColor,
			strokeWidth = 4,
			fontSize = 23,
			width = 130,
			height = 50
		}
	)
	local computerStartsButton = widget.newButton(
		{
			label = "Computer",
			onRelease =  resetGameComputerFirst,
			emboss = false,
			-- Properties for a rounded rectangle button
			shape = "roundedRect",
			x = TEXT_X_CENTER + 70,
			y = 450,
			width = answerWidth,
			height = answerHeight,
			cornerRadius = 2,
			fillColor = answerFillColor,
			strokeColor = answerStrokeFillColor,
			strokeWidth = 4,
			fontSize = 23,
			width = 130,
			height = 50
		}
	)
	buttonElements:insert(startText)
	buttonElements:insert(humanStartsButton)
	buttonElements:insert(computerStartsButton)
	showButtons()
end

GameArea = {
	endGame = endGame,
	startGame = startGame,
	showGameResult = showGameResult,	
	setupBoard = setupBoard,
	registerMove = registerMove,
	drawButtons = drawButtons,
	hideButtons = hideButtons,
	showButtons = showButtons,
	drawTempO = drawTempO,
	undrawTempO = undrawTempO,
	hideUndoButton = hideUndoButton,
	showUndoButton = showUndoButton
}

return GameArea