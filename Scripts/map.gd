extends Node3D
class_name Map
@export var player_scene: PackedScene
@export var lose_scene: PackedScene
@export var player_spawn_point: Node3D
@export var spawn_room: Room
var player: Player

func _ready() -> void:
	Globals.current_map = self
	spawn_player()
	player.cam.current = true


func spawn_player():
	var p = player_scene.instantiate()
	if p is Player:
		player = p
		add_child(player)
		player.global_position = player_spawn_point.global_position
		player.current_room = spawn_room
		player.update_tasks()
	else:
		printerr("player scene is not a player class!")
		p.queue_free()
		return

func game_over():
	print("game over")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var l = lose_scene.instantiate()
	get_parent().add_child(l)
	queue_free()
