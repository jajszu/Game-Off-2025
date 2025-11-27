extends Control
class_name PauseMenu

@onready var settings_menu: SettingsMenu = $SettingsMenu
@onready var buttons_container: VBoxContainer = $ButtonsContainer

func _ready() -> void:
	self.visibility_changed.connect(on_visibility_changed)

func on_visibility_changed():
	if visible:
		settings_menu.visible = false
		buttons_container.visible = true
	else:
		Settings.settings_changed.emit()

func _on_resume_button_pressed() -> void:
	visible = false

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	settings_menu.visible = true
	buttons_container.visible = false
	
func close_settings():
	settings_menu.visible = false
	buttons_container.visible = true
