extends Ghost

@export var shy = false

func _ready() -> void:
	super()
	SignalBus.saw_ghost.connect(trigger)

func trigger(x):
	print(x)
	if x == shy:
		active = false
		return
	active = true
