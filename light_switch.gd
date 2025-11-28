extends StaticBody3D

@export var lights: Array[Light3D]

func _ready() -> void:
	for l in lights:
		l.light_energy = 5

func get_interact_text() -> String:
	return "[E] toggle light"

func interact():
	$Sound.play()
	$lightswitch.rotate_x(deg_to_rad(180))
	for l in lights:
		if l.light_energy == 0:
			l.light_energy = 5
		else:
			l.light_energy = 0
	
