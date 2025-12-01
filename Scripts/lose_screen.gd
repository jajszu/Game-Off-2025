extends Control
class_name LoseScreen

@onready var label: Label = $Label

func _ready() -> void:
	var p = get_parent()
	if p is Game:
		p.bg_music.play()

func _on_restart_button_pressed() -> void:
	var p = get_parent()
	if p.has_method("start_map"):
		p.start_map()
		queue_free()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
