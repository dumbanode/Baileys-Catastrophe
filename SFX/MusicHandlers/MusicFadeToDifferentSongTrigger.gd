extends Area2D

export(String) var musicToLoad

func _ready():
	$"Default_Texture".hide()


func _on_MusicFadeOutTrigger_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().call_group("MusicHandler", "FadeToDifferentMusic", musicToLoad)
