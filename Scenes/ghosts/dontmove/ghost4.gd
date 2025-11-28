extends Ghost

@export var chasing_speed = 1

func  _ready() -> void:
	super()
	SignalBus.player_moved.connect(trigger)

func trigger():
	chasing = true
	wandering = false
	speed = chasing_speed
	animator.speed_scale = 8
