extends Ghost

@export var shy = false

var first_time_seen = false

func _ready() -> void:
	super()
	SignalBus.saw_ghost.connect(trigger)

func _process(delta: float) -> void:
	if not first_time_seen:
		if dist_player_no_y() < 5:
			first_time_seen = true

func trigger(x):
	if not x and not first_time_seen:
		active = true
		return
	first_time_seen = true
	if x == shy :
		active = false
		return
	active = true
