extends Control
class_name SettingsMenu

var master_bus_idx = AudioServer.get_bus_index("Master")

func _ready() -> void:
	$VBoxContainer/HBoxContainer2/SensSlider.value = Settings.mouse_sensitivity * 100

func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(master_bus_idx, value)	

func _on_sens_slider_value_changed(value: float) -> void:
	Settings.mouse_sensitivity = value / 100

func _on_save_button_pressed() -> void:
	Settings.settings_changed.emit()
	var p = get_parent()
	if p.has_method("close_settings"):
		p.close_settings()
		
