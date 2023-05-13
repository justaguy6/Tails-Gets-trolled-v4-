function addZoom(how)
	setProperty("camZooming", true)
	setProperty("camGame.zoom", getProperty("camGame.zoom") + how)
end

function onStepHit()	
	if curStep < 63 then
		if curStep > 54 and curStep % 2 == 0 then
			addZoom(curStep > 58 and 0.015 or 0.01)
		end
	else
		onStepHit = nil
	end
end