extends Area3D
class_name Room

#region Spawning
@export_range(1, 20) var min_trash_spawn: int = 2
@export_range(1, 20) var max_trash_spawn: int = 6
@export_range(1, 20) var min_mop_spawn: int = 2
@export_range(1, 20) var max_mop_spawn: int = 6
@export var trash_spawn_points: Array[Node3D]
@export var mop_dirt_spawn_points: Array[Node3D]
#endregion

#region Tasks
var current_trash: int = 0
var goal_trash: int = 10
var current_mop: int = 0
var goal_mop: int = 10
#endregion

func _ready() -> void:
	self.body_entered.connect(on_body_entered)
	spawn_tasks()
	
func on_body_entered(body: Node3D):
	if body is Player:
		body.current_room = self
		body.update_tasks()
		
func spawn_tasks():
	#TODO spawn tasks
	printerr("Spawning tasks not implemented")
		
