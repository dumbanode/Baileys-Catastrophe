extends Area2D

func _ready():
	$"Default_Texture".hide()


func _on_Rotate_Trigger_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().call_group("Background_Handler", "set_Rotate", true)
		get_tree().call_group("Background_Handler", "set_Translate", false)
		get_tree().call_group("reversibleParallaxLayer", "reverse")
