extends StaticBody3D

@export var lights: Array[Light3D]

func _ready() -> void:
	for l in lights:
		l.light_energy = 12

func _process(delta: float) -> void:
	if Globals.current_ghost != null:
		if not flicker_in_progress:
			flicker_lights()
	else:
		for l in lights:
			l.light_energy = 12


var flicker_in_progress := false

func flicker_lights() -> void:
	flicker_in_progress = true
	for l in lights:
		l.light_energy = 5
		await get_tree().create_timer(randf_range(0.2,0.4)).timeout
	flicker_in_progress = false


func get_interact_text() -> String:
	return "[E] toggle light"

func interact():
	$Sound.play()
	$lightswitch.rotate_x(deg_to_rad(180))
	for l in lights:
		l.visible = !l.visible
	
