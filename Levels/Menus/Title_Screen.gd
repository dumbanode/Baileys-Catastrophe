extends Control



func _on_StartGameButton_pressed():
	get_tree().change_scene("res://Levels/Menus/How_To_Play.tscn")


func _on_QuitGameButton_pressed():
	get_tree().quit()
