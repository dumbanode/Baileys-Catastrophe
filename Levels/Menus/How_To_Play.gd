extends Control



func _on_StartButton_pressed():
	get_tree().change_scene("res://Levels/Intro/Intro.tscn")


func _on_skipButton_pressed():
	get_tree().change_scene("res://Levels/Level1/Level1.tscn")
