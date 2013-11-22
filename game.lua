module(..., package.seeall)
function new()
local localGroup = display.newGroup()
local balloonScores = {100, 200, 300, 400, 500}
local lfs = require("lfs")
local easingx = require("easingx")
local physics = require("physics")
local sprite = require("sprite")
local wlist = require("wlist")
local ui = require("ui")
local allLetters = {}
local scoreLetters = {}
local clouds = {}
local touchedLetters = {}
local lettersToDelete = {}
local balloonColors = {"yellow balloon.png", "purple balloon.png", "balloon.png", "green balloon.png"}
local balloons = {}
local balloonCount = 0
local balloonMover
local currentLetter
local workCount = 0
local count = 0
local freezeCount = 1
local currentWord
local myList = wlist.getList()
local letterFrequencies = wlist.getLetters()
local found = false
local right = false
local left = true
local moved = false
local working = false
local paused = false
local firstOne = true
local gravity = 1
local numLetters = 0
local randLetter = 500
local score = 0
local totalScore = 0
math.randomseed(os.time())
local timeBar
local topCloud
local leftWall
local rightWall
local comboBar
local pauseButton
local pm
local rb
local reb
local mb
local bg
local displayGroup = display.newGroup()
local wordCounter = 1
local queuedLetters = {}
local scoreImage
local check
local startingIndex
local firstLetter = ""
local touchCount = 1
local combo = 1
local gravityIncrement
local dropLetters
local balloon
local balloonMover
local cloudMaker
local cloudMover
local gameSpeed = .6
local letterSpeed = 1200
local difficultyTimer
local numberOfWords
local go
local popCount = 1
local music = audio.loadStream("Happy Alley.mp3")
local wind = audio.loadSound("wind.mp3")
local popSound = audio.loadSound("pop.mp3")
local whooshSound = audio.loadSound("whoosh.mp3")
local clangSound = audio.loadSound("clang.mp3")
local rewardSound = audio.loadSound("reward.mp3")
local playMusic = audio.play(music, { channel=2, loops=-1, fadein=2000 } )
physics.start()
local playWind = audio.play(wind, { channel=5, loops=-1, fadein=1000 } )


