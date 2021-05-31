extends Control

export(String) var nextDirectory
export(String) var nextScene

func _process(delta):
	if Input.is_action_pressed("pause") or not $VideoPlayer.is_playing():
		get_tree().change_scene("res://Levels/" + nextDirectory + "/" + nextScene + ".tscn")
