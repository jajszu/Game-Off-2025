extends StaticBody3D

@export var hide_location: Node3D

func get_interact_text() -> String:
	if Globals.current_map.player.hidden:
		return "[E] stop hiding"
	elif get_angle_to_player() < 40:
		return "[E] hide"
	
	return ""

func interact():
	if get_angle_to_player() > 40:
		return
	var sec_cam := Globals.current_map.secondary_camera
	sec_cam.get_parent().remove_child(sec_cam)
	hide_location.add_child(sec_cam)
	sec_cam.pivot = hide_location
	sec_cam.global_position = hide_location.global_position
	sec_cam.global_rotation = hide_location.global_rotation
	sec_cam.current = true
	Globals.current_map.player.hidden = true
	Globals.current_map.player.drop_item()
	
func get_angle_to_player():
		var pos := hide_location.global_position
		pos.y = 0
		var pos_p := Globals.current_map.player.global_position
		pos_p.y = 0
		var dir = (pos_p - pos).normalized()
		var forward = -hide_location.global_basis.z
		return rad_to_deg(acos(forward.dot(dir)))
	
