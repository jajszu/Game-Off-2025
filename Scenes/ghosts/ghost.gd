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
@export var sound1 : AudioStreamPlayer3D
@export var sound2 : AudioStreamPlayer3D
@export var sound3 : AudioStreamPlayer3D

@export var bg_sound_1 : Array[AudioStream]
@export var bg_sound_2 : Array[AudioStream]
@export var sound_effects : Array[AudioStream]

var is_screaming := false

var waypoints = []
var player : Player = null
var target


func _ready() -> void:
	Globals.current_ghost = self
	waypoints = get_tree().get_nodes_in_group("waypoints")
	player = get_tree().get_first_node_in_group("player")
	pick_destination()
	
	sound1.volume_db = -40
	sound2.volume_db = -40
	sound3.volume_db = -40
	
	sound1.stream = bg_sound_1.pick_random()
	sound1.play(randf_range(0.0,10.0))
	sound2.stream = bg_sound_2.pick_random()
	sound2.play(randf_range(0.0,10.0))

func wander(delta):
	if not agent.is_navigation_finished():
		velocity = (agent.get_next_path_position() - global_position).normalized() * delta * speed * Vector3(1,0,1)
	if global_position.distance_to(target.global_position) < 0.5:
		pick_destination()
		#emiter.restart()
	move_and_slide()
	look_at(global_position + velocity, Vector3.UP)
		
func pick_destination():
	target = waypoints[randi() % waypoints.size()]
	agent.set_target_position(target.global_position)
	

func chase_player(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	if global_position.distance_to(target.global_position) < 1.0:
		kill()
	else:
		if not is_screaming:
			scream()
		target = player
		agent.set_target_position(target.global_position)
		wander(delta)

func scream():
	is_screaming = true
	sound3.stream = sound_effects.pick_random()
	sound3.play()
	await get_tree().create_timer(randf_range(3.0,10.0)).timeout
	is_screaming = false

func kill():
	Globals.current_map.game_over()

func despawn():
	Globals.current_ghost = null

func _process(delta: float) -> void:
	if sound1.volume_db < 0:
		sound1.volume_db += delta * 10
	if sound2.volume_db < 0:
		sound2.volume_db += delta * 10
	if sound3.volume_db < 0:
		sound3.volume_db += delta * 10
	
	if not active:
		animator.stop(true)
		return
	if not animator.is_playing():
		animator.play()
	if wandering:
		wander(delta)
	if chasing:
		chase_player(delta)