if(checkedWords ~= nil) then
	if(#checkedWords > 0) then
		checkedWords = {}
		print(#checkedWords)
	end
end

local f = ui.newLabel{
	bounds = { 55, 55, 300, 40 },
	text = "",
	font = "AmericanTypewriter-Bold",
	textColor = { 255, 40, 40, 255 },
	size = 30,
	align = "left"
}
f.x = 70
f.y = 320

go = ui.newLabel{
	bounds = { -180, 55, 300, 40 },
	text = "Start!",
	font = "AmericanTypewriter-Bold",
	textColor = { 255, 40, 40, 255 },
	size = 60,
	align = "left"
}
go.y = 130
	

local function increaseDifficulty()
	gameSpeed = gameSpeed + .2
end
	

local function balloonPopped(event)
	if(not paused) then
	audio.play(popSound, { channel=3, loops=0, fadein=0 } )
	balloonCount = balloonCount + 1
	transition.to( event.target, { time = 2000, xScale = .5, yScale = .5, transition = easingx.easeOutElastic })
	transition.dissolve(event.target, nil, 500)
	local bScore = event.target.speed * 100
	totalScore = totalScore + bScore
	f:setText(totalScore)
	if(timeBar.width + (bScore/10) > 260) then
timeBar.width =  260
timeBar:setReferencePoint(display.BottomLeftReferencePoint)
timeBar.x = 20

else
timeBar.width = timeBar.width + (bScore/10)
timeBar:setReferencePoint(display.BottomLeftReferencePoint)
timeBar.x = 20
end
	end
end


local function clearFrozenLetters()

		if(#lettersToDelete > 0 and lettersToDelete[freezeCount] ~= nil) then
	    local oneLetter = lettersToDelete[freezeCount]
	    local nextLetter = lettersToDelete[freezeCount + 1]
	    if(nextLetter ~= nil) then
	    	nextLetter:setFillColor(255,0,0)
	    end
		oneLetter:removeSelf()
		freezeCount = freezeCount + 1
		workCount = workCount + 1		
		end
		
		if(workCount < numLetters) then
			working = true
		else
			working = false
			firstOne = true
			workCount = 0
			numLetters = 0
		end		
end

local function suspendLetters(event)
	if(not paused) then
	if(not working) then
	for i = 1, #allLetters do
		local oneLetter = allLetters[i]
		lettersToDelete[#lettersToDelete + 1] = allLetters[i]
		if(oneLetter.x < display.contentWidth and oneLetter.y < display.contentHeight) then
		physics.removeBody(oneLetter)
		physics.addBody(oneLetter, "kinematic")
		oneLetter:addEventListener("tap", getName)
		if(firstOne) then
			oneLetter:setFillColor(255,0,0)
			firstOne = false
		else
        oneLetter:setFillColor(50,50,255)
		end
		allLetters[i] = nil
		numLetters = numLetters + 1
		end
	end
	end
	local removeLetters = timer.performWithDelay(1000, clearFrozenLetters, numLetters)
	end	
end

function toMenu()
			audio.fadeOut({ channel=2, time=2000 } )
			clearCheckedWords()
			audio.stop(playMusic)
			audio.stop(playWind)
			pm:removeSelf()
			mb:removeSelf()
			rb:removeSelf()
			reb:removeSelf()
			timer.cancel(gravityIncrement)
			timer.cancel(dropLetters)
			timer.cancel(gameTimer)
			timer.cancel(cloudMaker)
			timer.cancel(cloudMover)
			timer.cancel(balloonMover)
			timer.cancel(difficultyTimer)
			for i = 1, #clouds do
				clouds[i]:removeSelf()
			end
			for i = 1, #balloons do
				balloons[i]:removeSelf()
			end
			for i = 1, #allLetters do
				allLetters[i]:removeSelf()
			end
			f:removeSelf()
			grass:removeSelf()
			timeBar:removeSelf()
			topCloud:removeSelf()
			pauseButton:removeSelf()
			Runtime:removeEventListener( "enterFrame", removeOffScreenClouds )
			Runtime:removeEventListener("enterFrame", removeOffScreenLetters )
			Runtime:removeEventListener("enterFrame", removeOffScreenBalloons)
			physics.stop()
			director:changeScene("menu")
end

function resumeGame()
		paused = false
		physics.start()
		pm:removeSelf()
		mb:removeSelf()
		rb:removeSelf()
		reb:removeSelf()
		timer.resume(difficultyTimer)
		timer.resume(gravityIncrement)
		timer.resume(dropLetters)
		timer.resume(gameTimer)
		timer.resume(cloudMaker)
		timer.resume(cloudMover)
		timer.resume(balloonMover)
end

function restartGame()
		clearCheckedWords()
			gameSpeed = 1
			pm:removeSelf()
			mb:removeSelf()
			rb:removeSelf()
			reb:removeSelf()
			totalScore = 0
			f:setText("")
			timeBar.width = 260
			timeBar:setReferencePoint(display.BottomLeftReferencePoint)
			timeBar.x = 20
			gravity = 1
			for i = 1, #allLetters do
				allLetters[i]:removeSelf()
			end
			allLetters = {}
			queuedLetters = {}
			wordCounter = 1
			currentLetter = ""
			currentWord = ""
			gameSpeed = .6
			physics.start()
			paused = false
			timer.resume(difficultyTimer)
			timer.resume(gravityIncrement)
			timer.resume(dropLetters)
			timer.resume(gameTimer)
			timer.resume(cloudMaker)
			timer.resume(cloudMover)
			timer.resume(balloonMover)	
			go = ui.newLabel{
			bounds = { -180, 55, 300, 40 },
			text = "Start!",
			font = "AmericanTypewriter-Bold",
			textColor = { 255, 40, 40, 255 },
			size = 60,
			align = "left"
			}
			go.y = 130
			transition.to(go, {time = 1400, alpha = 1, x = 540 })
			transition.dissolve(go, nil, 1500)
			
end

function pauseGame()

if(not paused) then
		paused = true
		physics.pause()
		pm = display.newImage("Pause menu.png")
		pm.x = 170
		pm.y = 280
		mb = ui.newButton {
		default = "Menu button.png",
		over =  "Menu button.png",
		onRelease = toMenu,
		text = "",
		emboss = true
		}
		mb.x = 179; mb.y = 210
		
		rb = ui.newButton {
		default = "resume button.png",
		over =  "resume button.png",
		onRelease = pauseGame,
		text = "",
		emboss = true
		}
		rb.x = 178; rb.y = 245
		
		reb = ui.newButton {
		default = "restart button.png",
		over =  "restart button.png",
		onRelease = restartGame,
		text = "",
		emboss = true
		}
		reb.x = 175; reb.y = 290
		timer.pause(difficultyTimer)
		timer.pause(gravityIncrement)
		timer.pause(dropLetters)
		timer.pause(gameTimer)
		timer.pause(cloudMaker)
		timer.pause(cloudMover)
		timer.pause(balloonMover)
		
else
		paused = false
		physics.start()
		pm:removeSelf()
		mb:removeSelf()
		rb:removeSelf()
		reb:removeSelf()
		timer.resume(difficultyTimer)
		timer.resume(gravityIncrement)
		timer.resume(dropLetters)
		timer.resume(gameTimer)
		timer.resume(cloudMaker)
		timer.resume(cloudMover)
		timer.resume(balloonMover)
end
	
end

function getScore()
totalScore = totalScore + score
if(timeBar.width + (score/10) > 260) then
timeBar.width =  260
timeBar:setReferencePoint(display.BottomLeftReferencePoint)
timeBar.x = 20

else
timeBar.width = timeBar.width + (score/10)
timeBar:setReferencePoint(display.BottomLeftReferencePoint)
timeBar.x = 20
end

score = 0;
f:setText(totalScore)
end
		
		
function clearWord(event)
	if(not paused) then
	local begin = event.xStart
	local endPoint = event.x
	
	if(endPoint - begin < -100) then
		currentLetter = ""
		currentWord = ""
		for i = 1, #queuedLetters do
			transition.dissolve(queuedLetters[i], nil, 500)
		end
		wordCounter = 1
		queuedLetters = {}
		scoreLetters = {}
		score = 0
	end
end
end
		
function incrementGravity()
	if(not paused) then
	gravity = gravity + .05
	physics.setGravity(0,gravity)
	end
end

function dragBody( event, params )
	if(not paused) then
	local body = event.target
	local phase = event.phase
	local stage = display.getCurrentStage()
    

	if "began" == phase then
		stage:setFocus( body, event.id )
		body.isFocus = true

		-- Create a temporary touch joint and store it in the object for later reference
		if params and params.center then
			-- drag the body from its center point
			body.tempJoint = physics.newJoint( "touch", body, body.x, body.y )
		else
			-- drag the body from the point where it was touched
			body.tempJoint = physics.newJoint( "touch", body, event.x, event.y )
		end

		-- Apply optional joint parameters
		if params then
			local maxForce, frequency, dampingRatio

			if params.maxForce then
				-- Internal default is (1000 * mass), so set this fairly high if setting manually
				body.tempJoint.maxForce = params.maxForce
			end
			
			if params.frequency then
				-- This is the response speed of the elastic joint: higher numbers = less lag/bounce
				body.tempJoint.frequency = params.frequency
			end
			
			if params.dampingRatio then
				-- Possible values: 0 (no damping) to 1.0 (critical damping)
				body.tempJoint.dampingRatio = params.dampingRatio
			end
		end
	
	elseif body.isFocus then
		if "moved" == phase then
		
			-- Update the joint to track the touch
			body.tempJoint:setTarget( event.x, event.y )

		elseif "ended" == phase or "cancelled" == phase then
			stage:setFocus( body, nil )
			body.isFocus = false
			
			-- Remove the joint when the touch ends			
			body.tempJoint:removeSelf()
			
		end
	end

	-- Stop further propagation of touch event
	return true
	end
end

function newLetter()
	if(not paused) then
	local n = math.random()
	for i=1, #letterFrequencies do
		if(letterFrequencies[i] > n) then
			rand = i
			break
		end
	end
	
		
	if (rand == 1) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-A-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "a"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 200
		else
			letter.points = 100
		end
			
		
	end
		
	if (rand == 2) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-B-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "b"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 600
		else
			letter.points = 300
		end
		
	end
		
	if (rand == 3) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-C-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "c"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 600
		else
			letter.points = 300
		end
		
	end
	
	if (rand == 4) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-D-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "d"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 400
		else
			letter.points = 200
		end
		
	end
		
	if (rand == 5) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-E-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "e"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 200
		else
			letter.points = 100
		end
		
	end	
		
	if (rand == 6) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-F-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "f"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 800
		else
			letter.points = 400
		end
		
	end
		
	if (rand == 7) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-G-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "g"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 400
		else
			letter.points = 200
		end
		
	end
		
	if (rand == 8) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-H-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "h"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 800
		else
			letter.points = 400
		end
		
	end
		
	if (rand == 9) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-I-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "i"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 200
		else
			letter.points = 100
		end
		
	end
	
	if (rand == 10) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-J-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "j"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 1600
		else
			letter.points = 800
		end
		
	end	
	
	if (rand == 11) then
	allLetters[#allLetters + 1] = display.newImage( "Letter-K-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )	
		letter:addEventListener("tap", getName)
		letter.name = "k"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 1000
		else
			letter.points = 500
		end
		
	end	
	
	if (rand == 12) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-L-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )	
		letter:addEventListener("tap", getName)
		letter.name = "l"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 200
		else
			letter.points = 100
		end
		
	end			
	
	if (rand == 13) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-M-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )	
		letter:addEventListener("tap", getName)
		letter.name = "m"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 600
		else
			letter.points = 300
		end
		
	end	
	
	if (rand == 14) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-N-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "n"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 200
		else
			letter.points = 100
		end
		
	end	
	
	if (rand == 15) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-O-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "o"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 200
		else
			letter.points = 100
		end
		
	end	
	
	if (rand == 16) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-P-icon.png" )
		local letter = allLetters[#allLetters]
		displayGroup:insert(letter)
		letter.index = #allLetters
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "p"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 600
		else
			letter.points = 300
		end
		
	end	
	
	if (rand == 17) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-Q-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "q"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 2000
		else
			letter.points = 1000
		end
		
	end		
	
	if (rand == 18) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-R-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "r"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 200
		else
			letter.points = 100
		end
		
	end	
	
	if (rand == 19) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-S-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "s"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 200
		else
			letter.points = 100
		end
		
	end	
	
	if (rand == 20) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-T-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "t"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 200
		else
			letter.points = 100
		end
		
	end	
	
	if (rand == 21) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-U-icon.png" )
		local letter = allLetters[#allLetters]
		displayGroup:insert(letter)
		letter.index = #allLetters
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)	
		letter.name = "u"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 200
		else
			letter.points = 100
		end
		
	end	
	
	if (rand == 22) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-V-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "v"	
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 800
		else
			letter.points = 400
		end
		
	end	
	
	if (rand == 23) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-W-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "w"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 800
		else
			letter.points = 400
		end
		
	end	
	
	if (rand == 24) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-X-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "x"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 1600
		else
			letter.points = 800
		end
	end	
	
	if (rand == 25) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-Y-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "y"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 800
		else
			letter.points = 400
		end
	end	
	
	if (rand == 26) then
		allLetters[#allLetters + 1] = display.newImage( "Letter-Z-icon.png" )
		local letter = allLetters[#allLetters]
		letter.index = #allLetters
		displayGroup:insert(letter)
		letter:toBack()
		letter.x = math.random(20, 300)
		letter.y = 0
		physics.addBody( letter, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
		letter:addEventListener("touch", dragBody )
		letter:addEventListener("tap", getName)
		letter.name = "z"
		multiplier = math.random()
		if(multiplier > .8) then
			letter:setFillColor(255, 218, 0)
			letter.points = 2000
		else
			letter.points = 1000
		end
	end	
		
end
end
local function removeOffScreenLetters()
	for i = 1, #allLetters do
		local oneLetter = allLetters[i]
		if (oneLetter and oneLetter.x) then
			if oneLetter.x < -10 or oneLetter.x > display.contentWidth or oneLetter.y < -60 or oneLetter.y > display.contentHeight then
				oneLetter:removeSelf()
                table.remove( allLetters, i )
 			end	
		end
	end
end

local function removeOffScreenBalloons()
	for i = 1, #balloons do
		local b1 = balloons[i]
		if(b1 and b1.x) then
			if(b1.y < 0) then
				b1:removeSelf()
				table.remove( balloons, i)
			end
		end
	end
end

local function removeOffScreenClouds()
	for i = 1, #clouds do
		local oneCloud = clouds[i]
		if (oneCloud and oneCloud.x) then
			if oneCloud.x > 400 then
				oneCloud:removeSelf()
                table.remove( clouds, i )
 			end	
		end
	end
end

local function checkWord(event)
	
if(not paused) then
	local begin = event.xStart
	local endPoint = event.x
		
		if(firstLetter == "a") then
			startingIndex = 1
		end
		
		if(firstLetter == "b") then
			startingIndex = 17096
		end
		
		if(firstLetter == "c") then
			startingIndex = 28166
		end
		
		if(firstLetter == "d") then
			startingIndex = 48067
		end
		
		if(firstLetter == "e") then
			startingIndex = 58963
		end
		
		if(firstLetter == "f") then
			startingIndex = 67699
		end
		
		if(firstLetter == "g") then
			startingIndex = 74559
		end
		
		if(firstLetter == "h") then
			startingIndex = 81420
		end
		
		if(firstLetter == "i") then
			startingIndex = 90447
		end
		
		if(firstLetter == "j") then
			startingIndex = 99246
		end
		
		if(firstLetter == "k") then
			startingIndex = 100888
		end
		
		if(firstLetter == "l") then
			startingIndex = 103169
		end
		
		if(firstLetter == "m") then
			startingIndex = 109453
		end
		
		if(firstLetter == "n") then
			startingIndex = 122069
		end
		
		if(firstLetter == "o") then
			startingIndex = 128849
		end
		
		if(firstLetter == "p") then
			startingIndex = 136698
		end
		
		if(firstLetter == "q") then
			startingIndex = 161159
		end
		
		if(firstLetter == "r") then
			startingIndex = 162311
		end
		
		if(firstLetter == "s") then
			startingIndex = 171982
		end
		
		if(firstLetter == "t") then
			startingIndex = 197144
		end
		
		if(firstLetter == "u") then
			startingIndex = 210110
		end
		
		if(firstLetter == "v") then
			startingIndex = 226497
		end
		
		if(firstLetter == "w") then
			startingIndex = 229937
		end
		
		if(firstLetter == "x") then
			startingIndex = 233881
		end
		
		if(firstLetter == "y") then
			startingIndex = 243266
		end
		
		if(firstLetter == "z") then
			startingIndex = 234937
		end
		
		
		
if(endPoint - begin > 100 and firstLetter ~= "" and  currentLetter ~= "" and touchCount == 1) then
currentWord = currentLetter
for i = startingIndex, #myList do
	if(myList[i] == currentWord) then
			audio.play(rewardSound, { channel=6, loops=0, fadein=0 } )
			local scoreCheck = getScore()
			for i = 1, #queuedLetters do	
			transition.to(queuedLetters[i], {time = 400, alpha = 0, x = 160, y = 325})
			end
			addCheckedWord(currentWord)
			check = display.newImage("correct word.png")
			check.xScale = .6
			check.yScale = .6
			check.x = 180
			check.y = 280
			transition.to( check, { time = 1000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic }) -- "pop" animation
			transition.dissolve(check, nil, 1000)
			score = 0
			for i = 1, string.len(currentWord) do
				local numb = math.random(1,4)
				local b = display.newImage(balloonColors[numb])
				b:scale(.3, .3)
				b.speed = math.random(1,10)
				displayGroup:insert(b)
				b:toBack()
				balloons[#balloons + 1] = b
				b.index = #balloons
				b.x = math.random(10, 310)
				b.y = 450
				b:addEventListener("tap", balloonPopped)
			end
			queuedLetters ={}
			currentLetter = ""
			currentWord = ""
			firstLetter = ""
			startingIndex = 1
			wordCounter = 1
			touchCount = touchCount + 1
			found = true
			break
	end
	
		if(firstLetter ~= string.sub(myList[i],1, 1)) then
		break
		end
end

if(not found and touchCount == 1 ) then
	for i = 1, #queuedLetters do
			transition.dissolve(queuedLetters[i], nil, 500)
	end
	audio.play(clangSound, { channel=6, loops=0, fadein=0 } )
	wrongWord = display.newImage("wrong word.png")
	wrongWord.xScale = .6
	wrongWord.yScale = .6
	wrongWord.x = 165
	wrongWord.y = 240
	transition.to( wrongWord, { time = 1000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic }) -- "pop" animation
	transition.dissolve(wrongWord, nil, 1000)
	score = 0;
	queuedLetters ={}
	currentLetter = ""
	currentWord = ""
	firstLetter = ""
	startingIndex = 1
	wordCounter = 1
	touchCount = touchCount + 1
end

found = false
end
end

if(event.phase == "ended" or event.phase == "cancelled") then
	touchCount = 1
end
end

function getName(event)
if(not paused) then
if(wordCounter == 1) then
	transition.to( event.target, {time = 500, alpha = 1, x = 25, y = 25})
	event.target:scale(.7, .7)
	currentLetter = event.target.name
	firstLetter = event.target.name
	score = score + event.target.points
	queuedLetters[#queuedLetters + 1] = event.target
	event.target:toFront()
	physics.removeBody(event.target)
	event.target:removeEventListener("tap", getName)
	event.target:removeEventListener("touch", dragBody)
	audio.play(whooshSound, { channel=audio.findFreeChannel(), loops=0, fadein=0 } )
	
end

if(wordCounter == 2) then
	transition.to( event.target, {time = 500, alpha = 1, x = 55, y = 25})
	event.target:scale(.7, .7)
	currentLetter =  currentLetter .. event.target.name
	score = score + event.target.points
	queuedLetters[#queuedLetters + 1] = event.target
	event.target:toFront()
	physics.removeBody(event.target)
	event.target:removeEventListener("tap", getName)
	event.target:removeEventListener("touch", dragBody)
	audio.play(whooshSound, { channel=audio.findFreeChannel(), loops=0, fadein=0 } )
end

if(wordCounter == 3) then
	transition.to( event.target, {time = 500, alpha = 1, x = 85, y = 25})
	event.target:scale(.7, .7)
	currentLetter = currentLetter .. event.target.name
	score = score + event.target.points
	queuedLetters[#queuedLetters + 1] = event.target
	event.target:toFront()
	physics.removeBody(event.target)
	event.target:removeEventListener("tap", getName)
	event.target:removeEventListener("touch", dragBody)
	audio.play(whooshSound, { channel=audio.findFreeChannel(), loops=0, fadein=0 } )
end

if(wordCounter == 4) then
	transition.to( event.target, {time = 500, alpha = 1, x = 115, y = 25})
	event.target:scale(.7, .7)
	currentLetter = currentLetter .. event.target.name
	score = score + event.target.points
	queuedLetters[#queuedLetters + 1] = event.target
	event.target:toFront()
	physics.removeBody(event.target)
	event.target:removeEventListener("tap", getName)
	event.target:removeEventListener("touch", dragBody)
	audio.play(whooshSound, { channel=audio.findFreeChannel(), loops=0, fadein=0 } )
end

if(wordCounter == 5) then
	transition.to( event.target, {time = 500, alpha = 1, x = 145, y = 25})
	event.target:scale(.7, .7)
	currentLetter = currentLetter .. event.target.name
	score = score + event.target.points
	queuedLetters[#queuedLetters + 1] = event.target
	event.target:toFront()
	physics.removeBody(event.target)
	event.target:removeEventListener("tap", getName)
	event.target:removeEventListener("touch", dragBody)
	audio.play(whooshSound, { channel=audio.findFreeChannel(), loops=0, fadein=0 } )
	
end

if(wordCounter == 6) then
	transition.to( event.target, {time = 500, alpha = 1, x = 175, y = 25})
	event.target:scale(.7, .7)
	currentLetter = currentLetter .. event.target.name
	score = score + event.target.points
	queuedLetters[#queuedLetters + 1] = event.target
	event.target:toFront()
	physics.removeBody(event.target)
	event.target:removeEventListener("tap", getName)
	event.target:removeEventListener("touch", dragBody)
	audio.play(whooshSound, { channel=audio.findFreeChannel(), loops=0, fadein=0 } )
	
end

if(wordCounter == 7) then
	transition.to( event.target, {time = 500, alpha = 1, x =205, y = 25})
	event.target:scale(.7, .7)
	currentLetter = currentLetter .. event.target.name
	score = score + event.target.points
	queuedLetters[#queuedLetters + 1] = event.target
	event.target:toFront()
	physics.removeBody(event.target)
	event.target:removeEventListener("tap", getName)
	event.target:removeEventListener("touch", dragBody)
	audio.play(whooshSound, { channel=audio.findFreeChannel(), loops=0, fadein=0 } )
	
end

if(wordCounter == 8) then
	transition.to( event.target, {time = 500, alpha = 1, x = 235, y = 25})
	event.target:scale(.7, .7)
	currentLetter = currentLetter .. event.target.name
	score = score + event.target.points
	queuedLetters[#queuedLetters + 1] = event.target
	event.target:toFront()
	physics.removeBody(event.target)
	event.target:removeEventListener("tap", getName)
	event.target:removeEventListener("touch", dragBody)
	audio.play(whooshSound, { channel=audio.findFreeChannel(), loops=0, fadein=0 } )
	
end

if(wordCounter == 9) then
	transition.to( event.target, {time = 500, alpha = 1, x = 265, y = 25})
	event.target:scale(.7, .7)
	currentLetter = currentLetter .. event.target.name
	score = score + event.target.points
	queuedLetters[#queuedLetters + 1] = event.target
	event.target:toFront()
	physics.removeBody(event.target)
	event.target:removeEventListener("tap", getName)
	event.target:removeEventListener("touch", dragBody)
	audio.play(whooshSound, { channel=audio.findFreeChannel(), loops=0, fadein=0 } )
	
end

if(wordCounter == 10) then
	transition.to( event.target, {time = 500, alpha = 1, x = 295, y = 25})
	event.target:scale(.7, .7)
	currentLetter = currentLetter .. event.target.name
	score = score + event.target.points
	queuedLetters[#queuedLetters + 1] = event.target
	event.target:toFront()
	physics.removeBody(event.target)
	event.target:removeEventListener("tap", getName)
	event.target:removeEventListener("touch", dragBody)
	audio.play(whooshSound, { channel=audio.findFreeChannel(), loops=0, fadein=0 } )
	
end
wordCounter = wordCounter + 1

end

end



local function generateClouds()
		cloud = display.newImage("Clouds.png")
		displayGroup:insert(cloud)
		cloud:toBack()
		clouds[#clouds + 1] = cloud
		cloud.x = -50
		cloud.y = math.random(30, 400)
		cloudScale = math.random()
		if(cloudScale > .6) then
			cloudScale = .5
		end
		cloud:scale(cloudScale, cloudScale)
		cloud.speed = math.random()
	end
	
cloudMaker = timer.performWithDelay(11000, generateClouds, 0)
	
	local function moveClouds()
		for i = 1, #clouds do
			clouds[i]:translate(clouds[i].speed, 0)
	end
	end
	
cloudMover = timer.performWithDelay(10, moveClouds, 0)

local function moveBalloons()
		for i = 1, #balloons do
			if(balloons[i] ~= nil) then
			balloons[i]:translate(0, -balloons[i].speed)
			end
	end
end

balloonMover = timer.performWithDelay(10, moveBalloons, 0)
	

bg = display.newImage("background.png")
grass = display.newImage("grass.png")
grass.x = 160
displayGroup:insert(grass)
topCloud = display.newImage("top cloud.png")
topCloud.x = 160
rightWall = display.newImage("wall.jpeg")
rightWall.x = 325
leftWall = display.newImage("wall.jpeg")
leftWall.x = -5
physics.addBody(rightWall, "static")
physics.addBody(leftWall, "static")
timeBar = display.newRoundedRect( 20, 460 , 260, 10, 4 )
timeBar:setReferencePoint(display.BottomLeftReferencePoint)
timeBar.x = 20


bg:addEventListener("touch", clearWord)
bg:addEventListener("touch", checkWord)

pauseButton = ui.newButton{
	default = "pause button.png",
	over = "pause button.png",
	onRelease = pauseGame,
	text = "",
	emboss = true
}
pauseButton.x = 300;pauseButton.y = 463	


localGroup: insert( bg )
localGroup:insert(topCloud)
displayGroup:insert(topCloud)
topCloud:toFront()
localGroup:insert( leftWall )
localGroup:insert( rightWall )
localGroup:insert( timeBar)
displayGroup:insert(timeBar)
timeBar:toFront()
f:toFront()
grass:toBack()

local function loseTime (event)
	if(not paused) then
		timeBar.width = timeBar.width - gameSpeed
		timeBar:setReferencePoint(display.BottomLeftReferencePoint)
		timeBar.x = 20
		if(timeBar.width < 5) then
			audio.stop(playMusic)
			audio.stop(playWind)
			audio.dispose(playMusic)
			audio.dispose(playWind)
			timer.cancel(gravityIncrement)
			timer.cancel(dropLetters)
			timer.cancel(gameTimer)
			timer.cancel(cloudMaker)
			timer.cancel(cloudMover)
			timer.cancel(balloonMover)
			timer.cancel(difficultyTimer)
			for i = 1, #clouds do
				clouds[i]:removeSelf()
			end
			for i = 1, #balloons do
				balloons[i]:removeSelf()
			end
			for i = 1, #allLetters do
				allLetters[i]:removeSelf()
			end
			f:removeSelf()
			grass:removeSelf()
			timeBar:removeSelf()
			topCloud:removeSelf()
			pauseButton:removeSelf()
			Runtime:removeEventListener( "enterFrame", removeOffScreenClouds )
			Runtime:removeEventListener("enterFrame", removeOffScreenLetters )
			Runtime:removeEventListener("enterFrame", removeOffScreenBalloons)
			physics.stop()	
			hp = tonumber(loadValue("highscores.txt"))
			if(totalScore > hp) then
			saveValue("highscores.txt", totalScore)
			end	
			director:changeScene("gameOver")
		end	
	end
end

	physics.setGravity(0, 1)
	transition.to(go, {time = 1400, alpha = 1, x = 540 })
	transition.dissolve(go, nil, 1500)
	gravityIncrement = timer.performWithDelay(10000, incrementGravity, 0)
	dropLetters = timer.performWithDelay(1200, newLetter, 0)
	gameTimer = timer.performWithDelay(100 ,loseTime, 0)
	difficultyTimer = timer.performWithDelay(30000, increaseDifficulty, 0)
	Runtime:addEventListener( "enterFrame", removeOffScreenLetters )
	Runtime:addEventListener( "enterFrame", removeOffScreenClouds )
	Runtime:addEventListener( "enterFrame", removeOffScreenBalloons )



return localGroup



end


