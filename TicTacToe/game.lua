---------------------------------------------------------------------------------
--
-- game.lua
--
---------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local physics = require ("physics")
local ui = require ("ui")
local utility = require("utility")


----- IMPORT MODULES --------------------------------------------------------------------
local GameLogic = require "gameLogic"
local GameArea = require "GameArea"	
local widget = require( "widget" )

----DEFINE VARIABLES---------------------------------------------------------------------
local remaining = {}
local humanMoves = {}
local computerMoves = {}
local isTouchEnabled = true
local gameIsOn = true	
local board = {}
local d = display
local TEXT_X_CENTER = d.contentCenterX
local EMPTY, X, O = 0, 1, 2
local whichTurn = O
local round
local difficulty = "easy"

-----------------------------------------------------------------------------------------------------------------------------
---- Create function --------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

function scene:create( event )
	local gameGroup = self.view
	
	-- remove scenes
	composer.removeScene( "menu" )
	composer.removeScene( "loadingGame" )
	composer.removeScene( "resultsScreen" )
	composer.removeScene( "replayGame" )
	
	utility.checkResultsFileExists()
	utility.initiateReplayGameFile()
			
	round = 1
	
end

-----------------------------------------------------------------------------------------------------------------------------
---- Show function ----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

function scene:show( event )	

----- DEFINE MAIN FUNCTIONS ------------------------------------------------------------------

local function enableTouch()
	isTouchEnabled = true
end
			
local function disableTouch()
	isTouchEnabled = false
end	

-- Returns table with remaining indexes
local function getRemaining ()		
	local remaining = {}
	for r = 1, 9 do
		if board[r][7] == EMPTY then
			table.insert(remaining, r)
		end
	end 	
	return remaining
end	

-- Removes element from remaining table
local function removeFromRemaining(symbol)
	for key, value in ipairs(remaining) do
		if symbol == value then
			table.remove(remaining, key)
		end
	end
end	

local function showMenu()
	composer.gotoScene( "menu", "fade", 500  )
end

-- Does random computer move and checks game status
local function computerMove()
	if (timeToReEnableTouch) then
		timer.cancel(timeToReEnableTouch)
	end
	if (timeToReEnableTouch) then
		timer.cancel(timeToUndo)
	end
	enableTouch()
	local remain = getRemaining()
	local x = GameLogic.setDifficulty(computerMoves, humanMoves, remain, composer.getVariable( "difficulty"), round)	
	local winnings = {}
	GameArea.registerMove(x, X, computerMoves, board)	
	utility.updateMoves(round, X, x)
	round = round + 1	
	winnings = GameLogic.checkWinnings(computerMoves)
	if next(winnings) ~= nil then -- computer won!
		gameIsOn = GameArea.endGame("COMPUTER WON!")
		utility.updateOnComputerWon()	
		timer.performWithDelay( 2000, showMenu )
	else
		removeFromRemaining(x)
		if #remaining == 0 then
			gameIsOn = GameArea.endGame("DRAW!")
			utility.updateOnDraw()	
			timer.performWithDelay( 2000, showMenu )
		end
	end
end	

-- Processes human move and if any fields remaining does 'computerMove' 1 second after human move
local function humanMove(event)
	GameArea.hideUndoButton()
	local params = event.source.params
	local o = params.t
	local winnings = {}
	GameArea.registerMove(o, O, humanMoves, board)
	utility.updateMoves(round, O, o)
	round = round + 1	
	winnings = GameLogic.checkWinnings(humanMoves)
	if next(winnings) ~= nil then -- human won!
		gameIsOn = GameArea.endGame("HUMAN WON!")
		utility.updateOnHumanWon()
		timer.performWithDelay( 2000, showMenu )
	else		
		removeFromRemaining(o)
		if #remaining > 0 then
			computerMove()
		else
			gameIsOn = GameArea.endGame("DRAW!")
			utility.updateOnDraw()	
			timer.performWithDelay( 2000, showMenu )
		end
		whichTurn = O
	end
end
-- Checks if clicked field is empty then process human move		
local function processMoves (event)
	remaining = getRemaining()
	for t = 1, 9 do
		if event.x > board[t][3] and event.x < board [t][5] then
			if event.y < board[t][4] and event.y > board[t][6] then
				if board[t][7] == EMPTY then
					GameArea.drawTempO(t, board)
					timeToUndo = timer.performWithDelay( 5000, humanMove )
					timeToUndo.params = { t = t}
					GameArea.showUndoButton()
				end
			end
		end
	end 
end		

-- Disable touch for 1 second and processMoves()
local function touched (event)
	if isTouchEnabled and (gameIsOn)then
		disableTouch()
		timeToReEnableTouch = timer.performWithDelay( 5000, enableTouch ) -- re-enable in 1 sec
		if event.phase == "began" then
			processMoves (event)
		end
	end
end

-- Resets the board
local function resetGame()
	board = GameArea.setupBoard(board)
	humanMoves = {}
	computerMoves = {}
	gameIsOn = GameArea.startGame()
end

-- Resets the board and human starts
local function resetGameHumanFirst()
	enableTouch()
	resetGame()
end

-- Resets the board and computer starts
local function resetGameComputerFirst()
	disableTouch()
	resetGame()
	remaining = getRemaining()
	computerMove()
	--round = round + 1	
end

-- Resets the board and computer starts
local function undoMove()
	GameArea.hideUndoButton()
	timer.cancel(timeToUndo)
	GameArea.undrawTempO()
	timer.cancel(timeToReEnableTouch)
	enableTouch()
end

-- Resets the board and computer starts
local function play()
	Runtime:addEventListener("touch", touched)
	board = GameArea.setupBoard(board)
	GameArea.drawButtons(undoMove, resetGameHumanFirst, resetGameComputerFirst)
	disableTouch()
end

----- INITIATE GAME ----------------------------------------------------------------------------

play()
end

-----------------------------------------------------------------------------------------------------------------------------
---- Hide function ----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

function scene:hide( event )
end

-----------------------------------------------------------------------------------------------------------------------------
---- Destroy function -------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------------------------------------------
---- Return Scene -----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

return scene