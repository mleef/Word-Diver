display.setStatusBar (display.HiddenStatusBar)
--> Hides the status bar
checkedWords = {}


saveValue = function( strFilename, strValue )
-- will save specified value to specified file
local theFile = strFilename
local theValue = strValue

local path = system.pathForFile( theFile, system.DocumentsDirectory )

-- io.open opens a file at path. returns nil if no file found
local file = io.open( path, "w+" )
	if file then
		-- write game score to the text file
		file:write( theValue )
		io.close( file )
	end
end

clearCheckedWords = function()
checkedWords = {}
end

addCheckedWord = function(word)
checkedWords[#checkedWords + 1] = word
end

loadValue = function( strFilename )
-- will load specified file, or create new file if it doesn't exist

local theFile = strFilename

local path = system.pathForFile( theFile, system.DocumentsDirectory )

-- io.open opens a file at path. returns nil if no file found
local file = io.open( path, "r" )
	if file then
		-- read all contents of file into a string
		local contents = file:read( "*a" )
		io.close( file )
		return contents
		else
		-- create file b/c it doesn't exist yet
		file = io.open( path, "w" )
		file:write( "0" )
		io.close( file )
		return "0"
	end
end



local director = require ("director")
--> Imports director

local mainGroup = display.newGroup()
--> Creates a main group

local function main()
--> Adds main function
	
	mainGroup:insert(director.directorView)
	--> Adds the group from director
	
	director:changeScene("menu")
	--> Change the scene, no effects
	
	return true
end


main()