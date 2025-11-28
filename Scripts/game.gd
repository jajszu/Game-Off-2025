extends Node3D

@export var map_scene: PackedScene
@onready var main_menu: Control = $MainMenu
@onready var v_box_container: VBoxContainer = $MainMenu/VBoxContainer
@onready var settings_menu: SettingsMenu = $MainMenu/SettingsMenu

func _ready() -> void:
	settings_menu.visible = false
	v_box_container.visible = true

func _on_start_button_pressed() -> void:
	var m = map_scene.instantiate()
	add_child(m)
	main_menu.visible = false
	$BgMusic.stop()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	settings_menu.visible = true
	v_box_container.visible = false
	
