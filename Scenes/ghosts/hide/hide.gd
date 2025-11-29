extends Ghost

@export var normal_speed = 1.0
@export var chasing_speed = 1.0


func _process(delta: float) -> void:
	super(delta)
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	if true:
		wandering = false
		chasing = true
		speed = chasing_speed
		animator.speed_scale = 3
	else:
		if target == player:
			pick_destination()
		speed = normal_speed
		animator.speed_scale = 1.5
		wandering = true
		chasing = false
