extends Area2D

func _ready():
	$"Default_Texture".hide()

func _on_Background_Translate_Trigger_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().call_group("Background_Handler", "set_Rotate", false)
		get_tree().call_group("Background_Handler", "set_Translate", true)
