module(..., package.seeall)

function new()
local localGroup = display.newGroup()
local easingx = require("easingx")
local widget = require("widget")
local playBtn
local clouds = {}
local words = {}
local wordList = checkedWords
local cloudMaker
local score
local cloudMover
local wordMaker
local count = 1
local wordMover
local path = system.pathForFile( "highscores.txt", system.DocumentsDirectory )
globalGroup = display.newGroup()

local background = display.newImageRect( "background.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	
	local w = display.newImage("Letter-G-icon.png")
	w.x = 70
	w.y = -10
	w:scale(.6, .6)
	
	local o = display.newImage("Letter-A-icon.png")
	o.x = 110
	o.y = -10
	o:scale(.6, .6)
	
	local r = display.newImage("Letter-M-icon.png")
	r.x = 150
	r.y = -10
	r:scale(.6, .6)
	
	local d1 = display.newImage("Letter-E-icon.png")
	d1.x = 190
	d1.y = -10
	d1:scale(.6, .6)
	
	local d2 = display.newImage("Letter-O-icon.png")
	d2.x = 130
	d2.y = -10
	d2:scale(.6, .6)
	
	local e = display.newImage("Letter-R-icon.png")
	e.x = 250
	e.y = -10
	e:scale(.6, .6)
	
	local v = display.newImage("Letter-E-icon.png")
	v.x = 210
	v.y = -10
	v:scale(.6, .6)
	
	local i = display.newImage("Letter-V-icon.png")
	i.x = 170
	i.y = -10
	i:scale(.6, .6)
	
	transition.to(w, {time = 500, alpha = 1, x = 70, y = 80})
	transition.to( w, { time = 2000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic })
	transition.to(o, {time = 500, alpha = 1, x = 110, y = 80})
	transition.to( o, { time = 2000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic })
	transition.to(r, {time = 500, alpha = 1, x = 150, y = 80})
	transition.to( r, { time = 2000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic })
	transition.to(d1, {time = 500, alpha = 1, x = 190, y = 80})
	transition.to( d1, { time = 2000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic })
	transition.to(d2, {time = 500, alpha = 1, x = 130, y = 120})
	transition.to( d2, { time = 2000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic })
	transition.to(i, {time = 500, alpha = 1, x = 170, y = 120})
	transition.to( i, { time = 2000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic })
	transition.to(v, {time = 500, alpha = 1, x = 210, y = 120})
	transition.to( v, { time = 2000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic })
	transition.to(e, {time = 500, alpha = 1, x = 250, y = 120})
	transition.to( e, { time = 2000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic })

	
	
local function onPlayBtnRelease()
	playBtn:removeSelf()
	Runtime:removeEventListener("enterScene", removeOffScreenClouds)
	w:removeSelf()
	o:removeSelf()
	r:removeSelf()
	d1:removeSelf()
	d2:removeSelf()
	i:removeSelf()
	v:removeSelf()
	e:removeSelf()
	timer.cancel(cloudMaker)
	timer.cancel(cloudMover)
	timer.cancel(wordMaker)
	timer.cancel(wordMover)
	score: removeSelf()
	for i = 1, #clouds do
		clouds[i]:removeSelf()
	end
	for i = 1, #words do
		words[i]:removeSelf()
	end
	clearCheckedWords()
	director:changeScene("menu")
end

local function generateClouds()
		cloud = display.newImage("Clouds.png")
		globalGroup:insert(cloud)
		cloud:toBack()
		clouds[#clouds + 1] = cloud
		cloud.x = -50
		cloud.y = math.random(20, 440)
		cloudScale = math.random()
		if(cloudScale > .6) then
			cloudScale = .5
		end
		cloud:scale(cloudScale, cloudScale)
		cloud.speed = math.random(1,5)
	end
	
	cloudMaker = timer.performWithDelay(1000, generateClouds, 0)
	
	local function moveClouds()
		for i = 1, #clouds do
			clouds[i]:translate(clouds[i].speed, 0)
		end
	end
	
	cloudMover = timer.performWithDelay(10, moveClouds, 0)

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

local function generateWords()
	if(wordList[count] ~= nil) then
	local word = display.newText(wordList[count], -40, math.random(20, 400), "AmericanTypewriter-Bold", math.random(10,30))
	globalGroup:insert(word)
	word:toBack()
	word.speed = math.random(1,5)
	words[#words + 1] = word
	count = count + 1
	else
	end
end

wordMaker = timer.performWithDelay(1200, generateWords, #checkedWords)

local function moveWords()
	for i = 1, #words do
		words[i]:translate(words[i].speed, 0)
	end
end

wordMover = timer.performWithDelay(10, moveWords, 0)
	

	
	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="",
		labelColor = { default={255}, over={128} },
		default="back-button.png",
		over="back-button-press.png",
		width=100, height=100,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn:toFront()
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 125
	
	Runtime:addEventListener("enterFrame", removeOffScreenClouds)
	
	hp = tonumber(loadValue("highscores.txt"))
	score = display.newText("Highscore:   " .. hp, 30, 200, "AmericanTypewriter-Bold", 25)
	score:setTextColor(255,40,40)

	globalGroup:insert(playBtn)
	playBtn:toFront()
	
	-- all display objects must be inserted into group
	localGroup:insert( background )
	
	
	return localGroup
end