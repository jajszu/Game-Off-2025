extends Node3D
class_name Map
@export var player_scene: PackedScene
@export var lose_scene: PackedScene
@export var player_spawn_point: Node3D
@export var spawn_room: Room
var player: Player
var rooms_done:int = 0
var rooms_total:int = 0

func _ready() -> void:
	Globals.current_map = self
	spawn_player()
	player.cam.current = true
	Globals.map_loaded.emit()
	player.update_tasks()


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

func game_over(text: String = "you lose"):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var l = lose_scene.instantiate()
	if l is LoseScreen:
		l.label.text = text
	get_parent().add_child(l)
	queue_free()
	
func check_win():
	if rooms_done == rooms_total:
		game_over("You won!")
