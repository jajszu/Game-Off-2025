extends Control
class_name LoadingScene

signal finished



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "default":
		finished.emit()
