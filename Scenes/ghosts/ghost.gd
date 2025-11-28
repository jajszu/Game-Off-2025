extends CharacterBody3D

class_name Ghost


#ghost1 - patrz / nie patrz
#ghost 2 - floor is lava
#ghost3 - schowaj sie
#ghost 4 - nie ruszaj sie
#ghost 5 - swiatlo

@export var active = false
@export var speed = 1.0
@export var wandering = false
@export var chasing = false

@export var agent : NavigationAgent3D
@export var emiter : GPUParticles3D
@export var animator : AnimationPlayer

var waypoints = []
var player = null
var target


func _ready() -> void:
	Globals.current_ghost = self
	waypoints = get_tree().get_nodes_in_group("waypoints")
	player = get_tree().get_first_node_in_group("player")
	pick_destination()

func wander(delta):
	if not agent.is_navigation_finished():
		velocity = (agent.get_next_path_position() - global_position).normalized() * delta * speed * Vector3(1,0,1)
	if global_position.distance_to(target.global_position) < 0.5:
		pick_destination()
		emiter.restart()
	move_and_slide()
	look_at(global_position + velocity, Vector3.UP)
		
func pick_destination():
	target = waypoints[randi() % waypoints.size()]
	agent.set_target_position(target.global_position)
	

func chase_player(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	if global_position.distance_to(target.global_position) < 0.5:
		kill()
	else:
		target = player
		agent.set_target_position(target.global_position)
		wander(delta)

func kill():
	print("gameover")
	pass

func despawn():
	Globals.current_ghost = null

func _process(delta: float) -> void:
	if not active:
		animator.stop(true)
		return
	if not animator.is_playing():
		animator.play()
	if wandering:
		wander(delta)
	if chasing:
		chase_player(delta)
