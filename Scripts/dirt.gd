extends Node
class_name Dirt

@onready var model: Node3D = $model
var hp: int = 3
var current_room: Room

func clean():
	hp -= 1
	var tween := create_tween()
	var new_scale := model.scale * 0.7
	tween.tween_property(model, "scale", new_scale, 1)
	await tween.finished
	if hp <= 0:
		#current_room.current_mop += 1
		queue_free()
