extends Node3D
class_name Map
@export var player_scene: PackedScene
@export var player_spawn_point: Node3D
var player: Player

func _ready() -> void:
	Globals.current_map = self
	spawn_player()


func spawn_player():
	var p = player_scene.instantiate()
	if p is Player:
		player = p
		add_child(player)
		player.global_position = player_spawn_point.global_position
	else:
		printerr("player scene is not a player class!")
		p.queue_free()
		return
