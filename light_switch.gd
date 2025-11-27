extends StaticBody3D

@export var lights: Array[Light3D]

func get_interact_text() -> String:
	return "[E] toggle light"

func interact():
	$Sound.play()
	for l in lights:
		if l.light_energy == 0:
			l.light_energy = 1
		else:
			l.light_energy = 0
	
