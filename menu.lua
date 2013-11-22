module(..., package.seeall)

function new()
local localGroup = display.newGroup()
local music = audio.loadStream("Poofy Reel.mp3")
local easingx = require("easingx")
local globalGroup = display.newGroup()
local clouds = {}
local widget = require "widget"
math.randomseed(os.time())
local gameModesBtn
local cloudMaker
local cloudMover

local playMusic = audio.play(music, { channel=1, loops=-1, fadein=2000 } )


local w = display.newImage("Letter-W-icon.png")
	w.x = 70
	w.y = -10
	w:scale(.6, .6)
	
	local o = display.newImage("Letter-O-icon.png")
	o.x = 110
	o.y = -10
	o:scale(.6, .6)
	
	local r = display.newImage("Letter-R-icon.png")
	r.x = 150
	r.y = -10
	r:scale(.6, .6)
	
	local d1 = display.newImage("Letter-D-icon.png")
	d1.x = 190
	d1.y = -10
	d1:scale(.6, .6)
	
	local d2 = display.newImage("Letter-D-icon.png")
	d2.x = 130
	d2.y = -10
	d2:scale(.6, .6)
	
	local e = display.newImage("Letter-E-icon.png")
	e.x = 250
	e.y = -10
	e:scale(.6, .6)
	
	local v = display.newImage("Letter-V-icon.png")
	v.x = 210
	v.y = -10
	v:scale(.6, .6)
	
	local i = display.newImage("Letter-I-icon.png")
	i.x = 170
	i.y = -10
	i:scale(.6, .6)
	
	local r2 = display.newImage("Letter-R-icon.png")
	r2.x = 250
	r2.y = -10
	r2:scale(.6,.6)
	
	
	
	transition.to(w, {time = 500, alpha = 1, x = 70, y = 80})
	transition.to( w, { time = 2000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic })
	transition.to(o, {time = 500, alpha = 1, x = 110, y = 80})
	transition.to( o, { time = 2000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic })
	transition.to(r, {time = 500, alpha = 1, x = 150, y = 80})
	transition.to( r, { time = 2000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic })
	transition.to(d1, {time = 500, alpha = 1, x = 190, y = 80})
	transition.to( d1, { time = 2000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic })
	transition.to(d2, {time = 500, alpha = 1, x = 90, y = 120})
	transition.to( d2, { time = 2000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic })
	transition.to(i, {time = 500, alpha = 1, x = 130, y = 120})
	transition.to( i, { time = 2000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic })
	transition.to(v, {time = 500, alpha = 1, x = 170, y = 120})
	transition.to( v, { time = 2000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic })
	transition.to(e, {time = 500, alpha = 1, x = 210, y = 120})
	transition.to( e, { time = 2000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic })
	transition.to(r2, {time = 500, alpha = 1, x = 250, y = 120})
	transition.to( r2, { time = 2000, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic })

	local function toCredits()
	gameModesBtn:removeSelf()	
	playBtn:removeSelf()
	creditsBtn:removeSelf()
	w:removeSelf()
	o:removeSelf()
	r:removeSelf()
	d1:removeSelf()
	d2:removeSelf()
	i:removeSelf()
	v:removeSelf()
	e:removeSelf()
	r2:removeSelf()
	audio.fadeOut({ channel=1, time=2000 } )
	audio.stop(playMusic)
	Runtime:removeEventListener("enterFrame", removeOffScreenClouds)
	timer.cancel(cloudMaker)
	timer.cancel(cloudMover)
	for i = 1, #clouds do
		clouds[i]:removeSelf()
	end
	globalGroup:remove()
	director:changeScene("credit")
	end
	

	local function toInstructions()
	gameModesBtn:removeSelf()	
	playBtn:removeSelf()
	creditsBtn:removeSelf()
	w:removeSelf()
	o:removeSelf()
	r:removeSelf()
	d1:removeSelf()
	d2:removeSelf()
	i:removeSelf()
	v:removeSelf()
	e:removeSelf()
	r2:removeSelf()
	audio.fadeOut({ channel=1, time=2000 } )
	audio.stop(playMusic)
	Runtime:removeEventListener("enterFrame", removeOffScreenClouds)
	timer.cancel(cloudMaker)
	timer.cancel(cloudMover)
	for i = 1, #clouds do
		clouds[i]:removeSelf()
	end
	globalGroup:remove()
	director:changeScene("instructions")
	end

	local function ongameModesBtnRelease()
	gameModesBtn:removeSelf()	
	playBtn:removeSelf()
	creditsBtn:removeSelf()
	w:removeSelf()
	o:removeSelf()
	r:removeSelf()
	d1:removeSelf()
	d2:removeSelf()
	i:removeSelf()
	v:removeSelf()
	e:removeSelf()
	r2:removeSelf()
	audio.fadeOut({ channel=1, time=2000 } )
	audio.stop(playMusic)
	Runtime:removeEventListener("enterFrame", removeOffScreenClouds)
	timer.cancel(cloudMaker)
	timer.cancel(cloudMover)
	for i = 1, #clouds do
		clouds[i]:removeSelf()
	end
	globalGroup:remove()
	director:changeScene("game")
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



	-- display a background image
	local background = display.newImageRect( "background.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	
	
	
	-- create a widget button (which will loads level1.lua on release)
	gameModesBtn = widget.newButton{
		label="",
		labelColor = { default={255}, over={128} },
		default="play-button.png",
		over="play-button-press.png",
		width=100, height=100,
		onRelease = ongameModesBtnRelease	
	}
	
	gameModesBtn:setReferencePoint( display.CenterReferencePoint )
	gameModesBtn:toFront()
	gameModesBtn.x = display.contentWidth/2
	gameModesBtn.y = display.contentHeight/2
	globalGroup:insert(gameModesBtn)
	gameModesBtn:toFront()
	
	playBtn = widget.newButton{
		label="",
		labelColor = { default={255}, over={128} },
		default="how-button.png",
		over="how-button-press.png",
		width=100, height=100,
		onRelease = toInstructions	-- event listener function
	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn:toFront()
	playBtn.x = display.contentWidth*0.25
	playBtn.y = 350
	
	globalGroup:insert(playBtn)
	playBtn:toFront()
	
	creditsBtn = widget.newButton{
		label="",
		labelColor = { default={255}, over={128} },
		default="who-button.png",
		over="who-button-press.png",
		width=100, height=100,
		onRelease = toCredits	-- event listener function
	}
	creditsBtn:setReferencePoint( display.CenterReferencePoint )
	creditsBtn:toFront()
	creditsBtn.x = display.contentWidth*0.75
	creditsBtn.y = 350
	
	globalGroup:insert(creditsBtn)
	creditsBtn:toFront()
	
	Runtime:addEventListener("enterFrame", removeOffScreenClouds)

	
	
	
	
	localGroup:insert(background)

	return localGroup
end
	
