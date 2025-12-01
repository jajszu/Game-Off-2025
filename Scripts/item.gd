extends RigidBody3D
class_name Item

func get_interact_text() -> String:
	if !Globals.current_map.player.inventory.is_empty():
		return ""
	return "[E] pick up"

func interact():
	if Globals.current_map.player.inventory.is_empty():
		Globals.current_map.player.pick_up_item(self)
		
func _physics_process(delta: float) -> void:
	if global_position.y < -1:
		self.global_position = Globals.current_map.player.global_position
