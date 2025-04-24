requestPermission = ->
	if typeof DeviceOrientationEvent?.requestPermission is 'function'
		DeviceOrientationEvent.requestPermission().then (response) ->
			if response is 'granted'
				startCompass()
			else
				document.getElementById('output').innerText = "Tillgång nekades."
	else
		startCompass()

startCompass = ->
	window.addEventListener 'deviceorientation', (event) ->
		alpha = event?.webkitCompassHeading ? event?.alpha
		if alpha?
			document.getElementById('output').innerText = "Kompassriktning: #{Math.round(alpha)}°"
		else	
			document.getElementById('output').innerText = "Ingenkompassdata tillgängling"

document.getElementById('startBtn').addEventListener 'click', -> requestPermission()
