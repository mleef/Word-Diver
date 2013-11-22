module(..., package.seeall)

function new()
local physics = require("physics")
local ui = require("ui")
local localGroup = display.newGroup()
local globalGroup = display.newGroup()
local balloons = {}
local balloonColors = {"yellow balloon.png", "purple balloon.png", "balloon.png", "green balloon.png"}
local clouds = {}	
local balloonMover
local check
local cloudMaker
local cloudMover
local topCloud
local grass
local timeBar
local firstText
local secondText
local thirdText
local fourthText
local letterF
local letterU
local letterN
local firstTimer
local threeHalfsTimer
local secondTimer
local thirdTimer
local fourthTimer
local fifthTimer
local sixthTimer
local seventhTimer
local eigthTimer
local ninthTimer
local tenthTimer
local eleventhTimer
local barTimer
math.randomseed(os.time())
local music = audio.loadStream("Happy Alley.mp3")
local playMusic = audio.play(music, { channel=1, loops=-1, fadein=2000 } )
local popSound = audio.loadSound("pop.mp3")
local whooshSound = audio.loadSound("whoosh.mp3")
local clangSound = audio.loadSound("clang.mp3")
local rewardSound = audio.loadSound("reward.mp3")
physics.start()
	
local function loseTime()
	timeBar.width = timeBar.width - 1
	timeBar:setReferencePoint(display.BottomLeftReferencePoint)
	timeBar.x = 20
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

local function moveBalloons()
		for i = 1, #balloons do
			if(balloons[i] ~= nil) then
			balloons[i]:translate(0, -balloons[i].speed)
			end
	end
end

