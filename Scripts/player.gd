extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 6.0

@onready var cam: Camera3D = $Camera3D
@onready var ray_cast: RayCast3D = $Camera3D/RayCast
@onready var interact_label: Label = $UI/InteractLabel
@onready var subtitles_label: Label = $UI/SubtitlesLabel
@onready var inventory: Inventory = $Camera3D/Inventory
@onready var pause_menu: PauseMenu = $PauseMenu
@onready var mop_label: Label = %MopLabel
@onready var trash_label: Label = %TrashLabel
@onready var room_count_label: Label = %RoomCountLabel
@onready var room_label: Label = %RoomLabel
@onready var tasks: Control = $UI/Tasks
@onready var drop_item_label: Label = $UI/DropItemLabel
@export var mouse_sensitivity: float = 0.01
var position_before_hidden: Vector3
var current_room: Room
var hidden:bool = false

func _ready() -> void:
	Settings.settings_changed.connect(_on_settings_changed)
	pause_menu.visibility_changed.connect(on_pause_changed)
	_on_settings_changed() #sync values at start
	pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	subtitles_label.text = ""
	tasks.visible = false
	drop_item_label.visible = false

func on_pause_changed():
	if pause_menu.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_settings_changed() -> void:
	mouse_sensitivity = Settings.mouse_sensitivity

func _input(event: InputEvent) -> void:
	SignalBus.player_moved.emit()
	if event.is_action_pressed("ui_cancel"): #na to reaguje zawsze
		pause_menu.visible = !pause_menu.visible
	elif pause_menu.visible: #jeżeli pauza aktywna, nie sprawdzaj pozostałych inputów
		return

	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		cam.rotate_x(-event.relative.y * mouse_sensitivity)
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90, 90)
		
	if hidden:
		if event.is_action_pressed("interact"):
			hidden = false
			global_position = position_before_hidden
			set_collision_mask_value(1, true)
			axis_lock_linear_y = false
		return
	
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif event.is_action_pressed("interact"):
		if ray_cast.is_colliding():
			if ray_cast.get_collider().has_method("interact"):
				ray_cast.get_collider().interact()
	elif event.is_action_pressed("drop_item"):
		drop_item()

func update_tasks():
	tasks.visible = true
	var no_mop := current_room.goal_mop == 0
	var no_trash := current_room.goal_trash == 0
	if no_mop and no_trash:
		room_label.visible = false
	mop_label.visible = !no_mop
	trash_label.visible = !no_trash

	#set text
	room_count_label.text = "Rooms done: " + str(Globals.rooms_done) \
	+ "/" + str(Globals.rooms_total)
	mop_label.text = "Mop up the dirt " + str(current_room.current_mop) \
	+ "/" + str(current_room.goal_mop)
	trash_label.text = "Pick up the trash " + str(current_room.current_trash) \
	+ "/" + str(current_room.goal_trash)


func _physics_process(delta: float) -> void:
	ghost_visible_to_camera()
	#region raycast
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
	#endregion
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if hidden:
		input_dir = Vector2.ZERO
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
	drop_item_label.visible = true

func drop_item():
	if inventory.current_item == null:
		return
	else:
		var item := inventory.current_item
		item.set_collision_layer_value(4, true)
		item.freeze = false
		var pos := item.global_position
		var rot := item.global_rotation
		inventory.remove_child(item)
		self.get_parent().add_child(item)
		item.global_position = pos
		item.global_rotation = rot
		inventory.current_item = null
		drop_item_label.visible = false


func ghost_visible_to_camera() -> void:
	if Globals.current_ghost == null:
		SignalBus.saw_ghost.emit(false)
		return
	if not cam.is_position_in_frustum(Globals.current_ghost.global_position):
		SignalBus.saw_ghost.emit(false)
		return
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(cam.global_position, Globals.current_ghost.global_position)
	query.collision_mask = 1
	var result = space.intersect_ray(query)
	if result and result.collider != Globals.current_ghost:
		SignalBus.saw_ghost.emit(false)
		return
	SignalBus.saw_ghost.emit(true)
