---------------------------------------------------------------------------------
--
-- replayGame.lua
--
---------------------------------------------------------------------------------

----- IMPORT MODULES --------------------------------------------------------------------
local composer = require( "composer" )
local utility = require("utility")

----DEFINE VARIABLES---------------------------------------------------------------------
local scene = composer.newScene()

local d = display
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

-----------------------------------------------------------------------------------------------------------------------------
---- Create function --------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

function scene:create( event )
    local sceneGroup = self.view
	
	-- remove scenes
	composer.removeScene( "menu" )
	composer.removeScene( "loadingGame" )
	composer.removeScene( "resultsScreen" )
	composer.removeScene( "game" )
end

-----------------------------------------------------------------------------------------------------------------------------
---- Show function ----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

function scene:show( event )
	local sceneGroup = self.view
	local board = {}

	----DRAW LINES FOR BOARD
	local lline = d.newLine(W_40, H_20, W_40, H_80 )
	lline.strokeWidth = STROKE_WIDTH
	sceneGroup:insert( lline )
	local rline = d.newLine(W_60, H_20, W_60, H_80 )
	rline.strokeWidth = STROKE_WIDTH
	sceneGroup:insert( rline )
	local bline = d.newLine(W_20, H_40, W_80, H_40 )
	bline.strokeWidth = STROKE_WIDTH
	sceneGroup:insert( bline )
	local tline = d.newLine(W_20, H_60, W_80, H_60 )
	tline.strokeWidth = STROKE_WIDTH
	sceneGroup:insert( tline )

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
	

	local replayGame = utility.loadTable("replayGame.json" )	
	local round = 0
	
	-- retrieves moves from replayGame.json and replays in 1 second interval
	local function drawMove( event )
		round = round + 1
		local player = replayGame[round].Player
		local move = replayGame[round].Move		
		if player == X then		
			local x1 = d.newLine(board[move][3] + X_OFFSET, board[move][6] + Y_X1, board[move][3] + W_20 - X_OFFSET, board[move][6] + H_20 - Y_X1)
			local x2 = d.newLine(board[move][3] + X_OFFSET, board[move][6] + Y_X2, board[move][3] + W_20 - X_OFFSET, board[move][6] + H_20 - Y_X2)
			x1.strokeWidth, x2.strokeWidth = STROKE_WIDTH, STROKE_WIDTH
			sceneGroup:insert( x1 )
			sceneGroup:insert( x2 )
		else
				local o = d.newCircle(board[move][3] + W_20 * CIRCLE_OFFSET , board[move][6] + H_20 * CIRCLE_OFFSET, W_20 * CIRCLE_RADIUS)
				o:setFillColor(0,0,0)
				o.strokeWidth = STROKE_WIDTH
				sceneGroup:insert( o )
		end
		
		if round >= #replayGame then	
			local function returnToMenu( event )
				composer.gotoScene( "menu", "crossFade", 500  )
			end
			timer.performWithDelay( 2000, returnToMenu )
		end
		
	end
	
	timer.performWithDelay( 1000, drawMove, #replayGame ) -- for each move display with 1 second interval
	
end

-----------------------------------------------------------------------------------------------------------------------------
---- Hide function ----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

function scene:hide()
	board = {}
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