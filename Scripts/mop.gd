extends Item
class_name Mop
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func use():
	animation_player.play("use")
	
func clean():
	var p := Globals.current_map.player
	if p.ray_cast.is_colliding():
		var coll := p.ray_cast.get_collider()
		print(coll.get_class())

		if coll is Dirt:
			coll.clean()
