
# Målkoordinater (t.ex. Brandparken)
targetLat = 59.266338
targetLon = 18.131969

previousPosition = null

toRadians = (deg) -> deg * Math.PI / 180
toDegrees = (rad) -> rad * 180 / Math.PI

messages = []

dump = (msg) ->
	messages.unshift msg
	if messages.length > 20 then messages.pop()
	document.getElementById('debug').innerText = messages.join "\n"

calculateBearing = (lat1, lon1, lat2, lon2) ->
	φ1 = toRadians lat1
	φ2 = toRadians lat2
	Δλ = toRadians lon2 - lon1
	y = Math.sin(Δλ) * Math.cos(φ2)
	x = Math.cos(φ1) * Math.sin(φ2) - Math.sin(φ1) * Math.cos(φ2) * Math.cos(Δλ)
	(toDegrees(Math.atan2(y, x)) + 360) % 360

updateArrow = (bearingToTarget) ->
	arrow = document.getElementById('arrow')
	arrow.style.transform = "rotate(#{bearingToTarget}deg)"

f = (position) ->
	{latitude, longitude} = position.coords

	if previousPosition?
		movementBearing = calculateBearing previousPosition.latitude, previousPosition.longitude, latitude, longitude
		targetBearing = calculateBearing latitude, longitude, targetLat, targetLon
		relativeBearing = (targetBearing - movementBearing + 360) % 360
		updateArrow relativeBearing
		dump "M:#{Math.round(movementBearing)}° T:#{Math.round(targetBearing)}° R:#{Math.round(relativeBearing)}°"

	previousPosition =
		latitude: latitude
		longitude: longitude

watchError = (error) -> dump "Kunde inte hämta GPS-position #{error}"

navigator.geolocation.watchPosition f,	watchError, {enableHighAccuracy: true, maximumAge: 1000, timeout: 5000}

