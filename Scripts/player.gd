extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var cam: Camera3D = $Camera3D
@onready var ray_cast: RayCast3D = $Camera3D/RayCast
@onready var interact_label: Label = $UI/InteractLabel
@onready var subtitles_label: Label = $UI/SubtitlesLabel
@onready var inventory: Inventory = $Inventory
@onready var pause_menu: PauseMenu = $PauseMenu
@onready var mop_label: Label = %MopLabel
@onready var trash_label: Label = %TrashLabel
@export var mouse_sensitivity: float = 0.01
var current_room: Room

func _ready() -> void:
	Settings.settings_changed.connect(_on_settings_changed)
	pause_menu.visibility_changed.connect(on_pause_changed)
	pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func on_pause_changed():
	if pause_menu.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_settings_changed() -> void:
	mouse_sensitivity = Settings.mouse_sensitivity

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): #na to reaguje zawsze
		pause_menu.visible = !pause_menu.visible
	elif pause_menu.visible: #jeżeli pauza aktywna, nie sprawdzaj pozostałych inputów
		return
		
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		cam.rotate_x(-event.relative.y * mouse_sensitivity)
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)
	elif event.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif event.is_action_pressed("interact"):
		if ray_cast.is_colliding():
			if ray_cast.get_collider().has_method("interact"):
				ray_cast.get_collider().interact()
	elif event.is_action_pressed("drop_item"):
		drop_item()

func update_tasks():
	mop_label.text = "Mop up the dirt " + str(current_room.current_mop) \
	+ "/" + str(current_room.goal_mop)
	trash_label.text = "Pick up the trash " + str(current_room.current_trash) \
	+ "/" + str(current_room.goal_trash)

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

func pick_up_item(item: Item):
	item.set_collision_layer_value(4, false)
	item.freeze = true
	item.get_parent().remove_child(item)
	inventory.add_child(item)
	inventory.current_item = item
	item.position = Vector3.ZERO
	item.rotation = Vector3.ZERO

func drop_item():
	if inventory.current_item == null:
		return
	else:
		var item := inventory.current_item
		item.set_collision_layer_value(4, true)
		item.freeze = false
		var pos = item.global_position
		inventory.remove_child(item)
		self.get_parent().add_child(item)
		item.global_position = pos
		inventory.current_item = null
