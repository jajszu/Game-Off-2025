extends SpotLight3D


func _process(delta: float) -> void:
	$OmniLight3D.light_energy = light_energy
