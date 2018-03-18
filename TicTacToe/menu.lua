---------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------

----- IMPORT MODULES --------------------------------------------------------------------
local composer = require( "composer" )
local ui = require("ui")
local utility = require("utility")

----DEFINE VARIABLES---------------------------------------------------------------------
local animateButton
local scene = composer.newScene()
local buttonClicked = audio.loadSound( "buttonClicked.wav" )

-----------------------------------------------------------------------------------------------------------------------------
---- Create function --------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

function scene:create( event )
	local sceneGroup = self.view
	
	-- remove scenes
	composer.removeScene( "loadingGame" )
	composer.removeScene( "resultsScreen" )
	composer.removeScene( "game" )
	composer.removeScene( "replayGame" )
end

-----------------------------------------------------------------------------------------------------------------------------
---- Show function ----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

function scene:show( event )
	
	local sceneGroup = self.view		
	local replayBtn	
	local difficulty
	local easyBtn	
	local mediumBtn	
	local hardBtn	
	local playBtn	
	local resultsBtn
	
	local backgroundImage = display.newImageRect( "backgrounds/crosses_noughts.png", 320, 480 )
	backgroundImage.x = 160; backgroundImage.y = 240
	sceneGroup:insert( backgroundImage )

	local replayGame = utility.loadTable("replayGame.json" )	
	
	-- show replay button if if there is a game to replay
	if replayGame ~= nil and #replayGame > 0 then
		
		local onReplayTouch = function( event )
			if event.phase == "release" then
				
				audio.play( buttonClicked )
				composer.gotoScene( "replayGame", "fade", 300  )
				
			end
		end
		
		replayBtn = ui.newButton{
			defaultSrc = "buttons/button_replay.png",
			defaultX = 97,
			defaultY = 44,
			overSrc = "buttons/button_replay_clicked.png",
			overX = 97,
			overY = 44,
			onEvent = onReplayTouch,
			id = "ReplayButton"
		}		
		replayBtn.x = 65; replayBtn.y = 40
		sceneGroup:insert( replayBtn )		
		animateButton = transition.to( replayBtn, { time = 1000, y = 50, transition = easing.outInElastic } )
	end
	
  -- chose easy difficulty	
	local onEasyTouch = function( event )
		if event.phase == "release" then			
			audio.play( buttonClicked )
			composer.setVariable( "difficulty", "easy")	
			print(composer.getVariable( "difficulty"))		
		end
	end
	
  -- chose medium difficulty	
	local onMediumTouch = function( event )
		if event.phase == "release" then			
			audio.play( buttonClicked )
			composer.setVariable( "difficulty", "medium" )
			print(composer.getVariable( "difficulty"))		
		end
	end
	
  -- chose hard difficulty	
	local onHardTouch = function( event )
		if event.phase == "release" then			
			audio.play( buttonClicked )
			composer.setVariable( "difficulty", "hard" )	
			print(composer.getVariable( "difficulty"))		
		end
	end
	
	-- play the game
	local onPlayTouch = function( event )
		if event.phase == "release" then			
			audio.play( buttonClicked )
			composer.gotoScene( "loadingGame", "fade", 300  )			
		end
	end	
	
	-- show persistent results
	local onresultsTouch = function( event )
		if event.phase == "release" then
			audio.play( buttonClicked )
			composer.gotoScene( "resultsScreen", "slideLeft", 500  )
		end
	end
	
	-- define all buttons
	easyBtn = ui.newButton{
		defaultSrc = "buttons/button_easy.png",
		defaultX = 91,
		defaultY = 44,
		overSrc = "buttons/button_easy_clicked.png",
		overX = 91,
		overY = 44,
		onEvent = onEasyTouch,
		id = "EasyButton"
	}	
	easyBtn.x = 65; easyBtn.y = 40
  sceneGroup:insert( easyBtn )	
	animateButton = transition.to( easyBtn, { time = 1000, y = 370, transition = easing.inBack } )
	
	mediumBtn = ui.newButton{
		defaultSrc = "buttons/button_medium.png",
		defaultX = 91,
		defaultY = 44,
		overSrc = "buttons/button_medium_clicked.png",
		overX = 91,
		overY = 44,
		onEvent = onMediumTouch,
		id = "MediumButton"
	}	
	mediumBtn.x = 159; mediumBtn.y = 40
  sceneGroup:insert( mediumBtn )	
	animateButton = transition.to( mediumBtn, { time = 1000, y = 370, transition = easing.inBack } )
	
	hardBtn = ui.newButton{
		defaultSrc = "buttons/button_hard.png",
		defaultX = 91,
		defaultY = 44,
		overSrc = "buttons/button_hard_clicked.png",
		overX = 91,
		overY = 44,
		onEvent = onHardTouch,
		id = "HardButton"
	}	
	hardBtn.x = 253; hardBtn.y = 40
  sceneGroup:insert( hardBtn )	
	animateButton = transition.to( hardBtn, { time = 1000, y = 370, transition = easing.inBack } )
	
	playBtn = ui.newButton{
		defaultSrc = "buttons/button_play.png",
		defaultX = 91,
		defaultY = 44,
		overSrc = "buttons/button_play_clicked.png",
		overX = 91,
		overY = 44,
		onEvent = onPlayTouch,
		id = "PlayButton"
	}	
	playBtn.x = 65; playBtn.y = 40
  sceneGroup:insert( playBtn )	
	animateButton = transition.to( playBtn, { time = 1000, y = 430, transition = easing.inBack  } )
	
	resultsBtn = ui.newButton{
		defaultSrc = "buttons/button_results.png",
		defaultX = 97,
		defaultY = 44,
		overSrc = "buttons/button_results_clicked.png",
		overX = 97,
		overY = 44,
		onEvent = onresultsTouch,
		id = "ResultsButton"
	}	
	resultsBtn.x = 253; resultsBtn.y = 40
	sceneGroup:insert( resultsBtn )	
	animateButton = transition.to( resultsBtn, { time = 1000, y = 50, transition = easing.outInElastic } )
	
end

-----------------------------------------------------------------------------------------------------------------------------
---- Hide function ----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

function scene:hide()
	if animateButton then 
		transition.cancel( animateButton )
	end
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