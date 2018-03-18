---------------------------------------------------------------------------------
--
-- utility.lua
-- saveTable and loadTable functions were accessed at
-- https://docs.coronalabs.com/tutorial/data/jsonSaveLoad/index.html
---------------------------------------------------------------------------------

local json = require( "json" )
local defaultLocation = system.DocumentsDirectory
 
-- saves lua table into json file 
local function saveTable( t, filename, location )
 
    local loc = location
    if not location then
        loc = defaultLocation
    end
 
    -- Path for the file to write
    local path = system.pathForFile( filename, loc )
 
    -- Open the file handle
    local file, errorString = io.open( path, "w" )
 
    if not file then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
        return false
    else
        -- Write encoded JSON data to file
        file:write( json.encode( t ) )
        -- Close the file handle
        io.close( file )
        return true
    end
end

-- loads json file into lua table
local function loadTable( filename, location )
 
    local loc = location
    if not location then
        loc = defaultLocation
    end
 
    -- Path for the file to read
    local path = system.pathForFile( filename, loc )
 
    -- Open the file handle
    local file, errorString = io.open( path, "r" )
 
    if not file then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
    else
        -- Read data from file
        local contents = file:read( "*a" )
        -- Decode JSON data into Lua table
        local t = json.decode( contents )
        -- Close the file handle
        io.close( file )
        -- Return table
        return t
    end
end

-- checks if results.json exists, if not creates one and fill with zeroes
local function checkResultsFileExists()		
	local filePath = system.pathForFile( "results.json", defaultLocation )
	local file = io.open( filePath )
		
	if file then
		print( "results.json exists" )
		file:close()
	else
		print( "results.json does not exist!" )		
		local resultsHistory = {
			draw = 0, won = 0, lost = 0
		}
		saveTable( resultsHistory, "results.json" )	
	end
end

-- updates results.json when the game ends in draw
local function updateOnDraw()			
	local updatedResults = {
	}
		
	local results = loadTable("results.json" )	
	for a, c in pairs (results) do
		if a == "lost" then
			updatedResults.lost = c
		end
		if a == "draw" then
			updatedResults.draw = c + 1
		end
		if a == "won" then
			updatedResults.won = c
		end			
	end
	saveTable( updatedResults, "results.json" )
end

-- updates results.json when computer wins
local function updateOnComputerWon()			
	local updatedResults = {
	}
		
	local results = loadTable("results.json" )	
	for a, c in pairs (results) do
		if a == "lost" then
			updatedResults.lost = c + 1
		end
		if a == "draw" then
			updatedResults.draw = c
		end
		if a == "won" then
			updatedResults.won = c
		end			
	end
	saveTable( updatedResults, "results.json" )
end

-- updates results.json when human wins
local function updateOnHumanWon()			
	local updatedResults = {
	}
		
	local results = loadTable("results.json" )	
	for a, c in pairs (results) do
		if a == "lost" then
			updatedResults.lost = c
		end
		if a == "draw" then
			updatedResults.draw = c
		end
		if a == "won" then
			updatedResults.won = c + 1
		end			
	end
	saveTable( updatedResults, "results.json" )
end

-- updates replayGame.json after every move
local function updateMoves(round, player, move)
	local replayGame = loadTable("replayGame.json" )	
	replayGame[round] = {Player = player, Move = move}
	saveTable( replayGame, "replayGame.json" )
end

-- creates empty replayGame.json file
local function initiateReplayGameFile()
	local replayGame = {}
	saveTable( replayGame, "replayGame.json" )
end

local utility = {
	saveTable = saveTable,
	loadTable = loadTable,
	checkResultsFileExists = checkResultsFileExists,
	updateOnDraw = updateOnDraw,
	updateOnComputerWon = updateOnComputerWon,
	updateOnHumanWon = updateOnHumanWon,
	updateMoves = updateMoves,
	initiateReplayGameFile = initiateReplayGameFile
}


return utility