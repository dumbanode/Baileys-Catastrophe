extends ParallaxLayer

func _ready():
	add_to_group("reversibleParallaxLayer")
	
func reverse():
	if motion_scale.x > 0:
		motion_scale.x = -1 * motion_scale.x
		
func standard():
	motion_scale.x = abs(motion_scale.x)
