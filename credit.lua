module(..., package.seeall)

function new()
local ui = require("ui")
local widget = require "widget"
local localGroup = display.newGroup()
local firstLine
local secondLine
local thirdLine
local fourthLine
local fifthLine
local sixthLine
local seventhLine

local function back()
	creditsBtn:removeSelf()
	director:changeScene("menu")
end


local background = display.newImageRect( "background.png", display.contentWidth, display.contentHeight )
background:setReferencePoint( display.TopLeftReferencePoint )
background.x, background.y = 0, 0
localGroup:insert(background)

creditsBtn = widget.newButton{
		label="",
		labelColor = { default={255}, over={128} },
		default="back-button.png",
		over="back-button-press.png",
		width=100, height=100,
		onRelease = back	-- event listener function
	}
	creditsBtn:setReferencePoint( display.CenterReferencePoint )
	creditsBtn:toFront()
	creditsBtn.x = display.contentWidth*0.5
	creditsBtn.y = 410
	
firstLine = display.newText("Balloon Pop by Texaveryjr" , 30, 20, "AmericanTypewriter-Bold", 19)
secondLine = display.newText("Wind by Mark DiAngelo" , 30, 70, "AmericanTypewriter-Bold", 19)
thirdLine = display.newText("Clang by Texaveryjr" , 30, 120, "AmericanTypewriter-Bold", 19)
fourthLine = display.newText("Reward by Mark Buckland" , 30, 170, "AmericanTypewriter-Bold", 19)
fifthLine = display.newText("Art by Aaron Gupta" , 30, 220, "AmericanTypewriter-Bold", 19)
sixthLine = display.newText("Music by Kevin MacLeod" , 30, 270, "AmericanTypewriter-Bold", 19)
seventhLine = display.newText("Letters by iconarchive.com" , 30, 320, "AmericanTypewriter-Bold", 19)
localGroup:insert(firstLine)
localGroup:insert(secondLine)
localGroup:insert(thirdLine)
localGroup:insert(fourthLine)
localGroup:insert(fifthLine)
localGroup:insert(sixthLine)
localGroup:insert(seventhLine)
	

return localGroup
end