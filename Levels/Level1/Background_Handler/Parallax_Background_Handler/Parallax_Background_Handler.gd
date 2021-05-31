extends ParallaxBackground

func _ready():
	add_to_group("Parallax_Background_Handler")


func reverseLayersBehind3D():
	get_tree().call_group("reversibleParallaxLayer", "reverse")
	
func setLayersBehind3DPositive():
	get_tree().call_group("reversibleParallaxLayer", "standard")
