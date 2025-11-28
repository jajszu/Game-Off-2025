extends Ghost


func _process(delta: float) -> void:
	print(current_room)
	if current_room != null:
		if current_room.light.light_energy == 0:
			active = false
			return
	active = true
