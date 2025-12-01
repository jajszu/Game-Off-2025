extends Node3D
class_name Game

@export var map_scene: PackedScene
@export var loading_scene: PackedScene
@onready var main_menu: Control = $MainMenu
@onready var v_box_container: VBoxContainer = $MainMenu/VBoxContainer
@onready var settings_menu: SettingsMenu = $MainMenu/SettingsMenu
@onready var bg_music: AudioStreamPlayer = $BgMusic

var can_skip:bool = false

var loading_node: LoadingScene

func _input(event: InputEvent) -> void:
	if can_skip:
		if event is InputEventMouseButton or event is InputEventKey:
			can_skip = false
			start_map()
			

func _ready() -> void:
	settings_menu.visible = false
	v_box_container.visible = true

func _on_start_button_pressed() -> void:
	var l = loading_scene.instantiate()
	add_child(l)
	if l is LoadingScene:
		l.finished.connect(func(): can_skip = true, CONNECT_ONE_SHOT)
		loading_node = l
	main_menu.visible = false
	$MainMenuMap.queue_free()


func start_map():
	var m = map_scene.instantiate()
	add_child(m)
	bg_music.stop()
	if loading_node != null:
		loading_node.queue_free()

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	settings_menu.visible = true
	v_box_container.visible = false
	
