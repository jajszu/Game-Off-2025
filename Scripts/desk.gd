extends StaticBody3D

@export var hide_location: Node3D

func get_interact_text() -> String:
	if Globals.current_map.player.hidden:
		return "[E] stop hiding"
	elif get_angle_to_player() < 45:
		return "[E] hide"
	
	return ""

func interact():
	if get_angle_to_player() > 40:
		return
	var player = Globals.current_map.player
	player.hidden = true
	#player.drop_item()
	player.set_collision_mask_value(1, false)
	player.position_before_hidden = player.global_position
	player.global_position.y -= 2
	player.axis_lock_linear_y = true
	player.global_position = hide_location.global_position
	
func get_angle_to_player():
		var pos := hide_location.global_position
		pos.y = 0
		var pos_p := Globals.current_map.player.global_position
		pos_p.y = 0
		var dir = (pos_p - pos).normalized()
		var forward = -hide_location.global_basis.z
		return rad_to_deg(acos(forward.dot(dir)))
	
