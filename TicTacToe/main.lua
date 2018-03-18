-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

local composer = require ( "composer" )

-- load menu
composer.gotoScene( "loadingMenu" )