extends Camera3D
class_name SecondaryCamera

var pivot: Node3D

func get_input(event: InputEventMouseMotion, mouse_sensitivity: float):
	if pivot == null:
		printerr("no pivot for secondary camera")
		return
	pivot.rotate_y(-event.relative.x * mouse_sensitivity)
	rotate_x(-event.relative.y * mouse_sensitivity)
	rotation_degrees.x = clamp(rotation_degrees.x, -90, 90)
