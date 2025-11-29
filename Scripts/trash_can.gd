extends StaticBody3D

func get_interact_text() -> String:
	if Globals.current_map.player.inventory.current_item is Trash:
		return "[E] Throw the trash"
	return ""

func interact() -> void:
	var item = Globals.current_map.player.inventory.current_item
	if item is Trash:
		if item.room != null:
			item.room.current_trash += 1
			Globals.current_map.player.update_tasks()
			item.room.check_done()
		Globals.current_map.player.inventory.current_item = null
		item.queue_free()