balloonMover = timer.performWithDelay(10, moveBalloons, 0)
	
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

	
	local function generateClouds()
		cloud = display.newImage("Clouds.png")
		globalGroup:insert(cloud)
		cloud:toBack()
		clouds[#clouds + 1] = cloud
		cloud.x = -50
		cloud.y = math.random(20, 200)
		cloudScale = math.random()
		if(cloudScale > .6) then
			cloudScale = .5
		end
		cloud:scale(cloudScale, cloudScale)
		cloud.speed = math.random(1,5)
	end
	
	cloudMaker = timer.performWithDelay(5000, generateClouds, 0)
	
	local function moveClouds()
		for i = 1, #clouds do
			clouds[i]:translate(clouds[i].speed, 0)
		end
				
	end
	
	cloudMover = timer.performWithDelay(10, moveClouds, 0)


	
local background = display.newImageRect( "background.png", display.contentWidth, display.contentHeight )
background:setReferencePoint( display.TopLeftReferencePoint )
background.x, background.y = 0, 0
	
	
topCloud = display.newImage("top cloud.png")
topCloud.x = 160
grass = display.newImage("grass.png")
grass.x = 160
timeBar = display.newRoundedRect( 20, 460 , 260, 10, 4 )
timeBar:setReferencePoint(display.BottomLeftReferencePoint)
timeBar.x = 20
		
	
localGroup:insert(background)	
globalGroup:insert(grass)
grass:toFront()
globalGroup:insert(topCloud)
topCloud:toFront()
globalGroup:insert(timeBar)
timeBar:toFront()

local function firstStep()
	firstText = display.newText("The object of the game is to tap" , 8, 200, "AmericanTypewriter-Bold", 19)
	secondText = display.newText("falling letters in order to form" , 8, 220, "AmericanTypewriter-Bold", 19)
	thirdText = display.newText("the best words. Best meaning" , 8, 240, "AmericanTypewriter-Bold", 19)
	fourthText = display.newText("the longest words/rarest letters." , 8, 260, "AmericanTypewriter-Bold", 19)
	transition.dissolve(firstText, nil, 7000)
	transition.dissolve(secondText, nil, 8000)
	transition.dissolve(thirdText, nil, 9000)
	transition.dissolve(fourthText, nil, 10000)
end

local function threeHalfsStep()
	firstText = display.newText("You can drag letters, hit them" , 8, 200, "AmericanTypewriter-Bold", 19)
	secondText = display.newText("against each other, or throw " , 8, 220, "AmericanTypewriter-Bold", 19)
	thirdText = display.newText("them off walls to keep them in" , 8, 240, "AmericanTypewriter-Bold", 19)
	fourthText = display.newText("play." , 8, 260, "AmericanTypewriter-Bold", 19)
	transition.dissolve(firstText, nil, 7000)
	transition.dissolve(secondText, nil, 8000)
	transition.dissolve(thirdText, nil, 9000)
	transition.dissolve(fourthText, nil, 10000)
end

local function secondStep()
	letterF = display.newImage( "Letter-F-icon.png" )
	globalGroup:insert(letterF)
	letterF:toBack()
	letterF.x = 30
	letterF.y = 0
	physics.addBody( letterF, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
end

local function thirdStep()
	audio.play(whooshSound, { channel=4, loops=0, fadein=0 } )
	physics.removeBody(letterF)
	letterF:toFront()
	transition.to(letterF, {time = 500, alpha = 1, x = 25, y = 25})
	letterF:scale(.7, .7)
	letterU = display.newImage( "Letter-U-icon.png" )
	globalGroup:insert(letterU)
	letterU:toBack()
	letterU.x = 100
	letterU.y = 0
	physics.addBody( letterU, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
end

local function fourthStep()
	audio.play(whooshSound, { channel=4, loops=0, fadein=0 } )
	physics.removeBody(letterU)
	letterU:toFront()
	transition.to(letterU, {time = 500, alpha = 1, x = 55, y = 25})
	letterU:scale(.7, .7)
	letterN = display.newImage( "Letter-N-icon.png" )
	letterN:setFillColor(255, 218, 0)
	globalGroup:insert(letterN)
	letterN:toBack()
	letterN.x = 200
	physics.addBody( letterN, "dynamic", { density=0.3, friction=0.3, bounce=0.3} )
	fourthText = display.newText("Gold letters = double the score!" , 8, 100, "AmericanTypewriter-Bold", 19)
	transition.dissolve(fourthText, nil, 5000)
end

local function fifthStep()
	audio.play(whooshSound, { channel=4, loops=0, fadein=0 } )
	physics.removeBody(letterN)
	letterN:toFront()
	transition.to(letterN, {time = 500, alpha = 1, x = 85, y = 25})
	letterN:scale(.7, .7)
	firstText = display.newText("Once your word is queued, swipe" , 8, 200, "AmericanTypewriter-Bold", 19)
	secondText = display.newText("right anywhere to check/score" , 8, 220, "AmericanTypewriter-Bold", 19)
	thirdText = display.newText("it or swipe left to clear the word." , 8, 240, "AmericanTypewriter-Bold", 19)
	transition.dissolve(firstText, nil, 7000)
	transition.dissolve(secondText, nil, 8000)
	transition.dissolve(thirdText, nil, 9000)
end

local function sixthStep()
	audio.play(rewardSound, { channel=5, loops=0, fadein=0 } )
	transition.to(letterF, {time = 400, alpha = 0, x = 160, y = 325})
	transition.to(letterU, {time = 400, alpha = 0, x = 160, y = 325})
	transition.to(letterN, {time = 400, alpha = 0, x = 160, y = 325})
	check = display.newImage("correct word.png")
	check.xScale = .6
	check.yScale = .6
	check.x = 180
	check.y = 280
	transition.to( check, { time = 1000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic }) -- "pop" animation
	transition.dissolve(check, nil, 1000)	
	f:setText(600)	
end

local function seventhStep()
	firstText = display.newText("All real words will be counted," , 8, 200, "AmericanTypewriter-Bold", 19)
	secondText = display.newText("but all invalid words will be" , 8, 220, "AmericanTypewriter-Bold", 19)
	thirdText = display.newText("met with a big fat red X." , 8, 240, "AmericanTypewriter-Bold", 19)
	fourthText = display.newText("Pluralizing words will not work." , 8, 260, "AmericanTypewriter-Bold", 19)
	transition.dissolve(firstText, nil, 7000)
	transition.dissolve(secondText, nil, 8000)
	transition.dissolve(thirdText, nil, 9000)
	transition.dissolve(fourthText, nil, 10000)
end

local function eighthStep()
	firstText = display.newText("For every letter in the correct" , 8, 200, "AmericanTypewriter-Bold", 19)
	secondText = display.newText("word, a balloon will float up the" , 8, 220, "AmericanTypewriter-Bold", 19)
	thirdText = display.newText("screen. Pop for extra points." , 8, 240, "AmericanTypewriter-Bold", 19)
	transition.dissolve(firstText, nil, 7000)
	transition.dissolve(secondText, nil, 8000)
	transition.dissolve(thirdText, nil, 9000)	
	for i = 1, 3 do
				local numb = math.random(1,4)
				local b = display.newImage(balloonColors[numb])
				b:scale(.3, .3)
				b.speed = math.random(1,2)
				globalGroup:insert(b)
				b:toBack()
				balloons[#balloons + 1] = b
				b.index = #balloons
				b.x = math.random(10, 310)
				b.y = 450
			end
end

local function ninthStep()
	
	for i = 1, 3 do
	transition.to( balloons[i], { time = 1000, xScale = .5, yScale = .5, transition = easingx.easeOutElastic })
	audio.play(popSound, { channel=3, loops=0, fadein=0 } )
	transition.dissolve(balloons[i], nil, 500)
	end
	f:setText(1600)
	
end

local function tenthStep()
	
	barTimer = timer.performWithDelay(7, loseTime, 0)
	firstText = display.newText("All points will add to the length" , 8, 200, "AmericanTypewriter-Bold", 19)
	secondText = display.newText("of the time bar at the bottom." , 8, 220, "AmericanTypewriter-Bold", 19)
	thirdText = display.newText("If the bar runs out, it's game" , 8, 240, "AmericanTypewriter-Bold", 19)
	fourthText = display.newText("over." , 8, 260, "AmericanTypewriter-Bold", 19)
	transition.dissolve(firstText, nil, 5000)
	transition.dissolve(secondText, nil, 6000)
	transition.dissolve(thirdText, nil, 7000)	
	transition.dissolve(fourthText, nil, 8000)	
end

local function eleventhStep()
	audio.stop(playMusic)
	topCloud:removeSelf()
	grass:removeSelf()
	timeBar:removeSelf()
	f:removeSelf()
	Runtime:removeEventListener("enterFrame", removeOffScreenClouds)
	timer.cancel(cloudMaker)
	timer.cancel(cloudMover)
	timer.cancel(barTimer)
	for i = 1, #clouds do
		clouds[i]:removeSelf()
	end
	globalGroup:remove()
	firstText:removeSelf()
	director:changeScene("menu")
end
	
	
	


Runtime:addEventListener("enterFrame", removeOffScreenClouds)
firstTimer = timer.performWithDelay(500, firstStep, 1)
threeHalfsTimer = timer.performWithDelay(8000, threeHalfsStep, 1)
secondTimer = timer.performWithDelay(15000, secondStep, 1)
thirdTimer = timer.performWithDelay(16300, thirdStep, 1)
fourthTimer = timer.performWithDelay(17600, fourthStep, 1)
fifthTimer = timer.performWithDelay(18900, fifthStep, 1)
sixthTimer = timer.performWithDelay(25900, sixthStep, 1)
seventhTimer = timer.performWithDelay(27900, seventhStep, 1)
eigthTimer = timer.performWithDelay(35900, eighthStep, 1)
ninthTimer = timer.performWithDelay(40000, ninthStep, 1)
tenthTimer = timer.performWithDelay(42900, tenthStep, 1)
eleventhTimer = timer.performWithDelay(50100, eleventhStep, 1)

return localGroup
end