extends SpotLight3D

@onready var omni_light_3d: OmniLight3D = $OmniLight3D

func _process(delta: float) -> void:
	if omni_light_3d.light_energy != light_energy:
		omni_light_3d.light_energy = light_energy
