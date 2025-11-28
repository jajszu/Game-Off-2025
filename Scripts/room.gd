extends Area3D
class_name Room

#region Spawning
@export_range(1, 20) var min_trash_spawn: int = 2
@export_range(1, 20) var max_trash_spawn: int = 6
@export_range(1, 20) var min_mop_spawn: int = 2
@export_range(1, 20) var max_mop_spawn: int = 6
@export var trash_spawn_points: Array[Node3D]
@export var mop_dirt_spawn_points: Array[Node3D]
@export var trash_scenes: Array[PackedScene]
@export var mop_dirt_scenes: Array[PackedScene]
#endregion

#region Tasks
var current_trash: int = 0
var goal_trash: int = 10
var current_mop: int = 0
var goal_mop: int = 10
#endregion

#region Ghost things
@export var light : SpotLight3D
#endregion

func _ready() -> void:
	self.body_entered.connect(on_body_entered)
	spawn_tasks()
	
func on_body_entered(body: Node3D):
	if body is Player:
		body.current_room = self
		body.update_tasks()
	if body is Ghost:
		body.current_room = self
		
func spawn_tasks():
	if max_trash_spawn > trash_spawn_points.size():
		max_trash_spawn = trash_spawn_points.size()
	if max_mop_spawn > mop_dirt_spawn_points.size():
		max_mop_spawn = mop_dirt_spawn_points.size()

	# Trash Spawning
	var trash_count = randi_range(min_trash_spawn, max_trash_spawn)
	var available_trash_points = trash_spawn_points.duplicate()
	available_trash_points.shuffle()
	
	# Ensure we don't try to spawn more than we have points for
	trash_count = min(trash_count, available_trash_points.size())
	
	goal_trash = trash_count
	current_trash = 0
	
	for i in range(trash_count):
		var point = available_trash_points[i]
		if not trash_scenes.is_empty():
			var random_trash_scene = trash_scenes[randi() % trash_scenes.size()]
			var trash_instance = random_trash_scene.instantiate()
			add_child(trash_instance)
			trash_instance.global_position = point.global_position
			trash_instance.global_rotation = point.global_rotation
			
	# Mop Spawning
	var mop_count = randi_range(min_mop_spawn, max_mop_spawn)
	var available_mop_points = mop_dirt_spawn_points.duplicate()
	available_mop_points.shuffle()
	
	mop_count = min(mop_count, available_mop_points.size())
	
	goal_mop = mop_count
	current_mop = 0
	
	for i in range(mop_count):
		var point = available_mop_points[i]
		if not mop_dirt_scenes.is_empty():
			var random_mop_scene = mop_dirt_scenes[randi() % mop_dirt_scenes.size()]
			var mop_instance = random_mop_scene.instantiate()
			add_child(mop_instance)
			mop_instance.global_position = point.global_position
			mop_instance.global_rotation = point.global_rotation
