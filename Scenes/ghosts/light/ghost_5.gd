extends Ghost


func _process(delta: float) -> void:
	#print("w ",wandering," c ",chasing)
	super(delta)
	if player == null:
		player = Globals.current_map.player
	if Globals.current_map.player.current_room.light.visible:
		wandering = false
		chasing = true
		target == Globals.current_map.player
	else :
		wandering = true
		chasing = false
		if target == player:
			pick_destination()
	
