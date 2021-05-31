extends Area2D

export(String) var directory
export(String) var levelToLoad

func _ready():
	$"Default_Texture".hide()


func _on_LevelTransitionTrigger_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().change_scene("res://Levels/" + directory + "/" + levelToLoad + ".tscn")
