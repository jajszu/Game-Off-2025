extends StaticBody3D

@export var hide_location: Node3D

func get_interact_text() -> String:
	if Globals.current_map.player.hidden:
		return "[E] stop hiding"
	return "[E] hide"

func interact():
	var sec_cam := Globals.current_map.secondary_camera
	sec_cam.get_parent().remove_child(sec_cam)
	hide_location.add_child(sec_cam)
	sec_cam.pivot = hide_location
	sec_cam.global_position = hide_location.global_position
	sec_cam.global_rotation = hide_location.global_rotation
	sec_cam.current = true
	Globals.current_map.player.hidden = true
	Globals.current_map.player.drop_item()
