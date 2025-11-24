extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var cam: Camera3D = $Camera3D
@onready var ray_cast: RayCast3D = $Camera3D/RayCast
@onready var interact_label: Label = $UI/InteractLabel
@onready var subtitles_label: Label = $UI/SubtitlesLabel
@onready var inventory: Inventory = $Inventory
@export var mouse_sensitivity: float = 0.01

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Settings.settings_changed.connect(_on_settings_changed)

func _on_settings_changed() -> void:
	mouse_sensitivity = Settings.mouse_sensitivity

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		cam.rotate_x(-event.relative.y * mouse_sensitivity)
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)
	elif event.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif event.is_action_pressed("interact"):
		if ray_cast.is_colliding():
			if ray_cast.get_collider().has_method("interact"):
				ray_cast.get_collider().interact(self)


func _physics_process(delta: float) -> void:
	if ray_cast.is_colliding():
		var coll := ray_cast.get_collider()
		if coll.has_method("get_interact_text"):
			var t = coll.get_interact_text()
			if t is String:
				interact_label.text = t
			else:
				printerr("get_interact_text in " + str(coll.get_class()) +
					" does not return a string")
		else:
			interact_label.text = ""
	else:
		interact_label.text = ""

	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
