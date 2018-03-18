---------------------------------------------------------------------------------
--
-- resultsScreen.lua
--
---------------------------------------------------------------------------------

----- IMPORT MODULES --------------------------------------------------------------------
local composer = require( "composer" )
local utility = require("utility")

----DEFINE VARIABLES---------------------------------------------------------------------
local scene = composer.newScene()
local backgroundImage
local buttonClicked = audio.loadSound( "buttonClicked.wav" )

-----------------------------------------------------------------------------------------------------------------------------
---- Create function --------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

function scene:create( event )
  local sceneGroup = self.view
	
	-- remove scenes
	composer.removeScene( "menu" )
	composer.removeScene( "loadingGame" )
	composer.removeScene( "game" )
	composer.removeScene( "replayGame" )
	utility.checkResultsFileExists()
end

-----------------------------------------------------------------------------------------------------------------------------
---- Show function ----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

function scene:show( event )
	local sceneGroup = self.view	
	local clearResultsBtn	
	local closeBtn
	
	backgroundImage = display.newImageRect( "backgrounds/results_background.png", 320, 480 )
	backgroundImage.x = 160; backgroundImage.y = 240
	sceneGroup:insert( backgroundImage )
	
	local results = utility.loadTable("results.json" )
	
	-- define results text elements
	local won = display.newText( "Won", 50, 100, native.systemFont, 36 )
	sceneGroup:insert( won )
	local wonTimes = display.newText( results.won, 50, 140, native.systemFont, 36 )
	sceneGroup:insert( wonTimes )
	
	local lost = display.newText( "Lost", 160, 100, native.systemFont, 36 )
	sceneGroup:insert( lost )
	local lostTimes = display.newText( results.lost, 160, 140, native.systemFont, 36 )
	sceneGroup:insert( lostTimes )
	
	local draw = display.newText( "Draw", 270, 100, native.systemFont, 36 )
	sceneGroup:insert( draw )
	local drawTimes = display.newText( results.draw, 270, 140, native.systemFont, 36 )
	sceneGroup:insert( drawTimes )	
	
	-- clears the results
	local onClearResultsTouch = function( event )
		if event.phase == "release" then			
			audio.play( buttonClicked )						
			local resultsHistory = {
				draw = 0, won = 0, lost = 0
			}
			utility.saveTable( resultsHistory, "results.json" )
			composer.gotoScene( "resultsScreen", "crossFade", 500  )
		end
	end
	
	-- returns to menu
	local onCloseTouch = function( event )
		if event.phase == "release" then
			audio.play( buttonClicked )
			composer.gotoScene( "menu", "slideRight", 500  )
		end
	end
	
	-- define the buttons
	clearResultsBtn = ui.newButton{
		defaultSrc = "buttons/button_clear.png",
		defaultX = 129,
		defaultY = 44,
		overSrc = "buttons/button_clear_clicked.png",
		overX = 129,
		overY = 44,
		onEvent = onClearResultsTouch,
		id = "ClearButton"
	}	
	clearResultsBtn.x = 160; clearResultsBtn.y = 200
	sceneGroup:insert( clearResultsBtn )
	
	closeBtn = ui.newButton{
		defaultSrc = "buttons/button_back.png",
		defaultX = 97,
		defaultY = 44,
		overSrc = "buttons/button_back_clicked.png",
		overX = 97,
		overY = 44,
		onEvent = onCloseTouch,
		id = "CloseButton"
	}	
	closeBtn.x = 65; closeBtn.y = 430
	sceneGroup:insert( closeBtn )	
end

-----------------------------------------------------------------------------------------------------------------------------
---- Hide function ----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

function scene:hide()
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