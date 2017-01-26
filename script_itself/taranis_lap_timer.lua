-- simple lap timer for OpenTX firmware, works with openTX 2.2
-- logical switch 32 is used to trigger lap timer, SH lever is used to reset all timers.
-- By Ihor Suzdaliev a.k.a. Student :D

local function drawPreciseTimer( x, y, val )
	local ti = math.floor( val / 100 )
	local tr = val % 100-- % 100 gives remainder after dividing by 100, can use 60 to get minutes from seconds.
	if tr < 10 then
		tr = '.0' .. tr
	else
		tr = '.' .. tr
	end
	lcd.drawTimer( x, y, ti, DBLSIZE )
	lcd.drawText( lcd.getLastPos(), y, tr, MIDSIZE )
	return 0
end

local function playPreciseTimer( val )
	local minutes = math.floor( val / 6000 )
	local seconds = val % 6000	
	if minutes > 0 then
		playNumber(minutes, 16, 0)
	end
		
	playNumber(seconds/10, 17, PREC1)
	return 0
end

local timeold = getTime()
local timer = 0
local mark = 0
local switch = 'ls32'
local besttime = 999999





local function run()
if getValue('ls30') >0 then
		if getValue(switch)>0 and mark == 0 then
		timer = getTime()-timeold
		timeold = getTime()
		mark = 1
			if timer<besttime then
			besttime = timer
			end
		playPreciseTimer( timer )
		end


		

		if getValue(switch)<0 then
		mark = 0
		end
		
	
end


if getValue('ls31')>0 then  
			timer = 0
			besttime = 999999
end
		lcd.clear()
		lcd.drawText(5, 50, "RSSI:", 0)
		lcd.drawText(31, 50, getRSSI(), 0)
			
			if getValue('ls31')>0 then
				lcd.drawText(50, 50, "*RESET*", 0)
				else
				lcd.drawText(50, 50, "       ", 0)
			end
		
			lcd.drawText(5, 40, "Lap timing state:", 0)
			if getValue('ls30')>0 then
				lcd.drawText(93, 40, "ON", 0)
			else
				lcd.drawText(93, 40, "OFF", 0)
			end
		
		lcd.drawText( 119, 5, "Last lap time", 0)
		drawPreciseTimer( 119, 15, timer )


		lcd.drawText( 10, 5, "Best lap time", 0)
		drawPreciseTimer( 10, 15, besttime )


		lcd.drawText( 119, 35, "Current lap time", 0)
		drawPreciseTimer( 119, 45, getTime()-timeold )
		

return 0
end


return { run=run }
