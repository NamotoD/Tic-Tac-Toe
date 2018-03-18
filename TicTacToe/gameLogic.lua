---------------------------------------------------------------------------------
--
-- gameLogic.lua
--
---------------------------------------------------------------------------------

-- Returns table of all winning sets after a move
local function checkWinnings(moves)
	local returnWinnings = {}
	local winningSets = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 9}, {3, 5, 7}}
	for _, winningSet in pairs (winningSets) do
		local isPossiblyWinning = false
		for _, winningSetValue in pairs (winningSet) do -- find possible winning sets for the new element
			if moves[#moves] == winningSetValue then
				isPossiblyWinning = true
			end
		end
		if isPossiblyWinning then
			local isWinningSet = true
			for _, wSetValue in pairs (winningSet) do -- find if a player has all the values in a possibly winning sets
				local isNumberIn = false
				for _, moveValue in pairs (moves) do
					if wSetValue == moveValue then
						isNumberIn = true
					end
				end
				if not(isNumberIn) then
					isWinningSet = false
				end
			end
			if isWinningSet then
				table.insert(returnWinnings, winningSet)
			end
		end
	end
	return returnWinnings -- return all winning sets
end

-- used in easy mode
local function getRandomX(remain)
	local x = remain[math.random( #remain )]
	return x
end

-- helper function to find elements in a table
local function findInTable(tbl, move)
	local isIn = false
	for _, mValue in pairs (tbl) do
		if move == mValue then
			isIn = true
		end
	end
	return isIn
end

-- helper function to count elements in a row
local function countInARow(set, pastMoves)
	local compInARow = 0
	for _, number in pairs (set) do
		for _, pastMove in pairs (pastMoves) do
			if number == pastMove then
				compInARow = compInARow + 1
			end
		end
	end
	return compInARow
end

-- helper function to validate move
local function validateMove(set, pastMoves, remain)
	local rValue = 0
	for _, value in pairs (set) do
		local wasPlayedBefore = findInTable(pastMoves, value) -- find the value missing to complete winning set
		if not(wasPlayedBefore) then
			local isAvailable = findInTable(remain, value) -- check that the value is in remaining moves to not ovewrite older moves
			if isAvailable then
				rValue = value
				break
			end
		end
	end
	return rValue
end

-- clone a table
function table.clone_table(tin)
  local tout = {}
  for k,v in pairs(tin) do
    tout[k] = v
  end
  return tout
end

-- Returns table of all winning sets after a move
local function winningStrategy(compPastMoves, humPastMoves, remain)
	local returnMove = getRandomX(remain)
	local founBest = false
	local winningSets = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 9}, {3, 5, 7}}
	
	-- finish the game - complete computer two in a row 
	for _, set in pairs (winningSets) do -- find if a player has all the values in a possibly winning sets
		local compInARow = countInARow(set, compPastMoves) -- count computer moves in a winning set
		if (compInARow == 2) then -- if at least 2 in  a wining set
			local validMove = validateMove(set, compPastMoves, remain) -- check if there is a valid move
			if not ( validMove == 0) then -- !found valid move!
				returnMove = validMove
				founBest = true
			end
		end
	end
	
	-- otherwise disallow human to finish the game - complete human two in a row
	for _, set in pairs (winningSets) do
		if not(founBest) then
			local humInARow = countInARow(set, humPastMoves) -- count human moves in a winning set
			if (humInARow == 2) then -- if at least 2 in  a wining set
				local validMove = validateMove(set, humPastMoves, remain) -- check if there is a valid move
				if not ( validMove == 0) then -- !found valid move!
					returnMove = validMove
					founBest = true
				end
			end
		end
	end
	
	-- otherwise check if there is a move that creates two lines of two in a row
	for _, set in pairs (winningSets) do
		if not(founBest) then
			for i = 1, 9 do
				local compMoves = table.clone_table(compPastMoves)
				if findInTable(remain, i) then
					table.insert(compMoves, i)
				end
				local twoSets = 0
				for _, set1 in pairs (winningSets) do
					if findInTable(set1, i) then
						local isInARow = countInARow(set1, compMoves) -- count computer moves in a winning set
						if (isInARow == 2) then -- if at least 2 in  a wining set
							local found = false
							for _, n in pairs (set1) do
								if findInTable(humPastMoves, n) then
									found = true
								end
							end
							if not(found) then
								twoSets = twoSets + 1
							end
						end
					end
				end
				if(twoSets > 1) then
					returnMove = i
					founBest = true
				end
			end
		end		
	end
		
	-- otherwise play in the centre if available
	if not(founBest) then
		if findInTable(remain, 5) then
			returnMove = 5
			founBest = true
		end
	end
	
	-- otherwise if human last was corner , play the opposite corner if available
	if not(founBest) then
		if humPastMoves[#humPastMoves] == 1 and findInTable(remain, 9) then
			returnMove = 9
			founBest = true
		end
		if humPastMoves[#humPastMoves] == 9 and findInTable(remain, 1) then
			returnMove = 1
			founBest = true
		end
		if humPastMoves[#humPastMoves] == 3 and findInTable(remain, 7) then
			returnMove = 7
			founBest = true
		end
		if humPastMoves[#humPastMoves] == 7 and findInTable(remain, 3) then
			returnMove = 3
			founBest = true
		end
	end
	
	-- otherwise play empty corner
	if not(founBest) then
		local corners = {1, 3, 7, 9}
		for _, c in pairs (corners) do
			if findInTable(remain, c) then
				returnMove = c
				founBest = true
			end
		end
	end
	
	return returnMove
end

-- plays the difficulty based on the selected mode
local function setDifficulty(compPastMoves, humPastMoves, remain, difficulty, round)
	local x
	if (difficulty == "easy") then
		x = getRandomX(remain)
	elseif (difficulty == "hard") then
		x = winningStrategy(compPastMoves, humPastMoves, remain)
	else
		if (math.ceil(round/2) % 2 == 0) then -- divide by 2 to account for the fact that two players are playing and ceil it to get same result if computer starts
			x = winningStrategy(compPastMoves, humPastMoves, remain)
		else 
			x = getRandomX(remain)
		end
	end
	return x
end


local GameLogic = {
	checkWinnings = checkWinnings,
	getRandomX = getRandomX,
	winningStrategy = winningStrategy,
	setDifficulty = setDifficulty
}


return GameLogic